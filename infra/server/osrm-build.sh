#!/usr/bin/env bash
# Builds the shared OSRM data from fresh OpenStreetMap data and restarts the
# routed services (architecture §7.1), installed as
# /usr/local/bin/foxdrop-osrm-build by provision.sh. Runs as root:
#   foxdrop-osrm-build              rebuild, then restart (weekly, by
#                                   foxdrop-osrm-build.timer)
#   foxdrop-osrm-build --if-missing build only when there is no data yet,
#                                   then start (provision.sh)
# During the restart, for a few seconds, the API measures the straight line
# × 1.3. A failed build leaves the running data as it was.
set -euo pipefail

die() {
  echo "foxdrop-osrm-build: $*" >&2
  exit 1
}

home=/srv/foxdrop-osrm
[ -f "$home/compose.yaml" ] || die "$home is not provisioned (infra/server/provision.sh)"

exec 9>/run/lock/foxdrop-osrm-build.lock
flock --wait 3600 9 || die "another build is still running"

compose() {
  docker compose --project-name foxdrop-osrm --project-directory "$home" --file "$home/compose.yaml" "$@"
}

if [ "${1:-}" = --if-missing ] &&
  compose run --rm --no-deps --entrypoint test build -d /data/current >/dev/null 2>&1; then
  echo "OSRM data present"
else
  compose build --quiet cut
  compose run --rm build
  compose rm --force cut >/dev/null
fi
compose up --detach --wait --wait-timeout 180 --force-recreate --remove-orphans
echo "OSRM is up"
