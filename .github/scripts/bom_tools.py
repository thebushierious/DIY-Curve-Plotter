#!/usr/bin/env python3
"""BOM helpers used by export.sh.

  bom_tools.py missing <debug.csv> <field>      list references whose <field> is empty (exit 1 if any)
  bom_tools.py buy <refs.csv> <bom-buy.csv> <field> [extras.csv]
        build the buying BOM from a one-row-per-reference table; parts without
        <field> are listed as "MISSING <reference>"; extras.csv is merged in
"""
import csv
import re
import sys


def read(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        return list(csv.reader(f))


def write(path, rows):
    with open(path, "w", newline="", encoding="utf-8") as f:
        csv.writer(f, quoting=csv.QUOTE_ALL, lineterminator="\n").writerows(rows)


def to_int(text, where):
    try:
        return int(float(text.strip()))
    except ValueError:
        sys.exit(f"{where}: quantity '{text}' is not a number")


def cmd_missing(path, field):
    rows = read(path)
    head, body = rows[0], rows[1:]
    if field not in head:
        sys.exit(f"Field '{field}' not found in the BOM export (columns: {', '.join(head)})")
    i = head.index(field)
    bad = [r[0].strip() for r in body if len(r) <= i or not r[i].strip()]
    if bad:
        print(f"Parts without '{field}': " + ", ".join(bad))
        sys.exit(1)


def read_extras(path):
    with open(path, "rb") as f:
        raw = f.read()
    if raw[:2] == b"PK" or b"\x00" in raw[:2048]:
        sys.exit(
            f"{path} is not a CSV text file (it looks like an Excel file renamed to .csv). "
            "Open it in Excel and use File > Save As > CSV UTF-8."
        )
    rows = list(csv.reader(raw.decode("utf-8-sig").splitlines()))
    rows = [r for r in rows if any(c.strip() for c in r)]
    has_header = bool(rows) and not (len(rows[0]) > 1 and rows[0][1].strip().isdigit())
    if has_header:
        rows = rows[1:]
    out = []
    for n, r in enumerate(rows, start=2):
        if len(r) < 2:
            sys.exit(f"{path} line {n}: expected 2 columns (part number, quantity)")
        out.append((r[0].strip(), to_int(r[1], f"{path} line {n}")))
    return out


def natural(ref):
    return [int(p) if p.isdigit() else p for p in re.split(r"(\d+)", ref)]


def cmd_buy(refs_path, out_path, field, extras=None):
    """Build the buying BOM from a one-row-per-reference table (Reference, <field>)."""
    rows = read(refs_path)
    head, body = rows[0], rows[1:]
    if field not in head:
        sys.exit(f"Field '{field}' not found in the BOM export (columns: {', '.join(head)})")
    i = head.index(field)
    totals, missing = {}, []
    for r in body:
        ref = r[0].strip()
        mfr = r[i].strip() if len(r) > i else ""
        if mfr:
            totals[mfr] = totals.get(mfr, 0) + 1
        else:
            missing.append(ref)
    if extras:
        for key, qty in read_extras(extras):
            totals[key] = totals.get(key, 0) + qty
    out = [["Manufacturer Part Number", "Quantity"]]
    out += [[f"MISSING {ref}", "1"] for ref in sorted(missing, key=natural)]
    out += [[k, str(v)] for k, v in sorted(totals.items())]
    write(out_path, out)


if __name__ == "__main__":
    args = sys.argv[1:]
    if len(args) >= 3 and args[0] == "missing":
        cmd_missing(args[1], args[2])
    elif len(args) in (4, 5) and args[0] == "buy":
        cmd_buy(args[1], args[2], args[3], args[4] if len(args) == 5 else None)
    else:
        sys.exit(__doc__)
