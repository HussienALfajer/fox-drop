# D.W3a Component tokens and parity: forms and actions

Status: Planned · Tier: T2 · Branch: `refactor/tokens-forms-actions`
Spec: architecture §9.2 (the component layer), §9.5 R1, R2, R9, R10, §9.9 · Definition of done: workflow §4 (UI items)

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Needs D.W1 and D.W2 merged. Runs in parallel with any other D.W3 or D.W4 slice except D.W4a, which edits `phone-field.tsx` after this slice.

## Goal

Every form and action component with both versions reads one component-token file on both sides, and its parity sheet is reviewed: Button, Field, TextField, TextArea, SearchField, PhoneField, CodeField, Select, Checkbox, Radio, Switch, QuantityStepper, TextLink.

## Plan

0. Design checkpoint: `pnpm parity Button Field TextField TextArea SearchField PhoneField CodeField Select Checkbox RadioGroup Switch QuantityStepper TextLink` before any change; the owner marks each gap on the sheets (shared rule: the D.8 or D.11b sheet wins where it shows the state, else the web). The gaps and decisions go in «Notes» below.
1. Tokens: `input.json` declares its folders (`$extensions`) and gains the values either side still hard-codes or takes from the semantic layer (each found by `component-usage.test.ts` and by reading); `text-link.json` is new; `button.json` takes Button's gap fixes.
2. Web: each component reads only its component tokens (`--fd-input-*`, `--fd-text-link-*`, `--fd-button-*`), the type roles and the motion tokens; the agreed gaps fixed.
3. Flutter: the same through `FoxTheme.of(context).components`; the agreed gaps fixed; parity cases for every story of these components.
4. Images: the moved screenshots and goldens updated with `pnpm baselines` in their own commit; each moved image is a listed gap fix, nothing else.

Files (hand-written count, 38; the owner allowed about 40 for this plan):

- Tokens (5): `packages/design-tokens/tokens/component/input.json`, `button.json`, `text-link.json` (new), `CHANGELOG.md`, `package.json`.
- Web (14), under `packages/ui-web/src/`: `button/button.tsx`, `field/field.tsx`, `field/styles.ts`, `text-field/text-field.tsx`, `text-area/text-area.tsx`, `search-field/search-field.tsx`, `phone-field/phone-field.tsx`, `code-field/code-field.tsx`, `select/select.tsx`, `checkbox/checkbox.tsx`, `radio-group/radio-group.tsx`, `switch/switch.tsx`, `quantity-stepper/quantity-stepper.tsx`, `text-link/text-link.tsx`.
- Flutter (15), under `packages/core_ui/`: `lib/src/button/fox_button.dart`, `field/fox_field.dart`, `field/entry.dart`, `field/pick_box.dart`, `text_field/fox_text_field.dart`, `phone_field/fox_phone_field.dart`, `code_field/fox_code_field.dart`, `select/fox_select.dart`, `checkbox/fox_checkbox.dart`, `radio/fox_radio.dart`, `switch/fox_switch.dart`, `quantity_stepper/fox_quantity_stepper.dart`, `text_link/fox_text_link.dart`, `internal/choice_row.dart`; `test/parity/forms_parity_test.dart` (new; TextLink's cases too).
- Docs (4): `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`, this file, `docs/roadmap.md`.

Not touched: `phone_field/fox_country_sheet.dart` and `phone-field/country-list.ts` (D.W4a), `internal/anchored_menu.dart` (D.W3c owns it; Select's open list takes its look from the menu tokens there), `icon/`, `tabs/` (D.W3c).

Tests written first (locked in the red phase):

- The `$extensions` of `input.json` and `text-link.json` are written first: `component-usage.test.ts` then fails for every token one side does not read, and passes when both sides read all of them.
- A test per agreed gap that changes behaviour or a size a test can see (a target, a height): in the component's existing test file (`*.test.tsx`, `test/text_field_test.dart`, `test/choice_test.dart`, `test/pick_test.dart`, `test/phone_field_test.dart`).
- The rest is proven by the screenshots and goldens: an image moves only where a gap was fixed.

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
