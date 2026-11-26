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

## Gaps on the sheets (before the change)

`pnpm parity Dialog ConfirmDialog Toaster Banner BannerStack Menu Tabs Icon`, with the Flutter cases written first (`overlays_parity_test.dart`) and the web side shooting the open overlay (decision 2). Rule: the D.10 sheet (`src/overlays-sheet.ts`) or the D.8 sheet (`src/forms-sheet.ts`, the select list) wins where it shows the state, else the web.

| #   | Component           | Gap                                                                                                               | Who wins                        | Fix                                                                       |
| --- | ------------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------------------- | ------------------------------------------------------------------------- |
| 1   | Dialog              | Flutter's two actions kept their own width; the web's share the row                                               | D.10 sheet (`flex: 1`) and web  | Flutter: `DialogPanel.fillActions`, `dialog.actions-gap`                  |
| 2   | Dialog              | Flutter put lg before the actions and xs between the title and its ×                                              | Web (one `gap-md`, `gap-sm`)    | Flutter: `dialog.gap` everywhere, `dialog.header-gap`                     |
| 3   | Dialog              | Flutter's × is a 48 button inside the padding; the web's overlaps the padding by xs, so its title sits higher     | Web                             | Left (decision 4)                                                         |
| 4   | ConfirmDialog       | The web greys «تأكيد الإلغاء» until a reason is written (still pressable, to show the error); Flutter does not    | D.10 sheet and web              | Left (decision 5)                                                         |
| 5   | ConfirmDialog       | Flutter's notified chips sm inside, their text plus 8 high                                                        | Web (xs, 24)                    | Flutter: `dialog.confirm.chip-*`                                          |
| 6   | Toaster             | Web: on a 360 screen the toast ran 16 past the start edge (a 360 toast at `end-md`)                               | —                               | Web: the region spans `inset-x-md`, each toast `max-w-(--fd-toast-width)` |
| 7   | Toast               | Flutter's icon xs from its words                                                                                  | Web (sm; the sheet's 10)        | Flutter: `toast.gap`                                                      |
| 8   | Toast               | Flutter's toast is 56 high (its × a 48 target), the web's 48 (a 32 ×)                                             | Web                             | Left (decision 4)                                                         |
| 9   | Toaster             | Flutter shows one toast at a time; the web up to three (`toaster--stacked`)                                       | Web                             | Left: a behaviour of D.10 (phones), not a look                            |
| 10  | Banner              | Flutter 2xs above and below; the web xs (sm with two actions)                                                     | D.10 sheet (8) and web          | Flutter: `banner.padding-block`, sm when stacked                          |
| 11  | Banner              | Flutter: a banner with two actions filled a tall parent (its column was not `min`)                                | —                               | Flutter: `mainAxisSize.min`                                               |
| 12  | BannerStack         | Flutter's counter a 48 pill, outlined when opened too; the web's 32, bare when opened                             | Web                             | Flutter: a 32 pill (`banner.stack.toggle-height`) in a 48 target          |
| 13  | Menu                | Flutter 192 wide                                                                                                  | D.10 sheet (240) and web        | Flutter: `menu.min-width`                                                 |
| 14  | Menu                | Flutter rows: a medium icon, sm padding and gap                                                                   | Web (small icon, xs)            | Flutter: `menu.item-*`, `FoxIconSize.sm`                                  |
| 15  | Menu                | Web rows in regular weight                                                                                        | D.10 sheet (500) and Flutter    | Web: `font-medium`                                                        |
| 16  | Select (open list)  | Flutter: an outline, no inner padding, square rows on `surface-raised-hover`, the choice bold with a medium check | D.8 sheet (`listbox()`) and web | Flutter: `anchored_menu.dart` as the web's list (decision 3)              |
| 17  | Tabs                | Web line 4 high and round                                                                                         | D.10 sheet (3, square)          | Web: `tabs.indicator`                                                     |
| 18  | Tabs                | Web: the selected tab's count blue                                                                                | D.10 sheet (red) and Flutter    | Web: `danger` on the selected tab                                         |
| 19  | Tabs                | Flutter underline tabs touching, md inside, hover tinting the tab, the count 2xs from its label                   | Web (2xs, sm, words, xs)        | Flutter: `tabs.gap`, `padding-inline`, `color.text-hover`, `label-gap`    |
| 20  | Tabs (pill)         | Flutter pills 48 high                                                                                             | D.10 sheet (40)                 | Flutter: a 40 pill (`tabs.pill.height`) in a 48 target                    |
| 21  | Tabs                | The sheet draws an unselected count on `neutral-subtle`; both sides draw it blue                                  | —                               | Left: both sides agree                                                    |
| —   | every overlay, tabs | Flutter has no compact density (the web's `*-compact` stories)                                                    | —                               | Left (as D.W3a)                                                           |
| —   | Icon                | No gap (the web story draws in Storybook's black ink, the component's `currentColor`)                             | —                               | —                                                                         |

## Decisions taken overnight (pending the owner)

The owner was asleep and delegated decisions to the supervising session (2026-11-26); each took the recommended option.

1. **The gaps above were decided by the shared rule, without the owner marking the sheets.** The sheets before and after are left on the host (`.parity/`) for the owner's review.
2. **The parity spec changed (`packages/ui-web/e2e/parity.spec.ts`, outside the plan's list):** an open dialog renders outside the story root, so the web side shot only the trigger under the scrim. It now shoots an open dialog alone, the toasts as their region, and an open menu with its trigger; the Flutter cases draw the same (the panel in the frame; the menu over an `Overlay` of its own).
3. **The Select's open list reads `input`, not `menu.json`.** The plan expected the web select's list to use the menu tokens; it reads `input` (`select/menu.tsx`, D.W3a's). So `anchored_menu.dart` reads the same `input` tokens and takes the web list's look (gap 16); `menu.json` serves the action menu only.
4. **Flutter keeps its 48 targets (R13):** the dialog's × (gap 3) and the toast's × (gap 8) stay 48 inside the panel rather than overlap the padding as the web's pointer targets do; where a pill is drawn smaller (the stack's counter, the pill tabs) it sits inside a 48 target.
5. **Gap 4 changes an API, so it is left:** greying the confirm action while it stays pressable needs a `FoxButton` state that does not exist.
6. **Web-only files** (`blocking-banner`, `tooltip`, `drawer`) declare `"flutter": []` and mark every token `sides: ["web"]`, as D.W3b's `data-table`.
7. **Tests that named the old classes follow the change:** `icon/icon.test.tsx`, `button/button.test.tsx`, `field/field.test.tsx` (`--fd-icon-size-*`) and `test/design-system.test.ts` (`--fd-dialog-width`); `test/icon_test.dart` reads the sizes from the icon tokens (`FoxIconSize.pixels` is gone: no app used it).
8. **The version is 0.17.0:** D.W3b merged first with 0.16.0; main was merged into the branch (force pushes are refused), the outputs regenerated.

## Stopped at

Build done on both sides; checks, images, review and pull request next.

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
