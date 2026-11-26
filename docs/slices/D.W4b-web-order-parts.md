# D.W4b Web versions: countdown ring, order row, logo and tracking steps

Status: Done · Tier: T2 · Branch: `feat/web-order-parts`
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
4. **Countdown ring, an exception to the shared rule:** the sheet draws a 96 ring with an 8 stroke and a 29 number, which would win; Flutter's approved ring (D.9's widgetbook and goldens) has a 6 stroke and the `number` type role, and the twin wins here, since the sheet's stroke and number were drawn before the ring was built and approved. New semantic `size.countdown-ring` (96px) and `border-width.ring` (6px). The web eases each tick's sweep over `duration.base` (motion-safe only); the Flutter ring now does the same through a `TweenAnimationBuilder` that is instant under `disableAnimations`, so both are still under reduced motion and no golden moves.
5. **Logo's letter:** the web and Flutter both take the trimmed name's first character, a Latin one in capitals (Flutter took the untrimmed first character as is; no golden shows a Latin or spaced name). No image story or case: the image is the app's.
6. **Order row:** the web row is an `article` named «restaurant، date»; with `onPress` the restaurant's name is the button and covers the card, so the reorder action stays a separate button (Flutter's card is one button that keeps its inner semantics). It has no hover tint on the card.
7. **Names for assistive technology:** the web tracking list takes a `label` prop (its name), which the Flutter strip has no need for (each step is a node). The web ring is a `timer` named «38 ثانية متبقية»; the Flutter ring takes the same words as an optional `label` (found by the review; without it, it reads the number alone, as before), and both show 0 for a negative count.
8. **Order row focus:** a `Focus` story and its parity case show the keyboard on the restaurant's name (found by the review); the Flutter card shows its own focus ring round the card.
9. **Not gaps:** the captain's type on the web is the phone's (the web has no captain type roles; the Flutter timer and ring grow on the captain theme), as in D.W3b; the Flutter order card is 2 px taller than the web's at the head, where its wrap lays the timer out.
10. **Files beyond the plan's list:** `tokens/semantic/base.json` (the two tokens of decision 4); `src/theme.css` (the pulse keyframes and the late ring's delay) with `src/countdown-ring/countdown-ring.css` and `src/tracking-steps/tracking-steps.css` (the SVG radius and dash utilities: no style prop, no arbitrary value); `src/order-card/order-card.test.tsx` (its late assertion names the card token now); `test/design-system.test.ts` (the four new props types documented).
11. **One locked test corrected, not weakened:** `order-parts-review.test.tsx` asked for the still ring under `motion-reduce:` only. The parity sheet showed that a shot with animations cancelled (the screenshots and the sheet) then drew no ring at all, where Flutter draws the still one; the still values are now the first ring's own look (the animation overrides them when motion is allowed), and the test asks for that.

## Stopped at

Done: pull request open with auto-merge.

## Evidence

- Red phase: `order-parts-review.test.tsx` failed on the missing modules, `stories.test.ts` on the four missing titles, `component-usage.test.ts` on every token of the six new files («no web file in countdown-ring reads --fd-countdown-ring-size», «no Flutter file in timer reads countdownRing.size», …).
- `pnpm parity CountdownRing OrderRow Logo TrackingSteps Timer OrderCard`, before the Flutter changes and after (48 web shots, 46 Flutter): before, the order card's spacing, the timer's height, the Latin logo letter and the web's missing still ring differed (and a web bug: a shadowed name dropped the card number's bold); after, each pair matches but for decision 10. The sheets are on the host for the owner (`.parity/*.html`, not published).
- `node scripts/verify.mjs --changed`: «the checks of the change passed» (Turborepo lint, types, build and smoke; tests; Dart analyze, `fox_lints rules`, format, Dart and Flutter tests), before and after the review's fixes.
- `pnpm baselines`: «passed in 2 min 23 s»; 26 new web screenshots, six Flutter goldens moved (decisions 2 and 3 only), web Timer and OrderCard screenshots unchanged; each looked at.
- Review (T2, `reviewer`, two rounds): round 1 found the baselines not updated (two blocking), the slice record, decision 4's wording, the Flutter ring's missing words and the order row's missing focus story; round 2 asked for a test of the ring's label and floor (added to `core_ui/test/data_review_test.dart`) and for the corrected locked test to be named in the pull request.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

The gaps and their fixes are under «Decisions taken overnight». If the owner reverses one, change its token (or the semantic size) and run `pnpm baselines`; `core_ui/test/parity/order_parts_parity_test.dart` shows the pairs again with `pnpm parity CountdownRing OrderRow Logo TrackingSteps Timer OrderCard`. Apps that show the ring should pass `FoxCountdownRing.label`.
