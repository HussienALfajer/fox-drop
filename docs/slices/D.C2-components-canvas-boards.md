# D.C2 The components canvas: the other boards, the index and the group notes

Status: In progress · Tier: T2 · Branch: `feat/components-canvas-boards`
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

Built: 41 component boards and the index, written, measured and checked; the unit test widened (12 of 12). Next: `--changed`, review, publish.

## Evidence

- `node scripts/verify.mjs --changed`:
- `components-canvas:check`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

- **No per-component overrides were needed.** A story's `render` (its own or its meta's) is called in Node and the first library component it draws is taken with its props (SignInHero framed, StatusChip's tone, Field around the SDK's input); a child from outside the library (the SDK's input, `InputBox`) crosses as its static markup (`{ $html }`); a `render` that only wraps state (QuantityStepper's counter, DataTable's sorter, BottomNavigation's demo) keeps the story's args. The blocking heads mount their parts (`FoxDrop.BlockingHeads.VersionTicket`, `.ShopSign`), named as the bundle names them.
- **BlockingBanner moved to D.C3:** it covers the page like a popup, so it is drawn open once it takes `inline`.
- **TopBar is wide:** its surfaces and states sit one a row (`WIDE` in `board.ts`).
- **The index is `Index.dc.html`:** the old hand-drawn `Main.dc.html` is still on the proposals page until D.C4, which may rename the index to `Main`.
- **Caption words:** `SCurve` splits as «s curve», `picked_up` as «picked up»; every word of every state and story name has its Arabic in `copy-ar.ts` (`WORDS`), phrases before words.
- **The Design System is re-synced once after D.C3** (Dialog's `inline` from D.C1 and the popups' from D.C3); until then the canvas sends this branch's bundle.
