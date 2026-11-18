#!/bin/sh
# Builds the map of V1's region (architecture §7.2) into /data/out, for
# maps-publish to upload to public-maps: the vector tiles of Azaz's region
# extracted from the newest Protomaps daily build of OpenStreetMap, the
# glyphs the style names (Noto Sans, Arabic included) and the light sprite,
# all under a folder named by the build's date, and style.json naming that
# folder. Runs in the maps-build image with the maps-data volume at /data.
# Nothing here is reached at run time: the phones read only our /maps/.
set -eu

# The region of OSRM (infra/osrm/cut.sh): Azaz and about 20 km around it.
# left,bottom,right,top in degrees.
region=36.82,36.40,37.27,36.77
assets=https://github.com/protomaps/basemaps-assets/archive/refs/heads/main.tar.gz

work=/data/work
rm -rf "$work"
mkdir -p "$work"

# Today's daily build may not be out yet: the newest of the last week.
build=
for days in 0 1 2 3 4 5 6 7; do
  date=$(date -u -d "-$days days" +%Y%m%d)
  if curl --fail --silent --head --output /dev/null "https://build.protomaps.com/$date.pmtiles"; then
    build=$date
    break
  fi
done
[ -n "$build" ] || { echo "no Protomaps build in the last week" >&2; exit 1; }

out=$work/$build
mkdir -p "$out/fonts" "$out/sprites"
pmtiles extract "https://build.protomaps.com/$build.pmtiles" "$out/region.pmtiles" --bbox="$region"

curl --fail --silent --show-error --location --retry 3 "$assets" | tar -xz --no-same-owner -C "$work"
source=$work/basemaps-assets-main
# Only the font stacks the style names.
grep -o '"Noto Sans[^"]*"' /maps/style.json | sort -u | tr -d '"' | while read -r font; do
  cp -r "$source/fonts/$font" "$out/fonts/"
done
cp "$source/sprites/v4/light.json" "$source/sprites/v4/light.png" \
  "$source/sprites/v4/light@2x.json" "$source/sprites/v4/light@2x.png" "$out/sprites/"
rm -rf "$source"

# Arabic labels need the Arabic block's glyphs (U+0600 to U+06FF).
[ "$(wc -c <"$out/fonts/Noto Sans Regular/1536-1791.pbf")" -gt 1000 ] ||
  { echo "the glyphs have no Arabic" >&2; exit 1; }

sed "s/{{BUILD}}/$build/g" /maps/style.json >"$work/style.json"
rm -rf /data/out
mv "$work" /data/out
echo "built the map $build of the region $region: $(du -sh /data/out | cut -f1)"
