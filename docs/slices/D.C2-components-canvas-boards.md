# D.C2 The components canvas: the other boards, the index and the group notes

Status: Done · Tier: T2 · Branch: `feat/components-canvas-boards`
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

Done: 42 component boards (the pilots among them) and the index, checked, reviewed (two rounds) and published (canvas version 32). The Design System is re-synced after D.C3.

## Evidence

- `node scripts/verify.mjs --changed`: «the checks of the change passed».
- `pnpm baselines`: «no image changed» (the DataTable story's args moved; its 6 stories compared).
- `components-canvas:check`: «43 boards, 276 combinations, 0 with problems»; states sheets 2 to 33 KB.
- `test/components-canvas.test.ts`: 15 of 15.
- Review (reviewer, T2, medium): round 1, four should-fix (DataTable's cells and BannerStack's counter crossed as empty functions; gesture states drawn at rest under their names; Field's static input lost `disabled`) and three minor, fixed; round 2, DataTable's sort and selection callbacks added by its story wrapper (now in the meta args) and the static markup's server ids, fixed. Two items to the backlog (gesture states, the table's hover).

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

- **Stories read generically, two narrow tables.** A story's `render` (its own or its meta's) is called in Node and the first library component it draws is taken with its props (SignInHero framed, StatusChip's tone, Field around the SDK's input); a child from outside the library crosses as its static markup drawn inside that component (Field's input keeps `disabled`; on the canvas its label is not tied to it); a wrapper that gets the args as they are (QuantityStepper's counter) keeps them, so its stories are scenarios too. Function props that give content are the one per-component table (`CALLS`): DataTable's cells, row keys and names over its rows, BannerStack's counter words over the hidden counts, called in Node and carried as results (the review found them empty). Other functions wait 1.5 s on the canvas, like a request. The blocking heads mount their parts (`FoxDrop.BlockingHeads.VersionTicket`, `.ShopSign`), named as the bundle names them.
- **Gesture-only states are drawn at rest, and say so:** BannerStack opened and PullToRefresh pulling and refreshing have no prop that holds them; their cells carry «بالإيماءة في Play، مرسومة هنا ساكنة» and they are no scenarios. A forced-display prop on those components was left out (no use outside the canvas); pending the owner.
- **BlockingBanner moved to D.C3:** it covers the page like a popup, so it is drawn open once it takes `inline`.
- **TopBar and DataTable are wide:** their surfaces and states sit one a row (`WIDE` in `board.ts`).
- **The index is `Index.dc.html`:** the old hand-drawn `Main.dc.html` is still on the proposals page until D.C4, which may rename the index to `Main`.
- **Caption words:** `SCurve` splits as «s curve», `picked_up` as «picked up»; every word of every state and story name has its Arabic in `copy-ar.ts` (`WORDS`), phrases before words.
- **The Design System is re-synced once after D.C3** (Dialog's `inline` from D.C1 and the popups' from D.C3); until then the canvas sends this branch's bundle.
