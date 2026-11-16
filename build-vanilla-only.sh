#!/usr/bin/env bash
# Build the VANILLA Infinity-X variant only (no GAPPS, no installclean pass).
set -eo pipefail

SRC=/root/infinity
cd "$SRC" || exit 1

echo "=== $(date -Is) configure vanilla ==="
# shellcheck disable=SC1091
source build/envsetup.sh >/dev/null
# OTA packaging must not follow ROOT/d -> /sys/kernel/debug into the host.
export ZIPOPT=-y
export WITH_GAPPS=false
lunch infinity_a42xq-user

echo "=== $(date -Is) running soong analysis + bacon ==="
exec "$SRC/build/soong/soong_ui.bash" --make-mode bacon -j4
