import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { cities } from './schema.js';

// Cities (AP §9.12.1) for the other modules; zones and distances join with
// their slices.
@Injectable()
export class GeoService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  // The city's id by its code, such as AZ; null for an unknown code.
  async cityIdByCode(code: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ id: cities.id })
      .from(cities)
      .where(eq(cities.code, code));
    return row?.id ?? null;
  }
}
