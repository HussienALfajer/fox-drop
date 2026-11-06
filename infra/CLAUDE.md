# infra

How FOX DROP runs on the owner's shared Contabo server (architecture §17, T9, E8). The `deploy` skill (`.claude/skills/deploy/SKILL.md`) is the runbook: deploy, rollback, provisioning, secrets, backups and restores. Read the `vertex-server` skill and `/root/SERVER.md` on the server before any work there.

## Layout

- `compose.yaml`: one environment's Compose project (the database, Valkey, the migrations, the four server roles and the web container). Its images are the commit's `ghcr.io/hussienalfajer/fox-drop-server` and `fox-drop-web`.
- `environments/<env>.env`: an environment's public settings (host names, loopback ports). Its secrets live only on the server, in `/srv/foxdrop-<env>/shared/.env`.
- `centrifugo/config.yaml`: Centrifugo's channels (architecture §6), the same in every environment and in the server's tests; its secrets and subscription proxies come from the environment.
- `osrm/`: the shared OSRM (architecture §7.1): its Compose project `foxdrop-osrm`, `cut.sh` (downloads the Syria extract and cuts Azaz's region with osmium), `build.sh` (builds the car, motorbike, bicycle and walking profiles), `motorbike.lua` and the cut image. The root `compose.yaml` runs the same scripts locally.
- `web/`: the image of the panel and the portal (an unprivileged nginx that answers unknown paths with `index.html`) and its smoke test.
- `nginx/`: the server's nginx site, snippets and limit zones; `*.template` files are rendered per environment by `provision.sh`.
- `server/`: `provision.sh` (prepares an environment, run as root), `deploy.sh` (`foxdrop-deploy`), `deploy-ssh.sh` (the only command the GitHub Actions key may run), `backup.sh` (`foxdrop-backup`) and its systemd timer, `osrm-build.sh` (`foxdrop-osrm-build`) and its weekly timer, and the deploy key's public half.
- `infra.test.mjs`: the rules below that a machine can check, run by `pnpm verify`.

## Rules

- **Nothing public but nginx (§15.5):** every published port is `127.0.0.1:<port>`; Docker bypasses the firewall. The server's other sites use ports 3000 to 3073; FOX DROP staging uses 3110 to 3113 (3113 is Centrifugo, behind nginx's `/connection/websocket`).
- **One hop of proxy:** nginx sets `X-Forwarded-For $remote_addr` (replacing), and the API trusts exactly one hop (`trustProxy: 1` in `apps/server/src/http/create-api-app.ts`). Never `$proxy_add_x_forwarded_for`, never `trustProxy: true`.
- **Isolation (§17.2):** each environment has its own system user (`foxdrop-<env>`, which the server containers run as), Compose project, network, volume, database, environment file and certificate. FOX DROP never uses the server's own PostgreSQL or Redis.
- **Memory limits** on every container: the server is shared with the owner's other sites (§22 item 10).
- **Migrations** run in `deploy.sh` before the new release starts, and must stay backward compatible: a failed start brings the previous release back on the migrated database.
- **Edit here, never on the server.** A change under `nginx/` or `server/` reaches the server only by running `provision.sh` again (the `deploy` skill); `compose.yaml` and `environments/` reach it with the next deploy.
- **Secrets** are generated on the server by `provision.sh` and never printed; a secret added later (the Centrifugo ones) is appended by its next run when its line is missing, so run it before the deploy that needs it; the owner adds the Sentry DSN and the backup keys there. No secret in this folder: `server/deploy-key.pub` is the public half.
- The postgis image here and in the root `compose.yaml` stay the same, and so do the OSRM images (a test).
- **One OSRM for every environment (§17, owner decision 2026-11-06):** `provision.sh` copies `osrm/` to `/srv/foxdrop-osrm`, builds the data on the first run (`foxdrop-osrm-build --if-missing`) and enables the weekly rebuild (Mondays 04:30), which downloads fresh OSM data and restarts the routed services; for those few seconds the API measures the straight line × 1.3. A change under `osrm/` reaches the server only by running `provision.sh` again; then run `foxdrop-osrm-build` for a new region or profile.
- **The `foxdrop-osrm-<env>` networks:** each environment's `compose.yaml` declares its own (so its first deploy creates it, a deploy never needs OSRM, and staging never reaches production's containers), and the OSRM project's routed services join every one as external; a new environment adds its network to `osrm/compose.yaml` (a test). `provision.sh` skips OSRM until the network exists. Never change that declaration (a test pins it): Compose refuses an existing network whose declaration changed. Never `docker compose down` an environment while OSRM runs: Compose would try to remove its network; stop OSRM first (the `deploy` skill).
- `nginx` on the server is 1.24: `listen 443 ssl http2;`, not `http2 on;`.

## Not yet

- **Trust boundary:** `foxdrop-deploy` runs, as root, the `compose.yaml` of a commit on `main` with images from ghcr.io. Whoever can merge to `main` or push those images can act as root on the shared server; the forced command limits which commit deploys, not what it does.
- Staging's B2 key may delete, to prune copies older than 30 days. Production's key must not: a B2 lifecycle rule prunes instead, so root on the shared server cannot erase the off-site copies.
- Staging backs up with a nightly `pg_dump`; production needs the continuous WAL archiving of §17.2 (pgBackRest) and a tested restore before launch.
- Centrifugo joins `compose.yaml` in slice 1.9's second pull request, after `provision.sh` has added its secrets and its nginx route on the server; imgproxy and the object storage join with their first use; the Sentry and PostHog relays for the apps (§16) with the apps' error tracking.
- Production: its `environments/production.env`, a deploy on a release tag, and its own sudoers line.
