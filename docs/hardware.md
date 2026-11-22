# Hardware

Applies to: v1

Mechanical and off-board parts. Electrical parts are in the BOM generated on each release; parts that are not on a board are in `hardware/v1/bom/extras.csv`.

## Board mounting

All three boards use **M2** mounting holes: 4 on the DUT board, 4 on the Power Supply Board and 6 on the Logic Board, spread out over each board.

| Part | Spec | Notes |
|---|---|---|
| Screws | M2, length = standoff height + board thickness (1.6 mm) + nut | Pan head or cheese head |
| Nuts | M2 | One per screw if the standoffs are not threaded |
| Standoffs | 3D-printed stackable PCB standoffs, scaled to fit M2 holes | See below |

### Printing the stackable standoffs

The standoffs are a model by [theduckom](https://www.printables.com/@theduckom) (Stackable PCB Standoff on Printables), licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Sharing and commercial use are allowed with attribution, so the STL files may be included in this repository as long as the author is credited.

The model's author scaled it to fit M2 holes and recommends the following:

1. **Scale X and Y to 78 %.** Scale Z to 100 %, so the standoff height stays the same. (If you scale all axes uniformly, set the height back afterwards.)
2. **Wall order: outer/inner** (outer wall printed first). In the slicers this is called:
   - Bambu Studio / OrcaSlicer: *Wall printing order* → *Outer/inner*
   - PrusaSlicer / SuperSlicer: enable *External perimeters first*
   - Cura: enable *Outer Before Inner Walls*
3. Add a **dab of glue** between stacked pieces. Printed outer/inner the pieces fit together, but loosely; the glue holds the stack together enough to handle it.
4. With the usual inner/outer order most pieces would not fit together at 78 %, which is why the order matters here.

Before printing a full set, print one standoff and check that an M2 screw passes through and that two pieces stack. Different printers and slicers need slightly different tolerances, so you may need to change the scale by a few percent.

<!-- TODO: add the exact standoff height, number of stacked pieces per board and the total count once the PCBs are laid out. -->

## Enclosure

<!-- TODO: model, internal size, and whether the transformer, IEC inlet, boards and front panel fit. -->

- The enclosure is metal and bonded to protective earth (see [SAFETY.md](../SAFETY.md)).
- It has to hold a 30 VA 2 × 18 V toroidal transformer, the IEC C14 inlet with fuse holder and mains switch, three boards and the front panel.

## Connectors and wiring

| Ref | Part | Use |
|---|---|---|
| J2, J5 | JST XH S6B-XH-A, 6-pin | Board-to-board |
| J6, J7 | Molex Mini-Fit Jr 39-28-1043, 4-pin | Board-to-board |
| J8, J9, J10 | Phoenix 1718757, 3-pin | Transformer input and power between boards |
| J12 | ZIF socket 228-1277-00-0602J | Device under test |
| J13, J20 | TBL009V-254-03GY-2GY (alternative 0397000203) | Screw terminals on the DUT board |
| J14–J16 | Cal Test CT4397-08-x, 4 mm jack with 4.8 mm quick-connect | Banana jacks (colour by `-x` suffix) |

Mating housings, crimp terminals, ring lugs, quick-connect terminals, ferrules, wire and heat-shrink are listed in `hardware/v1/bom/extras.csv`. <!-- TODO: fill in extras.csv -->

Mains side: 0.75 mm² mains-rated wire, insulated crimp terminals with heat-shrink, strain relief. See [SAFETY.md](../SAFETY.md).

## Power

| Part | Spec |
|---|---|
| Transformer | 2 × 18 V toroidal, 30 VA (15 VA also works) |
| Mains inlet | IEC C14 with built-in fuse holder and mains switch |
| Mains fuse | T (slow-blow) 250 V, 250 mA for 30 VA (160 mA for 15 VA) |
| Rail fuses F1–F3 | 500 mA hold polyfuses, 30 V |
| Heatsinks | 4 on the voltage regulators (marked "Reg Heatsink" on the schematic) and 4 on the BD139 / BD140 output transistors |

## Front panel

Switches, potentiometers and legends are in [front-panel.md](front-panel.md). Knobs are sized to the shafts: <!-- TODO: shaft type and diameter of the chosen switches and the 10-turn pot P10 -->.
