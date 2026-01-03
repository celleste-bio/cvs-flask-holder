#!/bin/bash

# Exit on error
set -e

# List of volume directories
volumes=("100ml" "250ml" "500ml" "1000ml" "2000ml")

for vol in "${volumes[@]}"; do
    if [ -d "$vol" ]; then
        echo "Rendering $vol/holder.scad to $vol/holder.stl..."
        openscad -o "$vol/holder.stl" "$vol/holder.scad"
    else
        echo "Warning: Directory $vol not found."
    fi
done

echo "Batch rendering complete."
