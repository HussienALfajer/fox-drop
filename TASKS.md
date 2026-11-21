# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

Phase 5 of `docs/claude-code-workflow.md`: CI filters. Planned, not started. Phase 4 (fast checks, `chore/fast-verify`) is done: `scripts/classify-changes.mjs` is the classifier CI and `node scripts/verify.mjs --changed` share, so phase 5 changes its rules and its test, then `ci.yml`.

- **Branch:** `chore/ci-filters`.
- **Docs:** `docs/claude-code-workflow.md`, «Phase 5»; `scripts/classify-changes.mjs` and its test; `.github/workflows/ci.yml`; `renovate.json`.

### Plan

- [ ] Markdown never sets a code, Dart or Flutter job; only `SPEC_FILES_READ_BY_TESTS` count as code, with a test that fails when a test reads a spec file not in the list.
- [ ] Native release builds on a pull request only for a native project, a pubspec or lock file, a package with native code, `.fvmrc` or the workflow, or a label.
- [ ] `verify` requires `android-release`.
- [ ] Cache CocoaPods and the Swift packages in the iOS jobs.
- [ ] A merge of specs or docs alone builds and deploys nothing.
- [ ] Renovate groups GitHub Actions updates weekly.
- [ ] Measure a docs-only and a server-only pull request (done when under 2 and 5 minutes).

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.

## After that

Launch readiness from L.2 (`docs/roadmap.md`); the gap slices L.1a `test/dod-test-gaps`, L.1b `feat/dod-calls-and-notices` and L.1c `feat/dod-offline-browsing` (owner approval 2026-11-21) come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
