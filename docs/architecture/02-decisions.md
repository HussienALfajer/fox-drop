# 2. Decisions

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 2.1 Owner decisions (2026-11-04)

| ID  | Topic                       | Decision                                                                                                                                                                                                                                                                                         |
| --- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| T1  | Overall stack               | The stack in §3 is approved, with the changes below.                                                                                                                                                                                                                                             |
| T2  | Design system               | FOX DROP has its own UI/UX design. The web uses **Base UI** headless primitives instead of Radix, with FOX DROP's own components and styling. shadcn/ui is not used. The Flutter apps use the same design language (§9).                                                                         |
| T3  | Store and Firebase accounts | Apple Developer, Google Play and Firebase are available to FOX DROP. The store-availability open items in the specs are closed.                                                                                                                                                                  |
| T4  | Sign-in codes               | Codes are sent over **WhatsApp only**, through a third-party WhatsApp sending library, with protections that keep the sending numbers from being banned as far as possible (§8.3).                                                                                                               |
| T5  | SMS and voice               | There is no SMS provider for now. SMS and voice codes are not part of V1. The channel abstraction keeps them possible later without a client change (§8.3.1).                                                                                                                                    |
| T6  | One repository              | The server, the web apps and the three Flutter apps live in **one repository** (`fox-drop`), so a change to the API contract, its generated clients and every app that uses it lands in one pull request and passes one set of checks. This replaces the two repositories first planned (§19.1). |
| T7  | Local object storage        | MinIO no longer publishes container images, so the development S3-compatible storage is chosen in the slice that first stores a file, like OSRM. Until then `compose.yaml` has no object storage (§17.1). Decided 2026-11-04.                                                                    |
| T8  | Refresh retry grace         | A used refresh token presented again within 10 seconds of its first use, before its successor is used, gets a new pair that replaces the lost one instead of ending the session, so an answer lost on a weak network does not cost a new WhatsApp code (§15.1). Decided 2026-11-05.              |

## 2.2 Rules set by this document (the owner may change them)

| ID  | Rule                                                                                              |
| --- | ------------------------------------------------------------------------------------------------- |
| E1  | One modular monolith for the server in V1, not microservices (§4).                                |
| E2  | PostgreSQL is the only system of record. Redis holds nothing that cannot be rebuilt (§5.4, §5.7). |
| E3  | Every state change and every timer is written in the same database transaction (§5.5).            |
| E4  | Every event leaves the server through a transactional outbox (§5.5).                              |
| E5  | All three mobile and desktop apps are Flutter apps in one repository with shared packages (§11).  |
| E6  | API clients are generated from the OpenAPI document, never written by hand (§5.3).                |
| E7  | No secret is shipped inside an app or a web bundle (§15.4).                                       |
| E8  | Everything runs in containers from the first deployment (§17).                                    |
