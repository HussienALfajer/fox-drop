# 21. Open items (these do not block the build)

> Part of the [restaurant app spec](README.md) (RA). A bare "§n" here means RA §n.

1. **A restaurant that does not pay on Saturday.** Same as AP §13 item 2: decided for V1 (owner decision 2026-11-16): only the reminder and the alert (§12.6), never an automatic pause.
2. **Distribution and push in Azaz.** The Google Play and Firebase accounts are available (technology-stack T3, 2026-11-04). Still test on real devices and networks before launch that push messages arrive; where they do not, the foreground connection (§4.3) is the main route, and the signed APK serves phones without Google Play.
3. **Lending devices.** _Decided_ (owner, 2026-11-28): not at launch. A restaurant uses its own phone, Android tablet, Windows device or the owner web portal; lending is looked at again after launch if the need shows. Nothing in the system.
4. **Full-screen alerts on Android 14+.** Google Play limits full-screen notifications to some app types. Verify the policy at submission. The fallback is a heads-up notification with the looping sound, which the device check prepares (§4.5).
5. **Printer survey for V2.** Which printers restaurants in Azaz use (Bluetooth or USB thermal, paper width), so V2 printing fits them.
6. **The sign-in screen until the restaurant's screens are drawn.** _Decided_ (T16, 2026-11-27): D.R1 deleted the old sign-in screen and the batches; the new sign-in screen, one for the three apps, is the first screen drawn and built (`docs/roadmap.md`, customer screens), and the restaurant app takes it as it is.
