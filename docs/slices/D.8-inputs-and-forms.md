# D.8 Inputs and forms

Status: In progress · Tier: T2 · Branch: `feat/components-forms`
Spec: architecture §9.5 (R1 to R10), §9.6, §9.7, §9.9 (the component cycle), §9.10; the spec lines that use each control: sign-in (architecture §8.3.4), the customer's item options and cart (CU), the restaurant's open switch (RA), the panel's forms (AP) · Definition of done: the D.8 line of `docs/roadmap.md` Phase D

## Goal

Text field and its wrapper (label, hint, error), long text, search, phone (+963), sign-in code, select, checkbox, radio, switch, quantity stepper, and the date and time pickers in Flutter; web (`ui-web`) and Flutter (`core_ui`) in one pull request (owner, 2026-11-23), from one sheet the owner approves. The owner sees them in Storybook and widgetbook.

## Plan

Written before 2026-11-23 in `TASKS.md` on the slice's branch, which the build session follows; that branch's final handover moves here when it merges.

- [x] Split «D.8 onward» into slices with the owner: D.8 forms, D.9 data display, D.10 overlays and navigation, one pull request each for both platforms (2026-11-23).
- [ ] Look at the Figma file, read the cited sections and write the design, including its proposals sheet (§9.9 step 1) for the owner's approval. The owner's analysis page of 2026-11-23 (link in Claude's memory, not here) lists what the file holds: the search pill, the focused and error inputs, the quantity stepper with its concave bridge, the circle and pill pairing.
- [ ] The rest of the plan, written in the design step.

Read first: `docs/brand/directions.md`; `docs/slice-notes.md` «Left from D.7» and «Left from D.6»; `packages/ui-web/CLAUDE.md` and `packages/core_ui/CLAUDE.md`; grep `docs/code/packages/ui-web.md` and `docs/code/packages/core_ui.md` for the Button and the patterns every component repeats (states exported for R3, R10 hover and pressed tokens, RTL and text-scale tests, goldens and the visual gate).

Built so far: tokens 0.5.0 (`packages/design-tokens`, `core_tokens`), the icon set, the Button and Icon on the web (`ui-web`, Storybook, synced into the Design System) and in Flutter (`core_ui`, widgetbook, goldens in Docker, `fox_lints`).

## Stopped at

Being built on `feat/components-forms` in the main checkout (2026-11-23).

## Evidence

<filled when the slice's pull request is opened>

## Before deploying

Nothing: components only.

## To check on staging

Nothing new.

## Notes for the next session

The workflow changed while D.8 was being built (`chore/shifa-workflow`, 2026-11-23). On `feat/components-forms`: merging `main` gives a modify/delete conflict on `TASKS.md`; resolve it by deleting `TASKS.md` and moving its hand-over here (Stopped at, Evidence, Before deploying, To check on staging). `docs/slice-notes.md` is now a read-only archive and the edit guard refuses changes to it, so D.8's hand-over goes into this file, and open items into `docs/backlog.md`. D.8 merges with squash like every pull request.

After D.8: D.9 Data display, then D.10 Overlays and navigation, then the screens' slice plans (`docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 to L.11.
