# D.P4 Web twins 2: the phone frame and navigation

Status: Planned · Tier: T2 · Branch: `feat/web-twins-phone-frame`
Spec: architecture §9.6, §9.9 (as rewritten by D.P1); the cited sections of each `core_ui` widget · Definition of done: `BottomNavigation`, `RestaurantBar`, `PullToRefresh`, `BottomSheet` and `TrackingSteps` exist in `ui-web`, match their Flutter goldens, and leave `pendingWeb`.

## Goal

The phone frame can be drawn live on the screens canvas: the bottom navigation, the restaurant's bar, pull to refresh, the bottom sheet (with the S-curve tab) and the tracking steps.

## Plan

0. Design checkpoint: waived (owner, 2026-11-25); each twin copies its `core_ui` widget and golden, checked by the D.P2 side-by-side image.
1. Tokens: `tokens/component/navigation.json` (bars, tabs of the bar, the sheet's handle and tab, the steps), `generate`, version and `CHANGELOG.md`.
2. Web: each component with its story per golden state and its unit test, all phone-only in `src/phone.ts`. A web pointer stands in for touch: the sheet drags with the pointer and closes on Escape; pull to refresh works with the pointer and the wheel; what cannot be the same is written in each README. `docs.ts`, `COMPONENTS`, the registry.
3. Sync the Design System only: not the Guide or any other canvas until every D.P slice is done (owner, 2026-11-25).

Files (hand-written count, 23): five components × 3 = 15; `navigation.json`, `packages/design-tokens/package.json`, `CHANGELOG.md`, `src/phone.ts`, `scripts/bundle.ts`, `scripts/docs.ts`, `components.json`, `docs/code/packages/ui-web.md`.

Tests written first (locked in the red phase): each unit test (states, RTL, focus, keyboard of the sheet, the selected tab's Bold icon); the registry `metrics` of the five.

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- The side-by-side images of the five.
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

After D.P3 (same package). Flutter side: D.P7.
