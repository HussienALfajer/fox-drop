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

## Gaps on the sheets (before the change)

`pnpm parity Field TextField TextArea SearchField PhoneField CodeField Select Checkbox RadioGroup Switch QuantityStepper TextLink` (and Button): the Flutter cases were written first (`forms_parity_test.dart`), so the sheet before the change pairs every story with its twin. Rule: the D.8 sheet (`src/forms-sheet.ts`) wins where it shows the state, else the web.

| #   | Component                                  | Gap                                                                                       | Who wins                     | Fix                                                                                 |
| --- | ------------------------------------------ | ----------------------------------------------------------------------------------------- | ---------------------------- | ----------------------------------------------------------------------------------- |
| 1   | Checkbox, Radio                            | Flutter put the label 16 after the 48 target (the web 4)                                  | D.8 sheet (`gap: space.2xs`) | Flutter: `input.check.gap`, no label padding                                        |
| 2   | RadioGroup                                 | Web: a disabled unselected circle kept the rest fill and blue outline                     | D.8 sheet (grey)             | Web: two-attribute `data-disabled:data-unchecked:`                                  |
| 3   | QuantityStepper                            | Flutter drew the count in the `number` role (30) in a 44 cell                             | D.8 sheet (18 bold) and web  | Flutter: subtitle role, `input.stepper.value-width` (48, the web's; the sheet's 44) |
| 4   | SearchField                                | Web: the clear button was transparent at rest                                             | D.8 sheet (32 on `surface`)  | Web: `input.clear.*`                                                                |
| 5   | PhoneField                                 | Web: the clear button a 48 transparent circle; Flutter: the sheet's 32 on `surface`       | D.8 sheet (as the search)    | Web: a 32 circle in a 48 target                                                     |
| 6   | PhoneField                                 | Flutter drew a hairline after the chip                                                    | D.8 sheet (none) and web     | Flutter: removed                                                                    |
| 7   | Select                                     | Flutter kept the chevron down while open                                                  | Web (turns up)               | Flutter: `AnimatedRotation` in `PickBox`                                            |
| 8   | TextArea                                   | Web: with no hint the counter sat at the start                                            | D.8 sheet (end)              | Web: `ms-auto`                                                                      |
| 9   | Field (error)                              | Flutter: the error icon at the top of its line                                            | Web (centred)                | Flutter: the row centres                                                            |
| 10  | TextLink                                   | Flutter: the focus ring a 2 border tight on the words; the web a ring round the 48 target | Web                          | Flutter: `FocusRing` round the target                                               |
| 11  | Switch                                     | Flutter shows no visible label (semantics only); the web draws it beside the track        | Web                          | Left (decision 2)                                                                   |
| 12  | RadioGroup                                 | Flutter's group title stays blue when every radio is disabled                             | Web                          | Left (decision 2)                                                                   |
| 13  | TextLink                                   | The underline sits closer to the words in Flutter (no offset there)                       | Web                          | Left: Flutter's `TextStyle` has no underline offset                                 |
| —   | Button, CodeField, TextField, Field (rest) | No gap                                                                                    | —                            | —                                                                                   |

## Decisions taken overnight (pending the owner)

The owner was asleep and delegated decisions to the supervising session (2026-11-26); each took the recommended option.

1. **The gaps above were decided by the shared rule, without the owner marking the sheets.** The sheets before and after are published as a private artifact for the owner's review (link in the hand-over, never here).
2. **Two gaps change an API, so they are left:** a visible label on `FoxSwitch` (the screens draw the setting's line around the bare track, as the D.8 sheet's `switchLine` does) and an `enabled` on `FoxRadioGroup`. Both are listed for the owner rather than built.
3. **The stepper's count cell is 48 on both sides** (`space.2xl`, the web's), not the D.8 sheet's 44: no token states 44, and 4 pixels did not justify a new size.
4. **Tokens a side reads elsewhere are marked one-sided:** `input.color.focus-ring` is web only in the usage check, since Flutter paints every ring in the shared `FocusRing` (`internal/interaction.dart`, outside this slice) from `theme.input.focusRing`; `input.compact.*` and `input.switch.gap` are web only (no compact density, no switch label in Flutter).
5. **The parity harness changed (`test/parity/parity.dart`, outside the plan's list):** an `Overlay` above the frame (a focused text field needs one) and, for `-focus`, the first `EditableText`'s node when no `Focus` sits above the first `GestureDetector`. Without them no text field could be shot focused.
6. **Two locked tests were corrected, not weakened:** the search field's clear-button test used `defaultValue`, which does not show the button (it now types, as the existing clear test does); the stepper's width test measured the stretched widget, not its row of three cells. Two older tests followed the change: `text-link.test.tsx` (the class names of the new tokens) and `frame_parts_review_test.dart` (the ring is now a `FocusRing` painter, still keyboard only).

## Stopped at

Built, web and Flutter green; checks and the images next.

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
