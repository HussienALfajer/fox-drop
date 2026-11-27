# 10. Admin panel and owner portal (web)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 10.1 Stack

As built (aligned with the code on 2026-11-27, §2 T17). A library named "when needed" is added by the slice that first needs it, as its own decision.

| Concern           | Choice                                                                                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Build             | **Vite**, React (latest stable), TypeScript strict                                                                                                                 |
| Routing           | **TanStack Router**, routes written in code (`src/router.tsx`), typed routes and search parameters                                                                 |
| Server state      | **TanStack Query**; real-time events from Centrifugo (`centrifuge`) invalidate what they changed and a full fetch follows every reconnect                          |
| Tables and lists  | Plain HTML tables, paged by the server; **TanStack Table** and **TanStack Virtual** when a list outgrows them (when needed)                                        |
| Forms             | Controlled React state in each feature file, validated by the server's answer (the generated types); no form library                                               |
| Components        | `packages/ui-web` on **UI SDK**, Base UI per component as the fallback (T11, §9.10); none yet (T16)                                                                |
| Maps              | **MapLibre GL JS** with **PMTiles** from `/maps/`; zones are edited with FOX DROP's own corner editing on MapLibre, no drawing library (owner decision 2026-11-19) |
| Charts            | Shown as tables until their screens are designed; a chart library is chosen with that screen (when needed)                                                         |
| Dates and numbers | `Intl` formatters with `ar-u-nu-latn` (Western digits) on the chosen city's time zone (`format.ts`, `clock.ts`)                                                    |
| Translations      | `i18next` and `react-i18next`, typed keys, Arabic as the only V1 language (AP D21)                                                                                 |
| API client        | Generated from OpenAPI (`openapi-typescript`, `openapi-fetch` in `packages/api-schema`, §5.3)                                                                      |
| Other             | `qrcode` (the TOTP enrolment's QR code at setup, AP §5.1)                                                                                                          |

## 10.2 Why a single-page app

The panel and the portal are behind sign-in and need no SEO or server rendering. A static single-page app is simpler to run, is served as static files by nginx (§17.2), and keeps all logic on the server API.

## 10.3 Panel specifics

- **Alert sound (AP D22):** Web Audio. At sign-in the panel asks for one click «تفعيل الصوت» because browsers block autoplay; it shows a red banner until sound is enabled.
- **Live screens** subscribe to the city channels (§6.2) and reconcile with a full fetch after every reconnect.
- **Phones (AP §7.5):** the dashboard, operations room, order detail, live map, alerts, tickets and the restaurant settlement screen are responsive.
- **Sign-in:** password hashed with **Argon2id**, TOTP per RFC 6238 (`otplib`), 10 backup codes stored hashed (AP §5.1).
- **Session:** an HTTP-only, secure, same-site cookie, with idle and maximum lifetimes enforced on the server (AP §5.2).

## 10.4 Owner portal

- Same stack and same component library as the panel, its own app in the monorepo (`apps/merchant-portal`).
- Read-only live view of orders; no ringing and no order receiving (RA §4.1).
- Sign-in by phone and WhatsApp code (§8.3), session 30 days (RA §5.3).
