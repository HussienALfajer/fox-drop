# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 2 of `docs/claude-code-workflow.md`: fast checks. Planned, not started. Phase 1 (the context diet) merged with `chore/claude-context-diet`.

- **Branch:** `chore/fast-verify`.
- **Why:** the `checker` ran the full `pnpm verify` 305 times (median 3.7 min, p90 9.5 min, 25.6 h in all) with every Turborepo cache off; CI's `verify` runs the same set in 4–5 min.

### Plan

- [ ] Move the path classification of CI's `changes` job into one script that `ci.yml` and `verify.mjs` share.
- [ ] `node scripts/verify.mjs --changed`: only the parts the branch's changes need (Markdown only: Prettier on the changed files and the size check; TypeScript: `turbo --affected`; Dart: Melos `--diff`; the API contract only after a route or schema change); the `checker` runs it by default.
- [ ] Turborepo cache for `lint` and `typecheck` only.
- [ ] Measure: a Markdown-only change, a server change and a Flutter change, before and after.

## Next

Launch readiness (`docs/roadmap.md`, after Phase 2): not split into slices yet. Planned, not started.

- **Roadmap line:** Launch readiness: captain simulator load test, real-device lab, staging rehearsal (architecture §18).
- **Specs:** architecture §18 (18-testing-and-quality.md), §17 (environments, the production deploy), §22 (risks and open items: the paid licences, item 8; App Check from Azaz, item 9); the four definitions of done (AP §19, RA, CA, CU `19-definition-of-done.md`).
- **Branch:** to name per slice once split.
- **First:** run the `slice-plan` skill on it and get the owner's approval of the split; ask the owner who tests on which real phones (Android and, through TestFlight, iPhones), when the staging rehearsal runs, and the production environment's hosting and accounts (a production deploy is the owner's to approve).
