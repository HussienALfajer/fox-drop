# D.P11 Component tokens for overlays, navigation and actions: Flutter

Status: Planned · Tier: T2 · Branch: `feat/overlay-tokens-flutter`
Spec: architecture §9.7 (as rewritten by D.P1), §9.5 R1–R2 · Definition of done: every `core_ui` component passes the D.P2 gate; the parity work of 2026-11-25 is complete.

## Goal

`FoxDialog`, `FoxConfirmDialog`, `FoxToast`, `FoxBanner`, `FoxBannerStack`, `FoxMenu`, `FoxTabs`, `FoxTopBar`, `FoxNavigationRail`, `FoxIcon` and `FoxTextLink` answer to the same tokens as the web.

## Plan

1. The eleven widgets read the `overlays` and `navigation` tokens through `FoxTheme`.
2. A difference from the web is fixed toward the web and its golden updated in its own commit.
3. The registry's `metrics` of the eleven join the Flutter parity test, which then covers every entry.
4. Architecture §9.8: the parity check covers every component; the roadmap closes the work.

Files (hand-written count, 15): the eleven widget files, `lib/src/theme/fox_theme.dart`, `test/parity_table.dart`, `docs/code/packages/core_ui.md`, `docs/architecture/09-design-system.md`.

Tests written first (locked in the red phase): the Flutter parity test over the eleven.

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- The list of differences fixed, with the side-by-side images.
- Review: `reviewer` at medium, short list.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

After D.P9 and D.P10.
