# 18. Open items (these do not block the build)

> Part of the [captain app spec](README.md) (CA). A bare "§n" here means CA §n.

1. **iPhone distribution in Azaz.** _Closed_ (technology-stack T3, 2026-11-04): the Apple Developer account is available. App review requirements are handled at submission.
2. **Critical Alerts on iPhone.** Apply to Apple for the entitlement (K15). Without it, an iPhone on silent may not sound for offers. Field-test both cases before launch.
3. **Push in Azaz.** The Google Play and Firebase accounts are available (technology-stack T3). As RA §21 item 2: still test FCM and APNs delivery on real devices and networks.
4. **Distance service.** _Decided_ (AP §13 item 8): self-hosted OSRM (technology-stack §7.1), with the straight-line fallback.
5. **Insurance and accidents.** _Decided_ (owner, 2026-11-28): the captain is independent and covers their own vehicle and insurance, and the contract says so. Operations follow a written procedure after the emergency button: call the captain, move the order to another captain, and charge no fault for that order. Nothing in the system changes; the procedure goes in the operations runbook before launch.
6. **Full-screen offers on Android 14+.** Google Play limits the full-screen notification permission to some app types (as RA §21 item 4). Verify the policy at submission. The fallback is a heads-up notification with the looping alarm sound, which the device check prepares.
7. **The sign-in screen until the captain's screens are drawn.** _Decided_ (T16, 2026-11-27): D.R1 deleted the old sign-in screen and the batches; the new sign-in screen, one for the three apps (`core_auth`), is the first screen drawn and built (`docs/roadmap.md`, customer screens), and the captain app takes it as it is.
