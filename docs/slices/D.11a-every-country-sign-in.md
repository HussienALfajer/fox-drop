# D.11a Every country at sign-in, and the fields D.11's screens need

Status: Planned · Tier: T0 (sign-in, a migration) · Branch: `feat/every-country-sign-in`
Spec: CU U3, CU §4.2, §4.7, §5.2; RA §5; CA §5, C13; AP §9.12.1, §9.14, Appendix A (`otp.*`, `app.<app>.*`); architecture §8.3.3 item 2 · Definition of done: the D.11a line of `docs/roadmap.md`; it closes the server items 1 to 4 of D.11's «Code changes recorded for step 8» and the server parts of D.11's «Owner's answers» (b) and (d).

## Goal

The three apps' sign-in, a restaurant user added in the panel or the restaurant app, and a customer's number change take a mobile number of any country. `GET platform` answers the platform hours, the minimum version and the maintenance return time; sign-in tells used-up attempts apart from an expired code; the office has a landmark description. D.11's screens then have every field they show.

## Owner decisions (2026-11-24, for this plan)

- A number outside Syria (+963) and Turkey (+90) gets at most **3 codes a day** (`otp.number_daily_max_abroad`, global, OWN, default 3; the hourly limit `otp.number_hourly_max` and the device and IP limits stay as they are). Syria and Turkey keep `otp.number_daily_max` (6).
- The office's landmark description is shown to the customer (the dues sheet, `account-state`) **and to the captain** (every answer that carries the office today, CA C13).

## Plan

0. No design checkpoint: no component or app screen. The two panel fields join pages that are unstyled until the design (`docs/code/apps/admin.md`).

