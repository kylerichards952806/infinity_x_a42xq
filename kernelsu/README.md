# KernelSU-Next manager for the a42xq Infinity-X kernel

The kernel ships KernelSU-Next with driver **uapi 6**
(`v3.4.0-legacy-24-gb933b1f7 (33318-6)`). The official KernelSU-Next 3.4.2
manager is **uapi 5** (`33355-5`) and refuses to talk to it:

> The current KernelSU-Next manager version 5 is too low for KernelSU-Next to
> work properly. Please upgrade manager to version 6 or higher!

No official uapi-6 manager has been released yet, so use the CI build from the
`dev` branch that is mirrored here:

| | |
|---|---|
| APK | `KernelSU_Next_v3.4.2-198-g7ccf6147_33553-release.apk` |
| Package | `com.rifsxd.ksunext` |
| versionCode | `33553` (manager uapi 6) |
| versionName | `v3.4.2-198-g7ccf6147` |
| SHA-256 | `3860d41c86ff30dd31af815f30032de03ffd71e775a44311ef319db539a927d7` |

Provenance: KernelSU-Next GitHub Actions run `43601257081` on the `dev`
branch (`build-manager-ci.yml`), artifact `manager`, downloaded via
nightly.link. It is mirrored here because Actions artifacts expire.

Notes:

- Do not update this manager to the 3.4.2 release — that is the uapi-5 build
  and root stops working again.
- If a manager with a different signature is already installed, uninstall it
  first; root grants are tied to the signature and must be re-granted.
- This kernel is built without SUSFS, so the manager logs
  `SUSFS operation not supported` — expected, not an error.
