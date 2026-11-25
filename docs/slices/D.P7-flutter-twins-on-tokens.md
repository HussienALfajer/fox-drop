# D.P7 Flutter on component tokens: the seventeen twins

Status: Planned · Tier: T2 · Branch: `feat/flutter-twins-tokens`
Spec: architecture §9.7 (as rewritten by D.P1), §9.5 R1–R2 · Definition of done: the seventeen `core_ui` widgets that got web twins in D.P3 to D.P6 take every size, radius, gap and colour from the component tokens and pass the D.P2 gate.

## Goal

The Flutter side of the seventeen components reads the same component tokens as the web, so the parity gate holds them together.

## Plan

1. `core_tokens` already carries the generated classes (D.P3 to D.P6); `FoxTheme` exposes the `data`, `navigation` and `notices` tokens like `ButtonTokens` and `InputTokens`; the pickers read `InputTokens`.
2. The seventeen widgets: `FoxRestaurantCard`, `FoxDishCard`, `FoxOrderRow`, `FoxLogo`, `FoxCountdownRing`, `FoxBottomNavigation`, `FoxRestaurantBar`, `FoxPullToRefresh`, `FoxBottomSheet`, `FoxTrackingSteps`, `FoxSignInHero`, `FoxCodePreview`, `FoxCountrySheet`, `FoxVersionTicket`, `FoxShopSign`, `FoxDateField`, `FoxTimeField`. A value that differed from the web twin is fixed toward the web (the reference) and its golden updated in its own commit.
3. The registry's `metrics` of the seventeen join the Flutter parity test.

Files (hand-written count, 21): the seventeen widget files, `lib/src/theme/fox_theme.dart`, `test/parity_table.dart`, `docs/code/packages/core_ui.md`, `docs/roadmap.md` (goldens apart).

Tests written first (locked in the red phase): the Flutter parity test over the seventeen, failing before the move.

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- Every golden that changed, with the side-by-side image.
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing; the apps take it at their next build.

## To check on staging

Nothing new.

## Notes for the next session

After D.P6. The customer screens (D.11 onward) are paused by the owner (2026-11-25), so nothing else is in flight on `core_ui`. The sync publishes the Design System only: the Guide and the other canvases are not touched until every D.P slice is done (owner, 2026-11-25).
