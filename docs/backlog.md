# Backlog

Open items that outlive a slice: decisions waiting for the owner, non-blocking review findings and small follow-ups. Each item names its source; remove it when done. Status lives in [`roadmap.md`](roadmap.md), a slice's own hand-over in its file in [`slices/`](slices/README.md), and the open items of the specs in [`open-questions.md`](open-questions.md).

For slices before 2026-11-23, what each left (before deploying, to check on staging, decided by us, not yet) stays in its section of the archive [`slice-notes.md`](slice-notes.md); the items below are the ones still waiting.

## Waiting for the owner

- **A discount above the clearing account** (`test/money-properties`, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- **`FONTS_DEPLOY_KEY`** (D.1): the private half of a read-only deploy key on `fox-drop-fonts`, no expiry, in the repository's Actions secrets (commands in the D.1 pull request thread); the `visual` (D.6) and `golden` (D.7) CI jobs fail without it. Also the meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- **Choices decided by us, to confirm:** D.3, D.4, D.6, D.7 and L.1c, each under «Decided by us» in its section of `slice-notes.md`; D.8 under «Notes for the next session» in [`slices/D.8-inputs-and-forms.md`](slices/D.8-inputs-and-forms.md). D.4: open both design artifacts. D.7: run widgetbook.
- **The icons' orange accent layer** (D.5, «Left from D.5»).
- **Two plugins off** (archive `claude-code-workflow.md`, phase 3): the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).

## Follow-ups

- **L.1c's two-session measurement** (formerly in `TASKS.md`): record what the two-session slice cost, measured with `scripts/claude-audit.mjs`, in the evidence of the slice that measures it, now that `docs/archive/claude-code-workflow.md` is read-only; it is the baseline for the item below.
- **Claude Code workflow, measure after a month** (2026-11-23, `chore/shifa-workflow`): cost and speed of slices under the new workflow with `scripts/claude-audit.mjs`, against L.1a, L.1b and L.1c in the archive `claude-code-workflow.md` (phase 6).
