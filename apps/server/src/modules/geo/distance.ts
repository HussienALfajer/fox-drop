import type { Vehicle } from '../settings/index.js';
import { tripMinutes } from './delivery-estimate.js';

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
  // The distance matrix (OSRM `table`) from each source to one destination,
  // in the sources' order: null for a source with no route.
  table(sources: Point[], to: Point, vehicle: Vehicle): Promise<(number | null)[]>;
  // The route (OSRM `route`): its distance, its duration and its line, the
  // points in order from the start to the end.
  route(from: Point, to: Point, vehicle: Vehicle): Promise<RoadRoute>;
}

export interface RoadRoute {
  metres: number;
  seconds: number;
  line: Point[];
}

// A leg's route for the maps (architecture §7.1, CA §4.6, CU §11.3): by road
// with its line, or the straight line × 1.3 at the city's average speed with
// no line when the routing service does not answer.
export interface Route {
  metres: number;
  seconds: number;
  method: DistanceMethod;
  line: Point[] | null;
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

// The distances from many points to one, for one vehicle, in their order
// (dispatch's ranking, AP §9.12.6): one matrix call by road, each source
// without a route, and every source when the call fails, by the straight line
// × 1.3.
export async function measureDistances(
  sources: Point[],
  to: Point,
  vehicle: Vehicle,
  method: 'road' | 'straight_line',
  road: RoadDistances,
  onFallback: (error: unknown) => void = () => {},
): Promise<Distance[]> {
  sources.forEach(assertCoordinate);
  assertCoordinate(to);
  const straight = (from: Point): Distance => ({
    metres: Math.round(straightLineMetres(from, to) * STRAIGHT_LINE_FACTOR),
    method: 'straight_x1.3',
  });
  if (sources.length === 0) return [];
  if (method === 'road') {
    try {
      const metres = await road.table(sources, to, vehicle);
      if (metres.length !== sources.length) {
        throw new Error(`the matrix has ${metres.length} rows for ${sources.length} sources`);
      }
      if (metres.some((each) => each === null)) onFallback(new Error('no route for some sources'));
      return metres.map((each, index) =>
        each === null ? straight(sources[index]!) : { metres: Math.round(each), method: 'road' },
      );
    } catch (error) {
      onFallback(error);
    }
  }
  return sources.map(straight);
}

// The route between two points for a vehicle: OSRM's distance, duration and
// line in whole metres and seconds, or, when it fails or has no route, the
// straight line × 1.3 timed at speedKmh (order.eta_speed_kmh) without a line.
export async function measureRoute(
  from: Point,
  to: Point,
  vehicle: Vehicle,
  speedKmh: number,
  road: RoadDistances,
  onFallback: (error: unknown) => void = () => {},
): Promise<Route> {
  assertCoordinate(from);
  assertCoordinate(to);
  try {
    const route = await road.route(from, to, vehicle);
    return {
      metres: Math.round(route.metres),
      seconds: Math.round(route.seconds),
      method: 'road',
      line: route.line,
    };
  } catch (error) {
    onFallback(error);
  }
  const metres = Math.round(straightLineMetres(from, to) * STRAIGHT_LINE_FACTOR);
  return {
    metres,
    seconds: Math.round(tripMinutes(metres, speedKmh) * 60),
    method: 'straight_x1.3',
    line: null,
  };
}
