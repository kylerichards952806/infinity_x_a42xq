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

- Boot, calls, SMS/MMS, mobile data
- VoLTE / VoWiFi (IMS), including the Samsung IMS/RIL stack
- WiFi, Bluetooth, NFC, GPS, hotspot, USB/OTG
- Camera (photo/video), audio, in-call audio
- Under-display fingerprint (UDFPS), face unlock
- LiveDisplay, brightness and high-brightness mode
- SELinux fully enforcing from boot
- GAPPS build: Play Store and Play services, Play Integrity **STRONG** with Infinity-X's built-in spoofing
- KernelSU-Next root

### Features

- Infinity Suite: network traffic monitor, status bar logo, WiFi standard icon
- Font, icon shape, signal, WiFi and data icon customization
- Lockscreen clock styles, depth wallpaper, ambient pulse, edge lighting, music ticker, AOD image
- 20+ battery styles with battery customizer, status bar clock chip
- QS panel transparency, dual tone, tile size/row spacing, compact media player
- Dynamic Island style notification chip with adjustable position
- Screen-off UDFPS icons and animations
- Face Unlock, Pocket Mode, Smart Pixels
- Three-finger swipe to screenshot, quick torch, double-tap to pulse
- Separate SIM ringtones, increasing ring volume, volume panel on the left
- Charging control, Device as Webcam, battery information
- Hide navigation bar, force fullscreen apps, hide developer options status
- Advanced reboot, ignore window secure level flags
- Custom Monet engine, wallpaper blur, colored notification/QS icons
- Pixel extras: Now Playing, Clear Calling, Quick Tap, Adaptive Charging
- Customizable Launcher3, clear-all notification button
- AudioFX equalizer
- Bunch more customization under Settings → Infinity Suite

### Bugs / notes

- Google SetupWizard is **temporarily disabled** while its page lock/unlock bug is fixed. First boot goes straight to the launcher; sign in through Play Store.
- **Dolby Atmos removed** in this and future builds. The A42 5G blob set has no Dolby effect library and no profiles, so the switch did nothing. AudioFX is included instead.
- Play services ships as a priv-app APK fallback because the GMS APEX does not activate on this device.
- fs-verity on f2fs is fixed in the next kernel build. Current builds log harmless `Failed to verity-protect ...` lines.
- Do **not** wipe `/metadata`: the factory key cannot be regenerated and the device will not boot without the patched fstab.
- Banking apps may still apply their own root or bootloader checks.
- KernelSU-Next is built into the kernel; if an app refuses to run because of root, hide it with your usual modules or flash a non-root boot image.
- Unofficial build: no OTA updates, no official maintainer support, don't ask for ETAs.
- Anything else: report it with a logcat and, for boot issues, `last_kmsg`/`dmesg`.

This is an unofficial build, expect some imperfections. If you have any issues/bugs, please provide logcat or last_kmsg/etc.

### Installation

Flash with TWRP or with the Lineage recovery inside the zip (`recovery.img`). Both work.

1. Boot into recovery
2. Format Data, but only if you are coming from a build signed with different keys
3. Flash the ROM zip
4. If you want Google apps, flash them now, in the same session, before the first boot
5. Reboot to system

Once you are on an Infinity-X build signed with these keys, later builds can be dirty flashed without wiping, from either recovery.

#### Google apps on VANILLA

The ROM ships without Google apps unless you pick the GAPPS variant. For vanilla builds use **BiTGApps Nano for Android 17 arm64**: https://bitgapps.io — Nano → ARM64 → Android 17.0. Flash it straight after the ROM and before the phone boots for the first time. Don't use a package built for another Android version, and a clean flash is required if you add GApps after the first boot.

Do not use BiTGApps' debloat option: it strips stock apps like Messaging, and SMS/MMS stop working until you put an APK back by hand.

### Downloads

Both variants are built from the same device trees; only the `WITH_GAPPS` flag differs.

<!-- DOWNLOADS_START -->
- **GAPPS** (`WITH_GAPPS := true`): `infinity_a42xq-GAPPS-repacked.zip` — 2,516,507,938 bytes (2.34 GiB) — MD5: `6c2366166916da1594ccb209ad0c1a95`
  - Repacked after the first flash attempts: `system` and `product` are resized (5.47 GB and 2.20 GB partitions) so the four images total 8.86 GB and fit the 9.02 GB super.
  - As built (before repack): `Project_Infinity-X-4.2-a42xq-16.11.2026-GAPPS-UNOFFICIAL.zip` — 2,519,545,845 bytes (2.35 GiB) — MD5: `61401778d4e84b76e98778c6fbcfd695`
- **VANILLA** (`WITH_GAPPS := false`): not rebuilt yet. The earlier VANILLA zip predates the boot and wattage fixes, so don't flash it; a fresh VANILLA build follows.
<!-- DOWNLOADS_END -->

The zip contains `recovery.img`, the Lineage recovery for this device, for anyone who would rather use it than TWRP.

