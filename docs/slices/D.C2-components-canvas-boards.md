# D.C2 The components canvas: the other boards, the index and the group notes

Status: Planned · Tier: T2 · Branch: `feat/components-canvas-boards`
Spec: architecture §9.8, §9.9, T14 · Definition of done: workflow §4

Part of the components canvas plan; its shared rules are in `D.C1-components-canvas-generator.md`. After D.C1 is merged and the owner approved the pilot boards' look.

## Goal

Every component of `COMPONENTS` without a popup has its generated board (about 38 beside the five pilots), a Main index board links to every board by group, and each group has its Arabic title note.

## Plan

1. `copy-ar.ts`: each component's description and when to use / not (from its Design System README), every remaining state caption, the group names.
2. `stories.ts` overrides for the stories that use a custom `render` (BlockingHeads' two parts, Sidebar, SignInHero, DataTable, Field, QuantityStepper, StatusChip, BottomNavigation, Button's press counter) and for the gesture states (BannerStack folded and opened, PullToRefresh pulling and refreshing) as forced props; an override only where a story cannot be read as args.
3. `index.ts` (new): the Main board — what the page is, three cards (Play, fixed states, synthetic data), links by group with counts.
4. `canvas.ts`: group title notes («إجراءات · 3») and the rows laid out by group; Main first.
5. The test widens from the pilots to every non-overlay component (the overlays of D.C3 listed as the only ones still without a board).
6. Write, measure, write, check (0 problems), publish.

Files (hand-written count, 9): generator 4 (`copy-ar.ts`, `stories.ts`, `index.ts`, `canvas.ts`), `board.ts` if a layout needs it, `test/components-canvas.test.ts`, this file, `docs/code/packages/ui-web.md`, `docs/roadmap.md`.

Tests written first (locked in the red phase): `test/components-canvas.test.ts` — every non-overlay component of `COMPONENTS` has a board, an Arabic description, a caption for each state and a cell for each; the Main board links every board, each link to an existing file; each group's note counts its boards.

## Stopped at

Planned.

## Evidence

- `node scripts/verify.mjs --changed`:
- `components-canvas:check`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session
