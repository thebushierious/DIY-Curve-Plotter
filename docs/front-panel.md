# Front panel and switches

Applies to: v1

This page collects the legends and notes that were drawn on the Logic sheet, so they can live here instead of on the schematic.

## Switch contact requirements

- All switches are **break-before-make, except two**:
  - **SW3A/B** (DP4T rotary, base current per step): make-before-break, **gold** contacts (low-level signal).
  - **SW11A/B** (DP3T, emitter shunt range): make-before-break, **silver** contacts (carries the DUT current).
- The DPST (SW7), SP3T (SW5), SP4T (SW10, SW15) and DP3T (SW4, SW11) positions are hard to source as plain switches; see the known issues in [hardware/v1](../hardware/v1/README.md).

## Controls and legends as drawn

| Switch | Type | Positions / legend | Function |
|---|---|---|---|
| SW1 | SPST | N/P | NPN or PNP (N- or P-channel): switches the polarity relays K1–K3 (see theory) |
| SW12 | push button | STEP | Advances the step counter in Step mode |
| SW4A/B | DP3T rotary | Auto / Step / Pot | Step source: automatic (one step per sweep), manual button, or the 10-turn pot |
| SW3A/B | DP4T rotary | 1 µA/Step, 10 µA/Step, 100 µA/Step, 1 mA/Step | Base current per step (R19 1 MΩ, R16 100 kΩ, R17 10 kΩ, R18 1 kΩ); make-before-break, gold |
| SW5 | SP3T | ×1, ×1/2, ×1/10 | Scale of the gate-voltage step for FETs |
| SW9A/B | DPDT | BJT / FET | Device type |
| SW8 | SPDT | JFET / MOS | Type of FET |
| SW6A/B/C | 3PDT | Output / Transfer; I<sub>C</sub> = f(U<sub>CE</sub>) or I<sub>C</sub> = f(I<sub>BE</sub>); (V<sub>CE</sub>) (I<sub>B</sub>) 0–12 V | Output: X = V<sub>CE</sub>, Y = I<sub>C</sub>. Transfer: X = I<sub>B</sub>, Y = I<sub>C</sub>. Replaces the two sets of output terminals of the magazine design |
| SW15 | SP4T | 10 µA/V, 21.3 µA/V, 50 µA/V, 1 mA/V | Transfer mode only: base current per volt of the ramp, through R46 100 kΩ, R45 47 kΩ, R44 20 kΩ, R43 1 kΩ |
| SW10 | SP4T | R59 47 Ω 2 W, R60 470 Ω ½ W, R61 4.7 kΩ, open | Collector series resistor (output range) |
| SW11A/B | DP3T | R55 100 Ω, R56 10 Ω, R57 1 Ω (all 0.1 %, R57 ½ W) | Emitter shunt (current range). Pole A carries the emitter current, pole B senses the shunt through R25 to the Y amplifier; make-before-break, silver |
| SW14 | SPDT | 10 V / 5 V | Fixed collector-emitter voltage for the transfer characteristics (negative for PNP) |
| SW7A/B | DPST | | Closed: shorts R37 and R38 so the booster transistors are off and the collector current is limited to about 25 mA (protects small transistors). Open: full 100 mA |

Other legends on the sheet:

- **Y output (I<sub>C</sub> / I<sub>D</sub>):** Y = 100 × I × R<sub>shunt</sub>, so full scale (10 V) is 1 mA on the 100 Ω shunt (R55), 10 mA on the 10 Ω shunt (R56) and 100 mA on the 1 Ω shunt (R57). The legends next to the shunts should read: **R55 100 Ω: 10 V = 1 mA (100 µA/V)**, **R56 10 Ω: 10 V = 10 mA (1 mA/V)**, **R57 1 Ω: 10 V = 100 mA (10 mA/V)**. The older legends (0.1 V–1 mA, 1 V–10 mA, 10 V–100 mA) were copied from the magazine design, which had a single 1 Ω shunt, and are wrong for v1.
- **Add a buffer from B:** a to-do for v2 (buffer the base output).
- **When EXT supply change for relay:** if an external supply is used for the relay coils, recalculate R41 (see the relay driver calculations in the [theory of operation](theory-of-operation.md)). It is written twice on the Logic sheet.
- **P / N** and **N / P**: the position legends of the K1 and K2 relay contacts and of SW1.

