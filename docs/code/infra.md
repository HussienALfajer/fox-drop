# infra

> Moved here from `infra/CLAUDE.md` on 2026-11-20. In these notes, a folder's `CLAUDE.md` (or "its `CLAUDE.md`") means that folder's file under `docs/code/` when there is one, otherwise the folder's own `CLAUDE.md`; the folder's own `CLAUDE.md` now holds only the rules for working there.

How FOX DROP runs on the owner's shared Contabo server (architecture §17, T9, E8).
The `deploy` skill (`.claude/skills/deploy/SKILL.md`) is the runbook: deploy, rollback, provisioning, secrets, backups and restores.
Read the `vertex-server` skill and `/root/SERVER.md` on the server before any work there.

## Layout

- `compose.yaml`: one environment's Compose project (the database, Valkey, the migrations, the storage setup, the four server roles, Centrifugo, Garage, imgproxy and the web container).
  Its images are the commit's `ghcr.io/hussienalfajer/fox-drop-server` and `fox-drop-web`.
- `environments/<env>.env`: an environment's public settings (host names, loopback ports). Its secrets live only on the server, in `/srv/foxdrop-<env>/shared/.env`.
- `centrifugo/config.yaml`: Centrifugo's channels (architecture §6), the same in every environment and in the server's tests;
  its secrets and subscription proxies come from the environment.
  Each environment runs its own `centrifugo` service, whose proxies call `http://api:3000` on the environment's network;
  the API and the worker publish to `http://centrifugo:8000/api`.
