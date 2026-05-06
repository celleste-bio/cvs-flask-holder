# Project Overview

This repository contains a parametric CAD workflow for generating 3D-printable CVS (Cell Volume after Sedimentation) flask holders.

## Purpose

The holder fixes an Erlenmeyer flask at a repeatable tilt (60 degrees) so sedimented biomass forms a readable column along the flask wall. The geometry is driven from flask dimensions stored in per-model YAML files.

## Core Design Idea

A flask model is defined by measurements in `models/<model>/measurements.yaml`.

From that YAML:

- `source/flask.lua` defines the flask visualization geometry.
- `source/holder.lua` defines the printable holder geometry, including provenance engravings.
- scripts in `scripts/` batch-generate high-fidelity STL files and sliced G-code.

## Software Architecture

The project leverages a modern CAD stack:

- **[Luametry](https://github.com/BenSiv/luametry)**: The geometry engine that processes Lua source files.
- **[Manifold](https://github.com/elalish/manifold)**: The underlying C++ library providing robust and fast CSG (Constructive Solid Geometry) operations.
- **Direct Export**: Unlike traditional workflows that output SCAD files for OpenSCAD rendering, this implementation computes the mesh in-memory and exports STL files directly, reducing build times and improving precision.

## Main Data Flow

1. **Define**: Update `models/.../measurements.yaml` with physical dimensions.
2. **Compute & Export**: Run Luametry to evaluate the scripts and export STL meshes.
3. **Slice**: Process STL files through PrusaSlicer to generate printer-specific toolpaths (G-code).
4. **Package**: Bundle the final artifacts (STL, G-code, and JSON manifests) for release.

## Documentation Layout

- `project-overview.md`: what the repo does and how it is organized (this file).
- `holder-traceability.md`: provenance and engraving model.
- `flask-id-index.md`: registry of current short IDs and full IDs.
- `repo-map.md`: structure guide for the repository.
- `workflows.md`: practical generation and release workflow notes.

## Legacy Note
Previously, the project relied on OpenSCAD and local submodules (`lua-utils`, `lua-openscad`). These have been deprecated in favor of the integrated **Luametry** environment and built-in runtime utilities (`luam/lib/utils`).
