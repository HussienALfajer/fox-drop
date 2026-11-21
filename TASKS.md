# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.1 Brand assets and private fonts (`docs/roadmap.md`, Phase D; architecture §9.3).

- **Branch:** `chore/brand-assets-and-fonts`.
- **Done on the branch:** `docs/brand/` (logo mark, lockups, app icons, the three boards, README of the brand rules); the private repository `HussienALfajer/fox-drop-fonts` (created by the owner, commit `634b087`); `docs/brand/fonts-manifest.json`; `pnpm fonts:fetch` (`scripts/fonts-fetch.mjs`, run end to end once locally: 9 files); `scripts/fonts.test.mjs` (a font file tracked by git fails it; `.fonts/` is ignored), in the `format` part of `pnpm verify`; a CI step in the `format` job that fetches the fonts when `FONTS_REPO_TOKEN` exists.
- **Stopped at:** about to run the checker and the `reviewer`, then open the pull request (it has `## Checks changed`: `ci.yml` and `scripts/verify.mjs`).

### Plan

- [x] Brand files under professional names, README.
- [x] Guard test first, then manifest, fetch script, ignore rule, CI step.
- [ ] `node scripts/verify.mjs --changed`, then the `reviewer`.
- [ ] Pull request; merge when its checks pass.

## Waiting for the owner

- D.1: the `FONTS_REPO_TOKEN` secret (fine-grained token, `Contents: Read-only` on `fox-drop-fonts` only) in the repository's Actions secrets; until then the CI fetch step skips. (The owner confirmed on 2026-11-21 that he holds the right to use every font in the pack, CoFo included, in the apps.) The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

Phase D from D.2 (`feat/design-tokens`), then L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.2 `feat/design-tokens`, D.3 `feat/design-directions`, D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
