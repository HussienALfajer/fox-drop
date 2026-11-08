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
- `FCM_SERVICE_ACCOUNT` (push, architecture §8.1; slice 2.3a): a service account that may only send messages (least privilege, architecture §15). In Google Cloud (project `foxdrop-staging`), **IAM & Admin › Service accounts › Create service account** `push-sender`, with the one role **Firebase Cloud Messaging API Admin**; then its **Keys › Add key › JSON** downloads its key. On the owner's computer, `base64 -w0 <the file>` (PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes('<the file>'))`) gives one line; add `FCM_SERVICE_ACCOUNT=<that line>` to the file, then delete the downloaded key. Never commit it or paste it in a chat. The worker reads it: `docker compose ... up -d worker`, then `docker logs foxdrop-staging-worker-1 2>&1 | grep -i push` shows no «push is not configured». Firebase's **Cloud Messaging API (V1)** must be enabled (Project settings › Cloud Messaging); it is by default.
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

Scan the QR code from WhatsApp on that phone (Linked devices › Link a device) within 3 minutes. It prints `Paired ***NN as sending number <id> (<state>)`; the running `otp-sender` connects it within 10 seconds (`docker logs foxdrop-staging-otp-sender-1 | grep 'otp sender'` shows `otp sender connected`). Pair two numbers or more: the sender sends from the active ones in turn and moves to the next when one stops (architecture §8.3.3 item 11). A new number starts `warming` at 50 codes a day, one step every `otp.sender_warmup_step_days` (3) days, and becomes `active` after 15 days; it sends only when no active number can. OWN reads the pool, its alerts and its counts with `GET /v1/admin/otp-sender-numbers`, sets a number `active` or `standby` with `PUT .../{numberId}/status` (setting a warming number active ends its warm-up) and retires it with `POST .../{numberId}/disable`. A number WhatsApp logs out (`disconnected`) or refuses (`banned`) logs `otp sender number stopped` and reaches Sentry as «رقم إرسال الرموز متوقف»; a pool that cannot send reaches it as «لا يمكن إرسال رموز الدخول». Run the command again for that number: pairing it again replaces its row and resumes its warm-up. The support number of the fixed reply is `SUPPORT_WHATSAPP_NUMBER` in `infra/environments/staging.env`. App Check (architecture §8.3.3 item 1) needs the Firebase project's number in `FIREBASE_PROJECT_NUMBER` there (not a secret) before OWN turns `otp.app_check_required` on, after the apps send the token («App Check» below); without it every code request is refused while the setting is on, and turning it off lets codes through again. Before turning it on: every released app sends the token, the restaurant app on Windows sends `platform: windows` (otherwise it is refused), and the Firebase project of production registers no debug tokens (a debug token passes the check). The server image must stay private on ghcr.io (owner decision 2026-11-06: the WhatsApp library depends on GPL-3.0 code).

## Real numbers for the test restaurant owner and captain

The placeholder seed's test owner (`+963900000001`), cashier (`+963900000002`) and captain (`+963900000003`) have fake numbers. To sign in on real phones (slice 1.14, owner decision 2026-11-07), move each to a real number on the server, never in the repository. The real number goes on standard input, typed at a hidden prompt, so it stays out of the shell history and the process list; it is never printed:

```bash
read -rs -p 'New number (+9639... or +905...): ' number; echo; cd /srv/foxdrop-staging/current/infra && echo "$number" | FOXDROP_RELEASE=$(basename "$(readlink /srv/foxdrop-staging/current)") FOXDROP_HOME=/srv/foxdrop-staging FOXDROP_UID=$(id -u foxdrop-staging) FOXDROP_GID=$(id -g foxdrop-staging) docker compose -p foxdrop-staging --env-file environments/staging.env --env-file /srv/foxdrop-staging/shared/.env run --rm -T api node dist/modules/identity/placeholder-phone-command.js --party merchant --from +963900000001; unset number
```

