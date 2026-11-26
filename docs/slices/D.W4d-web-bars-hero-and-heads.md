# D.W4d Web versions: restaurant bar, bottom navigation, sign-in hero and blocking heads

Status: Done · Tier: T2 · Branch: `feat/web-bars-hero-heads`
Spec: architecture §9.5 R1, R3, R4, R5, R7, R9, R16, §9.6, §9.9; CU §4 (the blocking screens), CU §5.1 (the sign-in hero); D.10 and D.11b's slice files for the approved looks · Definition of done: workflow §4 (UI items)

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Needs D.W1 and D.W2 merged. Runs in parallel with any other D.W3 or D.W4 slice.

## Goal

`ui-web` has RestaurantBar, BottomNavigation (the Figma file's floating bar), SignInHero and the two blocking heads (VersionTicket and ShopSign, one `blocking-heads` folder and one Design System card, as in Flutter), matching the approved Flutter twins, in Storybook and the Design System; and the twins TopBar and NavigationRail (`Sidebar` on the web), whose Flutter files hold the bar and the bottom navigation, move onto component tokens with them.

## Plan

1. Tokens: `restaurant-bar.json`, `bottom-navigation.json`, `sign-in-hero.json`, `blocking-heads.json` from the Flutter twins' current values, and `top-bar.json`, `navigation-rail.json` (web folder `sidebar`) for the two twins; each declares both folders.
2. Web: the new components with stories for every state of their Flutter cards (the bar's status pill and connection states; the bottom navigation's selected tab Bold and its outline; the hero by where the guest came from: saved cart, checkout, orders, account; the version ticket and the shop sign with the return time), the Design System files and the bundle entries; `top-bar.tsx` and `sidebar.tsx` read their tokens.
3. Design checkpoint (new rule, owner 2026-11-26): `pnpm parity RestaurantBar BottomNavigation SignInHero BlockingHeads TopBar Sidebar`; the owner approves the new web components and marks the twins' gaps (shared rule).
4. Flutter: `fox_top_bar.dart`, `fox_navigation.dart`, `fox_sign_in_hero.dart` and `fox_blocking_heads.dart` read the same tokens; goldens move only for an agreed gap; parity cases for every story.

Files (hand-written count, 40; the owner allowed about 40 for this plan):

- Tokens (8): `packages/design-tokens/tokens/component/restaurant-bar.json`, `bottom-navigation.json`, `sign-in-hero.json`, `blocking-heads.json`, `top-bar.json`, `navigation-rail.json` (new), `CHANGELOG.md`, `package.json`.
- Web (24), under `packages/ui-web/`: for each of `restaurant-bar`, `bottom-navigation`, `sign-in-hero`, `blocking-heads`: `src/<name>/<name>.tsx`, `<name>.stories.tsx`, `design-system/<Name>/README.md`, `preview.html` (new) (16); `src/bars-hero-review.test.tsx` (new), `src/top-bar/top-bar.tsx`, `src/sidebar/sidebar.tsx`, `src/index.ts`, `scripts/bundle.ts`, `scripts/bundle-entry.ts`, `scripts/docs.ts`, `test/stories.test.ts`.
- Flutter (5), under `packages/core_ui/`: `lib/src/top_bar/fox_top_bar.dart`, `navigation/fox_navigation.dart`, `sign_in_hero/fox_sign_in_hero.dart`, `blocking_heads/fox_blocking_heads.dart`; `test/parity/bars_hero_parity_test.dart` (new).
- Docs (3): `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`, `docs/roadmap.md` (and this file).

Not touched: `drawer/`, `count-badge/`, `icon/` and their Flutter twins (D.W3b, D.W3c; imported, not edited); `pull_to_refresh/` (D.W4c).

Tests written first (locked in the red phase):

- `src/bars-hero-review.test.tsx`: the bottom navigation is a `nav` with one `aria-current` item, a name for each icon-only item and arrow keys in RTL; the restaurant bar reads its status and connection, never colour alone; the hero's title per origin; the heads read their message and the return time in Western digits.
- `test/stories.test.ts`: the four new titles present.
- The six token files with their `$extensions`: `component-usage.test.ts` fails until both sides read every token.
- New screenshots for every story; Flutter goldens move only for an agreed gap.

## Decisions taken overnight (pending the owner)

The owner was asleep and delegated decisions to the supervising session (2026-11-26); each took the recommended option.

1. **The design checkpoint was not held separately.** The web components were drawn after their approved Flutter twins (D.10, D.11, D.11b), built, and their sheets made together with the Flutter cases; the sheets are left on the host (`.parity/`) for the owner's approval, which stays pending.
2. **The selected bottom tab stays Linear**, as the Flutter twin and the owner's rule of 2026-11-25 («the larger circle alone marks it»); the plan's «selected tab Bold» predates that rule.
3. **The top bar and the sidebar are twins by name only.** The web `TopBar` and `Sidebar` are the panel's and portal's (AP §7.1, §7.2); the Flutter `FoxTopBar` and `FoxNavigationRail` are the phone bar and the restaurant's tablet rail (D.10). Their differences (the bar's gap and ground, the rail's 88 width and its icon-over-name items) are by design, not parity gaps: `top-bar.json` and `navigation-rail.json` share what both draw (height, inline padding, ground, hairline, item colours) and mark the rest `sides`. Their parity cases pair each panel story with the closest phone or tablet state; `topbar--emergency`, `sidebar--portal` and `sidebar--drawer` have no twin.
4. **The blocking heads have one folder, one Storybook title (`BlockingHeads`) and one Design System card**, as the plan says, with `VersionTicket` and `ShopSign` exported from the index. So `test/stories.test.ts` maps the two names to `blocking-heads` (`FOLDERS`), the module's `STATES` are `versionTicket`, `shopSign`, `shopSignReturnTime`, and the bundle exposes `FoxDrop.BlockingHeads` (drawing nothing) with the two heads as parts.
5. **The hero's tracking steps are a slot** (`origin.steps`): the web `TrackingSteps` came with D.W4b, which merged while this slice was built; the orders story uses it.
6. **Semantic tokens of the same value are reused** (as D.W3c): `bottom-navigation.item-size-selected` is `size.list-row` (56), `blocking-heads.sign.width` `size.menu-min-width` (192), `sign.strings-height` `size.control-compact` (40). A later retune of those semantic tokens moves these too.
7. **Parity gaps left, none fixed** (no golden or existing screenshot moves): the web perforation is the browser's dashed border (Flutter draws 4-and-4 dashes; `ticket.dash` is Flutter only), and the web cut-outs need `ticket.cut-offset`; the web sign's strings start about 2 px higher (`sign.strings-lift`, Flutter lifts by half the nail in a transform); at the parity width the Flutter restaurant bar wraps a long name on two lines where the web truncates it on one; the bottom navigation's count badge sits on the right corner on the web, the left in Flutter (a `CountBadge` placement gap outside this slice's files: `docs/backlog.md`); the ticket's required version looks heavier on the web (the `number` role's rendering, both sides read the same token).
8. **The bottom navigation's focus ring is left as the approved twin draws it** (review, round 2): `color.focus` is `on-accent` (white) inside the item's circle, plain on the orange current tab but barely visible on an ivory tab (about 1.1:1 to the circle; its outer edge meets the blue outline). Changing it is a design choice for the owner (a `focus-ring` or `accent` ring on an unselected tab, one more token, the Focus images on both sides move): `docs/backlog.md`. The Focus story now shows that case (the second tab current).
9. **One locked test was corrected, not weakened:** `test/stories.test.ts` listed `RestaurantBar` before `RadioGroup`, against the sorted order it compares; and it took D.W4b's `TrackingSteps` when main was merged.

