#!/usr/bin/env bash
# Usage: export.sh <release|docs> <output-dir>
#
# Finds every KiCad project (*.kicad_pro) in the repo and exports it.
#   release: schematic PDF, buying BOM, user BOM, layout PDF, STEP, gerbers zip per board
#   docs:    schematic PDF and PcbDraw SVGs per board
#
# Settings (environment variables):
#   MFR_FIELD       symbol field holding the manufacturer part number (default "Mfr. No")
#   STRICT          1 = fail when a part has no part number, 0 = only warn (default 1)
#   USER_GROUP_BY   how the user BOM merges rows (default "Value,Description")
#
# Skipped folders: archive/, .history/, *-backups/
set -u

MODE=${1:?mode: release or docs}
OUT=${2:?output directory}
MFR_FIELD=${MFR_FIELD:-Mfr. No}
STRICT=${STRICT:-1}
USER_GROUP_BY=${USER_GROUP_BY:-Value,Description}

HERE=$(cd "$(dirname "$0")" && pwd)
TOOLS="$HERE/bom_tools.py"
mkdir -p "$OUT"
OUT=$(cd "$OUT" && pwd)
STATUS=0
FOUND=0

while IFS= read -r PRO <&3; do
  DIR=$(dirname "$PRO")
  NAME=$(basename "$PRO" .kicad_pro)
  SCH="$DIR/$NAME.kicad_sch"
  SLUG=$(echo "${DIR#./}" | sed 's#/kicad$##; s#/#_#g')
  [ "$SLUG" = "." ] && SLUG=$NAME

  echo "=== $SLUG ($PRO) ==="
  if [ ! -f "$SCH" ]; then
    echo "No $SCH, skipping"
    continue
  fi
  FOUND=$((FOUND + 1))

  # Release files share one folder, so their names get a prefix.
  # Docs go into one subfolder per project.
  if [ "$MODE" = release ]; then
    DEST="$OUT"; PFX="$SLUG-"
  else
    DEST="$OUT/$SLUG"; PFX=""
  fi
  mkdir -p "$DEST"

  kicad-cli sch export pdf -o "$DEST/${PFX}schematic.pdf" "$SCH" || STATUS=1

  if [ "$MODE" = release ]; then
    TMP=$(mktemp -d)

    # Table of every reference and its part number, to find parts that lack one
    kicad-cli sch export bom -o "$TMP/debug.csv" \
      --fields "Reference,$MFR_FIELD" \
      --labels "Reference,$MFR_FIELD" \
      --group-by 'Reference' \
      "$SCH" || STATUS=1
    if [ -f "$TMP/debug.csv" ]; then
      echo "::group::Reference / $MFR_FIELD table for $SLUG"
      cat "$TMP/debug.csv"
      echo "::endgroup::"
      if ! MSG=$(python3 "$TOOLS" missing "$TMP/debug.csv" "$MFR_FIELD"); then
        if [ "$STRICT" = 1 ]; then
          echo "::error::$SLUG: $MSG"; STATUS=1
        else
          echo "::warning::$SLUG: $MSG"
        fi
      fi
    fi

    # Buying BOM: part number and quantity, built from the reference table above.
    # A part without a part number is listed as "MISSING <reference>" at the top.
    # Off-board parts (screws, transformer, fuses...) from extras.csv are merged in.
    BUY="$DEST/${PFX}bom-buy.csv"
    EXTRAS=""
    for X in "$DIR/../bom/extras.csv" "$DIR/bom/extras.csv"; do
      [ -f "$X" ] && EXTRAS="$X"
    done
    if [ -f "$TMP/debug.csv" ]; then
      python3 "$TOOLS" buy "$TMP/debug.csv" "$BUY" "$MFR_FIELD" $EXTRAS \
        || { echo "::error::$SLUG: could not build the buying BOM"; STATUS=1; }
    fi
    rm -rf "$TMP"

    # User BOM: reference, value, description
    kicad-cli sch export bom -o "$DEST/${PFX}bom-user.csv" \
      --fields 'Reference,Value,Description' \
      --labels 'Reference,Value,Description' \
      --group-by "$USER_GROUP_BY" \
      --sort-field 'Reference' \
      --ref-delimiter ', ' \
      --ref-range-delimiter '' \
      "$SCH" || STATUS=1
  fi

  # Every board file in the project folder
  for PCB in "$DIR"/*.kicad_pcb; do
    [ -f "$PCB" ] || continue
    B=$(basename "$PCB" .kicad_pcb)
    if [ "$MODE" = release ]; then
      G=$(mktemp -d)
      kicad-cli pcb export gerbers -o "$G/" "$PCB" || STATUS=1
      kicad-cli pcb export drill -o "$G/" "$PCB" || STATUS=1
      (cd "$G" && zip -qr "$DEST/${PFX}${B}-gerbers.zip" .) || STATUS=1
      rm -rf "$G"
      # Optional extras: a failure here only prints a warning
      kicad-cli pcb export pdf -l "F.Cu,B.Cu,F.Silkscreen,B.Silkscreen,Edge.Cuts" \
        --mode-multipage -o "$DEST/${PFX}${B}-layout.pdf" "$PCB" \
        || echo "::warning::layout PDF skipped for $PCB"
      kicad-cli pcb export step --subst-models -o "$DEST/${PFX}${B}.step" "$PCB" \
        || echo "::warning::STEP export skipped for $PCB"
    else
      if command -v pcbdraw >/dev/null 2>&1; then
        pcbdraw plot "$PCB" "$DEST/$B-top.svg" \
          || echo "::warning::PcbDraw skipped for $PCB (needs a closed outline on Edge.Cuts)"
        pcbdraw plot --side back "$PCB" "$DEST/$B-bottom.svg" || true
      else
        echo "::warning::pcbdraw is not installed, skipping board drawings"
      fi
    fi
  done
done 3< <(find . -name '*.kicad_pro' \
  -not -path './.git/*' -not -path '*/.history/*' \
  -not -path '*-backups/*' -not -path '*/archive/*' | sort)

[ "$FOUND" = 0 ] && echo "::warning::No KiCad project found (looked for NAME.kicad_pro next to NAME.kicad_sch)"
exit $STATUS
