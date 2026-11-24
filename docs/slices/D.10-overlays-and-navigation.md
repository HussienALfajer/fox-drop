# D.10 Overlays and navigation

Status: Planned · Tier: T2 · Branch: `feat/components-overlays-navigation`
Spec: architecture §9.5 (R1 to R10), §9.7, §9.9 (the component cycle), §9.10; brand expression §2 (the S-curve tab) and the motion language; AP §7.1 (the sidebar), §7.2 (the top bar), §7.3 (the blocking sound banner), §7.4 (confirmation dialog with reason, money-effect preview and who is notified; side drawers; detail-page tabs), §7.5 (devices), §9.4 (map tooltips); RA §4.7, §6.2 (top bar with status pill and connection dot, phone bottom navigation, the tablet and Windows rail), §6.3 (banners), §7.2 (the status sheet), §17 (the owner web portal); CA §4.6, §6.2, §6.3; CU §6.1 (bottom bar), §6.2 (banners), §8 (pull to refresh), §9 (the item sheet) · Definition of done: the D.10 line of `docs/roadmap.md` Phase D

## Goal

Dialog (with the confirmation form of AP §7.4), toast, alert banner and the banner stack (offline among them), tabs, top bar, menu; on the web the tooltip, the side drawer and the panel and portal sidebar; in Flutter the bottom sheet, the bottom navigation bar, the restaurant's navigation rail and pull to refresh. Web (`ui-web`) and Flutter (`core_ui`) in one pull request, from one sheet the owner approves (owner, 2026-11-24). The owner sees them in Storybook and widgetbook. Wiring them into the apps' routes is each app's screen slice.

**Scope decisions (owner, 2026-11-24):** one slice and one pull request; the restaurant's navigation rail (RA §6.2) and the web side drawer (AP §7.4, and the sidebar's phone form, AP §7.5) are added to the roadmap line; the active-order bar and the floating cart button (CU §6.1, CA §6.2) are built in the customer and captain screen slices, not here.

## Plan

0. Design checkpoint: look at the Figma file (`.claude/skills/build-slice/figma-look.mjs`; its bottom bar component and the customer screens; if rate limited, the renders D.9 used), read the cited sections and write the design here, with its proposals sheet (§9.9 step 1) «Overlays and navigation — batch 4» on the Component proposals canvas, for the owner's approval. The sheet draws, per surface (customer, captain, restaurant, panel):
   - **Dialog:** title, body, one or two actions (the destructive one in danger), the confirmation form of AP §7.4 (reason field, money-effect preview from D.9's amounts summary, the list of who is notified); scrim; Escape and back close it.
   - **Bottom sheet (Flutter):** handle, the S-curve tab for the customer's item sheet and a plain top elsewhere (the restaurant's status sheet), drag to dismiss, max height, safe area; whether D.8's select opens in it on the phone, behind the same API (`docs/code/packages/core_ui.md`).
   - **Side drawer (web):** the panel's quick view from a table, its side in RTL, and the sidebar's phone form.
   - **Toast:** tones (success, info, warning, danger), with or without an action, its place per surface (above the bottom bar on phones, a corner on the web), duration; never the only signal of an AP §7.3 alert.
   - **Alert banner:** the tones the specs name (red, yellow, amber, blue, grey), icon, text, optional action; the offline banner (CA §4.6 text, RA §4.7); the blocking sound banner of AP §7.3; the **banner stack** of RA §6.3 (up to two, the rest behind a counter), in the priority order the app gives.
   - **Menu:** items with icons, a destructive item, a separator; the user menu of AP §7.2 as its example.
   - **Tooltip (web):** on hover and focus, its delay.
   - **Tabs:** per surface, with a count badge (D.9) on a tab, overflow; the restaurant board's column tabs on the phone.
   - **Top bar:** the panel's (AP §7.2 as slots: city selector, platform status, dispatch mode, search, alerts bell with count, approvals badge, user menu), the restaurant's (RA §6.2: name, status pill, connection dot, support button), and the phone apps' back and title bar.
   - **Sidebar (web):** on the start side (AP §7.1), the active item, icons, a collapsed form, a count on an item, the drawer below the tablet width; one component for the panel and the portal.
   - **Bottom navigation (Flutter):** the Figma file's bottom bar, four items (CU §6.1, CA §6.2, RA §6.2), active item, a badge, the thumb zone and safe area.
   - **Navigation rail (Flutter):** RA §6.2 at 840 dp or wider and on Windows, on the start side.
   - **Pull to refresh (Flutter):** the indicator in the brand's colours.
   - Motion: durations and easing from the tokens, still under reduced motion; z-order tokens if the tokens lack them.
