# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 2 of `docs/claude-code-workflow.md`: fewer requests, smaller results. Planned, not started. Phase 1 (the context diet) merged with `chore/claude-context-diet`; the second audit (2026-11-21) reordered the later phases.

- **Branch:** `chore/fewer-requests`.
- **Why:** 83% of assistant messages hold one tool call and 12,178 of them are a single Bash command (`sed -n`, `grep -n`, `python -`, `git diff`), each a request that resends the whole context.

### Plan

- [ ] Fix the Git Bash profile: the pinned Node on PATH without a prefix, no fnm error on every command, no silent skip after `cd … &&`. Then delete the workaround from the memory notes.
- [ ] A `PreToolUse` hook on Bash, in observe mode first: reading a tracked file with `sed -n`, `cat`, `head` or `tail`, or editing one with `sed -i` or an inline script, is refused with the tool to use instead.
- [ ] Root `CLAUDE.md`: independent tool calls in one message; `git diff --stat` first.
- [ ] A hook that cuts a test command's output to its failures and summary.
- [ ] `scripts/claude-audit.mjs`, the audit as a committed script.
- [ ] `infra/server/check-order-ledger.sql` line 3 still names `ordering/CLAUDE.md` for «The atomic pickup»: point it at `docs/code/apps/server/src/modules/ordering.md` in a pull request that changes code anyway.
- [ ] Measure one slice session against the baseline.

## After that

In the order of `docs/claude-code-workflow.md`: phase 3 (the owner's MCP servers, plugins and skills, with the owner), phase 4 (fast checks, `chore/fast-verify`), phase 5 (CI filters).

## Next

Launch readiness (`docs/roadmap.md`, after Phase 2): not split into slices yet. Planned, not started.

- **Roadmap line:** Launch readiness: captain simulator load test, real-device lab, staging rehearsal (architecture §18).
- **Specs:** architecture §18 (18-testing-and-quality.md), §17 (environments, the production deploy), §22 (risks and open items: the paid licences, item 8; App Check from Azaz, item 9); the four definitions of done (AP §19, RA, CA, CU `19-definition-of-done.md`).
- **Branch:** to name per slice once split.
- **First:** run the `slice-plan` skill on it and get the owner's approval of the split; ask the owner who tests on which real phones (Android and, through TestFlight, iPhones), when the staging rehearsal runs, and the production environment's hosting and accounts (a production deploy is the owner's to approve).
