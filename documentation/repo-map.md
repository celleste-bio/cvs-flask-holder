# Repository Map

This document gives a practical map of the repository so it is easier to locate source code, generated artifacts, specifications, and publishing materials.

## Top-Level Layout

- `README.md`: short project entry point
- `documentation/`: project documentation and navigation aids
- `source/`: parametric geometry source code in Lua
- `models/`: per-flask model definitions and generated outputs
- `scripts/`: batch generation, rendering, slicing, comparison, and packaging helpers
- `specifications/`: source-backed flask specification records
- `distribution/`: packaged release outputs
- `artifacts/`: generated comparison images and similar derived outputs
- `deployment/`: containerized build environment helpers
- `publications/`: paper manuscript, references, and rendered publication assets
- `dimensions/`: exploratory dimensional analysis inputs and notes
- `dependencies/`: vendored or submodule dependencies used by the geometry code

## Source Code

### `source/`

- `flask.lua`: builds the flask reference geometry used for visualization and fit checks
- `holder.lua`: builds the printable holder geometry and engravings

## Model Definitions And Outputs

### `models/`

Each subdirectory represents one flask model.

Typical contents:

- `measurements.yaml`: source-of-truth dimensions and metadata
- `flask.scad`: generated flask geometry
- `holder.scad`: generated holder geometry
- `holder_with_flask.scad`: generated holder plus flask visualization
- `holder.stl`: rendered printable mesh
- `holder.bgcode`: sliced print output

Current families include:

- generic open Erlenmeyer reference sizes
- Tarsons vented cell culture flasks

## Scripts

### `scripts/`

Operational entry points:

- `model_all.sh`: generate SCAD for all models
- `render_all.sh`: render STL files
- `slice_all.sh`: slice print jobs
- `build_all.sh`: run the full main pipeline
- `package_tarsons_pc_vented.sh`: create Tarsons release packages

Comparison scenes:

- `compare_all.scad`
- `compare_classic_open.scad`
- `compare_tarsons_pc_vented.scad`
- `compare_tarsons_pc_vented_small.scad`
- `compare_tarsons_pc_vented_large.scad`

## Documentation

### `documentation/`

- `project-overview.md`: project-level orientation
- `workflows.md`: build and maintenance workflows
- `holder-traceability.md`: holder provenance model
- `flask-id-index.md`: short-ID registry and decoding table
- `repo-map.md`: this file

## Specifications

### `specifications/`

This directory is reserved for specification material and source-backed records:

- `erlenmeyer-specifications.csv`: tracked manufacturer or source rows
- `erlenmeyer-spec-sources.md`: notes about where each specification came from

## Publication Material

### `publications/`

- `paper.md`: manuscript source
- `references.bib`: bibliography
- `paper.pdf`: built paper output
- `images/`: paper figures

## Build Environment

### `deployment/`

- `Containerfile`: reproducible container definition
- `build_and_run.sh`: helper to enter the build environment

## Derived Output Areas

### `artifacts/`

Stores generated visual comparison outputs.

### `distribution/`

Stores packaged release bundles prepared for sharing or fabrication handoff.
