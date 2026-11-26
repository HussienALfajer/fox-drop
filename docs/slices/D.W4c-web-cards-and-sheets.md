# D.W4c Web versions: restaurant and dish cards, bottom sheet, pull to refresh

Status: Done · Tier: T2 · Branch: `feat/web-cards-sheets`
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

## Decisions taken overnight (pending the owner)

The owner was asleep and delegated decisions to the supervising session (2026-11-26); each took the recommended option.

1. **The bases (step 0):** BottomSheet on the UI SDK's `Dialog`, as the side drawer (focus trap, Escape, focus back); not its `Drawer`, whose drag physics would give the web the Flutter sheet's drag-down close but writes physical sides and has no `inline` frame for the stories. So the web sheet does not close on a drag (Escape, the scrim and the × do). PullToRefresh on React pointer events, touch only. No new dependency.
2. **The cards are one link each, not one button.** A card holding a button (the heart, «+») cannot be a `<button>`; the name is the link, stretched over the card (`href` on both, where Flutter has `onPressed`). The web `Card` is imported nowhere here: its pressable form is a button. The restaurant link reads its state with the name; an unavailable dish is no link (as Flutter's `onPressed: null`).
3. **Three semantic sizes outside the plan's files** (`tokens/semantic/base.json`): `size.cover-logo` 72, `size.dish-photo` 96, `size.sheet-handle` 40, the values the twins computed (`touchTarget + lg`, `touchTarget * 2`, `xl + xs`); a component file references semantic tokens only and has no arithmetic. **One file removed:** `core_ui/lib/src/internal/faded.dart`, unused once both cards read their `faded-opacity` token.
4. **The `far` state** of the plan has no badge in CU §8.2 (a restaurant outside the coverage does not appear): the story is a restaurant at the edge of its coverage, with a long estimate and a higher fee. Added states the web needs: `favourite`, `hover`, `focus`, `pressed` on both cards.
5. **No photos in the stories** (no image asset in Storybook, the CSP forbids `data:` URLs, the Flutter goldens use none either): every story shows the fallback; the photo and its failure are in the tests.
6. **The open sheets are `inline` in their stories** (a new `inline` prop, the SDK's frame mode with `modal="trap-focus"`), so the screenshot and the parity sheet show the sheet; the Design System card uses it too.
7. **The web sheet's height:** at most the screen below `size.bar` (64) rather than Flutter's 90% (the lint refuses a fraction class, and no token holds a viewport share). Web only besides: centred at `size.dialog` on a wide page; no home-indicator padding (no `env()` class without an arbitrary value).
8. **The logo is D.W4b's web `Logo`**, merged from main while this slice was open: the restaurant card draws a local logo no more; on a missing cover a wrapper sets it to `restaurant-card.logo-size` (72), as Flutter's `FoxLogo(size:)`. The web `Logo` has no fallback for an image that fails to load (the cover has). Files outside the plan's list besides decision 3: `docs/backlog.md` (one item).
9. **Parity gaps fixed** (all on the web; the approved twins win): the cover had no height (Tailwind's `aspect-video` is reset by the token theme; now `aspect-cover`); the sheet's × was pulled out of its row by the shared `-m-xs` and cut the handle (now `m-none` in the row, as Flutter's 48 icon button); the pull's refresh button, meant for the keyboard only, stood in the flow 40 high (its own `relative` and height beat `sr-only`; now hidden by an `sr-only` wrapper) and pushed the list down; the pull story's text took the page's black, not `on-surface`. The Flutter open-sheet cases drop their trigger: the web side shoots an open dialog alone (D.W3c's parity spec).
10. **Parity gaps left:** the web sheet moves focus inside when it opens (the SDK's first control, the ×, with its ring), Flutter's does not (a dialog's focus rule on the web, §9.10); the drop's `elevation.medium` is softer on the web than Flutter's shadow (the shared token's rendering, not this slice's); the web mark fills with a flat surface, Flutter's with the wave's crest.
11. **The Figma look (skill §2) could not run:** the Figma API reset the connection. The twins carry the approved D.9 and D.10 looks; no new idea is taken.

## Stopped at

Done: pull request open with auto-merge; the owner's approval of the sheets and of the overnight decisions is pending.

## Evidence

- Red phase: `cards-sheets-review.test.tsx` failed on the missing modules, `stories.test.ts` on the four missing components, `component-usage.test.ts` on every token of the four new files (no folder, nothing read).
- `pnpm parity RestaurantCard DishCard BottomSheet PullToRefresh`: four sheets in `.parity/` (git-ignored, on disk for the owner). The first run showed the gaps of decision 9, fixed; the third run, after the review fixes, matched but for the gaps of decision 10. Approval: delegated overnight, pending the owner.
- `pnpm baselines`: «baselines: passed»; only the new stories' screenshots were added, no existing screenshot and no `core_ui` golden moved.
- ui-web `vitest run`: 47 files, 488 tests passed (before the review's new test file); `cards-sheets-review.test.tsx` 17 and `pull-to-refresh.test.tsx` 3 passed after the fixes. design-tokens `component-usage.test.ts`: 28 passed. core_ui `flutter test`: all passed; `dart analyze`: no issues.
- `node scripts/verify.mjs --changed`: «the checks of the change passed». Earlier runs failed on axe's `scrollable-region-focusable` once the long sheet and the pull list overflowed their frames (both scroll regions now take keyboard focus; the sheet's content only while it overflows, so it never takes the first focus of a short sheet), and once on two `core_auth` session tests (timing under the machine's load from parallel slices; they pass alone, and the change does not touch `core_auth`).
- Merged `origin/main` three times (D.W3c, D.W4b, then D.W4d): design-tokens 0.21.0 after them, outputs regenerated; the restaurant card now uses D.W4b's web `Logo` (decision 8).
- Review (T2, `reviewer`, two rounds): round 1 found one blocking item (the new screenshots not committed) and three should-fix (the dish card's outline lost under hover and press; no story where the long sheet or the pull list overflows, REVIEW item 15; WebKit has no `pan-down`, so the pull would not work on iOS), with four minor (the state chip under the heart, an unhandled rejected refresh, the `inline` sheet trapping Tab, three stale doc lines); all fixed. Round 2: one new minor (no test for the touch listener), fixed with `pull-to-refresh.test.tsx`.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

The bases: the UI SDK's `Dialog` for the sheet, pointer events plus a non-passive `touchmove` for the pull (decision 1). Gaps and choices: «Decisions taken overnight». Owner to try after the merge: `pnpm --filter @fox-drop/ui-web storybook`, the four new titles in Arabic RTL; on a phone browser, pull the PullToRefresh story's list down from its top.
