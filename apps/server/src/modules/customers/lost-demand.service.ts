import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, lt, max, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService, type Point } from '../geo/index.js';
import { restaurantSuggestions, searchMisses } from './schema.js';
import { searchText } from './search-text.js';

// AP §9.17 (owner decision 2026-11-18, decided by us): the panel lists the
// lost demand of the last 30 days, the 100 searches with no result missed
// most and the 100 latest suggestions.
export const LOST_DEMAND_DAYS = 30;
export const LOST_DEMAND_ROWS = 100;
const DAY_MS = 24 * 60 * 60_000;

export type LostDemandRefusal = 'outside_zones' | 'idempotency_key_reused';

export class LostDemandRefusedError extends Error {
  constructor(
    readonly refusal: LostDemandRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface Suggestion {
  restaurantName: string;
  note: string | null;
  query: string | null;
}

export interface LostDemand {
  since: Date;
  // A search's text as it was last typed, how often it found nothing and
  // when it last did, the searches typed alike counted together.
  searches: { query: string; count: number; lastAt: Date }[];
  suggestions: (Suggestion & { id: string; at: Date })[];
}

// The lost demand of CU §8.3 and AP §9.17: the searches that found nothing
// and «لم تجده؟ أخبرنا».
@Injectable()
export class LostDemandService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
  ) {}

  // A search with no restaurant and no item at a point a zone serves.
  async recordMiss(
    place: { cityId: string; zoneId: string },
    query: string,
    accountId: string | null,
    at: Date,
  ): Promise<void> {
    await this.database.db.insert(searchMisses).values({
      cityId: place.cityId,
      zoneId: place.zoneId,
      query,
      normalized: searchText(query),
      customerAccountId: accountId,
      at,
    });
  }

  // «لم تجده؟ أخبرنا» at the customer's point, which a zone covers (the app
  // searches only there): outside_zones otherwise. A repeat of the key adds nothing; the key with another
  // body is idempotency_key_reused.
  async suggest(
    point: Point,
    suggestion: Suggestion,
    accountId: string | null,
    idempotencyKey: string,
    at: Date,
  ): Promise<void> {
    const requestHash = createHash('sha256')
      .update(JSON.stringify([point.latitude, point.longitude, suggestion, accountId]))
      .digest('hex');
    if (await this.replayed(idempotencyKey, requestHash)) return;
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) {
      throw new LostDemandRefusedError('outside_zones', 'no active zone covers the point');
    }
    const [row] = await this.database.db
      .insert(restaurantSuggestions)
      .values({
        cityId: place.cityId,
        zoneId: place.zone.id,
        ...suggestion,
        customerAccountId: accountId,
        at,
        idempotencyKey,
        requestHash,
      })
      .onConflictDoNothing({ target: restaurantSuggestions.idempotencyKey })
      .returning({ id: restaurantSuggestions.id });
    // A retry raced the first.
    if (row === undefined) await this.replayed(idempotencyKey, requestHash);
  }

  private async replayed(key: string, requestHash: string): Promise<boolean> {
    const [row] = await this.database.db
      .select({ requestHash: restaurantSuggestions.requestHash })
      .from(restaurantSuggestions)
      .where(eq(restaurantSuggestions.idempotencyKey, key));
    if (row === undefined) return false;
    if (row.requestHash !== requestHash) {
      throw new LostDemandRefusedError(
        'idempotency_key_reused',
        'the key named another suggestion',
      );
    }
    return true;
  }

  // AP §9.17 «Lost demand» (slice 2.41): a period's misses and
  // suggestions, from `from` (included) to `to` (excluded), as `report`
  // groups them, every row.
  async between(cityId: string, from: Date, to: Date): Promise<Omit<LostDemand, 'since'>> {
    const db = this.database.db;
    const [searches, suggestions] = await Promise.all([
      db
        .select({
          query: sql<string>`(array_agg(${searchMisses.query} ORDER BY ${searchMisses.at} DESC))[1]`,
          count: count(),
          lastAt: max(searchMisses.at),
        })
        .from(searchMisses)
        .where(
          and(eq(searchMisses.cityId, cityId), gte(searchMisses.at, from), lt(searchMisses.at, to)),
        )
        .groupBy(searchMisses.normalized)
        .orderBy(desc(count()), desc(max(searchMisses.at))),
      db
        .select({
          id: restaurantSuggestions.id,
          restaurantName: restaurantSuggestions.restaurantName,
          note: restaurantSuggestions.note,
          query: restaurantSuggestions.query,
          at: restaurantSuggestions.at,
        })
        .from(restaurantSuggestions)
        .where(
          and(
            eq(restaurantSuggestions.cityId, cityId),
            gte(restaurantSuggestions.at, from),
            lt(restaurantSuggestions.at, to),
          ),
        )
        .orderBy(desc(restaurantSuggestions.at)),
    ]);
    return {
      searches: searches.map((row) => ({
        query: row.query,
        count: row.count,
        lastAt: row.lastAt!,
      })),
      suggestions,
    };
  }

  // AP §9.17: the city's lost demand since LOST_DEMAND_DAYS ago.
  async report(cityId: string, now: Date): Promise<LostDemand> {
    const since = new Date(now.getTime() - LOST_DEMAND_DAYS * DAY_MS);
    const db = this.database.db;
    const [searches, suggestions] = await Promise.all([
      db
        .select({
          // The latest text typed for the search form.
          query: sql<string>`(array_agg(${searchMisses.query} ORDER BY ${searchMisses.at} DESC))[1]`,
          count: count(),
          lastAt: max(searchMisses.at),
        })
        .from(searchMisses)
        .where(and(eq(searchMisses.cityId, cityId), gte(searchMisses.at, since)))
        .groupBy(searchMisses.normalized)
        .orderBy(desc(count()), desc(max(searchMisses.at)))
        .limit(LOST_DEMAND_ROWS),
      db
        .select({
          id: restaurantSuggestions.id,
          restaurantName: restaurantSuggestions.restaurantName,
          note: restaurantSuggestions.note,
          query: restaurantSuggestions.query,
          at: restaurantSuggestions.at,
        })
        .from(restaurantSuggestions)
        .where(and(eq(restaurantSuggestions.cityId, cityId), gte(restaurantSuggestions.at, since)))
        .orderBy(desc(restaurantSuggestions.at))
        .limit(LOST_DEMAND_ROWS),
    ]);
    return {
      since,
      searches: searches.map((row) => ({
        query: row.query,
        count: row.count,
        lastAt: row.lastAt!,
      })),
      suggestions,
    };
  }
}
