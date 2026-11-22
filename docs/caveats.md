# Caveats

Known limits of each revision, how I can work around them and what to consider. The values come from calculation; v1 is not built yet, so I treat them as expectations until the [bring-up](bring-up.md) confirms them.

## v1

### Measurement limits

- **12 V and 100 mA maximum.** I cannot test transistors that need more voltage (high breakdown voltage) or power transistors at their full rating. The high-voltage box in the [roadmap](roadmap.md) is the plan for this.
- **25 mA protection.** With SW7 closed the current is limited to about 25 mA. A large device then shows a clipped curve, so I check SW7 first when a curve looks flat.
- **Only 8 steps and fixed step sizes.** The staircase has 3 bits, 1 V per step. I get a different step size by changing the range (SW3, SW5) or with the pot. I cannot choose the exact step.
- **Base current with high-gain devices and Darlingtons.** The pump is limited by the ±15 V rails. On the 1 mA/step range the top steps can run out of headroom. I use a lower range or a series resistor.
- **FET gate voltage.** Steps come from the same staircase (0 to 7 V). Devices that need a higher gate voltage are not covered.
- **Sweep frequency.** At 500 Hz, devices with large capacitance (power transistors, MOSFETs) show loops where the curve goes up and back. I read the curve at the slowest setting I have, or I lower the sweep frequency with P2.
- **Heating.** At 12 V and 100 mA the DUT dissipates over 1 W for short moments, so the curves change as the part warms. I use the collector resistors (SW10) and the 25 mA limit for small parts.
- **Y range.** Y is 10 V at full scale on each range and the clamp diodes limit it above that. A part that draws more than the range clips the display and does not damage the unit.
- **The 1 µA range.** The currents are very small, so leakage across a dirty board (flux, humidity) is visible. I clean the board and I keep the guard tracks around the base path.

### Accuracy and calibration

- 11 trimmers, and some of them interact (P1/P2, P3/P4, P5/P6). I follow the order in the [calibration guide](calibration.md), and I recalibrate when I change a part.
- The ±1 mV accuracy of the 8.000 V reference depends on a warm-up of 30 minutes and on a good meter.
- The shunts are 0.1 %, but the contact resistance of the ZIF socket and the jacks adds to the 1 Ω range. SW11 senses through a separate pole, but the DUT side is still not a full Kelvin connection.
- The legends on the panel had to be corrected (see [front-panel.md](front-panel.md)).

### Construction and safety

- **Mains voltage.** Read [SAFETY.md](../SAFETY.md). The first power-up goes through a bench supply or a dim bulb tester.
- **Switch sourcing.** DPST, SP3T, SP4T and DP3T switches are hard to buy. Substitutes are in [front-panel.md](front-panel.md); a rotary switch with an adjustable stop is the best option.
- **No PCB layout yet.** The layout of the 1 µA path, the guard, the grounding (digital switching noise from the CD40106, CD4520 and ADG419 must stay away from the analog ground) and the placement of the ferrite beads decide how well it works.
- **Heatsinks.** 4 regulator heatsinks and 4 transistor heatsinks. The case needs ventilation, because the regulators dissipate the most at low load.
- **Polyfuses F1 to F3** are 500 mA hold. They derate in the warm case, and they are not a safe disconnect.
- **Relay driver.** The values are for the 12 V relay rail; an external supply needs a recalculation.
- **Licence.** v1 is derived from a magazine design. I asked the publisher for permission and have not had a reply (see the [README](../README.md)).

## v2

- **Lower amplitude.** The divider must sit before the power stage and X must still show the real DUT voltage. A mistake here makes the X scale wrong on the lower ranges.
- **AC mode.** The Y amplifier limits the frequency (about 1 kHz). A bipolar signal needs the polarity relays and the ramp circuit set to a neutral state, and the X buffer must pass negative voltages. A capacitor on the DUT can make the push-pull stage oscillate.
- **Buffer from the base.** Op-amp outputs driving a transistor base can oscillate, so I add a series resistor and I check it with the scope.
- **Step LEDs.** They must be buffered, so they do not load the counter outputs that drive the ADG419 inputs.
- **Coil checker and relay checks.** The LM339 thresholds depend on the coil current and the supply, so I recalculate them for the external supply.
- **External supply.** R41 and the relay driver have to be recalculated.
- **Front panel meter.** It must not load the measured node. I use a buffer in front of it.
- **High-voltage box.** Not designed. It needs its own safety design before anything is built (see the [roadmap](roadmap.md)).

## v3

- **Noise.** A microcontroller, a display and the switching of relays add noise next to the 1 µA path. I keep the MCU on a separate ground, I use a separate regulator, and I do not clock anything near the analog path at a frequency that shows up on the scope.
- **Switches replaced by analog parts.** Analog switches have on-resistance and leakage. For the shunts and the collector path I use relays, and for the 1 µA path I use low-leakage parts.
- **Start-up state.** Relays and switches must start in a safe state (lowest current, 25 mA limit, no step) and the firmware needs a watchdog that returns to this state.
- **Make-before-break in software.** The order and timing of the switching must be right, so the base and the emitter are never left open.
- **USB.** I isolate the USB connection, so the PC ground and the scope ground do not form a loop and the PC does not connect to the unit's supply.
- **Display.** A backlight and a switching supply for it can add noise; I use a linear supply and I turn the backlight down when I take a measurement.
- **Firmware.** Settings that I now see on a switch position must be visible on the display, so I never guess which mode the unit is in. A mismatch between the display and the relays must be caught by the relay checks from v2.
- **More work.** Firmware, a PC program and updates to maintain. I keep v2 as the reference design that works without any of it.
