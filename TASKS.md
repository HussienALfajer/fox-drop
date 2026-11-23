# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

D.6 `packages/ui-web` (`docs/roadmap.md` Phase D): Storybook, UI lint rules, Button and Icon, the bundle for the design system and the first sync. The owner sees the real Button in the design system.

- **Branch:** `feat/ui-web`.
- **Cited:** architecture §9.5 R1, R3, R4, R5 and R9, §9.6, §9.8, §9.9, §9.10 (UI SDK pinned, Base UI fallback, the RTL gate); `docs/brand/directions.md` «Measurements» (controls row: pills 50 high, the offset shadow); `apps/admin/CLAUDE.md` for the web rules; `docs/code/packages/design-tokens.md` «Icons (D.5)» for the icon data (`@fox-drop/design-tokens/icons`: `{d: string[], mirror}`, stroke 2/24 of the size, `mirror` flips under RTL) and «The Design System and the Guide (D.4)» for the sync; `docs/slice-notes.md` «Left from D.5».

### Design

Owner (2026-11-23): visual tests use the real CoFo (`FONTS_DEPLOY_KEY` before the merge); the sheet shows every Button variant and state, the owner picks; a compact Button of 40 for the panel; Playwright snapshots, no Chromatic.

- **Package** `packages/ui-web` (`@fox-drop/ui-web`, private, ESM, TS source exports). Exact pins: `@ui-sdk/react` and `@ui-sdk/core` `0.1.0-beta.14` (T11), `tailwind-variants` 4.0.2, `tailwindcss` and `@tailwindcss/vite` 4.3.5, Storybook 10.6.8, `@axe-core/playwright` 4.14.0, Testing Library; the repo's React, Vite, Vitest, Playwright. Base UI 1.9.0 only for a piece failing the RTL gate.
- **Styles:** `src/styles.css` imports `tokens.css` and `tailwind.css` and declares CoFo 400/500/700 by `@font-face` from `.fonts/` (self-hosted, §9.3). Components read their component tokens as `(--fd-button-*)`; the Tailwind theme stays semantic only (R1).
- **Icon** (§9.4): `<Icon name size="sm|md|lg" label?>` over `@fox-drop/design-tokens/icons`, inline SVG (CSP forbids `data:`): viewBox 24, `stroke="currentColor"`, width 2, round caps and joins, no fill; `mirror` flips with `rtl:-scale-x-100`; `aria-hidden` without `label`, `role="img"` with it.
- **Button** on `@ui-sdk/react/button` (read its `.d.ts` first): `variant` (the set approved on the sheet), `density` `comfortable` 50 or `compact` 40 (panel), `icon` and `iconEnd` (`IconName`, at start and end), `loading` (`aria-busy`, width kept, no activation), `disabled`, icon-only circle with a required `label`. Visible focus ring `focus-ring`. Compact is for pointer devices: the sheet asks the owner to confirm it against R4's 48 dp touch rule.
- **Tokens** (design-tokens 0.4.0, changelog): `button.compact.height` 40 and the colour roles of each approved variant beyond primary and secondary, each with its pair in `src/contrast.ts`.
- **Lint** (R1, R3, R5, T11), a local plugin in `eslint.web.mjs` (so `ui-web` and both apps get it) over every string and template: no arbitrary Tailwind value (`(--fd-*)` only); no hex; no `style` prop; no physical direction (`ml-`, `pr-`, `left-`, `text-right`, `rounded-l`, `border-r`, `float-left`...); apps import no `@ui-sdk/*` or `@base-ui/*`; nobody imports `@ui-sdk/react/agent`. Grep the apps for `style=` and physical classes first. `test/lint.test.ts` proves each rule fires.
- **R3 test:** every component exported by `src/index.ts` has `<name>.stories.tsx` with one story per state in its `STATES` list (default, hover, focus, pressed, disabled, loading, both densities).
- **Storybook** (§9.6): `.storybook/` with a decorator `dir="rtl" lang="ar"`, a surface toolbar (phone, captain via `data-surface="captain"`, panel), `.fonts/` as a static dir. Story labels are Arabic sample text (stories are excluded from the JSX-text lint like tests).
- **RTL gate** (§9.10, R4, R9), Playwright over the built Storybook, `e2e/`: the start icon sits right of the label; `back` is mirrored; Enter and Space activate, disabled and loading do not; focus ring visible; axe WCAG 2.2 AA with `color-contrast` off (the token test is the contrast gate; the orange is excepted); no label clips at 130% text. Snapshots of every story on phone and captain, in `mcr.microsoft.com/playwright:v1.64.1-noble` locally and in CI; a missing `.fonts/` fails with a message, never skips; CI runs `pnpm fonts:fetch` first.
- **Wiring:** turbo `build` (Storybook and the bundle), `test`, `test:e2e`; `scripts/classify-changes.mjs` and `ci.yml` for the new package (`## Checks changed`).
- **Bundle and sync** (§9.8; read the type's `format.md` on the system's url first): `pnpm --filter @fox-drop/ui-web design-system` writes one classic IIFE `window.FoxDrop` with React 19 inside (no UMD; `libraries: []`), `bundle.css`, `index.d.ts` and `Button/`, `Icon/` (`README.md`, `preview.html` with every state) into `.design-system/system/project/components/`; then the index and publish of `packages/design-tokens/CLAUDE.md` «Sync», extended for it.
- **Docs:** `packages/ui-web/CLAUDE.md`, `docs/code/packages/ui-web.md`; `apps/admin/CLAUDE.md`'s stale design-stop line becomes: UI only from `@fox-drop/ui-web`, a screen only after its drawing is approved (§9.9).
- **Left out:** wiring into the apps (later screen slices); money and the ₺ fallback, bidi isolation of Latin runs (D.8); dark mode; Flutter (D.7); the icon accent layer.

