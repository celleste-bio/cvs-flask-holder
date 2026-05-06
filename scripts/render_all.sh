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

find models -mindepth 1 -maxdepth 1 -type d | sort | while read -r path; do
    measurements="$path/measurements.yaml"
    if [ -f "$measurements" ]; then
        echo "Rendering holder from $measurements..."
        CVS_MEASUREMENTS="$measurements" CVS_COMMIT_ID="$COMMIT_ID" "$LUAMETRY_BIN" export source/holder.lua -o "$path/holder.stl"
    fi
done

echo "Batch rendering complete."
