// Writes style.json, the one map style of every product (architecture §7.2):
// Protomaps' light basemap with Arabic labels (name:ar, then the local name),
// its source, glyphs and sprite on our own storage. {{MAPS_URL}} is the
// environment's /maps address (written by maps-publish) and {{BUILD}} the
// build's folder (written by build.sh). Run after updating
// @protomaps/basemaps: pnpm --filter @fox-drop/infra maps:style
import { writeFileSync } from 'node:fs';
import { layers, namedFlavor } from '@protomaps/basemaps';

export function mapStyle() {
  return {
    version: 8,
    name: 'FOX DROP',
    glyphs: '{{MAPS_URL}}/{{BUILD}}/fonts/{fontstack}/{range}.pbf',
    sprite: '{{MAPS_URL}}/{{BUILD}}/sprites/light',
    sources: {
      protomaps: {
        type: 'vector',
        url: 'pmtiles://{{MAPS_URL}}/{{BUILD}}/region.pmtiles',
        attribution: '© OpenStreetMap',
      },
    },
    layers: layers('protomaps', namedFlavor('light'), { lang: 'ar' }),
  };
}

export const styleText = () => `${JSON.stringify(mapStyle(), null, 2)}\n`;

if (import.meta.url === `file://${process.argv[1]}`) {
  writeFileSync(new URL('style.json', import.meta.url), styleText());
}
