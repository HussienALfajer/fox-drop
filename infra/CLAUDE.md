# infra

How FOX DROP runs on the owner's shared Contabo server (architecture §17, T9, E8). The `deploy` skill (`.claude/skills/deploy/SKILL.md`) is the runbook; read the `vertex-server` skill before any work on the server.

## Rules

- **Layout:** `compose.yaml` is one environment's Compose project; `environments/<env>.env` holds public settings only; `nginx/` (`*.template` rendered per environment by `provision.sh`), `server/` (provision, deploy, backup scripts), `osrm/`, `maps/`, `storage/`, `imgproxy/`, `centrifugo/`, `web/`. `infra.test.mjs` checks the machine-checkable rules below in `pnpm verify`.
- **Edit here, never on the server.** A change under `nginx/` or `server/` reaches the server only by running `provision.sh` again; `compose.yaml` and `environments/` reach it with the next deploy.
- **Nothing public but nginx (§15.5):** publish every port as `127.0.0.1:<port>`; Docker bypasses the firewall. Staging uses ports 3110 to 3116.
- **One hop of proxy:** nginx sets `X-Forwarded-For $remote_addr`, and the API trusts exactly one hop (`trustProxy: 1`). Never `$proxy_add_x_forwarded_for`, never `trustProxy: true`.
- **Isolation (§17.2):** each environment has its own system user, Compose project, network, volume, database, environment file and certificate. Never use the server's own PostgreSQL or Redis.
- **Memory limits** on every container: the server is shared with the owner's other sites.
- **Migrations** run in `deploy.sh` before the new release starts and must stay backward compatible: a failed start brings the previous release back on the migrated database.
- **Secrets** are generated on the server by `provision.sh` and never printed; a secret added later is appended by its next run, so run it before the deploy that needs it. No secret in this folder.
- **Keys:** only the API, the worker and `maps-publish` hold the storage server key, only imgproxy the reader key, no container the backup key; the reader has no right on `private-docs` (a test).
- **Pinned together (a test):** the postgis image here and in the root `compose.yaml`, and the OSRM, Garage and imgproxy images. imgproxy's preset widths equal the apps' (`apps/admin/src/media.ts`, `apps/customer/lib/src/media.dart`).
- **OSRM networks:** each environment's `compose.yaml` declares its own `foxdrop-osrm-<env>` network and OSRM's project joins it as external; a new environment adds its network to `osrm/compose.yaml`. Never change that declaration (Compose refuses an existing network whose declaration changed). Never `docker compose down` an environment while OSRM runs; stop OSRM first.
- **The map:** `maps-build` downloads from outside, so it runs on its own `maps-build` network, never the environment's (a test); only `maps-publish` writes `public-maps`.
- **Backups:** `backup.sh` never deletes off-site copies of the images (a key is never reused); the 30-day pruning touches only the dumps.
- **nginx 1.24:** write `listen 443 ssl http2;`, not `http2 on;`.

## More

Behaviour, decisions and slice history: `docs/code/infra.md`. Grep it for the feature, route, table or label you are changing and read only those lines; never read it whole.
