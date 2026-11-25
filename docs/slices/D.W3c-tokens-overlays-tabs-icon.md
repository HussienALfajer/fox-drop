# D.W3c Component tokens and parity: overlays, tabs and the icon

Status: Planned · Tier: T2 · Branch: `refactor/tokens-overlays`
Spec: architecture §9.2 (the component layer), §9.4, §9.5 R1, R2, R4, R9, §9.9 · Definition of done: workflow §4 (UI items)

Part of the web-first plan (its table and shared rules: `D.W1-component-token-pipeline.md`). Needs D.W1 and D.W2 merged. Runs in parallel with any other D.W3 or D.W4 slice.

## Goal

Every overlay with both versions, the tabs and the icon read their own component-token file on both sides, and their parity sheets are reviewed: Dialog, ConfirmDialog, Toast (`Toaster` on the web), Banner, BannerStack, Menu, Tabs, Icon; the web-only BlockingBanner, Tooltip and Drawer and the shared overlay styles get their files too.

## Plan

0. Design checkpoint: `pnpm parity Dialog ConfirmDialog Toaster Banner BannerStack Menu Tabs Icon` before any change; the owner marks each gap (shared rule: the D.10, D.11b or D.5b sheet wins where it shows the state, else the web).
1. Tokens: one new file per component, each declaring its folders. ConfirmDialog reads `dialog.json` and BannerStack `banner.json` (the same parts); `menu.json` also serves Select's open list (`anchored_menu.dart`), as on the web.
2. Web: each component reads only its tokens, the type roles and the motion tokens; gaps fixed.
3. Flutter: the same through `FoxTheme.of(context).components`; gaps fixed; parity cases for every story.
4. Images: the moved screenshots and goldens in their own commit, each a listed gap fix.

Files (hand-written count, 33; the owner allowed about 40 for this plan):

- Tokens (11): `packages/design-tokens/tokens/component/dialog.json`, `toast.json`, `banner.json`, `blocking-banner.json`, `menu.json`, `tooltip.json`, `drawer.json`, `tabs.json`, `icon.json` (all new; the web-only ones with empty `flutter` folders), `CHANGELOG.md`, `package.json`.
- Web (12), under `packages/ui-web/src/`: `dialog/dialog.tsx`, `confirm-dialog/confirm-dialog.tsx`, `toaster/toaster.tsx`, `banner/banner.tsx`, `banner-stack/banner-stack.tsx`, `blocking-banner/blocking-banner.tsx`, `menu/menu.tsx`, `tooltip/tooltip.tsx`, `drawer/drawer.tsx`, `overlay/styles.ts`, `tabs/tabs.tsx`, `icon/icon.tsx`.
- Flutter (8), under `packages/core_ui/`: `lib/src/dialog/fox_dialog.dart`, `toast/fox_toast.dart`, `banner/fox_banner.dart`, `menu/fox_menu.dart`, `internal/anchored_menu.dart`, `tabs/fox_tabs.dart`, `icon/fox_icon.dart`; `test/parity/overlays_parity_test.dart` (new).
- Docs (2 more): `docs/code/packages/ui-web.md`, `docs/code/packages/core_ui.md`; with this file and `docs/roadmap.md`, 35.

Not touched: `bottom_sheet/` and `blocking_heads/` (D.W4c), `top_bar/`, `navigation/`, `sidebar/`, `top-bar/` (D.W4d), `icon/path_data.dart` (generated icon geometry).

Tests written first (locked in the red phase):

- The nine token files with their `$extensions`, written first: `component-usage.test.ts` fails for every unread token and passes when both sides read all of them.
- A test per agreed gap a test can see, in the component's existing tests (`*.test.tsx`, `src/overlays-review.test.tsx`, `test/overlays_test.dart`, `test/navigation_test.dart`, `test/icon_test.dart`).
- The rest by the screenshots and goldens: an image moves only where a gap was fixed.

## Stopped at

Not started.

## Evidence

- `pnpm parity …` before and after: the sheets shown to the owner
- `node scripts/verify.mjs --changed`:
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

<the gaps found on the sheets, the owner's choice for each, and their fixes>
