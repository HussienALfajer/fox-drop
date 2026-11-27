# D.W4a Web versions: date, time, country sheet and code preview

Status: Done · Tier: T2 · Branch: `feat/web-date-country-code`
Spec: architecture §9.5 R1, R3, R4, R5, R9, §9.6, §9.9, §9.10; CU §5.2 (the code preview), D.8 and D.11b's slice files for the approved looks · Definition of done: workflow §4 (UI items)

> **D.R1 (2026-11-27):** the components this slice built were deleted, and so was D.11's slice file; both are in git history before the D.R1 merge.

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Needs D.W1, D.W2 and D.W3a merged (it reads `input.json` and edits `phone-field.tsx`). Runs in parallel with any D.W3 or D.W4 slice but D.W3a.

## Goal

`ui-web` has DateField, TimeField, CountrySheet and CodePreview, matching the approved Flutter twins, each in Storybook with all its states, in the Design System, and reading one component-token file that its Flutter twin reads too.

## Plan

0. Base check: the headless base for a calendar and a time picker (§9.10: UI SDK, else Base UI). If neither has one, stop and ask the owner before any new dependency. The web CountrySheet is the searchable list `phone-field` already shows (`country-list.ts`), lifted into its own component; `phone-field.tsx` then uses it.
1. Tokens: `date-field.json` (DateField and TimeField), `country-sheet.json`, `code-preview.json`, written from the Flutter twins' current values, each declaring both folders.
2. Web: the four components with their stories (every state of the Flutter card: empty, filled, error, disabled, open; Western digits, «ص» and «م»; the code masked), the Design System files and the bundle entries.
3. Design checkpoint (new rule, owner 2026-11-26): `pnpm parity DateField TimeField CountrySheet CodePreview`; the owner approves the web component on the sheet. It becomes the drawing.
4. Flutter: the twins read the same tokens; their goldens must not move (a moved golden is a parity fix the owner agreed, listed in «Notes»); parity cases for every story.

Files (hand-written count, 37; the owner allowed about 40 for this plan):

