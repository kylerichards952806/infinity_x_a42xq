# Pending for the next build

Changes that are committed in the trees but are **not** in a published
artifact. Fold these into the build changelog when the next build is run.

Builds are only started when explicitly requested.

## Pending

- `device/samsung/a42xq`: Google SetupWizard skipped
  (`ro.setupwizard.mode=DISABLED`) because it needed a screen lock/unlock per
  page and left airplane mode on after an offline first boot; `SamsungDAP`
  dropped (no Dolby effect library or profiles in the blob set, AudioFX stays);
  ExtServices APEX dropped, APK fallback is the supported path.
- apexd never activates `com.android.extservices` (`/system/apex`) or
  `com.google.android.gmssystem` (`/product/apex`): payloads are byte-identical
  to the prebuilts, the `avbpubkey` files match the keys embedded in the
  APEXes, `ro.apex.updatable=true`, `ro.boot.veritymode=enforcing`, and both
  still report `isActive="false"`. apexd logs the failure before logd is up and
  dmesg is flooded by KernelSU, so the exact rejection reason is not captured
  yet. APK fallbacks cover both until this is solved.
- GAPPS audit: Photos, CalendarGooglePrebuilt, PrebuiltGmail and Maps are in
  `vendor/pixel/gms` but not in the image. Gmail/Maps/Play services come from
  Play Store updates; Photos and Calendar are absent.
- Current hand-patched device still has `ro.adb.secure=0`, `ro.debuggable=1`
  and the init.rc adb trigger. Those are device-side only; a clean build does
  not contain them, so do not distribute the current system as-is.
- `device/samsung/a42xq`: the GMS APEX
  (`com.google.android.gmssystem.prodvic.apex`) is no longer installed;
  `PRODUCT_PACKAGES` and `PRODUCT_COPY_FILES` filter it out, and the vendor
  list drops the entry. Play services comes from the PrebuiltGmsCore
  priv-app fallback, so the APEX would only create a duplicate package if
  apexd ever mounts it. (Vendor edit is committed locally only; the
  gitlab.com/tejas101k vendor remote needs credentials to push.)
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
