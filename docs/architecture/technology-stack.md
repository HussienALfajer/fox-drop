# FOX DROP — Technology Stack and Architecture

| | |
|---|---|
| Product | FOX DROP, a food delivery platform launching in Azaz, Syria, then expanding city by city |
| Scope | The technical foundation for V1, designed to carry V2–V6 without a rewrite |
| Component | The shared server, the admin panel, the restaurant app and owner portal, the customer app and the captain app |
| Status | Approved by the owner on 2026-11-04 (decisions in §2) |
| Audience | Engineers and coding agents (Claude Code) who set up the repositories, the infrastructure and the code |
| Related | Admin panel spec `docs/v1/admin-panel.md` ("AP §n"). Restaurant app spec `docs/v1/restaurant-app.md` ("RA §n"). Captain app spec `docs/v1/captain-app.md` ("CA §n"). Customer app spec `docs/v1/customer-app.md` ("CU §n"). BeeOrder technical findings: `docs/beeorder-research/01-customer-app.md` §10 |

---

## 0. How to use this document

- The four V1 specs say *what* the platform does. This document says *with what* and *how it is structured*. Where a spec says "the technical plan confirms the stack", this document is that plan.
- **MUST**, **SHOULD** and **MAY** as in AP §0.
- Product names are the chosen technology. "Latest stable" or "current LTS" means the version current when the repository is created; exact versions are pinned in lockfiles and upgraded on purpose (§19.4), never floating.
- A change to a choice in this document is a decision: record it in §2 with a date and a reason, and update every section that depends on it.

---

## 1. What the specs demand from the technology

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

---

## 2. Decisions

### 2.1 Owner decisions (2026-11-04)

| ID | Topic | Decision |
|---|---|---|
| T1 | Overall stack | The stack in §3 is approved, with the changes below. |
| T2 | Design system | FOX DROP has its own UI/UX design. The web uses **Base UI** headless primitives instead of Radix, with FOX DROP's own components and styling. shadcn/ui is not used. The Flutter apps use the same design language (§9). |
| T3 | Store and Firebase accounts | Apple Developer, Google Play and Firebase are available to FOX DROP. The store-availability open items in the specs are closed (§23). |
| T4 | Sign-in codes | Codes are sent over **WhatsApp only**, through a third-party WhatsApp sending library, with protections that keep the sending numbers from being banned as far as possible (§8.3). |
| T5 | SMS and voice | There is no SMS provider for now. SMS and voice codes are not part of V1. The channel abstraction keeps them possible later without a client change (§8.3.1). |

### 2.2 Rules set by this document (the owner may change them)

| ID | Rule |
|---|---|
| E1 | One modular monolith for the server in V1, not microservices (§4). |
| E2 | PostgreSQL is the only system of record. Redis holds nothing that cannot be rebuilt (§5.4, §5.7). |
| E3 | Every state change and every timer is written in the same database transaction (§5.5). |
| E4 | Every event leaves the server through a transactional outbox (§5.5). |
| E5 | All three mobile and desktop apps are Flutter apps in one repository with shared packages (§11). |
| E6 | API clients are generated from the OpenAPI document, never written by hand (§5.3). |
| E7 | No secret is shipped inside an app or a web bundle (§15.4). |
| E8 | Everything runs in containers from the first deployment (§17). |

---

## 3. The stack at a glance

| Layer | Choice |
|---|---|
| **Server runtime** | Node.js (current LTS), TypeScript in strict mode |
| **Server framework** | NestJS on the Fastify adapter, as a modular monolith |
| **Database** | PostgreSQL (latest stable) with PostGIS and `pg_trgm` |
| **Jobs and timers** | pg-boss (queue and scheduled jobs inside PostgreSQL) |
| **Cache, locks, rate limits, live positions** | Valkey (Redis-compatible), including GEO commands |
| **Real time** | Centrifugo (WebSocket server with history and recovery) |
| **API** | REST with OpenAPI 3.1; generated Dart and TypeScript clients |
| **Routing and distances** | OSRM, self-hosted, with OpenStreetMap data for Syria |
| **Map display** | MapLibre (web and Flutter) with OpenStreetMap vector tiles |
| **Push** | Firebase Cloud Messaging (Android, and iOS through APNs) |
| **Sign-in codes** | WhatsApp through a third-party library, isolated in the `otp-sender` worker (§8.3) |
| **App integrity** | Firebase App Check (Play Integrity on Android, App Attest on iOS) |
| **Files and images** | S3-compatible object storage (Cloudflare R2) with imgproxy behind the CDN |
| **Admin panel and owner portal** | React, TypeScript, Vite (single-page apps), TanStack Router, Query and Table, Base UI, Tailwind CSS |
| **Restaurant app** | Flutter for Android and Windows, with native Kotlin and Win32 layers for ringing |
| **Customer app** | Flutter for Android and iOS |
| **Captain app** | Flutter for Android and iOS, with `flutter_background_geolocation` and native Kotlin and Swift layers for offers |
| **Errors** | Sentry (server, web, Flutter) |
| **Metrics, logs, traces** | OpenTelemetry, then Grafana, Prometheus, Loki and Tempo |
| **Product analytics** | PostHog |
| **Hosting** | Docker containers on DigitalOcean (Frankfurt, FRA1) with managed PostgreSQL and managed Valkey; Cloudflare in front |
| **CI/CD** | GitHub Actions; Kamal for V1 deployments, managed Kubernetes from V3 |
| **Infrastructure as code** | Terraform |

---

## 4. Architecture

### 4.1 Modular monolith (E1)

The server is **one deployable application made of strictly separated modules**. It runs as several processes from the same image (§4.4).

Why not microservices in V1: they would put the money flows behind distributed transactions, multiply deployments and monitoring, and add network failures between parts that today change together. The modular monolith gives build speed now and lets any module become a service later, because its boundaries are already enforced.

### 4.2 Modules

