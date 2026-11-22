# Theory of operation

Applies to: v1

## Overview

<!-- Block diagram: diagrams/block-diagram.svg, source diagrams/block-diagram.drawio. Add when drawn. -->

The plotter applies a repeating voltage ramp to the device under test (DUT) while stepping its base current (or gate voltage) through 8 levels, one level per ramp. The X output (J3) shows the sweep voltage and the Y output (J4) shows the DUT current, so an oscilloscope in X-Y mode draws a family of curves. Relays K1–K3 switch between NPN and PNP (N- and P-channel) operation.

Signal path: **8 V reference → step counter and DAC → sign stage → step range → base/gate drive**, and **555 ramp → X amplifier and output stage → DUT → shunt → ×100 amplifier → Y**.

## Block 1: power supply

Sheet: `power_supply.kicad_sch`.

A 2 × 18 V toroidal transformer (15 or 30 VA) is connected to J8 (L1, GND1, L2). Four 1N5408 diodes (D23–D26) form a full-wave rectifier with a centre ground, and C20 and C21 (2200 µF) smooth it into about ±25 V unregulated (TP2 +UNREG, TP3 −UNREG). Three linear regulators produce the rails:

| Rail | Regulator | Fuse | LED |
|---|---|---|---|
| +15 V | U14 (UA7815) | F1 (5 A hold) | D15 |
| −15 V | U8 (LM7915) | F2 (5 A hold) | D16 |
| 12 V (relay coils) | U17 (UA7812) | F3 (5 A hold, 30 V) | D17 |

D3 is an LED on the unregulated supply. The Schottky diodes D10 (+15 V) and D12 (−15 V), both 1N5819, clamp each analog rail to within about 0.3 V of ground in the wrong direction, so the load can never pull one rail across ground while the other is starting up or collapsing. D5, D6 and D11 (1N4007) across the regulators protect them if the input falls faster than the output.

The 5 V rail comes from U7 (UA7805) on the Logic board, fed from +15 V (`5V_supply.kicad_sch`, LED D4). It feeds the counter, the logic and the VL pins of the analog switches.

## Block 2: reference

Sheet: `ref.kicad_sch`.

A TL431 (U3) and an OPA2277 (U16B) produce an 8.000 V reference, trimmed with the multi-turn P7 (TP14 VREF, LED D18). R10 and R13 are 0.1 % parts. Every step level, the pot range and the current ranges derive from it, so its stability sets the accuracy of the whole instrument. The supplies of the op-amp are filtered with ferrite beads (FB11, FB12) and decoupled.

## Block 3: sweep generator

A NE555P (U1) with a PNP current source (Q6, BC558C) charges C3 (220 nF) with a constant current, which gives a linear ramp at 500 Hz (2.00 ms period). P2 sets the charging current and so the frequency, and P1 sets the discharge current and so the retrace time. A BC548C (Q1) buffers the ramp, and P3 and C4 pass it to the relay contacts K1B and K1C, which feed it to the non-inverting input of U5A (TL072) for NPN or PNP. P3 sets the amplitude (12 V peak-to-peak), P4 and P5 set the DC level for PNP and NPN, and P6 equalizes the NPN amplitude. U5A drives a complementary BD139 / BD140 pair (Q9, Q5) on heatsinks to raise the output current, and the X output is 0 to +12 V for NPN or 0 to −12 V for PNP (TP50, then R7 1 kΩ to J3). The 555 output is also the Sync signal (TP44, R12 1 kΩ to J1). The 500 Hz rate is chosen so that a family of 8 curves is redrawn at 500 / 8 ≈ 62 Hz, which looks steady on the scope.

## Block 4: step generator

The sync pulse is conditioned by R8 and C9 and a CD40106B Schmitt trigger (U13A), and the step source switch SW4A (Auto / Step / Pot) routes it to the clock of a CD4520 counter (U6A, TP46 CLK). In Step mode the push button SW12 (debounced by R9 and C11) clocks the counter instead. Counter outputs A, B and C (TP38 Q1, TP37 Q2, TP36 Q3) each drive one ADG419 analog switch (U9A, U18A, U19A), which connects one leg of an R-2R ladder (R24A–D 20 kΩ, R15A–B 10 kΩ) to ground or the 8.000 V reference. An OPA2277 (U2B) buffers the 8-level staircase from 0 V to 7 V in 1 V (Vref / 8) steps (TP22 and TP23 DAC). Output D of the counter is not used.

