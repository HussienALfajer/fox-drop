import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';

// AP §9.12.2 «مناطق الخدمة» (slice 2.37c): the city's neighbourhoods on the
// map, drawn, edited and activated by OWN (zones.manage), and the votes
// from outside them. Owner decision 2026-11-19: our own corner editing on
// MapLibre, no drawing library; the names typed as people in Azaz call
// their neighbourhoods (CU §18 item 6).
export type CityZones = components['schemas']['AdminZonesDto_Output'];
export type Zone = CityZones['zones'][number];
export type VoteCell = CityZones['votes'][number];
type SaveZone = components['schemas']['AdminSaveZoneDto'];

export interface Point {
  latitude: number;
  longitude: number;
}

// A zone as the form edits it: the corners in order, as the map and the
// text field both change them.
export interface ZoneForm {
  id: string;
  name: string;
  corners: Point[];
  active: boolean;
  reason: string;
}

export function newZoneForm(id: string): ZoneForm {
  return { id, name: '', corners: [], active: false, reason: '' };
}

export function zoneFormOf(zone: Zone): ZoneForm {
  return { id: zone.id, name: zone.name, corners: zone.area, active: zone.active, reason: '' };
}

// Six decimals, about 10 cm: what a click on the map can mean.
function degrees(value: number): string {
  return String(Math.round(value * 1e6) / 1e6);
}

// The corners as the text field shows them: one «latitude, longitude» per
// line, in order.
export function cornersText(corners: Point[]): string {
  return corners
    .map((point) => `${degrees(point.latitude)}, ${degrees(point.longitude)}`)
    .join('\n');
}

// The corners typed, one per line («36.59, 37.04»; a comma or spaces
// between), empty lines left out; null when a line is not a point on the
// map.
export function cornersOf(text: string): Point[] | null {
  const corners: Point[] = [];
  for (const line of text.split('\n')) {
    if (line.trim() === '') continue;
    const match = /^\s*(-?\d{1,3}(?:\.\d+)?)\s*[,،\s]\s*(-?\d{1,3}(?:\.\d+)?)\s*$/.exec(line);
    if (!match) return null;
    const latitude = Number(match[1]);
    const longitude = Number(match[2]);
    if (Math.abs(latitude) > 90 || Math.abs(longitude) > 180) return null;
    corners.push({ latitude, longitude });
  }
  return corners;
}

export type ZoneProblem = 'name' | 'corners';

// The body to save, or what is wrong; the server checks the rest (the
// outline crossing itself, the overlap, the name taken).
export function zoneRequestOf(form: ZoneForm): { body: SaveZone } | { problem: ZoneProblem } {
  const name = form.name.trim();
  if (name === '' || name.length > 100) return { problem: 'name' };
  const distinct = new Set(form.corners.map((point) => `${point.latitude},${point.longitude}`));
  if (distinct.size < 3 || form.corners.length > 500) return { problem: 'corners' };
  const reason = form.reason.trim();
  return {
    body: { name, area: form.corners, active: form.active, reason: reason === '' ? null : reason },
  };
}

// The corners moved: one replaced, one added at the end, the last removed.
export function movedCorner(corners: Point[], index: number, to: Point): Point[] {
  return corners.map((point, at) => (at === index ? to : point));
}

export function withoutLastCorner(corners: Point[]): Point[] {
  return corners.slice(0, -1);
}

const zonesKey = (cityId: string) => ['city-zones', cityId] as const;

export function useCityZones(cityId: string | undefined) {
  return useQuery({
    queryKey: zonesKey(cityId ?? ''),
    enabled: cityId !== undefined,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/cities/{cityId}/zones', {
        params: { path: { cityId: cityId! } },
      });
      if (!data) throw new Error('zones unavailable');
      return data;
    },
  });
}

export type ZoneRefusal =
  'invalid_name' | 'invalid_area' | 'zone_name_taken' | 'zones_overlap' | 'unknown_zone';

const zoneRefusals: readonly ZoneRefusal[] = [
  'invalid_name',
  'invalid_area',
  'zone_name_taken',
  'zones_overlap',
  'unknown_zone',
];

export type ZoneSaveResult = { status: 'saved' } | { status: 'refused'; refusal: ZoneRefusal };

// Saves the zone under its id: a new id draws it, a known one changes it.
// It sets the value sent, so no key; the answer replaces the read.
export function useSaveZone(cityId: string) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, body }: { id: string; body: SaveZone }): Promise<ZoneSaveResult> => {
      const { data, error, response } = await api.PUT('/v1/admin/cities/{cityId}/zones/{zoneId}', {
        params: { path: { cityId, zoneId: id } },
        body,
      });
      if (data) {
        queryClient.setQueryData(zonesKey(cityId), data);
        return { status: 'saved' };
      }
      const code = (error as { error?: string } | undefined)?.error;
      const refusal = zoneRefusals.find((each) => each === code);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`zone save failed with ${response.status}`);
    },
  });
}

// The votes counted, for the map's caption.
export function voteCount(votes: VoteCell[]): number {
  return votes.reduce((sum, cell) => sum + cell.votes, 0);
}

// Where the map starts: the middle of the zones' corners, else of the
// votes, else nowhere (the typed corners remain).
export function mapCentre(zones: Zone[], votes: VoteCell[]): Point | null {
  const points: Point[] = zones.length > 0 ? zones.flatMap((zone) => zone.area) : votes;
  if (points.length === 0) return null;
  const sum = points.reduce(
    (total, point) => ({
      latitude: total.latitude + point.latitude,
      longitude: total.longitude + point.longitude,
    }),
    { latitude: 0, longitude: 0 },
  );
  return { latitude: sum.latitude / points.length, longitude: sum.longitude / points.length };
}

// The GeoJSON the sources take, typed here, so a wrong `type` fails the type
// check (the panel's program has no GeoJSON types of its own).
type Geometry =
  | { type: 'Polygon'; coordinates: number[][][] }
  | { type: 'Point'; coordinates: number[] }
  | { type: 'LineString'; coordinates: number[][] };
export interface Collection {
  type: 'FeatureCollection';
  features: { type: 'Feature'; properties: Record<string, unknown>; geometry: Geometry }[];
}

const ring = (corners: Point[]) => [
  ...corners.map((point) => [point.longitude, point.latitude]),
  [corners[0]!.longitude, corners[0]!.latitude],
];

export function zonesData(zones: Zone[], editingId: string | null): Collection {
  return {
    type: 'FeatureCollection',
    features: zones
      .filter((zone) => zone.id !== editingId && zone.area.length >= 3)
      .map((zone) => ({
        type: 'Feature',
        properties: { name: zone.name, active: zone.active },
        geometry: { type: 'Polygon', coordinates: [ring(zone.area)] },
      })),
  };
}

export function votesData(votes: VoteCell[]): Collection {
  return {
    type: 'FeatureCollection',
    features: votes.map((cell) => ({
      type: 'Feature',
      properties: { votes: cell.votes },
      geometry: { type: 'Point', coordinates: [cell.longitude, cell.latitude] },
    })),
  };
}

export function outlineData(corners: Point[]): Collection {
  if (corners.length < 2) return { type: 'FeatureCollection', features: [] };
  return {
    type: 'FeatureCollection',
    features: [
      {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'LineString',
          coordinates: corners.length >= 3 ? ring(corners) : ring(corners).slice(0, -1),
        },
      },
    ],
  };
}
