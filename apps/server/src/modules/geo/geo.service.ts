import { Inject, Injectable, Logger } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { SettingsService, type Vehicle } from '../settings/index.js';
import {
  type Distance,
  measureDistance,
  type Point,
  ROAD_DISTANCES,
  type RoadDistances,
} from './distance.js';
import { cities } from './schema.js';

// Cities (AP §9.12.1) and distances (architecture §7.1) for the other
// modules; zones join with their slice.
@Injectable()
export class GeoService {
  private readonly logger = new Logger(GeoService.name);

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(ROAD_DISTANCES) private readonly road: RoadDistances,
    private readonly settings: SettingsService,
  ) {}

  // The city's id by its code, such as AZ; null for an unknown code.
  async cityIdByCode(code: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ id: cities.id })
      .from(cities)
      .where(eq(cities.code, code));
    return row?.id ?? null;
  }

  // The distance between two points for a vehicle, in whole metres: by road
  // through OSRM, or the straight line × 1.3 when OSRM does not answer or
  // pricing.distance_method is straight_line (AP §9.12.3).
  async distance(from: Point, to: Point, { vehicle }: { vehicle: Vehicle }): Promise<Distance> {
    const method = await this.settings.get('pricing.distance_method');
    return measureDistance(from, to, vehicle, method, this.road, (error) => {
      // No points in the log: a customer's delivery point is personal data.
      this.logger.warn(
        { vehicle, err: error },
        'OSRM did not answer: the straight line × 1.3 is used',
      );
    });
  }
}