| Module | Owns |
|---|---|
| `identity` | Users of all four products, sessions, devices, OTP, TOTP, roles and permissions |
| `geo` | Cities, zones, distances (OSRM client), zone checks, votes |
| `settings` | The typed settings catalogue, scopes, effective dates and their history (AP §4.4) |
| `content` | Texts, terms versions, reason lists (AP §9.13) |
| `merchants` | Restaurants, hours, states, devices, menu, menu change requests |
| `ordering` | The quote, the order, its state machine, edits, outcomes |
| `dispatch` | Eligibility, ranking, offers, assignments, handovers |
| `captains` | Applications, documents, contracts, availability, performance, violations |
| `customers` | Profiles, addresses, trust, strikes, dues |
| `ledger` | Accounts and append-only double-entry ledger entries in every currency |
| `cashdesk` | Drawer sessions, receipts, hand-ins, payouts, restaurant settlements |
| `fx` | Exchange rates and rounding per currency |
| `support` | Tickets, compensation, approvals |
| `marketing` | Promo codes, banners, home sections, mass push |
| `notifications` | Push, in-app messages, real-time publishing, sound levels |
| `audit` | The append-only audit log |
| `reporting` | Daily report, statements, exports (reads from the replica) |

### 4.3 Module rules (MUST)

1. Each module owns a **PostgreSQL schema** with the same name. No module reads or writes another module's tables.
2. Modules call each other only through the other module's public service interface, or react to its domain events.
3. Domain events are typed, versioned and published inside the process. Events that must leave the process go through the outbox (§5.5).
4. A lint rule (`eslint-plugin-boundaries` or the Nx module-boundary rule) fails the build on a forbidden import.
5. Money moves only through the `ledger` module. No other module writes balances.

### 4.4 Processes

The same container image runs in four roles:

| Role | Does |
|---|---|
| `api` | HTTP API for all clients. Stateless, scaled horizontally. |
| `worker` | pg-boss jobs: timers, outbox relay, push sending, exports, reports |
| `dispatcher` | The dispatch loop for each city (one active leader per city, using a PostgreSQL advisory lock) |
| `otp-sender` | The WhatsApp sessions and the sending queue (§8.3). Isolated so a library crash never affects the API. |

Centrifugo, OSRM and imgproxy run as their own containers.

---

## 5. Server

### 5.1 Language and framework

- **TypeScript (strict), Node.js current LTS, NestJS on Fastify.**
- One language across the server, the admin panel and the owner portal: shared validation schemas and types.
- NestJS enforces the module structure of §4, has dependency injection, guards for permissions, and OpenAPI generation.
- **Validation:** Zod schemas at every API boundary, shared with the web clients (`nestjs-zod`).
- **Database access:** **Drizzle ORM** with SQL-first migrations (`drizzle-kit`), reviewed as SQL. Complex reporting queries are written as plain SQL.

### 5.2 Data model rules (MUST)

- `city_id` on every business record from day one (AP §1.3 item 6).
- Primary keys are **UUIDv7** (time-ordered). Human numbers (`#10423`, `AZ-2026-000123`, `T-5521`, AP §4.8) are separate columns from per-city sequences.
- Times are stored as `timestamptz` in UTC. The city's time zone is applied for display and for the business day (AP §4.3).
- Money is stored as **`bigint` in minor units** with an explicit currency code on every amount. The minor unit per currency comes from `fx`. Floating point is never used for money.
- Every order keeps a snapshot of the exchange rates, the fee rule, the commission and the pay table version it used.
- Phone numbers are stored in E.164 format.
- Soft state, such as "closed account", is a status column. Business records are not deleted.

### 5.3 API (E6)

- **REST over HTTPS, documented by OpenAPI 3.1** generated from the NestJS controllers.
- Clients are generated in CI: Dart (`openapi-generator`, `dart-dio`) for the Flutter apps, TypeScript (`openapi-typescript`, `openapi-fetch`) for the web. A breaking change fails the build of a client.
- Separate route groups per product: `/admin/*`, `/merchant/*`, `/captain/*`, `/customer/*`. Each group has its own guards and rate limits.
- Versioned under `/v1`. Apps also send their app version; the server can refuse versions below `app.*.min_version` (AP §9.14).
- **Idempotency:** every command carries an `Idempotency-Key` header (RA §4.7). The server stores the key with the response for 24 hours and returns the stored response for a repeat.
- **Optimistic concurrency:** commands on an order carry the order version they were made against. A stale command returns `409` with the current state, which the apps explain (RA §4.7).
- **Server time:** every response carries a `Server-Time` header. The apps compute their clock offset from it (RA §4.7).
- **Light and heavy reads are separate** (CU §4.5): lists come first from a cheap cached call, estimates and fees after.
- GraphQL is not used: it adds caching complexity without benefit on weak networks.

### 5.4 Database

- **PostgreSQL**, latest stable, managed (§17.2), with a hot standby and a read replica.
- **PostGIS** for zones (polygons), point-in-zone checks, distance checks and the vote heatmap.
- **Partitioning** by month for orders, order events, location history, ledger entries and the audit log.
- **Search in V1:** PostgreSQL full text plus `pg_trgm`, on a normalised Arabic column. Normalisation removes diacritics and tatweel and unifies «أ إ آ ا», «ة ه» and «ى ي».
- **Backups:** continuous WAL archiving with point-in-time recovery, daily snapshots kept 30 days, a weekly copy in a second provider. A restore is tested every month.
- The reporting module reads from the replica only.

### 5.5 Order state machine, timers and the outbox (E3, E4)

- The order lifecycle (AP §8.1) is an explicit state machine in the `ordering` module. Each transition:
  1. checks the current state and version,
  2. writes the new state and increments the order version,
  3. appends a row to `order_events`,
  4. schedules or cancels the timers this state needs,
  5. writes the outgoing events to the outbox,
  6. all in **one transaction**.
- **Timers** are pg-boss jobs created in that transaction, so a timer exists exactly when its state exists. When it fires, the job re-reads the order and acts only if the state and version still match. A late or repeated job is therefore harmless.
- **Outbox:** a relay job reads committed outbox rows in order and publishes them to Centrifugo and to push. Delivery is at least once; clients ignore events older than the version they show (RA §4.3).
- **From V3:** when errands, stores and multi-step flows multiply the long-running processes, move them to **Temporal**. The state-machine and outbox design above makes this a module change, not a rewrite.

### 5.6 Ledger

