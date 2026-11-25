# D.P3 Web twins 1: the browsing cards, and the phone-only entry

Status: Planned · Tier: T2 · Branch: `feat/web-twins-browse-cards`
Spec: architecture §9.6, §9.9 (as rewritten by D.P1); the cited sections of each `core_ui` widget (`docs/code/packages/core_ui.md`) · Definition of done: `RestaurantCard`, `DishCard`, `OrderRow`, `Logo` and `CountdownRing` exist in `ui-web`, match their Flutter goldens, and leave `pendingWeb`.

## Goal

The five components can be drawn live on the screens canvas and are touchable in the Design System. Phone-only components come from `@fox-drop/ui-web/phone`, which the admin panel and the restaurant portal cannot import.

## Plan

0. Design checkpoint: waived by the owner (2026-11-25). Each twin copies its `core_ui` widget: the same anatomy, props named alike, the same states as its golden. The evidence is the D.P2 side-by-side image of each, every difference fixed or written in its README.
1. Tokens: `tokens/component/data.json` holds these five's sizes, radii, gaps and colours (semantic references only); `generate`; version and `CHANGELOG.md`.
2. Web: each component with its story per golden state and its unit test; `src/phone.ts` and the `./phone` export for the phone-only ones (registry `phoneOnly`); `eslint.web.mjs` forbids `@fox-drop/ui-web/phone` in the web apps; `COMPONENTS`, `docs.ts`, the registry (`web`, `metrics`, out of `pendingWeb`).
3. Sync the Design System only: not the Guide or any other canvas until every D.P slice is done (owner, 2026-11-25).

Files (hand-written count, 25): five components × (component, story, test) = 15; `tokens/component/data.json`, `packages/design-tokens/package.json`, `CHANGELOG.md`, `packages/ui-web/package.json`, `src/phone.ts`, `src/index.ts`, `scripts/bundle.ts`, `scripts/docs.ts`, `eslint.web.mjs`, `test/lint.test.ts`, `packages/design-tokens/components.json` (the visual baselines apart).

Tests written first (locked in the red phase): each component's unit test (its states, RTL, accessible name, no text of its own); `test/lint.test.ts` (a web app importing `ui-web/phone` fails); the registry's `metrics` for the five (D.P2 gate).

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- The side-by-side images of the five (CI artifact).
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new; the owner touches the five in the Design System.

## Notes for the next session

Needs D.P2. `core_ui` is not changed here: D.P7 moves the Flutter side onto the new component tokens.
