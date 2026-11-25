# D.P9 Component tokens for data display: Flutter

Status: Planned · Tier: T2 · Branch: `feat/data-tokens-flutter`
Spec: architecture §9.7 (as rewritten by D.P1), §9.5 R1–R2 · Definition of done: the eleven `core_ui` data widgets read the `data` component tokens and pass the D.P2 gate.

## Goal

`FoxMoney`, `FoxStatusChip`, `FoxCountBadge`, `FoxCard`, `FoxListRow`, `FoxTimer`, `FoxOrderCard`, `FoxAmountsSummary`, `FoxSkeleton`, `FoxEmptyState` and `FoxDropLoader` answer to the same tokens as the web; every difference found is fixed toward the web.

## Plan

1. The eleven widgets read the generated `data` tokens through `FoxTheme`.
2. A difference from the web is fixed toward the web and its golden updated in its own commit, each listed in the evidence.
3. The registry's `metrics` of the eleven join the Flutter parity test.

Files (hand-written count, 14): the eleven widget files, `lib/src/theme/fox_theme.dart`, `test/parity_table.dart`, `docs/code/packages/core_ui.md`.

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

After D.P7 and D.P8.
