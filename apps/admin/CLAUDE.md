# apps/admin

The admin panel «لوحة الإدارة»: a static single-page app (architecture §10). `apps/merchant-portal` follows the same rules.

## Layout

- `src/main.tsx`: mounts the app with i18next, TanStack Query and TanStack Router.
- `src/router.tsx`: the route tree, written in code (no generated route file).
- `src/api.ts`: the API client. `src/i18n.ts` and `src/locales/ar.json`: the translations.
- One feature per pair of files (owner decision 2026-11-07, logic apart from presentation): `<feature>.ts` holds its queries, mutations and pure functions, and maps each answer to a typed result (`{ status: 'refused', refusal }` for a refusal the page explains, a thrown error for anything else); `<feature>-page.tsx` only renders. `session.ts` holds the session read, sign-in and sign-out.
- `e2e/`: the Playwright tests. Unit tests sit next to the code as `*.test.ts`; one that imports a feature file mocks `./api.js` (`vi.mock`), since the client reads `window`.

## Rules

- **API (E6):** call the server only through `api` from `src/api.ts` (`createApiClient` from `@fox-drop/api-schema`), inside a TanStack Query query or mutation. Never a hand-written `fetch`, never a second client.
- **Same origin (owner decision 2026-11-05):** the app calls `/v1` on its own origin. In development Vite forwards `/v1` to the server on port 3000 (`vite.config.ts`), so the `__Host-` session cookie works without CORS; in production the edge routes `/v1` to the API. Never put an API address, key or secret in the bundle (E7): every `VITE_` variable ships to the browser.
- **Arabic, right to left (AP §4.7):** `index.html` is `lang="ar" dir="rtl"`. Every user-facing string, the page title included, is a key in `src/locales/ar.json`, read with `t()`; the keys are typed from `ar.json`, so a missing key fails the type check. Translations use Western digits (`src/locales/ar.test.ts`). Format numbers and dates with `Intl` and the `ar-u-nu-latn` locale, never `ar` alone. The root `eslint.web.mjs` holds the lint rules every web app shares: it fails text written in JSX, in braces or in a label attribute (`alt`, `title`, `placeholder`, `aria-label` and the like), and `Intl` or `toLocale*String` called with plain `ar`. `test/lint.test.ts` proves each one fires; add a case when a rule changes.
- **Session (AP §5.1–5.2):** the cookie is httpOnly, so the panel knows its session only from `GET /v1/admin/auth/session` (`sessionQuery`, null on 401). Every page except `/sign-in` and `/setup` sits under the `signed-in` layout route, whose `beforeLoad` sends a request without a session to `/sign-in` and puts `session` in the route context. A page needing a permission checks it with `can()` in its route's `beforeLoad` and hides its links the same way (AP §6.1); the server still enforces it. A 401 from any route outside `/v1/admin/auth/` means the session ended: `api.ts` clears it and opens `/sign-in`.
- **Operations pages (AP §9.2–9.3, slice 1.14f):** `/orders` (the board, `operations.read`), its child `/orders/$orderId` (the detail, in the board's `<aside>`, so the board stays visible, AP §9.2.1) and the detail's child `/orders/$orderId/assign` (the picker, `operations.manage`). The chosen city travels as the `city` search parameter on `/orders` (its code, from `citiesQuery`; the first city without one), and links keep it with `search`. The board's filters belong to their city, and a choice whose last order left the board falls back to «الكل» (`effectiveFilter`). Until the `ops:` channel exists the board and the detail read again every `POLL_MS` (10 s, owner decision 2026-11-07); a command invalidates the reads it changes. Times and SLA colours use the server's clock (`clock.ts`, from every response's `Server-Time`), and times show in the city's zone. Code labels (statuses, tracks, alerts, badges, vehicles; the detail's outcomes and reasons in `order-detail.ts`) are key maps checked against the API's enums with `satisfies`; a code the panel does not know is hidden, never shown in English, and only an operator's own reason shows as written (`eventReason`). Money is formatted from minor units by `format.ts`, never through a float, with the minor-unit digits of `fx.currencies` (Intl's own data gives SYP none).
- **Commands (architecture §5.3):** a command that takes `Idempotency-Key` keeps one key per choice until an answer arrives (`useAssignCaptain`), so a retry after a lost answer replays instead of acting twice.
- **Content-Security-Policy (`infra/nginx/headers.conf`):** `default-src 'self'` on staging and production, so no inline script or style, no `data:` image and no third-party origin. Draw generated images as inline SVG (the setup page's QR code). The Playwright tests run without it, so check a new kind of resource against it.
- **Types:** `tsconfig.json` types `src` for the browser (DOM and `vite/client`, no Node globals); `tsconfig.node.json` types `e2e`, `test` and the config files for Node.
- **Design stop:** no styling, design tokens or shared UI package until the owner says the UI/UX and the design system are ready (root `CLAUDE.md`). Layout, when it comes, uses start and end, never left and right.
- **Smoke test:** `e2e/` runs the built app (`vite preview`) in Chromium and answers its API calls with `page.route`, so it needs no server. Each app previews on its own port (admin 4173, portal 4174) because Turborepo runs them together.

## Commands

From the repository root, after `docker compose up --detach` and the server on port 3000:

- `pnpm --filter @fox-drop/admin dev`: the panel on http://localhost:5173 (the portal: `@fox-drop/merchant-portal`, port 5174).
- `pnpm --filter @fox-drop/admin test:e2e`: build first (`build`), then the smoke test. `pnpm verify` runs both for every app and installs Chromium once.
