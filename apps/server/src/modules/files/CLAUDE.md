# files module

Uploads to the object storage and their checks before a record links them (architecture §4.2, §5.8; slice 2.5). The storage is Garage (T7); its setup and the tests' Garage are in the shared `src/storage/`.

## Rules

- **One bucket so far:** `public-media` (`PUBLIC_MEDIA_BUCKET`), served by imgproxy under `/media/` (`infra/imgproxy/imgproxy.env`). `private-docs`, encrypted and opened with short-lived signed URLs, joins with the captain documents (2.34).
- **Uploads** (`files.uploads`): `POST /v1/admin/uploads` (`{ purpose, contentType, sizeBytes }`) records an upload and answers a pre-signed `PUT` valid `UPLOAD_URL_SECONDS` (10 minutes). The type and the size are signed (`signableHeaders`), so Garage refuses any other body with `403`. Types: JPEG, PNG, WebP; at most `MAX_IMAGE_BYTES` (8 MB). The key is `<folder>/<uuid>.<ext>` per purpose (`restaurants/logos`, `restaurants/covers`, `menu/items`), new for every upload and never reused, so imgproxy's and nginx's caches never go stale. Who may ask: `restaurants.manage` for `restaurant_logo` and `restaurant_cover`, `restaurants.menus` for `item_photo` (`403` otherwise). No `Idempotency-Key`: asking again makes another upload, and only the linked one is used.
- **Where the panel uploads:** the URL is signed for `ADMIN_PANEL_URL`'s origin, path style (`/public-media/<key>`). nginx on the panel's host (and Vite in development) forwards that path to Garage with the same `Host`, so the signature holds and the browser needs no CORS. Uploads from the apps (2.32, 2.34) will sign for their own host.
- **Linking** (`FilesService.claim(tx, uploadId, purpose)`), in the transaction of the record that takes the file: the upload must exist (`upload_not_found`), be for that purpose (`upload_wrong_purpose`) and be at most `LINK_WITHIN_MS` (an hour) old (`upload_expired`); the stored object must exist (`upload_missing`) with the size and type asked for and start with that type's signature (`hasImageSignature`; `upload_invalid`). Then `linked_at` is set. An upload linked before answers `alreadyLinked: true` with its key: the caller treats the same key on the same record as a repeat and anything else as `upload_used`.
- **The storage client** is built on first use from `STORAGE_URL`, `STORAGE_KEY_ID`, `STORAGE_SECRET` and `ADMIN_PANEL_URL`, so a process or a test that never uploads needs none of them. The SDK's default checksums are off (`WHEN_REQUIRED`): a pre-signed URL must not carry one the browser cannot send.
- **Tests:** `startTestStorage()` (`src/storage/test-storage.ts`) starts Garage with the image of `compose.yaml` and sets it up; point `STORAGE_URL`, the key and `ADMIN_PANEL_URL` at it before the app starts.

## Not yet

- Removing the objects of uploads never linked, and of images a newer one replaced (a worker job; the bucket only grows until then).
- The apps' own uploads: the restaurant's photos with their review (RA §9.2, 2.32), the customer's report photos (CU §12.2, 2.24), the captain's documents in `private-docs` (2.34).
