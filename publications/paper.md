---
title: "Usage of CVS (Cell Volume after Sedimentation) Apparatus for High-Precision Biomass Measurement"
author:
- Celleste Bio
date: 2026-01-03
abstract: |
  We present a parametric OpenSCAD implementation of the Cell Volume after Sedimentation (CVS) apparatus originally described by @mustafa2011initiation. While the cell volume measurement method itself is established, our contribution is the provision of a fully customizable, 3D-printable model optimized for manufacturing and flexibility. This parametric design allows researchers to specify dimensions for any Erlenmeyer flask, ensuring the apparatus can be adapted to various laboratory glassware standards without requiring redesign.
bibliography: references.bib
csl: https://www.zotero.org/styles/nature
geometry:
  - margin=2cm
---

# Introduction

Accurate measurement of biomass in plant cell suspension cultures is critical for tracking growth and optimizing bioprocesses. The CVS method, involving a 60-degree tilted holder, was proposed by @mustafa2011initiation as a "poor man's real-time sensor" to transform a standard flask into a precision measurement tool.

We provide a parametric model of this apparatus. The goal is not to claim the invention of the method, but to facilitate its adoption by providing a robust, 3D-printable design that can be easily adapted to the specific dimensions of any flask available in the user's laboratory.

# Parametric Model Configuration

To ensure the apparatus fits the flask securely and provides accurate sedimentation angles, the model requires specific dimensions of the user's flask. These are defined in a YAML configuration file.

The required measurements are:

*   **`total_height`**: The absolute vertical height of the flask from base to the top of the rim.
*   **`neck_height`**: The length of the neck, including the rim.
*   **`base_diameter`**: The diameter of the widest part of the base.
*   **`neck_diameter`**: The diameter of the neck (measured below the rim).

The **`body_height`** (the conical section) is automatically derived as `total_height - neck_height`.

## Example Configuration (250ml Flask)

For a standard 250ml Erlenmeyer flask, the configuration would be:

```yaml
# 250ml Flask Dimensions
total_height: 13.3   # cm
neck_height: 1.0     # cm (includes rim)
base_diameter: 8.0   # cm
neck_diameter: 3.7   # cm (excludes rim)
```

# Principles and Benefits

The CVS apparatus holds flasks at a fixed 60-degree angle, offering three primary advantages over vertical sedimentation or flat-bottom estimation.

## Amplified Resolution
In a flat flask, sedimented cells spread in a thin, indistinguishable layer across the wide bottom, making small changes in biomass difficult to quantify. By tilting the flask, cells are forced into the junction of the base and the wall. This geometry concentrates the biomass into a tall column. A change in biomass that would result in a <1 mm height difference on a flat bottom translates to a 5–10 mm change along the angled wall, making it easily readable with a standard ruler.

## Consistency of Packing
Cells, particularly those of *Theobroma cacao* (cocoa), often form aggregates that settle loosely and unevenly in vertically oriented flasks due to friction and aggregation. The 60-degree angle provides an optimal tilt—steep enough for cells to slide to maximum packing density under gravity, yet stable enough to prevent collapse. This ensures that every measurement has uniform packing pressure, creating a strong linear correlation to Fresh Weight (FW).

## Non-Destructive Monitoring
A significant limitation of traditional sampling is the requirement to open the flask, which breaks the sterile barrier. The CVS apparatus allows for measurement of the flask *as is*. This results in zero contamination risk and no loss of cells, enabling the tracking of the growth curve of the exact same flask throughout the entire culture cycle.

# Comparison with Standard Methods

| Feature | Erlenmeyer Markings | 60° CVS Apparatus |
| :--- | :--- | :--- |
| **Accuracy** | ± 10% (Approximate) | **High** (Correlates to Fresh Weight) |
| **Readability** | Very poor for thin layers | **High** (Vertical height is amplified) |
| **Contamination Risk** | Low | **Zero** (Flask remains sealed) |
| **Suitability for Cocoa** | Poor (Aggregates settle unevenly) | **Excellent** (Optimal packing) |

# Fabrication

The models were optimized for fabrication using **Fused Deposition Modeling (FDM)** 3D printing. We utilized the **[Original Prusa MK4S](https://www.prusa3d.com/product/original-prusa-mk4s-3d-printer/)** 3D printer for its reliability and precision.

Preprocessing and slicing were performed using **[PrusaSlicer](https://www.prusa3d.com/page/prusaslicer_424/)**, which ensures optimal toolpath generation for structural integrity and print quality. The batch processing scripts provided in the repository utilize the PrusaSlicer CLI interface to automate the generation of G-code for multiple flask sizes.

# References
The apparatus described here serves as a supplementary tool to facilitate the handling of flasks described in the protocol by @mustafa2011initiation. Note that this tool is not the invention claimed in the cited patent (US Patent 5,965,438), which relates to the cryopreservation method itself.

