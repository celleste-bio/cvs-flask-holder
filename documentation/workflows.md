# Workflows

This document summarizes the main operational workflows for the repository.

## Model Authoring Workflow

1. Pick or create a model folder under `models/`.
2. Edit `measurements.yaml` with dimensions and metadata.
3. Assign `flask_id` and `engraving_id`.
4. Keep published source values and modeling assumptions separate when manufacturer data is incomplete.

## Geometry Generation Workflow

Use the batch generator:

```bash
./scripts/model_all.sh
```

This produces:

- `flask.scad`
- `holder.scad`
- `holder_with_flask.scad`

## Rendering Workflow

Render STL files from generated SCAD:

```bash
./scripts/render_all.sh
```

## Slicing Workflow

Generate printer toolpaths:

```bash
./scripts/slice_all.sh
```

## Full Build Workflow

Run the full generation pipeline:

```bash
./scripts/build_all.sh
```

This is the most convenient path when model definitions or generator logic changes.

## Packaging Workflow

For the tracked Tarsons vented family:

```bash
./scripts/package_tarsons_pc_vented.sh
```

This prepares a release bundle under `distribution/`.

## When To Regenerate Artifacts

Regenerate SCAD files when:

- `source/flask.lua` changes
- `source/holder.lua` changes
- any `measurements.yaml` changes
- engraving or provenance logic changes

Regenerate STL and slicing outputs when:

- geometry changes
- print settings change
- release bundles need refreshing
