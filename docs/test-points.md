# Test points

Applies to: v1

Where a signal has two test points, one is a test loop for the scope and the other is a test point (pin) for the multimeter, so both can be connected at the same time. The two points are the same net.

| Group | Test points | Measure with | Suggested type |
|---|---|---|---|
| Ground (22) | TP1, TP7, TP8, TP11, TP13, TP15, TP16, TP20, TP21, TP26, TP27, TP30, TP31, TP32, TP33, TP39, TP40, TP43, TP45, TP47, TP49, TP52 | scope ground clip, multimeter | Loop, black |
| Supply voltages | TP2 +UNREG, TP3 −UNREG, TP6 12V, TP12 5V | multimeter | Plain point |
| Supply rails with ripple check | TP4 and TP10 (+15V), TP5 and TP9 (−15V) | multimeter and scope | One loop and one plain point of each pair |
| Reference | TP14 VREF | multimeter (trim P7) | Plain point |
| DC levels | TP41 QB, TP42 COIL, TP48 POT | multimeter | Plain point |
| Digital signals | TP44 SYNC, TP46 CLK, TP36 Q3, TP37 Q2, TP38 Q1 | scope | Loop |
| X and Y | TP50 X, TP51 Y | scope | Loop |
| Both voltage and signal | TP17 and TP18 SIGN, TP22 and TP23 DAC, TP24 and TP25 EPATH, TP28 and TP29 GATE, TP34 and TP35 PUMP | scope and multimeter | One loop and one plain point of each pair |
| Sensitive node | TP19 PINV | scope, lightly | Loop; avoid loading it (virtual ground of U10B) |

