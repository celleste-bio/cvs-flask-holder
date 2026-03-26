# Erlenmeyer Specification Tracking

This repository now tracks manufacturer-backed Erlenmeyer flask specifications in [erlenmeyer-specifications.csv](/root/cvs-flask-holder/docs/erlenmeyer-specifications.csv).

## Primary Modeling Source

- Tarsons: Sterile Erlenmeyer Cell Culture Flask, Flat base, PC with vented HDPE Closure
  - URL: https://www.tarsons.com/product/sterile-erlenmeyer-cell-culture-flask-flat-base-pc-with-vented-hdpe-closure/
  - Sizes published on the product page: 125, 250, 500, 1000, 2000 mL
  - Published dimensions captured in the dataset: bottom outer diameter, inner neck diameter, height without closure, height with closure, closure finish
  - Metadata captured: plastic, capped, vented, threaded, sterile, autoclavable, flat-base

## Additional Manufacturer Resources

- DWK Life Sciences, PYREX narrow-neck glass flasks
  - URL: https://www.dwk.com/pyrex-flasks-conical-narrow-neck-125-ml-113008d
  - Useful for glass, rimmed/open, narrow-neck reference dimensions
  - Product page exposes body OD, neck ID, and height

- DWK Life Sciences, DURAN narrow-neck glass flasks
  - URL: https://www.dwk.com/duran-erlenmeyer-flask-narrow-neck-1000-ml-212165409
  - Useful for ISO-style borosilicate glass reference families and larger capacities
  - Product page confirms glass material and narrow-neck family; dimensions should be pulled from the live spec table when modeling a specific size

- Thermo Fisher Scientific, Nalgene single-use PETG Erlenmeyer flasks
  - URL: https://www.thermofisher.com/order/catalog/product/ar/en/4115-0500
  - Useful for plastic, threaded, capped plain-bottom families
  - Family page covers vented and solid caps across 125, 250, 500, 1000, 2000, and 2800 mL

- Corning polycarbonate Erlenmeyer flasks
  - URL: https://ecatalog.corning.com/life-sciences/b2c/US/en/Bioprocess-and-Scale-up/Erlenmeyer-Flasks/Erlenmeyer-Flasks-Plastic/Corning%C2%AE-Polycarbonate-Erlenmeyer-Flasks/p/431255
  - Useful for sterile disposable plastic flask families with vented and baffled variants
  - Family pages are good references for cap style, neck style, bottom style, sterility, and size availability

## Modeling Assumptions For Tarsons

Tarsons publishes `Inner Neck Diameter` and thread finish, but not the outer neck diameter required by this holder model. For the new Tarsons models:

- `total_height` uses the published `Height w/out closure`
- `base_diameter` uses the published `Bottom Outer Diameter`
- `neck_diameter` uses the published thread finish as the best available outer-neck proxy
- `neck_height` is an explicit modeling estimate and is marked as such in each `measurements.yaml`

If direct caliper measurements become available, update the Tarsons folders first and then regenerate the SCAD/STL outputs.
