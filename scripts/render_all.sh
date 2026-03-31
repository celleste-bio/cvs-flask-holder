#!/bin/bash

# Exit on error
set -e

LUAMETRY_BIN="${LUAMETRY_BIN:-/home/bensiv/Projects/luametry/bin/luametry}"
if [ ! -x "$LUAMETRY_BIN" ]; then
    echo "Luametry binary not found at $LUAMETRY_BIN" >&2
    exit 1
fi

find models -mindepth 1 -maxdepth 1 -type d | sort | while read -r path; do
    measurements="$path/measurements.yaml"
    if [ -f "$measurements" ]; then
        echo "Rendering holder from $measurements..."
        CVS_MEASUREMENTS="$measurements" "$LUAMETRY_BIN" export source/holder.lua -o "$path/holder.stl"
    fi
done

echo "Batch rendering complete."
