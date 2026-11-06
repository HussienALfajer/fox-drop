# 5. Server

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 5.1 Language and framework

- **TypeScript (strict), Node.js current LTS, NestJS on Fastify.**
- One language across the server, the admin panel and the owner portal: shared validation schemas and types.
- NestJS enforces the module structure of §4, has dependency injection, guards for permissions, and OpenAPI generation.
- **Validation:** Zod schemas at every API boundary, shared with the web clients (`nestjs-zod`).
- **Database access:** **Drizzle ORM** with SQL-first migrations (`drizzle-kit`), reviewed as SQL. Complex reporting queries are written as plain SQL.

## 5.2 Data model rules (MUST)

- `city_id` on every business record from day one (AP §1.3 item 6).
- Primary keys are **UUIDv7** (time-ordered). Human numbers (`#10423`, `AZ-2026-000123`, `T-5521`, AP §4.8) are separate columns from per-city sequences.
- Times are stored as `timestamptz` in UTC. The city's time zone is applied for display and for the business day (AP §4.3).
- Money is stored as **`bigint` in minor units** with an explicit currency code on every amount. The minor unit per currency comes from `fx`. Floating point is never used for money.
- Every order keeps a snapshot of the exchange rates, the fee rule, the commission and the pay table version it used.
- Phone numbers are stored in E.164 format.
- Soft state, such as "closed account", is a status column. Business records are not deleted.

## 5.3 API (E6)

- **REST over HTTPS, documented by OpenAPI 3.1** generated from the NestJS controllers.
- Clients are generated in CI: Dart (`openapi-generator`, `dart-dio`) for the Flutter apps, TypeScript (`openapi-typescript`, `openapi-fetch`) for the web. A breaking change fails the build of a client.
- Separate route groups per product: `/admin/*`, `/merchant/*`, `/captain/*`, `/customer/*`. Each group has its own guards and rate limits.
- Versioned under `/v1`. Apps also send their app version; the server can refuse versions below `app.*.min_version` (AP §9.14).
- **Idempotency:** every command carries an `Idempotency-Key` header (RA §4.7). The server stores the key with the response for 24 hours and returns the stored response for a repeat. Exception: a command whose answer is a secret shown once (the emergency sign-in code, §8.3.5) takes no key, since storing its response would store the secret; a repeat issues a new one.
- **Optimistic concurrency:** commands on an order carry the order version they were made against. A stale command returns `409` with the current state, which the apps explain (RA §4.7).
- **Server time:** every response carries a `Server-Time` header. The apps compute their clock offset from it (RA §4.7).
- **Light and heavy reads are separate** (CU §4.5): lists come first from a cheap cached call, estimates and fees after.
- GraphQL is not used: it adds caching complexity without benefit on weak networks.

## 5.4 Database

- **PostgreSQL**, latest stable and at least 18 (the migrations use its built-in `uuidv7()`), managed (§17.2), with a hot standby and a read replica.
- **PostGIS** for zones (polygons), point-in-zone checks, distance checks and the vote heatmap.
- **Partitioning** by month for orders, order events, location history, ledger entries and the audit log.
- **Search in V1:** PostgreSQL full text plus `pg_trgm`, on a normalised Arabic column. Normalisation removes diacritics and tatweel and unifies «أ إ آ ا», «ة ه» and «ى ي».
- **Backups:** continuous WAL archiving with point-in-time recovery, daily snapshots kept 30 days, a weekly copy in a second provider. A restore is tested every month.
- The reporting module reads from the replica only.

## 5.5 Order state machine, timers and the outbox (E3, E4)

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

## 5.6 Ledger

- **Double entry.** Every money movement is one journal with two or more entries that balance to zero per currency.
- Accounts per party and purpose: captain custody per currency, captain earnings, restaurant account, platform revenue, platform cash per drawer, discounts, compensation and so on (AP §8.5, §8.7, §8.11).
- Entry types are enum values (for example `custody.pay_merchant`, `earn.order_pay`, CA §0).
- **Append-only, enforced in the database:** the application role has `INSERT` and `SELECT` on ledger tables, never `UPDATE` or `DELETE`. Corrections are reversing journals with a reason (AP §1.3 item 5).
- Balances are computed from entries. Cached balances are rebuilt from entries and checked by a nightly reconciliation job that alerts on any difference.
- The ledger is designed for V5 from day one: a wallet is one more account type, and an e-payment is one more journal type.

## 5.7 Valkey (E2)

- Last known captain position and state, as a GEO set per city, for `GEOSEARCH` in dispatch.
- Rate limits (OTP, API), short locks, and caches (settings, menus, home sections).
- Everything in it can be rebuilt from PostgreSQL or from the next location update.

## 5.8 Files and images

- **S3-compatible object storage self-hosted on the server** (T9), the same software as in development (T7), chosen in the slice that first stores a file. It listens only on the server and is reached through nginx on FOX DROP's domain, so phones in Syria reach it without any outside provider. Two buckets per environment:
  - `public-media`: menu photos, logos, banners. Served by nginx through **imgproxy**, which resizes and converts to WebP or AVIF per screen size (CU §4.5); nginx caches the results, in place of a CDN in V1.
  - `private-docs`: captain documents, contracts, report photos. Encrypted at rest, never public, opened with short-lived signed URLs, every view audited.
- Uploads go directly from the app to storage with a pre-signed URL. The server checks type and size before linking the file to a record.
- Both buckets are copied every night, encrypted, to a destination off the server (§17.2).

## 5.9 Exports

Excel exports (AP §9.10.1, §9.17) are generated on the server by a worker job with **ExcelJS**, stored in `private-docs` for 24 hours and downloaded through a signed URL. Every export is audited (AP §5.4).
