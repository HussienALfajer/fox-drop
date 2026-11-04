# 10. Admin panel and owner portal (web)

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 10.1 Stack

| Concern           | Choice                                                                                             |
| ----------------- | -------------------------------------------------------------------------------------------------- |
| Build             | **Vite**, React (latest stable), TypeScript strict                                                 |
| Routing           | **TanStack Router** (typed routes and search parameters)                                           |
| Server state      | **TanStack Query**; real-time events from Centrifugo update the query cache directly               |
| Tables            | **TanStack Table** with **TanStack Virtual** for long lists (operations room, history, statements) |
| Forms             | **React Hook Form** with **Zod** schemas shared with the server                                    |
| Components        | `packages/ui-web` on **Base UI** (§9.2)                                                            |
| Maps              | **MapLibre GL JS**; **Terra Draw** for drawing zone polygons                                       |
| Charts            | **Apache ECharts** (RTL, large data sets)                                                          |
| Dates and numbers | `date-fns` with `date-fns-tz`; `Intl` formatters with Western digits                               |
| Translations      | `i18next` with Arabic as the only V1 language (AP D21)                                             |
| API client        | Generated from OpenAPI (§5.3)                                                                      |

## 10.2 Why a single-page app

The panel and the portal are behind sign-in and need no SEO or server rendering. A static single-page app is simpler to run, is served from the CDN, and keeps all logic on the server API.

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