- **Double entry.** Every money movement is one journal with two or more entries that balance to zero per currency.
- Accounts per party and purpose: captain custody per currency, captain earnings, restaurant account, platform revenue, platform cash per drawer, discounts, compensation and so on (AP §8.5, §8.7, §8.11).
- Entry types are enum values (for example `custody.pay_merchant`, `earn.order_pay`, CA §0).
- **Append-only, enforced in the database:** the application role has `INSERT` and `SELECT` on ledger tables, never `UPDATE` or `DELETE`. Corrections are reversing journals with a reason (AP §1.3 item 5).
- Balances are computed from entries. Cached balances are rebuilt from entries and checked by a nightly reconciliation job that alerts on any difference.
- The ledger is designed for V5 from day one: a wallet is one more account type, and an e-payment is one more journal type.

### 5.7 Valkey (E2)

- Last known captain position and state, as a GEO set per city, for `GEOSEARCH` in dispatch.
- Rate limits (OTP, API), short locks, and caches (settings, menus, home sections).
- Everything in it can be rebuilt from PostgreSQL or from the next location update.

### 5.8 Files and images

- **Cloudflare R2** (S3 API), two buckets:
  - `public-media`: menu photos, logos, banners. Served through the Cloudflare CDN and **imgproxy**, which resizes and converts to WebP or AVIF per screen size (CU §4.5).
  - `private-docs`: captain documents, contracts, report photos. Encrypted at rest, never public, opened with short-lived signed URLs, every view audited.
- Uploads go directly from the app to storage with a pre-signed URL. The server checks type and size before linking the file to a record.

### 5.9 Exports

Excel exports (AP §9.10.1, §9.17) are generated on the server by a worker job with **ExcelJS**, stored in `private-docs` for 24 hours and downloaded through a signed URL. Every export is audited (AP §5.4).

---

## 6. Real time

### 6.1 Centrifugo

- **Centrifugo** is a dedicated WebSocket server. It holds the connections; the API stays stateless.
- **History and recovery:** each channel keeps recent messages. A client that reconnects with its last offset receives what it missed. When recovery is not possible, the client re-fetches the full state (AP §4.2, RA §4.3).
- **Presence** tells the server which restaurant devices are connected, for the receiving-device rule (RA §4.6).
- Clients connect with a short-lived JWT issued by the API. Channel access is checked by the API (subscription proxy).
- Official clients: `centrifuge` for the web, `centrifuge-dart` for Flutter.

### 6.2 Channels

| Channel | Subscribers | Carries |
|---|---|---|
| `ops:city.{city_id}` | Panel users with access to the city | Orders, alerts, tickets, cash desk, emergency stop |
| `ops_map:city.{city_id}` | Live map screen | Captain positions and states (every 10 s) |
| `merchant:{merchant_id}` | Every signed-in device of the restaurant | Orders, pickup requests, edits, state, banners |
| `captain:{captain_id}` | The captain's device | Offers, assignment changes, order events, banners |
| `order:{order_id}` | The customer's devices while the order is active | Status, ETA, captain position after pickup |
| `customer:{customer_id}` | The customer's devices | Account state, codes, banners |

### 6.3 Heartbeats and fallbacks

- Restaurant devices send a heartbeat every 20 s; the server marks a device disconnected after 60 s (fixed, RA §4.3).
- Push is a second channel only. The Android apps MUST NOT depend on push alone (RA §4.3).
- The customer app polls every 30 s when the socket is down on an order screen (CU §4.3).

---

## 7. Maps, routing and location

### 7.1 Routing: OSRM, self-hosted

- **OSRM** with the OpenStreetMap extract for Syria, rebuilt weekly from fresh OSM data.
- Used for: road distance for the delivery fee (AP §9.12.3), the ETA, the captain route line, and the distance matrix in dispatch.
- Profiles: car and motorbike (on the car profile with adjusted speeds), bicycle, walking.
- Fallback when OSRM does not answer: straight line × 1.3 (fixed, AP §9.12.3).
- OSRM is reached only through the server, never from an app.
- This closes AP §13 item 8 (§23).

### 7.2 Map display: MapLibre with OpenStreetMap tiles

- **MapLibre GL JS** on the web and **`maplibre_gl`** in Flutter, with vector tiles built from OpenStreetMap (Protomaps PMTiles hosted on R2, or OpenFreeMap).
- No per-view billing, one style shared by all products, Arabic labels.
- **Field check before launch (CU §18 item 3):** compare the OSM map of Azaz's neighbourhoods with Google Maps. If OSM is clearly weaker, the customer pin screen MAY use Google Maps for display only, behind the same map interface in `core_maps` (§11.2).
- Navigation is handed to Google Maps or Apple Maps (CA §4.6).
- Place search is not required in V1: customers set a pin and a landmark (CU §7.3).

### 7.3 Location data

- Captain positions arrive every 10 s while online (CA §4.3), are written to Valkey for dispatch and published to the map channel, and are written in batches to a partitioned `captain_locations` table for routes and disputes.
- History is kept for 90 days, then aggregated. Positions are never collected while offline (CA §4.3).
- Customer device positions are not stored with orders (CU §4.4).

---

## 8. Notifications and sign-in codes

### 8.1 Push

- **Firebase Cloud Messaging** for Android and for iOS (through APNs). One Firebase project per environment (development, staging, production).
- Message types: high priority for new orders, pickup requests, offers, cancellations and arrival (RA §4.3, CA §4.4, CU §4.3); normal for the rest; time-sensitive on iOS where the specs say so.
- Sending runs in the `worker` from the outbox, with retries and removal of invalid tokens.
- Apply to Apple for the **Critical Alerts** entitlement for the captain app (CA §4.4, CA §18 item 2).

### 8.2 In-app sounds

Ring, chime and silent levels are played by the apps themselves (RA §4.4, CA §4.4), not by the push payload. Push only wakes the app or shows a notification when the app cannot run.

### 8.3 Sign-in codes over WhatsApp (T4, T5)

#### 8.3.1 The channel abstraction

- The `identity` module asks a **`CodeSender` port** to deliver a code. V1 has one adapter: `WhatsAppLibrarySender`.
- The adapter runs in the separate `otp-sender` process (§4.4). The API puts a send request on a queue and does not wait for the library.
- **Library:** the chosen third-party WhatsApp library. The default candidate for a Node.js server is **Baileys** (WhatsApp multi-device protocol, no browser needed). The adapter hides it completely, so it can be replaced by another library, by the official WhatsApp Cloud API, or by an SMS adapter later, with no change in the apps.
- `otp.channel_order` stays a setting, with `whatsapp` as its only value in V1. SMS and voice are reserved for later (T5).

