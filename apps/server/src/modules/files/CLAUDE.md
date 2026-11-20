# files module

Uploads to the object storage (Garage) and their checks before a record links them (architecture §4.2, §5.8). The storage's setup and the tests' Garage are in the shared `src/storage/`.

## Rules

- **Two buckets:** `public-media`, served by imgproxy under `/media/`, and `private-docs`, which only the server's key reaches. `putPrivate`, `privateDownloadUrl` (a signed GET that saves under a file name), `privateImageUrl` and `deletePrivate` serve the private one.
- **Uploads are pre-signed `PUT`s** to `incoming/<uuid>.<ext>`, valid 10 minutes, with the type and size signed. Only JPEG, PNG and WebP up to 8 MB, except `menu_import` (one `.xlsx`, 2 MB). `POST /v1/admin/uploads` checks the permission by purpose and never takes `report_photo`; app purposes go through the party's own upload route with the hourly limit per account (`429 too_many_uploads`).
- **No `Idempotency-Key`** on an upload route: the answer is a URL never stored, and asking again makes another upload of which only the linked one is used.
- **Sign for the right origin:** the panel's uploads for `ADMIN_PANEL_URL`, the apps' for `APP_UPLOAD_URL`, the owner portal's for `MERCHANT_PORTAL_URL`. nginx and Vite forward that path to Garage with the same `Host` (the signature covers it), so the browser needs no CORS. A new purpose that uploads from a new origin needs its nginx and Vite forwarding, PUT or GET only as the case is.
- **Link in two halves:** `prepare(uploadId, purpose, ...)` before the record's transaction (it calls the storage, so it must never run under a row lock), then `link(tx, uploadId)` in it. `prepare` checks the upload exists, has that purpose and is under an hour old, copies it to its published key and verifies size, type and the file's signature (`hasImageSignature`; `imageSize` reads PNG, JPEG and WebP headers, never a decode; `EXACT_IMAGE_SIZES` for exact pixels). `link` answers `alreadyLinked: true` on a repeat: the caller treats the same key on the same record as a repeat and anything else as `upload_used`.
- **Published keys are new for every upload and never reused**, so imgproxy's and nginx's caches never go stale.
- **Owner-scoped purposes** (`report_photo`, `captain_document`, an owner's `item_photo`): `prepare(..., owner)` finds only that owner's upload.
- **The storage client** has short timeouts and is built on first use from `STORAGE_URL`, `STORAGE_KEY_ID`, `STORAGE_SECRET` and `ADMIN_PANEL_URL`; the SDK's default checksums stay off (`WHEN_REQUIRED`) so a pre-signed URL carries none the browser cannot send.
- **Tests:** `startTestStorage()` (`src/storage/test-storage.ts`) starts Garage; point the storage variables and `ADMIN_PANEL_URL` at it before the app starts.

## More

Behaviour, decisions and history: `docs/code/apps/server/src/modules/files.md`. Grep it for what you change; never read it whole.
