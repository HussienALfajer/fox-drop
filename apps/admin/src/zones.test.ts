import { describe, expect, it, vi } from 'vitest';
import {
  cornersOf,
  cornersText,
  mapCentre,
  movedCorner,
  newZoneForm,
  outlineData,
  votesData,
  zonesData,
  voteCount,
  withoutLastCorner,
  zoneRequestOf,
} from './zones.js';

vi.mock('./api.js', () => ({ api: {} }));

// AP §9.12.2 «مناطق الخدمة»: the corners as typed and the body saved.
const square = [
  { latitude: 36.595, longitude: 37.045 },
  { latitude: 36.595, longitude: 37.055 },
  { latitude: 36.605, longitude: 37.055 },
];

describe('cornersOf and cornersText', () => {
  it('reads one point per line, a comma, an Arabic comma or spaces between', () => {
    expect(cornersOf('36.595, 37.045\n36.595،37.055\n\n 36.605 37.055 ')).toEqual(square);
    expect(cornersOf(cornersText(square))).toEqual(square);
  });

  it('refuses a line that is not a point on the map', () => {
    expect(cornersOf('36.595, 37.045\nnorth')).toBeNull();
    expect(cornersOf('95, 37')).toBeNull();
    expect(cornersOf('')).toEqual([]);
  });

  it('writes six decimals at most', () => {
    expect(cornersText([{ latitude: 36.12345678, longitude: 37.1 }])).toBe('36.123457, 37.1');
  });
});

describe('zoneRequestOf', () => {
  it('sends the trimmed name, the corners, the state and the reason or null', () => {
    const form = { ...newZoneForm('z'), name: ' الحي الشمالي ', corners: square, active: true };
    expect(zoneRequestOf(form)).toEqual({
      body: { name: 'الحي الشمالي', area: square, active: true, reason: null },
    });
    expect(zoneRequestOf({ ...form, reason: ' حدود أدق ' })).toMatchObject({
      body: { reason: 'حدود أدق' },
    });
  });

  it('needs a name and three distinct corners', () => {
    const form = { ...newZoneForm('z'), name: 'حي', corners: square };
    expect(zoneRequestOf({ ...form, name: ' ' })).toEqual({ problem: 'name' });
    expect(zoneRequestOf({ ...form, corners: [square[0]!, square[0]!, square[1]!] })).toEqual({
      problem: 'corners',
    });
  });
});

describe('the corners edited on the map', () => {
  it('moves one corner and removes the last', () => {
    const to = { latitude: 1, longitude: 2 };
    expect(movedCorner(square, 1, to)).toEqual([square[0], to, square[2]]);
    expect(withoutLastCorner(square)).toEqual(square.slice(0, 2));
  });
});

describe('the map', () => {
  it('starts at the middle of the zones, else of the votes, else nowhere', () => {
    const zone = { id: 'z', name: 'حي', active: true, area: square };
    const votes = [{ latitude: 10, longitude: 20, votes: 3 }];
    expect(mapCentre([zone], votes)?.latitude).toBeCloseTo(36.598333);
    expect(mapCentre([], votes)).toEqual({ latitude: 10, longitude: 20 });
    expect(mapCentre([], [])).toBeNull();
    expect(voteCount([...votes, { latitude: 1, longitude: 1, votes: 2 }])).toBe(5);
  });
});

describe('the map layers', () => {
  it('draws the zones but the one edited, the votes and the outline as GeoJSON', () => {
    const zone = { id: 'z', name: 'حي', active: true, area: square };
    const zones = zonesData([zone, { ...zone, id: 'edited' }], 'edited');
    expect(zones.type).toBe('FeatureCollection');
    expect(zones.features).toEqual([
      {
        type: 'Feature',
        properties: { name: 'حي', active: true },
        geometry: {
          type: 'Polygon',
          coordinates: [
            [
              [37.045, 36.595],
              [37.055, 36.595],
              [37.055, 36.605],
              [37.045, 36.595],
            ],
          ],
        },
      },
    ]);
    expect(votesData([{ latitude: 10, longitude: 20, votes: 3 }]).features[0]).toEqual({
      type: 'Feature',
      properties: { votes: 3 },
      geometry: { type: 'Point', coordinates: [20, 10] },
    });
    expect(outlineData(square.slice(0, 1)).features).toEqual([]);
    expect(outlineData(square.slice(0, 2)).features[0]?.geometry).toEqual({
      type: 'LineString',
      coordinates: [
        [37.045, 36.595],
        [37.055, 36.595],
      ],
    });
    expect(outlineData(square).features[0]?.geometry.coordinates).toHaveLength(4);
  });
});
