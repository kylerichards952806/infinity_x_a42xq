# [ROM][17][UNOFFICIAL][a42xq] Project Infinity-X 4.2 for Galaxy A42 5G

*Draft — fill the download placeholders after the build.*

```
/*
 * Your warranty is now void.
 *
 * I am not responsible for bricked devices, dead SD cards,
 * thermonuclear war, or you getting fired because the alarm app failed.
 * Please do some research if you have any concerns about features included
 * in this ROM before flashing it. YOU are choosing to make these modifications.
 */
```

**Project Infinity-X 4.2 (Android 17) for the Samsung Galaxy A42 5G (a42xq / SM-A426B).**

This is an unofficial build. It is based on the same `lineage-24.0` platform as my LineageOS 24.0 builds, with Project Infinity-X's framework, Infinity Suite and theming on top. All of the device bring-up work from the Lineage builds — SELinux enforcing, UDFPS, LiveDisplay, power hints, thermal, IMS/VoLTE and the rest — is carried over.

---

## What is Project Infinity-X?

Infinity-X is an AOSP-based Android 17 ROM built from the LineageOS 24.0 platform, with a large customization suite (Infinity Suite) and its own framework changes. It is not a LineageOS build with a theme on top: Settings, SystemUI, the launcher and several framework components are Infinity-X's own.

## Features

A selection of what Infinity Suite adds over AOSP/Lineage:

- Network traffic monitor, status bar logo, WiFi standard icon
- Font, icon shape, signal, WiFi and data icon customization
- Lockscreen clock styles, depth wallpaper, ambient pulse, edge lighting, music ticker, AOD image
- 20+ battery styles with a battery customizer, status bar clock chip
- QS panel transparency, dual tone, tile size/row spacing, compact media player
- Dynamic Island-style notification chip with adjustable position
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
- Bunch more customization under Settings → Infinity Suite

## What's working

Everything needed as a daily driver:

- Boot, calls, SMS/MMS, mobile data
- VoLTE / VoWiFi (IMS), including the Samsung IMS/RIL stack
- Wi-Fi, Bluetooth, NFC
- Camera (photo/video), audio, in-call audio
- Under-display fingerprint (UDFPS)
- GPS, hotspot, USB/OTG
- LiveDisplay, brightness and high-brightness mode
- SELinux fully enforcing from boot

## Known issues

- Unofficial build: no OTA updates, no official maintainer support.
- Play Integrity: BASIC and DEVICE may pass depending on Infinity-X's current fixes; STRONG will not pass while the bootloader is unlocked. Banking apps can still detect an unlocked bootloader or root.
- KernelSU-Next is built into the kernel. If an app refuses to run because of root, that is expected; hide it with your usual modules or use a non-root boot image. SUSFS is **not** included.
- Anything else: report it with a logcat and, for boot issues, `last_kmsg`/`dmesg`.

---

## Changelog

### Initial build — <BUILD_DATE>

**ROM**

- Project Infinity-X 4.2, Android 17, November 2026 security patch
- Built from `ProjectInfinity-X/manifest` branch `17`
- Built as a `user` release, signed with private release keys
- Stock A426B fingerprint kept for Play certification
- Two variants: `WITH_GAPPS := true` (GAPPS) and `WITH_GAPPS := false` (VANILLA)

**Upstream — Project Infinity-X 4.2**

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

**Infinity-X 4.2 — 16 November 2026 (this build)**

- Fixed the "Phone is starting" hang: the device manifest declared a `vendor.lineage.livedisplay` AIDL HAL that no service registers, so `ServiceManager.waitForDeclaredService()` blocked the `android.display` thread inside `finishBooting()`. User 0 never unlocked, no launcher ever appeared, and the Watchdog restarted `system_server` every ~66 seconds
- Added `Launcher3QuickStep`, because the product shipped no HOME activity at all
- Added Dolby Atmos (`org.lineageos.dap`, Settings → Sound) and AudioFX
- SELinux: `crash_dump` can ptrace `vold` and `system_server` can read `binderfs_logs_transactions` on `user` builds; the benign `ro.usb.uvc.enabled` read from SystemUI is silenced
- OTA packaging no longer hangs: `releasetools/non_ab_ota.py` archived the target files without `-y`, so `zip` followed `ROOT/d` into the host sysfs and blocked forever; the flag is now passed there too, and `ZIPOPT=-y` stays exported for the other packaging paths

- Fixed the always-on display / lockscreen charging readout showing 0.0 W: the Samsung kernel reports `battery/current_now` in mA, and `healthd` stored it straight into a microamp field, so SettingsLib computed ~3 mW. The HAL now normalises to microamps and falls back to `bms/current_now`

**Known issues**

- Dolby Atmos: the app and its Settings entry install correctly, but the vendor DAP effect (`46d279d9-9be7-453d-9d7c-ef937f675587`) is not in the blob set, so the switch has no audible effect yet. Fixing it needs the effect library from stock A426B firmware plus a matching `audio_effects.xml` entry
- Vibration intensity sliders could not be verified until the boot fix is flashed; `VibratorManagerService` already reports full intensity settings