1. Build, in two checkpoints, one commit per step, `checker` once at each checkpoint:
   - **Checkpoint A, overlays:** web on `@ui-sdk/react` (`dialog`, `alert-dialog`, `drawer`, `toast`, `menu`, `tooltip`; read each `.d.ts` first); Flutter dialog, bottom sheet, toast, banner and stack, menu in `core_ui` (dialog and bottom sheet may wrap `material_ui`, §9.10, themed wholly from the tokens); stories, widgetbook use cases, Design System cards (group Overlays), goldens and visual baselines.
   - **Checkpoint B, navigation:** web tabs, top bar, sidebar (`tabs`, and `navigation-menu` if it fits); Flutter tabs, top bar, bottom navigation, rail, pull to refresh (may wrap `material_ui`'s `RefreshIndicator`); the same outputs (group Navigation).
2. Docs (`docs/code/packages/*.md`, folder `CLAUDE.md` rules), mark the sheet superseded; review; hand over to the screens' slice plans.

Read first: `packages/ui-web/CLAUDE.md`, `packages/core_ui/CLAUDE.md`; grep `docs/code/packages/ui-web.md` and `core_ui.md` for the patterns of D.6 to D.9 (exported states, R10 tokens, RTL and text-scale tests, goldens, the visual gate, the Design System cards) and for the select's menu.

Tests written first (locked in the red phase), on both platforms unless marked; every component also passes axe (web), RTL and 130% text, and has goldens or visual baselines on phone, captain, restaurant tablet and panel as it applies:

- Dialog: opens with focus inside, traps Tab, Escape (and Android back) closes it, focus returns to the trigger; the confirmation form will not confirm without a reason; the destructive action is not the default focus.
- Bottom sheet (Flutter): opens within the safe area, drag down and the scrim close it, semantics name it; if the select's sheet is approved, the D.8 select tests still pass.
- Side drawer (web): opens from its approved side in RTL, traps focus, Escape closes it.
- Toast: announced in a polite live region (assertive for danger), auto-dismiss paused on hover and focus, its action reachable by keyboard, nothing moves under reduced motion.
- Alert banner and stack: every tone has an icon and text (never colour alone); the stack shows the first two in the given order and a counter of the rest, and the counter opens the rest.
- Menu: arrow keys, Home and End, type-ahead, Escape returns focus, it opens to the correct side in RTL.
- Tooltip (web): shown on focus as on hover; its trigger keeps its own accessible name.
- Tabs: arrow keys follow reading order in RTL, one tab stop, the selected tab announced with its count, overflow scrolls the selected tab into view.
- Top bar: every slot has a name, the alerts count is read with its label, the connection dot has a text equivalent.
- Sidebar (web): links with `aria-current` on the active item, the collapsed form keeps names (through the tooltip), below the breakpoint it opens as the drawer.
- Bottom navigation (Flutter): four items, the selected one announced as selected, 48 dp targets, a badge read with its item, the safe area kept.
- Navigation rail (Flutter): the same items on the start side, keyboard traversal on Windows.
- Pull to refresh (Flutter): the callback runs once per pull, the indicator holds until it completes, a semantics action refreshes without a gesture.

## Design (checkpoint 0, approved 2026-11-24)

**Owner approval (2026-11-24, in comments on the sheet and in chat):**

1. Bottom navigation: exactly the Figma file's floating bar, icons only (B), **in all three apps** (customer, captain, restaurant), the captain's in its own theme. Names live in semantics. Items: the owner asked for the best for a delivery customer; ours, kept: the four of CU §6.1 (home, search, my orders, my account) with the floating cart button (it shows the count and value; search matters with many restaurants; favourites stay under «حسابي»), so the spec does not change.
2. Pull to refresh: (B) the logo's drop filling as you pull, pulsing while it loads, still under reduced motion.
3. D.8's select: (B) stays the menu under the field everywhere.
4. Banners: (A) red solid, the other tones tinted.
5. Tokens 0.8.0 as proposed (caution, scrim, layer.*). 6. Missing icons as proposed; `menu` added. 7. Toast (A) dark blue.


Sheet «Overlays and navigation — batch 4» (`packages/design-tokens/src/overlays-sheet.ts`, board `Overlays.dc.html` on the Component proposals canvas at x 8400, 1680×11300, drawn by `pnpm --filter @fox-drop/design-tokens icon-sheet --config <file>`). The Figma API was rate limited (429), so the look used the renders of 2026-11-23 (home 49:2041, cart, the components page). Taken from the file: the floating blue bottom bar with ivory circles and the orange active circle, the S-curve tab of the dish block (here on the item sheet), the round back button with the orange title, the bell in a round chip with its dot.

Drawn, with the questions the owner decides (the framed option is ours):

1. **Customer bottom navigation:** (A, ours) the file's floating pill with the names under the circles; (B) icons only, as the file. Captain and restaurant: a flat bar on the raised surface, names always.
2. **Pull to refresh:** (A, ours) Material's indicator themed orange; (B) the logo's drop filling.
3. **D.8's select on a phone:** (A, ours) opens as a bottom sheet below 600 dp behind the same API; (B) stays a menu.
4. **Banners:** (A, ours) red solid, the other tones tinted; (B) all tinted; (C) all solid. The stack: two shown, «+N» opens the rest in place.
5. **New tokens 0.8.0:** `color.caution` #5C4A00 on `color.caution-subtle` #FFF5BF (7.8:1) for the yellow tone RA §6.3 and CA §6.3 name; `color.scrim` (neutral 900 at 48%); `layer.*` z-order (sticky 10, banner 20, overlay 30, menu 40, toast 50, tooltip 60, blocking 70).
6. **Missing icons:** the panel opens with the sidebar expanded and modules without a batch-1 icon show a dot until the panel's icon batch; only «menu» (three lines) is added now.
7. **Toast:** (A, ours) dark blue with a tone icon; (B) tinted. «تسجيل الخروج» without an icon until the panel batch.

Also drawn without a question: the dialog (safe action focused first, captain dialog in the thumb zone), the AP §7.4 confirmation form (required reason, money-effect preview from the amounts summary, who is notified; confirm disabled until a reason), the customer item sheet and the restaurant status sheet, the web side drawer from the end side and the sidebar's phone form from the start side, toast places (above the bottom bar; the web's bottom end corner), the offline banners, the blocking sound banner (AP §7.3, `color.alert`), the menu, the tooltip (500 ms on hover, at once on focus), tabs per surface, the top bars (panel slots, restaurant, phone back bar), the sidebar (panel 16 modules, collapsed, portal), the restaurant rail, and the motion table (existing duration and easing tokens; fades under reduced motion).

## Stopped at

Checkpoint 0 approved (2026-11-24). Tokens 0.8.0 (caution, scrim, layer.*, the menu icon) done; next: the red phase of checkpoint A.

## Evidence

- `node scripts/verify.mjs --changed`: <summary line>
- Screenshots or recordings (outside the repository): <where>
- Review: <reviewer findings fixed; deferred to the backlog>

## Before deploying

Nothing: components only.

## To check on staging

Nothing new.

## Notes for the next session

After D.10: the screens' slice plans (`docs/roadmap.md`), then L.2 The permission matrix (see the D.9 slice file's notes). The active-order bar and the floating cart button belong to the customer and captain screen slices (owner, 2026-11-24).
