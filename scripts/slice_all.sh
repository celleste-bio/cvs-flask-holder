#!/bin/bash
set -e

# Profiles
PRINTER="${PRINTER:-Original Prusa MK4 0.4 nozzle}"
PRINT_PROFILE="${PRINT_PROFILE:-0.20mm SPEED @MK4 0.4}"
MATERIAL="${MATERIAL:-Generic PLA @PG}"
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

    SLICER_ARGS=(--datadir "$config_dir" --load "$SLICER_VENDOR_INI")
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

    cat > "$config_dir/PrusaSlicer.ini" <<EOF
[presets]
filament = $MATERIAL
physical_printer =
print = $PRINT_PROFILE
printer = $PRINTER
sla_material =
sla_print =
EOF

    SLICER_ARGS=(--datadir "$config_dir" --load "$config_dir/vendor/PrusaResearch.ini")
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

# Find all holder.stl files in models/
find models -name "holder.stl" | sort | while read -r file; do
    # Extract size from directory name (e.g., models/100ml/holder.stl -> 100ml)
    dir=$(dirname "$file")
    size=$(basename "$dir")
    
    echo "----------------------------------------"
    echo "Slicing $size model from $file..."

    "${SLICER_ENV[@]}" "${SLICER_CMD[@]}" "${SLICER_ARGS[@]}" -g "$file" \
      -o "${dir}/holder.gcode" \
      --scale 10 \
      --fill-density 15% \
      --brim-width 5 \
      --center 125,105
    #   --binary-gcode
      
    echo "Exported to ${dir}/holder.gcode"
done

echo "----------------------------------------"
echo "All slicing complete."
