# apps/admin

The admin panel «لوحة الإدارة»: a static single-page app (architecture §10). `apps/merchant-portal` follows the same rules.

## Layout

- `src/main.tsx`: mounts the app with i18next, TanStack Query and TanStack Router.
- `src/router.tsx`: the route tree, written in code (no generated route file).
- `src/api.ts`: the API client. `src/i18n.ts` and `src/locales/ar.json`: the translations.
- `e2e/`: the Playwright tests. Unit tests sit next to the code as `*.test.ts`.

## Rules

- **API (E6):** call the server only through `api` from `src/api.ts` (`createApiClient` from `@fox-drop/api-schema`), inside a TanStack Query query or mutation. Never a hand-written `fetch`, never a second client.
- **Same origin (owner decision 2026-11-05):** the app calls `/v1` on its own origin. In development Vite forwards `/v1` to the server on port 3000 (`vite.config.ts`), so the `__Host-` session cookie works without CORS; in production the edge routes `/v1` to the API. Never put an API address, key or secret in the bundle (E7): every `VITE_` variable ships to the browser.
- **Arabic, right to left (AP §4.7):** `index.html` is `lang="ar" dir="rtl"`. Every user-facing string, the page title included, is a key in `src/locales/ar.json`, read with `t()`; the keys are typed from `ar.json`, so a missing key fails the type check. Translations use Western digits (`src/locales/ar.test.ts`). Format numbers and dates with `Intl` and the `ar-u-nu-latn` locale, never `ar` alone. The root `eslint.web.mjs` holds the lint rules every web app shares: it fails text written in JSX, in braces or in a label attribute (`alt`, `title`, `placeholder`, `aria-label` and the like), and `Intl` or `toLocale*String` called with plain `ar`. `test/lint.test.ts` proves each one fires; add a case when a rule changes.
- **Types:** `tsconfig.json` types `src` for the browser (DOM and `vite/client`, no Node globals); `tsconfig.node.json` types `e2e`, `test` and the config files for Node.
- **Design stop:** no styling, design tokens or shared UI package until the owner says the UI/UX and the design system are ready (root `CLAUDE.md`). Layout, when it comes, uses start and end, never left and right.
- **Smoke test:** `e2e/` runs the built app (`vite preview`) in Chromium and answers its API calls with `page.route`, so it needs no server. Each app previews on its own port (admin 4173, portal 4174) because Turborepo runs them together.

## Commands

From the repository root, after `docker compose up --detach` and the server on port 3000:

- `pnpm --filter @fox-drop/admin dev`: the panel on http://localhost:5173 (the portal: `@fox-drop/merchant-portal`, port 5174).
- `pnpm --filter @fox-drop/admin test:e2e`: build first (`build`), then the smoke test. `pnpm verify` runs both for every app and installs Chromium once.
