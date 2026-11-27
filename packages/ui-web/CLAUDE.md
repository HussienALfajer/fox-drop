# packages/ui-web

The web components of FOX DROP (architecture §9.5, §9.6, §9.8): Tailwind 4 and `tailwind-variants` over `@ui-sdk/react` (headless pieces) and the tokens of `packages/design-tokens`. Bundled for the Design System; the apps do not import it yet. What was built and decided: `docs/code/packages/ui-web.md`.

**No component since D.R1 (T16).**

## Rules

- **The only importer of the UI SDK (T11):** `@ui-sdk/react/<piece>` (never `@ui-sdk/react/agent`) and `@base-ui/*` are imported here and nowhere else; the apps' lint fails on them. Versions are exact pins. Read a piece's `.d.ts` before wrapping it.
- **Tokens only (R1):** a component reads its component tokens as `(--fd-button-*)` classes (`bg-(--fd-button-primary-background)`); the Tailwind theme stays semantic. No arbitrary value (`w-[13px]`), no hex colour, no `style` prop; the lint (`eslint.web.mjs`) fails them. A missing token goes into `packages/design-tokens` first.
- **Logical directions only (R5):** `ms-`, `pe-`, `start-`, `text-start`, `rounded-s`, `border-e`; never `ml-`, `pr-`, `left-`, `text-right`. An icon that mirrors uses `rtl:-scale-x-100`.
- **No text of its own:** a component takes its labels as props; the apps translate them.
- **Stories (R3):** each exported component has `<name>.stories.tsx` with one story per state (default, hover, focus, pressed, disabled, loading, both densities). Stories use Arabic text and skip the JSX-text lint. A component `FooBar` lives in `src/foo-bar/foo-bar.tsx`, exports `STATES` there (not from `src/index.ts`) and, with variants, `VARIANTS`; `test/stories.test.ts` needs a story export ending in each state's PascalCase name (`Hover`), or exactly `<Variant><State>` (`PrimaryHover`) when `VARIANTS` exists. `.storybook/preview.tsx` sets `dir="rtl" lang="ar"` and, from the toolbar, the captain's `data-surface`.
- **Fonts:** `src/styles.css` declares CoFo from `.fonts/` (`pnpm fonts:fetch`, never committed), served at `/fonts`.
- **Web first (T14–T16, §9.9):** built here before its Flutter twin, once its screen is approved; its generated board must match the drawing. **CSP:** no inline script or style, no `data:` URL; icons are inline SVG.
- **Forms and popups:** before building one for an approved screen, read the D.8 and D.10 lessons in `docs/code/packages/ui-web.md` (named spacing only, text built above the `return`, stacked state selectors, one `<Field>` per control, popups opened by `play`).

## Commands

- `pnpm --filter @fox-drop/ui-web storybook` (port 6006), `build` (`dist/storybook`); `lint`, `typecheck`, `test`.
- `pnpm --filter @fox-drop/ui-web design-system`: the Design System's cards (bundle, types, each `design-system/<Name>/`) into `packages/design-tokens/.design-system/system/project/components/`; run it after the design-tokens `design-system` (which empties the folder), then publish (design-tokens «Sync»). A new component joins `COMPONENTS` in `scripts/bundle.ts`, `bundle-entry.ts` and the types in `docs.ts`.
- `... components-canvas`, `components-canvas:check`: the "Fox Drop Components" canvas (`scripts/components-canvas/`, Arabic only in `copy-ar.ts`, T15; steps: `docs/code`), rebuilt and published after each sync.
- `... test:e2e`: the functional gate (axe, scroll containment) over `dist/storybook`; build first; any OS.
- Screenshots of every story (`e2e/visual.spec.ts`) are valid only from the Playwright image in Docker: after a look change or a new story run `pnpm baselines` at the root (needs Docker and `.fonts/`; `--check` only compares) and commit the PNGs.
- `pnpm parity <Component>` (root): stories beside their Flutter twins (`e2e/parity.spec.ts`).
