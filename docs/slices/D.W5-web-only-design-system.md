# D.W5 The Design System shows web components only; the web-first rule

Status: Planned · Tier: T2 · Branch: `docs/web-first-design-system`
Spec: architecture §9.1, §9.7, §9.8, §9.9 · Definition of done: workflow §4

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Last: needs every D.W3 and D.W4 slice merged, so no component leaves the Design System before its web version is in it.

## Goal

The Fox Drop Design System shows only the live web components, with no Flutter card; the rule is written where every session reads it: the owner approves a web component (its Design System card) as the drawing, and a Flutter twin needs only its parity sheet.

## Plan

1. Remove the Flutter cards: `packages/core_ui/design-system/cards.json`, the cards golden test and its images (`test/golden/goldens/design-system/`), and the Flutter group of `design-system-build.ts` with its README text and test cases.
2. Record the decision: architecture §2 gets T14 (owner, 2026-11-26: web first, why — the Flutter-in-canvas spike of 2026-11-25 worked only through undocumented behaviour at about 11 MB per canvas; web components are editable on the canvas); §9.1 (a Flutter drawing is the parity sheet), §9.7 (a twin is built when a screen needs it, on the component tokens, with parity cases), §9.8 (the Design System holds web components only), §9.9 (the component cycle: the web component and its card are the drawing; a twin's checkpoint is its parity sheet; screens are drawn with the web components).
3. The process: workflow §3.1 (a batch's web side is the drawing; its Flutter twin is its own slice with a parity sheet, no second sheet), the `build-slice` and `slice-plan` skills' design checkpoint lines, the three packages' `CLAUDE.md`.
4. Sync: rebuild the Design System files (`pnpm --filter @fox-drop/design-tokens design-system`, then the `ui-web` one) and publish them (`packages/design-tokens/CLAUDE.md` «Sync»); the owner opens it and sees no Flutter group.

Files (hand-written count, 15; deletions counted, images apart):

- Removed (2): `packages/core_ui/design-system/cards.json`, `packages/core_ui/test/golden/design_system_cards_test.dart`.
- Design System build (2): `packages/design-tokens/src/design-system-build.ts`, `src/design-system-build.test.ts`.
- Docs and instructions (11): `docs/architecture/02-decisions.md`, `docs/architecture/09-design-system.md`, `docs/process/development-workflow.md`, `.claude/skills/build-slice/SKILL.md`, `.claude/skills/slice-plan/SKILL.md`, `packages/design-tokens/CLAUDE.md`, `packages/ui-web/CLAUDE.md`, `packages/core_ui/CLAUDE.md`, `docs/code/packages/design-tokens.md`, `docs/code/packages/core_ui.md`, `docs/roadmap.md`.

Tests written first (locked in the red phase):

- `src/design-system-build.test.ts`: the built Design System has no `Flutter/` file and no Flutter group; every `ui-web` component in `COMPONENTS` has its card.
- `scripts/classify-changes.test.mjs` stays green with the cards test gone (its golden paths are globbed; checked, not changed).

## Stopped at

Not started.

## Evidence

- `node scripts/verify.mjs --changed`:
- The republished Design System: the owner's look
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

The Design System's link lives in Claude's memory (design artifacts), never in the repository.
