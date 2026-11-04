# 14. Staff, devices and settings

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

## 14.1 Staff (owners)

- **List:** name, phone, role, number of devices, last active. Owners are listed read-only (§5.1).
- **Add a cashier:** name and phone number. The cashier signs in with that phone (§5.2).
- **Remove a cashier:** after a confirmation, all their devices are signed out.

## 14.2 Devices (owners)

- **List:** device name, platform, user, app version, ringing on or off, connected now or last seen, last device-check result.
- **Actions:** rename a device, or sign it out. Signing out a cashier's device does not remove the cashier.
- **Warning:** a banner shows when the restaurant has no receiving device (§4.6).

## 14.3 Settings

- **This device:**
  - «الرنين على هذا الجهاز» (owner devices only, §4.4)
  - «إبقاء الشاشة مضاءة» (Android, §6.2)
  - «تجربة الصوت» (test sound)
  - «فحص الجهاز» (device check, §4.5)
  - app version, and sign out
- **Restaurant (owners):** pickup currencies (§12.7). Prep time, the limit and hours are in Status and hours (§10).
- **Restaurant info (read-only):** name, logo, address, phone, category, commission %, contract dates, and the FOX DROP contact numbers.