In Pot mode, a second OPA2277 (U2A) follows the front-panel 10-turn pot P10 (TP48 POT); P9 sets its maximum. A sign stage (U10A OPA2277, trimmed with P8) inverts the staircase through relay contact K2B for the PNP or P-channel polarity (TP17 and TP18 SIGN).

## Block 5: step range

For a bipolar transistor, the base current per step is the 1 V step divided by a range resistor chosen by SW3A/B: 1 MΩ (R19) gives 1 µA per step, 100 kΩ (R16) gives 10 µA, 10 kΩ (R17) gives 100 µA and 1 kΩ (R18) gives 1 mA. U10B (OPA2277, with R42, R66, P11 and the compensation capacitor C44) is a current pump: it turns the staircase voltage across the selected range resistor into a base current that does not depend on the base-emitter voltage of the DUT (TP34 and TP35 PUMP). This is why v1 needs no silicon / germanium switch, and why germanium transistors and Darlingtons work as well as silicon ones; the limit is the compliance of the ±15 V rails. P11 trims the pump so that the current into a 1 kΩ and a 10 kΩ load is identical (R66 + P11 = R42). SW3 is make-before-break with gold contacts, so the base is never left floating while the range changes.

For FETs, SW5 (×1, ×1/2, ×1/10) scales the staircase through 0.1 % dividers (R67–R70) into a TL072 follower (U4B), which drives the gate as a voltage (TP28 and TP29 GATE). SW9A/B chooses between BJT and FET, and SW8 chooses between JFET and MOS. SW6A/B/C (3PDT) replaces the two sets of output terminals of the magazine design and chooses what the X and Y outputs show. In Output mode X shows the collector-emitter voltage V<sub>CE</sub> (0 to 12 V) and Y shows I<sub>C</sub>. In Transfer mode X is proportional to the base current I<sub>B</sub> and Y shows I<sub>C</sub> (the fixed collector voltage comes from SW14). In Transfer mode only, SW15 sets the base current per volt of the ramp through R46 (100 kΩ, 10 µA/V), R45 (47 kΩ, 21.3 µA/V), R44 (20 kΩ, 50 µA/V) or R43 (1 kΩ, 1 mA/V). See [front panel and switches](front-panel.md).

## Block 6: output stage

SW10 (SP4T) puts a series resistor in the collector path: R59 (47 Ω, 2 W), R60 (470 Ω, ½ W), R61 (4.7 kΩ) or no resistor, which limits the current and the power in the DUT and the output stage. A second buffer, U5B (TL072) with Q8 (BD139) and Q3 (BD140), is a fixed voltage source for the collector-emitter voltage when plotting transfer characteristics: SW14 chooses 10 V or 5 V (from the ±15 V rails through R29–R31), and relay contact K2C makes it negative for PNP.

R37 and R38 (100 Ω) are the resistors that make the booster transistors conduct (Q9/Q5 and Q8/Q3) when the output current of the op-amp exceeds a few mA. SW7A/B (DPST) short them out: the boosters then stay off and the collector current is limited to what the op-amp can deliver (about 25 mA). This protects small transistors from exceeding their power rating. Leave SW7 open for the full 100 mA.

## Block 7: current measurement

The DUT emitter current flows to ground through a shunt chosen by SW11: R55 (100 Ω), R56 (10 Ω) or R57 (1 Ω), all 0.1 %. SW11 is a DP3T switch, make-before-break with silver contacts, so the current path is never opened. Pole A connects the emitter directly to the selected shunt and carries the DUT current. Pole B is a separate sense path: it connects the same shunt through R25 (1 kΩ) and the clamp diodes D1 and D2 (1N4148) to U16A (OPA2277), which draws almost no current, so the contact resistance of the switch does not affect the measurement. U16A has a gain of 100 (R26 91 kΩ + P12 20 kΩ against R28 1 kΩ, 0.1 %) and drives the Y output (TP51, then R27 1 kΩ to J4): Y = 100 × I × R<sub>shunt</sub>, so 10 mA through the 1 Ω shunt gives 1.000 V.

