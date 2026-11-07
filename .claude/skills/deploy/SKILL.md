---
name: deploy
description: Deploy, roll back, provision or inspect a FOX DROP environment on the owner's Contabo server (staging now), and handle its secrets, backups and restores. Use for anything about staging, the deploy job, the server's FOX DROP containers, nginx site or backups.
---

# Deploy FOX DROP

Read `infra/CLAUDE.md` for the layout and rules, and the `vertex-server` skill before touching the server (`ssh vertex`, root). Stop and ask the owner before any production deploy, anything destructive (a volume, a database, a release folder), or a change to another site on the server.

## Staging at a glance

| What             | Where                                                                                                                                                |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Panel            | `https://foxdrop-staging-admin.109-199-111-169.sslip.io`                                                                                             |
| Portal           | `https://foxdrop-staging-portal.109-199-111-169.sslip.io`                                                                                            |
| API for the apps | `https://foxdrop-staging-api.109-199-111-169.sslip.io/v1/`                                                                                           |
| Files            | `/srv/foxdrop-staging/` (user `foxdrop-staging`): `repo.git`, `releases/<commit>`, `current`, `previous`, `shared/.env` (secrets, 600), `shared/db/` |
| Compose project  | `foxdrop-staging` (`docker ps --filter label=com.docker.compose.project=foxdrop-staging`)                                                            |
| Logs             | `docker logs foxdrop-staging-api-1`; a failed deploy's logs in `journalctl -t foxdrop-deploy`; nginx in `/var/log/nginx/foxdrop-staging.*.log`       |
| Backups          | `/var/backups/foxdrop-staging/` (7 days), encrypted copies in B2 (30 days); `journalctl -t foxdrop-backup`                                           |

## Deploy

Every merge to `main` deploys staging: the `deploy-staging` job in `.github/workflows/ci.yml` builds and pushes both images tagged with the commit, then runs `ssh foxdrop-deploy@<host> "staging <commit>"`. The key (the `staging` GitHub environment, `main` only) can run nothing but `infra/server/deploy-ssh.sh`, which calls `foxdrop-deploy` through sudo.

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

It creates the users, folders, mirror and secrets if missing, installs the scripts, the sudoers rule, the nginx site (tested with `nginx -t` and disabled again if it fails), the certificate, the backup timer and the shared OSRM. It never touches the database, the releases or a secret already there; it appends a secret a later commit added, such as the Centrifugo ones. Record what changed in `/root/SERVER.md`.

A new environment needs two runs: the first ends at the OSRM step ("skipped"), because its `foxdrop-osrm-<env>` network appears only with its first deploy; deploy, then run it again.

## OSRM (shared by every environment)

One Compose project, `foxdrop-osrm`, in `/srv/foxdrop-osrm` (copied from `infra/osrm/` by `provision.sh`): four routed services over Azaz's region, about 15 MB each. Each environment's server containers reach them on that environment's `foxdrop-osrm-<env>` network as `http://osrm-<vehicle>:5000`; while they are down, the API measures the straight line × 1.3.

- **Build:** `provision.sh` builds the data on its first run (several minutes: the 82 MB Syria extract, the cut, four profiles); `foxdrop-osrm-build.timer` rebuilds it every Monday at 04:30 and restarts the services. By hand, as root: `foxdrop-osrm-build`. The cut peaks at about 1.5 GB of memory for a minute.
- **Status and logs:** `docker ps --filter label=com.docker.compose.project=foxdrop-osrm`; `journalctl -u foxdrop-osrm-build`; `docker logs foxdrop-osrm-osrm-car-1`.
- **A failed build** leaves the running data in place (the new data is swapped in only after all four profiles build).

## Secrets

`/srv/foxdrop-staging/shared/.env` holds the database, Valkey and encryption secrets that `provision.sh` generated; never print them. The owner fills in, by editing the file on the server (`nano`, as root):

- `SENTRY_DSN`: the DSN of the Sentry project for the server (EU region). The next deploy or `docker compose ... up -d` picks it up.
- `B2_ACCOUNT_ID`, `B2_APPLICATION_KEY`, `B2_BUCKET`: a Backblaze B2 application key limited to that bucket.
- `BACKUP_ENCRYPTION_PASSWORD`: a long random password, also kept in the owner's password manager. Without it the backups in B2 cannot be read.

After a change, check with `systemctl start foxdrop-backup@staging && journalctl -t foxdrop-backup -n 20`.

## The first owner account

```bash
cd /srv/foxdrop-staging/current/infra && FOXDROP_RELEASE=$(basename "$(readlink /srv/foxdrop-staging/current)") FOXDROP_HOME=/srv/foxdrop-staging FOXDROP_UID=$(id -u foxdrop-staging) FOXDROP_GID=$(id -g foxdrop-staging) docker compose -p foxdrop-staging --env-file environments/staging.env --env-file /srv/foxdrop-staging/shared/.env run --rm api node dist/modules/identity/create-owner-command.js --email <owner email>
```

It prints a one-time setup link: give it to the owner only.

## Pair a sending WhatsApp number

The sign-in codes go out from a dedicated number (architecture §8.3.3 items 4–5), never a personal or the support one. The owner runs this in an interactive `ssh vertex` terminal (`-it`, so the QR code shows), with the number's phone at hand:

