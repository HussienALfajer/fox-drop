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

## Design (checkpoint 0, awaiting the owner)

Sheet «Data display — batch 3» (`packages/design-tokens/src/data-sheet.ts`, board `Data.dc.html` on the Component proposals canvas, drawn by `pnpm --filter @fox-drop/design-tokens icon-sheet --config <file>`). The Figma API was rate limited (429), so the look used the renders of 2026-11-23 (home 49:2041, dish 49:1765, cart 49:1557, components page). Taken from the file: the cart's summary with dashed rules and the orange total bar, the offset shadow under customer cards, the outlined item cards, the dish block with an icon panel (offered as option B), the rating with a star, the chips of the dish page.

Drawn, with the options the owner decides:

1. **Money:** one isolated RTL run, amount then symbol (the symbol sits to the amount's left, as in the file), Western tabular digits, a whole amount drops its fraction; sizes secondary 14 to number 30 (captain 36); − reads first; a zero fee is «مجاني». The ₺: (A, ours) a 1 KB Noto Sans subset holding U+20BA bundled beside CoFo, (B) the platform's font, (C) «TL». Thousands: (ours) a Western comma, or none (today's `core_l10n` and pushes).
2. **Status chip:** the nine AP §8.1 states, icon and word with every colour; (A, ours) tint behind dark text, (B) solid, (C) dot. Tones: placed warning, accepted info, ready and delivered success, picked up and arrived primary, rejected and failed danger, cancelled neutral. New tokens `*-subtle` (proposed hexes in the sheet, text 4.6:1 to 8.7:1).
3. **Count badge:** dot, count, 99+; the restaurant's column tabs with count and late count.
4. **Card shell:** outline, soft elevation, offset shadow; ours: offset in the customer app, outline elsewhere; R10 states when tappable.
5. **List row**, **timer** (mm:ss under 10 min, «12 د» above; calm, soon, late counting up; the captain's 45 s offer ring), **order card** (restaurant board card per RA §8.2, late red; customer «طلباتي» row per CU §12.3).
6. **Amounts summary** (CU §10.2): (A, ours for the customer cart) the orange total bar, (B, elsewhere) a bold total under a rule; equivalents per currency under it.
7. **Restaurant card** (CU §8.2) and **dish card** (CU §9.3): (A, ours) a row with a 1:1 photo and «+», (B) the file's icon-panel block. Missing photos per brand expression §5.
8. **Skeleton:** (A, ours) calm pulse, (B) shimmer; still under reduced motion. **Empty and error states** in the drop frame (icon until the fox scenes exist). **Data table** (web, compact 40).

## Stopped at

Checkpoint 0: the sheet is published; waiting for the owner's approval and choices.

## Evidence

<filled when the slice's pull request is opened>

## Before deploying

Nothing: components only.

## To check on staging

Nothing new.

## Notes for the next session

After D.9: D.10 Overlays and navigation, then the screens' slice plans (`docs/roadmap.md`). Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 to L.11.
