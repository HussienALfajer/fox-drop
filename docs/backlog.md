# Backlog

Open items that outlive a slice: decisions waiting for the owner, non-blocking review findings and small follow-ups. Each item names its source; remove it when done. Status lives in [`roadmap.md`](roadmap.md), a slice's own hand-over in its file in [`slices/`](slices/README.md), and the open items of the specs in [`open-questions.md`](open-questions.md).

For slices before 2026-11-23, what each left (before deploying, to check on staging, decided by us, not yet) stays in its section of the archive [`slice-notes.md`](slice-notes.md); the items below are the ones still waiting.

## Waiting for the owner

- **Codes abroad while App Check is off** (D.11a security review): `otp.number_daily_max_abroad` limits one number, not a script that sends one code to each of many foreign numbers (held only by `otp.ip_hourly_max` and a client-chosen device id) while `otp.app_check_required` is off. Options: refuse numbers abroad until App Check is on, or a global daily cap on codes sent abroad. The apps offer foreign numbers only from D.11's components slice.
- **The address's contact number abroad** (D.11a review): it stays Syrian or Turkish (`syrianOrTurkishPhone`); the owner widened sign-in only (U3). Widen it too? A captain calls it from Syria.

- **A discount above the clearing account** (`test/money-properties`, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- **`FONTS_DEPLOY_KEY`** (D.1): the private half of a read-only deploy key on `fox-drop-fonts`, no expiry, in the repository's Actions secrets (commands in the D.1 pull request thread); the `visual` (D.6) and `golden` (D.7) CI jobs fail without it. Also the meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- **Choices decided by us, to confirm:** D.3, D.4, D.6, D.7 and L.1c, each under «Decided by us» in its section of `slice-notes.md`; D.8 under «Notes for the next session» in [`slices/D.8-inputs-and-forms.md`](slices/D.8-inputs-and-forms.md). D.4: open both design artifacts. D.7: run widgetbook.
- **The icons' orange accent layer** (D.5, «Left from D.5»).
- **Running times in AP §4.7** (D.9 review): the approved sheet shows «4:32» under ten minutes and «12 د» from ten (`formatDuration`, `foxFormatDuration`); AP §4.7 still says «12 د» and «45 ث». The spec's wording waits for the owner.
- **Two plugins off** (archive `claude-code-workflow.md`, phase 3): the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).

## Follow-ups

- **Dart analysis from a cold cache** (the checks' speed-up, 2026-11-25, pull requests 284 to 295): `dart analyze --no-plugins` over `core_ui` and its five dependents takes 12 to 30 s once the analyzer's cache holds the content, but 3 to 7 minutes the first time (a new worktree, a reinstalled SDK, after many merges), and the same one-comment edit took 180 s in one `--changed` run and 30 s in the next. CI's 4-vCPU Linux runner analyzes the whole workspace cold in 42 s; this machine took 221 s. The analyzer's own cache (`%LOCALAPPDATA%\.dartServer\.analysis-driver`) held 322 thousand files, 4.8 GB, the oldest from 2025-12. To find: whether results are lost when the process exits (the `fox_lints` check writes its cache synchronously for that reason) or the cache is keyed by path, and whether the analysis should run through that compiled check.
- **The hooks' and scripts' tests step** (same source): 11 to 17 s in every check (`verify-support.test.mjs` 13 s, `hooks.test.mjs` 9 s, `turbo-inputs.test.mjs` 8 s, `baselines.test.mjs` 6 s, each alone). A pass record can only skip the hooks' and the engine's own tests; the tests that scan the repository must run after any source change, so the gain is 5 to 8 s.
- **Real-time waits left in tests** (same source): `scripts/verify-support.test.mjs` sleeps at lines 126 to 132 and 438; `packages/core_auth/test/session_test.dart` (lines 148 and 161) failed twice under machine load and passed alone.

- **The sign-in hero's keyboard golden at 412** (D.11b checkpoint C review): `frame_golden_test.dart` draws the keyboard-up hero at 360 only; the plan names 360 × 640 and 412 × 915 for every origin and the keyboard. Add the 412 image when D.11 codes the screen.
- **The hero's art in the contrast pairs** (D.11b checkpoint C review): the orange badges and dish circles (`primary` on `primary-subtle`, `info-subtle`, `neutral-subtle`, 2.29 to 2.52) are decoration, read as words, so they have no pair; confirm with the owner or add them under the exception.

- **The selected point in nginx's logs** (D.11a security review): public customer routes take the point in the query string (`GET platform`, `account-state`, browsing, search, favourites, codes, the emergency stop), and nginx's combined log writes the request line with the IP (`infra/nginx/server.conf.template`). A log format without the query string for `/v1`.

- **The registry's widget scan** (D.P1 review): `packages/design-tokens/src/components.test.ts` finds core_ui's widgets by `^class Fox… extends StatelessWidget|StatefulWidget`; a later `final class`, or a widget on another base (an animated widget, a `RenderObjectWidget`), would be skipped without failing. Accept class modifiers and any `…Widget` base, or fail on a `Fox*` widget class the pattern does not recognise (D.P2 or the next slice that unlocks the test).

- **The bridge test stands alone** (D.11 design checkpoint review, round 2): the test «renders through its own React beside a page React 18, and converts nested elements» in `ui-web/test/design-system.test.ts` relies on the test before it having loaded React 18 and the bundle; load both in it (or in a shared `beforeAll`) and cover `DataTable`'s function props (a `cell` returning a page element) beside `Tabs`.
- **A server test under load** (D.11 design checkpoint): `apps/server` `otp-sender.test.ts` «delivers a customer code over WhatsApp…» answered 500 once during a full local `--changed` run and passed alone (35/35); watch it in CI and fix its cause if it repeats.
- **`on-primary-subtle` in REVIEW item 13** (D.9 review; owner, 2026-11-24): the owner accepts it as an orange token (orange 600 on the primary tint; blue for the captain). Add it to item 13's list and to `ORANGE` in `src/contrast.ts` in a pull request of its own.
- **One money format everywhere** (D.9 review): `formatAmount` and `foxFormatAmount` group thousands with a Western comma and use U+2212 (owner, 2026-11-24); `core_l10n` `formatMoney`, the server's `content/push-format.ts` and the panel's and portal's `format.ts` do not yet. Align them when a screen shows both.
- **Fox Lira's licence in the apps** (D.9 review): each Flutter app adds the OFL text (`core_ui/assets/fonts/fox-lira/OFL.txt`) to `LicenseRegistry`, and each web app ships `ui-web/fonts/fox-lira` with its OFL, in its screen slice. The Design System bundle does not carry the font, so its previews draw the ₺ in the system font.
- **A late card's pressed state** (D.9 review): a pressable `FoxCard` or `Card` with the danger tone keeps its tint under the pointer and press; R10 has no danger-tint step yet.
- **Photo ratios as tokens** (D.9 review): `--aspect-cover` and `--aspect-dish` in `ui-web/src/styles.css` and `foxFadedOpacity` in `core_ui` are literals beside the tokens.

- **L.1c's two-session measurement** (formerly in `TASKS.md`): record what the two-session slice cost, measured with `scripts/claude-audit.mjs`, in the evidence of the slice that measures it, now that `docs/archive/claude-code-workflow.md` is read-only; it is the baseline for the item below.
- **Claude Code workflow, measure after a month** (2026-11-23, `chore/shifa-workflow`): cost and speed of slices under the new workflow with `scripts/claude-audit.mjs`, against L.1a, L.1b and L.1c in the archive `claude-code-workflow.md` (phase 6).
