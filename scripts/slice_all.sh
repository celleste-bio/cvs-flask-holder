#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Profiles — see documentation/print-parameters.md for rationale
PRINTER="${PRINTER:-Original Prusa i3 MK2S}"
PRINT_PROFILE="${PRINT_PROFILE:-0.20mm NORMAL}"
MATERIAL="${MATERIAL:-Generic PLA}"
NOZZLE_TEMP="${NOZZLE_TEMP:-215}"
BED_TEMP="${BED_TEMP:-55}"
INFILL_DENSITY="${INFILL_DENSITY:-15%}"
BRIDGE_SPEED="${BRIDGE_SPEED:-25}"
PERIMETER_SPEED="${PERIMETER_SPEED:-25}"
SMALL_PERIMETER_SPEED="${SMALL_PERIMETER_SPEED:-20}"
EXTERNAL_PERIMETER_SPEED="${EXTERNAL_PERIMETER_SPEED:-25}"
# Cap infill at 20 mm/s — validated by test print; MK2S slips above ~1.8 mm³/s at 215 °C
INFILL_SPEED="${INFILL_SPEED:-20}"
FLATPAK_APP_ID="com.prusa3d.PrusaSlicer"

SLICER_CMD=()
SLICER_ARGS=()
SLICER_MODE=""
SLICER_ENV=()
SLICER_VENDOR_INI=""

resolve_locale() {
    if locale -a 2>/dev/null | grep -qx 'C\.utf8'; then
        SLICER_ENV=(env LC_ALL=C.utf8 LANG=C.utf8)
    else
        SLICER_ENV=(env LC_ALL=C.UTF-8 LANG=C.UTF-8)
    fi
}

resolve_slicer() {
    if [ -n "${PRUSASLICER:-}" ] && [ -x "$PRUSASLICER" ]; then
        SLICER_CMD=("$PRUSASLICER")
        SLICER_MODE="path"
        return 0
    fi

    for candidate in prusa-slicer PrusaSlicer prusaslicer; do
        if command -v "$candidate" >/dev/null 2>&1; then
            SLICER_CMD=("$(command -v "$candidate")")
            SLICER_MODE="path"
            return 0
        fi
    done

    if flatpak info "$FLATPAK_APP_ID" >/dev/null 2>&1; then
        SLICER_CMD=(flatpak run --command=prusa-slicer "$FLATPAK_APP_ID")
        SLICER_MODE="flatpak"
        return 0
    fi

    for candidate in \
        "$HOME/Applications/PrusaSlicer.AppImage" \
        "$HOME/Applications/PrusaSlicer-2.8.1.AppImage" \
        "$HOME/Downloads/PrusaSlicer.AppImage" \
        "$HOME/Downloads/PrusaSlicer-2.8.1.AppImage" \
        "/opt/PrusaSlicer.AppImage"
    do
        if [ -x "$candidate" ]; then
            SLICER_CMD=("$candidate")
            SLICER_MODE="path"
            return 0
        fi
    done

    return 1
}

ensure_flatpak_datadir() {
    local config_dir appdir

    config_dir="$HOME/.var/app/$FLATPAK_APP_ID/config/PrusaSlicer"
    appdir="$(flatpak info -l "$FLATPAK_APP_ID")"

    mkdir -p "$config_dir/vendor"

    SLICER_VENDOR_INI="$config_dir/vendor/PrusaResearch.ini"

    if [ ! -f "$SLICER_VENDOR_INI" ]; then
        cp -r "$appdir/files/share/PrusaSlicer/profiles/." "$config_dir/vendor/"
    fi

    if [ ! -f "$config_dir/PrusaSlicer.ini" ]; then
        cat > "$config_dir/PrusaSlicer.ini" <<EOF
[presets]
filament = $MATERIAL
physical_printer =
print = $PRINT_PROFILE
printer = $PRINTER
sla_material =
sla_print =
EOF
    fi

    # --datadir is sufficient; PrusaSlicer reads active presets from PrusaSlicer.ini automatically.
    # Do NOT pass --load with a vendor INI — that format is incompatible and silently breaks profiles.
    SLICER_ARGS=(--datadir "$config_dir")
}

ensure_path_datadir() {
    local config_dir vendor_dir

    config_dir="$HOME/.config/PrusaSlicer"
    vendor_dir="${PRUSASLICER_VENDOR_DIR:-/usr/share/PrusaSlicer/profiles}"
    SLICER_VENDOR_INI="$vendor_dir/PrusaResearch.ini"

    if [ ! -f "$SLICER_VENDOR_INI" ]; then
        echo "PrusaSlicer vendor profiles not found at $SLICER_VENDOR_INI" >&2
        echo "Set PRUSASLICER_VENDOR_DIR=/path/to/profiles containing PrusaResearch.ini." >&2
        exit 1
    fi

    mkdir -p "$config_dir/vendor"

    if [ ! -f "$config_dir/vendor/PrusaResearch.ini" ]; then
        cp -r "$vendor_dir/." "$config_dir/vendor/"
    fi

    # --datadir is sufficient; PrusaSlicer reads active presets from PrusaSlicer.ini automatically.
    # Do NOT pass --load with a vendor INI — that format is incompatible and silently breaks profiles.
    SLICER_ARGS=(--datadir "$config_dir")
}

resolve_slicer || {
    echo "PrusaSlicer CLI not found." >&2
    echo "Set PRUSASLICER=/path/to/PrusaSlicer.AppImage, install 'prusa-slicer' on PATH, or install Flatpak package com.prusa3d.PrusaSlicer." >&2
    exit 1
}

resolve_locale

if [ "$SLICER_MODE" = "flatpak" ]; then
    ensure_flatpak_datadir
else
    ensure_path_datadir
fi

slice_stl() {
    local file="$1" out="$2"
    "${SLICER_ENV[@]}" "${SLICER_CMD[@]}" "${SLICER_ARGS[@]}" -g "$file" \
      -o "$out" \
      --load "$SCRIPT_DIR/mk2s-machine.ini" \
      --scale 10 \
      --rotate 90 \
      --fill-density "$INFILL_DENSITY" \
      --brim-type no_brim \
      --skirts 0 \
      --temperature "$NOZZLE_TEMP" \
      --first-layer-temperature "$NOZZLE_TEMP" \
      --bed-temperature "$BED_TEMP" \
      --first-layer-bed-temperature "$BED_TEMP" \
      --bridge-speed "$BRIDGE_SPEED" \
      --perimeter-speed "$PERIMETER_SPEED" \
      --small-perimeter-speed "$SMALL_PERIMETER_SPEED" \
      --external-perimeter-speed "$EXTERNAL_PERIMETER_SPEED" \
      --infill-speed "$INFILL_SPEED" \
      --center 125,105 \
      --bed-shape 0x0,250x0,250x210,0x210
}

# Find all holder.stl files in models/
find models -name "holder.stl" | sort | while read -r file; do
    dir=$(dirname "$file")
    size=$(basename "$dir")
    echo "----------------------------------------"
    echo "Slicing $size model from $file..."
    slice_stl "$file" "${dir}/holder.gcode"
    echo "Exported to ${dir}/holder.gcode"
done



echo "----------------------------------------"
echo "All slicing complete."
