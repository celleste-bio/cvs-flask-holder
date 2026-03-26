#!/bin/bash

# Exit on error
set -e

find models -mindepth 1 -maxdepth 1 -type d | sort | while read -r path; do
    if [ -f "$path/holder.scad" ]; then
        echo "Rendering $path/holder.scad to $path/holder.stl..."
        openscad -o "$path/holder.stl" "$path/holder.scad"
    fi
done

echo "Batch rendering complete."
