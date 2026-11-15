#!/usr/bin/env bash
#
# Apply the a42xq port on top of a synced Project Infinity-X tree.
# Run inside WSL after `repo sync` has fetched the device/kernel/vendor projects:
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

log "Overlaying the built LineageOS tree changes (git metadata preserved)"
[ -d "$LINEAGE_TREE/device/samsung/a42xq" ] || die "no Lineage tree at $LINEAGE_TREE"
[ -d "$SRC/device/samsung/a42xq" ] || die "device/samsung/a42xq not synced"
[ -d "$SRC/device/samsung/sm7225-common" ] || die "device/samsung/sm7225-common not synced"
[ -d "$SRC/vendor/samsung/sm7225-common" ] || die "vendor/samsung/sm7225-common not synced"
rsync -a --exclude=.git "$LINEAGE_TREE/device/samsung/a42xq/" "$SRC/device/samsung/a42xq/"
rsync -a --exclude=.git "$LINEAGE_TREE/device/samsung/sm7225-common/" "$SRC/device/samsung/sm7225-common/"
rsync -a --exclude=.git --exclude=a42xq "$LINEAGE_TREE/vendor/samsung/sm7225-common/" "$SRC/vendor/samsung/sm7225-common/"
# a42xq blobs are their own PRIVATE project, checked out at a real path.
[ -d "$SRC/vendor/samsung/a42xq/proprietary" ] || die "vendor/samsung/a42xq not synced (private repo android_vendor_samsung_a42xq; add the manifest entry and repo sync)"
echo "vendor/samsung/a42xq comes from android_vendor_samsung_a42xq"

log "Installing Infinity product files"
cp -f "$LOCAL/infinity-port/infinity_a42xq.mk" "$SRC/device/samsung/a42xq/infinity_a42xq.mk"
cp -f "$LOCAL/infinity-port/AndroidProducts.mk" "$SRC/device/samsung/a42xq/AndroidProducts.mk"

log "Checking kernel"
if [ -d "$SRC/kernel/samsung/sm7225/.git" ]; then
    git -C "$SRC/kernel/samsung/sm7225" log -1 --oneline
else
    echo "WARNING: kernel/samsung/sm7225 is not a git checkout"
fi

log "Done"
