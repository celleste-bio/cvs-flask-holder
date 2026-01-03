#!/bin/bash
set -e

IMAGE_NAME="cvs-holder-deployment"
SCRIPT_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(dirname "$SCRIPT_DIR")

echo "Building container image: $IMAGE_NAME..."
podman build -t "$IMAGE_NAME" -f "$SCRIPT_DIR/Containerfile" "$SCRIPT_DIR"

echo "Running shell in container..."
echo "Mounting: $ROOT_DIR -> /data"
podman run --rm -it \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --security-opt apparmor:unconfined \
    -v "$ROOT_DIR:/data" \
    "$IMAGE_NAME" /bin/bash