## Stopped at

Built and checked; pull request next.

## Evidence

- Red phase: `bars-hero-review.test.tsx` failed on the missing modules, `stories.test.ts` on the five missing components, `component-usage.test.ts` on every token of the six new files unread on both sides.
- `pnpm parity RestaurantBar BottomNavigation SignInHero BlockingHeads TopBar Sidebar`: six sheets, 44 web shots and the Flutter cases, all passed; the new components match their twins but for the gaps in decision 7. Approval: delegated overnight, pending the owner.
- `node scripts/verify.mjs --changed`: «the checks of the change passed» (Prettier, Turborepo lint, types, build and smoke over 7 packages, tests, Dart analyze, `fox_lints rules`, Dart format, Dart and Flutter tests of 7 packages; server tests skipped, no change they read).
- `pnpm baselines`: «passed in 4 min 10 s»; 30 new screenshots (the four new components' stories on phone and captain), no existing screenshot and no core_ui golden moved.
- Review (T2, `reviewer`, two rounds): round 1 found no blocker; one should-fix (the hero's orange icon pairs missing from `contrast.ts`) was withdrawn in round 2, since `contrast.ts` already records the hero's art as decoration (D.11b); three minor fixed (the hero resets what it shows when its words change; the Hover and Focus stories make the second tab current, so the hover look is shot; the status line). Round 2 found one should-fix that is the owner's design choice (decision 8, backlog).

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

Gaps and choices: «Decisions taken overnight». The web components' sheets wait for the owner's approval; the count badge's corner is a backlog item.
