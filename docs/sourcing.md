# Sourcing

Applies to: v1

I buy everything from Mouser. This page lists what is hard to find and what I use instead.

## Switches

DPST (SW7), SP3T (SW5), SP4T (SW10, SW15) and DP3T (SW4, SW11) switches are hard to buy as plain switches. What I do:

- Use a DPDT switch with one throw unused instead of a DPST, and a rotary switch with an adjustable stop for the multi-position switches (SP3T, SP4T, DP3T, DP4T). The make-before-break types (SW3 gold, SW11 silver) need the matching contacts, so I check the datasheet before ordering.
- The full list of switches with their contact requirements is in [front-panel.md](front-panel.md).

## Parts to watch

- **0.1 % resistors** (R10, R13, R28, R55 to R57, R67 to R70) and the 1 Ω shunt (R57, ½ W). I check the power rating before I order.
- **ADG419, OPA2277, UA7815, UA7812, UA7805, LM7915, TL431:** I check stock and the package before I order, and I keep the datasheet of any substitute.
- **Connectors:** JST XH (S6B-XH-A), Molex Mini-Fit Jr (39-28-1043), Phoenix 1718757, the ZIF socket (228-1277-00-0602J), the screw terminals (TBL009V-254-03GY-2GY, or 0397000203) and the 4 mm jacks (CT4397-08-x). The mating housings, crimp terminals and tools are in `hardware/v1/bom/extras.csv`.
- **Transformer:** 2 × 18 V toroidal. I use the 30 VA one because it is the only one available; the 15 VA one also works.

## Off-board parts

The parts that are not on a board (transformer, inlet, fuse, enclosure, standoffs, screws, heatsinks, knobs, wire, lugs and the mating connectors) are in `hardware/v1/bom/extras.csv`. I use it with the generated BOM to build the order.
