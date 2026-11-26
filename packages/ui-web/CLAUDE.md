# packages/ui-web

The web components of FOX DROP (architecture §9.5, §9.6, §9.8): Tailwind 4 and `tailwind-variants` over `@ui-sdk/react` (headless pieces) and the tokens of `packages/design-tokens`. Used by `apps/admin` and `apps/merchant-portal` and bundled for the Design System. What was built and decided: `docs/code/packages/ui-web.md`.

## Rules

- **The only importer of the UI SDK (T11):** `@ui-sdk/react/<piece>` (never `@ui-sdk/react/agent`) and `@base-ui/*` are imported here and nowhere else; the apps' lint fails on them. Versions are exact pins. Read a piece's `.d.ts` before wrapping it.
- **Tokens only (R1):** a component reads its component tokens as `(--fd-button-*)` classes (`bg-(--fd-button-primary-background)`); the Tailwind theme stays semantic. No arbitrary value (`w-[13px]`), no hex colour, no `style` prop; the lint (`eslint.web.mjs`, `test/lint.test.ts`) fails them. A missing token goes into `packages/design-tokens` first.
- **Logical directions only (R5):** `ms-`, `pe-`, `start-`, `text-start`, `rounded-s`, `border-e`; never `ml-`, `pr-`, `left-`, `text-right`. An icon that mirrors uses `rtl:-scale-x-100`.
- **No text of its own:** a component takes its labels as props; the apps translate them.
- **Stories (R3):** each exported component has `<name>.stories.tsx` with one story per state (default, hover, focus, pressed, disabled, loading, both densities). Stories use Arabic text and skip the JSX-text lint. A component `FooBar` lives in `src/foo-bar/foo-bar.tsx`, exports `STATES` there (not from `src/index.ts`) and, with variants, `VARIANTS`; `test/stories.test.ts` needs a story export ending in each state's PascalCase name (`Hover`), or exactly `<Variant><State>` (`PrimaryHover`) when `VARIANTS` exists. `.storybook/preview.tsx` sets `dir="rtl" lang="ar"` and, from the toolbar, the captain's `data-surface`.
- **Fonts:** `src/styles.css` declares CoFo from `.fonts/` (`pnpm fonts:fetch`, never committed), served at `/fonts`.
- **Web first (T14):** built here before its Flutter twin; its Design System card is the drawing to approve (§9.9). **CSP:** no inline script or style, no `data:` URL; icons are inline SVG.
- **Forms (D.8):** the theme has named spacing only (`gap-2xs`, `w-2xl`; `min-w-0` makes no CSS, use `min-w-none`). A string or template in a JSX `{}` is text: build it above the `return`. Stack states as `group-hover/row:data-checked:`; the SDK sets `data-checked`, `data-unchecked`, `data-indeterminate`, `data-open`.
- **Shared classes** live in `src/field/styles.ts` (`formTv`, `box`; the bundle sources it). Fields use `@ui-sdk` Field, so give a second control inside one (the phone chip) its own `<Field>`.
- **Popups (D.10):** none starts open (a story opens it with `play`); a trigger is our Button through the SDK's `render`; the side drawer is the SDK's Dialog (its Drawer is physical).

## Commands

- `pnpm --filter @fox-drop/ui-web storybook` (port 6006), `build` (static, `dist/storybook`); `lint`, `typecheck`, `test` (`pnpm verify` runs them).
- `pnpm --filter @fox-drop/ui-web design-system`: the Design System's cards (bundle, types, each `design-system/<Name>/`) into `packages/design-tokens/.design-system/system/project/components/`; run it after the design-tokens `design-system` (which empties the folder), then publish (design-tokens «Sync»). A new component joins `COMPONENTS` in `scripts/bundle.ts`, `bundle-entry.ts` and the types in `docs.ts`.
- `... components-canvas`, `components-canvas:check`: the "Fox Drop Components" canvas (`scripts/components-canvas/`, Arabic only in `copy-ar.ts`; steps: `docs/code`), after each sync.
- `... test:e2e`: the functional gate (RTL, keyboard, axe, 130% text) over `dist/storybook`; build first; any OS.
- Screenshots of every story (`e2e/visual.spec.ts`) are valid only from the Playwright image in Docker: after a look change or a new story run `pnpm baselines` at the root (needs Docker and `.fonts/`; `--check` only compares) and commit the PNGs.
- `pnpm parity <Component>` (root): stories beside their Flutter twins (`e2e/parity.spec.ts`).
