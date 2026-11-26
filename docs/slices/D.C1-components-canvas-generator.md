# D.C1 The components canvas: generator, check and five pilot boards

Status: Planned · Tier: T2 · Branch: `feat/components-canvas-generator`
Spec: architecture §9.8, §9.9, T14 · Definition of done: workflow §4; the owner approves the pilot boards' look

Part of the components canvas plan (owner approval 2026-11-26, with every recommendation of the brief): the Design canvas "Component proposals" becomes "Fox Drop Components", one live board per `ui-web` component, generated from the code on the principle of the Shifa project's components canvas (its ADR-0048 and `packages/ui/scripts/design-system/canvas/`, read only). Four slices, T2, one merge at a time since they share the generator: D.C1 (this one), D.C2 the other non-overlay boards and the index, D.C3 the overlays drawn open, D.C4 the proposals page, the old boards out, decision T15 and the docs. Shared rules for the four:

- Every copy is the real component of the Design System bundle (`FoxDrop.<Name>`, `scripts/bundle.ts`), mounted with `<x-import component-from-global-scope>`; nothing drawn by hand. The canvas installs the system under `project/ds/fox-drop/` as the Design System publishes it.
- Board structure, chrome in Arabic: (1) header: name, group, when to use and when not, the code name (`FoxDrop.Button`, English), where it is read (the `$extensions["app.foxdrop"]` readers of its component token files, so a Flutter twin shows); (2) a playground: one live copy, a props panel built from FoxDrop components, the component's stories as scenarios, «إعادة الضبط»; (3) a static surface strip: phone, captain (`data-surface="captain"`), panel (compact where the component has `density`), no toggle; (4) the state matrix, rows = `VARIANTS` (or one), columns = `STATES`, each cell the matching story's args, hover / pressed / keyboard focus forced with the component's own CSS rules; (5) «التشريح والمقاسات» from `packages/design-tokens/tokens/component/`: each part, its size and colour per state, with the token name and its value.
- Axes: surface yes; dark mode no (dark copies light until designed); LTR no (the apps are Arabic only).
- Arabic copy (owner-approved exception to English-only storage): descriptions, headings, group names and captions live in one data file, `scripts/components-canvas/copy-ar.ts`; code, identifiers and component code names stay English.
- Guarantees: the generator rebuilds the whole canvas after each sync; a Playwright check opens every board in every combination (React 18 as the canvas runs it, CoFo from `.fonts/`) and reports errors, missing values, overflow, content taller than its board and the measured heights; a unit test in `pnpm verify` covers boards, holes and copy.
- The canvas's link stays out of the repository (Claude's memory). Publishing as in the brief: read `project/canvas.json` first, republish with `url` and `root` = the generated folder, `ds/fox-drop/*` copied server side from the Design System.

## Goal

The canvas is titled "Fox Drop Components" with its two pages, and its first page holds five live, generated boards (Button, TextField, Dialog, OrderCard, Tabs), each with header, playground, surface strip, state matrix and anatomy, the Dialog drawn open inside its board. The owner opens them in Play and approves the look before D.C2 generalises it.

## Plan

