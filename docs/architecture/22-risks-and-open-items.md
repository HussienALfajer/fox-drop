# 22. Risks and open items

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

1. **WhatsApp as the only code channel (T4, T5).** A ban or outage of all sending numbers stops new sign-ins; existing sessions continue. Mitigations are in §8.3.3. Still to decide: an emergency procedure for that case (for example, OPS verifying a captain or restaurant by phone and issuing a one-time sign-in from the panel), and when to add the official WhatsApp Cloud API or an SMS provider as a second channel.
2. **Terms of the WhatsApp library.** Automated sending through an unofficial library is outside WhatsApp's terms; numbers can be banned even with the protections. Keep spare warmed numbers ready at all times.
3. **Play policy for foreground service types and full-screen intents.** Verify at submission (RA §21 item 4, CA §18 item 6).
4. **Critical Alerts entitlement.** Apply early; field-test iPhones on silent with and without it (CA §18 item 2).
5. **OSM map quality in Azaz.** Field check before launch (§7.2, CU §18 item 3).
6. **Push delivery on real networks.** The accounts are available (T3); still field-test FCM and APNs delivery on Azaz networks and on phones without Google services (RA §21 item 2).
7. **Hosting account.** Open the DigitalOcean, Cloudflare and Sentry accounts in the name that holds the Apple and Google accounts, and confirm each provider accepts it before the infrastructure is set up.
8. **Paid licences** to budget: `flutter_background_geolocation` (Android), the Windows code-signing certificate, Sentry, Grafana Cloud, PostHog beyond the free tier, Shorebird.
