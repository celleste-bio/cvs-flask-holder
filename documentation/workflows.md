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
- `flask.stl` (Visualization)
- `holder.stl` (Printable apparatus)
- `holder_with_flask.stl` (Combined fit check)
- `*.manifest.json` (Traceability metadata)

## Slicing Workflow

Generate printer toolpaths (G-code) from the STL files:

```bash
./scripts/slice_all.sh
```
This requires **PrusaSlicer** CLI.

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
