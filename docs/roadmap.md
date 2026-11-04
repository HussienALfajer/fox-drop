# Roadmap

One line per item. Details belong in the specs and the architecture, not here.

## Versions

| Version | Scope | Status |
|---|---|---|
| V1 | Full order cycle for restaurants: cash on delivery, captain cash custody and earnings, launch promo codes. Azaz only. | Specified |
| V2 | Quality and operations: printing, panel chat, penalties engine, English UI | Not started |
| V3 | Stores and errands, central catalogue, order stacking | Not started |
| V4 | Growth: loyalty, referral, campaigns | Not started |
| V5 | Electronic payments and wallet | Not started |
| V6 | Scale and intelligence: smart dispatch, forecasting | Not started |

The technical growth path is [architecture §20](architecture/20-growth-path-v1-v6.md).

## V1 build phases

Markers: `[ ]` not started, `[~]` in progress, `[x]` done.

- `[x]` Specs: admin panel, restaurant app, captain app, customer app, technology stack.
- `[x]` Repository and documentation layout.
- `[ ]` Phase 0, foundation: agent instructions and checks, workspace and CI, server skeleton with the module boundaries, database, identity and roles, settings. **The design system and any screen styling wait for the owner's answer on whether the UI/UX and design system are ready.**
- `[ ]` Phase 1, walking skeleton: one order goes through its whole cycle (customer orders, restaurant accepts, dispatch offers, captain picks up and delivers, ledger entries) with minimal screens.
- `[ ]` Phase 2 onwards, vertical slices: each feature of the specs built through every layer it touches, one slice per pull request. The slice list is planned before Phase 1 starts.
- `[ ]` Launch readiness: captain simulator load test, real-device lab, staging rehearsal (architecture §18).
