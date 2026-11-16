# Pending for the next build

Changes that are committed in the trees but are **not** in a published
artifact. Fold these into the build changelog when the next build is run.

Builds are only started when explicitly requested.

## Pending

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
