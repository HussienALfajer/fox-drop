# D.C3 The components canvas: overlays drawn open in their boards

Status: Planned · Tier: T2 · Branch: `feat/components-canvas-overlays`
Spec: architecture §9.8, §9.9, T14 · Definition of done: workflow §4

Part of the components canvas plan; its shared rules are in `D.C1-components-canvas-generator.md`. After D.C2 is merged.

## Goal

Every overlay's board shows it open inside the board, beside its closed trigger, still working in Play, instead of hiding the open view behind a switch (Shifa's weak point); with it all 54 components have their board.

## Plan

1. Web: `inline?: boolean` on each popup, as D.C1's `Dialog` does (the UI SDK content's `inline`, beside the page: `modal: false`, no outside-press close, no initial focus, the scrim inside the frame; an alert dialog is always modal, so inline it takes the plain dialog's parts): `ConfirmDialog`, `BlockingBanner` (moved here from D.C2: it covers the page), `Drawer`, `Menu`, `Select`, `Tooltip`, `CountrySheet`, the `DateField` and `TimeField` pickers, `PhoneField`'s country sheet, `Sidebar`'s drawer; `Toaster` shows seeded toasts in place (its toast container or a part exposed on `FoxDrop.Toaster`, decided by reading the SDK's `toast-parts` first). Types in `scripts/docs.ts`.
2. Generator: the open states of these components drawn with `open` and `inline`; their Arabic copy in `copy-ar.ts`.
3. The test widens to every entry of `COMPONENTS`.
4. Re-sync the Design System (the components changed), write, measure, write, check (0 problems), publish.

Files (hand-written count, about 18): web 12 (`src/{confirm-dialog,drawer,menu,select,tooltip,toaster,country-sheet,date-field,time-field,phone-field,sidebar}/*.tsx`, `scripts/docs.ts`), `test/inline-overlays.test.tsx`, generator 2 (`copy-ar.ts`, `stories.ts`), `test/components-canvas.test.ts`, this file, `docs/code/packages/ui-web.md`, `docs/roadmap.md`. A component whose popup needs a second file (a shared overlay style) is counted when the plan is refined at the start of the build.

Tests written first (locked in the red phase): `test/inline-overlays.test.tsx` — each popup with `inline` and open renders inside its container, not at `document.body`, and keeps its name and role; `test/components-canvas.test.ts` — all 54 components have a board, each open state is drawn open.

## Stopped at

Planned.

## Evidence

- `node scripts/verify.mjs --changed`:
- `components-canvas:check`:
- `pnpm baselines` (no look change expected; `inline` defaults off):
- Review:

## Before deploying

Nothing.

## To check on staging

Nothing new.

## Notes for the next session

Findings of 2026-11-27 (the session that built D.C1 and D.C2), read before the plan is refined:

- **Two kinds of popup.** The dialog kind (`ConfirmDialog` and `BlockingBanner` on AlertDialog, `Drawer` and Sidebar's drawer on Dialog) takes the SDK content's `inline`: do as D.C1's `Dialog` (the plain dialog's parts when inline, `modal: false`, `closeOnOutsidePress: false`, `initialFocus: 'none'`, `inlineFrame`, the `inline` variants of `backdrop` and `dialogPanel` in `overlay/styles.ts`). The anchored kind (`Menu`, `Tooltip`, `Select`, `CountrySheet` on Combobox, `DateField` on DatePicker) has no `inline` in the SDK 0.1.0-beta.14 types or docs, only `container` (an element the popup renders into), `open`, `modal` (`'pointer' | boolean`, not Tooltip) and `dismissible`. Spike first: render into a container beside the trigger with `open`, `modal={false}`, `dismissible={false}`, and see whether the positioned popup takes room in its cell (it is placed from the trigger, so it may cover the next row); if not, reserve its height or draw it in flow. The canvas passes only JSON, so `container` is made inside the component (a ref to a box after the trigger), behind the one `inline` prop.
- **TimeField has no popup** (`@ui-sdk/react/time-input` segments only; no `play` story): it leaves `LATER` and gets an ordinary board.
- **Toaster:** the SDK's toast `Region` takes `container`; its stories seed toasts through `useToast` in `play`. Read `toast-parts.d.ts` and decide between a region drawn in place with seeded toasts and a part exposed on `FoxDrop.Toaster`.
- **PhoneField** opens CountrySheet; **Sidebar** opens its Drawer (`portal`/`drawer` states): both follow their popup's choice.
- The generator already draws a story with `play` open (`open: true, inline: true`) when the component declares `inline` in `docs.ts`, and captions it «بالإيماءة في Play» otherwise (`board.ts`); a component that gains `inline` needs its type in `docs.ts` and its prop list in `test/design-system.test.ts`.
- After D.C3 merges, re-sync the Design System once (D.C1's `Dialog` `inline` and these), then republish the canvas with `ds/fox-drop/*` copied from it (`{artifact, path}`), not sent as files.
