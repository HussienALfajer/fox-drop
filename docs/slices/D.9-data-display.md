# D.9 Data display

Status: Planned · Tier: T2 · Branch: `feat/components-data`
Spec: architecture §9.5 (R1 to R10), §9.7, §9.9 (the component cycle), §9.10; AP §4.7 (formats, digits, money); `docs/domain/` (money in minor units with a currency code, the order states the chip shows); the CU and RA sections on the order card and the restaurant and dish cards · Definition of done: the D.9 line of `docs/roadmap.md` Phase D

## Goal

Money (Western digits, the ₺ fallback, bidi isolation), order status chip, count badge, card, list row, timer and countdown, order card, amounts summary, restaurant and dish cards, skeleton, empty and error states; the data table on the web. Web (`ui-web`) and Flutter (`core_ui`) in one pull request (owner, 2026-11-23), from one sheet the owner approves.

## Plan

0. Design checkpoint: look at the Figma file (`.claude/skills/build-slice/figma-look.mjs`), read the cited sections and write the design here, including its proposals sheet (§9.9 step 1) on the Component proposals canvas, for the owner's approval.
1. Build steps, one commit each (written with the design).
2. Docs (`docs/code/packages/*.md`, folder `CLAUDE.md` rules), mark the sheet superseded; review; hand over to D.10.

Read first: `packages/ui-web/CLAUDE.md`, `packages/core_ui/CLAUDE.md`; grep `docs/code/packages/ui-web.md` and `core_ui.md` for the patterns of D.6 to D.8 (exported states, R10 tokens, RTL and text-scale tests, goldens, the visual gate, the Design System cards).

Built so far: tokens 0.6.0, icons, Button and Icon, and the inputs and forms set ([D.8](D.8-inputs-and-forms.md)) on the web (`ui-web`) and in Flutter (`core_ui`, widgetbook, goldens).

## Stopped at

Not started.

## Evidence

<filled when the slice's pull request is opened>

## Before deploying

Nothing: components only.

## To check on staging

Nothing new.

## Notes for the next session

After D.9: D.10 Overlays and navigation, then the screens' slice plans (`docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 to L.11.
