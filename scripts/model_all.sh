#!/bin/bash
set -e

find models -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
    measurements="$dir/measurements.yaml"

    if [ ! -f "$measurements" ]; then
        continue
    fi

    name=$(basename "$dir")
    echo "$name"

    lua source/flask.lua "$measurements" "$dir/flask.scad"
    lua source/holder.lua "$measurements" "$dir/holder.scad"
    lua source/holder.lua "$measurements" "$dir/holder_with_flask.scad" true
done
