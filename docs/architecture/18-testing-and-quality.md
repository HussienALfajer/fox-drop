# 18. Testing and quality

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 18.1 Server

- **Vitest** for unit tests; **Testcontainers** with real PostgreSQL, Valkey and Centrifugo for integration tests. They run inside `pnpm verify`, locally and in CI, so the check needs Docker (owner decision, 2026-11-04).
- State machine tests cover every transition and every timer in AP §8.3, including late and repeated timer jobs.
- Ledger property tests: every journal balances per currency; every flow in AP §8.9 produces the expected entries.
- Permission tests for every role on every route.

## 18.2 Web

- **Vitest** and Testing Library for components; **Playwright** for end-to-end flows in RTL; **Storybook** with visual regression (Chromatic or Playwright snapshots).

## 18.3 Apps

- Unit and widget tests; **Patrol** for end-to-end tests that cover native dialogs and permissions.
- **Captain simulator:** a tool that runs hundreds of fake captains (moving along OSRM routes, accepting or ignoring offers) against staging, to test dispatch, offers and the live map before launch.
- **Real-device lab** before launch: at least one low-cost Android phone of each common brand in Azaz, an Android tablet, a Windows PC and an iPhone, running the ringing and 8-hour idle tests (RA §22 item 3, CA §19).

## 18.4 Gates

A change merges only when lint, type checks, tests, the OpenAPI client build and the module-boundary check pass.
