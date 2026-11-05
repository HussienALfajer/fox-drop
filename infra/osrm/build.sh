#!/bin/sh
# Builds the OSRM data of each vehicle profile (architecture §7.1) from the
# region cut.sh made, then makes it current. Runs in the OSRM image with the
# data volume at /data and this folder at /osrm. The routed services read
# /data/current/<vehicle>/region.osrm when they start, so they are restarted
# after a build; a failed build leaves the current data as it was.
set -eu

# Motorbike: the car profile with motorbike speeds (motorbike.lua).
cp /osrm/motorbike.lua /opt/motorbike.lua

rm -rf /data/next
for vehicle in car motorbike bicycle walking; do
  case $vehicle in
    walking) profile=/opt/foot.lua ;;
    *) profile=/opt/$vehicle.lua ;;
  esac
  mkdir -p "/data/next/$vehicle"
  cp /data/source/region.osm.pbf "/data/next/$vehicle/region.osm.pbf"
  osrm-extract --profile "$profile" "/data/next/$vehicle/region.osm.pbf"
  osrm-partition "/data/next/$vehicle/region.osrm"
  osrm-customize "/data/next/$vehicle/region.osrm"
  rm "/data/next/$vehicle/region.osm.pbf"
done

rm -rf /data/previous
if [ -d /data/current ]; then mv /data/current /data/previous; fi
mv /data/next /data/current
echo "OSRM data built for car, motorbike, bicycle and walking"
