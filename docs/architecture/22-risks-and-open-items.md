# 22. Risks and open items

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

1. **WhatsApp as the only code channel (T4, T5).** A ban or outage of all sending numbers stops new sign-ins; existing sessions continue. Mitigations are in §8.3.3. Still to decide: an emergency procedure for that case (for example, OPS verifying a captain or restaurant by phone and issuing a one-time sign-in from the panel), and when to add the official WhatsApp Cloud API or an SMS provider as a second channel.
2. **Terms of the WhatsApp library.** Automated sending through an unofficial library is outside WhatsApp's terms; numbers can be banned even with the protections. Keep spare warmed numbers ready at all times.
3. **Play policy for foreground service types and full-screen intents.** Verify at submission (RA §21 item 4, CA §18 item 6).
4. **Critical Alerts entitlement.** Apply early; field-test iPhones on silent with and without it (CA §18 item 2).
5. **OSM map quality in Azaz.** Field check before launch (§7.2, CU §18 item 3).
6. **Push delivery on real networks.** The accounts are available (T3); still field-test FCM and APNs delivery on Azaz networks and on phones without Google services (RA §21 item 2).
7. **Accounts and domain.** Buy the domain and open the Sentry, PostHog and Grafana Cloud accounts in the name that holds the Apple and Google accounts, and confirm each provider accepts it before staging is set up.
8. **Paid licences** to budget: `flutter_background_geolocation` (Android), the Windows code-signing certificate, Sentry, Grafana Cloud, PostHog beyond the free tier, Shorebird.
9. **Hosting without Cloudflare (T9, decided).** Cloudflare is blocked in Syria, and FOX DROP is hosted on the owner's Contabo server (§17.2). Reachability from Syria: Doppler is not used (§15.4); Sentry and PostHog are reached only through FOX DROP's domain, and Grafana Cloud only from the server (§16), so whether Syria reaches them no longer matters. Still for the owner to check on phones in Azaz, on each mobile network, before launch: Firebase Cloud Messaging and App Check (Google services, item 6), installing from Google Play and the App Store, and the relays to Sentry and PostHog end to end on staging.
10. **One shared server (T9).** Staging, production and the owner's other sites share one server with no standby: a load spike or an outage of any of them, or of the server, stops live orders, and a lost disk loses everything since the last off-server backup. Mitigations: memory and CPU limits per container, the off-server backups and a tested restore (§17.2), and alerts on the server's memory, disk and load (§16). Move production to a dedicated server when load or a second city requires it.
