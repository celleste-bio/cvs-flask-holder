#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RELEASE_DATE="${RELEASE_DATE:-$(date +%F)}"
OUTPUT_DIR="${1:-$HOME/documents/3d-models/release_${RELEASE_DATE}}"

usage() {
    cat <<'EOF'
Usage: ./scripts/distribute_bgcode.sh [output_dir]

Copy each model's holder BGCODE file into a release directory and rename it
using the short engraved model ID from measurements.yaml.

Defaults:
  output_dir: ~/documents/3d-models/release_<YYYY-MM-DD>

Environment:
  RELEASE_DATE   Override the date used in the default output directory name
EOF
}

yaml_get() {
    local key="$1"
    local file="$2"

    awk -F': *' -v key="$key" '$1 == key { print $2; exit }' "$file"
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

cd "$REPO_DIR"

if [ -e "$OUTPUT_DIR" ]; then
    echo "Output path already exists: $OUTPUT_DIR" >&2
    echo "Pass a new directory path or remove the existing release directory first." >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

find models -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
    measurements="$dir/measurements.yaml"
    bgcode="$dir/holder.bgcode"

    if [ ! -f "$measurements" ] || [ ! -f "$bgcode" ]; then
        continue
    fi

    short_id="$(yaml_get engraving_id "$measurements")"
    if [ -z "$short_id" ]; then
        echo "Skipping $(basename "$dir"): missing engraving_id in $measurements" >&2
        continue
    fi

    cp "$bgcode" "$OUTPUT_DIR/$short_id.bgcode"
    echo "Copied $(basename "$dir")/holder.bgcode -> $OUTPUT_DIR/$short_id.bgcode"
done

echo "Release directory created: $OUTPUT_DIR"
