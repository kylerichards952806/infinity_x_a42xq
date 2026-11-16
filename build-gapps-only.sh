#!/usr/bin/env bash
# GAPPS variant, same recipe that worked for VANILLA, plus ZIPOPT=-y so the OTA
# packaging step does not follow ROOT/d -> /sys/kernel/debug into the host.
set -eo pipefail

SRC=/root/infinity
cd "$SRC" || exit 1

echo "=== $(date -Is) configure gapps ==="
# shellcheck disable=SC1091
source build/envsetup.sh >/dev/null
export ZIPOPT=-y
export WITH_GAPPS=true
lunch infinity_a42xq-user

# Product config changes with WITH_GAPPS, so force kati/soong to regenerate the
# plan instead of reusing the VANILLA one.
touch device/samsung/a42xq/infinity_a42xq.mk

echo "=== $(date -Is) soong analysis + bacon (GAPPS) ==="
exec "$SRC/build/soong/soong_ui.bash" --make-mode bacon -j4
