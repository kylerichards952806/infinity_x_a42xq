# Infinity-X 4.2 (Android 17) — Galaxy A42 5G (a42xq)

Build tooling, port overlay and release files for running **Project Infinity-X
4.2 (Android 17)** on the Samsung Galaxy A42 5G (SM-A426B, codename `a42xq`).

Both variants are supported from the same tree:

| Variant | Switch |
|---|---|
| GAPPS | `WITH_GAPPS=true` (default) |
| VANILLA | `WITH_GAPPS=false` |

## Contents

| Path | Purpose |
|---|---|
| `apply-infinity-port.sh` | Applies the manifest entry, private keys and device/vendor overlays into an Infinity-X checkout |
| `build-infinity-a42xq.sh` | Builds GAPPS then VANILLA, copies the zips out, records size and MD5, and fills in the release post |
| `infinity-port/` | `infinity_a42xq.mk` and `AndroidProducts.mk` for the device tree |
| `release-post-infinityx-a42xq-17.md` | XDA release post template |
| `patches/sepolicy-user-builds.patch` | `system/sepolicy` fix so `user` builds can dump vold stacks and read binderfs ANR transactions |

## Device

- Maintainer: `kyler084`
- Kernel: `4.19.325-kyler084-a42tweak-v1.0.2`, KernelSU-Next, no SUSFS
- IMS/VoLTE preserved through `generic-ims`
- About phone: Galaxy A42 5G, Snapdragon 750G, 720 x 1600 60 Hz, 5000 mAh,
  48MP + 8MP + 5MP + 5MP

## Device tree

The Infinity-X product configuration lives on the `infinity-x` branch of
[android_device_samsung_a42xq](https://github.com/kylerichards952806/android_device_samsung_a42xq).

## Build

```
# 1. sync Infinity-X 4.2 (Android 17) with repo
# 2. apply the port overlay
bash apply-infinity-port.sh

# 3. build both variants
JOBS=4 bash build-infinity-a42xq.sh
```

## Memory notes

Soong's analysis is the tightest constraint on a 16 GB machine. `soong_ui`
launches `soong_build` under `env -i`, so `GOGC` and `GOMEMLIMIT` cannot be
passed through the environment, and the analysis peaks around 11–13 GB RSS.
On a 14 GB WSL guest that leads to OOM kills (`exit=137`).

Two mitigations that work:

1. Build **VANILLA first** — without the Gapps module trees the graph is
   smaller and comfortably fits.
2. Resume an existing plan instead of re-analysing: `out/soong/build.*.ninja`
   and `out/build-*.ninja` survive between runs, and

   ```
   prebuilts/build-tools/linux-x86/bin/ninja -f out/combined-infinity_a42xq.ninja bacon -j4
   ```

   drives the build directly against a previously generated plan, skipping the
   analysis entirely.

Keep the Windows volume holding the WSL disk image free: a full `C:` at 97%
wedges the guest and every process spawn fails with an I/O error.
