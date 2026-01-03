#!/bin/bash

# Create the output directory if it does not exist
mkdir -p erlenmeyer_volumes

# Loop through the range from 0.5 to 6 with a step of 0.5
for height in $(seq 0 0.5 6)
do
    openscad -o erlenmeyer_volumes/volume_at_${height}cm.stl -D "height_cutoff=${height}" erlenmeyer_ruller/erlenmeyer_volume_ruller.scad
done