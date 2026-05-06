# Repository Map

This document gives a practical map of the repository so it is easier to locate source code, generated artifacts, specifications, and publishing materials.

## Top-Level Layout

- `README.md`: project entry point and software stack overview.
- `documentation/`: project documentation and navigation aids.
- `source/`: parametric geometry source code in Lua (**Luametry**).
- `models/`: per-flask model definitions and generated STL/G-code outputs.
- `scripts/`: automation scripts for batch processing, slicing, and packaging.
- `specifications/`: source-backed manufacturer flask specifications.
- `distribution/`: packaged release bundles.
- `artifacts/`: generated visual comparison outputs.
- `deployment/`: containerized build environment (Podman).
- `publications/`: paper manuscript and rendered assets.
- `dependencies/`: **[DEPRECATED]** Legacy submodules. Utilities are now integrated via `luam`.

## Source Code

### `source/`
Geometric logic evaluated by Luametry:
- `flask.lua`: flask reference geometry for visualization.
- `holder.lua`: printable holder geometry and engravings.
- `bootstrap.lua`: configures imports and environment.
- `flask_geom.lua`: shared geometry primitives.

## Model Definitions And Outputs

### `models/`
Each subdirectory represents a specific flask model.
- `measurements.yaml`: source-of-truth dimensions.
- `flask.stl`: direct Luametry mesh export.
- `holder.stl`: direct Luametry mesh export (printable).
- `holder.gcode`: sliced print output.
- `*.manifest.json`: metadata for traceability.

## Scripts

### `scripts/`
- `model_all.sh`: batch generates STL files for all models.
- `slice_all.sh`: batch slices all models into G-code.
- `build_all.sh`: full end-to-end build pipeline.
- `package_tarsons_pc_vented.sh`: bundles Tarsons release files.
- `compare_*.scad`: legacy OpenSCAD visualization scripts (use with caution).

## Documentation

### `documentation/`
- `project-overview.md`: high-level architecture.
- `workflows.md`: standard operation procedures.
- `holder-traceability.md`: details on provenance engravings.
- `flask-id-index.md`: registry of flask and engraving IDs.
- `repo-map.md`: this file.
