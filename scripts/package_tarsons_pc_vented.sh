#!/bin/bash
set -euo pipefail

PACKAGE_DATE="$(date +%F)"
PACKAGE_BASENAME="tarsons_pc_vented_release_${PACKAGE_DATE}"
OUTPUT_DIR="${1:-distribution/${PACKAGE_BASENAME}}"
MODEL_GLOB="models/tarsons_pc_vented_*ml"
SOURCE_CSV="specifications/erlenmeyer-specifications.csv"
SOURCE_NOTES="specifications/erlenmeyer-spec-sources.md"

yaml_get() {
    local key="$1"
    local file="$2"

    awk -F': *' -v key="$key" '$1 == key { print $2; exit }' "$file"
}

csv_escape() {
    local value="$1"
    value="${value//\"/\"\"}"
    printf '"%s"' "$value"
}

if [ -e "$OUTPUT_DIR" ]; then
    echo "Output path already exists: $OUTPUT_DIR" >&2
    echo "Pass a new directory path or remove the existing package first." >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR/models"

PACKAGE_README="$OUTPUT_DIR/README.md"
PACKAGE_MANIFEST="$OUTPUT_DIR/manifest.csv"
PACKAGE_SPECS="$OUTPUT_DIR/source-specifications.csv"

cat > "$PACKAGE_MANIFEST" <<'EOF'
model_id,manufacturer,product_line,catalog_no,capacity_ml,source_url,source_height_without_closure_mm,source_bottom_outer_diameter_mm,source_inner_neck_diameter_mm,source_closure_size,modeled_total_height_cm,modeled_base_diameter_cm,modeled_neck_height_cm,modeled_neck_diameter_cm,holder_stl,holder_gcode,status,notes
EOF

cat > "$PACKAGE_README" <<EOF
# Tarsons PC Vented Flask Holder Package

This package contains the final printable holder files for the modeled **Tarsons sterile flat-base polycarbonate Erlenmeyer cell culture flasks with vented HDPE closure** family.

## Provenance