### Root manager (KernelSU-Next)

The kernel ships KernelSU-Next with driver **uapi 6** (`v3.4.0-legacy-24-gb933b1f7 (33318-6)`). The official KernelSU-Next **3.4.2** manager is uapi 5 (`33355-5`) and refuses to work with it, reporting that the manager is too low and must be version 6 or higher. No official uapi-6 manager has been released yet, so install the CI build from the `dev` branch:

- **APK**: `KernelSU_Next_v3.4.2-198-g7ccf6147_33553-release.apk` (versionCode `33553`, manager uapi 6)
- **Download**: https://github.com/kylerichards952806/infinity_x_a42xq/raw/main/kernelsu/KernelSU_Next_v3.4.2-198-g7ccf6147_33553-release.apk
- **SHA-256**: `3860d41c86ff30dd31af815f30032de03ffd71e775a44311ef319db539a927d7`

Notes:

- Do not update it to the 3.4.2 release; that is the uapi-5 manager and root breaks again.
- If a differently signed manager is already installed, uninstall it first — root grants are tied to the signature and need re-granting.
- This kernel has no SUSFS, so `SUSFS operation not supported` in the logs is expected.
- Provenance: KernelSU-Next CI run `43601257081` (`build-manager-ci.yml`, `dev` branch); mirrored because Actions artifacts expire.

### Changelog

#### This build — 16 November 2026

- Fixed the boot hang: Google ExtServices ships as a priv-app, so `system_server` no longer aborts with "Required services extension package is missing"
- Fixed the "Phone is starting" hang: the device manifest declared a `vendor.lineage.livedisplay` AIDL HAL that no service registers, so `ServiceManager.waitForDeclaredService()` blocked the `android.display` thread inside `finishBooting()`; user 0 never unlocked and the Watchdog restarted `system_server` every ~66 seconds
- Added Launcher3QuickStep; the product had no HOME activity
- Play Store fixed: Play services ships as a priv-app APK because the GMS APEX never activates
- Google SetupWizard temporarily disabled (page lock/unlock bug, and it left airplane mode on after an offline first boot)
- Dolby Atmos app removed; AudioFX enabled
- Fixed the lockscreen/AOD charging readout showing 0.0 W: Samsung reports `battery/current_now` in mA and `healthd` stored it as microamps; the HAL now normalises and falls back to `bms/current_now`
- SELinux: `crash_dump` can ptrace `vold`, `system_server` can read `binderfs_logs_transactions` on `user` builds, benign `ro.usb.uvc.enabled` read silenced
- OTA packaging no longer hangs: `releasetools/non_ab_ota.py` now passes `-y` to `zip` so it doesn't follow `ROOT/d` into host sysfs
- Kernel: `CONFIG_F2FS_FS_VERITY` and `CONFIG_EXT4_FS_VERITY` enabled (next kernel build)
- Log sweep: SELinux, RIL, WiFi and keystore noise reviewed; no system_server or app denials

#### Build history

| Build | Date | ROM | Device / kernel changes |
| --- | --- | --- | --- |
| Initial | 12 Nov 2026 | Infinity-X 4.2 | first booting Infinity-X build |
| 4.2 | 16 Nov 2026 | Infinity-X 4.2 | boot/LiveDisplay fix, Launcher3QuickStep, Dolby Atmos, AudioFX, user-build SELinux fixes, ZIPOPT OTA fix |
| GAPPS 4.2 | 16 Nov 2026 | Infinity-X 4.2 | healthd charging-wattage fix, `releasetools` `-y` OTA fix, GMS LFS blobs pulled; GAPPS variant only |

#### Base ROM

- Project Infinity-X 4.2, Android 17, November 2026 security patch
- Built from `ProjectInfinity-X/manifest` branch `17`, `user` release, private release keys
- Stock A426B fingerprint kept for Play certification
- Two variants: `WITH_GAPPS := true` (GAPPS) and `WITH_GAPPS := false` (VANILLA)

#### Upstream — Infinity-X 4.2

