# CVS (Cell Volume after Sedimentation) Apparatus

Parametric Luametry implementations of the **CVS (Cell Volume after Sedimentation) Apparatus**.
 
This project provides a **parametric, 3D-printable model** of the CVS apparatus described by Mustafa et al. (2011). While the measurement method itself is established, this repository offers a flexible design that can be customized to fit any Erlenmeyer flask dimensions, optimizing it for 3D printing and laboratory use.

## Specification Tracking

Manufacturer-backed flask specification tracking lives in [specifications/erlenmeyer-specifications.csv](specifications/erlenmeyer-specifications.csv) with supporting notes in [specifications/erlenmeyer-spec-sources.md](specifications/erlenmeyer-spec-sources.md).

Project documentation lives in `documentation/`:

- [project-overview.md](documentation/project-overview.md)
- [repo-map.md](documentation/repo-map.md)
- [workflows.md](documentation/workflows.md)
- [holder-traceability.md](documentation/holder-traceability.md)
- [flask-id-index.md](documentation/flask-id-index.md)

Tracked flask lines:

- **Generic Erlenmeyer** (open rim) — reference dimensions for standard glass flasks
  - Modeled sizes: `100`, `250`, `500`, `1000`, `2000` mL
  - Model folders: `models/100ml` through `models/2000ml`

- **Tarsons** sterile flat-base polycarbonate Erlenmeyer cell culture flasks with vented HDPE closure
  - Source: https://www.tarsons.com/product/sterile-erlenmeyer-cell-culture-flask-flat-base-pc-with-vented-hdpe-closure/
  - Modeled sizes: `125`, `250`, `500`, `1000`, `2000` mL
  - Model folders: `models/tarsons_pc_vented_125ml` through `models/tarsons_pc_vented_2000ml`

## Scientific Context & Benefits

This apparatus holds Erlenmeyer flasks at a precise **60-degree angle**, transforming a standard flask into a precision measurement tool ("the poor man's real-time sensor").

### Why Use the 60° CVS Apparatus?
Standard flask markings are notoriously inaccurate (5-10% error margin) and designed for liquid volume, not biomass density. This apparatus offers three critical advantages:

#### 1. Amplified Resolution (The "Ruler" Effect)
**The Problem**: In a flat flask, sedimented cells spread in a thin, indistinguishable layer across the wide bottom.
**The 60° Solution**: By tilting the flask, cells are forced into the "corner" (junction of base and wall), concentrating the biomass into a tall column.
**Result**: A <1mm change in biomass (invisible on a flat bottom) becomes a **5–10mm change** along the angled wall, making it easily readable with a standard ruler.

#### 2. Consistency of "Packing"
**The Problem**: Cells form aggregates (clumps) that settle loosely and unevenly in vertical flasks due to friction.
**The 60° Solution**: This angle is the "goldilocks" tilt—steep enough for cells to slide to maximum packing density, but stable enough to prevent collapse.
**Result**: Ensures every measurement has uniform packing pressure, creating a **linear correlation to Fresh Weight (FW)**.

#### 3. Non-Destructive Monitoring
**The Problem**: Accurate biomass readings usually require transferring culture to a graduated cylinder or PCV tube, risking contamination and cell loss.
**The 60° Solution**: The apparatus measures the flask *as is*.
**Result**: **Zero contamination risk** and no lost cells. You can track the growth curve of the *exact same flask* throughout the entire cycle.

### Summary Comparison

| Feature | Erlenmeyer Markings | 60° CVS Apparatus |
| :--- | :--- | :--- |
| **Accuracy** | ± 10% (Approximate) | **High** (Correlates to Fresh Weight) |
| **Readability** | Very poor for thin layers | **High** (Vertical height is amplified) |
| **Contamination Risk** | Low | **Zero** (Flask remains sealed) |
| **Suitability** | Poor (Aggregates settle unevenly) | **Excellent** (Optimal packing) |

