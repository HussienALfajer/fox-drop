import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { and, desc, eq, inArray, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { ContentService, type ReasonList } from '../content/index.js';
import { CaptainsService } from '../captains/index.js';
import { type CustomerRating, CustomersService } from '../customers/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { lockOrder } from './order-events.js';
import type { OrderView } from './order-views.js';
import { OrdersService } from './orders.service.js';
import { orders, ratingParties, ratings } from './schema.js';

// CU §12.1, U15, Q16 (slice 2.26a): the customer's ratings of a delivered
// order, the restaurant and the captain apart.

export type RatingParty = (typeof ratingParties)[number];

export const RATING_COMMENT_MAX = 300;

export interface RatingPart {
  stars: number;
  reasons: string[];
  comment: string | null;
}

export interface RatingView {
  party: RatingParty;
  stars: number;
  reasons: { code: string; label: string }[];
  comment: string | null;
  at: Date;
}

export type RatingRefusal =
  | 'unknown_order'
  | 'not_ratable'
  | 'rating_closed'
  | 'already_rated'
  | 'invalid_rating'
  | 'unknown_reason';

export class RatingRefusedError extends Error {
  constructor(readonly refusal: RatingRefusal) {
    super(refusal);
  }
}

// Content's list of reasons for the stars (AP Appendix B): 1–2, 3, 4–5.
export function reasonListFor(party: RatingParty, stars: number): ReasonList {
  const band = stars <= 2 ? 'low' : stars === 3 ? 'mid' : 'high';
  return `${party}_rating_${band}`;
}

// The end of the rating window: delivered orders only, whatever the outcome,
// never a free re-delivery (CU §12.1, AP §9.9.3); null when it cannot be rated.
export function ratingUntil(
  order: { status: string; deliveredAt: Date | null; redelivery: boolean },
  windowDays: number,
): Date | null {
  if (order.status !== 'delivered' || order.deliveredAt === null || order.redelivery) return null;
  return new Date(order.deliveredAt.getTime() + windowDays * 86_400_000);
}

// The pure rule of a rating: within the window, each part once, the captain's
// only when a captain delivered it, each reason once.
export function ratingProblem(input: {
  until: Date | null;
  now: Date;
  captainId: string | null;
  rated: readonly RatingParty[];
  parts: Partial<Record<RatingParty, RatingPart>>;
}): RatingRefusal | null {
  const given = ratingParties.filter((party) => input.parts[party] !== undefined);
  if (given.length === 0) return 'invalid_rating';
  if (input.until === null) return 'not_ratable';
  if (input.now.getTime() >= input.until.getTime()) return 'rating_closed';
  if (input.parts.captain !== undefined && input.captainId === null) return 'not_ratable';
  for (const party of given) {
    const part = input.parts[party]!;
    if (!Number.isInteger(part.stars) || part.stars < 1 || part.stars > 5) return 'invalid_rating';
    if (new Set(part.reasons).size !== part.reasons.length) return 'invalid_rating';
  }
  if (given.some((party) => input.rated.includes(party))) return 'already_rated';
  return null;
}

@Injectable()
export class RatingsService implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly orders: OrdersService,
    private readonly content: ContentService,
    private readonly settings: SettingsService,
    private readonly customers: CustomersService,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
  ) {}

  onModuleInit(): void {
    this.customers.useRatings({
      restaurants: (restaurantIds) => this.restaurantSummaries(restaurantIds),
      written: (accountId, cityId) => this.written(accountId, cityId),
    });
  }

  // When the order can be rated until, for its detail; null when it cannot.
  async until(order: OrderView, deliveredAt: Date | null): Promise<Date | null> {
    const windowDays = await this.settings.get('customer.rating_window_days', {
      cityId: order.cityId,
    });
    return ratingUntil(
      { status: order.status, deliveredAt, redelivery: order.redelivery !== null },
      windowDays,
    );
  }

  ofOrder(orderId: string): Promise<RatingView[]> {
    return this.database.db
      .select({
        party: ratings.party,
        stars: ratings.stars,
        reasons: sql<{ code: string; label: string }[]>`${ratings.reasons}`,
        comment: ratings.comment,
        at: ratings.at,
      })
      .from(ratings)
      .where(eq(ratings.orderId, orderId));
  }

  // POST /v1/customer/orders/{orderId}/rating: the reasons checked against
  // Content before the transaction, then under the order's lock the window,
  // the captain and the parts already sent (Q16: never edited).
  async rate(
    accountId: string,
    orderId: string,
    parts: Partial<Record<RatingParty, RatingPart>>,
    now: Date,
  ): Promise<void> {
    const order = await this.orders.customerOrder(accountId, orderId);
    if (!order) throw new RatingRefusedError('unknown_order');
    const chosen = new Map<RatingParty, { code: string; label: string }[]>();
    for (const party of ratingParties) {
      const part = parts[party];
      if (part === undefined) continue;
      if (part.stars < 1 || part.stars > 5) throw new RatingRefusedError('invalid_rating');
      // An active reason of the list for the stars; a rating's chip takes
      // no text, whatever note mode the panel gives it.
      const active = new Map(
        (await this.content.reasonsOf(reasonListFor(party, part.stars)))
          .filter((reason) => reason.active)
          .map((reason) => [reason.code, reason.label]),
      );
      const reasons: { code: string; label: string }[] = [];
      for (const code of part.reasons) {
        const label = active.get(code);
        if (label === undefined) throw new RatingRefusedError('unknown_reason');
        reasons.push({ code, label });
      }
      chosen.set(party, reasons);
    }
    const windowDays = await this.settings.get('customer.rating_window_days', {
      cityId: order.cityId,
    });
    await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new RatingRefusedError('unknown_order');
      const deliveredAt = await this.orders.deliveredAt(order.id, order.placedAt, tx);
      const rated = await tx
        .select({ party: ratings.party })
        .from(ratings)
        .where(eq(ratings.orderId, order.id));
      const problem = ratingProblem({
        until: ratingUntil(
          { status: locked.status, deliveredAt, redelivery: order.redelivery !== null },
          windowDays,
        ),
        now,
        captainId: locked.captainId,
        rated: rated.map((row) => row.party),
        parts,
      });
      if (problem !== null) throw new RatingRefusedError(problem);
      for (const [party, reasons] of chosen) {
        const part = parts[party]!;
        await tx.insert(ratings).values({
          orderId: order.id,
          orderPlacedAt: order.placedAt,
          cityId: order.cityId,
          customerId: accountId,
          party,
          restaurantId: order.restaurantId,
          captainId: party === 'captain' ? locked.captainId : null,
          stars: part.stars,
          reasons,
          comment: part.comment,
          testOrder: order.testOrder,
          at: now,
        });
      }
    });
  }

  // Each restaurant's count and average of its ratings, test orders left out.
  async restaurantSummaries(
    restaurantIds: string[],
  ): Promise<Map<string, { count: number; average: number }>> {
    if (restaurantIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({
        restaurantId: ratings.restaurantId,
        count: sql<number>`count(*)::int`,
        average: sql<number>`avg(${ratings.stars})::float8`,
      })
      .from(ratings)
      .where(
        and(
          eq(ratings.party, 'restaurant'),
          eq(ratings.testOrder, false),
          inArray(ratings.restaurantId, restaurantIds),
        ),
      )
      .groupBy(ratings.restaurantId);
    return new Map(rows.map((row) => [row.restaurantId, row]));
  }

  // AP §9.8 «التقييمات المكتوبة»: the customer's latest 20 ratings in the
  // city, with the order's number, the restaurant's and the captain's names.
  async written(accountId: string, cityId: string): Promise<CustomerRating[]> {
    const rows = await this.database.db
      .select({
        orderId: ratings.orderId,
        orderNumber: orders.number,
        party: ratings.party,
        restaurantId: ratings.restaurantId,
        captainId: ratings.captainId,
        stars: ratings.stars,
        reasons: sql<{ code: string; label: string }[]>`${ratings.reasons}`,
        comment: ratings.comment,
        at: ratings.at,
      })
      .from(ratings)
      .innerJoin(
        orders,
        and(eq(orders.id, ratings.orderId), eq(orders.placedAt, ratings.orderPlacedAt)),
      )
      .where(and(eq(ratings.customerId, accountId), eq(ratings.cityId, cityId)))
      .orderBy(desc(ratings.at), ratings.party)
      .limit(20);
    const [restaurants, captains] = await Promise.all([
      this.merchants.names([...new Set(rows.map((row) => row.restaurantId))]),
      this.captains.names([...new Set(rows.flatMap((row) => row.captainId ?? []))]),
    ]);
    return rows.map(({ restaurantId, captainId, ...row }) => ({
      ...row,
      restaurantName: restaurants.get(restaurantId)?.nameAr ?? null,
      captainName: captainId === null ? null : (captains.get(captainId) ?? null),
    }));
  }
}
