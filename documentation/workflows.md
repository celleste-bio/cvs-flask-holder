# Workflows

This document summarizes the main operational workflows for the repository.

## Model Authoring Workflow

1. Pick or create a model folder under `models/`.
2. Edit `measurements.yaml` with dimensions and metadata.
3. Assign `flask_id` and `engraving_id`.
4. Keep published source values and modeling assumptions separate when manufacturer data is incomplete.

## Geometry Generation Workflow

Generate STL files directly from the parametric Lua scripts using the batch generator:

```bash
./scripts/model_all.sh
```

This uses **Luametry** to produce:
- `flask.stl` — flask reference mesh for visualization
- `holder.stl` — printable apparatus in single-print layout
- `holder_assembled.stl` — all pieces shown assembled (fit check)
- `holder_with_flask.stl` — holder assembled with flask inserted (combined fit check)
- `holder_part1.stl` — split-print part 1: base plate + both supports
- `holder_part2.stl` — split-print part 2: ruler plate + neck rest
- `*.manifest.json` — traceability metadata (dimensions, commit ID)

## Slicing Workflow

Generate printer toolpaths (G-code) from the STL files:

```bash
./scripts/slice_all.sh
```

This requires **PrusaSlicer** CLI (native install, Flatpak, or AppImage — the script auto-detects).

Default settings target the **Original Prusa i3 MK2S** at 215 °C / 55 °C with infill capped at 20 mm/s to stay within the hotend's volumetric flow limit. See [`print-parameters.md`](print-parameters.md) for the full rationale and a list of overridable environment variables.

## Full Build Workflow

Run the full pipeline to regenerate everything from scratch:

```bash
./scripts/build_all.sh
```
This is the recommended path after making changes to `source/` geometry or `measurements.yaml` definitions.

## Split-Print Workflow

For larger models (e.g. `2000ml`, `tarsons_pc_vented_2000ml`) that exceed the MK2S 250×210 mm build plate, the holder is split into two separate print jobs:

| File | Contents | Typical size |
|---|---|---|
| `holder_part1.stl` | Base plate + both angled supports | ≤ 241×213 mm |
| `holder_part2.stl` | Ruler plate + neck rest | ≤ 237×185 mm |

Both files are generated automatically by `model_all.sh` and sliced by `slice_all.sh`. They are produced for all models (even ones that fit in a single print) so the workflow is uniform.

To generate split parts for a single model manually:

```bash
CVS_MEASUREMENTS=models/2000ml/measurements.yaml CVS_PART=1 luametry export source/holder.lua -o holder_part1.stl
CVS_MEASUREMENTS=models/2000ml/measurements.yaml CVS_PART=2 luametry export source/holder.lua -o holder_part2.stl
```

## Packaging Workflow

For the tracked Tarsons vented family:

```bash
./scripts/package_tarsons_pc_vented.sh
```

This prepares a release bundle under `distribution/`.

## When To Regenerate Artifacts

Regenerate all artifacts when:

- `source/flask.lua` or `source/holder.lua` changes.
- any `measurements.yaml` definition is updated.
- Print settings (in `scripts/slice_all.sh`) change.
- A new release bundle is required.

*Note: Since the transition to Luametry, we no longer use SCAD intermediate files or separate rendering steps from SCAD.*
