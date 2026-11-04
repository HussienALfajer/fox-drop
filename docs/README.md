# FOX DROP documentation

Start here. This page says where each kind of information lives. Each rule has exactly one home; other documents point to it instead of repeating it.

## Map

| Folder or file | What it holds |
|---|---|
| [`product/v1/admin-panel/`](product/v1/admin-panel/README.md) | Admin panel V1 spec (AP) |
| [`product/v1/restaurant-app/`](product/v1/restaurant-app/README.md) | Restaurant app and owner web portal V1 spec (RA) |
| [`product/v1/captain-app/`](product/v1/captain-app/README.md) | Captain app V1 spec (CA) |
| [`product/v1/customer-app/`](product/v1/customer-app/README.md) | Customer app V1 spec (CU) |
| [`domain/`](domain/README.md) | Shared domain rules (AP §8): order statuses, timers, order money, custody and earnings, currencies, restaurant account, trust, outcomes |
| [`architecture/`](architecture/README.md) | Technology stack and architecture |
| [`roadmap.md`](roadmap.md) | Versions V1–V6 and the V1 build phases |
| [`open-questions.md`](open-questions.md) | Where every open item lives |

## Citations

Documents cite each other by spec code and section number:

| Code | Document |
|---|---|
| AP | Admin panel spec. AP §8 is in [`domain/`](domain/README.md). |
| RA | Restaurant app spec |
| CA | Captain app spec |
| CU | Customer app spec |

A bare "§n" means a section of the document the file belongs to; each file says which document that is in its first line. File names start with the section number, so "CA §9.4" is `product/v1/captain-app/09-the-active-order/04-the-pickup-request.md`.

## Decisions

Each document records its decisions in its §2. The ID prefix tells you where to look:

| Prefix | Meaning | Home |
|---|---|---|
| D | Owner decisions for the admin panel and the shared domain | [AP §2](product/v1/admin-panel/02-owner-decisions.md) |
| R, S | Owner decisions (R) and spec-author rules (S) for the restaurant app | [RA §2](product/v1/restaurant-app/02-decisions.md) |
| C, K | Owner decisions (C) and spec-author rules (K) for the captain app | [CA §2](product/v1/captain-app/02-decisions.md) |
| U, Q | Owner decisions (U) and spec-author rules (Q) for the customer app | [CU §2](product/v1/customer-app/02-decisions.md) |
| T, E | Owner decisions (T) and architecture rules (E) for the technology | [Architecture §2](architecture/02-decisions.md) |

Spec-author and architecture rules (S, K, Q, E) stand until the owner changes them. A new decision goes into §2 of the document it belongs to, with its date and reason, and every section that depends on it is updated in the same change.

## Language

Documentation, code and commit messages are in English. Arabic appears only as user-facing labels in «guillemets»; in the apps those labels live in translation files.
