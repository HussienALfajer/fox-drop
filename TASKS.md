# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 4 of `docs/claude-code-workflow.md`: fast checks. Planned, not started. It comes before L.2 because every later slice runs the checks many times (the baseline: 25.6 hours of `pnpm verify` in the history).

- **Branch:** `chore/fast-verify` (phase 5, `chore/ci-filters`, may ride with it: they share the classifier).
- **Docs:** `docs/claude-code-workflow.md`, «Phase 4» and «Phase 5»; `scripts/verify.mjs`; `.github/workflows/ci.yml`; `.claude/agents/checker.md`.

### Plan

- [ ] One script classifies a change's paths; `ci.yml` and `verify.mjs` share it, with its test.
- [ ] `node scripts/verify.mjs --changed`, the `checker`'s default: Markdown only, Prettier on the changed files and the size check; TypeScript, `turbo --affected` and the server's `vitest run --changed origin/main` with the migrations, fixtures and the spec files tests read as `forceRerunTriggers`; Dart, Melos `--diff`; the API contract only after a route or schema change.
- [ ] Turborepo cache for `lint` and `typecheck` only.
- [ ] A `Stop` hook that runs the fast check when a turn ends with code changes and prints only failures.
- [ ] Measure a Markdown-only change, a one-module server change and a Flutter change, before and after (done when the one-module server change checks in under a minute).

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: applied on 2026-11-21 except what only the app's settings can turn off (the `marketing` and `social-media-skills` plugins). Its "done when" (under 45K tokens at the start, no MCP delta) is to check with `/context` in a new session.

## After that

Phase 5 (CI filters) if it did not ride with phase 4. Then launch readiness from L.2 (`docs/roadmap.md`); the gap slices L.1a `test/dod-test-gaps`, L.1b `feat/dod-calls-and-notices` and L.1c `feat/dod-offline-browsing` (owner approval 2026-11-21) come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
