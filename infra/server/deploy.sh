#!/usr/bin/env bash
# Deploys one FOX DROP environment (architecture §17.3), installed as
# /usr/local/bin/foxdrop-deploy by provision.sh. Runs as root:
#   foxdrop-deploy <environment> <commit>    deploy a commit on main
#   foxdrop-deploy <environment> rollback    go back to the previous release
# GitHub Actions reaches it through deploy-ssh.sh after every merge to main.
#
# A deploy pulls the commit's images, starts the database, runs the
# migrations, then starts the new release. If it does not come up healthy, the
# previous release starts again (migrations are backward compatible, so it
# runs on the migrated database) and the deploy fails.
set -euo pipefail

die() {
  echo "foxdrop-deploy: $*" >&2
  exit 1
}

environment=${1:-}
target=${2:-}
[[ $environment =~ ^(staging|production)$ ]] || die "unknown environment '$environment'"
[[ $target =~ ^([0-9a-f]{40}|rollback)$ ]] || die "expected a full commit hash or 'rollback'"

home=/srv/foxdrop-$environment
user=foxdrop-$environment
[ -d "$home/repo.git" ] || die "$home is not provisioned (infra/server/provision.sh)"

# One deploy at a time per environment.
exec 9>"/run/lock/foxdrop-deploy-$environment.lock"
flock --wait 900 9 || die "another deploy is still running"

as_user() { sudo -u "$user" -H -- "$@"; }
release_of() { [ -L "$home/$1" ] && basename "$(readlink "$home/$1")" || true; }

current=$(release_of current)
previous=$(release_of previous)

if [ "$target" = rollback ]; then
  [ -n "$previous" ] || die "no previous release to go back to"
  target=$previous
  migrate=no
else
  migrate=yes
  as_user git -C "$home/repo.git" fetch --quiet --prune origin
  as_user git -C "$home/repo.git" merge-base --is-ancestor "$target" refs/heads/main ||
    die "$target is not a commit on main"
fi

release=$home/releases/$target
if [ ! -d "$release" ]; then
  rm -rf -- "$release.partial"
  as_user mkdir "$release.partial"
  as_user git -C "$home/repo.git" archive "$target" infra apps/server/db |
    as_user tar -x -C "$release.partial"
  as_user mv "$release.partial" "$release"
fi

# The database's first-start scripts, at the fixed path compose.yaml mounts.
as_user install -m 644 "$release/apps/server/db/init-container.sh" "$release/apps/server/db/bootstrap.sql" \
  "$home/shared/db/"

compose() {
  local commit=$1
  shift
  FOXDROP_RELEASE=$commit FOXDROP_HOME=$home FOXDROP_UID=$(id -u "$user") FOXDROP_GID=$(id -g "$user") \
    docker compose --project-name "foxdrop-$environment" \
    --project-directory "$home/releases/$commit/infra" \
    --file "$home/releases/$commit/infra/compose.yaml" \
    --env-file "$home/releases/$commit/infra/environments/$environment.env" \
    --env-file "$home/shared/.env" \
    "$@"
}

echo "deploying $target to $environment"
compose "$target" pull --quiet
# The storage arrived with slice 2.5; a rollback to an older release has none.
storage=()
if compose "$target" config --services | grep -qx storage; then storage=(storage); fi
compose "$target" up --detach --wait --wait-timeout 120 postgres valkey "${storage[@]}"
if [ "$migrate" = yes ]; then
  compose "$target" run --rm migrate
  # The storage's layout, keys and bucket (architecture §5.8); changes
  # nothing once they are there.
  compose "$target" run --rm storage-setup
fi

if ! compose "$target" up --detach --wait --wait-timeout 180 --remove-orphans; then
  # The states only: this output reaches the public GitHub Actions log, so
  # the logs stay in the server's journal (journalctl -t foxdrop-deploy).
  compose "$target" ps --all --format '{{.Service}} {{.State}} {{.Health}}' >&2 || true
  compose "$target" logs --tail 100 2>&1 | logger -t foxdrop-deploy || true
  if [ -n "$current" ] && [ "$current" != "$target" ]; then
    echo "foxdrop-deploy: $target did not start healthy; starting $current again" >&2
    compose "$current" up --detach --wait --wait-timeout 180 --remove-orphans
  fi
  die "$target failed"
fi

if [ "$target" != "$current" ]; then
  [ -n "$current" ] && as_user ln -sfn "releases/$current" "$home/previous"
  as_user ln -sfn "releases/$target" "$home/current"
fi
echo "$environment runs $target"

# Keep the five newest releases besides the current and previous ones, and
# only the images those releases use.
current=$(release_of current)
previous=$(release_of previous)
declare -A keep=()
newest=$(find "$home/releases" -mindepth 1 -maxdepth 1 -type d -not -name '*.partial' -printf '%T@ %f\n' |
  sort -rn | head -5 | cut -d' ' -f2)
# shellcheck disable=SC2086 # one release per word
for name in "$current" "$previous" $newest; do
  [ -z "$name" ] || keep[$name]=1
done
for dir in "$home"/releases/*; do
  [[ -v keep[$(basename "$dir")] ]] || rm -rf -- "$dir"
done
docker image ls --format '{{.Repository}}:{{.Tag}}' |
  { grep -E '^ghcr\.io/hussienalfajer/fox-drop-(server|web):' || true; } |
  while read -r image; do
    [[ -v keep[${image##*:}] ]] || docker image rm "$image" >/dev/null || true
  done
