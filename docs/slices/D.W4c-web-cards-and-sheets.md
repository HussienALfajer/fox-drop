# D.W4c Web versions: restaurant and dish cards, bottom sheet, pull to refresh

Status: Planned · Tier: T2 · Branch: `feat/web-cards-sheets`
Spec: architecture §9.5 R1, R3, R4, R5, R7, R9, R13, §9.6, §9.9, §9.10; D.9, D.10 and D.11b's slice files for the approved looks · Definition of done: workflow §4 (UI items)

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Needs D.W1 and D.W2 merged. Runs in parallel with any other D.W3 or D.W4 slice.

## Goal

`ui-web` has RestaurantCard, DishCard, BottomSheet and PullToRefresh, matching the approved Flutter twins, in Storybook and the Design System, each reading one component-token file its twin reads too.

## Plan

0. Base check: BottomSheet on the headless dialog of §9.10 (focus trap, Escape, the S-curve top of the customer item sheet); PullToRefresh with pointer events on touch and nothing on a mouse, showing `DropLoader`. No new dependency without the owner.
1. Tokens: `restaurant-card.json`, `dish-card.json`, `bottom-sheet.json`, `pull-to-refresh.json` from the Flutter twins' current values, each declaring both folders.
2. Web: the components with stories for every state of their Flutter cards (the restaurant card's closed, busy and far states with the photo fallback of R7; the dish in the cart, unavailable and pressed; the sheet open with its handle; the pull at rest, pulling and refreshing), the Design System files and the bundle entries.
3. Design checkpoint (new rule, owner 2026-11-26): `pnpm parity RestaurantCard DishCard BottomSheet PullToRefresh`; the owner approves the web components on the sheet. They become the drawing.
4. Flutter: the twins read the same tokens; goldens move only for an agreed gap; parity cases for every story.

Files (hand-written count, 37; the owner allowed about 40 for this plan):

- Tokens (6): `packages/design-tokens/tokens/component/restaurant-card.json`, `dish-card.json`, `bottom-sheet.json`, `pull-to-refresh.json` (new), `CHANGELOG.md`, `package.json`.
- Web (22), under `packages/ui-web/`: for each of `restaurant-card`, `dish-card`, `bottom-sheet`, `pull-to-refresh`: `src/<name>/<name>.tsx`, `<name>.stories.tsx`, `design-system/<Name>/README.md`, `preview.html` (new) (16); `src/cards-sheets-review.test.tsx` (new), `src/index.ts`, `scripts/bundle.ts`, `scripts/bundle-entry.ts`, `scripts/docs.ts`, `test/stories.test.ts`.
- Flutter (5), under `packages/core_ui/`: `lib/src/restaurant_card/fox_restaurant_card.dart`, `dish_card/fox_dish_card.dart`, `bottom_sheet/fox_bottom_sheet.dart`, `pull_to_refresh/fox_pull_to_refresh.dart`; `test/parity/cards_sheets_parity_test.dart` (new).
- Docs (4): `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`, this file, `docs/roadmap.md`.

Not touched: `card/`, `drop-loader/`, `dialog/` and their Flutter twins (D.W3b, D.W3c; imported, not edited); `blocking_heads/` (D.W4d).

Tests written first (locked in the red phase):

- `src/cards-sheets-review.test.tsx`: each card is one named link with its state read; the photo fallback when the image fails; the sheet traps focus, closes on Escape and gives focus back; PullToRefresh calls its action once per pull, never on a mouse drag, and shows the still loader under reduced motion.
- `test/stories.test.ts`: the four new titles present.
- The four token files with their `$extensions`: `component-usage.test.ts` fails until both sides read every token.
- New screenshots for every story; Flutter goldens move only for an agreed gap.

## Stopped at

Not started.

## Evidence

- `pnpm parity …`: the sheets shown to the owner and the approval
- `node scripts/verify.mjs --changed`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

<the bases chosen, the gaps and the owner's choices>