- Merged November 2026 security patch
- Fixed the stock app icon briefly appearing during the app-to-home-screen transition when a custom icon pack is in use
- Brought back the combined Internet tile from Android 16
- Dynamic Island chip horizontal/vertical position is now adjustable for different punch-hole layouts
- Added Dynamic Island support on devices with corner punch-hole layouts
- Fixed QS panel lag when Dynamic Island is active and media is playing
- Added an optional aggressive standby sleep mode toggle to minimise idle drain
- Transparent blur effects for the revamped volume panel and more system/dynamic bar surfaces
- More optimised and cleaner glass blur UI
- Fixed transparent status bar overlap while scrolling the Settings homepage
- Private DNS can now be disabled while a VPN is active (author: idoybh)
- Fixed the Private DNS tile long-press opening nothing (author: idoybh)
- Added per-connection Wi-Fi MAC address randomisation (author: muhomorr)
- Fixed an occasional crash on the Settings Wi-Fi data usage page
- The call timer is no longer shown in the Dynamic Island chip until the call connects
- Improved custom ROM/root detection handling in banking and security apps
- Revamped the Spoofing section in Material Expressive; added keystore provider, ROM signature, Vending SDK level and more (authors: joeyhuab, neobuddy89)
- Improved Trickystore and the spoofing feature backend
- Added a toggle to disable forced dark theme in Battery Saver (author: Blackseafisher1)
- Fixed the volume panel not showing in legacy keyguard mode (author: neobuddy89)
- Fixed AliPay crashing
- Fixed Tidal crashing (author: QuinceROMS)
- In-use apps can no longer be cleared by the Recents panel's Clear All button
- Fixed the inability to set SIM 1 ringtone on some devices
- Revamped Header Image settings in Material 3 Expressive and improved Header Image functionality (author: neobuddy89)
- Fixed the status bar being hidden while lockscreen media art is showing
- Fixed an async notification inflation warning that caused UI lag in some instances
- Added wallpaper effects and live/Pixel wallpapers support in vanilla builds (author: uwu-gl)
- Fixed the keybox fetch failed error and greatly improved keybox fetching speed
- Added a toggle to disable custom ambient/AOD brightness so the auto-brightness sensor can drive ambient/doze brightness
- No longer forces an opaque app drawer background when window-level blurs are disabled in legacy fullscreen / One UI app drawer style
- Fixed the predictive back gesture animation in InfinitySuite
- Fixed the sandbox crash when the app list contains no user apps (author: Varakumar)
- Weather clock / At a Glance is hidden while notifications are present
- Wallpaper & Styles now shows the lockscreen clock with the applied clock fonts (author: eldainosor)
- Expanded volume panel now opens the media output switcher instead of the extended stock volume panel
- Variable fonts applied to the lyrics card and lockscreen lyrics

#### Device tree (carried over from LineageOS 24.0)

- SELinux fully enforcing from boot, with the bring-up denials cleaned up
- LiveDisplay: fixed hang at boot and black screen after wiping data
- UDFPS: fixed fingerprint prompt text being cut off by the navigation bar
- Fixed lockscreen PIN being rejected after a reboot
- Fixed brightness and high-brightness mode not always applying
- Fixed power hints not being applied (scroll and app-launch stutter)
- Added the missing thermal HAL
- Fixed charger and OTG detection
- Fixed invalid vibration profile warning
- In-call audio fixed (updated mixer paths)
- Added the default Messaging app so SMS/MMS work out of the box
- Faster memory compression (LZ4 zram) on 4 GB models
- Updated to A426BXXU8DXG2 blobs and build fingerprint
- UDFPS overlay/pixel-pitch updates, `soong_config_set()` migration
- About Phone reports **kyler084** as maintainer and the correct specs: Galaxy A42 5G, Snapdragon 750G, 720 x 1600 at 60 Hz, 5000 mAh, 48MP + 8MP + 5MP + 5MP
- Private signing keys instead of public test keys

#### IMS / VoLTE

- Inherits `hardware/lineage/generic-ims/ims.mk` (ImsStack, CarrierSettings, Iwlan, QualifiedNetworksService, ImsMedia)
- Samsung radio HALs kept: `vendor.samsung.hardware.radio@2.0/2.1/2.2`, `sehradiomanager`, `secril_config_svc`
- IMS QoS precondition disabled via `CarrierSettingsOverlayCommon`
- `persist.dbg.volte_avail_ovr`, `vt_avail_ovr`, `wfc_avail_ovr` kept
- Samsung radio channel `imsd`/`imsd2` SELinux labels kept
- Google Carrier Services (`com.google.android.ims`) available via GApps

#### Kernel — 4.19.325-kyler084-a42tweak-v1.0.2

- Default CPU governor changed from `performance` to `schedutil`
- `CONFIG_IKHEADERS` off (no resident compressed headers)
- `CONFIG_SLUB_DEBUG` off (no slab debug accounting on every allocation)
- `CONFIG_PROFILING`, `CONFIG_CPU_FREQ_TIMES`, `CONFIG_ARM_QCOM_CPUFREQ_HW_DEBUG` off
- 4 GB tuning (LZ4 zram and reduced kernel-side overhead)
- SELinux bootparam enforcing support (`CONFIG_SECURITY_SELINUX_BOOTPARAM`, value 1)
- KernelSU-Next with the syscall-table hook (`execve`, `execveat`, `faccessat`, `newfstatat`)
- `reboot(2)` hook so `ksud` can install its driver fd and modules install correctly
- Kprobes stays off on this 4.19 kernel; the syscall-table hook is the supported path
- KSU init `.rc` read fixes so `post-fs-data` is actually executed
- No SUSFS
- fs-verity (`CONFIG_F2FS_FS_VERITY`, `CONFIG_EXT4_FS_VERITY`) enabled in the next kernel build

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
