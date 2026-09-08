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
