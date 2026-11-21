# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.0 Design system spec and decision (`docs/roadmap.md`, Phase D): docs only.

- **Branch:** `docs/design-system-spec`.
- **Read first:** the Phase D block of `docs/roadmap.md` (the owner's decisions of 2026-11-21); architecture §9 and §2; the Shifa project's method, read only what is needed: `D:\shifa\docs\adr\0040-design-first-in-claude-design-code-as-source.md` and the "Design workflow" part of `D:\shifa\docs\architecture\design-system.md` (grep, do not read whole).
- **Inputs outside the repository:** the brand pack `C:\Users\OMEN\Desktop\حزمة الهوية البصرية (2).zip` (its `ارشادات اساسية.txt` and the boards `Logo Guidline-01..03.jpg`); Figma file key `lkeZAwDmzNcJDqzScXtDtp` (pages Colors, Typography, Components; a mood board without variables, screens imported as flat vectors). Do not commit links to private artifacts.
- **Findings of the analysis (2026-11-21):** contrast on ivory: orange 2.68, white on orange 2.79 (both fail), blue 9.27; the Figma screens use Arabic-Indic digits in one sample (AP §4.7 says Western); CoFo is "All rights reserved" with fsType 4; the guidelines name HTQaysSansPro, which is not in the pack (Emad-Diana is).

### Plan

- [ ] Rewrite architecture §9: the method (code is the source, the Claude design project mirrors it, design before code with the owner's approval), the token layers (primitive, semantic, component; brand colours and the accessible orange; a dark mode slot), typography (CoFo for the UI, YR-Speed for display, Emad-Diana secondary; Western tabular digits), the own hand-drawn line icon set (grid, stroke, corners), the parts of the design project (Fox Drop Design System, Fox Drop Guide, component proposals, screens per app), the component and screen cycles, what a drawing does not decide (behaviour is proven by tests; Flutter drawings are a visual reference checked by golden tests), and the fonts kept outside the repository.
- [ ] Add decision T10 to architecture §2.
- [ ] Lift the design stop in `CLAUDE.md` and the roadmap's Phase 0 line; point to Phase D.
- [ ] Owner approval of the spec, then the pull request.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

Phase D from D.1, then L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.1 `chore/brand-assets-and-fonts`, D.2 `feat/design-tokens`, D.3 `feat/design-directions`, D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
