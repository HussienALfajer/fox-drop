# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 1 of `docs/claude-code-workflow.md`: the context diet.

- **Branch:** `chore/claude-context-diet`.
- **Why:** sessions spend most of their tokens carrying 941 KB of folder `CLAUDE.md` files and a 413 KB `TASKS.md` (the baseline in that file).

### Plan

- [x] Write `docs/claude-code-workflow.md`; move the earlier handover notes to `docs/slice-notes.md`.
- [ ] Move every folder `CLAUDE.md` over 4 KB unchanged to `docs/code/<folder path>.md`.
- [ ] Write the short folder `CLAUDE.md` files (at most 4 KB, pointing to their `docs/code` file).
- [ ] The size check in `pnpm verify`; the `build-slice`, `reviewer` and root `CLAUDE.md` rules; the `Explore` agent on Haiku.
- [ ] Run the checker and the reviewer, open the pull request and merge it.

## Next

Launch readiness (`docs/roadmap.md`, after Phase 2): not split into slices yet. Planned, not started.

- **Roadmap line:** Launch readiness: captain simulator load test, real-device lab, staging rehearsal (architecture §18).
- **Specs:** architecture §18 (18-testing-and-quality.md), §17 (environments, the production deploy), §22 (risks and open items: the paid licences, item 8; App Check from Azaz, item 9); the four definitions of done (AP §19, RA, CA, CU `19-definition-of-done.md`).
- **Branch:** to name per slice once split.
- **First:** run the `slice-plan` skill on it and get the owner's approval of the split; ask the owner who tests on which real phones (Android and, through TestFlight, iPhones), when the staging rehearsal runs, and the production environment's hosting and accounts (a production deploy is the owner's to approve).
