# DIY Curve Plotter

<!-- Enable once the first release exists and thebushierious/DIY-Curve-Plotter is set:
[![Release](https://img.shields.io/github/v/release/thebushierious/DIY-Curve-Plotter)](https://github.com/thebushierious/DIY-Curve-Plotter/releases)
[![Release build](https://github.com/thebushierious/DIY-Curve-Plotter/actions/workflows/release.yml/badge.svg)](https://github.com/thebushierious/DIY-Curve-Plotter/actions/workflows/release.yml)
-->

![KiCad](https://img.shields.io/badge/KiCad-10.0-blue?logo=kicad)
![Status](https://img.shields.io/badge/status-in%20progress-yellow)

An analog transistor curve tracer (Charakterograf): it sweeps the collector (or drain) voltage while stepping the base current (or gate voltage) and draws the family of I-V curves on an oscilloscope in X-Y mode.

Based on the Charakterograf (curve plotter) by R. K., "Praktyczny Elektronik" 2/1995, pp. 4–10 (PCB no. 188). See [credits](#credits).

<!-- ![Hero image](docs/images/hero.jpg) -->

## Features

- Tests NPN and PNP bipolar transistors, and N- and P-channel FETs (JFET and MOSFET), with relay-switched polarity
- 8 steps per family (3-bit staircase from an 8.000 V reference)
- Base current per step: 1 µA, 10 µA, 100 µA or 1 mA; gate-voltage step scaled ×1, ×1/2 or ×1/10
- Step modes: automatic (one step per sweep), manual single step, and a 10-turn pot for manual control
- Collector sweep of 12 V peak-to-peak at 500 Hz (2.00 ms period), with selectable collector series resistors (47 Ω, 470 Ω, 4.7 kΩ)
- Current measured across 1 Ω, 10 Ω or 100 Ω shunts and amplified ×100 for the Y axis
- BNC outputs for X, Y and Sync; banana jacks and a 28-pin ZIF socket for the device under test
- Powered from a 2 × 18 V toroidal transformer (15 or 30 VA) with ±15 V, 12 V and 5 V rails

## How it works

A 555-based ramp generator sweeps the collector supply while a counter and a 3-bit R-2R ladder produce the step staircase, so each ramp draws one curve of the family. The current through the DUT is measured across a selectable shunt and amplified for the Y output, and the sweep voltage drives the X output. See the [theory of operation](docs/theory-of-operation.md).

<!-- ![Block diagram](docs/diagrams/block-diagram.svg) -->

## Status

| Revision | Status | Notes |
|---|---|---|
| [v1](hardware/v1) | in progress | Needs creating the PCBs |

**Planned for v2:**

- Current checker (LM339) for the relay coils
- Check that all relays switched correctly
- Front panel meter
- Step LEDs
- External power option (the relay driver must be recalculated for it)
- A buffer from the base output
- A separate high-voltage box
- Lower sweep amplitude mode and an AC component mode

More details, the plan for v3 (microcontroller, display and USB) and the high-voltage box are in the [roadmap](docs/roadmap.md). Known limits of each revision are in the [caveats](docs/caveats.md).

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
| `.github/` | release and docs automation |

<!-- Enable when v1 has a release with gerbers and BOMs:
## Build it yourself

1. Download the gerbers and BOMs from the [latest release](https://github.com/thebushierious/DIY-Curve-Plotter/releases/latest).
2. Order the PCBs (settings: [manufacturing notes](hardware/v1/manufacturing/README.md)).
3. Order the parts from `bom-buy.csv`.
4. Assemble: [assembly guide](docs/assembly.md).
5. Power up and test: [bring-up](docs/bring-up.md).
-->

## Safety

This project contains mains voltage. Read [SAFETY.md](SAFETY.md) before building or powering it.

## License

Hardware: CC BY-NC-SA 4.0. Docs: CC BY 4.0. See [LICENSE.md](LICENSE.md).

## Credits

Based on the Charakterograf (curve plotter) by R. K., "Praktyczny Elektronik" 2/1995, pp. 4–10 (PCB no. 188).

The author, R. K., could not be identified. On 22 November 2026 an email was sent to the publisher asking for permission to publish this derived design; no reply has been received so far.

Stackable PCB standoffs: model by [theduckom](https://www.printables.com/@theduckom) on Printables, licensed CC BY 4.0.
