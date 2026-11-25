# D.W4d Web versions: restaurant bar, bottom navigation, sign-in hero and blocking heads

Status: Planned · Tier: T2 · Branch: `feat/web-bars-hero-heads`
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

## Stopped at

Not started.

## Evidence

- `pnpm parity …`: the sheets shown to the owner and the approval
- `node scripts/verify.mjs --changed`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

<the gaps and the owner's choices>
