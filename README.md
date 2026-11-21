# PROJECT_NAME

[![Release](https://img.shields.io/github/v/release/OWNER/REPO)](https://github.com/OWNER/REPO/releases)
[![Release build](https://github.com/OWNER/REPO/actions/workflows/release.yml/badge.svg)](https://github.com/OWNER/REPO/actions/workflows/release.yml)
![KiCad](https://img.shields.io/badge/KiCad-10.0-blue?logo=kicad)
![Status](https://img.shields.io/badge/status-in%20progress-yellow)

One sentence: what it is and what it does.

<!-- ![Hero image](docs/images/hero.jpg) -->

## Features

- Feature 1 (with numbers: range, accuracy, power)
- Feature 2

## How it works

<!-- ![Block diagram](docs/diagrams/block-diagram.svg) -->

Two or three sentences, then a link to the [theory of operation](docs/theory-of-operation.md).

## Status

| Revision | Status | Notes |
|---|---|---|
| [v1](hardware/v1) | in progress | |

## Schematic and board

<!-- Uncomment after the Docs workflow has run once (folder names come from your KiCad project path):

[Schematic (PDF)](docs/generated/hardware_v1/schematic.pdf)

![Board top](docs/generated/hardware_v1/BOARD_NAME-top.svg)
-->

## Repository layout

| Folder | Contents |
|---|---|
| `hardware/` | KiCad projects, one folder per revision |
| `docs/` | documentation; `docs/generated/` is rebuilt automatically |
| `mechanical/` | enclosure, front panel, printed parts |
| `firmware/` | device code (delete if unused) |
| `.github/` | release and docs automation |

## Build it yourself

1. Download the gerbers and BOMs from the [latest release](https://github.com/OWNER/REPO/releases/latest).
2. Order the PCBs (settings: [manufacturing notes](hardware/v1/manufacturing/README.md)).
3. Order the parts from `bom-buy.csv`, plus anything in [sourcing](docs/sourcing.md).
4. Assemble: [assembly guide](docs/assembly.md).
5. Power up and test: [bring-up](docs/bring-up.md).

## Safety

Only keep this section if it applies. See [SAFETY.md](SAFETY.md).

## License

Hardware: CERN-OHL-P-2.0. Software: MIT. Docs: CC BY 4.0. (Edit to match your `LICENSE` file.)

## Credits

Based on / inspired by / thanks to.
