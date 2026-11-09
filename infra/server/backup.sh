#!/usr/bin/env bash
# Backs up one FOX DROP environment's database and images (architecture §5.8,
# §17.2), installed as /usr/local/bin/foxdrop-backup by provision.sh and run
# nightly by foxdrop-backup@<environment>.timer:
#   foxdrop-backup <environment>
# A custom-format pg_dump, checked by pg_restore, kept 7 days in
# /var/backups/foxdrop-<environment>, and copied encrypted (rclone crypt) to
# Backblaze B2, where dumps older than 30 days are deleted; then the
# public-media bucket, copied encrypted to B2 under public-media/. The B2 key and
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
trap 'rm -f "$dir/$name.partial"' EXIT
docker exec "$postgres" pg_dump --username postgres --dbname fox_drop --format custom >"$dir/$name.partial"
# Reads the archive's table of contents: a truncated or corrupt file fails.
# Only a restore proves the data (the deploy skill's restore test).
docker exec --interactive "$postgres" pg_restore --list <"$dir/$name.partial" >/dev/null ||
  die "the dump does not read back"
mv "$dir/$name.partial" "$dir/$name"
find "$dir" -maxdepth 1 -name '*.dump' -mtime +7 -delete
echo "saved $dir/$name ($(du -h "$dir/$name" | cut -f1))"

# One value from the environment file, without the quotes Compose would strip.
setting() {
  sed -n "s/^$1=//p" "$home/shared/.env" | tail -1 | sed -e "s/^\"\(.*\)\"$/\1/" -e "s/^'\(.*\)'$/\1/"
}
B2_ACCOUNT_ID=$(setting B2_ACCOUNT_ID)
B2_APPLICATION_KEY=$(setting B2_APPLICATION_KEY)
B2_BUCKET=$(setting B2_BUCKET)
BACKUP_ENCRYPTION_PASSWORD=$(setting BACKUP_ENCRYPTION_PASSWORD)
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
# Only the dumps at the top expire; the images below public-media/ stay.
rclone delete --min-age 30d --max-depth 1 --include '*.dump' foxdropcrypt:
echo "copied $name to B2 bucket $B2_BUCKET, encrypted"

# The public-media bucket (architecture §5.8), read from the storage's S3 API
# on its loopback port with the reader key. A key is never reused, so a copy
# adds the new images and never changes or removes one.
STORAGE_READER_KEY_ID=$(setting STORAGE_READER_KEY_ID)
STORAGE_READER_SECRET=$(setting STORAGE_READER_SECRET)
storage_port=$(sed -n 's/^STORAGE_PORT=//p' "$home/current/infra/environments/$environment.env")
if [ -z "$STORAGE_READER_KEY_ID" ] || [ -z "$STORAGE_READER_SECRET" ] || [ -z "$storage_port" ]; then
  die "no copy of the images: the storage's reader key or port is missing (provision.sh, then a deploy)"
fi
export RCLONE_CONFIG_FOXDROPSTORAGE_TYPE=s3
export RCLONE_CONFIG_FOXDROPSTORAGE_PROVIDER=Other
export RCLONE_CONFIG_FOXDROPSTORAGE_ENDPOINT=http://127.0.0.1:$storage_port
export RCLONE_CONFIG_FOXDROPSTORAGE_REGION=garage
export RCLONE_CONFIG_FOXDROPSTORAGE_FORCE_PATH_STYLE=true
export RCLONE_CONFIG_FOXDROPSTORAGE_ACCESS_KEY_ID=$STORAGE_READER_KEY_ID
export RCLONE_CONFIG_FOXDROPSTORAGE_SECRET_ACCESS_KEY=$STORAGE_READER_SECRET
rclone copy foxdropstorage:public-media foxdropcrypt:public-media
echo "copied the public-media bucket to B2, encrypted"
