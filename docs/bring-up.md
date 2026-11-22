# Bring-up

Applies to: v1

Read [SAFETY.md](../SAFETY.md) first. Do the steps in order and stop at the first one that fails.

## Before power

- Visual inspection: solder joints, bridges, missing parts, socketed ICs seated the right way round.
- Polarity of electrolytic capacitors (C14, C15, C20, C21, C37 and the 10 µF / 22 µF parts on the Logic board) and of the LEDs and diodes (the Schottkys D10 and D12 especially).
- Regulator pinouts: U14 (UA7815), U17 (UA7812) and U7 (UA7805) are IN-GND-OUT, but U8 (LM7915) is **GND-IN-OUT**. Check each against its datasheet.
- Ohm-meter checks with the unit unplugged: no short between +15 V, −15 V, 12 V, 5 V and GND.
- Check chassis earth continuity to the IEC earth pin (under 0.1 Ω).
- Fuse in the IEC inlet is the right value (T 160 mA for 15 VA, T 250 mA for 30 VA).
- ICs out of their sockets for the first power-up of each board (U1, U2, U4, U5, U6, U9, U10, U13, U16, U18, U19).

## First power

Use a current-limited supply for the Logic board first (100 mA limit), then a dim bulb tester for the full unit.

1. Power the Power Supply Board alone, with the Logic and DUT boards disconnected (J2, J5, J6, J7, J9, J10 unplugged).
2. Check the rail LEDs (D15, D16, D17) and the unregulated LED (D3) light.
3. Measure the test points below with a multimeter.
4. Power off, connect the Logic board, and repeat with the ICs inserted one board at a time.

| Test point | Expected | Tolerance |
|---|---|---|
| TP2 +UNREG | about +25 V (higher with no load) | +22 V to +29 V |
| TP3 −UNREG | about −25 V | −22 V to −29 V |
| TP4 or TP10 (+15V) | +15.0 V | ±5 % |
| TP5 or TP9 (−15V) | −15.0 V | ±5 % |
| TP6 (12V) | +12.0 V | ±5 % |
| TP12 (5V) | +5.0 V | ±5 % |
| TP14 (VREF) | 8.000 V after trimming P7 (see [calibration](calibration.md)) | before trim: 8 V ±0.2 V |
| All GND test points | 0 V | |

Record the no-load and loaded current from the bulb or bench supply here: <!-- TODO after first build -->.

## Functional checks

1. **Sync / sweep:** scope on TP44 (SYNC): a pulse train at roughly 500 Hz. If the sweep is not yet calibrated, only check that it runs.
2. **X ramp:** scope on TP50 (X): a clean ramp about 12 V peak-to-peak; check both polarity switch positions.
3. **Counter:** set the step source switch (SW4) to Step. Each press of SW12 advances the counter: TP38 (Q1), TP37 (Q2) and TP36 (Q3) count in binary 000 to 111, then wrap.
4. **Staircase:** set SW4 to Auto and scope TP22 (DAC): 8 steps, 0 V to 7 V in 1 V (Vref / 8) increments, one step per sweep.
5. **Pot mode:** set SW4 to Pot: TP48 follows the front-panel 10-turn pot (P10) from 0 V up to the maximum set by P9 (7.000 V after calibration).
6. **Polarity relays:** flip the N/P switch (SW1): relays K1–K3 click, and the green (D13) / red (D19) LED changes.
7. **Y path:** with a 1 kΩ resistor from collector to emitter on the DUT board, the X-Y trace is a straight line. The slope changes correctly when the range switches (SW10, SW11) are changed.
8. **Collector-emitter voltage source:** measure the output of U5B. It should be +10 V or +5 V with SW14 in each position, and −10 V or −5 V with SW1 in the PNP position.
9. **X range:** the X output (TP50) swings between 0 and +12 V for NPN, or between 0 and −12 V for PNP.
10. **Known device:** insert a common small-signal transistor (BC548 or BC558) and compare the curve family with its datasheet. NPN curves are drawn from bottom to top and from left to right; PNP curves from top to bottom and from right to left. For small silicon transistors close SW7 to keep the collector current low.

## Troubleshooting

| Symptom | Likely cause | Check |
|---|---|---|
| No ±15 V | A rail fuse (F1–F3) has opened, a Schottky (D10, D12) is in backwards, or a regulator is inserted wrongly | Check D10 and D12 orientation (cathode to the rail for D10, to GND for D12); check the LM7915 pinout |
| +UNREG or −UNREG missing | Bridge diode or fuse problem, transformer wiring | Check D23–D26 and the L1, L2 and GND connections on J8 |
| Rail LEDs on, 5 V missing | U7 (UA7805) or C32–C34 | Measure TP12, check +15 V at its input |
| VREF not near 8 V | TL431 (U3) or U16B problem, P7 at an end stop | Check R11, R10, R13, and the +15 V / −15 V at U16 |
| No sweep | 555 (U1) not oscillating, Q6 or Q1 wrong way round | Scope U1 pin 3; check C3, Q6 and Q1 |
| Counter does not advance | U6A reset (pin 7) held high, SW4 in wrong position, no clock | Scope TP46 (CLK); check U13A and U6A pins 1, 2 and 7 |
| Staircase has wrong levels | Vref off, an ADG419 (U9, U18, U19) not powered or missing VL (5 V), a ladder resistor wrong | Measure Vref at the switches; check R24A–D and R15A–B |
| Relays do not switch | 12 V missing, Q4 not turned on, flyback diode in backwards | Check TP42 (COIL) and TP41 (QB); D7–D9 |
| Y offset or noise | Floating guard, poor ground, long unscreened DUT wiring | Check the guard connection and use PTFE wiring on the base, emitter and collector |
| Curves cut off at high current | Collector series resistor (R59–R61) for the selected range, or the output stage (Q9/Q5) overheating | Check SW10 and the heatsinks |
