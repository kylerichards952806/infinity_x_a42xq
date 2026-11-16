#!/usr/bin/env bash
#
# Build Project Infinity-X for the Galaxy A42 5G (a42xq) in both variants.
#
# Run inside WSL (Ubuntu-24.04):
#   bash /mnt/c/a42/build-infinity-a42xq.sh
#
# Env overrides:
#   INFINITY_SRC   source tree           (default /root/infinity)
#   RELEASE_POST   markdown to update    (default /mnt/c/a42/release-post-infinityx-a42xq-17.md)
#   ARTIFACTS      output directory      (default /mnt/c/a42/artifacts)
#   BUILD_TYPE     user | userdebug      (default user)
#   JOBS           make jobs             (default nproc)
#   KEYS_SRC       private keys          (default /root/android/vendor/lineage-priv/keys)
#
set -eo pipefail

SRC="${INFINITY_SRC:-/root/infinity}"
POST="${RELEASE_POST:-/mnt/c/a42/release-post-infinityx-a42xq-17.md}"
ARTIFACTS="${ARTIFACTS:-/mnt/c/a42/artifacts}"
BUILD_TYPE="${BUILD_TYPE:-user}"
JOBS="${JOBS:-$(nproc)}"
# OTA packaging zips the target-files ROOT/, which contains absolute Android
# symlinks (ROOT/d -> /sys/kernel/debug). Without -y, zip follows them into the
# host sysfs and hangs; -y stores them as symlinks.
export ZIPOPT="${ZIPOPT:--y}"
DEVICE=a42xq
KEYS_SRC="${KEYS_SRC:-/root/android/vendor/lineage-priv/keys}"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
log() { printf '\n=== %s ===\n' "$*"; }

[ -d "$SRC/.repo" ] || die "no repo tree at $SRC"
[ -f "$SRC/build/envsetup.sh" ] || die "no build/envsetup.sh in $SRC"
[ -f "$SRC/device/samsung/$DEVICE/infinity_a42xq.mk" ] || die "infinity_a42xq.mk missing in $SRC"
[ -f "$POST" ] || die "release post not found: $POST"

# Private release keys, carried over from the Lineage tree.
KEY_DST="$SRC/vendor/infinity-priv/keys"
if [ ! -f "$KEY_DST/releasekey.pk8" ]; then
    [ -d "$KEYS_SRC" ] || die "private keys not found at $KEYS_SRC"
    mkdir -p "$KEY_DST"
    cp -a "$KEYS_SRC/." "$KEY_DST/"
    printf 'PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/infinity-priv/keys/releasekey\n' > "$KEY_DST/keys.mk"
    chmod 700 "$KEY_DST"
    log "Copied private release keys into vendor/infinity-priv/keys"
fi

mkdir -p "$ARTIFACTS"
INFO="$ARTIFACTS/build-info.txt"
: > "$INFO"

build_variant() {
    local variant="$1" with_gapps="$2" label="$3"
    local zip base size md5

    log "Configuring $label (WITH_GAPPS=$with_gapps)"
    cd "$SRC"
    # shellcheck disable=SC1091
    source build/envsetup.sh >/dev/null
    ccache -M "${CCACHE_SIZE:-20G}" >/dev/null 2>&1 || true
    export WITH_GAPPS="$with_gapps"
    lunch "infinity_${DEVICE}-${BUILD_TYPE}"

    if [ "$variant" = "VANILLA" ]; then
        log "Cleaning installed files from the GAPPS build"
        m installclean
    fi

    log "Building $label"
    # `m` injects --all-modules, which makes Soong analyze every module in the
    # tree and OOMs this 14 GB VM. Make mode analyzes only what bacon needs.
    "$SRC/build/soong/soong_ui.bash" --make-mode bacon -j"$JOBS"

    zip=$(find "out/target/product/$DEVICE" -maxdepth 1 \
        -name "Project_Infinity-X-*-${variant}-*.zip" \
        -printf '%T@ %p\n' | sort -nr | head -1 | cut -d' ' -f2-)
    [ -n "$zip" ] || die "$label zip not found under out/target/product/$DEVICE"

    base=$(basename "$zip")
    cp -f "$zip" "$ARTIFACTS/$base"
    size=$(du -h "$ARTIFACTS/$base" | cut -f1)
    md5=$(md5sum "$ARTIFACTS/$base" | cut -d' ' -f1)
    printf '%s|%s|%s|%s\n' "$variant" "$base" "$size" "$md5" >> "$INFO"
    log "Artifact: $ARTIFACTS/$base ($size, md5 $md5)"
}

build_variant GAPPS true "GAPPS build"
build_variant VANILLA false "VANILLA build"

log "Updating release post"
python3 - "$POST" "$INFO" <<'PY'
import re
import sys
from pathlib import Path

post_path, info_path = Path(sys.argv[1]), Path(sys.argv[2])
rows = {}
build_date = None
for line in info_path.read_text().splitlines():
    variant, name, size, md5 = line.split("|")
    rows[variant] = (name, size, md5)
    m = re.search(r"-(\d{2}\.\d{2}\.\d{4})-", name)
    if m and build_date is None:
        build_date = m.group(1)

if "GAPPS" not in rows or "VANILLA" not in rows:
    raise SystemExit("build-info.txt is missing a variant")

g_name, g_size, g_md5 = rows["GAPPS"]
v_name, v_size, v_md5 = rows["VANILLA"]
block = (
    "<!-- DOWNLOADS_START -->\n"
    f"- **GAPPS** (`WITH_GAPPS := true`): `{g_name}` — `{g_size}` — MD5: `{g_md5}`\n"
    f"- **VANILLA** (`WITH_GAPPS := false`): `{v_name}` — `{v_size}` — MD5: `{v_md5}`\n"
    "<!-- DOWNLOADS_END -->"
)

text = post_path.read_text()
if "<!-- DOWNLOADS_START -->" not in text or "<!-- DOWNLOADS_END -->" not in text:
    raise SystemExit("download markers missing from the release post")
text = re.sub(
    r"<!-- DOWNLOADS_START -->.*?<!-- DOWNLOADS_END -->",
    block,
    text,
    count=1,
    flags=re.S,
)
if build_date:
    text = text.replace("<BUILD_DATE>", build_date)
post_path.write_text(text)
print(f"Updated {post_path} with {g_name} and {v_name}")
PY

log "Done"
cat "$INFO"
