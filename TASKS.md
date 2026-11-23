# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.8 Inputs and forms (`docs/roadmap.md` Phase D): text field and its wrapper (label, hint, error), long text, search, phone (+963), sign-in code, select, checkbox, radio, switch, quantity stepper, and the date and time pickers in Flutter; web (`ui-web`) and Flutter (`core_ui`) in one pull request (owner, 2026-11-23), from one sheet the owner approves.

- **Branch:** `feat/components-forms`.
- **Read first:** architecture §9.5 (R1 to R10), §9.7, §9.10; `packages/ui-web/CLAUDE.md`, `packages/core_ui/CLAUDE.md`; grep `docs/code/packages/ui-web.md` and `core_ui.md` for the Button's patterns (exported states, R10 tokens, RTL and text-scale tests, goldens, the visual gate). Specs: architecture §8.3.4 (code), CU §5.2 (phone), AP §4.7 (formats).
- **Built so far:** tokens, icons, Button and Icon on the web (`ui-web`) and in Flutter (`core_ui`, widgetbook, goldens).

### Design

**The drawing of record** is `packages/design-tokens/src/forms-sheet.ts` («Inputs and forms — batch 2», board `Forms.dc.html` on the Component proposals canvas), approved by the owner on 2026-11-23. Build what it draws; read the function of the control at hand, not the whole file. Figma ideas taken: the search pill with the orange lens, the circle and pill pairing, the cart's concave stepper bridge, circles for the code cells.

**Owner decisions (2026-11-23):** focus outline, checked controls, switch, stepper and current code cell in the brand orange `primary` (`#FF6E31`; hover and pressed `primary-hover`, `primary-pressed`), extending the R4 exception to 3:1 control boundaries (2.5:1 on `surface`); the keyboard ring stays the Button's blue `focus-ring` (R10). Phone: one pill, an LTR island inside (+963 or +90 chip with chevron at the left, then the digits), label and error RTL. Code: six 48 circles, LTR, one hidden input under them; on success they fill and fuse for `duration.moment` (still under reduced motion). Switch: classic 52×32 track, off at the start, on slides to the end. Months: Syriac names (كانون الثاني…كانون الأول), week from Saturday, dates `dd/mm/yyyy`, 12-hour «ص/م» typed in boxes (AP §4.7). Flutter select: a menu under the field now; D.10 may switch it to the bottom sheet behind the same API. Single-line fields are pills, long text radius 15; «(اختياري)» marks optional fields (no required star); at quantity 1 the stepper's «−» becomes `delete`.

**Common to every field:** 50 high (40 compact, web only), `surface-raised`, 1 `border-strong` at rest, `border-hover` on hover, 2 `primary` on focus, 2 `danger` invalid (inset, so nothing moves), `disabled`/`on-disabled`. Wrapper: label (secondary, 500) above, hint (caption, muted) or error (caption, `danger`, `error` icon 16) below; the error is the control's description (`aria-describedby` / Flutter semantics). Checkbox (radius 8) and radio are 24 in a 48 target; the whole row with its label is the target.

**Tokens (`packages/design-tokens`, 0.6.0):** `tokens/component/input.json` (heights, padding, radii, border widths 1 and 2, every colour above, the check and switch colours, stepper circle 32); `primary` as a 3:1 boundary on `surface` and `surface-raised` in `src/contrast.ts` with the exception and its floor; icons `chevron-down` and `calendar` (paths in `NEW_ICONS` of the sheet) in `icons/`.

**Web (`packages/ui-web`, on `@ui-sdk/react` pieces `field`, `input`, `textarea`, `otp-input`, `select`, `checkbox`, `radio`, `switch`, `number-input`; Base UI per piece if one fails the RTL gate):** `Field` (wrapper), `TextField`, `TextArea` (counter, 3 to 6 lines), `SearchField` (clear, loading), `PhoneField` (country menu «سوريا +963», «تركيا +90»; value E.164; accepts `09…`/`9…` and `05…`/`5…`, CU §5.2), `CodeField` (paste, autofill `one-time-code`), `Select` (listbox, type-ahead), `Checkbox` (mixed), `RadioGroup`, `Switch`, `QuantityStepper` (min, max, delete at the minimum, announced «الكمية 2» from a label prop). Each with `STATES`, stories, unit tests, the RTL gate (keyboard, axe, 130%), visual baselines, Design System cards.

**Flutter (`packages/core_ui`):** `FoxInputTheme` in `FoxThemeData`; the same set as `Fox*` widgets. Text entry wraps `material_ui`'s `TextField` (selection, IME, paste) themed wholly from the tokens, ripples off (§9.7); new dependency `material_ui` (and `flutter_localizations` for the pickers) in `core_ui` only. Simple controls (checkbox, radio, switch, stepper, code cells' look) on the widgets layer. `FoxDateField` and `FoxTimeField` open `material_ui`'s date picker and input-mode time picker, themed, with a `MaterialLocalizations` override for the Syriac months and Saturday as the first day. Comfortable only. Tests: semantics, RTL, text scale 1.3 and 2.0, states' tokens, keyboard; goldens per theme.

**Left out:** money (D.9), the bottom sheet (D.10), web date pickers, Flutter compact density, dark mode, the apps' wiring.

### Plan

- [x] Split «D.8 onward» into slices with the owner (`slice-plan`): D.8 forms, D.9 data display, D.10 overlays and navigation, one pull request each for both platforms (2026-11-23)
- [x] Look at the Figma file, read the cited sections and write the design here, including its proposals sheet (§9.9 step 1) for the owner's approval
- [x] Tokens 0.6.0 (`input.*`, Dart `FoxInput`, new `size.*`, `border-width.*`, the two icons); the Design System sync moves to the web cards step
- [x] Web: the eleven components, stories, e2e `forms.spec.ts`, visual baselines, Design System cards (one commit)
- [x] Flutter: `FoxInputTheme` and the thirteen widgets plus `FoxRadioGroup`, widgetbook, goldens (one commit)
- [x] Design System sync (tokens 0.6.0 and the web cards)
- [ ] Docs (`docs/code/packages/*.md`, folder `CLAUDE.md` rules), mark the forms sheet superseded; review; hand over to D.9

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; the `visual` (D.6) and `golden` (D.7) CI jobs fail without it. The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- D.3: the choices under «Decided by us» in `docs/slice-notes.md` «Left from D.3».
- D.4: open both artifacts; the choices under «Decided by us» in «Left from D.4».
- D.5: the orange accent layer for icons («Left from D.5»).
- D.6 and D.7: the choices under «Decided by us» in «Left from D.6» and «Left from D.7»; run widgetbook («Left from D.7»).
- Phase 3 of `docs/claude-code-workflow.md`: the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).
- Phase 6 items 1 and 2: record L.1c's two-session measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»).

## After that

D.9 Data display, then D.10 Overlays and navigation, then the screens' slice plans (`docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 to L.11.
