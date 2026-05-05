# Flask ID Index

This repository uses two ID layers for holder provenance:

- `engraving_id`: short code engraved on the holder
- `flask_id`: full canonical ID stored in `measurements.yaml`

The short code is optimized for readability and reliable printing. The full ID is optimized for indexing, search, and documentation.

## Engraving ID Format

```text
{maker}{capacity}{variant}{revision}
```

Examples:

- `G250O1` = Generic, 250 mL, open, revision 1
- `T250V1` = Tarsons, 250 mL, vented, revision 1
- `T1KV1` = Tarsons, 1000 mL, vented, revision 1

## Code Tables

### Maker Codes

- `G` = Generic or legacy reference flask
- `T` = Tarsons
- `D` = DWK
- `C` = Corning
- `H` = Thermo Fisher

### Capacity Codes

- `100`, `125`, `250`, `500` = capacity in mL
- `1K` = 1000 mL
- `2K` = 2000 mL
- `2P8K` = 2800 mL if needed in the future

### Variant Codes

- `O` = open rim
- `V` = vented cap
- `S` = solid or screw cap
- `B` = baffled

### Revision

The trailing number is the revision of the modeled measurement set.

- `1` = first tracked measurement definition
- `2` = updated measurement definition, same family and capacity

Increment the revision when the modeled dimensions or their interpretation change in a way that should remain traceable.

## Canonical Full ID Format

```text
{manufacturer}-{family_code}-{capacity_ml}-{variant_code}-v{revision}
```

Examples:

- `generic-erlenmeyer-0250-open-v1`
- `tarsons-cellculture-0250-vented-v1`

The full ID is the durable repo key. Use it in manifests, documentation, and any future packaging metadata.

## Current Registry

| Model Folder | Engraving ID | Full ID |
| :--- | :--- | :--- |
| `models/100ml` | `G100O1` | `generic-erlenmeyer-0100-open-v1` |
| `models/250ml` | `G250O1` | `generic-erlenmeyer-0250-open-v1` |
| `models/500ml` | `G500O1` | `generic-erlenmeyer-0500-open-v1` |
| `models/1000ml` | `G1KO1` | `generic-erlenmeyer-1000-open-v1` |
| `models/tarsons_pc_vented_125ml` | `T125V1` | `tarsons-cellculture-0125-vented-v1` |
| `models/tarsons_pc_vented_250ml` | `T250V1` | `tarsons-cellculture-0250-vented-v1` |
| `models/tarsons_pc_vented_500ml` | `T500V1` | `tarsons-cellculture-0500-vented-v1` |
| `models/tarsons_pc_vented_1000ml` | `T1KV1` | `tarsons-cellculture-1000-vented-v1` |
| `models/tarsons_pc_vented_2000ml` | `T2KV1` | `tarsons-cellculture-2000-vented-v1` |

## How To Trace A Printed Holder

1. Read the Git commit engraving and locate the code revision.
2. Read the short `engraving_id` and look it up in this index.
3. Open the matching `models/.../measurements.yaml` file.
4. Use `flask_id`, source fields, and notes to recover the exact modeled flask definition.

## Authoring Rules

- Keep `engraving_id` short enough to print clearly.
- Keep `flask_id` descriptive and stable.
- Do not recycle an existing ID for different dimensions.
- Bump the revision when measurements or modeling assumptions change materially.
