# Pending for the next build

Changes that are committed in the trees but are **not** in a published
artifact. Fold these into the build changelog when the next build is run.

Builds are only started when explicitly requested.

## Pending

- `device/samsung/a42xq`: Google Play services priv-app fallback
  (`prebuilts/gms/PrebuiltGmsCore.apk`, 26.11.36, Git LFS) plus its
  privapp allowlist and preinstalled-packages sysconfig. Fixes Play Store
  dying with `Failed to find provider com.google.android.gsf.gservices`
  because apexd never mounted the GMS APEX. Remove the APK copy if apexd
  ever starts mounting `com.google.android.gmssystem.prodvic.apex`.
- `device/samsung/a42xq` (new commit): Google ExtServices priv-app fallback
  plus the two Google APEX `avbpubkey` files. Fixes the endless boot
  animation: `PackageManagerService` aborted `system_server` with
  "Required services extension package is missing" because apexd never
  activated `com.google.android.extservices.apex`. Must be in the next
  artifact.
- GAPPS payload is incomplete: `vendor/pixel/gms` ships only the GmsCore
  **Dynamite modules** (no base `PrebuiltGmsCore` APK), so
  `com.google.android.gms` is never installed. Play Store crashes on the
  missing `com.google.android.gsf.gservices` provider and GSF cannot
  start. GAPPS is not usable until a full GMS base APK is added.
- Metadata encryption: TWRP "wipe metadata" destroyed the factory-wrapped
  key on this device. vold only generates that key on the format path, so
  the device currently runs with `metadata_encryption` removed from
  `/vendor/etc/fstab.default` (device-side only, not in the tree). Never
  wipe `/metadata`; if it is wiped, that fstab edit is required to boot.
- Device-side debug leftovers from bring-up (not in the tree, a clean
  build reverts them): `ro.adb.secure=0` and `ro.debuggable=1` in
  `/system/build.prop`, an `init.rc` trigger that forces
  `sys.usb.config=adb`, and `/data/misc/adb/adb_keys`.
- Do not create files as root inside `/data/system` from recovery: a
  root-owned `locksettings.db` left there made `TrustManagerService`
  abort `system_server` with `SQLiteCantOpenDatabaseException ...
  locksettings.db`.
- SetupWizard hijacks HOME after an offline setup; mark
  `device_provisioned`/`user_setup_complete` and disable
  `com.google.android.setupwizard` to get Launcher3 back.

- `device/samsung/a42xq` `cc23dce`: pinned the super and logical partition
  sizes to the A42 5G layout so the GAPPS images cannot overflow the real
  super again.
  - `BOARD_SUPER_PARTITION_SIZE` 9,017,753,600 (was 10,385,096,704 from
    `sm7225-common`, which other devices still use)
  - `BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE` 9,013,559,296
  - system 5,472,002,048, vendor 1,138,327,552, product 2,200,674,304,
    odm 52,510,720 = 8,863,514,624 total

## Already in the last artifacts

- GAPPS OTA, 16 Nov 2026 19:24 — 2,519,545,845 B,
  MD5 `61401778d4e84b76e98778c6fbcfd695`
  - livedisplay manifest fix, Launcher3QuickStep, Dolby Atmos + AudioFX,
    user-build sepolicy fixes, healthd charging-wattage fix,
    `releasetools/non_ab_ota.py` `-y` fix
- Repacked GAPPS OTA — 2,516,507,938 B,
  MD5 `6c2366166916da1594ccb209ad0c1a95`
  - same content, `system`/`product` filesystems shrunk and the dynamic
    partition op list regenerated to fit the 9,017,753,600-byte super
