# D.W4b Web versions: countdown ring, order row, logo and tracking steps

Status: Planned · Tier: T2 · Branch: `feat/web-order-parts`
Spec: architecture §9.5 R1, R3, R4, R5, R9, §9.6, §9.9; D.9 and D.11b's slice files for the approved looks · Definition of done: workflow §4 (UI items)

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Needs D.W1 and D.W2 merged. Runs in parallel with any other D.W3 or D.W4 slice.

## Goal

`ui-web` has CountdownRing, OrderRow, Logo and TrackingSteps, matching the approved Flutter twins, in Storybook and the Design System; and the twins Timer and OrderCard, whose Flutter files hold the ring, the row and the logo, move onto component tokens with them.

## Plan

1. Tokens: `countdown-ring.json`, `order-row.json`, `logo.json`, `tracking-steps.json` from the Flutter twins' current values, and `timer.json`, `order-card.json` for the two twins; each declares both folders.
2. Web: the four new components with stories for every state of their Flutter cards (the ring emptying over 45 seconds and its last seconds; the row's states; the logo and its initials; the four steps with the current one), the Design System files and the bundle entries; `timer.tsx` and `order-card.tsx` read their tokens (OrderCard shows the new Logo where its Flutter twin does).
3. Design checkpoint (new rule, owner 2026-11-26): `pnpm parity CountdownRing OrderRow Logo TrackingSteps Timer OrderCard`; the owner approves the new web components and marks the twins' gaps (shared rule).
4. Flutter: `fox_timer.dart`, `fox_order_card.dart` and `fox_tracking_steps.dart` read the same tokens; goldens move only for an agreed gap; parity cases for every story.

Files (hand-written count, 38; the owner allowed about 40 for this plan):

- Tokens (8): `packages/design-tokens/tokens/component/countdown-ring.json`, `order-row.json`, `logo.json`, `tracking-steps.json`, `timer.json`, `order-card.json` (new), `CHANGELOG.md`, `package.json`.
- Web (24), under `packages/ui-web/`: for each of `countdown-ring`, `order-row`, `logo`, `tracking-steps`: `src/<name>/<name>.tsx`, `<name>.stories.tsx`, `design-system/<Name>/README.md`, `preview.html` (new) (16); `src/order-parts-review.test.tsx` (new), `src/timer/timer.tsx`, `src/order-card/order-card.tsx`, `src/index.ts`, `scripts/bundle.ts`, `scripts/bundle-entry.ts`, `scripts/docs.ts`, `test/stories.test.ts`.
- Flutter (4), under `packages/core_ui/`: `lib/src/timer/fox_timer.dart`, `order_card/fox_order_card.dart`, `tracking_steps/fox_tracking_steps.dart`; `test/parity/order_parts_parity_test.dart` (new).
- Docs (2 more): `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`; with this file and `docs/roadmap.md`, 40.

Not touched: `money/`, `status-chip/`, `card/` and their Flutter twins (D.W3b; imported, not edited).

Tests written first (locked in the red phase):

- `src/order-parts-review.test.tsx`: the ring's remaining seconds read aloud and its still state under reduced motion; the row and the steps named for assistive technology, the current step marked (`aria-current`), never colour alone; Western digits; the logo's initials from an Arabic and a Latin name, its image's empty alternative text when a name sits beside it.
- `test/stories.test.ts`: the four new titles present.
- The six token files with their `$extensions`: `component-usage.test.ts` fails until both sides read every token.
- New screenshots for every story; Flutter goldens move only for an agreed gap.

## Decisions taken overnight (pending the owner)

The owner was asleep and delegated decisions to the supervising session (2026-11-26); each took the recommended option and stays open for the owner to reverse. The approved looks are the Flutter twins (D.9, D.11b); where the D.9 sheet («Data display — batch 3», `packages/design-tokens/src/data-sheet.ts`) draws a state it wins, else the web wins (shared rule).

1. **Design checkpoint:** the new web components copy their approved Flutter twins, so the sheet approval of plan step 3 is taken as given for the night; the before and after parity sheets stay on disk for the owner (`.parity/*.html`, git-ignored, not published). The Figma look of §2 of `/build-slice` was skipped for the same reason: no new look is drawn.
2. **Order card spacing (a gap):** the sheet spaces every part of the board card by `space.sm` (12), as the web did; Flutter used 8, 4, 8 and 12. Flutter moves to one `order-card.gap`.
3. **Timer height (a gap):** the web timer is at least `size.step` (32); the Flutter one came to 31.4 (its text and 4 above and below). Flutter takes `timer.min-height`. The sheet's 36, 28 and 44 stay undrawn, as the status chip's in D.W3b. The web's compact density keeps 24 with no block padding (adding it would make 30).
4. **Countdown ring:** the sheet draws a 96 ring with an 8 stroke and a 29 number; Flutter's approved ring has a 6 stroke and the `number` type role. The twin wins: new semantic `size.countdown-ring` (96px) and `border-width.ring` (6px). The web eases each tick's sweep over `duration.base` (motion-safe only); the Flutter ring now does the same through a `TweenAnimationBuilder` that is instant under `disableAnimations`, so both are still under reduced motion and no golden moves.
5. **Logo's letter:** the web and Flutter both take the trimmed name's first character, a Latin one in capitals (Flutter took the untrimmed first character as is; no golden shows a Latin or spaced name). No image story or case: the image is the app's.
6. **Order row:** the web row is an `article` named «restaurant، date»; with `onPress` the restaurant's name is the button and covers the card, so the reorder action stays a separate button (Flutter's card is one button that keeps its inner semantics). It has no hover tint on the card.
7. **Tracking steps:** the web list takes a `label` prop (its name for assistive technology), which the Flutter strip has no need for (each step is a node).
8. **Files beyond the plan's list:** `tokens/semantic/base.json` (the two tokens of decision 4); `src/theme.css` (the pulse keyframes and the late ring's delay) with `src/countdown-ring/countdown-ring.css` and `src/tracking-steps/tracking-steps.css` (the SVG radius and dash utilities: no style prop, no arbitrary value); `src/order-card/order-card.test.tsx` (its late assertion names the card token now); `test/design-system.test.ts` (the four new props types documented).

## Stopped at

Done: pull request open with auto-merge.

## Evidence

- `pnpm parity …`: the sheets shown to the owner and the approval
- `node scripts/verify.mjs --changed`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

<the gaps and the owner's choices>
