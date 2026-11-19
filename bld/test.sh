#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ -z "${LUAM_DIR:-}" ]; then
    LUAM_DIR="$(cd ../luam && pwd)"
fi

export LUA_PATH="${LUAM_DIR}/lib/?.lua;${LUAM_DIR}/lib/?/init.lua;;"
export LUA_CPATH="${LUAM_DIR}/lib/?.so;${LUAM_DIR}/lib/?/?.so;;"

echo "Checking Luam bytecode compilation..."
for f in source/*.lua dimensions/*.lua; do
    "$LUAM_DIR/bin/luamc" -p "$f"
done

echo "Running dimensions_analysis.lua..."
"$LUAM_DIR/bin/luam" dimensions/dimensions_analysis.lua >/dev/null

echo "Verifying existing STL model bounds..."
python3 source/tests/verify_models.py

LUAMETRY_BIN="${LUAMETRY_BIN:-}"
if [ -z "$LUAMETRY_BIN" ] && [ -x "../luametry/bin/luametry" ]; then
    LUAMETRY_BIN="$(cd ../luametry && pwd)/bin/luametry"
fi

if [ -n "$LUAMETRY_BIN" ] && [ -x "$LUAMETRY_BIN" ]; then
    echo "Testing live STL export with $LUAMETRY_BIN..."
    TMP_MODELS="$(mktemp -d)"
    trap 'rm -rf "$TMP_MODELS"' EXIT
    mkdir -p "$TMP_MODELS/100ml"
    cp models/100ml/measurements.yaml "$TMP_MODELS/100ml/measurements.yaml"
    CVS_MEASUREMENTS="$TMP_MODELS/100ml/measurements.yaml" CVS_COMMIT_ID="test123" "$LUAMETRY_BIN" export source/flask.lua -o "$TMP_MODELS/100ml/flask.stl"
    CVS_MEASUREMENTS="$TMP_MODELS/100ml/measurements.yaml" CVS_COMMIT_ID="test123" "$LUAMETRY_BIN" export source/holder.lua -o "$TMP_MODELS/100ml/holder.stl"
    CVS_MEASUREMENTS="$TMP_MODELS/100ml/measurements.yaml" CVS_COMMIT_ID="test123" CVS_ASSEMBLED=true "$LUAMETRY_BIN" export source/holder.lua -o "$TMP_MODELS/100ml/holder_assembled.stl"
    CVS_MEASUREMENTS="$TMP_MODELS/100ml/measurements.yaml" CVS_COMMIT_ID="test123" CVS_WITH_FLASK=true "$LUAMETRY_BIN" export source/holder.lua -o "$TMP_MODELS/100ml/holder_with_flask.stl"
    python3 source/tests/verify_models.py "$TMP_MODELS"
fi
