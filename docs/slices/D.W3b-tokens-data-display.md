# D.W3b Component tokens and parity: data display

Status: Planned · Tier: T2 · Branch: `refactor/tokens-data-display`
Spec: architecture §9.2 (the component layer), §9.5 R1, R2, R5, R9, §9.9 · Definition of done: workflow §4 (UI items)

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Needs D.W1 and D.W2 merged. Runs in parallel with any other D.W3 or D.W4 slice.

## Goal

Every data-display component with both versions reads its own component-token file on both sides, and its parity sheet is reviewed: Money, StatusChip, CountBadge, Card, ListRow, AmountsSummary, Skeleton, EmptyState, DropLoader; the web-only DataTable gets its file too. Timer and OrderCard move in D.W4b, with the Flutter-only components that share their files.

## Plan

0. Design checkpoint: `pnpm parity Money StatusChip CountBadge Card ListRow AmountsSummary Skeleton EmptyState DropLoader` before any change; the owner marks each gap (shared rule: the D.9 or D.11b sheet wins where it shows the state, else the web).
1. Tokens: one new file per component, each declaring its folders: the paddings, heights, radii, per-state and per-tone colours, icon and text sizes either side uses today (the values do not change unless a gap says so).
2. Web: each component reads only its tokens, the type roles and the motion tokens; gaps fixed.
3. Flutter: the same through `FoxTheme.of(context).components`; gaps fixed; parity cases for every story.
4. Images: the moved screenshots and goldens in their own commit, each a listed gap fix.

Files (hand-written count, 37; the owner allowed about 40 for this plan):

- Tokens (12): `packages/design-tokens/tokens/component/money.json`, `status-chip.json`, `count-badge.json`, `card.json`, `list-row.json`, `amounts-summary.json`, `skeleton.json`, `empty-state.json`, `drop-loader.json`, `data-table.json` (all new; DataTable's `flutter` folders empty), `CHANGELOG.md`, `package.json`.
- Web (10), under `packages/ui-web/src/`: `money/money.tsx`, `status-chip/status-chip.tsx`, `count-badge/count-badge.tsx`, `card/card.tsx`, `list-row/list-row.tsx`, `amounts-summary/amounts-summary.tsx`, `skeleton/skeleton.tsx`, `empty-state/empty-state.tsx`, `drop-loader/drop-loader.tsx`, `data-table/data-table.tsx`.
- Flutter (11), under `packages/core_ui/`: `lib/src/money/fox_money.dart`, `status_chip/fox_status_chip.dart`, `status_chip/fox_tone.dart`, `count_badge/fox_count_badge.dart`, `card/fox_card.dart`, `list_row/fox_list_row.dart`, `amounts_summary/fox_amounts_summary.dart`, `skeleton/fox_skeleton.dart`, `empty_state/fox_empty_state.dart`, `drop_loader/fox_drop_loader.dart`; `test/parity/data_parity_test.dart` (new).
- Docs (4): `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`, this file, `docs/roadmap.md`.

Not touched: `timer/`, `order-card/`, `order_card/` (D.W4b), `drop_loader/mark_geometry.dart` (drawing geometry, outside the literal rule since D.W1).

Tests written first (locked in the red phase):

- The ten token files with their `$extensions`, written first: `component-usage.test.ts` fails for every unread token and passes when both sides read all of them.
- A test per agreed gap a test can see, in the component's existing tests (`*.test.tsx`, `test/data_test.dart`, `test/drop_loader_test.dart`).
- The rest by the screenshots and goldens: an image moves only where a gap was fixed.

## Stopped at

Not started.

## Evidence

- `pnpm parity …` before and after: the sheets shown to the owner
- `node scripts/verify.mjs --changed`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

<the gaps found on the sheets, the owner's choice for each, and their fixes>
