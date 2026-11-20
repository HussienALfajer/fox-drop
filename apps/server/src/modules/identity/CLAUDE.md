# identity module

Accounts, sign-in and sessions of the four products: the admin panel (password, TOTP, roles, team) and the apps' phone sign-in with a WhatsApp code (architecture §8.3, §10.3, §15.1–15.3; AP §5–6, §9.15; CU §5; RA §5; CA §4.9).

## Rules

- **Nothing secret in clear:** passwords are Argon2id; phones and TOTP secrets are encrypted with `IdentitySecrets` (`secrets.ts`) and found by a keyed hash; backup codes, setup and session tokens are hashed. Another module that keeps a phone encrypts it with `PhoneCipher`. `identity.test.ts` fails on any secret in a row or an audit event, so keep numbers and secrets out of audit values.
- **Phone numbers:** a customer's number is decrypted only for the captain's active order and the customer's own profile; any new caller needs the same limit. The panel shows numbers masked.
- **Shown once:** setup token, TOTP secret, backup codes and the session token each appear once; tokens travel in bodies, the cookie or a URL fragment, never in a path.
- **Roles and permissions are rows** that only a migration changes. Add a code to `permissions.ts`; `admin-team.test.ts` keeps the rows equal to AP §6.2–6.3. Permissions are read at every request.
- **Route access:** every route needs one of `@Public()`, `@SignedIn()`, `@RequirePermission()`, `@RealtimeProxy()`, `@AppSignedIn()` or `@AppSignedInOrGuest()` (`src/http/access.ts`), or `RouteAccessGuard` answers `403`. A route the owner web portal reaches declares `portal: true`; `merchant-portal.test.ts` lists them. A captain applicant reaches only `@AppSignedIn({ applicants: true })` routes; `captain-sign-in.test.ts` checks.
- **Argon2 is the costly step:** check a token or find the account before hashing, and never hash inside an open transaction except under the account's row lock.
- **Sign-in answers alike:** every refusal and every code request answers the same whether the number or name has an account or is locked, and takes as long as a wrong password.
- **One engine for every app:** `AppSignInService` and `AppSessionsService` take the party (`appParties` in `schema.ts`). A new party adds its account table, its `appParties` value, the `CHECK`s and its routes.
- **Code sender:** `CodeSender` is the port; the API never loads the WhatsApp library (Baileys lives only in `whatsapp-baileys.ts`, behind `WhatsAppClient`, in the otp-sender process). Tests use fakes.
- **Sessions:** one per device and app; a new sign-in ends the earlier one. Call `AppSessionsService.endAll` inside the ending transaction, and pass the ids it returns to `notifyEnded` after the commit. Resolve the signing key and read settings before opening a transaction, or the pool can run out.
- **Locks:** lock the account row before its link row; a team action takes the `identity.owners` advisory lock; code requests take the number's advisory lock and send last, so a refused send rolls the code back.
- **Cross-module reads:** identity reads a restaurant's or captain's status through `MerchantsService` or `CaptainsService`, outside any transaction; `merchants` and `captains` import only types from identity, so there is no cycle.
- **Time:** services take `now` and never read the database clock.
- **Settings** (`admin.*`, `otp.*`, `merchant.*`) are read at each attempt or request.
- **Commands:** `pnpm --filter @fox-drop/server admin:create-owner --email <email>`, `otp:pair`, `placeholder:phone`; in a deploy `node dist/modules/identity/<name>-command.js` (the `deploy` skill). They print to stdout, never to the logger.

## More

Behaviour, decisions and slice history: `docs/code/apps/server/src/modules/identity.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