#### 8.3.2 The code itself (MUST)

- 6 digits (fixed, CU §5.2), generated with a cryptographic random generator.
- Stored only as a hash with the number, the device and the expiry. Compared in constant time.
- One active code per number: a new request replaces the old code.
- Validity `otp.validity_min` (5), attempts `otp.max_attempts` (5), resend wait `otp.resend_after_sec` (60) (AP Appendix A).
- The response to "send a code" is the same whether the number has an account or not, except where a spec shows a specific message (RA §5.2 items 3–4).

#### 8.3.3 Protection against banning the sending numbers

WhatsApp bans numbers that send many messages to people who did not expect them, that get reported or blocked, or that behave like automation. The design below keeps the sending numbers' behaviour close to a normal business account and stops abuse before it reaches WhatsApp.

**A. Only real users can trigger a message**

1. **App integrity:** a code request MUST carry a valid **Firebase App Check** token (Play Integrity on Android, App Attest on iOS; the Windows app uses its device registration). Requests from scripts and modified apps are refused before any message is sent. This stops the main cause of bans: mass requests to random numbers.
2. **Requester limits** (server side, in Valkey):
   - per phone number: `otp.number_hourly_max` (3) and `otp.number_daily_max` (6)
   - per device: `otp.device_daily_max` (6)
   - per IP address: `otp.ip_hourly_max` (30)
   - the resend wait (60 s) between two codes to the same number
   - after the daily limit: «تجاوزت عدد المحاولات المسموح، حاول غداً أو تواصل مع الدعم»
3. **The number must be on WhatsApp:** before sending, the sender checks that the number has a WhatsApp account (cached for 30 days). If it does not, nothing is sent and the app shows «هذا الرقم غير مسجّل على واتساب». Messages to numbers without WhatsApp are a strong ban signal.

**B. The sending numbers behave like a business**

4. **Dedicated numbers:** two or more numbers owned by FOX DROP, used only for sign-in codes. Never a personal number, never the support number, never used for marketing or mass push (AP §9.11.4 uses push, not WhatsApp).
5. **Business profile complete** on every number: name «FOX DROP», logo, description, website.
6. **Warm-up:** a new number starts with a low daily cap that rises over two weeks (`otp.sender_warmup_caps`, default 50 → 100 → 200 → 400 → 800 → full). A number is used for codes only after it has been active and normal for some days.
7. **Pacing:** each number sends at most `otp.sender_per_minute_max` (12) and `otp.sender_daily_max` (1500) messages, with a random delay of `otp.send_jitter_sec` (1–4) seconds between sends. A short queue absorbs peaks.
8. **One short, fixed message.** No links, no marketing, the same structure every time, chosen from a few approved wordings in Content (AP §9.13), for example:
   «رمز الدخول إلى FOX DROP: 482913
   لا تشارك هذا الرمز مع أحد. إن لم تطلبه فتجاهل هذه الرسالة.»
9. **Replies are answered:** when someone writes to a sending number, it answers once with a fixed message pointing to the support WhatsApp number. Unanswered conversations and confused users lead to reports.
10. **Stable server:** the sessions run from a fixed server IP in one region. Session credentials are stored encrypted in PostgreSQL, so a restart does not force a new pairing.

**C. Failover and monitoring**

11. **Sender pool:** each number has a state: `warming`, `active`, `standby`, `throttled`, `disconnected` or `banned`. Sending uses the active numbers in rotation. If a number disconnects, is throttled or is banned, sending moves to the next number at once.
12. **Health signals** recorded per number: sent, delivered, read, failed, blocks and reports where the library exposes them. A rising failure rate throttles the number automatically.
13. **Panel screen «أرقام إرسال الرموز»** (OWN, in Settings, AP §9.14): add a number and pair it by scanning a QR code, see its state and daily counts, set it active or standby, disable it.
14. **Alerts** (AP §9.1.3):
    - «رقم إرسال الرموز متوقف» (Warning, OWN): one number is disconnected, throttled or banned.
    - «لا يمكن إرسال رموز الدخول» (Critical, OWN and OPS): no active number can send.

**D. Fewer codes overall**

15. Sessions are long, so codes are rare: customer and captain sessions do not expire with inactivity (CU §5.4, CA §4.9), restaurant app sessions likewise (RA §5.3).
16. Opening the app never asks for a code again. A code is needed only for a new device or after a sign-out.

**What this cannot guarantee.** A third-party library uses an unofficial interface; WhatsApp may still restrict or ban a number, and its terms do not allow automated sending outside its official Business Platform. With WhatsApp as the only channel, a full outage means no **new** sign-ins until a number works again; existing sessions continue. The long-term fix is the official WhatsApp Cloud API with authentication templates, or an SMS provider as a second channel. Both plug into the `CodeSender` port (§8.3.1). See §22.

#### 8.3.4 In the apps

- The screen says where the code was sent: «أرسلنا الرمز إلى واتساب على الرقم {الرقم}» (CU §5.2).
- After the resend wait, only «إعادة الإرسال» and «تعديل الرقم» are offered. There is no SMS or voice option in V1.
- SMS auto-fill does not apply to WhatsApp messages. The code field accepts paste, and on Android the app offers to paste a 6-digit code it finds on the clipboard.

---

## 9. Design system (T2)

### 9.1 One design language, two implementations

- FOX DROP's own UI/UX design is the source. It is defined once as **design tokens**: colours (light and dark), typography, spacing, radii, shadows, motion, z-order, icon sizes.
- Tokens are stored in the W3C Design Tokens format (JSON) in `packages/design-tokens` and compiled with **Style Dictionary** into:
  - CSS variables and a Tailwind theme for the web
  - a Dart theme file for `core_ui` in Flutter
- A token change reaches both platforms in the same build.

### 9.2 Web components: Base UI

