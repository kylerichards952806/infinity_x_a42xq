# [ROM][17][UNOFFICIAL][a42xq] Project Infinity-X 4.2 for Galaxy A42 5G

Project Infinity-X is an AOSP based Custom ROM runs on Android Operating System. We give our best to fulfill the demands of our users regarding features, Stability & performance.

```
/*
 * Your warranty is now void.
 *
 * I am not responsible for bricked devices, dead SD cards,
 * thermonuclear war, or you getting fired because the alarm app failed. Please
 * do some research if you have any concerns about features included in this ROM
 * before flashing it! YOU are choosing to make these modifications, and if
 * you point the finger at me for messing up your device, I will laugh at you.
 */
```

**Device:** Samsung Galaxy A42 5G (SM-A426B / a42xq)
**Android:** 17 · **ROM:** Project Infinity-X 4.2 · **Status:** UNOFFICIAL
**Build:** user, signed with private release keys, stock A426B fingerprint
**Kernel:** 4.19.325-kyler084-a42tweak-v1.0.2 (KernelSU-Next, no SUSFS)
**Maintainer:** kyler084

### What's working

- Calls, SMS, mobile data, VoLTE/IMS (Samsung radio HALs kept)
- WiFi, Bluetooth, NFC, GPS
- Camera (Aperture), UDFPS fingerprint, face unlock
- GAPPS build: Play Store and Play services, Play Integrity **STRONG** with Infinity-X's built-in spoofing
- SELinux enforcing, private release keys
- KernelSU-Next root

### Features

- Infinity Suite: network traffic monitor, status bar logo, WiFi standard icon
- Font, icon shape, signal, WiFi and data icon customization
- Lockscreen clock styles, depth wallpaper, ambient pulse, edge lighting, music ticker, AOD image
- 20+ battery styles with battery customizer, status bar clock chip
- QS panel transparency, dual tone, tile size/row spacing, compact media player
- Dynamic Island style notification chip
- Screen-off UDFPS icons and animations
- Face Unlock, Pocket Mode, Smart Pixels
- Three-finger swipe to screenshot, quick torch, double-tap to pulse
- Separate SIM ringtones, increasing ring volume, volume panel on the left
- Charging control, Device as Webcam, battery information
- AudioFX equalizer
- LiveDisplay, power hints, thermal reporting, charging wattage

### Bugs / notes

- Google SetupWizard is **temporarily disabled** while its page lock/unlock bug is fixed. First boot goes straight to the launcher; sign in through Play Store.
- **Dolby Atmos removed** in this and future builds. The A42 5G blob set has no Dolby effect library and no profiles, so the switch did nothing. AudioFX is included instead.
- Play services ships as a priv-app APK fallback because the GMS APEX does not activate on this device.
- fs-verity on f2fs is fixed in the next kernel build. Current builds log harmless `Failed to verity-protect ...` lines.
- Do **not** wipe `/metadata`: the factory key cannot be regenerated and the device will not boot without the patched fstab.
- Banking apps may still apply their own root or bootloader checks.

This is an unofficial build, expect some imperfections. If you have any issues/bugs, please provide logcat or last_kmsg/etc.

### Downloads

<!-- DOWNLOADS_START -->
- **GAPPS** (`WITH_GAPPS := true`): `infinity_a42xq-GAPPS-repacked.zip` — 2,516,507,938 bytes (2.34 GiB) — MD5: `6c2366166916da1594ccb209ad0c1a95`
  - Repacked after the first flash attempts: `system` and `product` are resized (5.47 GB and 2.20 GB partitions) so the four images total 8.86 GB and fit the 9.02 GB super.
- **VANILLA** (`WITH_GAPPS := false`): not rebuilt yet. The earlier VANILLA zip predates the boot and wattage fixes, so don't flash it; a fresh VANILLA build follows.
<!-- DOWNLOADS_END -->

- **KernelSU-Next manager (uapi 6)**: `KernelSU_Next_v3.4.2-198-g7ccf6147_33553-release.apk` — [download](https://github.com/kylerichards952806/infinity_x_a42xq/raw/main/kernelsu/KernelSU_Next_v3.4.2-198-g7ccf6147_33553-release.apk) — SHA-256: `3860d41c86ff30dd31af815f30032de03ffd71e775a44311ef319db539a927d7`
  - The official 3.4.2 manager is uapi 5 and refuses this kernel (driver is uapi 6). Don't update it to the release build.

### Flashing

1. Boot the TWRP you already have (the zip has no `recovery.img`).
2. If you are coming from a build signed with different keys, Format Data once.
3. Flash the ROM zip (sideload, USB OTG or sdcard).
4. Reboot and enjoy.

### Changelog

- Fixed the boot hang: Google ExtServices ships as a priv-app, so `system_server` no longer aborts with "Required services extension package is missing"
- Added Launcher3QuickStep; the product had no HOME activity
- Play Store fixed: Play services ships as a priv-app APK because the GMS APEX never activates
- Google SetupWizard temporarily disabled (page lock/unlock bug, and it left airplane mode on after an offline first boot)
- Dolby Atmos app removed; AudioFX enabled
- Kernel: f2fs/ext4 fs-verity enabled (next kernel build)
- Log sweep: SELinux, RIL, WiFi and keystore noise reviewed; no system_server or app denials
- Charging wattage, thermal and power-hint fixes from the Lineage bring-up

### Sources

- ROM: https://github.com/ProjectInfinity-X/manifest (branch `17`)
- Device: https://github.com/kylerichards952806/android_device_samsung_a42xq
- Common: https://github.com/kylerichards952806/android_device_samsung_sm7225-common
- Kernel: https://github.com/kylerichards952806/android_kernel_samsung_sm7225
- Vendor: https://github.com/kylerichards952806/android_vendor_samsung_sm7225-common

### Credits

- The Project Infinity-X team
- The LineageOS team and everyone who keeps the sm7225 platform alive
- KernelSU-Next
- BiTGApps
- Everyone who tested the Lineage builds and reported back
