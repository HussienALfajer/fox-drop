# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs. At most 8 KB: the notes of earlier slices live in `docs/slice-notes.md`.

## Current task

L.1c Offline browsing (`docs/roadmap.md`, `docs/launch/dod-checklist.md` «Not built»): the customer app's cached browsing without a connection, and an `Idempotency-Key` on the address commands (CU §19 item 28). The owner browses a restaurant in airplane mode.

- **Branch:** `feat/dod-offline-browsing`.
- **Read first:** the CU-28 row and its note in `docs/launch/dod-checklist.md`; CU §19 item 28 and the browsing and addresses sections it rests on; `docs/code/apps/customer.md` (browsing, addresses); `apps/server/CLAUDE.md` (Idempotency) and the address routes in the `customers` module.

### Design

Rests on CU §4.5 («Caching», «Lost connection»), §19 item 28, and the owner's answers of 2026-11-21 (marked «owner»).

**Server: only `POST /v1/customer/addresses` takes a key** (`customer-profile.controller.ts` `addAddress`, `CustomersService.addAddress`). The other three need none by `apps/server/CLAUDE.md` «Idempotency»: `PUT …/{addressId}` and `PUT …/default` set a value; `DELETE` names its target and a repeat is refused (`404`) by what the first did, which the app already ends as done (`AddressBook.delete`).

- `@Idempotent()` + `@IdempotencyKey()`. Two nullable columns on `customers.addresses`, `idempotency_key` and `request_hash` (older rows have none), and a partial unique index on `(account_id, idempotency_key)`; hash the body as the blocks table does (`schema.ts` ~233). Migration adds only (`db-migration` skill).
- Inside the existing transaction, after `lockAddresses` and **before** the limit check: a row with this key and hash answers that address (`201`, as it is now; `404` if deleted since); another hash is `422 idempotency_key_reused`. So a replay at 10 addresses answers the first save, not `address_limit`.
- Tests (route level, next to the existing address tests): replay returns the same id and one row; another body with the key is `422`; a replay at the limit answers the first; no key is `400 idempotency_key_required`. Then `pnpm generate:api`.

**App: one key per address body.** `AddressBook` (`account/addresses.dart`) gains `create(CustomerNewAddressDto) → id` holding `_key`/`_keyFor` (the body's `toString()`, as `PlaceOrderController`): a lost answer keeps the key, any answer or refusal clears it. `add` wraps it in `_run`; checkout's `PlaceOrderController._saveAddress` calls it instead of the API, so «احفظ هذا العنوان» retried after a lost answer saves once. Tests: a lost answer then a retry sends the same key (FakeServer records headers); another body takes a new key; checkout's retry after a lost save sends the same key.

**App: cached browsing** (new `browsing/browse_cache.dart`, logic only; screens keep plain Material, design stop).

- What: the home answer (`homeProvider`), the categories row (`categoriesProvider`), and restaurant pages (`restaurantPageProvider`). Not category pages, banners' lists beyond the home answer they already use, search, favourites or «طلباتي» (CU §4.5 names home, pages and menus only).
- Where: `deviceStoreProvider` (`DeviceStore`, shared_preferences). Each entry `{savedAt, accountId, point, body}`, body via `standardSerializers.serializeWith` (as `search/search.dart`). Keys `browse_home`, `browse_categories`, `browse_page_<id>` and an LRU index `browse_pages` of the **last 20** pages (owner); the 21st drops the oldest.
- For how long: an entry older than **7 days** (`browseCacheMaxAge`, owner) is never shown; every good read rewrites it.
- Which entry fits: same `accountId` (null for a guest; test mode and hearts differ by account), and its point within 1 km of the browsing point (`browseCacheRadiusMetres`, decided by us: fees and `deliversHere` change with distance, and online the live read replaces it at once).
- Online (owner: «cached first, then live»): a fitting entry shows at once instead of the spinner, the read runs, its answer replaces the screen and the entry. Hearts read from a cached answer use its `savedAt` as `since`.
- The read fails with no answer (`DioException` without a response: connection error or timeout) and an entry fits: keep showing it with a bar «لا يوجد اتصال بالإنترنت» (CU §4.5, new ARB key `customerOffline`) at the top of home and the page. That bar is the "not live" mark. A failure with an answer (4xx/5xx) or no entry stays as now (error and «حاول مرة أخرى»).
- Cold start offline (owner: «the last saved home»): the zone check fails (`PointUnavailable(null)`), so home shows `browse_home` at its stored point with the bar, and pages open from their entries at that point. Pull to refresh and the app's return to the foreground (`AppLifecycleListener`, as `AccountStateBanners`) repeat the last point request; a served answer brings live browsing back.
- Offline the cart still takes items (it is on the device); checkout's quote and «تأكيد الطلب» need the server as now (CU §4.5 «Placing an order needs a connection»).
- Tests (`test/offline_browsing_test.dart`, plus pure tests of the cache's fit/age/LRU): cached home shows before the live read, then the live one replaces it; offline home and a restaurant page from cache with the bar, an item goes in the cart; cold start offline shows the last home; an entry of 8 days or another account is not shown; the 21st page drops the oldest.

**Left out on purpose:** a connectivity package (the failed read is the signal); an «آخر تحديث» time (not in the spec); keys on the address `PUT`/`DELETE` (rule above); offline category pages and search.

### Plan

- [x] Read the cited sections and write the design here (what is cached, where, for how long, what a screen shows offline; which address commands take a key).
- [ ] Server: `Idempotency-Key` on the address commands (stored in the module's schema, in the command's transaction); tests (a replay answers the first result, another body is refused); `pnpm generate:api`.
- [ ] Customer app: the address commands send one key per body (resent on a lost answer); tests.
- [ ] Customer app: cached browsing offline (home, a restaurant and its menu from the last good read, marked as not live); tests.
- [ ] Review (`reviewer`), fixes.
- [ ] Mark CU-28 covered in `docs/launch/dod-checklist.md`; notes in `docs/slice-notes.md`; `docs/code/` notes; hand over.

## Waiting for the owner

- Phase 3 of `docs/claude-code-workflow.md`: the phase 4 session started at 75.7K tokens with one MCP delta (goal: under 45K, none). Left: the `marketing` and `social-media-skills` plugins, off only in the app's settings.
- Phase 6 items 1 and 2 (owner decision 2026-11-21): `autoCompactWindow: 350000` and every slice in two sessions, planning then build (`build-slice`). Measure L.1c's two sessions with `scripts/claude-audit.mjs` (compactions, cost, context a request, what was re-read or redone) against L.1a and L.1b in `docs/claude-code-workflow.md`.

## After that

Launch readiness from L.2 (`docs/roadmap.md`); the gap slices come before L.10.

Branches of the later slices: L.2 `test/permission-matrix`, L.3 `feat/captain-simulator`, L.4 `test/load-k6`, L.5 `chore/pgbackrest`, L.6 `feat/monitoring-alerts`, L.7 `chore/production-environment`, L.8 `test/patrol-e2e`, L.9 `docs/device-lab`, L.10 `docs/staging-rehearsal`, L.11 `chore/launch`.
