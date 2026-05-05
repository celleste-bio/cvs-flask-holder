# Project Overview

This repository contains a parametric CAD workflow for generating 3D-printable CVS (Cell Volume after Sedimentation) flask holders.

## Purpose

The holder fixes an Erlenmeyer flask at a repeatable tilt so sedimented biomass forms a readable column along the flask wall. The geometry is driven from flask dimensions stored in per-model YAML files.

## Core Design Idea

A flask model is defined by measurements in `models/<model>/measurements.yaml`.

From that YAML:

- `source/flask.lua` generates a flask visualization model
- `source/holder.lua` generates the printable holder geometry
- scripts in `scripts/` batch-generate SCAD, STL, BGCODE, and release packages

## Main Data Flow

1. Define or update a flask model in `models/.../measurements.yaml`.
2. Generate SCAD files from the Lua geometry sources.
3. Render STL files from SCAD.
4. Slice toolpaths for printing.
5. Package release artifacts when needed.

## Documentation Layout

Project-level documentation now lives in `documentation/`:

- `project-overview.md`: what the repo does and how it is organized
- `holder-traceability.md`: provenance and engraving model
- `flask-id-index.md`: registry of current short IDs and full IDs
- `repo-map.md`: structure guide for the repository
- `workflows.md`: practical generation and release workflow notes

## Specifications Layout

The `specifications/` directory is reserved for flask specification sources and source-backed records such as:

- manufacturer-backed specification tables
- source capture notes
- future source-specific supporting material