### Plan

- [x] Read the cited sections and write the design here
- [x] Draw «Button and Icon — batch 1» (`src/button-sheet.ts`); the owner approves
  - **Approved 2026-11-23** (values: `button()` in `src/button-sheet.ts`): the four variants plus icon circles; danger pressed = `color.alert`; ghost transparent, pressed `surface-pressed`; **no button shadow**; hover = 88% bg mixed with pressed; compact 40 panel only.
- [ ] Package skeleton: Tailwind, Storybook in RTL, fonts, turbo, verify, CI and classify wiring; the lint rules and their test
- [ ] Icon with stories and unit tests
- [ ] Tokens for the approved set (0.4.0) and Button on UI SDK with stories and unit tests
- [ ] RTL gate, axe, 130% text and visual snapshots in Docker; the story coverage test
- [ ] Bundle for the Design System and the first sync; the docs
- [ ] Review, hand over to D.7, pull request (waits for `FONTS_DEPLOY_KEY`)

## Waiting for the owner

- From `test/money-properties` (merged, PR 246): what an outcome posts when a restaurant-funded discount exceeds what the clearing account holds (`outcomeEntries` throws today; the property skips that case).
- D.1: the `FONTS_DEPLOY_KEY` secret (the private half of a read-only deploy key on `fox-drop-fonts`, no expiry; commands in the pull request thread) in the repository's Actions secrets; until then the CI fetch step skips. D.6's visual tests need it before the merge (owner agreed 2026-11-23). The meaning of the `broken-edges` icon SVGs and of the `variant-b/c` icons.
- D.3: the choices under «Decided by us» in `docs/slice-notes.md` «Left from D.3».
- D.4: open both artifacts; the choices under «Decided by us» in «Left from D.4».
- D.5: the orange accent layer for icons («Left from D.5»).
- Phase 3 of `docs/claude-code-workflow.md`: the `marketing` and `social-media-skills` plugins, off only in the app's settings (start goal under 45K tokens; was 75.7K).
- Phase 6 items 1 and 2: record L.1c's two-session measurement (`scripts/claude-audit.mjs`, against L.1a and L.1b) in `docs/claude-code-workflow.md`.
- L.1c's choices to confirm (`docs/slice-notes.md` «Left from L.1c»).

## After that

D.7 `feat/core-ui`. Then L.2 The permission matrix (`test/permission-matrix`; read first: architecture §18.1, AP §6 and §14 item 2, RA §22 item 2, the AP-2 and RA-2 rows of `docs/launch/dod-checklist.md`, `apps/server/CLAUDE.md` «Deny by default», the route table in `apps/server/src/modules/identity/admin-team.test.ts`), then L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
