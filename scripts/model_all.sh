#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -z "${LUAMETRY_BIN:-}" ]; then
    if command -v luametry >/dev/null 2>&1; then
        LUAMETRY_BIN="$(command -v luametry)"
    else
        LUAMETRY_BIN="$HOME/projects/luametry/bin/luametry"
    fi
fi

if [ ! -x "$LUAMETRY_BIN" ]; then
    echo "Luametry binary not found at $LUAMETRY_BIN" >&2
    exit 1
fi

cd "$REPO_DIR"

COMMIT_ID="$(git -C "$REPO_DIR" rev-parse --short=7 HEAD 2>/dev/null || printf 'manual')"

find models -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
    measurements="$dir/measurements.yaml"

    if [ ! -f "$measurements" ]; then
        continue
    fi

    name=$(basename "$dir")
    echo "$name"

    CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" "$LUAMETRY_BIN" export source/flask.lua -o "$dir/flask.stl"
    CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" "$LUAMETRY_BIN" export source/holder.lua -o "$dir/holder.stl"
    CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" CVS_ASSEMBLED=true "$LUAMETRY_BIN" export source/holder.lua -o "$dir/holder_assembled.stl"
    CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" CVS_WITH_FLASK=true "$LUAMETRY_BIN" export source/holder.lua -o "$dir/holder_with_flask.stl"
    CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" CVS_PART=1 "$LUAMETRY_BIN" export source/holder.lua -o "$dir/holder_part1.stl"
    CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" CVS_PART=2 "$LUAMETRY_BIN" export source/holder.lua -o "$dir/holder_part2.stl"
    CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" CVS_PART=3 "$LUAMETRY_BIN" export source/holder.lua -o "$dir/holder_part3.stl"
done
