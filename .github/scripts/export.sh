#!/usr/bin/env bash
# Usage: export.sh <release|docs> <output-dir>
set -u
MODE=${1:?mode: release or docs}
OUT=${2:?output dir}
MFR_FIELD=${MFR_FIELD:-Mfr. No}
STRICT=${STRICT:-1}
STATUS=0
mkdir -p "$OUT"

while IFS= read -r PRO; do
  DIR=$(dirname "$PRO")
  NAME=$(basename "$PRO" .kicad_pro)
  REL=${DIR#./}
  [ "$REL" = "." ] && REL=$NAME
  SLUG=$(echo "$REL" | sed 's#/kicad$##; s#/#_#g')
  SCH="$DIR/$NAME.kicad_sch"

  echo "=== $SLUG ($PRO) ==="
  if [ ! -f "$SCH" ]; then
    echo "No $SCH, skipping"
    continue
  fi

  # Release files must have unique names (flat); docs go into a subfolder per project
  if [ "$MODE" = release ]; then
    DEST="$OUT"; PFX="$SLUG-"
  else
    DEST="$OUT/$SLUG"; PFX=""
  fi
  mkdir -p "$DEST"

  kicad-cli sch export pdf -o "$DEST/${PFX}schematic.pdf" "$SCH" || STATUS=1

  if [ "$MODE" = release ]; then
    # Debug table: one row per reference, to find parts without a part number
    kicad-cli sch export bom -o "$OUT/debug.csv" \
      --fields "Reference,$MFR_FIELD" \
      --labels "Reference,$MFR_FIELD" \
      --group-by 'Reference' \
      "$SCH" || STATUS=1
    echo "::group::Reference / $MFR_FIELD table for $SLUG"
    cat "$OUT/debug.csv"
    echo "::endgroup::"
    python3 - "$OUT/debug.csv" "$MFR_FIELD" <<'PY' || { [ "$STRICT" = 1 ] && STATUS=1; }
import csv, sys
rows = list(csv.reader(open(sys.argv[1], newline="")))
head, body = rows[0], rows[1:]
i = head.index(sys.argv[2])
bad = [r[0] for r in body if len(r) <= i or not r[i].strip()]
if bad:
    print("::error::Parts without " + sys.argv[2] + ": " + ", ".join(bad))
    sys.exit(1)
PY
    rm -f "$OUT/debug.csv"

    # Buying BOM: part number + quantity
    kicad-cli sch export bom -o "$DEST/${PFX}bom-buy.csv" \
      --fields "$MFR_FIELD"',${QUANTITY}' \
      --labels 'Manufacturer Part Number,Quantity' \
      --group-by "$MFR_FIELD" \
      --sort-field "$MFR_FIELD" \
      "$SCH" || STATUS=1

    # User BOM: reference, value, description, merged by value + description
    kicad-cli sch export bom -o "$DEST/${PFX}bom-user.csv" \
      --fields 'Reference,Value,Description' \
      --labels 'Reference,Value,Description' \
      --group-by 'Value,Description' \
      --sort-field 'Reference' \
      --ref-delimiter ', ' \
      --ref-range-delimiter '' \
      "$SCH" || STATUS=1

    # Off-board parts
    for X in "$DIR/../bom/extras.csv" "$DIR/bom/extras.csv"; do
      if [ -f "$X" ]; then
        sed -i -e '$a\' "$DEST/${PFX}bom-buy.csv"
        tail -n +2 "$X" >> "$DEST/${PFX}bom-buy.csv"
      fi
    done
  fi

  # Every board file in the project folder
  for PCB in "$DIR"/*.kicad_pcb; do
    [ -f "$PCB" ] || continue
    B=$(basename "$PCB" .kicad_pcb)
    if [ "$MODE" = release ]; then
      G=$(mktemp -d)
      kicad-cli pcb export gerbers -o "$G/" "$PCB" || STATUS=1
      kicad-cli pcb export drill -o "$G/" "$PCB" || STATUS=1
      (cd "$G" && zip -qr "$OLDPWD/$DEST/${PFX}${B}-gerbers.zip" .)
      rm -rf "$G"
    else
      pcbdraw plot "$PCB" "$DEST/$B-top.svg" || echo "PcbDraw skipped for $PCB"
      pcbdraw plot --side back "$PCB" "$DEST/$B-bottom.svg" || true
    fi
  done
done < <(find . -name '*.kicad_pro' \
  -not -path './.git/*' -not -path '*/.history/*' \
  -not -path '*-backups/*' -not -path '*/archive/*' | sort)

exit $STATUS