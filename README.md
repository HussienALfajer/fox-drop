# FOX DROP

A food delivery platform for Syria, launching in Azaz and growing city by city. One server
carries four products: the customer app, the restaurant app with its owner web portal, the
captain (courier) app and the owner's admin panel. The interface is Arabic, right to left.

Progress is tracked in [`docs/roadmap.md`](docs/roadmap.md). The map of all documentation is
[`docs/README.md`](docs/README.md).

## Repository layout

| Path                   | What it is                                                                |
| ---------------------- | ------------------------------------------------------------------------- |
| `apps/server`          | The API, workers and jobs: a NestJS modular monolith on PostgreSQL        |
| `apps/customer`        | Customer app, Flutter (Android, iOS)                                      |
| `apps/merchant`        | Restaurant app, Flutter (Android, Windows)                                |
| `apps/captain`         | Captain app, Flutter (Android, iOS)                                       |
| `apps/admin`           | Owner's admin panel, React                                                |
| `apps/merchant-portal` | Restaurant owner's web portal, React                                      |
| `packages/api-schema`  | The OpenAPI contract and the generated TypeScript client                  |
| `packages/core_*`      | Shared Flutter packages: API client, sign-in, real time, maps, strings, … |
| `infra`                | Deployment: Compose files, nginx, maps, routing and backups               |
| `scripts`              | The single check (`pnpm verify`) and its helpers                          |
| `docs`                 | Specs, domain rules, architecture, process and slice plans                |

## Technology

- **Server:** Node.js and TypeScript, NestJS on Fastify, PostgreSQL with PostGIS, pg-boss,
  Valkey, Centrifugo for real time, REST with OpenAPI 3.1.
- **Apps:** Flutter for the mobile and Windows apps; React and Vite for the web.
- **Maps and routing:** MapLibre with OpenStreetMap tiles, self-hosted OSRM.
- **Hosting:** Docker containers behind nginx, deployed from GitHub Actions.

The full stack and its decisions are in [`docs/architecture/`](docs/architecture/README.md).

## Getting started

Requirements: Node.js and pnpm (versions pinned in `.node-version` and `package.json`),
[FVM](https://fvm.app) for the pinned Flutter in `.fvmrc`, Docker, and Java 11 or later for the
API client generator.

```sh
pnpm install
fvm install
dart pub get
cp .env.example .env
docker compose up --detach
pnpm --filter @fox-drop/server db:migrate
pnpm verify
```

`pnpm verify` runs every check: the API contract, formatting, lint, type checks, tests and web
builds, then the Dart analysis and tests. `.env.example` holds fake values only.

## Documentation

| Document                                                                      | What it covers                                           |
| ----------------------------------------------------------------------------- | -------------------------------------------------------- |
| [`docs/product/v1/customer-app/`](docs/product/v1/customer-app/README.md)     | Customer app V1                                          |
| [`docs/product/v1/restaurant-app/`](docs/product/v1/restaurant-app/README.md) | Restaurant app and owner web portal V1                   |
| [`docs/product/v1/captain-app/`](docs/product/v1/captain-app/README.md)       | Captain app V1                                           |
| [`docs/product/v1/admin-panel/`](docs/product/v1/admin-panel/README.md)       | Admin panel V1                                           |
| [`docs/domain/`](docs/domain/README.md)                                       | Shared domain rules: orders, money, currencies, outcomes |
| [`docs/architecture/`](docs/architecture/README.md)                           | Technology stack and architecture                        |
| [`docs/process/`](docs/process/development-workflow.md)                       | How the project is built: risk tiers, slices, reviews    |
| [`docs/roadmap.md`](docs/roadmap.md)                                          | Versions, build phases and progress                      |

## License

The source is public for transparency only; all rights reserved. See [`LICENSE`](LICENSE).
