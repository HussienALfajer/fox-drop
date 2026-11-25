# D.W4a Web versions: date, time, country sheet and code preview

Status: Planned · Tier: T2 · Branch: `feat/web-date-country-code`
Spec: architecture §9.5 R1, R3, R4, R5, R9, §9.6, §9.9, §9.10; CU §5.2 (the code preview), D.8 and D.11b's slice files for the approved looks · Definition of done: workflow §4 (UI items)

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

<the base chosen for the calendar, the gaps and the owner's choices>
