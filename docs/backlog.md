# Backlog

Open items that outlive a slice: decisions waiting for the owner, non-blocking review findings and small follow-ups. Each item names its source; remove it when done. Status lives in [`roadmap.md`](roadmap.md), a slice's own hand-over in its file in [`slices/`](slices/README.md), and the open items of the specs in [`open-questions.md`](open-questions.md).

For slices before 2026-11-23, what each left (before deploying, to check on staging, decided by us, not yet) stays in its section of the archive [`slice-notes.md`](slice-notes.md); the items below are the ones still waiting.

## Waiting for the owner

- **A discount above the clearing account** (`test/money-properties`, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- **`FONTS_DEPLOY_KEY`** (D.1): the private half of a read-only deploy key on `fox-drop-fonts`, no expiry, in the repository's Actions secrets (commands in the D.1 pull request thread); the `visual` (D.6) and `golden` (D.7) CI jobs fail without it. Also the meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- **Choices decided by us, to confirm:** D.3, D.4, D.6, D.7 and L.1c, each under «Decided by us» in its section of `slice-notes.md`; D.8 under «Notes for the next session» in [`slices/D.8-inputs-and-forms.md`](slices/D.8-inputs-and-forms.md). D.4: open both design artifacts. D.7: run widgetbook.
- **The icons' orange accent layer** (D.5, «Left from D.5»).
- **Running times in AP §4.7** (D.9 review): the approved sheet shows «4:32» under ten minutes and «12 د» from ten (`formatDuration`, `foxFormatDuration`); AP §4.7 still says «12 د» and «45 ث». The spec's wording waits for the owner.
- **Two plugins off** (archive `claude-code-workflow.md`, phase 3): the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).

## Follow-ups

- **The bridge test stands alone** (D.11 design checkpoint review, round 2): the test «renders through its own React beside a page React 18, and converts nested elements» in `ui-web/test/design-system.test.ts` relies on the test before it having loaded React 18 and the bundle; load both in it (or in a shared `beforeAll`) and cover `DataTable`'s function props (a `cell` returning a page element) beside `Tabs`.
- **A server test under load** (D.11 design checkpoint): `apps/server` `otp-sender.test.ts` «delivers a customer code over WhatsApp…» answered 500 once during a full local `--changed` run and passed alone (35/35); watch it in CI and fix its cause if it repeats.
- **`on-primary-subtle` in REVIEW item 13** (D.9 review; owner, 2026-11-24): the owner accepts it as an orange token (orange 600 on the primary tint; blue for the captain). Add it to item 13's list and to `ORANGE` in `src/contrast.ts` in a pull request of its own.
- **One money format everywhere** (D.9 review): `formatAmount` and `foxFormatAmount` group thousands with a Western comma and use U+2212 (owner, 2026-11-24); `core_l10n` `formatMoney`, the server's `content/push-format.ts` and the panel's and portal's `format.ts` do not yet. Align them when a screen shows both.
- **Fox Lira's licence in the apps** (D.9 review): each Flutter app adds the OFL text (`core_ui/assets/fonts/fox-lira/OFL.txt`) to `LicenseRegistry`, and each web app ships `ui-web/fonts/fox-lira` with its OFL, in its screen slice. The Design System bundle does not carry the font, so its previews draw the ₺ in the system font.
- **A late card's pressed state** (D.9 review): a pressable `FoxCard` or `Card` with the danger tone keeps its tint under the pointer and press; R10 has no danger-tint step yet.
- **Photo ratios as tokens** (D.9 review): `--aspect-cover` and `--aspect-dish` in `ui-web/src/styles.css` and `foxFadedOpacity` in `core_ui` are literals beside the tokens.

- **L.1c's two-session measurement** (formerly in `TASKS.md`): record what the two-session slice cost, measured with `scripts/claude-audit.mjs`, in the evidence of the slice that measures it, now that `docs/archive/claude-code-workflow.md` is read-only; it is the baseline for the item below.
- **Claude Code workflow, measure after a month** (2026-11-23, `chore/shifa-workflow`): cost and speed of slices under the new workflow with `scripts/claude-audit.mjs`, against L.1a, L.1b and L.1c in the archive `claude-code-workflow.md` (phase 6).
