# Secrets

Read when the task needs it; the short rules are in `SKILL.md`.

## Secrets

`/srv/foxdrop-staging/shared/.env` holds the database, Valkey and encryption secrets that `provision.sh` generated; never print them. The owner fills in, by editing the file on the server (`nano`, as root):

- `SENTRY_DSN`: the DSN of the Sentry project for the server (EU region). The next deploy or `docker compose ... up -d` picks it up.
- `FCM_SERVICE_ACCOUNT` (push, architecture §8.1; slice 2.3a): a service account that may only send messages (least privilege, architecture §15). In Google Cloud (project `foxdrop-staging`), **IAM & Admin › Service accounts › Create service account** `push-sender`, with the one role **Firebase Cloud Messaging API Admin**; then its **Keys › Add key › JSON** downloads its key. On the owner's computer, `base64 -w0 <the file>` (PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes('<the file>'))`) gives one line; add `FCM_SERVICE_ACCOUNT=<that line>` to the file, then delete the downloaded key. Never commit it or paste it in a chat. The worker reads it: `docker compose ... up -d worker`, then `docker logs foxdrop-staging-worker-1 2>&1 | grep -i push` shows no «push is not configured». Firebase's **Cloud Messaging API (V1)** must be enabled (Project settings › Cloud Messaging); it is by default.
- `B2_ACCOUNT_ID`, `B2_APPLICATION_KEY`, `B2_BUCKET`: a Backblaze B2 application key limited to that bucket.
- `BACKUP_ENCRYPTION_PASSWORD`: a long random password, also kept in the owner's password manager. Without it the backups in B2 cannot be read.

After a change, check with `systemctl start foxdrop-backup@staging && journalctl -t foxdrop-backup -n 20`.
