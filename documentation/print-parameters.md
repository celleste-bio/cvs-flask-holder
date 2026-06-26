# Print Parameters

Validated print settings for the CVS flask holder on the **Original Prusa i3 MK2S**.

## Hardware

| Parameter | Value |
|---|---|
| Printer | Original Prusa i3 MK2S |
| Nozzle | 0.4 mm E3D V6 |
| Firmware | 3.2.3 or later |

## Temperatures

| Parameter | Value |
|---|---|
| Nozzle | 215 °C |
| First layer nozzle | 215 °C |
| Bed | 55 °C |
| First layer bed | 55 °C |

## Layer & Geometry

| Parameter | Value |
|---|---|
| Layer height | 0.2 mm |
| First layer height | 0.2 mm |
| Infill density | 15% |
| Brim width | 8 mm |
| Perimeter count | 2 |

## Speeds

| Setting | Value | Volumetric flow |
|---|---|---|
| Perimeter | 25 mm/s | 2.25 mm³/s |
| External perimeter | 25 mm/s | 2.25 mm³/s |
| Small perimeter | 20 mm/s | 1.8 mm³/s |
| Infill | **20 mm/s** | **1.8 mm³/s** ✅ validated |
| Solid infill | 20 mm/s | 1.8 mm³/s |
| Bridge | 25 mm/s | — |
| Travel | 180 mm/s | — |
| First layer | 20 mm/s | 1.8 mm³/s |

Volumetric flow is calculated as `speed × 0.45 mm width × 0.2 mm height`.

### Why the 20 mm/s infill cap

The MK2S stock hotend (E3D V6, 0.4 mm nozzle) slips at PLA flows above ~1.8 mm³/s at 215 °C in practice. This was established by test printing:

| Infill speed | Volumetric flow | Result |
|---|---|---|
| 60 mm/s | 5.4 mm³/s | roller slip, jagged lines |
| 40 mm/s | 3.6 mm³/s | still slipping |
| 20 mm/s | 1.8 mm³/s | ✅ clean extrusion |

PrusaSlicer's default profile uses 60 mm/s infill; this must be overridden. The `slice_all.sh` script handles this automatically.

### M220 vs M221 — do not confuse them

When patching a GCode file manually to reduce speed:

- **Use `M220 Sxx`** (speed factor): scales XY movement and E extrusion together. The E/XY ratio stays correct, beads spread flat as designed.
- **Do not use `M221 Sxx`** (flow rate): reduces E output only while XY speed is unchanged. Beads become under-extruded — narrow, stringy, and not flattened to the layer height. On a tall print this causes the PINDA probe to scrape the object on travel moves.

Reference: stock Prusa files at 1800 mm/min (30 mm/s) / 0.15 mm layer height give ~2.0 mm³/s. At 0.2 mm layer height the equivalent is ~22 mm/s, consistent with the validated 20 mm/s limit above.

## Retraction

| Parameter | Value |
|---|---|
| Retraction length | 0.8 mm |
| Retraction speed | 35 mm/s |
| Lift on retract | 0.4 mm |

## Slicing Profile

The batch slicer (`scripts/slice_all.sh`) encodes these settings and applies them automatically. The following environment variables override the defaults:

```bash
PRINTER="Original Prusa i3 MK2S"      # PrusaSlicer printer profile name
PRINT_PROFILE="0.20mm NORMAL"          # PrusaSlicer print profile name
MATERIAL="Generic PLA"                 # PrusaSlicer filament profile name
NOZZLE_TEMP=215
BED_TEMP=55
INFILL_DENSITY="15%"
PERIMETER_SPEED=25
SMALL_PERIMETER_SPEED=20
EXTERNAL_PERIMETER_SPEED=25
INFILL_SPEED=20
BRIDGE_SPEED=25
```

Run slicing for all models:

```bash
./scripts/slice_all.sh
```

Or override a single variable for a one-off test:

```bash
NOZZLE_TEMP=220 ./scripts/slice_all.sh
```
