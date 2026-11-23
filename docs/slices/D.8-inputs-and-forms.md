# D.8 Inputs and forms

Status: Done · Tier: T2 · Branch: `feat/components-forms` (PR 261, merged 2026-11-23)
Spec: architecture §9.5 (R1 to R10), §9.6, §9.7, §9.9 (the component cycle), §9.10; the spec lines that use each control: sign-in (architecture §8.3.4), the customer's item options and cart (CU), the restaurant's open switch (RA), the panel's forms (AP) · Definition of done: the D.8 line of `docs/roadmap.md` Phase D

## Goal

Text field and its wrapper (label, hint, error), long text, search, phone (+963), sign-in code, select, checkbox, radio, switch, quantity stepper, and the date and time pickers in Flutter; web (`ui-web`) and Flutter (`core_ui`) in one pull request (owner, 2026-11-23), from one sheet the owner approves. The owner sees them in Storybook and widgetbook.

## Plan

Built under the earlier two-session workflow, with its plan in `TASKS.md` on the slice's branch; the hand-over below moved here when the workflow changed (`chore/shifa-workflow`).

## Stopped at

Done: merged in PR 261 (2026-11-23).

## Evidence

The pull request's test plan and CI run (PR 261).

## Owner decisions (2026-11-23)

The forms sheet «Inputs and forms — batch 2» (now marked superseded, §9.9 step 4); the orange exception extended to 3:1 non-text elements (focus outlines, checked controls, the switch, the stepper, icons inside controls), then, after the review, orange allowed anywhere, body text, prices, amounts and timers included (owner, in chat on 2026-11-23, knowing such text sits near 2.5:1 against WCAG's 4.5:1). Written in architecture §9.5, decision T12, the brand docs, `packages/design-tokens` and `REVIEW.md` item 13 (now: orange from the orange tokens only, each pair listed in `src/contrast.ts`), named under «Checks changed» in the pull request.

## Before deploying

Nothing: components only. New dependencies: `material_ui` 1.11.1, `intl` 0.20.3 and `flutter_localizations` in `core_ui` only.

## To check on staging

Nothing new. The owner can try Storybook (`pnpm --filter @fox-drop/ui-web storybook`) and widgetbook (`apps/widgetbook`, `flutter run -d windows`): every form control in its states, phone and captain; the Design System (version 10) shows the eleven web cards.

## Notes for the next session

- **Decided by us (to confirm with the owner):** one phone rule on both platforms (`ui-web` `phone.ts`, `core_ui` `foxParsePhone`): a pasted calling code (`+`, `00` or bare) switches the country when the rest is valid for it and is refused otherwise; extra digits are refused, never cut; Arabic-Indic and Persian digits become 0-9. A bare calling code works pasted only, not typed digit by digit. The web QuantityStepper is two buttons (the SDK's NumberInput disables «−» at the minimum, where delete must work); its label is the noun («الكمية») and the count is the value on both platforms. New `FoxRadioGroup` (label, hint, error, one tab stop, arrow keys). `FoxTimeOfDay` is core_ui's own time type. The Syriac months, «ص/م» and the narrow weekday letters live in `core_ui`'s Material localizations (removing the letters shows English initials). `border-pressed` (blue 700) is new for the off switch pressed.
- **Not yet:** Cupertino localizations for the iOS text toolbar (each app adds them); the web date pickers; Flutter compact density; the code field's IME composition on real Android and iOS keyboards (only device testing tells); a story or golden of the code field's current cell after an error (unit test only).
- **Next:** [D.9 Data display](D.9-data-display.md).
