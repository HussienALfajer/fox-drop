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
- [ ] Write the rules approved by the owner on 2026-11-21 into §9, and name for each the slice and the lint rule or test that enforces it (`CLAUDE.md`: a rule a machine can check is a test or a lint rule):
  - One source: every colour, length, font, radius, shadow and duration comes from the tokens. Web lint: no arbitrary Tailwind value, no hex, no length in `style`; the Tailwind theme carries semantic tokens only. Flutter lint: no `Color(0x…)`, no number literal in `EdgeInsets`, `SizedBox` gaps or `TextStyle`, no Material or Cupertino widget in an app (only `core_ui`). Screens use the semantic layer only.
  - Components only from the libraries: nothing built inside a screen; a new component goes through the cycle (sheet, approval, code and tests, sync); one API naming scheme; every component in Storybook or widgetbook with all its states.
  - Foundations: 4-point spacing grid, a functional type scale, radius, elevation and motion tokens with reduced motion respected, two densities (comfortable for phones, compact for the panel), web breakpoints and phone safe areas.
  - Accessibility, WCAG 2.2 AA: the contrast test for every pair, 48 dp touch targets, visible focus, never colour alone, a name for every control, layouts intact at 130% text and more; axe on the web, semantics tests in Flutter.
  - Arabic first: start and end only (lint), mirrored directional icons, Western tabular digits for money and timers, bidi isolation of Latin runs, every string in the translation files, a voice and tone guide for Arabic copy.
  - Five states for every screen: loading (skeleton), empty, error, offline, partial.
  - Per surface: customer (appetite and trust, large photos with a fallback for missing or poor ones, fixed aspect ratios), captain (outdoors, one hand, thumb-zone actions, sunlight contrast, glanceable), restaurant (busy kitchen, alerts seen from afar, fewest taps, tablet), panel (dense data, keyboard shortcuts, compact).
  - Icons: one source for web and Flutter, 24-point grid, one stroke, the same caps and joins, a safe area; a test of the rules.
  - Governance: versioned tokens with a changelog and deprecation before removal; on every pull request screenshot comparison on the web, golden tests in Flutter, the RTL gate, the comparison of the built screen with its approved drawing; UI items in `REVIEW.md` for the `reviewer`.
- [ ] Add decision T10 to architecture §2.
- [ ] Add decision T11 to architecture §2 and rewrite §9.2 and §9.3 (owner approval 2026-11-21, as in Shifa ADR-0039): the web headless base is UI SDK (`@ui-sdk/react`, React 19, beta), pinned exactly, imported only by `packages/ui-web` (lint), its agent bridge forbidden (lint), an Arabic RTL gate before the core set, Base UI as the per-component fallback, upgrades as their own pull request. Flutter: no UI SDK; recommended to the owner: Flutter's own widgets layer (Flutter 3.47 moved Material and Cupertino out of the framework into `material_ui` and `cupertino_ui`) with `naked_ui` (headless behaviour widgets, BSD-3-Clause, v1.x; confirm the licence of the pinned version) behind the `core_ui` API, under the same safeguards: exact pin, imported only by `core_ui`, the RTL gate, Flutter's raw widgets as the per-component fallback. Not a styled kit (forui, shadcn_ui, shadcn_flutter): their look fights the FOX DROP identity. Ask the owner to confirm the Flutter choice with the spec.
- [ ] Lift the design stop in `CLAUDE.md` and the roadmap's Phase 0 line; point to Phase D.
- [ ] Owner approval of the spec, then the pull request.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). L.1c was the first trial; record its measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»): the 1 km fit of a kept read, and the rest under «Decided by us».

## After that

Phase D from D.1, then L.2 The permission matrix (branch `test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then the rest of launch readiness from L.3 (`docs/roadmap.md`).

Branches of Phase D: D.1 `chore/brand-assets-and-fonts`, D.2 `feat/design-tokens`, D.3 `feat/design-directions`, D.4 `feat/design-system-project`, D.5 `feat/icon-set`, D.6 `feat/ui-web`, D.7 `feat/core-ui`. Branches of the later slices: L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
