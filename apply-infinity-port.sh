#!/usr/bin/env bash
#
# Prepare a synced Project Infinity-X tree for the Galaxy A42 5G build.
#
# The device, vendor and kernel projects come from `repo sync` at the right
# revisions (device a42xq = infinity-x, vendor sm7225-common = infinity-24.0,
# blobs = android_vendor_samsung_a42xq), so this script installs the local
# manifest and the private release keys, then verifies the tree.
#
#   bash /mnt/c/a42/apply-infinity-port.sh
#
set -euo pipefail

SRC="${INFINITY_SRC:-/root/infinity}"
LOCAL="${LOCAL_TREES:-/mnt/c/a42}"
LINEAGE_TREE="${LINEAGE_TREE:-/root/android}"
KEYS_SRC="${KEYS_SRC:-$LINEAGE_TREE/vendor/lineage-priv/keys}"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
log() { printf '\n=== %s ===\n' "$*"; }

[ -d "$SRC/.repo" ] || die "no repo tree at $SRC"

log "Installing local manifest"
mkdir -p "$SRC/.repo/local_manifests"
cp -f "$LOCAL/local_manifests/a42xq-infinity.xml" "$SRC/.repo/local_manifests/a42xq.xml"
echo "wrote .repo/local_manifests/a42xq.xml (run: repo sync -c -j4)"

log "Copying private release keys"
KEY_DST="$SRC/vendor/infinity-priv/keys"
if [ ! -f "$KEY_DST/releasekey.pk8" ]; then
    [ -d "$KEYS_SRC" ] || die "private keys not found at $KEYS_SRC"
    mkdir -p "$KEY_DST"
    cp -a "$KEYS_SRC/." "$KEY_DST/"
    printf 'PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/infinity-priv/keys/releasekey\n' > "$KEY_DST/keys.mk"
    chmod 700 "$KEY_DST"
else
    echo "keys already present"
fi

log "Checking synced projects"
for p in device/samsung/a42xq device/samsung/sm7225-common \
         vendor/samsung/sm7225-common vendor/samsung/a42xq kernel/samsung/sm7225; do
    [ -d "$SRC/$p" ] || die "$p is missing - add the manifest entry and run repo sync"
    printf '%-32s %s\n' "$p" "$(git -C "$SRC/$p" log --oneline -1 2>/dev/null || echo 'not a git checkout')"
done

log "Checking the sm7225-common vendor symlinks"
V="$SRC/vendor/samsung/sm7225-common"
for f in Android.bp Android.mk BoardConfigVendor.mk sm7225-common-vendor.mk proprietary; do
    [ -e "$V/$f" ] || die "vendor/samsung/sm7225-common/$f does not resolve - the project is missing its tracked symlinks"
done
echo "Android.bp, Android.mk, BoardConfigVendor.mk, sm7225-common-vendor.mk, proprietary all resolve"

log "Checking the WebView prebuilt (Git LFS)"
WV="$SRC/external/chromium-webview/prebuilt/arm64/webview.apk"
WV_GOOD="$LINEAGE_TREE/external/chromium-webview/prebuilt/arm64/webview.apk"
if [ -f "$WV" ] && head -c 64 "$WV" | grep -q 'git-lfs.github.com/spec'; then
    echo "webview.apk is an unresolved LFS pointer, restoring the real APK"
    [ -f "$WV_GOOD" ] || die "webview.apk is an LFS pointer and no copy exists at $WV_GOOD"
    cp -f "$WV_GOOD" "$WV"
fi
[ -s "$WV" ] || die "webview.apk missing or empty - aapt2 will fail the build"
echo "webview.apk: $(stat -c %s "$WV") bytes"

log "Verifying the blob namespace"
grep -q 'PRODUCT_SOONG_NAMESPACES += vendor/samsung/a42xq' \
    "$SRC/device/samsung/a42xq/infinity_a42xq.mk" \
    || die "infinity_a42xq.mk does not point at vendor/samsung/a42xq"
grep -q 'infinity_a42xq.mk' "$SRC/device/samsung/a42xq/AndroidProducts.mk" \
    || die "AndroidProducts.mk does not list the Infinity product"
echo "ok"

log "Done - start the build with build-infinity-a42xq.sh"
