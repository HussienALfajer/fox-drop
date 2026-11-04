# 21. Open items (these do not block the build)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

1. **A restaurant that does not pay on Saturday.** Same as AP §13 item 2: should the restaurant be paused automatically after some days or above some amount? Until decided, there is only the reminder and the alert (§12.6).
2. **Distribution and push in Azaz.** The Google Play and Firebase accounts are available (technology-stack T3, 2026-11-04). Still test on real devices and networks before launch that push messages arrive; where they do not, the foreground connection (§4.3) is the main route, and the signed APK serves phones without Google Play.
3. **Lending devices.** Will FOX DROP lend a tablet to restaurants without a suitable device, and on what terms (deposit, return, damage)?
4. **Full-screen alerts on Android 14+.** Google Play limits full-screen notifications to some app types. Verify the policy at submission. The fallback is a heads-up notification with the looping sound, which the device check prepares (§4.5).
5. **Printer survey for V2.** Which printers restaurants in Azaz use (Bluetooth or USB thermal, paper width), so V2 printing fits them.