**Device tree (carried over from LineageOS 24.0)**

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
- About Phone now reports **kyler084** as maintainer and the correct device specs: Galaxy A42 5G, Snapdragon 750G, 720 x 1600 at 60 Hz, 5000 mAh, 48MP + 8MP + 5MP + 5MP
- Private signing keys instead of public test keys

**IMS / VoLTE**

- Inherit `hardware/lineage/generic-ims/ims.mk` (ImsStack, CarrierSettings, Iwlan, QualifiedNetworksService, ImsMedia)
- Samsung radio HALs kept: `vendor.samsung.hardware.radio@2.0/2.1/2.2`, `sehradiomanager`, `secril_config_svc`
- IMS QoS precondition disabled via `CarrierSettingsOverlayCommon`
- `persist.dbg.volte_avail_ovr`, `vt_avail_ovr`, `wfc_avail_ovr` kept
- Samsung radio channel `imsd`/`imsd2` SELinux labels kept
- Google Carrier Services (`com.google.android.ims`) available via GApps

**Kernel — 4.19.325-kyler084-a42tweak-v1.0.2**

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

### Build history

| Build | Date | ROM | Device / kernel changes |
| --- | --- | --- | --- |
| Initial | 12 Nov 2026 | Infinity-X 4.2 | above |
| 4.2 | 16 Nov 2026 | Infinity-X 4.2 | boot/livedisplay fix, Launcher3QuickStep, Dolby Atmos, AudioFX, user-build SELinux fixes, ZIPOPT OTA fix |
| GAPPS 4.2 | 16 Nov 2026 | Infinity-X 4.2 | healthd charging-wattage fix, `releasetools` `-y` OTA fix, GMS LFS blobs pulled; GAPPS variant only |

---

## Installation

You can flash this with TWRP or with the Lineage recovery that ships inside the zip as `recovery.img`. Both work.

1. Boot into recovery
2. Format Data, but only if you are coming from a build signed with different keys
3. Flash the ROM zip
4. If you want Google apps, flash them now, in the same session, before the first boot
5. Reboot to system

### Google apps

The ROM does not ship with Google apps unless you pick the GAPPS variant. If you need them on a vanilla build, use **BiTGApps Nano for Android 17 arm64**:

https://bitgapps.io

Choose Nano, then ARM64, then Android 17.0. Flash it straight after the ROM and before the phone boots for the first time. Don't use a package built for another Android version. A clean flash is required if you add GApps after the first boot.

Do not use BiTGApps' debloat option: it strips stock apps like Messaging, and SMS/MMS stop working until you put an APK back by hand.

### Dirty flashing

Once you are on an Infinity-X build signed with these keys, later builds can be dirty flashed without wiping, from either recovery.

### Play Integrity

This is a `user` build signed with release keys and keeps the stock A426B fingerprint, which is what BASIC integrity needs. DEVICE integrity depends on Infinity-X's current spoofing/fixes; STRONG integrity will not pass while the bootloader is unlocked. KernelSU-Next is present, so root-sensitive apps may still object.

---

## Downloads

Both variants are built from the same device trees; only the `WITH_GAPPS` flag differs.

<!-- DOWNLOADS_START -->
- **GAPPS** (`WITH_GAPPS := true`): `Project_Infinity-X-4.2-a42xq-16.11.2026-GAPPS-UNOFFICIAL.zip` — 2,519,545,845 bytes (2.35 GiB) — MD5: `61401778d4e84b76e98778c6fbcfd695`
- **VANILLA** (`WITH_GAPPS := false`): not rebuilt yet. The earlier VANILLA zip predates the boot and wattage fixes, so don't flash it; a fresh VANILLA build follows.
<!-- DOWNLOADS_END -->

The zip contains `recovery.img`, the Lineage recovery for this device, for anyone who would rather use it than TWRP.

## Notes

- This is an unofficial build; don't ask for ETAs.
- If you are coming from a build signed with different keys, you must Format Data once or it will refuse to boot.
- Kernel source, device trees and vendor blobs are the ones linked below; the ROM is built from the Project Infinity-X `17` branch.

## Sources

- ROM: https://github.com/ProjectInfinity-X/manifest (branch `17`)
- Device: https://github.com/kylerichards952806/android_device_samsung_a42xq
- Common: https://github.com/kylerichards952806/android_device_samsung_sm7225-common
- Kernel: https://github.com/kylerichards952806/android_kernel_samsung_sm7225
- Vendor: https://github.com/kylerichards952806/android_vendor_samsung_sm7225-common

## Credits

- The Project Infinity-X team
- The LineageOS team and everyone who keeps the sm7225 platform alive
- KernelSU-Next
- BiTGApps
- Everyone who tested the Lineage builds and reported back
