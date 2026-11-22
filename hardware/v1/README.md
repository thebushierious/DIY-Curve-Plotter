# Curve Plotter v1

**Status:** in progress
**KiCad:** 10.0  **Layers:** <!-- TODO: 2? -->  **Size:** <!-- TODO: W x H mm per board -->  **Thickness:** 1.6 mm

## Boards and sheets

| Board or sheet | Function | File |
|---|---|---|
| Top level | Interconnect between the three boards (J2/J5, J6/J7, J9/J10, transformer J8) | `CurvePlotter.kicad_sch` |
| Power Supply Board | ±15 V and 12 V from the transformer (rectifier, UA7815 / LM7915 / UA7812, fuses, rail LEDs) | `power_supply.kicad_sch` |
| Logic Board | Sweep generator, step counter and DAC, step range, output stage, Y amplifier, front panel wiring | `Logic.kicad_sch` |
| Logic: 5V Supply | UA7805 from +15 V | `5V_supply.kicad_sch` |
| Logic: Switch Supply | Supply decoupling for the ADG419 analog switches | `switch_supply.kicad_sch` |
| Logic: 8V Ref | TL431 and OPA2277 8.000 V reference | `ref.kicad_sch` |
| Logic: N/P Switches | Relays K1–K3 and driver for NPN/PNP polarity | `swiches.kicad_sch` |
| Logic: Unused Parts | Spare gates of U13 (CD40106B) and U6B (CD4520) | `Unused.kicad_sch` |
| DUT Board | Device-under-test socket, banana jacks, guard | `DUT.kicad_sch` |

## Credits and origin

v1 is based on the Charakterograf (curve plotter) by R. K., "Praktyczny Elektronik" 2/1995, pp. 4–10 (PCB no. 188).

The author, R. K., could not be identified. On 22 November 2026 an email was sent to the publisher asking for permission to publish this derived design; no reply has been received so far.

Differences from the magazine design:

| Area | Magazine | v1 |
|---|---|---|
| Step generator | CD4520 counter and CD4051 multiplexer choosing one of eight resistors (R13–R22); base currents 0, 25, 50, 100, 200, 300, 400, 500 µA | CD4520 counter, three ADG419 switches and an R-2R ladder from an 8.000 V reference: equal 1 V steps |
| Base drive | Voltage source and resistors, with a silicon / germanium switch (diodes D1–D4) | Current pump (U10B): the current is chosen by the user, so it works for germanium, silicon and Darlington transistors without a switch |
| Base current range | one set of resistors | 1 µA, 10 µA, 100 µA or 1 mA per step (SW3, make-before-break) |
| FET steps | not covered | gate-voltage step ×1, ×1/2, ×1/10 (SW5); BJT / FET and JFET / MOS switches |
| Polarity | manual n/p switch | relays K1–K3 driven by SW1, with LED indication |
| Characteristics | two sets of output terminals | Output / Transfer switch (SW6), transfer scales (SW15), fixed 10 V / 5 V source (SW14) |
| Current measurement | one 1 Ω shunt (R24) | 100 Ω, 10 Ω or 1 Ω shunts (SW11, make-before-break, silver) |
| Op-amps | µA741 (ULY7741) | TL072 and OPA2277 |
| Power | LM7815 / LM7915, bridge of 4 × BYP401, optional external supply | UA7815 / LM7915 / UA7812 (relay rail) / UA7805 (logic), 1N5408 bridge, fuses, rail LEDs, Schottky rail clamps |
| Reference | none | TL431 and OPA2277, trimmed to 8.000 V |
| Construction | single board with PCB no. 188 | three boards (power, logic, DUT), ferrite beads, test points, banana jacks and ZIF socket |

## Known issues

| # | Problem | Workaround | Fixed in |
|---|---|---|---|
| 1 | DPST (SW7), SP3T (SW5), SP4T (SW10, SW15) and DP3T (SW4, SW11) switches are hard to source | Use DPDT with one throw unused, or rotary switches with an adjustable stop; see [front panel and switches](../../docs/front-panel.md) | |
| 2 | The PCB layout does not exist yet | PCBs still to be designed | |
| 3 | The schematic still labels F1–F3 "5A hold", which would never trip (regulators limit at about 1–2 A) | Built with 500 mA hold polyfuses; change the value on the schematic | v1 build |

## Notes

- The screw terminals J13 and J20 (TBL009V-254-03GY-2GY) could alternatively be a 0397000203, as noted on the DUT sheet.
- Transformer: 2 × 18 V, 15 or 30 VA, toroidal (the build uses the 30 VA), connected to J8. IEC C14 inlet with built-in fuse holder and mains switch. See [SAFETY.md](../../SAFETY.md) for the fuse values.

## Files

- `kicad/`: project files
- `bom/extras.csv`: off-board parts (screws, enclosure, transformer, fuses)
- `manufacturing/`: fab settings and panel config
- Gerbers, BOMs, PDFs: attached to the [release](https://github.com/thebushierious/DIY-Curve-Plotter/releases)

## Ordering

See [manufacturing/README.md](manufacturing/README.md).
