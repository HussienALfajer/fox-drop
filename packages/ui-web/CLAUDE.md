# packages/ui-web

The web components of FOX DROP (architecture §9.5, §9.6, §9.8): Tailwind 4 and `tailwind-variants` over `@ui-sdk/react` (headless pieces) and the tokens of `packages/design-tokens`. Used by `apps/admin` and `apps/merchant-portal` and bundled for the Design System. What was built and decided: `docs/code/packages/ui-web.md`.

## Rules

- **The only importer of the UI SDK (T11):** `@ui-sdk/react/<piece>` (never `@ui-sdk/react/agent`) and `@base-ui/*` are imported here and nowhere else; the apps' lint fails on them. Versions are exact pins. Read a piece's `.d.ts` before wrapping it.
- **Tokens only (R1):** a component reads its component tokens as `(--fd-button-*)` classes (`bg-(--fd-button-primary-background)`); the Tailwind theme stays semantic. No arbitrary value (`w-[13px]`), no hex colour, no `style` prop; the lint (`eslint.web.mjs`, `test/lint.test.ts`) fails them. A missing token goes into `packages/design-tokens` first.
- **Logical directions only (R5):** `ms-`, `pe-`, `start-`, `text-start`, `rounded-s`, `border-e`; never `ml-`, `pr-`, `left-`, `text-right`. An icon that mirrors uses `rtl:-scale-x-100`.
- **No text of its own:** a component takes its labels as props; the apps translate them.
- **Stories (R3):** each exported component has `<name>.stories.tsx` with one story per state (default, hover, focus, pressed, disabled, loading, both densities). Stories use Arabic sample text and are exempt from the JSX-text lint. A component `FooBar` lives in `src/foo-bar/foo-bar.tsx`, exports `STATES` there (not from `src/index.ts`) and, with variants, `VARIANTS`; `test/stories.test.ts` needs a story export ending in each state's PascalCase name (`Hover`), or exactly `<Variant><State>` (`PrimaryHover`) when `VARIANTS` exists. `.storybook/preview.tsx` wraps each in `dir="rtl" lang="ar"`; the toolbar `surface` sets `data-surface="captain"` for the captain.
- **Fonts:** `src/styles.css` declares CoFo from `.fonts/` (fetched by `pnpm fonts:fetch`, never committed); Storybook serves it at `/fonts`.
- **Code a component only after its drawing is approved** (§9.9).
- **CSP:** no inline script or style and no `data:` URL (`infra/nginx/headers.conf`); icons are inline SVG.

## Commands

- `pnpm --filter @fox-drop/ui-web storybook`: Storybook on http://localhost:6006.
- `pnpm --filter @fox-drop/ui-web build`: the static Storybook in `dist/storybook`.
- `pnpm --filter @fox-drop/ui-web lint`, `typecheck`, `test`: the checks (`pnpm verify` runs them through Turborepo).
- `pnpm --filter @fox-drop/ui-web design-system`: the Design System's component files (`bundle.js`, `bundle.css`, `index.d.ts`, and each component's `README.md` and `preview.html` from `design-system/`) into `packages/design-tokens/.design-system/system/project/components/`. Run it after the design-tokens `design-system` (which empties the folder), then publish (`packages/design-tokens/CLAUDE.md` «Sync»). A new component joins `COMPONENTS` in `scripts/bundle.ts`, `scripts/bundle-entry.ts`, `scripts/docs.ts` types and gets a `design-system/<Name>/` folder.
- `... test:e2e`: the functional gate (RTL, keyboard, axe, 130% text) over `dist/storybook`; build first; any OS (`e2e/rtl.spec.ts`).
- `... test:visual`: screenshots of every story, run in Docker (`mcr.microsoft.com/playwright:v1.64.1-noble`, `scripts/visual-docker.mjs`; needs Docker, the built Storybook and `.fonts/`). Baselines in `e2e/__screenshots__/` are valid only from that image. After a deliberate look change: `pnpm --filter @fox-drop/ui-web test:visual --update-snapshots`, then commit the PNGs. A story you add needs its baselines the same way. The `visual` CI job runs the same project and fails without the fonts.