### Reference Material
> **Reference Paper:**
> Mustafa, N. R., de Winter, W., van Iren, F. & Verpoorte, R. (2011). **Initiation, growth and cryopreservation of plant cell suspension cultures**. *Nature Protocols*, 6(6), 715–742.

## Software Stack & Implementation

This project uses a modern parametric CAD stack based on Lua and the Manifold geometry library.

1.  **[Luam](https://github.com/BenSiv/luam)**: A modernized Lua dialect and runtime with local-by-default scoping and static building capabilities.
2.  **[Luametry](https://github.com/BenSiv/luametry)**: A professional, Lua-based parametric CAD tool. It provides the high-level API for defining 3D shapes.
3.  **[Manifold](https://github.com/elalish/manifold)**: A high-performance geometry library for topological robustness. Luametry uses Manifold for all Constructive Solid Geometry (CSG) operations (union, difference, intersection, hull).

### Direct STL Generation
Unlike older OpenSCAD workflows, this project generates STL files **directly** from Luametry. 
- **No SCAD intermediate files**: Geometry is computed and exported as high-fidelity STL meshes in one step.
- **Unified Utilities**: All shared logic and geometric utilities are integrated into the `luam` environment (e.g., `luam/lib/utils`). The legacy `dependencies/lua-utils` and `dependencies/lua-openscad` submodules are **no longer used**.

## Installation

### 1. Build Dependencies
Follow the build and installation instructions for:
- [Manifold](https://github.com/elalish/manifold) (Recommended: build as static library)
- [Luam](https://github.com/BenSiv/luam)
- [Luametry](https://github.com/BenSiv/luametry)

Ensure `luam` and `luametry` binaries are in your `PATH` (e.g., at `/usr/local/bin`).

### 2. Clone Repository
```bash
git clone https://github.com/BenSiv/cvs-flask-holder.git
cd cvs-flask-holder
```

## Repository Structure

- **`source/`**: Luametry scripts defining the parametric geometry.
    - `flask.lua`: Defines the flask reference shape.
    - `holder.lua`: Defines the printable holder apparatus.
- **`models/`**: Configuration and generated artifacts for specific flask sizes.
    - `measurements.yaml`: Flask dimensions and metadata (source of truth).
    - `flask.stl`: Flask reference mesh for visualization.
    - `holder.stl`: Printable holder in single-print layout.
    - `holder_assembled.stl`: All pieces shown assembled (fit check).
    - `holder_with_flask.stl`: Holder + flask combined (fit check).
    - `holder_part1.stl` / `holder_part2.stl`: Split-print layout for large models.
    - `holder.gcode` / `holder_part1.gcode` / `holder_part2.gcode`: Sliced toolpaths.
    - `*.manifest.json`: Traceability metadata.
- **`scripts/`**: Automation scripts for batch processing and build pipelines.

## Usage

### 1. Configure Dimensions
Edit the `measurements.yaml` in a model directory (e.g., `models/100ml/measurements.yaml`).

**Example:**
```yaml
total_height: 13.3
neck_height: 1.0
base_diameter: 8.0
neck_diameter: 3.7
```

### 2. Generate Models
Run the batch generator to export all STL files for all models:

```bash
./scripts/model_all.sh
```

Or export a single model manually:

```bash
CVS_MEASUREMENTS=models/100ml/measurements.yaml luametry export source/holder.lua -o models/100ml/holder.stl
```

For the full pipeline (models → slicing → comparison renders):

```bash
./scripts/build_all.sh
```

### 3. Fabrication
*   **Printer**: Original Prusa i3 MK2S, 0.4 mm nozzle, PLA.
*   **Slicer**: PrusaSlicer — use `scripts/slice_all.sh` for automated batch slicing.
*   **Print settings**: See [`documentation/print-parameters.md`](documentation/print-parameters.md) for validated temperatures, speeds, and the infill speed cap required by the MK2S hotend.

## License
MIT License. Copyright (c) 2026 Celleste Bio.