- **Base UI** provides unstyled, accessible primitives: dialog, popover, menu, select, combobox, tabs, tooltip, toast, checkbox, radio, switch, slider, field and form, scroll area, and others. It handles focus, keyboard navigation, ARIA and RTL.
- FOX DROP builds its own component library on top in `packages/ui-web`: buttons, inputs, tables, cards, badges, alert banners, timers, money and status chips, the order card, and so on. Styling is Tailwind CSS on the tokens, with logical properties (`ms-*`, `pe-*`, `start`, `end`) so RTL is the default and LTR works later (AP §12 lists English for V2).
- Variants are written with `tailwind-variants`. Icons come from one icon set chosen by the design (Lucide by default), wrapped in an `Icon` component so the set can change.
- **Storybook** documents every component in RTL, light and dark, with visual tests (§18).

### 9.3 Flutter components: `core_ui`

- `core_ui` implements the same components as Flutter widgets on the tokens. The apps use `core_ui` widgets, not raw Material widgets, so they look like FOX DROP and not like stock Material.
- Material 3 is used only underneath for platform behaviour (text selection, scrolling, accessibility).
- RTL by default (`Directionality` from the Arabic locale). Layouts stay usable with the system font at 130% (RA §4.8, CA §4.7, CU §4.6).
- A widget catalogue app (`widgetbook`) documents the components, like Storybook on the web.

### 9.4 Typography

- One Arabic typeface family with a matching Latin, chosen by the design, bundled in the apps and self-hosted on the web (never loaded from a third-party font CDN in the apps).
- Western digits everywhere (AP §4.7), with tabular figures for money, timers and tables.

---

## 10. Admin panel and owner portal (web)

### 10.1 Stack

| Concern | Choice |
|---|---|
| Build | **Vite**, React (latest stable), TypeScript strict |
| Routing | **TanStack Router** (typed routes and search parameters) |
| Server state | **TanStack Query**; real-time events from Centrifugo update the query cache directly |
| Tables | **TanStack Table** with **TanStack Virtual** for long lists (operations room, history, statements) |
| Forms | **React Hook Form** with **Zod** schemas shared with the server |
| Components | `packages/ui-web` on **Base UI** (§9.2) |
| Maps | **MapLibre GL JS**; **Terra Draw** for drawing zone polygons |
| Charts | **Apache ECharts** (RTL, large data sets) |
| Dates and numbers | `date-fns` with `date-fns-tz`; `Intl` formatters with Western digits |
| Translations | `i18next` with Arabic as the only V1 language (AP D21) |
| API client | Generated from OpenAPI (§5.3) |

### 10.2 Why a single-page app

The panel and the portal are behind sign-in and need no SEO or server rendering. A static single-page app is simpler to run, is served from the CDN, and keeps all logic on the server API.

### 10.3 Panel specifics

- **Alert sound (AP D22):** Web Audio. At sign-in the panel asks for one click «تفعيل الصوت» because browsers block autoplay; it shows a red banner until sound is enabled.
- **Live screens** subscribe to the city channels (§6.2) and reconcile with a full fetch after every reconnect.
- **Phones (AP §7.5):** the dashboard, operations room, order detail, live map, alerts, tickets and the restaurant settlement screen are responsive.
- **Sign-in:** password hashed with **Argon2id**, TOTP per RFC 6238 (`otplib`), 10 backup codes stored hashed (AP §5.1).
- **Session:** an HTTP-only, secure, same-site cookie, with idle and maximum lifetimes enforced on the server (AP §5.2).

### 10.4 Owner portal

- Same stack and same component library as the panel, its own app in the monorepo (`apps/merchant-portal`).
- Read-only live view of orders; no ringing and no order receiving (RA §4.1).
- Sign-in by phone and WhatsApp code (§8.3), session 30 days (RA §5.3).

---

## 11. Flutter apps: shared foundation (E5)

### 11.1 Repository

- One Flutter repository (`fox-drop-apps`) using **Dart pub workspaces** and **Melos** for scripts.
- Three apps: `apps/merchant` (Android, Windows), `apps/captain` (Android, iOS), `apps/customer` (Android, iOS).
- Flutter stable channel, the same version pinned for all three apps (FVM).

### 11.2 Shared packages

| Package | Contains |
|---|---|
| `core_api` | The Dart client generated from OpenAPI, auth interceptors, `Idempotency-Key` and app-version headers |
| `core_realtime` | The Centrifugo client, subscription management, recovery, full re-fetch after reconnect, version ordering of events |
| `core_commands` | The outgoing command queue in SQLite: idempotency keys, retries with exponential backoff and jitter, «جارٍ الإرسال…» state, conflict handling (RA §4.7) |
| `core_time` | Server clock offset from `Server-Time`; every countdown uses it |
| `core_storage` | **Drift** (SQLite) for caches and queues, `flutter_secure_storage` for tokens |
| `core_ui` | The design system (§9.3) |
| `core_l10n` | Arabic strings (ARB files), formatters for money, dates, durations and distances (AP §4.7) |
| `core_maps` | The map interface on `maplibre_gl`, tile caching, route drawing |
| `core_device_check` | The device-check framework and the per-brand guides with screenshots (RA §4.5, CA §4.5) |
| `core_alerts` | The native ringing layer: alarm audio stream, full-screen intents, foreground services, Windows tray and window control (§12, §14) |
| `core_push` | FCM registration, token refresh, notification channels |
| `core_auth` | Phone input for +963 and +90, the WhatsApp code screen, session handling |
| `core_observability` | Sentry setup, PostHog events, structured logs |

### 11.3 Libraries

| Concern | Choice |
|---|---|
| State and dependency injection | **Riverpod** (one state library, never mixed; BeeOrder shipped three, research §10) |
| Navigation and deep links | **go_router** |
| Models | **freezed** and **json_serializable** |
| HTTP | **Dio** (inside `core_api`) |
| Images | `cached_network_image` with sizes from imgproxy |
| Permissions | `permission_handler`, plus native checks in `core_alerts` |
| Code push | **Shorebird** for urgent Dart fixes without a store release; works for store and APK installs |
| Crash and error reporting | **Sentry** |
| Analytics | **PostHog** (no session replay with keystrokes; research §1 item 22) |

### 11.4 Builds and distribution

- **Android:** one signing key per app, kept in a hardware-backed key store and in CI secrets. Google Play App Signing uses an upload key; the APK on the FOX DROP website is signed with the same app signing key, so either can update the other (RA §4.2).
- **iOS:** App Store Connect with automatic signing in CI (fastlane match).
- **Windows:** MSIX is not used; see §12.3.
- **Release pipeline:** GitHub Actions builds every app per tag, runs tests, uploads to Play (internal track first), TestFlight, and the website. Release notes in Arabic.
- **Flavors:** development, staging, production, each with its own Firebase project, API URL and app ID suffix.

