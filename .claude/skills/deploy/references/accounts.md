# Accounts and numbers on the server

Read when the task needs it; the short rules are in `SKILL.md`.

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

Scan the QR code from WhatsApp on that phone (Linked devices › Link a device) within 3 minutes. It prints `Paired ***NN as sending number <id> (<state>)`; the running `otp-sender` connects it within 10 seconds (`docker logs foxdrop-staging-otp-sender-1 | grep 'otp sender'` shows `otp sender connected`). Pair two numbers or more: the sender sends from the active ones in turn and moves to the next when one stops (architecture §8.3.3 item 11). A new number starts `warming` at 50 codes a day, one step every `otp.sender_warmup_step_days` (3) days, and becomes `active` after 15 days; it sends only when no active number can. OWN reads the pool, its alerts and its counts with `GET /v1/admin/otp-sender-numbers`, sets a number `active` or `standby` with `PUT .../{numberId}/status` (setting a warming number active ends its warm-up) and retires it with `POST .../{numberId}/disable`. A number WhatsApp logs out (`disconnected`) or refuses (`banned`) logs `otp sender number stopped` and reaches Sentry as «رقم إرسال الرموز متوقف»; a pool that cannot send reaches it as «لا يمكن إرسال رموز الدخول». Run the command again for that number: pairing it again replaces its row and resumes its warm-up. The support number of the fixed reply is `SUPPORT_WHATSAPP_NUMBER` in `infra/environments/staging.env`. App Check (architecture §8.3.3 item 1) needs the Firebase project's number in `FIREBASE_PROJECT_NUMBER` there (not a secret) before OWN turns `otp.app_check_required` on, after the apps send the token (`app-check.md`); without it every code request is refused while the setting is on, and turning it off lets codes through again. Before turning it on: every released app sends the token, the restaurant app on Windows sends `platform: windows` and its registration's signature (otherwise it is refused: every PC must be paired first), and the Firebase project of production registers no debug tokens (a debug token passes the check). The server image must stay private on ghcr.io (owner decision 2026-11-06: the WhatsApp library depends on GPL-3.0 code).

## Real numbers for the test restaurant owner and captain

The placeholder seed's test owner (`+963900000001`), cashier (`+963900000002`) and captain (`+963900000003`) have fake numbers. To sign in on real phones (slice 1.14, owner decision 2026-11-07), move each to a real number on the server, never in the repository. The real number goes on standard input, typed at a hidden prompt, so it stays out of the shell history and the process list; it is never printed:

```bash
read -rs -p 'New number (+9639... or +905...): ' number; echo; cd /srv/foxdrop-staging/current/infra && echo "$number" | FOXDROP_RELEASE=$(basename "$(readlink /srv/foxdrop-staging/current)") FOXDROP_HOME=/srv/foxdrop-staging FOXDROP_UID=$(id -u foxdrop-staging) FOXDROP_GID=$(id -g foxdrop-staging) docker compose -p foxdrop-staging --env-file environments/staging.env --env-file /srv/foxdrop-staging/shared/.env run --rm -T api node dist/modules/identity/placeholder-phone-command.js --party merchant --from +963900000001; unset number
```

The same with `--party captain --from +963900000003` for the captain. To move a real number on, pass it as `--from` (it then shows in the history; clear it with `history -d`). The support numbers the apps show («اتصال بالعمليات», RA §5.2 item 3) are `SUPPORT_PHONE_NUMBER` and `SUPPORT_WHATSAPP_NUMBER` in `infra/environments/staging.env`; empty, the apps hide their buttons.
