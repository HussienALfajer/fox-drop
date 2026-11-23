---
paths:
  - 'apps/admin/**'
  - 'apps/merchant-portal/**'
---

# The two web apps

The admin panel and the owner web portal are static single-page apps on one stack (architecture §10). Each app's own `CLAUDE.md` adds what is particular to it.

- **One feature, two files:** `<feature>.ts` holds its queries, mutations and pure functions and maps each answer to a typed result (`{ status: 'refused', refusal }` for a refusal the page explains, a thrown error for anything else); `<feature>-page.tsx` only renders. Routes are written in code in `src/router.tsx` (no generated route file).
- **API (E6):** call the server only through `api` from `src/api.ts`, inside a TanStack Query query or mutation. Never a hand-written `fetch`, never a second client.
- **Same origin, no secrets (E7):** the app calls `/v1` on its own origin (Vite forwards it to port 3000 in development). Never put an API address, key or secret in the bundle: every `VITE_` variable ships to the browser.
- **Arabic, right to left (AP §4.7):** every user-facing string, the page title included, is a key in `src/locales/ar.json` read with `t()`; the keys are typed, so a missing one fails the type check. Western digits only (`src/locales/ar.test.ts`). Format numbers and dates with `Intl` and `ar-u-nu-latn`, never plain `ar`.
- **Lint:** the root `eslint.web.mjs` (shared by every web app) fails text written in JSX, in braces or in a label attribute (`alt`, `title`, `placeholder`, `aria-label`), and `Intl` or `toLocale*String` with plain `ar`. `apps/admin/test/lint.test.ts` proves each rule fires; add a case when a rule changes.
- **Money and codes:** format money from integer minor units (`format.ts`), never through a float; a code label (status, reason, alert) is a key map checked against the API's enum with `satisfies`; a code the app does not know is hidden, never shown in English; only an operator's own reason shows as written (`eventReason`).
- **Time:** show and type times on the chosen city's clock, never the browser's; countdowns and SLA colours use the server's clock (`clock.ts`).
- **Session and permissions (AP §5.1, §6.1):** every page but `/sign-in` and `/setup` sits under the `signed-in` layout route. A page needing a permission checks it with `can()` in its route's `beforeLoad` and hides its links and menu entry (`layout.ts`) the same way; the server still enforces it.
- **Commands (architecture §5.3):** a command that takes `Idempotency-Key` keeps one key per choice until an answer arrives, so a retry replays instead of acting twice. A command that only sets a value takes none.
- **Content-Security-Policy:** staging and production serve `default-src 'self'` (`infra/nginx/headers.conf`): no inline script or style, no `data:` image, no third-party origin. Draw generated images as inline SVG. Playwright runs without it: check new resources against it.
- **Types:** `tsconfig.json` types `src` for the browser; `tsconfig.node.json` types `e2e`, `test` and the config files.
- **UI:** it comes only from `@fox-drop/ui-web`; a screen is coded only after its drawing is approved (architecture §9.9). Layouts use start and end, never left and right.
- **Unit tests:** `*.test.ts` next to the code; a test that imports a feature file mocks `./api.js` with `vi.mock`, since the client reads `window`.
- **Smoke tests (`e2e/`):** Playwright runs the built app (`vite preview`) in Chromium and answers its API calls with `page.route`, so it needs no server. The panel previews on port 4173, the portal on 4174. Look for a page's own controls inside `getByRole('main')` where the top bar or menu has one of the same name.
