# Holder Traceability

This document explains how holder provenance is encoded, how flask IDs are assigned, and how to trace a printed holder back to the exact modeled flask definition.

## Provenance Layers

Each holder is intended to carry two engraved identifiers:

- Git commit hash: identifies the code revision that generated the holder geometry
- `engraving_id`: identifies the intended flask model in a compact print-friendly format

The engraved flask code is short on purpose. The full source-of-truth identity and supporting metadata live in the corresponding `measurements.yaml` file.

## Metadata Layers

Each flask model should define these metadata fields in `measurements.yaml`:

- `flask_id`: full canonical identifier used for indexing and documentation
- `engraving_id`: compact identifier engraved on the holder
- `manufacturer`: source manufacturer or `Generic`
- `family_code`: normalized family grouping such as `erlenmeyer` or `cellculture`
- `variant_code`: normalized variant such as `open` or `vented`
- `capacity_ml`: nominal flask capacity in mL
- `revision`: revision number for the modeled measurement definition

Manufacturer-specific models can also include:

- `catalog_no`
- `product_line`
- `source_url`
- published source dimensions
- notes about modeling assumptions

## Why Two IDs Exist

A single full identifier is useful for indexing but often too long for clean engraving. A single short identifier is easy to engrave but too compressed to serve as the only documentation key.

Using both solves that tradeoff:

- `engraving_id` keeps the physical holder readable
- `flask_id` keeps the repository searchable and explainable

## Engraving ID Format

```text
{maker}{capacity}{variant}{revision}
```

Examples:

- `G250O1` = Generic, 250 mL, open, revision 1
- `T250V1` = Tarsons, 250 mL, vented, revision 1
- `T1KV1` = Tarsons, 1000 mL, vented, revision 1

See [flask-id-index.md](/root/cvs-flask-holder/documentation/flask-id-index.md) for the code tables and current registry.

## Canonical Full ID Format

```text
{manufacturer}-{family_code}-{capacity_ml}-{variant_code}-v{revision}
```

Examples:

- `generic-erlenmeyer-0250-open-v1`
- `tarsons-cellculture-0250-vented-v1`

The full ID is the durable repository key and should be used in manifests, release notes, and any future packaging metadata.

## Example

```yaml
flask_id: tarsons-cellculture-0250-vented-v1
engraving_id: T250V1
manufacturer: Tarsons
family_code: cellculture
variant_code: vented
capacity_ml: 250
revision: 1
catalog_no: 444220
```

## How To Trace A Printed Holder

1. Read the Git commit engraving from the holder.
2. Read the short `engraving_id` from the opposite side.
3. Look up the short ID in [flask-id-index.md](/root/cvs-flask-holder/documentation/flask-id-index.md).
4. Open the corresponding `models/.../measurements.yaml` file.
5. Use `flask_id`, source fields, and notes to recover the exact modeled flask definition.

## Authoring Rules

- Keep `engraving_id` short enough to print clearly.
- Keep `flask_id` descriptive and stable.
- Do not reuse an existing ID for different dimensions.
- Increment `revision` when modeled dimensions or dimensional interpretation change materially.
- Keep manufacturer source values and modeling assumptions separate when both are needed.

## Maintenance Workflow

When adding or revising a flask model:

1. Add or update the normalized metadata in `measurements.yaml`.
2. Assign a new `engraving_id` and `flask_id` if needed.
3. Update [flask-id-index.md](/root/cvs-flask-holder/documentation/flask-id-index.md).
4. Regenerate SCAD files so the physical engraving matches the metadata.
5. Regenerate downstream STL or toolpath artifacts as needed.
