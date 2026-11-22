# Calibration

Applies to: v1

Equipment:

- Multimeter with at least 0.1 mV resolution (4½ digits) on the 20 V range, for the 8.000 V reference
- Two-channel oscilloscope with X-Y mode
- Precision resistors, 0.1 %: 1 kΩ and 10 kΩ
- A stable 5.000 V source and a 10.00 V source (bench supply measured with the multimeter)
- 30 minutes of warm-up before you start

Set all trimmers to mid-position before you start, and check on the scope that the ramp has no spike at P3 before adjusting anything else. Do the adjustments in this order, because later ones depend on the 8.000 V reference.

| Order | Adjust | For | Measure at | Target |
|---|---|---|---|---|
| 1 | P7 (5 k, multi-turn) | Vref | TP14 (VREF) | 8.000 V ±1 mV |
| 2 | P9 (2 k trimmer, with the front-panel pot P10 fully clockwise) | Maximum pot output | TP48 (POT) | 7.000 V at the pot follower (start near 1.43 kΩ) |
| 3 | P8 (500 Ω, multi-turn) | Sign stage gain of −1 | TP17 or TP18 (SIGN) with 5.000 V applied in the −1 state | −5.000 V, so that R22 + P8 = R21 |
| 4 | P2 (47 k) | Ramp period | TP50 (X) or TP44 (SYNC) | 2.00 ms (500 Hz) |
| 5 | P1 (4.7 k) | Ramp retrace | TP50 (X) on the scope | Shortest clean retrace |
| 6 | P3 (10 k) | X swing, PNP position | TP50 (X), polarity switch in PNP | 12.0 V peak-to-peak |
| 7 | P4 (47 k) | PNP ramp start | TP50 (X), polarity switch in PNP | Ramp starts at 0 V |
| 8 | P5 (47 k) | NPN ramp start | TP50 (X), polarity switch in NPN | Ramp starts at 0 V |
| 9 | P6 (10 k) | NPN ramp span | TP50 (X), polarity switch in NPN | 12.0 V peak-to-peak |
| 10 | P11 (5 k, multi-turn) | Output current match, R66 + P11 = R42 | Voltage across a 1 kΩ and a 10 kΩ load in turn | The two currents equal within 0.1 % |
| 11 | P12 (20 k) | Y amplifier gain of 100.0, R26 + P12 = 99.0 kΩ | TP51 (Y): apply 10.00 V through 1 kΩ into the E pin on the 1 Ω range | Y = 1.000 V (P12 near 8 kΩ) |

Notes:

- **P7 first.** The step size (Vref / 8 = 1.000 V per step) and the pot maximum all scale with Vref, so repeat step 2 if you re-trim P7.
- **P1 and P2 interact** (retrace and period); repeat steps 4 and 5 until both are within target.
- **P3 and P4, and P5 and P6, interact** (span and start); go back and forth until both are right. Do the PNP pair and the NPN pair separately.
- Re-check steps 6 to 9 after changing anything in the ramp or polarity circuit.
- Recalibrate after replacing U2, U10, U16, an ADG419 (U9, U18, U19) or any 0.1 % resistor, and then once a year. Warm up for 30 minutes first.
- Leave trimmers at the exact values your measurements give; don't hunt for a "better" setting.
