# 21. Open items (these do not block the build)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

1. **A restaurant that does not pay on Saturday.** Same as AP §13 item 2: decided for V1 (owner decision 2026-11-16): only the reminder and the alert (§12.6), never an automatic pause.
2. **Distribution and push in Azaz.** The Google Play and Firebase accounts are available (technology-stack T3, 2026-11-04). Still test on real devices and networks before launch that push messages arrive; where they do not, the foreground connection (§4.3) is the main route, and the signed APK serves phones without Google Play.
3. **Lending devices.** Will FOX DROP lend a tablet to restaurants without a suitable device, and on what terms (deposit, return, damage)?
4. **Full-screen alerts on Android 14+.** Google Play limits full-screen notifications to some app types. Verify the policy at submission. The fallback is a heads-up notification with the looping sound, which the device check prepares (§4.5).
5. **Printer survey for V2.** Which printers restaurants in Azaz use (Bluetooth or USB thermal, paper width), so V2 printing fits them.
6. **The sign-in screen until the restaurant's screens are drawn.** As CA §18 item 7: D.11 drew only the customer's form of the shared sign-in (owner, 2026-11-24); open whether the restaurant app keeps today's sign-in until its own batch (asked 2026-11-24).
