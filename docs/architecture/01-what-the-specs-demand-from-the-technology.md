# 1. What the specs demand from the technology

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

The stack follows from ten requirements that run through the four specs.

| # | Requirement | Where it comes from |
|---|---|---|
| 1 | **Real time everywhere.** Panel screens update live. Captain positions arrive every 10 s. A new order rings on every restaurant device and stops on all of them when any one handles it. Customers track the captain live. | AP §4.2, RA §4.3–4.4, CA §4.3, CU §4.3 |
| 2 | **Ringing that never fails silently.** Foreground services, the alarm audio stream, full-screen prompts over the lock screen, the Windows window brought to the front, iOS time-sensitive and critical alerts, the device check, 8 hours of idle ringing on a cheap phone. | RA §4.3–4.5, RA §22 item 3, CA §4.4–4.5 |
| 3 | **Many exact server-side timers.** Offer timeout 45 s, pickup auto-confirm 60 s, restaurant auto-cancel, prep late, captain waiting, no receiving device after 5 min, the auto-pause after 3 unanswered orders, and more. Countdowns use server time. | AP §8.3, RA §4.7, RA §8 |
| 4 | **Money that cannot be wrong.** Append-only ledgers, three currencies (USD, TRY, SYP) with a rate snapshot per order, per-currency rounding, captain custody per currency, Thursday payouts, Saturday restaurant settlements, cash-desk receipts and reversing entries. | AP §1.3, AP §8.4–8.7, AP §9.10 |
| 5 | **Weak internet and cheap phones.** Idempotent commands with retries, queued GPS points, caching, under 2 MB of data per delivered order for the captain. | RA §4.7, CA §4.6, CU §4.5 |
| 6 | **Configurable without code.** Typed settings with defaults, scopes, edit roles and effective dates, read by every app from the server. | AP §1.3 item 1, AP §4.4, AP Appendix A |
| 7 | **Geography.** Zone polygons, distance bands, road distance, nearest eligible captain, vote heatmaps, the 150 m and 200 m checks. | AP §9.12, CA §9.2, CA §9.6 |
| 8 | **Security and audit.** TOTP for admins, server-side permissions, logged phone reveals, one device per captain, mock-location detection, an append-only audit log. | AP §4.6, AP §5, CA §4.3, CA §4.9 |
| 9 | **City-by-city growth.** `city_id` on every record from day one, a time zone and base currency per city; stores in V3, wallet and e-payments in V5, smart dispatch in V6. | AP §1.3 item 6, AP §12 |
| 10 | **Local conditions.** APK distribution next to the stores, Syrian (+963) and Turkish (+90) numbers, sign-in codes over WhatsApp only (§2, T4). | RA §4.2, CU §5.2 |

**Consequence.** The heart of the system is the server: the order state machine, the timers, the ledgers, dispatch and real time. The four products are clients of one authority (AP §1.3 item 3). The server is therefore designed first and with the most care.
