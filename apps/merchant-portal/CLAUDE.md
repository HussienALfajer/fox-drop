# apps/merchant-portal

The owner web portal «بوابة المطعم» (architecture §10.4, RA §17): the same stack and rules as the admin panel; read `apps/admin/CLAUDE.md` first, it does not load here by itself (the the API through `api` only, same origin, feature and page pairs, Arabic and right to left, no styling until the design). It calls the `merchant` route group, serves on port 5174 in development and previews on 4174 for its smoke test (`e2e/smoke.spec.ts`).

## Rules

- **Only the routes the server opens to the portal** (`@AppSignedIn({ portal: true })`, the server's `merchant-portal.test.ts`); any other answers `403 not_in_portal`. A new screen opens its routes on the server in the same slice.
- **Translations' types:** never pass `t` to a helper as a parameter (`ReturnType<typeof useTranslation>['t']`): with `ar.json`'s typed keys it hits TypeScript's instantiation limit (`TS2589`). Write a hook that calls `useTranslation()` and returns the function (`useChangeText`, `useDecidedBy`, `useWithin`).
- **Session (RA §5.2–5.3):** owners only, by phone and WhatsApp code (`session.ts`). Every page but `/sign-in` sits under the `signed-in` route; a 401 from any route outside `/v1/merchant/auth/portal/` means the session ended and `api.ts` opens `/sign-in`.
- **Times:** shown and typed on the restaurant's city clock, the session's `timeZone` (`format.ts`), never the browser's; countdowns on the server's clock (`clock.ts`).
- **Money:** compare and format integer minor units, never floats.
- **Real time (`live.ts`):** the layout follows the restaurant's Centrifugo channel; each publication invalidates what it changed (`staleKeys`), and while the channel is down the board polls. The portal never counts as a receiving device (RA §4.6).
- **Commands:** a command with an `Idempotency-Key` keeps one key per ask until answered; a new row's id is made once per form (`crypto.randomUUID`), so a resend changes the same row.
- **Uploads and downloads:** photos, report files and Excel exports are signed for the portal's own origin and go through nginx (Vite in development); a download asks its URL at the click.
- **Terms and terminated restaurants:** until the terms are accepted every screen but «الطلبات» and the terms shows the terms (`AfterTerms` in `router.tsx`); a terminated restaurant's owners see the money section only, read only.
- **Print:** the browser's print with `data-print="hide"` and the one print rule in `index.html`; no layout until the design.

## More

Behaviour, decisions and history: `docs/code/apps/merchant-portal.md`. Grep it for what you change; never read it whole.
