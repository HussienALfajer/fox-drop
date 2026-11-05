import type { Vehicle } from '../settings/index.js';

export interface Point {
  latitude: number;
  longitude: number;
}

// How a distance was measured: by the routing service, or as the straight
// line × 1.3 when it did not answer or pricing.distance_method says so.
export type DistanceMethod = 'road' | 'straight_x1.3';

export interface Distance {
  metres: number;
  method: DistanceMethod;
}

// AP §9.12.3: the fallback factor is fixed, not a setting.
const STRAIGHT_LINE_FACTOR = 1.3;

// The mean radius of the Earth.
const EARTH_RADIUS_M = 6_371_008.8;

// The great-circle distance in metres (haversine).
export function straightLineMetres(from: Point, to: Point): number {
  const radians = (degrees: number) => (degrees * Math.PI) / 180;
  const dLatitude = radians(to.latitude - from.latitude);
  const dLongitude = radians(to.longitude - from.longitude);
  const a =
    Math.sin(dLatitude / 2) ** 2 +
    Math.cos(radians(from.latitude)) *
      Math.cos(radians(to.latitude)) *
      Math.sin(dLongitude / 2) ** 2;
  return 2 * EARTH_RADIUS_M * Math.asin(Math.sqrt(a));
}

// The injection token of the module's RoadDistances.
export const ROAD_DISTANCES = Symbol('ROAD_DISTANCES');

// The routing service (architecture §7.1): the road distance in metres for
// the vehicle's profile. It rejects when it cannot answer in time.
export interface RoadDistances {
  metres(from: Point, to: Point, vehicle: Vehicle): Promise<number>;
}

// A programming error, not a refusal: the routes validate the points they
// receive.
function assertCoordinate({ latitude, longitude }: Point): void {
  if (!(Math.abs(latitude) <= 90 && Math.abs(longitude) <= 180)) {
    throw new RangeError('a point needs a latitude within ±90 and a longitude within ±180');
  }
}

// The distance between two points in whole metres, by pricing.distance_method.
export async function measureDistance(
  from: Point,
  to: Point,
  vehicle: Vehicle,
  method: 'road' | 'straight_line',
  road: RoadDistances,
  onFallback: (error: unknown) => void = () => {},
): Promise<Distance> {
  assertCoordinate(from);
  assertCoordinate(to);
  if (method === 'road') {
    try {
      return { metres: Math.round(await road.metres(from, to, vehicle)), method: 'road' };
    } catch (error) {
      onFallback(error);
    }
  }
  return {
    metres: Math.round(straightLineMetres(from, to) * STRAIGHT_LINE_FACTOR),
    method: 'straight_x1.3',
  };
}