1. **Every country (server items 1 and 2).**
   - Add `libphonenumber-js` to `apps/server` with an exact pin (`pnpm add --filter @fox-drop/server libphonenumber-js@<version>`; MIT). Record the version in `docs/code/apps/server.md`.
   - `src/modules/identity/app-phone.ts` replaces `APP_PHONE_PATTERN` with `isAppMobile(phone)`: E.164 (`^\+[1-9]\d{7,14}$`), parsed with the `max` metadata, valid, type `MOBILE` or `FIXED_LINE_OR_MOBILE` (countries such as the United States do not tell the two apart). `appPhone` is the Zod string the routes share: the E.164 shape as `regex` (so the OpenAPI pattern stays) plus a `refine` on `isAppMobile`. It replaces the regex at every user: `app-auth.ts` (`phone`, with its new description), `merchant-staff.controller.ts`, `admin-restaurant-accounts.controller.ts`, `customer-accounts.service.ts` (the number change, refusal text «not a mobile number»), `captain-accounts.service.ts`, `merchant-accounts.service.ts` and `placeholder-phone.ts` (its message).
   - The masked display «+963 ••• 456» shows the number's real calling code: one function, `maskedPhone(e164)` (calling code from the metadata, then `•••` and the last three digits), exported from identity's `index.ts` and used in place of the four copies in `customers/blocks.ts`, `identity/admin-restaurant-accounts.controller.ts`, `captains/admin-captain-applications.controller.ts` and `reporting/admin-captain-profile.controller.ts`. If the module-boundary test refuses an import (reporting and captains already import identity's public entry; check), put it in a shared `src/phone/` file instead, beside `src/http/phone-search.ts`.
   - `logging/redact.ts` already masks any `+` or `00` international number: no change, but its test gains a German, a British and an American number (international and with `00`), so the claim is proved.
   - `src/http/phone-search.ts` (the cash desk's and tickets' search) already takes any international number: no change.
   - Every phone number in the server's tests and the placeholder seed must pass `isAppMobile`. Today's fakes are `+9639…` numbers such as `+963900000001`; whether the metadata takes `+96390` as a Syrian mobile is checked first (see the tests). If it does not, the placeholder seed's three numbers and the test fixtures move to a valid Syrian mobile range (a seed change only; the staging accounts keep their real numbers set by the placeholder-phone command). This is the slice's first commit after the red phase.

2. **The daily limit abroad (server item 3).**
   - Appendix A gains `otp.number_daily_max_abroad` (3, G, OWN, «Codes per phone number per day for a number outside Syria and Turkey (architecture §8.3.3 item 2)») after `otp.number_daily_max`; the catalogue gains it in the same order (`count(3, 'global')`); `apps/admin/src/locales/ar.json` its `settings.name` and `settings.description` (panel-labels test).
   - `AppSignInService.requestCode` takes `otp.number_daily_max_abroad` in place of `otp.number_daily_max` for a number whose calling code is neither 963 nor 90, with the same key, window and refusal (`number_limit` as today, 429 with `Retry-After`). Architecture §8.3.3 item 2 says so.

3. **Used-up attempts (owner's answer (b)).**
   - `SignInCodeRefusedError` gains the refusal `attempts_used`. In `useCodeIn`: the wrong attempt that reaches `otp.max_attempts` answers `attempts_used` (not `wrong_code` with 0 left); a later attempt finds no open code, so before answering `code_expired` it reads the number's latest code for the party and device, and answers `attempts_used` when that code ended `attempts_exhausted`. A new code request opens a new code, so the next wrong attempt is `wrong_code` again. An expired code, a code of another device and a portal-versus-app mismatch stay `code_expired`. The answer is the same whether the number has an account (architecture §8.3.2).
   - The four routes that map the refusal (customer, captain, merchant, merchant portal) and the customer's account deletion (`useCode`) answer `400 attempts_used` with `attemptsLeft: 0`; their API descriptions list it.
   - The clients keep working until D.11 gives it its own words: `core_auth`'s `sign_in_screen.dart`, the customer's `delete_account_screen.dart` and the portal's `session.ts` read `attempts_used` as they read `code_expired` today (one case each, same message).

4. **`GET platform` (owner's answers (b) and (d)).** `app-platform.controller.ts`, the shared `PlatformDto`:
   - `minVersion` (optional, the `app.<app>.min_version` setting when set), for the update ticket's real version.
   - `maintenanceReturnsAt` (optional ISO time): `app.<app>.maintenance` gains `returnsAt` (`z.iso.datetime().nullable().default(null)`, so a value stored before the deploy still parses and maintenance that is on stays on; `effective()` would otherwise fall back to the default, maintenance off). Sent only while maintenance is on and the time is still ahead: a time that has passed promises nothing. Appendix A's row and AP §9.14 say «maintenance mode with its message and an optional return time».
   - The customer route only: `hours` (optional `{open, opensAt}`; `opensAt` an ISO time, null when open or when no period is scheduled). The query takes the selected point as `account-state` does (`latitude`, `longitude`, both optional; both or neither, else 400); the city is `geo.locate(point)` and the answer is `platformOpening(platform.hours of the city, now, city time zone)` from `ordering/platform-hours.ts`, reached through ordering's public entry (or moved to settings, the owner of `platform.hours`, if the module-boundary test refuses settings importing ordering: settings must not depend on ordering, so the likely home is a small function exported by settings or geo; decide by the boundary test and record it). No point or a point outside every city: no `hours`. The captain and restaurant routes do not take the point.
   - The panel's «التطبيقات» page (`apps/admin/src/app-settings-page.tsx`) gains the return time beside the maintenance message (a date and time on the city clock of the board's city, cleared by an empty field; strings in `ar.json`).

5. **The office landmark (owner's answer (d), and C13 per the owner today).**
   - Migration (`db-migration` skill, expand only): `geo.offices.landmark text NULL` with a check of 1 to 120 characters after trimming. Grants are table-level, so none change; confirm in the migration test.
   - `GeoService.setOffice` takes `landmark` (trimmed, empty is null) into the new version; the `city.office` audit entry carries it with the version before; `office()` returns it.
   - Routes: the admin office route's body and answer (`admin-cities.controller.ts`), `account-state`'s `office` (`customer-account-state.controller.ts`) and the captain's office (`captain-availability.controller.ts` `officeBody`) gain `landmark` (string, nullable).
   - The panel's office page (`apps/admin/src/office-page.tsx`) gains «وصف المكان» (one line, 120 characters, «مثال: بجانب جامع …» as its hint; strings in `ar.json`).
   - The captain's evening cash reminder (`notifications/captain-cash-notices.ts`) stays as it is.

6. **Contract and clients.** `pnpm generate:api`; commit `packages/api-schema` and `packages/core_api`. Every change is additive except the `phone` description and pattern and the new refusal value.

7. **Spec text (server item 4)**, in the same pull request: U3 in CU §2 (every country, owner decision 2026-11-24, with its reason); CU §5.2 item 1 (any country's mobile; the picker and the field's rules are D.11's components slice, so the spec names the behaviour of D.11's analysis); CU §4.2 (the update screen's required version) and §4.7 (maintenance's return time; the platform hours read from `GET platform` as well as checkout); RA §5 and CA §5 line 28; AP §9.12.1 (the landmark, shown to captains and customers), §9.14 and Appendix A; architecture §8.3.3 item 2. `customer.phone_default_country` stays SY or TR (the owner rejected a default from the SIM; the picker pins Syria and Turkey). `docs/code/apps/server.md`, `docs/code/apps/admin.md` and the merged slice's notes record what changed.

Tests written first (locked in the red phase):

- `src/modules/identity/app-phone.test.ts` (new): one case per row: Syrian mobiles `+96393…`, `+96394…`, `+96395…`, `+96396…`, `+96398…`, `+96399…`; a Turkish mobile; a German, British and Iraqi mobile; an American number (fixed or mobile) accepted; a Syrian and a Turkish landline, a number a digit short and a digit long, a national form (`0944…`), `00963…` and a bare `963…` refused; every phone in `placeholder-seed.ts` and the placeholder-phone command accepted; `maskedPhone` for `+963`, `+90`, `+44`, `+1` and `+7`. (D.11's normalisation table is the clients' job, in the components slice: the server takes E.164 only.)
- `src/logging/redact.test.ts`: the German, British and American numbers masked in a message, international and with `00`.
- `app-sign-in.test.ts`, `captain-sign-in.test.ts`, `merchant-sign-in.test.ts`: a German mobile gets a code and signs in (customer, captain and a restaurant user added with it); a landline is `400` at the code request; the abroad limit: a German number's fourth code of the day is `429 number_limit` while a Syrian number's fourth passes, and a changed `otp.number_daily_max_abroad` applies; attempts: wrong, wrong, then the attempt reaching `otp.max_attempts` is `attempts_used`, a further try `attempts_used`, after a new code request `wrong_code` with attempts left again; an expired code and another device's code stay `code_expired`; the customer's account-deletion code answers `attempts_used` the same way.
- `merchant-staff.test.ts` and the admin restaurant-accounts test: a foreign mobile is added; the masked number shows its own calling code («+44 ••• 123»); the same in `customers` blocks and the captain applications and profile tests that assert a masked number.
- `settings/app-versions.test.ts` or a new `app-platform.test.ts`: `minVersion` when set and absent when not; `maintenanceReturnsAt` while maintenance is on and the time ahead, absent when it has passed or maintenance is off; a stored `{enabled: true, message}` from before the change still reads as maintenance on; the customer's `hours` for a point in Azaz inside and outside a `platform.hours` schedule (with `opensAt`), absent without a point and outside every city; a point with only a latitude is `400`.
- `geo` office tests (`admin-cities` and `geo.service`): the landmark saved in a new version, trimmed, empty as null, over 120 refused, in the audit entry; `account-state` and the captain's office answer carry it; the migration test sees the column and the check.
- `settings/catalogue.test.ts` and `panel-labels.test.ts` (existing) prove Appendix A, the catalogue and the Arabic labels agree on the new key.
- Flutter `core_auth` sign-in screen test and the customer's delete-account test: `attempts_used` shows the code-expired message; the portal's sign-in test the same.

Checkpoints (one commit and `checker` each): (1) red phase; (2) every country and the masks; (3) the abroad limit and the attempts; (4) `GET platform`; (5) the office migration and landmark; (6) the contract, the clients, the panel fields and the spec text; then `reviewer` and `security-reviewer`.

## Plan critique (fresh build session, 2026-11-24)

Checked against the code before building; the plan stands with these corrections:

1. **`+96390…` is a Syrian mobile** in libphonenumber's `max` metadata (`+963900000001` parses as `MOBILE`), so the placeholder seed and the fixtures keep their numbers.
2. **The metadata refuses `+96391…` and `+96392…`**, which today's pattern takes. To refuse nothing the apps take today, `isAppMobile` takes today's Syrian and Turkish pattern as well as any number the metadata calls a mobile (or fixed-or-mobile). The tests' random `+9639xxxxxxxx` numbers keep working. Whether `+96391`/`+96392` are real Syrian ranges is in «ما وجدته» of the report.
3. **The daily refusal is `daily_limit`**, not `number_limit`: the abroad limit answers it, as the Syrian one does.
4. **Settings cannot import geo** (geo imports settings), so the customer's `GET platform` with `hours` moves to the ordering module (which reads geo, settings and its own `platformOpening`); the shape and `PlatformDto` stay in settings and are exported from its entry. The captain and restaurant routes stay in settings.
5. `setOffice` takes `landmark` as optional (absent is none), so its other callers stay as they are; the admin route always sends it.
6. The masks in the customers blocks and the captain applications and profile tests stay Syrian: they now call the one `maskedPhone`, whose own test covers `+44`, `+1`, `+7`; the panel's restaurant accounts test adds a `+44` account.
7. There is no `redact.test.ts`: it is new. It passes before any change, as the plan expected (proof, not red).
8. The Flutter and portal message mappings are tested through small pure functions: `signInMessage` (extracted from the sign-in screen's private `_message`) and `signInResultOf` (from the portal's mutation).
9. Found while building: `maskedPhone` lives in `src/phone/masked-phone.ts` (shared), re-exported by `identity/app-phone.ts`: captains and merchants import only types from identity, so loading identity's entry from them would make a cycle.
10. Found while building: the address's contact number shares `app-auth.ts`'s `phone`, so it takes any country's mobile too; CU §7 says so now.
11. The locked tests cover every checkpoint, so the type check stayed red until the last server layer: the server layers were built in one pass and checked together, then committed.

Owner, 2026-11-24 (during the build): approved fixing two lines of locked tests the red phase got wrong: the captain test's British number (one digit short; now a range the metadata takes whole, `+447400…`) and the `otp.max_attempts` = 1 case of `app-sign-in.test.ts`, which now expects `attempts_used` as the plan says.

## Stopped at

Red phase written and locked (`.claude/state/locked-tests.txt`); next: checkpoint 2, every country and the masks.

## Evidence

- `node scripts/verify.mjs --changed`: not run yet
- Review: not yet

## Before deploying

The `geo.offices.landmark` migration (0152, expand only: a nullable column and its check); a server deploy (new dependency `libphonenumber-js`). No new variable. The new setting `otp.number_daily_max_abroad` reads its default (3) until OWN changes it. The apps need no rebuild: every new field is optional and the new refusal reads as today's message.

## To check on staging

- Sign in to the customer app with a Syrian and a Turkish number as today, then (once D.11's components slice lets the field take other countries) with a number of another country; until then, the code request with a foreign number from the API.
- In the panel: set an office landmark and a maintenance return time; read them in `GET /v1/customer/account-state` (a customer with dues) and `GET /v1/customer/platform`.

## Notes for the next session

- Not in this slice: the clients' phone field, picker and normalisation (D.11 items 5 to 13, the components slice); `attempts_used`'s own words (D.11's code screen).
- The plan critique of a fresh session goes here before building.
