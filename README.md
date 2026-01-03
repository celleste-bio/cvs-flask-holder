# CVS (Cell Volume after Sedimentation) Apparatus

Parametric OpenSCAD implementations of the **CVS (Cell Volume after Sedimentation) Apparatus**.
 
This project provides a **parametric, 3D-printable model** of the CVS apparatus described by [Mustafa et al. (2011)](docs/Initiation_growth_and_cryopreservation_of_plant_ce.pdf). While the measurement method itself is established, this repository offers a flexible design that can be customized to fit any Erlenmeyer flask dimensions, optimizing it for 3D printing and laboratory use.

## Scientific Context & Benefits

This apparatus holds Erlenmeyer flasks at a precise **60-degree angle**, transforming a standard flask into a precision measurement tool ("the poor man's real-time sensor").

### Why Use the 60° CVS Apparatus?
Standard flask markings are notoriously inaccurate (5-10% error margin) and designed for liquid volume, not biomass density. This apparatus offers three critical advantages:

#### 1. Amplified Resolution (The "Ruler" Effect)
**The Problem**: In a flat flask, sedimented cells spread in a thin, indistinguishable layer across the wide bottom.
**The 60° Solution**: By tilting the flask, cells are forced into the "corner" (junction of base and wall), concentrating the biomass into a tall column.
**Result**: A <1mm change in biomass (invisible on a flat bottom) becomes a **5–10mm change** along the angled wall, making it easily readable with a standard ruler.

#### 2. Consistency of "Packing"
**The Problem**: Cells (especially cocoa) form aggregates (clumps) that settle loosely and unevenly in vertical flasks due to friction.
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
| **Suitability for Cocoa** | Poor (Aggregates settle unevenly) | **Excellent** (Optimal packing) |

### Reference Material
> **Reference Paper:**
> Mustafa, N. R., de Winter, W., van Iren, F. & Verpoorte, R. (2011). **Initiation, growth and cryopreservation of plant cell suspension cultures**. *Nature Protocols*, 6(6), 715–742.

A copy of the reference paper is available in the `docs/` directory:
- [files/Initiation_growth_and_cryopreservation_of_plant_ce.pdf](docs/Initiation_growth_and_cryopreservation_of_plant_ce.pdf)

*Note: The apparatus provided here is a supplementary tool to facilitate the handling of flasks described in the protocol. It is not the invention claimed in the cited patent (US Patent 5,965,438), which relates to the cryopreservation method itself.*

## Prerequisites

To use and generate these models, you need:
1.  **Lua** (5.1 or later)
2.  **OpenSCAD** (for rendering)
3.  **Git** (to manage dependencies)

## Installation

Clone the repository and initialize the submodules:

```bash
git clone <repository-url>
cd erlenmeyer-holders
git submodule update --init --recursive
```

This will pull the necessary dependencies (`lua-utils` and `lua-openscad`) into the `deps/` directory.

## Deployment / Reproduction

To ensure a consistent environment for generating models and documentation, we provide a **Podman** container configuration.

### 1. Build and Run Container
Use the provided helper script to build the image and enter the container shell:

```bash
./deployment/build_and_run.sh
```

### 2. Run Tasks Inside Container
Once inside the container (which mounts the current directory to `/data`), you can run the standard workflows:

**Generate Models:**
```bash
./scripts/model_all.sh
```

**Generate Documentation (PDF):**
```bash
cd publication
make
```

**Slice Models (Generates G-code):**
```bash
./scripts/slice_all.sh
```
*(Note: The container includes a PrusaSlicer AppImage)*

## Repository Structure

- **`src/`**: Lua scripts replaced `parametric/` that define the parametric 3D geometry.
    - `flask.lua`: Generates the flask shape.
    - `holder.lua`: Generates the holder apparatus.
- **`scripts/`**: Helper shell scripts for batch processing.
- **`models/`**: Contains configuration and generated files for specific flask sizes.
    - **`[size]ml/`** (e.g., `100ml/`, `250ml/`):
        - `measurements.yaml`: Definition of flask dimensions.
        - `*.scad`: Generated OpenSCAD files.
- **`publication/`**: Files for generating the scientific paper documentation (PDF).
- **`docs/`**: Documentation and reference papers.
- **`deps/`**: Local dependencies (submodules).

## Publication
 
A scientific paper format of this documentation is available in the `publication/` directory. To generate the PDF:
 
```bash
cd publication
make
```

## Fabrication

We recommend the following equipment and software, which were used to validate the models:

*   **Printer**: [Original Prusa MK4S](https://www.prusa3d.com/product/original-prusa-mk4s-3d-printer/)
*   **Slicer**: [PrusaSlicer](https://www.prusa3d.com/page/prusaslicer_424/)

The provided `slice_all.sh` script is configured for PrusaSlicer CLI.

## Usage

### 1. Configure Dimensions
### 1. Configure Dimensions
Edit the `measurements.yaml` file in the desired size folder (e.g., `100ml/measurements.yaml`) to match your specific flask dimensions.

**Required Measurements:**

- **`total_height`**: Absolute height from base to top of rim.
- **`neck_height`**: Length of the neck (including the rim).
- **`base_diameter`**: Diameter of the base at its widest point.
- **`neck_diameter`**: Diameter of the neck (excluding the rim).

*(Note: `body_height` is automatically calculated as `total_height - neck_height`)*

**Example (250ml Flask):**

```yaml
total_height: 13.3  # cm
neck_height: 1.0    # cm (with rim)
base_diameter: 8.0  # cm
neck_diameter: 3.7  # cm (without rim)
```

### 2. Generate Models
Use Lua to run the parametric scripts.

**Generate a Flask Model:**
```bash
lua parametric/flask.lua 100ml/measurements.yaml 100ml/flask.scad
```

**Generate a Holder Model:**
```bash
lua parametric/holder.lua 100ml/measurements.yaml 100ml/holder.scad
```

**Generate a Holder with Flask Visualization:**
```bash
# The 'true' argument adds a visual ghost of the flask to check fit
lua parametric/holder.lua 100ml/measurements.yaml 100ml/holder_with_flask.scad true
```

### 3. Batch Processing
Use the provided shell scripts (ensure they are executable: `chmod +x *.sh`):

- **Generate All SCAD Files**:
  ```bash
  ./model_all.sh
  ```
- **Render All to STL**:
  ```bash
  ./render_all.sh
  ```
- **Slice All** (Requires PrusaSlicer CLI configuration):
  ```bash
  ./slice_all.sh
  ```

## License

**MIT License**

Copyright (c) 2026 Celleste Bio

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