## Panel labels

This is what I engrave or stick on the case, so I always know what each control does and which mode it belongs to. Text in **bold** is the label itself; the position legends are listed in the order I turn the switch clockwise. Controls that only work in one mode say so on the panel (for example "BJT only"), so I don't change a setting that does nothing.

### Device and polarity

| Control | Label | Positions | Notes |
|---|---|---|---|
| SW9A/B | **DEVICE** | **BJT** / **FET** | Selects bipolar or field-effect device |
| SW8 | **FET TYPE** | **JFET** / **MOS** | FET only |
| SW1 | **POLARITY** | **NPN · N-ch** / **PNP · P-ch** | Switches the polarity relays K1–K3; the green LED (N) and the red LED (P) show the state |

### Steps

| Control | Label | Positions | Notes |
|---|---|---|---|
| SW3A/B | **BASE STEP (BJT only)** | **1 µA** / **10 µA** / **100 µA** / **1 mA** | Base current per step |
| SW5 | **GATE STEP (FET only)** | **×1** / **×½** / **×1/10** | Scale of the gate-voltage step (1 V per step at ×1) |
| SW4A/B | **STEP MODE** | **AUTO** / **STEP** / **POT** | One step per sweep / manual button / 10-turn pot |
| SW12 | **STEP** | push button | Next step in STEP mode |
| P10 | **STEP POT** | 10-turn knob | Used in POT mode (0 to 7 V) |

### Measurement

| Control | Label | Positions | Notes |
|---|---|---|---|
| SW6A/B/C | **MODE** | **OUTPUT I<sub>C</sub> = f(U<sub>CE</sub>)** / **TRANSFER I<sub>C</sub> = f(I<sub>B</sub>)** | In OUTPUT, X is the collector voltage; in TRANSFER, X is the base current |
| SW15 | **TRANSFER I<sub>B</sub> / V (TRANSFER only)** | **10 µA/V** / **21.3 µA/V** / **50 µA/V** / **1 mA/V** | Base current per volt of the ramp |
| SW14 | **U<sub>CE</sub> (TRANSFER only)** | **10 V** / **5 V** | Fixed collector voltage for the transfer curve |
| SW10 | **R<sub>C</sub> (collector resistor)** | **47 Ω** / **470 Ω** / **4.7 kΩ** / **OFF** | OFF means no series resistor |
| SW11A/B | **I<sub>C</sub> RANGE** | **100 Ω: 10 V = 1 mA** / **10 Ω: 10 V = 10 mA** / **1 Ω: 10 V = 100 mA** | Y is 10 V at full scale on each range (see the legends above) |
| SW7A/B | **I<sub>MAX</sub>** | **25 mA** (closed) / **100 mA** (open) | 25 mA protects small transistors |

### Connectors and indicators

| Item | Label | Notes |
|---|---|---|
| J3 | **X** | BNC to the scope X input |
| J4 | **Y** | BNC to the scope Y input |
| J1 | **SYNC** | BNC to the scope trigger input |
| J14, J15, J16 | **C / D**, **B / G**, **E / S** | Banana jacks; I use the colours of the 4 mm jacks to tell them apart |
| J12 | **DUT** | ZIF socket; I mark pin 1 and the pin order for the device |
| LEDs D15, D16, D17 | **+15 V**, **−15 V**, **12 V** | Rails |
| LEDs D13 (green), D19 (red) | **N** (green) / **P** (red) | Polarity indicators: green is NPN / N-channel, red is PNP / P-channel |
| Rear | **I/O** (mains switch), **230 V~ 50 Hz**, **T 250 mA**, earth symbol | IEC inlet with built-in mains switch and fuse holder |
| Front or rear | **MAX DUT: 12 V, 100 mA** | Test limit |
| Inside, on the lid | **MAINS VOLTAGE INSIDE. UNPLUG BEFORE OPENING.** | See [SAFETY.md](../SAFETY.md) |

The trimmers (P1 to P9, P11, P12) are inside the case and are not labelled on the panel; they are listed in the [calibration guide](calibration.md).