- `maps/`: the map (architecture §7.2, `docs/runbooks/maps.md`): `style.json` (written by `style.mjs` from `@protomaps/basemaps`, Arabic labels, every URL under `{{MAPS_URL}}/{{BUILD}}/`), `build.sh` (Azaz's region from a Protomaps daily build with the pmtiles CLI, the glyphs and the sprite) and its image.
- `storage/garage.toml` and `imgproxy/imgproxy.env`: the object storage's and imgproxy's configuration (architecture §5.8, T7), the same in development and in every environment.
- `osrm/`: the shared OSRM (architecture §7.1): its Compose project `foxdrop-osrm`, `cut.sh` (downloads the Syria extract and cuts Azaz's region with osmium), `build.sh` (builds the car, motorbike, bicycle and walking profiles), `motorbike.lua` and the cut image.
  The root `compose.yaml` runs the same scripts locally.
- `web/`: the image of the panel and the portal (an unprivileged nginx that answers unknown paths with `index.html`) and its smoke test.
- `nginx/`: the server's nginx site, snippets and limit zones; `*.template` files are rendered per environment by `provision.sh`.
- `server/`: `provision.sh` (prepares an environment, run as root), `deploy.sh` (`foxdrop-deploy`), `deploy-ssh.sh` (the only command the GitHub Actions key may run), `backup.sh` (`foxdrop-backup`) and its systemd timer, `osrm-build.sh` (`foxdrop-osrm-build`) and its weekly timer, `maps-build.sh` (`foxdrop-maps-build <env>`), `windows-publish.sh` (`foxdrop-windows-publish <env>`, the restaurant app's Windows installer and update feed from CI, slice 2.44), and the deploy key's public half.
- `infra.test.mjs`: the rules below that a machine can check, run by `pnpm verify`.

## Rules

- **Nothing public but nginx (§15.5):** every published port is `127.0.0.1:<port>`;
  Docker bypasses the firewall.
  The server's other sites use ports 3000 to 3073;
  FOX DROP staging uses 3110 to 3116 (3113 is Centrifugo, behind nginx's `/connection/websocket`; 3114 is Garage's S3 API, behind `/public-media/` on the panel's host; 3115 is imgproxy, behind `/media/`; 3116 is Garage's website endpoint, behind `/maps/`).
- **One hop of proxy:** nginx sets `X-Forwarded-For $remote_addr` (replacing), and the API trusts exactly one hop (`trustProxy: 1` in `apps/server/src/http/create-api-app.ts`).
  Never `$proxy_add_x_forwarded_for`, never `trustProxy: true`.
- **Isolation (§17.2):** each environment has its own system user (`foxdrop-<env>`, which the server containers run as), Compose project, network, volume, database, environment file and certificate.
  FOX DROP never uses the server's own PostgreSQL or Redis.
- **Memory limits** on every container: the server is shared with the owner's other sites (§22 item 10).
- **Migrations** run in `deploy.sh` before the new release starts, and must stay backward compatible: a failed start brings the previous release back on the migrated database.
- **Edit here, never on the server.** A change under `nginx/` or `server/` reaches the server only by running `provision.sh` again (the `deploy` skill);
  `compose.yaml` and `environments/` reach it with the next deploy.
- **Secrets** are generated on the server by `provision.sh` and never printed;
  a secret added later (the Centrifugo ones) is appended by its next run when its line is missing, so run it before the deploy that needs it;
  the owner adds the Sentry DSN and the backup keys there.
  No secret in this folder: `server/deploy-key.pub` is the public half.
- The postgis image here and in the root `compose.yaml` stay the same, and so do the OSRM, Garage and imgproxy images (a test).
- **Object storage and images (architecture §5.8, slice 2.5):** Garage (`storage`) keeps `public-media` in the `storage-data` volume;
  `deploy.sh` starts it with the database and runs `storage-setup` after the migrations (the layout, the three keys and the buckets; a no-op once there).
  Only the API, the worker (which writes and removes the Excel exports in `private-docs`, slice 2.19g) and `maps-publish` hold the server's key, only imgproxy the reader key, and no container the nightly copy's backup key (`STORAGE_BACKUP_KEY_ID`/`STORAGE_BACKUP_SECRET`, slice 2.34a: it reads both buckets and writes none; the storage setup imports it and `backup.sh` reads it from the environment file) (a test);
  the reader has no right on `private-docs`. nginx sends `/media/` on every host to imgproxy through the `foxdrop_<env>_media` cache (2 GB, `/var/cache/nginx`, keyed by the path), for exactly a preset width of a published key (a regex; any other `/media/` URL is `404`), and `/public-media/incoming/` on the panel's host (and on the portal's, for the owners' item photos from the browser, slice 2.45b, with `/private-docs/incoming/` for their report photos, slice 2.45c) to Garage for `PUT` only, and `/private-docs/exports/` for `GET` only (the exports' 5-minute signed downloads; on the portal's host too, the owners' Excel files, slice 2.45d, a test), `/private-docs/tickets/`, `/private-docs/restaurants/` and `/private-docs/captains/` for `GET` only (report photos, slice 2.24a, a restaurant's contract and licence scans, slice 2.30a, and the captain applicants' documents, slice 2.34b, signed for 10 minutes), and `/private-docs/incoming/` for `PUT` only (the panel's scans; the API's host has its own `/private-docs/incoming/` for the apps' report photos and `/public-media/incoming/` for the restaurant owners' item photos, slice 2.32b), with the same `Host`, which the signature covers, without the session cookie and out of the access log. imgproxy runs two workers on sources up to 50 megapixels, within 768 MB. imgproxy's preset widths and the apps' (`apps/admin/src/media.ts`, `apps/customer/lib/src/media.dart`) stay equal (a test).
  `backup.sh` copies `public-media`, and `private-docs` without `incoming/` and `exports/` (the captain documents, the restaurants' scans, the report photos; owner decision 2026-11-19, slice 2.34a), encrypted, to B2 under their names every night, never deleting there (a key is never reused);
  the 30-day pruning touches only the dumps.
- **The map (architecture §7.2, slice 2.29a):** `public-maps` is the only bucket with website access (the storage setup takes it from any other);
  nginx's `/maps/` on every host sends `GET` to Garage's website endpoint with `Host: public-maps` (a test), ranges included, under its own rate limit (`foxdrop_<env>_maps`, a test) in place of the server's `general`, and the objects carry their own `Cache-Control`.
  `maps-build` downloads from outside, so it runs on its own `maps-build` network, never the environment's (a test).
  Only `maps-publish` writes it, with the server's key.
  `foxdrop-maps-build <env>` builds and publishes with the current release;
  `provision.sh` runs it once (`--if-missing`) after the first deploy that has `MAPS_PORT`, and goes on when it fails.
  The glyphs and sprite are `basemaps-assets` at `assets_commit` in `maps/build.sh` (to pin after the first build, `docs/runbooks/maps.md`).
  The map's region is OSRM's (a test).
- **One OSRM for every environment (§17, owner decision 2026-11-06):** `provision.sh` copies `osrm/` to `/srv/foxdrop-osrm`, builds the data on the first run (`foxdrop-osrm-build --if-missing`) and enables the weekly rebuild (Mondays 04:30), which downloads fresh OSM data and restarts the routed services;
  for those few seconds the API measures the straight line × 1.3. A change under `osrm/` reaches the server only by running `provision.sh` again;
  then run `foxdrop-osrm-build` for a new region or profile.
- **The `foxdrop-osrm-<env>` networks:** each environment's `compose.yaml` declares its own (so its first deploy creates it, a deploy never needs OSRM, and staging never reaches production's containers), and the OSRM project's routed services join every one as external;
  a new environment adds its network to `osrm/compose.yaml` (a test).
  `provision.sh` skips OSRM until the network exists.
  Never change that declaration (a test pins it): Compose refuses an existing network whose declaration changed.
  Never `docker compose down` an environment while OSRM runs: Compose would try to remove its network;
  stop OSRM first (the `deploy` skill).
- **The Windows downloads (slice 2.44):** `/downloads/windows/` on every host serves `/var/www/foxdrop-<env>-downloads/windows/` for `GET` only (a test), outside the user's home, which nginx cannot read.
  Only `foxdrop-windows-publish` writes it, from the deploy key's `staging windows` (a tar on standard input, Velopack's file names only, the feed last);
  its sudo rule names the environment.
- `nginx` on the server is 1.24: `listen 443 ssl http2;`, not `http2 on;`.

## Not yet

- **Trust boundary:** `foxdrop-deploy` runs, as root, the `compose.yaml` of a commit on `main` with images from ghcr.io.
  Whoever can merge to `main` or push those images can act as root on the shared server;
  the forced command limits which commit deploys, not what it does.
- Staging's B2 key may delete, to prune copies older than 30 days.
  Production's key must not: a B2 lifecycle rule prunes instead, so root on the shared server cannot erase the off-site copies. rclone crypt hides folder names, so that rule cannot tell the dumps from the images: production sends the images to a crypt remote of their own (another bucket or prefix) the rule leaves alone.
- Staging backs up with a nightly `pg_dump`; production needs the continuous WAL archiving of §17.2 (pgBackRest) and a tested restore before launch.
- Removing the objects nobody links (the `files` module's «Not yet»);
  encrypting `private-docs` at rest on the server (architecture §5.8; owner decision 2026-11-19: the nightly copy now, the server's volume before production; Garage offers only SSE-C, which a signed browser download cannot carry, so the choice is the volume's encryption or downloads through the server).
  The Sentry and PostHog relays for the apps (§16) with the apps' error tracking.
- Production: its `environments/production.env`, a deploy on a release tag, and its own sudoers line.
