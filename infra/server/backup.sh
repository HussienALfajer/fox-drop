#!/usr/bin/env bash
# Backs up one FOX DROP environment's database (architecture §17.2), installed
# as /usr/local/bin/foxdrop-backup by provision.sh and run nightly by
# foxdrop-backup@<environment>.timer:
#   foxdrop-backup <environment>
# A custom-format pg_dump, checked by pg_restore, kept 7 days in
# /var/backups/foxdrop-<environment>, and copied encrypted (rclone crypt) to
# Backblaze B2, where copies older than 30 days are deleted. The B2 key and
# the encryption password are in the environment's shared/.env; without them
# the local copy is still made and the run fails, so the journal shows it.
set -euo pipefail

die() {
  echo "foxdrop-backup: $*" >&2
  exit 1
}

environment=${1:-}
[[ $environment =~ ^(staging|production)$ ]] || die "unknown environment '$environment'"
home=/srv/foxdrop-$environment
dir=/var/backups/foxdrop-$environment

postgres=$(docker ps --quiet \
  --filter "label=com.docker.compose.project=foxdrop-$environment" \
  --filter label=com.docker.compose.service=postgres)
[ -n "$postgres" ] || die "the foxdrop-$environment database is not running"

umask 077
name=fox_drop-$environment-$(date -u +%Y%m%dT%H%M%SZ).dump
docker exec "$postgres" pg_dump --username postgres --dbname fox_drop --format custom >"$dir/$name.partial"
docker exec --interactive "$postgres" pg_restore --list <"$dir/$name.partial" >/dev/null ||
  die "the dump does not read back"
mv "$dir/$name.partial" "$dir/$name"
find "$dir" -maxdepth 1 -name '*.dump' -mtime +7 -delete
echo "saved $dir/$name ($(du -h "$dir/$name" | cut -f1))"

B2_ACCOUNT_ID=$(sed -n 's/^B2_ACCOUNT_ID=//p' "$home/shared/.env")
B2_APPLICATION_KEY=$(sed -n 's/^B2_APPLICATION_KEY=//p' "$home/shared/.env")
B2_BUCKET=$(sed -n 's/^B2_BUCKET=//p' "$home/shared/.env")
BACKUP_ENCRYPTION_PASSWORD=$(sed -n 's/^BACKUP_ENCRYPTION_PASSWORD=//p' "$home/shared/.env")
if [ -z "$B2_ACCOUNT_ID" ] || [ -z "$B2_APPLICATION_KEY" ] || [ -z "$B2_BUCKET" ] ||
  [ -z "$BACKUP_ENCRYPTION_PASSWORD" ]; then
  die "no off-server copy: set B2_ACCOUNT_ID, B2_APPLICATION_KEY, B2_BUCKET and BACKUP_ENCRYPTION_PASSWORD in $home/shared/.env"
fi

# rclone remotes from the environment, so no key is written to a file.
export RCLONE_CONFIG_FOXDROPB2_TYPE=b2
export RCLONE_CONFIG_FOXDROPB2_ACCOUNT=$B2_ACCOUNT_ID
export RCLONE_CONFIG_FOXDROPB2_KEY=$B2_APPLICATION_KEY
export RCLONE_CONFIG_FOXDROPB2_HARD_DELETE=true
export RCLONE_CONFIG_FOXDROPCRYPT_TYPE=crypt
export RCLONE_CONFIG_FOXDROPCRYPT_REMOTE=foxdropb2:$B2_BUCKET/$environment
RCLONE_CONFIG_FOXDROPCRYPT_PASSWORD=$(rclone obscure - <<<"$BACKUP_ENCRYPTION_PASSWORD")
export RCLONE_CONFIG_FOXDROPCRYPT_PASSWORD

rclone copyto "$dir/$name" "foxdropcrypt:$name"
rclone delete --min-age 30d foxdropcrypt:
echo "copied $name to B2 bucket $B2_BUCKET, encrypted"