---

## 12. Restaurant app (Android and Windows)

### 12.1 Why Flutter

Flutter is the only mature option that builds **Android and Windows from one codebase** with native performance. React Native for Windows is far less mature, and Compose Multiplatform runs on the desktop through the JVM.

### 12.2 Android native layer (Kotlin, in `core_alerts`)

- A **foreground service** of type `dataSync` or `specialUse` (whichever the Play policy accepts for this use at submission), with the permanent notification «FOX DROP يستقبل طلباتك», restarted after reboot and after an update (`BOOT_COMPLETED`, `MY_PACKAGE_REPLACED`).
- The service owns the WebSocket while the app is in the background, so a ring does not depend on the Flutter UI being alive.
- Ring sound through `AudioAttributes.USAGE_ALARM`, looping until handled (RA §4.4).
- **Full-screen intent** on Android 14+ where granted; heads-up notification with the looping sound otherwise (RA §21 item 4).
- Readers for the device check: notification permission, battery optimisation, full-screen permission, alarm volume, Do Not Disturb state (RA §4.5).
- Tablet layout at 840 dp and wider (RA §4.1).

### 12.3 Windows native layer

- `window_manager` and `tray_manager`: closing the window minimises to the tray; quitting asks for confirmation; a ring brings the window to the front or flashes the taskbar button (RA §4.3).
- `launch_at_startup` for starting with Windows.
- Native Windows toast notifications (`local_notifier` or a small Win32 plugin).
- Sleep and power-plan check through a small Win32 plugin (RA §4.5 check 6).
- **Installer and updates: Velopack.** A signed installer from the website, background download, install on the next restart, never while a ring, a pickup prompt or an active order is open (RA §4.2).
- **Code signing:** an EV or OV code-signing certificate, or Azure Trusted Signing, so SmartScreen does not warn restaurants.

### 12.4 Printing (V2)

ESC/POS over network, Bluetooth and USB is available in Flutter. The printer survey (RA §21 item 5) decides the transports.

---

## 13. Customer app (Android and iOS)

- Flutter on the shared foundation (§11). BeeOrder also uses Flutter (research §10); FOX DROP's app is leaner: one state library, no shipped secrets, no keystroke session replay, a smaller binary (research §11 items 1 and 5).
- **Lists first, extras after** (CU §4.5): restaurant lists render from the Drift cache, then refresh; estimates and fees fill in later.
- **Live tracking:** `order:{id}` channel; the captain marker moves smoothly between 10 s updates; the route comes from the server (OSRM) once per leg.
- **Location** only while using the app (CU §4.4) through `geolocator`; the far-pin check runs on the device (CU §7.5).
- **Notifications** asked at the first order (CU §4.4).
- **Deep links** for codes and banners with `app_links`.
- **App size target:** under 25 MB download on Android (split per ABI).

---

## 14. Captain app (Android and iOS)

### 14.1 Location: `flutter_background_geolocation`

- The **Transistorsoft `flutter_background_geolocation`** library, with a paid licence for Android. It is the standard for courier apps because it solves the hardest parts of CA §4.3:
  - reliable background tracking on Android and iOS, with motion detection to save battery
  - a **persistent queue of points** while offline, sent in batches when the connection returns
  - an HTTP sync to the server with retries
  - the 10 s interval with accuracy per point, only while online
- Location is never collected while offline (CA §4.3): the app starts the library when the captain goes online and stops it when they go offline.

### 14.2 Offers and sounds (native layer in `core_alerts`)

- **Android:** the same foreground service and alarm-stream sound as the restaurant app, with the notification «أنت متصل — FOX DROP يتابع موقعك لتصلك العروض»; foreground service type `location`; a full-screen offer over the lock screen where granted; vibration (CA §4.4).
- **iOS (Swift):** time-sensitive notifications with the offer sound (30 s limit); critical alerts if Apple grants the entitlement; in the foreground, the offer screen with the looping sound (CA §4.4).

### 14.3 Integrity and fraud

- **Mock locations:** `isMock` on Android and `isSimulatedBySoftware` on iOS, read per point (CA §4.3).
- **Firebase App Check** on every request from the captain app.
- Root and jailbreak signals reported to the panel; they do not block by themselves in V1.
- **One device** (CA §4.9): the session is bound to a device ID generated at install and stored in secure storage; the server ends the old session on a new sign-in.

### 14.4 Light data (CA §4.6)

- Map tiles cached; the route line fetched once per leg; document photos compressed on the device (`flutter_image_compress`) before upload; JSON responses compressed (gzip or Brotli).
- A CI check measures the data used by a scripted delivery against the 2 MB target.

---

## 15. Security

### 15.1 Authentication

| Product | Method |
|---|---|
| Admin panel | Password (Argon2id) and TOTP, mandatory (AP §5.1) |
| Owner portal | Phone and WhatsApp code (§8.3) |
| Restaurant app | Phone and WhatsApp code; device registration on first sign-in (RA §5.2) |
| Captain app | Phone and WhatsApp code; one device (CA §4.9) |
| Customer app | Phone and WhatsApp code at «تأكيد الطلب» (CU §5.1–5.2) |

- Apps receive a short-lived access token (15 minutes, JWT signed with a rotating key) and a refresh token. Refresh tokens are stored hashed, rotated on every use, and revoked on reuse.
- Blocking, closing an account or forcing sign-out revokes every refresh token at once (CU §5.4).

### 15.2 Authorisation

- Roles and permissions checked by NestJS guards on every route (AP §1.3 item 7). The UI hides actions, the server enforces them.
- Every query is scoped by city and by the caller's party (a restaurant sees only its orders, a captain only their tasks).
- Automated tests call every forbidden route for every role (RA §22 item 2).

### 15.3 Data protection

- TLS everywhere; HSTS on the web.
- Phone numbers encrypted at the application level in addition to disk encryption, with a searchable hash; masked by default in the panel (AP §5.4).
- Captain documents in the private bucket only (§5.8).
- Audit log append-only, enforced by database permissions (AP §4.6).

### 15.4 Secrets (E7)

