#!/usr/bin/env bash
# Builds and publishes one environment's map (architecture §7.2), installed as
# /usr/local/bin/foxdrop-maps-build by provision.sh. Runs as root, with the
# environment's current release:
#   foxdrop-maps-build <environment>              build and publish again
#   foxdrop-maps-build <environment> --if-missing only when public-maps has
#                                                 no style yet (provision.sh)
# The build downloads Azaz's region from Protomaps' daily OpenStreetMap build
# and the glyphs and sprite from protomaps/basemaps-assets; the phones then
# read only /maps/ on our domain. A failed build leaves the published map as
# it was. The runbook is docs/runbooks/maps.md.
set -euo pipefail

die() {
  echo "foxdrop-maps-build: $*" >&2
  exit 1
}

environment=${1:-}
[[ $environment =~ ^(staging|production)$ ]] || die "unknown environment '$environment'"
home=/srv/foxdrop-$environment
user=foxdrop-$environment
[ -L "$home/current" ] || die "$environment has no release yet: deploy it first"
release=$(basename "$(readlink "$home/current")")
infra=$home/releases/$release/infra

exec 9>"/run/lock/foxdrop-maps-build-$environment.lock"
flock --wait 3600 9 || die "another map build is still running"

compose() {
  FOXDROP_RELEASE=$release FOXDROP_HOME=$home FOXDROP_UID=$(id -u "$user") FOXDROP_GID=$(id -g "$user") \
    docker compose --project-name "foxdrop-$environment" \
    --project-directory "$infra" \
    --file "$infra/compose.yaml" \
    --env-file "$infra/environments/$environment.env" \
    --env-file "$home/shared/.env" \
    --profile maps "$@"
}

maps_port=$(sed -n 's/^MAPS_PORT=//p' "$infra/environments/$environment.env")
[ -n "$maps_port" ] || die "release $release has no MAPS_PORT: deploy a newer commit first"
published() {
  [ "$(curl --silent --output /dev/null --write-out '%{http_code}' \
    --header 'Host: public-maps' "http://127.0.0.1:$maps_port/style.json")" = 200 ]
}

if [ "${2:-}" = --if-missing ] && published; then
  echo "the map of $environment is published"
  exit 0
fi
compose build --quiet maps-build
compose run --rm maps-build
compose run --rm maps-publish
published || die "public-maps does not serve style.json"
echo "the map of $environment is published"