The same with `--party captain --from +963900000003` for the captain. To move a real number on, pass it as `--from` (it then shows in the history; clear it with `history -d`). The support numbers the apps show («اتصال بالعمليات», RA §5.2 item 3) are `SUPPORT_PHONE_NUMBER` and `SUPPORT_WHATSAPP_NUMBER` in `infra/environments/staging.env`; empty, the apps hide their buttons.

## The staging APKs

Every merge to `main` runs the `staging-apks` job of `.github/workflows/ci.yml` after `verify`: it builds the customer, restaurant and captain apps with `flutter build apk --flavor staging --release`, pointed at `https://<API_HOST of infra/environments/staging.env>`, and keeps each as an artifact of the run for 30 days (`foxdrop-<app>-staging-<run number>`, Android only; owner decisions 2026-11-07). Download them from the run's page (Actions › CI › the run › Artifacts) or with `gh run download <run id> --repo HussienALfajer/fox-drop`. The staging apps have their own IDs (`com.foxdrop.<app>.staging`), so they install beside development builds (`.dev`); Android asks to allow installs from unknown sources.

Each app has its own staging key (architecture §11.4): the secrets `STAGING_<APP>_KEYSTORE` (the PKCS12 key store in base64) and `STAGING_<APP>_KEYSTORE_PASSWORD` of the GitHub `staging` environment, alias `foxdrop`. The owner keeps a copy outside the repository. A new key cannot update an installed app: uninstall the staging app first. A build of the same flavor on a machine without the key is signed with the debug key; never hand it out.

## App Check

The code requests carry a Firebase App Check token (architecture §8.3.3 item 1; `packages/core_auth/CLAUDE.md`). Owner decisions 2026-11-07: one Firebase project for staging now (production gets its own before launch, §11.4), Android only, the configuration as build values (no `google-services.json` or other Firebase file in the repository), the debug provider in debug builds only. The staging APKs are installed outside Google Play, so Play Integrity never gives them `PLAY_RECOGNIZED`: the project must not require it.

The owner's steps, once (in the Firebase and Google Cloud consoles, signed in as the owner):