- Secrets live in a secret manager (**Doppler**, or Infisical self-hosted) and reach containers as environment variables.
- No secret in an app or a web bundle: routing, maps, WhatsApp and other keys are used only by the server (research §11 item 1).
- Provider keys entered in the panel are write-only (AP §5.4).

### 15.5 Edge protection

- **Cloudflare** in front of the API, the panel and the portal: DNS, CDN, WAF, DDoS protection, bot rules and rate limits.
- The admin panel MAY be restricted further with Cloudflare Access.

---

## 16. Observability and analytics

- **Errors:** Sentry on the server, both web apps and the three Flutter apps, with release and device tags.
- **Metrics, logs, traces:** OpenTelemetry in the server; Grafana with Prometheus (metrics), Loki (logs) and Tempo (traces), hosted (Grafana Cloud) in V1.
- **Business health dashboards and alerts for the technical team:**
  - time from `placed` to accepted, and from ready to pickup
  - rings not handled, offers expired, receiving-device count per open restaurant
  - Centrifugo connections and recoveries, outbox lag, timer lag
  - location update lag per captain
  - WhatsApp sender states and delivery rates (§8.3.3)
  - ledger reconciliation result (§5.6)
- **Product analytics:** PostHog (EU cloud in V1, self-hosted later if needed), with funnels for browse → cart → checkout → placed. No keystroke recording.
- **Logs** never contain codes, tokens or full phone numbers.

---

## 17. Infrastructure and environments (E8)

### 17.1 Environments

| Environment | Purpose |
|---|---|
| `development` | Local, with Docker Compose: PostgreSQL with PostGIS, Valkey, Centrifugo, OSRM (small extract), MinIO for object storage |
| `staging` | A smaller copy of production, used for the definition-of-done demonstrations in the four specs |
| `production` | Live |

Each environment has its own database, Firebase project, storage buckets, secrets and WhatsApp sender numbers (staging uses one test number).

### 17.2 Hosting

- **Region:** Frankfurt, close to the Turkish networks that serve Azaz.
- **Provider: DigitalOcean (FRA1)** for V1:
  - application droplets running the containers (`api`, `worker`, `dispatcher`, `otp-sender`, Centrifugo, imgproxy)
  - a separate droplet for OSRM (memory-heavy)
  - **managed PostgreSQL** with a standby node and a read replica, PostGIS enabled
  - **managed Valkey**
- **Cloudflare:** DNS, CDN, WAF, R2 storage.
- Alternative if needed: Hetzner (Germany) with self-managed PostgreSQL (Patroni and pgBackRest). The containers and Terraform make the move a redeployment.

### 17.3 Deployment

- **V1–V2: Kamal** deploys the containers to the droplets with zero-downtime rolling restarts; GitHub Actions runs it on every merge to `main` (staging) and on a release tag (production).
- **From V3 (several cities): managed Kubernetes** (DOKS), with the same images, Helm charts and horizontal autoscaling of `api` and `worker`.
- **Terraform** describes every cloud resource, DNS record and bucket from the start.
- **Database migrations** run as a separate step before the new version starts; every migration is backward compatible with the running version (expand, then contract).
- Forced app updates are published outside peak hours (RA §4.2).

### 17.4 Capacity

- V1 load in one city is small (hundreds of captains send a few hundred position updates per minute). The design targets the multi-city future: stateless API, connections in Centrifugo, positions in Valkey, partitioned tables, a read replica for reports.
- A **load test with k6** and the **captain simulator** (§18.3) before launch, at five times the expected peak.

---

## 18. Testing and quality

### 18.1 Server

- **Vitest** for unit tests; **Testcontainers** with real PostgreSQL, Valkey and Centrifugo for integration tests.
- State machine tests cover every transition and every timer in AP §8.3, including late and repeated timer jobs.
- Ledger property tests: every journal balances per currency; every flow in AP §8.9 produces the expected entries.
- Permission tests for every role on every route.

### 18.2 Web

- **Vitest** and Testing Library for components; **Playwright** for end-to-end flows in RTL; **Storybook** with visual regression (Chromatic or Playwright snapshots).

### 18.3 Apps

- Unit and widget tests; **Patrol** for end-to-end tests that cover native dialogs and permissions.
- **Captain simulator:** a tool that runs hundreds of fake captains (moving along OSRM routes, accepting or ignoring offers) against staging, to test dispatch, offers and the live map before launch.
- **Real-device lab** before launch: at least one low-cost Android phone of each common brand in Azaz, an Android tablet, a Windows PC and an iPhone, running the ringing and 8-hour idle tests (RA §22 item 3, CA §19).

### 18.4 Gates

A change merges only when lint, type checks, tests, the OpenAPI client build and the module-boundary check pass.

---

## 19. Repositories and conventions

### 19.1 Repositories

| Repository | Contains | Tooling |
|---|---|---|
| `fox-drop-platform` | `apps/server`, `apps/admin`, `apps/merchant-portal`, `packages/ui-web`, `packages/design-tokens`, `packages/api-schema` (Zod and OpenAPI), `tools/captain-simulator`, `infra/` (Terraform, Kamal) | pnpm workspaces and Turborepo |
| `fox-drop-apps` | `apps/merchant`, `apps/captain`, `apps/customer`, `packages/core_*` | Dart pub workspaces and Melos |

The design tokens are published from `fox-drop-platform` as a versioned package and consumed by `fox-drop-apps`.

### 19.2 Branches and reviews

- Trunk-based: short-lived branches into `main`, every change through a pull request with review and green checks.
- Conventional commit messages; releases tagged per product.

### 19.3 Code language

Code, comments, commit messages and documentation are in English. User-facing text is Arabic, in translation files only.

### 19.4 Dependencies

Exact versions pinned in lockfiles; Renovate opens update pull requests; runtimes (Node.js, PostgreSQL, Flutter) are upgraded once a quarter on staging first.

---

## 20. Growth path V1 → V6

