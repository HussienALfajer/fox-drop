# D.P10 Component tokens for overlays, navigation and actions: web

Status: Planned · Tier: T2 · Branch: `feat/overlay-tokens-web`
Spec: architecture §9.2, §9.6 (as rewritten by D.P1), §9.5 R1 · Definition of done: the overlays, navigation and action components with both sides take their values from component tokens on the web and pass the D.P2 gate; every component in the registry then has `metrics`.

## Goal

`Dialog`, `ConfirmDialog`, `Toaster`, `Banner`, `BannerStack`, `Menu`, `Tabs`, `TopBar`, `Sidebar` (the navigation rail's twin), `Icon` and `TextLink` read component tokens; nothing looks different.

## Plan

1. Tokens: `tokens/component/overlays.json`, the rest in `navigation.json` (D.P4); each value the one the web uses today; `generate`; version and `CHANGELOG.md`.
2. Web: the eleven components read the component variables; the visual baselines must not change.
3. The registry's `metrics` of the eleven; `src/components.test.ts` now requires `metrics` on every entry.

Files (hand-written count, 18): the eleven component files, `overlays.json`, `navigation.json`, `packages/design-tokens/package.json`, `CHANGELOG.md`, `components.json`, `src/components.test.ts`, `docs/code/packages/design-tokens.md`.

Tests written first (locked in the red phase): the registry `metrics` of the eleven; the registry test's new rule.

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`; the visual baselines unchanged.
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

After D.P8. Flutter side: D.P11.
