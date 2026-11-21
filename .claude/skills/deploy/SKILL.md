---
name: deploy
description: Deploy, roll back, provision or inspect a FOX DROP environment on the owner's Contabo server (staging now), and handle its secrets, backups and restores. Use for anything about staging, the deploy job, the server's FOX DROP containers, nginx site or backups.
---

# Deploy FOX DROP

Read `infra/CLAUDE.md` for the layout and rules, and the `vertex-server` skill before touching the server (`ssh vertex`, root). Stop and ask the owner before any production deploy, anything destructive (a volume, a database, a release folder), or a change to another site on the server.

## Staging at a glance

| What             | Where                                                                                                                                                 |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Panel            | `https://foxdrop-staging-admin.109-199-111-169.sslip.io`                                                                                              |
| Portal           | `https://foxdrop-staging-portal.109-199-111-169.sslip.io`                                                                                             |
| API for the apps | `https://foxdrop-staging-api.109-199-111-169.sslip.io/v1/`                                                                                            |
| Files            | `/srv/foxdrop-staging/` (user `foxdrop-staging`): `repo.git`, `releases/<commit>`, `current`, `previous`, `shared/.env` (secrets, 600), `shared/db/`  |
| Compose project  | `foxdrop-staging` (`docker ps --filter label=com.docker.compose.project=foxdrop-staging`)                                                             |
| Logs             | `docker logs foxdrop-staging-api-1`; a failed deploy's logs in `journalctl -t foxdrop-deploy`; nginx in `/var/log/nginx/foxdrop-staging.*.log`        |
| Backups          | `/var/backups/foxdrop-staging/` (7 days), encrypted copies in B2 (30 days); `journalctl -t foxdrop-backup`                                            |
| Images           | Garage (`foxdrop-staging-storage-1`, volume `foxdrop-staging_storage-data`), imgproxy behind `/media/` on every host, its cache in `/var/cache/nginx` |

## Deploy

What each merged slice needs before or after its deploy (a migration, a new variable, a provisioning run, what to check) is under «Before deploying» and «To check on staging» in its section of `docs/slice-notes.md`: grep it for the slices since the last deploy.

Every merge to `main` that changes more than Markdown and `docs/` deploys staging: the `deploy-staging` job in `.github/workflows/ci.yml` builds and pushes both images tagged with the commit, then runs `ssh foxdrop-deploy@<host> "staging <commit>"`. The key (the `staging` GitHub environment, `main` only) can run nothing but `infra/server/deploy-ssh.sh`, which calls `foxdrop-deploy` through sudo.

`foxdrop-deploy` (`infra/server/deploy.sh`) takes the commit's `infra/` and `apps/server/db/` from the mirror, pulls the images, starts the database, runs the migrations, starts the release and waits for it to be healthy. If it is not, it starts the previous release again and fails. By hand, as root on the server:

```bash
foxdrop-deploy staging <full commit on main>
```

## Roll back

```bash
foxdrop-deploy staging rollback
```

Starts the previous release without migrating. Migrations are never reversed, which is why each must be backward compatible (architecture §17.3).

## Provision (first time, or after a change under `infra/nginx` or `infra/server`)

From a commit on `main` (the provision script lives in the commit it installs):

```bash
commit=$(git rev-parse origin/main)
git archive "$commit" infra | ssh vertex "rm -rf /root/foxdrop-provision && mkdir /root/foxdrop-provision && tar -x -C /root/foxdrop-provision && /root/foxdrop-provision/infra/server/provision.sh staging"
```

It creates the users, folders, mirror and secrets if missing, installs the scripts, the sudoers rule, the nginx site (tested with `nginx -t` and disabled again if it fails), the certificate, the backup timer, the map (`foxdrop-maps-build <env> --if-missing`, `docs/runbooks/maps.md`) and the shared OSRM. It never touches the database, the releases or a secret already there; it appends a secret a later commit added, such as the Centrifugo ones. Record what changed in `/root/SERVER.md`.

A new environment needs two runs: the first ends at the OSRM step ("skipped"), because its `foxdrop-osrm-<env>` network appears only with its first deploy; deploy, then run it again.

## Reference files

Read the one the task needs (in `.claude/skills/deploy/references/`); each is a section that used to sit here.

| File                        | Read for                                                                                                       |
| --------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `osrm-storage.md`           | The shared OSRM (build, status, a failed build); Garage and imgproxy (containers, secrets first, check, cache) |
| `secrets.md`                | `SENTRY_DSN`, `FCM_SERVICE_ACCOUNT`, B2 and the backup password in `shared/.env`                               |
| `accounts.md`               | The first owner account; pairing a sending WhatsApp number; real numbers for the test owner and captain        |
| `android-windows-builds.md` | The `staging-apks` job and its keys; the Windows installer, its feed key, unsigned install and PC pairing      |
| `ios-builds.md`             | `staging-ios`, TestFlight, the owner's Apple and Firebase steps, Critical Alerts                               |
| `app-check.md`              | Firebase App Check setup, the debug provider, turning `otp.app_check_required` on or off                       |
| `restore-and-checks.md`     | Checking an order's money in the ledger; restoring files and the database from a backup                        |
