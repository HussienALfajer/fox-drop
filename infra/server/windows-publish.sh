#!/usr/bin/env bash
# foxdrop-windows-publish <env>: publishes the restaurant app's Windows
# installer and Velopack's update feed (slice 2.44, architecture §12.3), read
# as a tar on standard input from the `publish-windows` CI job through the
# deploy key (deploy-ssh.sh). Installed by provision.sh; run as root through
# sudo. nginx serves the folder as /downloads/windows/ on every host of the
# environment (api.conf.template).
#
# Only Velopack's own files are taken: the feed and its signature (which the
# app checks with a key the deploy key never holds), the installer, the
# portable zip and the packages. The packages land first and the feed last, so an app
# never reads a feed whose package is missing. Packages older than 14 days
# that the feed no longer names are removed.
set -euo pipefail

environment=${1:-}
[[ $environment =~ ^(staging)$ ]] || { echo "usage: foxdrop-windows-publish staging" >&2; exit 2; }
target=/var/www/foxdrop-$environment-downloads/windows
install -d -m 755 "$target"

incoming=$(mktemp -d)
trap 'rm -rf "$incoming"' EXIT
# Extracted by nobody, never root, 1 GB at most; then only plain files at
# the top with Velopack's names are copied by root.
chown nobody "$incoming"
head -c 1073741824 | runuser -u nobody -- tar -x -C "$incoming" --no-same-owner --no-same-permissions

id='FOXDROP\.Merchant\.[A-Za-z]+'
allowed="^(releases\.win\.json|releases\.win\.json\.sig|assets\.win\.json|RELEASES|$id-win-Setup\.exe|$id-win-Portable\.zip|$id-[0-9A-Za-z.+-]+-(full|delta)\.nupkg)$"
shopt -s nullglob dotglob
files=()
for path in "$incoming"/*; do
  name=$(basename "$path")
  if [ -L "$path" ] || [ ! -f "$path" ] || [[ ! $name =~ $allowed ]]; then
    echo "refused: $name" >&2
    exit 1
  fi
  files+=("$name")
done
[ -f "$incoming/releases.win.json" ] || { echo "no releases.win.json" >&2; exit 1; }

publish() { install -m 644 "$incoming/$1" "$target/.$1.new" && mv -f "$target/.$1.new" "$target/$1"; }
for name in "${files[@]}"; do [[ $name == *.nupkg ]] && publish "$name"; done
for name in "${files[@]}"; do [[ $name == *Setup.exe || $name == *Portable.zip ]] && publish "$name"; done
for name in "${files[@]}"; do [[ $name == *.nupkg || $name == *Setup.exe || $name == *Portable.zip ]] || publish "$name"; done

for old in "$target"/*.nupkg; do
  name=$(basename "$old")
  if ! grep -qF "\"$name\"" "$target/releases.win.json" && [ -n "$(find "$old" -mtime +14)" ]; then
    rm -f "$old"
  fi
done
logger -t foxdrop-windows-publish "published ${#files[@]} files to $target"
echo "published ${#files[@]} files"
