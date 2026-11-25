# D.P8 Component tokens for data display: web

Status: Planned · Tier: T2 · Branch: `feat/data-tokens-web`
Spec: architecture §9.2, §9.6 (as rewritten by D.P1), §9.5 R1 · Definition of done: the eleven data components that already have both sides take their values from component tokens on the web and pass the D.P2 gate there.

## Goal

`Money`, `StatusChip`, `CountBadge`, `Card`, `ListRow`, `Timer`, `OrderCard`, `AmountsSummary`, `Skeleton`, `EmptyState` and `DropLoader` read their sizes, radii, gaps and colours from `tokens/component/data.json`; nothing looks different.

## Plan

1. Tokens: the eleven in `data.json` (D.P3 created it), each value the one the web uses today; `generate`; version and `CHANGELOG.md`.
2. Web: the eleven components read the component variables; the visual baselines must not change.
3. The registry's `metrics` of the eleven (web gate).

Files (hand-written count, 16): the eleven component files, `data.json`, `packages/design-tokens/package.json`, `CHANGELOG.md`, `components.json`, `docs/code/packages/design-tokens.md`.

Tests written first (locked in the red phase): the registry `metrics` of the eleven, run by the web parity spec.

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

After D.P6 (same package). Flutter side: D.P9, where a Flutter value that differs from the web is fixed toward the web.