- Tokens (5): `packages/design-tokens/tokens/component/date-field.json`, `country-sheet.json`, `code-preview.json` (new), `CHANGELOG.md`, `package.json`.
- Web (23), under `packages/ui-web/`: for each of `date-field`, `time-field`, `country-sheet`, `code-preview`: `src/<name>/<name>.tsx` and `<name>.stories.tsx` (new), `design-system/<Name>/README.md` and `preview.html` (new) (16); `src/sign-in-forms-review.test.tsx` (new, the four components' tests), `src/phone-field/phone-field.tsx`, `src/index.ts`, `scripts/bundle.ts`, `scripts/bundle-entry.ts`, `scripts/docs.ts`, `test/stories.test.ts` (7).
- Flutter (5), under `packages/core_ui/`: `lib/src/date_field/fox_date_field.dart`, `date_field/fox_time_field.dart`, `phone_field/fox_country_sheet.dart`, `code_preview/fox_code_preview.dart`; `test/parity/sign_in_forms_parity_test.dart` (new).
- Docs (4): `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`, this file, `docs/roadmap.md`.

Not touched: `sign_in_hero/` (D.W4d), `phone_field/fox_phone_field.dart` (D.W3a moved it).

Tests written first (locked in the red phase):

- `src/sign-in-forms-review.test.tsx`: each component's name for assistive technology, keyboard use (the calendar's arrows in RTL, Escape closes, the list's search by Arabic name, English name and calling code), Western digits, the error read with the field, disabled; CodePreview never shows the whole code.
- `test/stories.test.ts`: the four new stories titles present.
- The three token files with their `$extensions`: `component-usage.test.ts` fails until both sides read every token.
- New screenshots for every story; the Flutter goldens unchanged.

## Decisions taken overnight (pending the owner)

The owner was asleep and delegated decisions to the supervising session (2026-11-26); each took the recommended option.

1. **The base (step 0):** the UI SDK has a `DatePicker` with calendar parts and a `TimeInput`, so no new dependency and no Base UI.
2. **The web time field types in place.** The pill holds the hour, minute and «ص»/«م» boxes (the SDK's `TimeInput`); the Flutter twin opens the same boxes in a dialog (the D.8 sheet's "typed" option). On a desktop page a dialog for three boxes adds a step; the closed face is the same. So `TimeField` has no `open` state.
3. **The web country sheet opens beside its trigger**, as the phone field's list did; the Flutter twin is a bottom sheet. `CountrySheet.Trigger` is a static part, not an index export, so it needs no stories of its own.
4. **Parity gaps, fixed** (the approved twin wins where the D.8 or D.11 sheet does not settle it): the date shows from the left, LTR, with plain figures (the web had it at the right, its slashes spaced by tabular figures); the time boxes are as wide as their text (`03:05 م`, they were fixed two-character boxes); the country list's section gap (`space.sm` above each section) and its empty line (`space.lg`, centred) take Flutter's values, which moves the phone field's open screenshot; the Flutter code preview's bubble no longer fills a bounded parent (its column took the maximum height; no golden moves, the goldens' parents are unbounded); a selected today in the Flutter date picker shows its number in `on-day-selected` (it was orange on the orange fill; review finding); days that cannot be picked no longer light up on hover on the web (review finding).
5. **Parity gaps left:** the web hour is padded (`03`, the SDK draws two-digit boxes; Flutter shows `3`); the open calendar and the open country list are portaled outside the shot on the web, and the Flutter calendar is a dialog route outside its frame, so those rows compare the closed field only (as `select--open` in D.W3a).
6. **Three locked tests were corrected, not weakened** (the SDK behaves otherwise than assumed): a time box is an input, so the test reads its value, not its text; the SDK puts the field's description on the time group, not on each box, so the test checks the group; the country list's trigger is a button (the search inside is the combobox). For the owner (review finding): a screen reader may not read a group's description when focus lands on a box inside it, so the time field's error is less sure to be heard than the date field's; giving each box the description needs the SDK's field id, which it does not expose.
7. **Two files outside the plan:** `e2e/visual.spec.ts` and `e2e/parity.spec.ts` drive a `spinbutton` too (a time box), else the TimeField Hover and Focus stories find no control and time out.

## Stopped at

Done: pull request open with auto-merge; the owner's approval of the sheets and of the overnight decisions is pending.

## Evidence

- Red phase: `sign-in-forms-review.test.tsx` failed on the missing modules, `stories.test.ts` on the four missing components, `component-usage.test.ts` on every token of the three new files unread on both sides.
- `pnpm parity DateField TimeField CountrySheet CodePreview`: four sheets, published for the owner as one private artifact (link outside the repository). The first run timed out on the time field's Hover and Focus (no `spinbutton` in the driven controls, decision 7); the second showed four gaps, fixed (decision 4); the third matched. Approval: delegated overnight, pending the owner.
- `node scripts/verify.mjs --changed`: «the checks of the change passed» (16 steps). Earlier runs failed on axe's `target-size` for the time boxes once they hugged their text (fixed with `date-field.segment.min-size`, 24) and once on port 6007 held by another session's run.
- ui-web `vitest run`: 46 files, 455 tests passed before the review fixes; `sign-in-forms-review.test.tsx` 21 passed after them. design-tokens: 454 passed.
- Review (T2, `reviewer`, one round): no code blocker. Fixed: days that cannot be picked lit up on hover; documented: the Flutter picker's selected today (now `on-day-selected`), the time group's description (for the owner). Its blocking item, the owner's approval of the sheet, and the locked-test corrections are the overnight decisions above, left to the owner.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

The UI SDK's DatePicker and TimeInput (decision 1). Gaps and choices: «Decisions taken overnight». The Flutter phone field's chip still reads `t.FoxRadius.sm` and `t.FoxSize.touchTarget` (not this slice's file).