## Block 8: polarity relays

SW1 (N/P) switches 5 V through R41 into Q4 (BC337, with R58 10 kΩ), which energizes three relays (K1, K2 and K3, 12 V) in parallel through the flyback diodes D7–D9 (1N4148). The relays swap the trimmers and signal paths between NPN and PNP. Contact K3B turns on a red LED (D19) or a green LED (D13) through R39 (2.2 kΩ) to show the state (TP41 QB, TP42 COIL). Schematic: `swiches.kicad_sch`.

### Relay driver calculations

For any number of relays on the same driver:

- Coil current: I = I<sub>c1</sub> + I<sub>c2</sub> + …, with I = V<sub>c</sub> / R and R = (1/R<sub>c1</sub> + 1/R<sub>c2</sub> + …)<sup>−1</sup>
- Base current (forced gain of 10): I<sub>b</sub> = I / 10
- R41 = (V<sub>s</sub> − V<sub>be</sub>) / (I<sub>b</sub> + V<sub>be</sub> / R58)
- Current in R41: I<sub>41</sub> = I<sub>b</sub> + V<sub>be</sub> / R58
- Power in R41: W<sub>R41</sub> = R41 × I<sub>41</sub><sup>2</sup>

| Symbol | Meaning |
|---|---|
| V<sub>c</sub> | coil voltage |
| V<sub>s</sub> | switch voltage |
| V<sub>be</sub> | base-emitter voltage |
| I | collector current |
| I<sub>c</sub> | coil current |
| I<sub>41</sub> | R41 current |
| I<sub>b</sub> | base current |
| R | collector resistance |
| R<sub>c</sub> | coil resistance |
| R41 | R41 resistance |
| W<sub>R41</sub> | R41 power |

If an external supply is used for the relay coils, recalculate R41.

## Block 9: DUT board

Sheet: `DUT.kicad_sch`.

The DUT board has a 28-pin ZIF socket (J12, 228-1277-00-0602J), banana jacks for the collector (J16), base (J15) and emitter (J14), and two 3-way screw terminals (J13, J20). The guard signal keeps leakage out of the 1 µA range.

## Interconnect

The boards connect through J2/J5 (6-way: +15 V, −15 V, 12 V, GND), J6/J7 (4-way: C, E, B, GUARD) and J9/J10 (3-way); J8 takes the transformer.

## Design decisions

- **Discrete R-2R ladder instead of a DAC IC.** The original design (see below) selects one of eight resistors with a CD4051 multiplexer; v1 builds a linear staircase from a trimmed reference instead. Only 3 bits are needed, there is no microcontroller to talk SPI, the 8 V reference is above the supply limit of many DAC ICs, and the whole design is through-hole. 0.1 % resistors and a trimmed reference give the required step accuracy.
- **Three single ADG419 switches** (U9, U18, U19). Each switches one bit between GND and Vref on ±15 V rails with 5 V logic (VL). A single quad switch could replace them but would need a redesign.
- **Make-before-break range switches** on the step range (SW3) and the shunts (SW11), so the base and the emitter are never left open while ranges are changed.
- **Schottky rail clamps (D10, D12)** instead of silicon diodes, for a tighter clamp.
- **OPA2277 in the precision paths** (reference, DAC, sign stage, Y amplifier) and TL072 where precision is less critical.
- **No microcontroller in v1.** The analog design needs no firmware and has fewer failure modes. A supervisor MCU (ADC readback, relay checks, display, USB logging) is planned for a later revision.

## Origin

v1 is based on the Charakterograf published in "Praktyczny Elektronik" 2/1995, pp. 4–10 (author R. K., PCB no. 188). The magazine design uses a ULY7855 (555) ramp generator, a MCY74520 (CD4520) counter with a MCY74051 (CD4051) multiplexer choosing one of eight resistors, µA741 op-amps, a single 1 Ω current shunt and manual switches for polarity and silicon/germanium compensation. See [hardware/v1](../hardware/v1/README.md) for the list of differences.
