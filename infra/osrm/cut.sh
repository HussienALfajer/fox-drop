#!/bin/sh
# Downloads the OpenStreetMap extract for Syria and cuts V1's region from it
# (architecture §7.1): Azaz and about 20 km around it, which keeps the OSRM
# data small on the shared server (owner decision 2026-11-06). Runs in the
# osrm-cut image with the OSRM data volume at /data; build.sh follows.
set -eu

source_url=https://download.geofabrik.de/asia/syria-latest.osm.pbf
# left,bottom,right,top in degrees.
region=36.82,36.40,37.27,36.77

mkdir -p /data/source
curl --fail --silent --show-error --location --retry 3 \
  --output /data/source/syria.osm.pbf.part "$source_url"
mv /data/source/syria.osm.pbf.part /data/source/syria.osm.pbf

# The simple strategy cuts the roads that cross the region's edge, 20 km
# from Azaz, and needs about 1.5 GB instead of 2.6 GB: osmium keeps a bitmap
# as large as the highest OpenStreetMap node id.
osmium extract --strategy simple --bbox "$region" --overwrite \
  --output /data/source/region.osm.pbf /data/source/syria.osm.pbf
echo "cut the region $region from the Syria extract"