- Manufacturer: Tarsons
- Product line: Sterile Erlenmeyer Cell Culture Flask Flat Base PC with vented HDPE Closure
- Primary source: https://www.tarsons.com/product/sterile-erlenmeyer-cell-culture-flask-flat-base-pc-with-vented-hdpe-closure/
- Package date: ${PACKAGE_DATE}
- Repository source files copied into this package:
  - \`source-specifications.csv\`
  - \`source-specifications-notes.md\`
  - per-model \`measurements.yaml\`

## Included Models

| Model ID | Catalog No. | Capacity (mL) | Manufacturer | STL | GCODE | Notes |
| :--- | :--- | ---: | :--- | :---: | :---: | :--- |
EOF

{
    head -n 1 "$SOURCE_CSV"
    awk -F, 'NR > 1 && $1 ~ /^tarsons_pc_vented_/ { print }' "$SOURCE_CSV"
} > "$PACKAGE_SPECS"

cp "$SOURCE_NOTES" "$OUTPUT_DIR/source-specifications-notes.md"

for dir in $MODEL_GLOB; do
    if [ ! -d "$dir" ]; then
        continue
    fi

    model_id="$(basename "$dir")"
    measurements_file="$dir/measurements.yaml"
    model_output_dir="$OUTPUT_DIR/models/$model_id"

    manufacturer="$(yaml_get manufacturer "$measurements_file")"
    product_line="$(yaml_get product_line "$measurements_file")"
    catalog_no="$(yaml_get catalog_no "$measurements_file")"
    capacity_ml="$(yaml_get capacity_ml "$measurements_file")"
    source_url="$(grep '^# source_url:' "$measurements_file" | sed 's/^# source_url: //')"
    source_height="$(yaml_get source_height_without_closure_mm "$measurements_file")"
    source_base="$(yaml_get source_bottom_outer_diameter_mm "$measurements_file")"
    source_inner_neck="$(yaml_get source_inner_neck_diameter_mm "$measurements_file")"
    source_closure_size="$(yaml_get source_closure_size "$measurements_file")"
    total_height="$(yaml_get total_height "$measurements_file")"
    base_diameter="$(yaml_get base_diameter "$measurements_file")"
    neck_height="$(yaml_get neck_height "$measurements_file")"
    neck_diameter="$(yaml_get neck_diameter "$measurements_file")"

    status="stl_only"
    gcode_rel=""
    notes="No sliced GCODE included in this package."

    if [ -f "$dir/holder.gcode" ]; then
        status="sliced"
        gcode_rel="models/$model_id/holder.gcode"
        notes="Sliced with PrusaSlicer for the MK3 workflow tracked in this repository."
    elif [ "$model_id" = "tarsons_pc_vented_2000ml" ]; then
        notes="STL included, but no GCODE is packaged because the current MK3 slicing workflow reported that the object is outside the configured print volume."
    fi

    mkdir -p "$model_output_dir"
    cp "$measurements_file" "$model_output_dir/"
    cp "$dir/flask.stl" "$model_output_dir/"
    cp "$dir/holder.stl" "$model_output_dir/"
    cp "$dir/holder_with_flask.stl" "$model_output_dir/"

    if [ -f "$dir/holder.gcode" ]; then
        cp "$dir/holder.gcode" "$model_output_dir/"
    fi

    printf '| `%s` | `%s` | %s | %s | yes | %s | %s |\n' \
        "$model_id" \
        "$catalog_no" \
        "$capacity_ml" \
        "$manufacturer" \
        "$( [ -f "$dir/holder.gcode" ] && printf 'yes' || printf 'no' )" \
        "$notes" >> "$PACKAGE_README"

    {
        csv_escape "$model_id"; printf ','
        csv_escape "$manufacturer"; printf ','
        csv_escape "$product_line"; printf ','
        csv_escape "$catalog_no"; printf ','
        csv_escape "$capacity_ml"; printf ','
        csv_escape "$source_url"; printf ','
        csv_escape "$source_height"; printf ','
        csv_escape "$source_base"; printf ','
        csv_escape "$source_inner_neck"; printf ','
        csv_escape "$source_closure_size"; printf ','
        csv_escape "$total_height"; printf ','
        csv_escape "$base_diameter"; printf ','
        csv_escape "$neck_height"; printf ','
        csv_escape "$neck_diameter"; printf ','
        csv_escape "models/$model_id/holder.stl"; printf ','
        csv_escape "$gcode_rel"; printf ','
        csv_escape "$status"; printf ','
        csv_escape "$notes"; printf '\n'
    } >> "$PACKAGE_MANIFEST"
done

cat >> "$PACKAGE_README" <<'EOF'

## File Layout

- `manifest.csv`: machine-readable release manifest mapping each final file to manufacturer metadata and source dimensions
- `source-specifications.csv`: filtered copy of the repository specification tracker for this Tarsons family
- `source-specifications-notes.md`: modeling notes describing what was published by the manufacturer and what remains an assumption
- `models/<model_id>/measurements.yaml`: per-model dimension record with source and assumption fields
- `models/<model_id>/flask.stl`: printable flask geometry
- `models/<model_id>/holder.stl`: printable holder geometry
- `models/<model_id>/holder_with_flask.stl`: combined preview geometry
- `models/<model_id>/holder.gcode`: sliced print file when available

## Interpretation Notes

- `source_height_without_closure_mm` and `source_bottom_outer_diameter_mm` come directly from the Tarsons product page.
- `neck_diameter` and `neck_height` in the model are explicit modeling assumptions tracked in `measurements.yaml`.
- The 2000 mL model is included as geometry and metadata, but is not packaged with GCODE because the current MK3 slicing setup does not fit it inside the configured print volume.
EOF

tar -C "$(dirname "$OUTPUT_DIR")" -czf "${OUTPUT_DIR}.tar.gz" "$(basename "$OUTPUT_DIR")"

echo "Package directory created: $OUTPUT_DIR"
echo "Compressed archive created: ${OUTPUT_DIR}.tar.gz"