```bash
cd /srv/foxdrop-staging/current/infra && FOXDROP_RELEASE=$(basename "$(readlink /srv/foxdrop-staging/current)") FOXDROP_HOME=/srv/foxdrop-staging FOXDROP_UID=$(id -u foxdrop-staging) FOXDROP_GID=$(id -g foxdrop-staging) docker compose -p foxdrop-staging --env-file environments/staging.env --env-file /srv/foxdrop-staging/shared/.env run --rm -it otp-sender node dist/modules/identity/otp-sender-pair-command.js
```

Scan the QR code from WhatsApp on that phone (Linked devices › Link a device) within 3 minutes. It prints `Paired ***NN as sending number <id> (<state>)`; the running `otp-sender` connects it within 10 seconds (`docker logs foxdrop-staging-otp-sender-1 | grep 'otp sender'` shows `otp sender connected`). Pair two numbers or more: the sender sends from the active ones in turn and moves to the next when one stops (architecture §8.3.3 item 11). A new number starts `warming` at 50 codes a day, one step every `otp.sender_warmup_step_days` (3) days, and becomes `active` after 15 days; it sends only when no active number can. OWN reads the pool, its alerts and its counts with `GET /v1/admin/otp-sender-numbers`, sets a number `active` or `standby` with `PUT .../{numberId}/status` (setting a warming number active ends its warm-up) and retires it with `POST .../{numberId}/disable`. A number WhatsApp logs out (`disconnected`) or refuses (`banned`) logs `otp sender number stopped` and reaches Sentry as «رقم إرسال الرموز متوقف»; a pool that cannot send reaches it as «لا يمكن إرسال رموز الدخول». Run the command again for that number: pairing it again replaces its row and resumes its warm-up. The support number of the fixed reply is `SUPPORT_WHATSAPP_NUMBER` in `infra/environments/staging.env`. App Check (architecture §8.3.3 item 1) needs the Firebase project's number in `FIREBASE_PROJECT_NUMBER` there (not a secret) before OWN turns `otp.app_check_required` on, after the apps send the token (slice 1.14); without it every code request is refused while the setting is on, and turning it off lets codes through again. Before turning it on: every released app sends the token, the restaurant app on Windows sends `platform: windows` (otherwise it is refused), and the Firebase project of production registers no debug tokens (a debug token passes the check). The server image must stay private on ghcr.io (owner decision 2026-11-06: the WhatsApp library depends on GPL-3.0 code).

## Real numbers for the test restaurant owner and captain

The placeholder seed's test owner (`+963900000001`), cashier (`+963900000002`) and captain (`+963900000003`) have fake numbers. To sign in on real phones (slice 1.14, owner decision 2026-11-07), move each to a real number on the server, never in the repository; the numbers are not printed:

```bash
cd /srv/foxdrop-staging/current/infra && FOXDROP_RELEASE=$(basename "$(readlink /srv/foxdrop-staging/current)") FOXDROP_HOME=/srv/foxdrop-staging FOXDROP_UID=$(id -u foxdrop-staging) FOXDROP_GID=$(id -g foxdrop-staging) docker compose -p foxdrop-staging --env-file environments/staging.env --env-file /srv/foxdrop-staging/shared/.env run --rm api node dist/modules/identity/placeholder-phone-command.js --party merchant --from +963900000001 --to <owner's real number>
```

The same with `--party captain --from +963900000003` for the captain. Run it again with the real number as `--from` to move it on. The support numbers the apps show («اتصال بالعمليات», RA §5.2 item 3) are `SUPPORT_PHONE_NUMBER` and `SUPPORT_WHATSAPP_NUMBER` in `infra/environments/staging.env`; empty, the apps hide their buttons.

## The staging APKs

Every merge to `main` runs the `staging-apks` job of `.github/workflows/ci.yml` after `verify`: it builds the customer, restaurant and captain apps with `flutter build apk --flavor staging --release`, pointed at `https://<API_HOST of infra/environments/staging.env>`, and keeps each as an artifact of the run for 30 days (`foxdrop-<app>-staging-<run number>`, Android only; owner decisions 2026-11-07). Download them from the run's page (Actions › CI › the run › Artifacts) or with `gh run download <run id> --repo HussienALfajer/fox-drop`. The staging apps have their own IDs (`com.foxdrop.<app>.staging`), so they install beside development builds (`.dev`); Android asks to allow installs from unknown sources.

Each app has its own staging key (architecture §11.4): the secrets `STAGING_<APP>_KEYSTORE` (the PKCS12 key store in base64) and `STAGING_<APP>_KEYSTORE_PASSWORD` of the GitHub `staging` environment, alias `foxdrop`. The owner keeps a copy outside the repository. A new key cannot update an installed app: uninstall the staging app first. A build of the same flavor on a machine without the key is signed with the debug key; never hand it out.

## Restore a backup

1. Copy the dump back, if it is not in `/var/backups/foxdrop-staging/`: set the `RCLONE_CONFIG_FOXDROP*` variables as `backup.sh` does, then `rclone copyto foxdropcrypt:<name> /var/backups/foxdrop-staging/<name>`.
2. Try it on a throwaway database first: `docker run -d --name foxdrop-restore-test -e POSTGRES_PASSWORD=x <the postgis image>`, then `docker exec -i foxdrop-restore-test pg_restore --username postgres --dbname postgres --create --no-owner --no-privileges < <dump>` and check the tables; remove the container.
3. Replacing staging's database stops staging and is destructive: ask the owner first. Stop OSRM before `docker compose down` on an environment (`docker compose --project-name foxdrop-osrm --project-directory /srv/foxdrop-osrm stop`, then `up --detach` after): `down` tries to remove the environment's OSRM network.