0. Design checkpoint: the five boards published; the owner approves their look (structure, density of the matrix, anatomy) before D.C2.
1. Spike, first: (a) Dialog with `inline` and `open`, mounted through x-import under React 18 (dev dependencies `react-18`, `react-dom-18`, as `test/design-system.test.ts`): open inside its frame, scrim inside the board, focus trapped there, no error; (b) the stories load in Node through Vite's SSR module loader with `storybook/test` aliased to a stub. The result goes under «Notes for the next session» before the generator grows.
2. Web: `src/dialog/dialog.tsx` takes `inline?: boolean` as `BottomSheet` does (content `inline`, `modal: 'trap-focus'`, no outside-press close, the backdrop inside the frame); its type in `scripts/docs.ts`; a unit test.
3. Generator, `packages/ui-web/scripts/components-canvas/`:
   - `stories.ts`: loads each component's CSF module, merges meta and story args, maps `STATES` × `VARIANTS` to stories as `test/stories.test.ts` does, serialises args (React elements as `{ $el, props }` of a FoxDrop component or a tag, functions as no-ops, an element of a story-local component an error naming the story), overrides from `copy-ar.ts`'s neighbour table.
   - `page.ts`: the artboard shell (tokens, bundle, the board's `states.css`, CoFo `@font-face` from the config's blob urls), `Mounts` (props as attributes or `{{ v.pN }}`), escaping.
   - `board.ts`: the five sections; elements rebuilt in `renderVals()` with `window.React.createElement(FoxDrop.X, …)`.
   - `playground.ts`: controls from the props types in `docs.ts` (`typesDoc()`): string-literal unions a choice, `boolean` a Switch, `string` a TextField, `number` numeric; callbacks and `ReactNode` skipped; Tweaks hold the saved defaults; the panel keeps changes in the board's state.
   - `anatomy.ts`: the component token files whose web readers include the component's folder, parts × state suffixes (`-hover`, `-pressed`, `-focus`, `-disabled`), values resolved from `@fox-drop/design-tokens/tokens.css` (light).
   - `states.ts`: Shifa's forced states ported (postcss over `bundle.css`, `data-pseudo`, `-outer`, `-nth`, `-in`), filtered per board to the class names the check recorded on it (the full sheet on the first pass).
   - `copy-ar.ts`: group names, state captions, section headings, each pilot's description and when to use / not.
   - `canvas.ts`: the CLI (`--config <file>` kept outside the repository: the Design System's link, creation time, CoFo blob urls); writes `packages/ui-web/.components-canvas/` (ignored): boards, per-board `states.css`, `canvas.json` (title, pages `components` «مكوّنات فوكس دروب» and `proposals` «المكوّنات المقترحة», the six old boards moved to `proposals` untouched until D.C4, layout by the Design System card groups), the system files copied from `packages/design-tokens/.design-system/system/project/`.
   - `render-board.ts` and `check.ts`: the check, as Shifa's (logic class run, `<sc-if>`, holes, x-import mounted) but with React 18 on the page so the bridge runs as on the canvas; combinations: the playground's defaults, its props changed, every scenario; `--measure` writes `heights.json` and `classes.json` into the output folder.
4. `package.json` scripts `components-canvas` and `components-canvas:check`; `postcss` 8.5.32 pinned (in the lockfile already); `.gitignore` gets `.components-canvas/`; Turborepo inputs if the test reads design-tokens files (`scripts/turbo-inputs.test.mjs` says).
5. Sync and publish: the Design System re-synced (Dialog changed, `packages/design-tokens/CLAUDE.md` «Sync»), then the canvas written, measured, written again, checked, published; opened in the built-in browser.

Files (hand-written count, 21): web 3 (`src/dialog/dialog.tsx`, `src/dialog/dialog.test.tsx`, `scripts/docs.ts`); generator 10 (`scripts/components-canvas/{stories,page,board,playground,anatomy,states,copy-ar,canvas,render-board,check}.ts`); test 1 (`test/components-canvas.test.ts`); config 3 (`packages/ui-web/package.json`, `.gitignore`, `turbo.json` if needed); docs 4 (this file, `docs/code/packages/ui-web.md`, `packages/ui-web/CLAUDE.md` commands, `docs/roadmap.md`).

Tests written first (locked in the red phase):

- `test/components-canvas.test.ts`: each pilot has a board; every `{{ }}` hole of every board resolves (its logic class evaluated in Node with a stub React and `FoxDrop`); every `STATES` entry of a pilot has an Arabic caption and a matrix cell (every `VARIANTS` × `STATES` pair for Button); every pilot has its Arabic description and when to use / not; a board's `states.css` holds only rules whose classes occur on it, under 60 KB; board chrome uses tokens only (no hex colour, no `px` colour literal); `canvas.json` has the title, the two pages and every board on a page.
- `src/dialog/dialog.test.tsx`: with `inline` the open dialog renders inside its container, not in a portal at `document.body`.

## Stopped at

Built: the generator, the check and the five boards written, measured and checked (0 problems in 41 combinations); the unit tests pass. Next: `--changed`, review, publish for the owner's look.

## Evidence

- `node scripts/verify.mjs --changed`:
- `components-canvas:check`:
- Screenshots (outside the repository):
- Review:

## Before deploying

Nothing (design tooling only).

## To check on staging

Nothing new.

## Notes for the next session

- The approved brief is the source for the design; do not re-ask its decisions.
- **Spike (a), open overlay:** Dialog with `open` and `inline` mounted through the bundle under React 18 UMD (the check's page, as the canvas) opens inside its cell with its scrim, beside its closed trigger, with no error; the AlertDialog is always modal, yet the controls around it stay usable (unit test: nothing outside is `inert` or `aria-hidden`). To confirm in Play on the canvas itself.
- **Spike (b), stories in Node:** Vite's `ssrLoadModule` reads every component's module and stories in about 14 s; 53 of 54 at once, DataTable's `selection` (a `Set`) now carried as `{ $set }`.
- **The system's files:** the Design System has `components/bundle.{js,css}` and `tokens.json`, no `tokens.css`: its `bundle.css` carries the `--fd-*` variables (`scripts/bundle.css`), so boards link the bundle only.
- **States sheets:** Shifa's frames multiply each rule about 26 times (962 KB for every rule); the boards use only `data-pseudo-outer`, so a board's sheet keeps that frame and only its own classes: 5 to 13 KB.
- **Copies fill their cell** in the forms, navigation and data groups (a scrolling Tabs row overflowed its cell otherwise).
- **Order of work:** the tests were written after the generator's first run (the spike shaped its API), then locked; the locked canvas test was unlocked once to drop an unused lint directive, no assertion changed. The Figma look was skipped: the canvas presents the coded components, it draws none.
- **Publish before the Design System re-sync:** Dialog's `inline` reaches the Design System only after the merge, so the pilot publish sends this branch's bundle as files; after the merge the system is re-synced and the canvas republished with its `ds/fox-drop/` copied from it.