1. Create the Firebase project `foxdrop-staging` (Google Analytics off). Its **Project settings › General** shows the project ID and the project number.
2. Add three Android apps with the package names `com.foxdrop.customer.staging`, `com.foxdrop.merchant.staging` and `com.foxdrop.captain.staging`. Skip downloading `google-services.json` and the SDK steps; never commit that file. Each app's settings show its **App ID** (`1:<number>:android:<hex>`). The API key is the one Firebase creates for Android apps: Google Cloud › **APIs & Services › Credentials**, «Android key (auto created by Firebase)» (a project with no web app shows no Web API key in its settings). Leave its restrictions as Firebase made them.
3. Give each app the SHA-256 of its staging key (**Project settings › Your apps › Add fingerprint**): download a staging APK from a CI run and run `apksigner verify --print-certs app-staging-release.apk` (Android SDK build-tools), or `keytool -list -v -keystore <the app's key store> -alias foxdrop` on the owner's copy.
4. In Google Cloud (the same project), **APIs & Services › Enable APIs and services**: enable **Google Play Integrity API** (apps outside Google Play enable it here instead of linking in Play Console).
5. **Security › App Check › Apps**: register each Android app with **Play Integrity**; in its settings require neither `PLAY_RECOGNIZED` nor `LICENSED`, and set the minimum device integrity to **Device integrity** (Firebase's settings for apps distributed outside Google Play). Leave **Enforcement** of Firebase's own services alone: the FOX DROP server does its own check.
6. Send the project ID and the project number to Claude, which sets `FIREBASE_PROJECT_ID` and `FIREBASE_PROJECT_NUMBER` in `infra/environments/staging.env` through a pull request (both public); its merge deploys the server with the number.
7. After that merge, GitHub › the repository › **Settings › Environments › staging**: the variables `STAGING_FIREBASE_CUSTOMER_APP_ID`, `STAGING_FIREBASE_MERCHANT_APP_ID` and `STAGING_FIREBASE_CAPTAIN_APP_ID` (the App IDs) and the secret `STAGING_FIREBASE_API_KEY`. In this order: an App ID without the project values fails the `staging-apks` job. The next merge to `main` (or re-running the last run's `staging-apks` job) builds APKs that send tokens.

The `staging-apks` job also passes `UPDATE_URL` from the variable `STAGING_<APP>_UPDATE_URL` (`CUSTOMER`, `MERCHANT`, `CAPTAIN`): where the update screen's button leads (RA §4.2, `packages/core_platform/CLAUDE.md`); unset, the button is hidden. The `staging-apks` job passes `FIREBASE_APP_ID`, `FIREBASE_PROJECT_ID`, `FIREBASE_PROJECT_NUMBER` and `FIREBASE_API_KEY` as `--dart-define`; without the app's App ID it builds without App Check and warns, and with the App ID but a missing project value or key it fails. A debug build of the staging flavor started with the same four values (`flutter run --flavor staging --dart-define=...`; the default `development` flavor's `.dev` ID is not registered in the project) uses the debug provider: it prints a debug token in `adb logcat` (`DebugAppCheckProvider`), which the owner adds under **App Check › Apps › the app › Manage debug tokens** for that device only; never register one in the production project.

Staging has it on since 2026-11-07 (owner decision, after a sign-in from one phone; the Azaz check is still due). Turn the check on only after staging APKs from a run with the values sign in from phones in Azaz, on each mobile network (architecture §22 item 9: whether Syria reaches App Check's Google services is still to check); the server answers their code requests while the setting is off too. Play Integrity needs Google Play services, so a phone without them can never pass the check once it is on: OWN sets `otp.app_check_required` to `true`. Until the panel has its settings screen: sign in to the staging panel as OWN, open the browser's console on that tab and run `await fetch('/v1/admin/settings/otp.app_check_required', { method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ value: true }) }).then((r) => r.json())` (the session cookie is the panel's, so the call runs as OWN and is audited); `value: false` turns it off. Then a code request without a token answers `403 app_check_failed`, which can be checked with `curl -i -X POST https://<API_HOST>/v1/captain/auth/code -H 'Content-Type: application/json' -d '{"phone":"+963900000000","deviceId":"00000000-0000-4000-8000-000000000000"}'`. If the apps stop getting codes, turn the setting off: codes go out again at once.

## Check an order's money in the ledger

`infra/server/check-order-ledger.sql` checks a delivered order's journals against AP §8.4 and lists its entries (read-only; the owner's run in `docs/runbooks/staging-cycle.md`). As root on the server, with the order's number:

```bash
docker exec -i foxdrop-staging-postgres-1 psql -U postgres -d fox_drop -v number=<order number> < /srv/foxdrop-staging/current/infra/server/check-order-ledger.sql
```

## Restore a backup

1. Copy the dump back, if it is not in `/var/backups/foxdrop-staging/`: set the `RCLONE_CONFIG_FOXDROP*` variables as `backup.sh` does, then `rclone copyto foxdropcrypt:<name> /var/backups/foxdrop-staging/<name>`.
2. Try it on a throwaway database first: `docker run -d --name foxdrop-restore-test -e POSTGRES_PASSWORD=x <the postgis image>`, then `docker exec -i foxdrop-restore-test pg_restore --username postgres --dbname postgres --create --no-owner --no-privileges < <dump>` and check the tables; remove the container.
3. Replacing staging's database stops staging and is destructive: ask the owner first. Stop OSRM before `docker compose down` on an environment (`docker compose --project-name foxdrop-osrm --project-directory /srv/foxdrop-osrm stop`, then `up --detach` after): `down` tries to remove the environment's OSRM network.
