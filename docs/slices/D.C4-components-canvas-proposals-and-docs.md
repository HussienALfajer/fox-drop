# D.C4 The components canvas: the proposals page, the old boards out, decision T15

Status: Done · Tier: T2 · Branch: `docs/components-canvas-proposals`
Spec: architecture §2, §9.8, §9.9 · Definition of done: workflow §4

Part of the components canvas plan; its shared rules are in `D.C1-components-canvas-generator.md`. Last, after D.C3 is merged.

## Goal

"Fox Drop Components" has its two pages only: «مكوّنات فوكس دروب» with the 54 generated boards and the index, and «المكوّنات المقترحة» with a note on the life cycle; the six hand-drawn boards are gone; the rule that the component's board is what the owner approves is written where every session reads it.

## Plan

1. Canvas: the proposals page's note (a component-only proposal is drawn here, coded, then its drawing is deleted and its board is built from the bundle); the six old boards (`Main`, `Buttons`, `States`, `Forms`, `Data`, `Overlays`) removed with `"project/<file>": null` and out of `boards` and `order`. Their approval dates are already in their slice files (D.6 to D.10 and `docs/slice-notes.md`): checked before the delete.
2. Decision **T15** in `docs/architecture/02-decisions.md` (owner, 2026-11-26): the component's board on "Fox Drop Components" is the drawing the owner approves, generated from the bundle after each sync; the canvas's Arabic copy lives in one generator data file, an approved exception to English-only storage; the Design System cards may be simplified later. Amends T14.
3. Architecture §9.8 (the row "Component proposals" becomes "Fox Drop Components": Design canvas, two pages, the generated boards and the proposals, changed by the repository after each sync and by the session with the owner on the proposals page) and §9.9 (the component cycle: the board is the drawing).
4. Instructions: `packages/ui-web/CLAUDE.md` (the web-first line), `packages/design-tokens/CLAUDE.md` «Sync» (after the ui-web sync, rebuild and publish the canvas), workflow §3.1 and the `build-slice` and `slice-plan` skills' design checkpoint lines, `docs/code/packages/ui-web.md`, `docs/roadmap.md`.
5. Publish; the owner sees the two pages and 54 boards.

Files (hand-written count, 10): `docs/architecture/02-decisions.md`, `docs/architecture/09-design-system.md`, `docs/process/development-workflow.md`, `.claude/skills/build-slice/SKILL.md`, `.claude/skills/slice-plan/SKILL.md`, `packages/ui-web/CLAUDE.md`, `packages/design-tokens/CLAUDE.md`, `docs/code/packages/ui-web.md`, this file, `docs/roadmap.md`; `scripts/components-canvas/canvas.ts` for the note and the removal (11).

Tests written first (locked in the red phase): `test/components-canvas.test.ts` — the written `canvas.json` has exactly the two pages, the proposals page holds the note and no board, no board outside `COMPONENTS` and Main.

## Stopped at

Done. After the merge, D.C3 publishes from a tree with both slices (the index is `Main.dc.html`).

## Evidence

- `node scripts/verify.mjs --changed`: «the checks of the change passed» (a first run failed on Prettier of the locked test, formatted, no assertion changed).
- `pnpm baselines`: «no image changed» (340 stories, phone and captain).
- Unit tests: `test/components-canvas.test.ts` 16 of 16 (the new case: the six boards retired, the proposals page holds the note and a live proposal only, the index is `Main.dc.html`).
- `components-canvas`, `--measure`, again, `components-canvas:check`: 42 boards written and checked; published to the canvas with the six old files and `Index.dc.html` removed.
- Review (reviewer, T2, medium): round 1, two should-fix (§9's opening rules and the design-tokens icon sheet still said the old canvas) and two minor (step 3's "card or sheet"; kept entries without a page), all fixed; round 2, none. The icon sheet's retirement went to `docs/backlog.md`.

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

- **Approvals checked before the delete:** `Main` («Icons — batch 1») and `Buttons` in `docs/slice-notes.md` (2026-11-23), `States` there too (system B, 2026-11-24), `Forms` in D.8 (2026-11-23), `Data` in D.9 (2026-11-24), `Overlays` in D.10 (2026-11-24).
- **The index is `Main.dc.html`** (the Design type names the entry so); `Index.dc.html` leaves the canvas with the six retired boards.
- **Proposals kept:** a board on the proposals page that is not retired stays (a component drawn there before it is coded); the plan's "no board" holds for today's canvas, which has none.
- **The note** is a sticky (no `kind`; the Design type's `title1` is for a row of boards).
