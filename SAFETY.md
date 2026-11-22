# Safety

**Hazard: this project contains mains voltage (230 V AC) at the IEC inlet, fuse and transformer primary. It can kill. Everything after the transformer (±15 V, 12 V, 5 V) is low voltage.**

## Required protection

- **Mains switch and fuse (primary):** the mains switch is built into the IEC C14 inlet together with the fuse holder. I check that the switch breaks the live wire (ideally both), and that the fuse is slow-blow (T), 250 V AC.
  160 mA for a 15 VA transformer, 250 mA for a 30 VA transformer. Never use a larger fuse.
- **Transformer:** toroidal, 2 × 18 V secondary, 15 VA or 30 VA, with a mains-rated, insulated primary.
- **Earthing:** the metal enclosure is bonded to the protective earth pin of the IEC inlet with a ring lug
  and star washer. Check continuity (inlet earth pin to every metal panel, under 0.1 Ω) before first power.
- **Insulation:** mains-rated wire (0.75 mm², 300/500 V) for the primary. Insulated crimp terminals with
  heat-shrink over every mains connection. Strain relief on all mains wiring. Keep primary wiring away from the low-voltage boards.
- **Enclosure:** the case stays closed whenever it is plugged in. Nothing on the front panel is connected to the mains.
- **Secondary fuses:** F1–F3 are 500 mA hold polyfuses (30 V) on the regulator outputs (+15 V, −15 V, 12 V). The circuit draws well under 0.3 A per rail; the polyfuses trip at roughly twice the hold current, so they limit a fault, but the regulators' own current limit and the mains-side T fuse remain the main protection. A polyfuse is not a safe disconnect: after a trip, unplug the unit and find the cause.

## What never to do

- Never work on the mains side with the unit plugged in. Unplug it first, then wait for the 2200 µF reservoir capacitors to discharge.
- Never bypass, jumper or up-rate the fuse.
- Never run the unit with the case open or the earth connection missing.
- Never plug a device into the DUT sockets or banana jacks while the unit is powered.
- Never touch the heatsinks, regulators or R59 (2 W) after a long run: they get hot.
- Never power it for the first time directly from the wall.

## How to test first

1. **Without mains:** power only the Logic board from a current-limited bench supply (+15 V, −15 V, 12 V; limit to 100 mA at first).
2. **Dim bulb tester:** put the finished unit behind a dim bulb tester. The bulb should glow only faintly. A bright bulb means a fault: unplug and investigate.
3. **Isolation transformer:** for the first live checks and for any probing near the primary.
4. Continue with [docs/bring-up.md](docs/bring-up.md).

<!-- Enable when the HV box exists:
## High-voltage box
Hazard notes for the HV box live in `hardware/<revision>/hv-box/README.md`. The plan is in [docs/roadmap.md](docs/roadmap.md).
-->

No warranty (see LICENSE). Build and use at your own risk.
