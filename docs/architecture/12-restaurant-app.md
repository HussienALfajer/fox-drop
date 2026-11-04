# 12. Restaurant app (Android and Windows)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 12.1 Why Flutter

Flutter is the only mature option that builds **Android and Windows from one codebase** with native performance. React Native for Windows is far less mature, and Compose Multiplatform runs on the desktop through the JVM.

## 12.2 Android native layer (Kotlin, in `core_alerts`)

- A **foreground service** of type `dataSync` or `specialUse` (whichever the Play policy accepts for this use at submission), with the permanent notification «FOX DROP يستقبل طلباتك», restarted after reboot and after an update (`BOOT_COMPLETED`, `MY_PACKAGE_REPLACED`).
- The service owns the WebSocket while the app is in the background, so a ring does not depend on the Flutter UI being alive.
- Ring sound through `AudioAttributes.USAGE_ALARM`, looping until handled (RA §4.4).
- **Full-screen intent** on Android 14+ where granted; heads-up notification with the looping sound otherwise (RA §21 item 4).
- Readers for the device check: notification permission, battery optimisation, full-screen permission, alarm volume, Do Not Disturb state (RA §4.5).
- Tablet layout at 840 dp and wider (RA §4.1).

## 12.3 Windows native layer

- `window_manager` and `tray_manager`: closing the window minimises to the tray; quitting asks for confirmation; a ring brings the window to the front or flashes the taskbar button (RA §4.3).
- `launch_at_startup` for starting with Windows.
- Native Windows toast notifications (`local_notifier` or a small Win32 plugin).
- Sleep and power-plan check through a small Win32 plugin (RA §4.5 check 6).
- **Installer and updates: Velopack.** A signed installer from the website, background download, install on the next restart, never while a ring, a pickup prompt or an active order is open (RA §4.2).
- **Code signing:** an EV or OV code-signing certificate, or Azure Trusted Signing, so SmartScreen does not warn restaurants.

## 12.4 Printing (V2)

ESC/POS over network, Bluetooth and USB is available in Flutter. The printer survey (RA §21 item 5) decides the transports.
