# 4. Architecture

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 4.1 Modular monolith (E1)

The server is **one deployable application made of strictly separated modules**. It runs as several processes from the same image (§4.4).

Why not microservices in V1: they would put the money flows behind distributed transactions, multiply deployments and monitoring, and add network failures between parts that today change together. The modular monolith gives build speed now and lets any module become a service later, because its boundaries are already enforced.

## 4.2 Modules

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

## 4.3 Module rules (MUST)

1. Each module owns a **PostgreSQL schema** with the same name. No module reads or writes another module's tables.
2. Modules call each other only through the other module's public service interface, or react to its domain events.
3. Domain events are typed, versioned and published inside the process. Events that must leave the process go through the outbox (§5.5).
4. A lint rule (`eslint-plugin-boundaries` or the Nx module-boundary rule) fails the build on a forbidden import.
5. Money moves only through the `ledger` module. No other module writes balances.

## 4.4 Processes

The same container image runs in four roles:

| Role | Does |
|---|---|
| `api` | HTTP API for all clients. Stateless, scaled horizontally. |
| `worker` | pg-boss jobs: timers, outbox relay, push sending, exports, reports |
| `dispatcher` | The dispatch loop for each city (one active leader per city, using a PostgreSQL advisory lock) |
| `otp-sender` | The WhatsApp sessions and the sending queue (§8.3). Isolated so a library crash never affects the API. |

Centrifugo, OSRM and imgproxy run as their own containers.
