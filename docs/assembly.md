# Assembly

Applies to: v1

How I build v1. The order is chosen so each board is tested on its own before it is connected to the others. Read [SAFETY.md](../SAFETY.md) first, and do the checks in [bring-up](bring-up.md) after each stage.

## Before I start

- The BOM from the latest release (`bom-buy.csv`) and the off-board parts from `hardware/v1/bom/extras.csv`.
- A temperature-controlled soldering iron, flux, isopropyl alcohol and a brush, a multimeter and a scope.
- ESD precautions for the ADG419 switches and the CD40106B and CD4520 ICs.
- I read the part values from the schematic and the BOM, not from memory. The 0.1 % resistors (R10, R13, R28, R55 to R57, R67 to R70) are marked and kept apart from the others.

## Order

1. **Power Supply Board.** Diodes and 0.1 % parts first, then connectors, capacitors (check the polarity of the 2200 µF capacitors), the regulators with their heatsinks, and the polyfuses F1 to F3. Test it alone with a bench supply or the transformer through a dim bulb tester (TP2, TP3, TP4, TP5, TP6, TP12).
2. **Logic Board.** Resistors and diodes, IC sockets, trimmers (all set to mid-position), capacitors, relays and connectors, and the output transistors with their heatsinks. ICs go in last, after I check the supply voltages on the sockets.
3. **DUT Board.** The ZIF socket, banana jacks, screw terminals and the guard.
4. **Clean every board** with isopropyl alcohol and a brush, and let it dry. This matters most for the base path on the 1 µA range, where flux residue creates leakage.
5. **Mechanics.** Standoffs and screws (see [hardware](hardware.md)), the front panel with the switches, jacks, LEDs and the BNC connectors, with the labels from [front-panel.md](front-panel.md).
6. **Wiring.** The board-to-board connectors (J2 and J5, J6 and J7, J9 and J10), the front-panel wiring and then the mains side: the inlet with switch and fuse, earth bonding to the case, and the transformer. The mains wiring is done with the unit unplugged, with insulated crimp terminals and heat-shrink.
7. **Bring-up** and [calibration](calibration.md).

## Things I check

- Polarity of electrolytic capacitors, diodes, LEDs and the regulators (the LM7915 has a different pinout from the 78xx).
- The make-before-break switches (SW3 and SW11) are the right type.
- Nothing on the front panel is connected to the mains, and every metal panel has continuity to the earth pin.