| Version | What changes technically |
|---|---|
| **V1** | Modular monolith, one PostgreSQL with standby and replica, Centrifugo, OSRM, pg-boss timers, manual then mixed dispatch, WhatsApp codes |
| **V2** | Printing, panel chat (on Centrifugo), the penalties engine, English UI (the RTL-first logical styles already support LTR) |
| **V3** | Stores and the central catalogue with **Meilisearch** (Arabic search at scale), errands, order stacking. **Temporal** for long-running flows. **Dispatch and location split into their own service** (Go is an option for it). Move to managed Kubernetes. |
| **V4** | Loyalty, referral and campaigns: a rules engine for offers; **ClickHouse** fed from PostgreSQL by change data capture for analytics and campaign ROI |
| **V5** | E-payments and wallet: new account and journal types in the existing ledger, payment gateway adapters, reconciliation jobs; the payments module gets stricter isolation and its own audit |
| **V6** | Smart dispatch and forecasting: a **Python (FastAPI)** service for ETA, demand and matching models trained on ClickHouse data; regional database separation if the number of cities requires it |

Second sign-in channel (SMS or the official WhatsApp Cloud API) can be added in any version as a new `CodeSender` adapter (§8.3.1).

---

## 21. Options considered and not chosen

| Option | Why not |
|---|---|
| Microservices from day one | Too much operational cost for the team size, and distributed transactions around money (§4.1) |
| Firebase or Supabase as the main backend | Not suited to a complex order state machine, strict ledgers and guaranteed timers. Firebase is used for push and App Check only. |
| MongoDB | Money needs relational constraints and multi-row transactions |
| Laravel (BeeOrder's likely backend) | Weaker for long-lived connections, real time and dense timers |
| Socket.IO inside the API | Couples connections to API scaling; no built-in history and recovery |
| GraphQL | Caching complexity without benefit on weak networks |
| Separate native apps per platform | Six codebases instead of three Flutter apps with shared packages |
| React Native | Weak on Windows for the restaurant app; one framework for all three apps is worth more |
| Flutter Web for the panel or portal | Weaker for large tables, long Arabic text and accessibility |
| Next.js for the panel | Server rendering and SEO are not needed behind a sign-in |
| Radix and shadcn/ui | Replaced by Base UI with FOX DROP's own components (T2) |
| Google Maps everywhere | Per-use billing; MapLibre with OSM covers V1, with Google Maps kept as a display fallback (§7.2) |
| Relying on push alone for rings | Forbidden by the specs (RA §4.3) |

---

## 22. Risks and open items

1. **WhatsApp as the only code channel (T4, T5).** A ban or outage of all sending numbers stops new sign-ins; existing sessions continue. Mitigations are in §8.3.3. Still to decide: an emergency procedure for that case (for example, OPS verifying a captain or restaurant by phone and issuing a one-time sign-in from the panel), and when to add the official WhatsApp Cloud API or an SMS provider as a second channel.
2. **Terms of the WhatsApp library.** Automated sending through an unofficial library is outside WhatsApp's terms; numbers can be banned even with the protections. Keep spare warmed numbers ready at all times.
3. **Play policy for foreground service types and full-screen intents.** Verify at submission (RA §21 item 4, CA §18 item 6).
4. **Critical Alerts entitlement.** Apply early; field-test iPhones on silent with and without it (CA §18 item 2).
5. **OSM map quality in Azaz.** Field check before launch (§7.2, CU §18 item 3).
6. **Push delivery on real networks.** The accounts are available (T3); still field-test FCM and APNs delivery on Azaz networks and on phones without Google services (RA §21 item 2).
7. **Hosting account.** Open the DigitalOcean, Cloudflare and Sentry accounts in the name that holds the Apple and Google accounts, and confirm each provider accepts it before the infrastructure is set up.
8. **Paid licences** to budget: `flutter_background_geolocation` (Android), the Windows code-signing certificate, Sentry, Grafana Cloud, PostHog beyond the free tier, Shorebird.

---

## 23. Changes made to the specs

The following edits were made to the V1 specs on 2026-11-04 to match this document:

### 23.1 Admin panel spec (`docs/v1/admin-panel.md`)

1. **Header:** this document added to "Related".
2. **§5.4:** provider keys now name the WhatsApp sending numbers and maps instead of a WhatsApp/SMS provider.
3. **§9.1.3:** two alerts added: «رقم إرسال الرموز متوقف» (Warning, OWN) and «لا يمكن إرسال رموز الدخول» (Critical, OWN, OPS).
4. **§9.14:** the OTP block now says WhatsApp is the only channel in V1 and adds the «أرقام إرسال الرموز» screen.
5. **§13 item 8:** the distance service is decided: self-hosted OSRM.
6. **Appendix A:** `otp.channel_order` defaults to `whatsapp`; new keys `otp.number_hourly_max`, `otp.number_daily_max`, `otp.device_daily_max`, `otp.ip_hourly_max`, `otp.sender_per_minute_max`, `otp.sender_daily_max`, `otp.send_jitter_sec`, `otp.sender_warmup_caps`.

### 23.2 Restaurant app spec (`docs/v1/restaurant-app.md`)

1. **Header:** this document added to "Related".
2. **§4.1:** the stack is confirmed (Flutter), pointing to this document.
3. **§5.2:** codes are sent over WhatsApp only.
4. **§21 item 2:** store and Firebase availability confirmed (T3); the field test of push delivery remains.

### 23.3 Captain app spec (`docs/v1/captain-app.md`)

1. **Header:** this document added to "Related".
2. **§4.1:** the stack is confirmed (Flutter), pointing to this document.
3. **§4.2:** App Store availability is no longer an open item.
4. **§4.9:** codes are sent over WhatsApp only.
5. **§18 items 1, 3 and 4:** store and Firebase availability confirmed (T3), the push field test remains; the distance service is decided (OSRM).

### 23.4 Customer app spec (`docs/v1/customer-app.md`)

1. **Header:** this document added to "Related".
2. **§4.1:** the stack is confirmed (Flutter), pointing to this document.
3. **§4.2:** App Store availability is no longer an open item.
4. **§5.2:** codes over WhatsApp only; resend offers «إعادة الإرسال» only; the «هذا الرقم غير مسجّل على واتساب» message; paste instead of SMS auto-fill.
5. **§18 items 1, 2, 3 and 5:** store and Firebase availability confirmed (T3); code delivery is tested over WhatsApp only; the map choice points to §7.2; the push field test remains.
6. **§19 item 2:** the definition of done no longer mentions SMS and voice fallbacks.
7. **Appendix B:** «إرسال برسالة نصية» and «اتصال صوتي» removed; «هذا الرقم غير مسجّل على واتساب» and the daily-limit message added.
