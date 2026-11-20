# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 2 of `docs/claude-code-workflow.md`: fewer requests, smaller results. Built and merged except the two steps that need later sessions (switching the guard to enforce, measuring a slice). Phase 1 (the context diet) merged with `chore/claude-context-diet`; the second audit (2026-11-21) reordered the later phases.

- **Branch:** `chore/fewer-requests`.
- **Why:** 83% of assistant messages hold one tool call and 12,178 of them are a single Bash command (`sed -n`, `grep -n`, `python -`, `git diff`), each a request that resends the whole context.

### Plan

- [x] Fix the Git Bash profile (`~/.bashrc`, outside the repository): the pinned Node on PATH without a prefix, no fnm cd hook. The memory note is rewritten.
- [x] `.claude/hooks/bash.mjs`, a `PreToolUse` hook on Bash in observe mode: logs to `.claude/bash-guard.log` reads of tracked files with `sed -n`, `cat`, `head` or `tail`, and edits with `sed -i`, `perl -i` or an inline script.
- [x] Root `CLAUDE.md`: independent tool calls in one message; `git diff --stat` first.
- [x] The same hook pipes a command of tests only through `.claude/hooks/test-summary.mjs` (failures and summary, the whole output saved).
- [x] `scripts/claude-audit.mjs`, the audit as a committed script.
- [x] `infra/server/check-order-ledger.sql` points at `docs/code/…/ordering.md` and `ledger.md`.
- [ ] After two sessions: `node scripts/claude-audit.mjs` shows the guard log; check it for false positives, then set `MODE = 'enforce'` in `.claude/hooks/bash.mjs`.
- [ ] Measure one slice session against the baseline: `node scripts/claude-audit.mjs --session=<id>`, single-Bash requests under half of 67.7%.

## After that

In the order of `docs/claude-code-workflow.md`: phase 3 (the owner's MCP servers, plugins and skills, with the owner), phase 4 (fast checks, `chore/fast-verify`), phase 5 (CI filters).

## Next

Launch readiness (`docs/roadmap.md`, after Phase 2): not split into slices yet. Planned, not started.

- **Roadmap line:** Launch readiness: captain simulator load test, real-device lab, staging rehearsal (architecture §18).
- **Specs:** architecture §18 (18-testing-and-quality.md), §17 (environments, the production deploy), §22 (risks and open items: the paid licences, item 8; App Check from Azaz, item 9); the four definitions of done (AP §19, RA, CA, CU `19-definition-of-done.md`).
- **Branch:** to name per slice once split.
- **First:** run the `slice-plan` skill on it and get the owner's approval of the split; ask the owner who tests on which real phones (Android and, through TestFlight, iPhones), when the staging rehearsal runs, and the production environment's hosting and accounts (a production deploy is the owner's to approve).
