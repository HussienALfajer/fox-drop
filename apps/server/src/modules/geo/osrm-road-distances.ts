import { Logger } from '@nestjs/common';
import { z } from 'zod';
import { vehicles, type Vehicle } from '../settings/index.js';
import type { Point, RoadDistances } from './distance.js';

// A route lookup that takes longer falls back to the straight line × 1.3, so
// a slow OSRM never holds up a quote.
const TIMEOUT_MS = 1000;

const routeAnswer = z.object({
  code: z.literal('Ok'),
  routes: z.tuple([z.object({ distance: z.number().nonnegative() })], z.unknown()),
});

const failedAnswer = z.object({ code: z.string() });

// Self-hosted OSRM (architecture §7.1): one osrm-routed per vehicle profile,
// reached only from the server. A vehicle without a server always falls back.
export class OsrmRoadDistances implements RoadDistances {
  constructor(
    private readonly urls: Partial<Record<Vehicle, string>>,
    private readonly timeoutMs = TIMEOUT_MS,
  ) {}

  async metres(from: Point, to: Point, vehicle: Vehicle): Promise<number> {
    const url = this.urls[vehicle];
    if (!url) throw new Error(`no OSRM server for ${vehicle}`);
    // Each osrm-routed serves one profile, so the profile in the path is
    // only a name. OSRM takes longitude first.
    const points = `${from.longitude},${from.latitude};${to.longitude},${to.latitude}`;
    const response = await fetch(
      `${url}/route/v1/driving/${points}?overview=false&alternatives=false&steps=false`,
      { signal: AbortSignal.timeout(this.timeoutMs) },
    );
    const body: unknown = await response.json();
    const route = routeAnswer.safeParse(body);
    if (route.success) return route.data.routes[0].distance;
    const failure = failedAnswer.safeParse(body);
    throw new Error(
      `OSRM answered ${response.status} ${failure.success ? failure.data.code : 'without a route'}`,
    );
  }
}

// The module's RoadDistances, from OSRM_CAR_URL, OSRM_MOTORBIKE_URL,
// OSRM_BICYCLE_URL and OSRM_WALKING_URL (such as http://127.0.0.1:5001 in
// development). Unset in the tests and the OpenAPI generation; a vehicle
// without one is measured by the straight line × 1.3, with a warning here.
export function roadDistancesFromEnvironment(
  env: NodeJS.ProcessEnv = process.env,
): OsrmRoadDistances {
  const urls: Partial<Record<Vehicle, string>> = {};
  for (const vehicle of vehicles) {
    const url = env[`OSRM_${vehicle.toUpperCase()}_URL`];
    if (url) urls[vehicle] = url.replace(/\/+$/, '');
  }
  const missing = vehicles.filter((vehicle) => urls[vehicle] === undefined);
  if (missing.length > 0) {
    new Logger('GeoService').warn(
      { vehicles: missing },
      'no OSRM server for these vehicles: their distances are the straight line × 1.3',
    );
  }
  return new OsrmRoadDistances(urls);
}
