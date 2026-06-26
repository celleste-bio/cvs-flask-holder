# Repository Map

This document gives a practical map of the repository so it is easier to locate source code, generated artifacts, specifications, and publishing materials.

## Top-Level Layout

- `README.md`: project entry point and software stack overview.
- `documentation/`: project documentation and navigation aids.
- `source/`: parametric geometry source code in Lua (**Luametry**).
- `models/`: per-flask model definitions and generated STL/G-code outputs.
- `scripts/`: automation scripts for batch processing, slicing, and packaging.
- `specifications/`: source-backed manufacturer flask specifications.
- `artifacts/`: generated visual comparison outputs.
- `deployment/`: containerized build environment (Podman).
- `publications/`: paper manuscript and rendered assets.
- `distribution/`: **[gitignored]** packaged release bundles (created by `package_tarsons_pc_vented.sh`).
- `scratch/`: **[gitignored]** local development and debugging scratch files.

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
- `measurements.yaml`: source-of-truth dimensions and metadata.
- `flask.stl`: flask reference mesh (visualization only).
- `holder.stl`: printable holder in single-print layout.
- `holder.gcode`: sliced G-code for `holder.stl`.
- `holder_assembled.stl`: all pieces assembled (fit check).
- `holder_with_flask.stl`: holder assembled with flask inserted (combined fit check).
- `holder_part1.stl` / `holder_part1.gcode`: split-print part 1 — base plate + supports.
- `holder_part2.stl` / `holder_part2.gcode`: split-print part 2 — ruler plate + neck rest.
- `*.manifest.json`: traceability metadata (dimensions, commit ID).

## Scripts

### `scripts/`
- `model_all.sh`: batch generates all STL files for all models (flask, holder, assembled, with-flask, part1, part2).
- `slice_all.sh`: batch slices `holder.stl`, `holder_part1.stl`, and `holder_part2.stl` into G-code.
- `build_all.sh`: full end-to-end pipeline (model → slice → compare scenes).
- `render_all.sh`: regenerates only `holder.stl` for all models (subset of `model_all.sh`).
- `package_tarsons_pc_vented.sh`: bundles Tarsons release files into `distribution/`.
- `compare_*.scad`: legacy OpenSCAD visualization scripts for side-by-side comparison renders.
- `mk2s-machine.ini`: PrusaSlicer machine config for the MK2S bed shape and limits.

## Documentation

### `documentation/`
- `project-overview.md`: high-level architecture.
- `workflows.md`: standard operation procedures.
- `holder-traceability.md`: details on provenance engravings.
- `flask-id-index.md`: registry of flask and engraving IDs.
- `repo-map.md`: this file.
