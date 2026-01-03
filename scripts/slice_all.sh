#!/bin/bash
set -e

# Profiles
PRINTER="Original Prusa MK4S HF0.4 nozzle"
PRINT_PROFILE="0.20mm SPEED @MK4S HF0.4"
MATERIAL="Generic PLA @MK4S HF0.4"

# Find all holder.stl files
grep_cmd="grep" # fallback if needed
# Find all holder.stl files in models/
find models -name "holder.stl" | sort | while read -r file; do
    # Extract size from directory name (e.g., models/100ml/holder.stl -> 100ml)
    dir=$(dirname "$file")
    size=$(basename "$dir")
    
    echo "----------------------------------------"
    echo "Slicing $size model from $file..."
    
    # Run prusa slicer
    # Note: --center 125,105 centers it on the MK4 bed (250x210)
    /home/bensiv/Apps/prusa3d_linux_2_8_1/PrusaSlicer-2.8.1+linux-x64-newer-distros-GTK3-202409181416.AppImage -g "$file" \
      -o "${dir}/holder.bgcode" \
      --printer-profile "$PRINTER" \
      --print-profile "$PRINT_PROFILE" \
      --material-profile "$MATERIAL" \
      --scale 10 \
      --fill-density 15% \
      --brim-width 5 \
      --center 125,105 \
      --binary-gcode
      
    echo "Exported to ${dir}/holder.bgcode"
done

echo "----------------------------------------"
echo "All slicing complete."
