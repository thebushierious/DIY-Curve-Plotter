# Roadmap

What I plan to change after v1. It collects the notes I had on the schematic, so I can delete them from it. Details are fixed when each schematic is drawn.

## v2: still analog

v2 stays analog. I want the analog part proven and calibrated before I add a microcontroller.

### From the notes on the schematic

- **Current checker (LM339) for the relay coils.** A comparator on each coil checks that the coil current is flowing.
- **Check that all relays switched correctly.** Together with the coil checker, an LED or signal shows when a relay did not switch.
- **Front panel meter.** A panel meter on the front, for the set values or the measured ones.
- **Step LEDs.** One LED per step (8 steps), driven from the counter outputs. They need buffering, so they don't load the logic that drives the ADG419 switches.
- **External power option.** v2 can be powered from an external bench power supply instead of the transformer. The bench supply replaces the transformer and the rectifier, so I need a way to switch between the two (so they never feed the rails together), reverse-polarity protection, a fuse, and the input range of the regulators. R41 (and with it the relay driver, see the calculations in the [theory of operation](theory-of-operation.md)) must be recalculated for the external voltage. This note is on the Logic sheet twice.
- **A buffer from the base output** (B). It needs a small series resistor so it does not oscillate with the capacitance of the DUT and the cable.
- **High-voltage box:** see [below](#high-voltage-box).

### Lower sweep amplitude mode

**Why:** v1 always sweeps the DUT with 12 V. A lower amplitude (0.2 V up to 12 V) allows in-circuit tests without turning junctions on, protects delicate parts, and makes Schottky and other low-voltage diodes easier to read.

**How:**
- A rotary switch with a resistive divider on the sweep command, in front of the power stage (U5A, Q9, Q5): about 12 V, 5 V, 2 V, 1 V, 0.5 V and 0.2 V. I use 0.1 % or 1 % resistors, so the ranges are accurate.
- X must follow the real DUT voltage, so it still reads volts per division on every range. I check where X is taken from before I choose the divider position.
- Calibration (P3, P6) stays on the full range; the lower ranges are only checked.
- The 12 V position stays the default, so the transistor measurements do not change.

### AC component mode

**Why:** with a bipolar signal on the DUT, a capacitor shows as an ellipse and an inductor as an ellipse tilted the other way. A resistor is a line and a diode shows both directions. This allows quick checks of capacitors, inductors, resistors, diodes and Zeners.

**How:**
- A mode switch (Ramp / AC) feeds the power stage with a sine wave instead of the ramp. The stage is push-pull (Q9 BD139, Q5 BD140), so it should drive both polarities. The polarity relays and the 0 to +12 V / 0 to −12 V ramp circuit must be bypassed or set to a neutral state in this mode.
- The collector resistors (SW10) limit the current; the shunts (SW11) and Y amplifier (U16A) measure it as in v1. The part goes between the collector and emitter pins, or to a separate two-terminal input.
- X must be bipolar in this mode. I check the X buffer range.
- **Frequency:** the Y amplifier has a gain of 100 and the OPA2277 about 1 MHz gain-bandwidth, so its bandwidth is about 10 kHz and the phase error at 10 kHz would be large (the ellipse would be wrong). I use 500 Hz to 1 kHz with the existing amplifier (phase error about 3° to 6°). Higher frequencies need a lower-gain range or a faster amplifier.
- **Signal source:** in v2 an analog sine generator, for example a Wien bridge with amplitude stabilisation as in "Charakterograf – przystawka do oscyloskopu" (T. Kwiatkowski, Praktyczny Elektronik 10/1999, PCB no. 491), which uses a TL082 and a BF245 at 10 kHz. If I reuse that circuit, I credit that article. In v3 the sine comes from the MCU and a DAC.
- A table of switch settings and scope V/div for common parts goes into a usage page, like the one in the 1999 article.

## v3: digital

v3 adds a microcontroller. It replaces the rotary switches with relays and analog switches, so the settings can be changed from the display, from the buttons and from a PC.

### User interface

I started from a display with buttons, but I think a better combination is:
- **A rotary encoder with a push button and a small display** (an OLED or a TFT). One knob selects a setting and changes its value, so I do not need a button for every setting.
- **A few dedicated buttons** for the things I change often: polarity (N/P), STEP and the mode (Output / Transfer). They work without looking at the screen.
- **The display shows** the polarity, the device type, the step ranges, the shunt range, the Y scale (for example "1 mA/div") and the current state of the relays.
- **A USB connection to a PC** with a program that plots the curves, saves them and extracts parameters (for example the gain β). This is where my Python, Rust or C++ code goes. The USB link should be isolated, so the PC ground does not connect to the scope ground (see the caveats).

The scope stays the main display of the curves. The ADC in the MCU is only for numbers and for the PC.

### Other v3 items

- Replace the rotary switches (SW3 to SW11, SW14, SW15) with relays or low-leakage analog switches driven by the MCU. Shunts and the collector path stay on relays, because of the low resistance and the current.
- The make-before-break ranges (SW3, SW11) are done in software with a defined order of switching.
- Step LEDs and relay checks from v2 are read by the MCU.
- Save and recall setting presets.
- The AC component mode with a sine from the MCU and a DAC (see above).

## High-voltage box

This is a separate box that connects to the main unit and lets the curve plotter use higher voltages and test high-voltage parts (for example transistors with a high breakdown voltage), beyond the 12 V and 100 mA of the main unit. It is **not designed yet**; this is the plan, with the decisions I still have to make.

**Idea:**
- A separate box with its own isolated high-voltage supply and its own mains inlet, fuse and earth bonding.
- It replaces only the collector sweep supply. The step generator, the Y measurement and the scope connections stay in the main unit. The main unit's sweep command (scaled) drives a high-voltage amplifier in the box.
- X takes the DUT voltage through a precision divider (for example 100:1) so the scope can still read it.
- Current limiting by a series resistor and an electronic limit, a discharge resistor across the output, an interlock (the high voltage is off when the cable or the lid is open), and a visible HV warning LED.
- A separate shielded cable with a locking connector between the box and the main unit, so the high voltage cannot appear on the normal jacks.

**Decisions I still have to make:**
- Maximum voltage and current (for example 100 V to 300 V and a few mA to tens of mA).
- Supply type (isolated DC-DC module or a transformer with a multiplier) and the amplifier topology.
- Where the DUT sits: in the main unit with a ZIF socket, or in the box.
- How the interlock and the connector are done.

The hazard notes belong in `hardware/<revision>/hv-box/README.md` and are summarised in [SAFETY.md](../SAFETY.md). I do not build the box until the safety design is written and checked.
