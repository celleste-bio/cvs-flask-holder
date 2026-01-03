#!/bin/bash

# Exit on error
set -e

# List of volume directories
volumes=("100ml" "250ml" "500ml" "1000ml")

for vol in "${volumes[@]}"; do
    path="models/$vol"
    if [ -d "$path" ]; then
        echo "Rendering $path/holder.scad to $path/holder.stl..."
        openscad -o "$path/holder.stl" "$path/holder.scad"
    else
        echo "Warning: Directory $path not found."
    fi
done

echo "Batch rendering complete."
