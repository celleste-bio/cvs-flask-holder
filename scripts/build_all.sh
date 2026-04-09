#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPARE_OUTPUT_DIR="${COMPARE_OUTPUT_DIR:-$REPO_DIR/artifacts/compare}"
RUN_MODEL=1
RUN_RENDER=1
RUN_SLICE=1
RUN_COMPARE=1

usage() {
    cat <<'EOF'
Usage: ./scripts/build_all.sh [options]

Run the full holder pipeline:
  1. generate SCAD sources
  2. render holder STL files
  3. slice holder STL files to BGCODE
  4. render comparison scene PNG previews

Options:
  --no-model      Skip SCAD generation
  --no-render     Skip STL rendering
  --no-slice      Skip BGCODE slicing
  --no-compare    Skip comparison PNG generation
  -h, --help      Show this help text

Environment:
  COMPARE_OUTPUT_DIR   Output directory for comparison PNG files
  PRUSASLICER          Optional path to PrusaSlicer executable
  PRINTER              Optional slicer printer profile override
  PRINT_PROFILE        Optional slicer print profile override
  MATERIAL             Optional slicer material profile override
EOF
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Required command not found: $1" >&2
        exit 1
    fi
}

render_compare_scenes() {
    mkdir -p "$COMPARE_OUTPUT_DIR"

    find "$SCRIPT_DIR" -maxdepth 1 -type f -name 'compare*.scad' | sort | while read -r scene; do
        local output
        output="$COMPARE_OUTPUT_DIR/$(basename "${scene%.scad}").png"
        echo "Rendering comparison scene $(basename "$scene") -> $output"
        openscad \
            --autocenter \
            --viewall \
            --projection=o \
            --imgsize=2400,1800 \
            -o "$output" \
            "$scene"
    done
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --no-model)
            RUN_MODEL=0
            ;;
        --no-render)
            RUN_RENDER=0
            ;;
        --no-slice)
            RUN_SLICE=0
            ;;
        --no-compare)
            RUN_COMPARE=0
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

cd "$REPO_DIR"

if [ "$RUN_MODEL" -eq 1 ]; then
    require_command lua
    echo "==> Modeling all variants"
    "$SCRIPT_DIR/model_all.sh"
fi

if [ "$RUN_RENDER" -eq 1 ] || [ "$RUN_COMPARE" -eq 1 ]; then
    require_command openscad
fi

if [ "$RUN_RENDER" -eq 1 ]; then
    echo "==> Rendering all holder STL files"
    "$SCRIPT_DIR/render_all.sh"
fi

if [ "$RUN_SLICE" -eq 1 ]; then
    echo "==> Slicing all holder STL files"
    "$SCRIPT_DIR/slice_all.sh"
fi

if [ "$RUN_COMPARE" -eq 1 ]; then
    echo "==> Rendering comparison scenes"
    render_compare_scenes
fi

echo "==> Build pipeline complete"
