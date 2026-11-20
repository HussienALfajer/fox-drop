import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gte, inArray, isNotNull, isNull, lt, or, sql, type SQL } from 'drizzle-orm';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { phoneOf } from '../../http/phone-search.js';
import { cutoffOn, GeoService } from '../geo/index.js';
import { CustomerAccountsService } from '../identity/index.js';
import { SettingsService } from '../settings/index.js';
import {
  handovers,
  orderOutcomes as orderOutcomeValues,
  orderOutcomeRows,
  orders,
  orderStatuses as orderStatusValues,
  reassignments,
  responsibleParties as responsibleValues,
} from './schema.js';

// AP §9.5 «سجل الطلبات» (slice 2.40): every order of a city, newest first,
// by the filters of the spec, a page at a time.
export const ADMIN_HISTORY_PAGE = 50;
// The most rows one Excel export holds (decided by us; a year of Azaz is far
// below it).
export const ADMIN_HISTORY_EXPORT_MAX = 50_000;

type OrderStatus = (typeof orderStatusValues)[number];
type OrderOutcome = (typeof orderOutcomeValues)[number];
type ResponsibleParty = (typeof responsibleValues)[number];

// The statuses an order no longer leaves (AP §8.1): read-only in the
// history, and the ones a financial correction is linked to.
export const FINISHED_STATUSES: readonly OrderStatus[] = [
  'delivered',
  'failed',
  'rejected',
  'cancelled',
];

export const historyKinds = ['all', 'real', 'test'] as const;
export type HistoryKind = (typeof historyKinds)[number];

export interface AdminHistoryFilter {
  cityId: string;
  number: bigint | null;
  // identity's customer accounts of the phone (a closed account's line
  // included, AP §8.8), found by the caller; empty matches nothing.
  customerAccountIds: string[] | null;
  restaurantId: string | null;
  // The captain who held the order last.
  captainId: string | null;
  // Business days on the city's clock, YYYY-MM-DD, each included.
  from: string | null;
  to: string | null;
  status: OrderStatus | null;
  outcome: OrderOutcome | null;
  responsible: ResponsibleParty | null;
  // A code as typed, any letter case.
  code: string | null;
  zoneId: string | null;
  kind: HistoryKind;
}

export interface AdminHistoryRow {
  id: string;
  number: bigint;
  placedAt: Date;
  restaurantId: string;
  neighbourhood: string;
  captainId: string | null;
  status: OrderStatus;
  outcome: OrderOutcome | null;
  // The outcome's party in force, or operations' cancellation's.
  responsible: ResponsibleParty | null;
  currency: string;
  total: bigint;
  promoCode: string | null;
  // From placing to delivery, in whole minutes; null unless delivered.
  deliveryMinutes: number | null;
  testOrder: boolean;
  redelivery: boolean;
}

// Who a finished order's financial correction may reach (AP §9.5): its
// restaurant, its customer and every captain who held it.
export interface CorrectionTarget {
  cityId: string;
  number: bigint;
  status: OrderStatus;
  finished: boolean;
  restaurantId: string;
  customerAccountId: string;
  captainIds: string[];
}

const day = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/)
  .refine((text) => new Date(`${text}T00:00:00Z`).toISOString().startsWith(text), 'a real day');

// The filters of AP §9.5 as the panel sends them, shared by the list and the
// export (a POST each, so a customer's phone never sits in a URL).
export const orderHistoryFilterBody = z.object({
  cityId: z.uuid(),
  number: z
    .string()
    .regex(/^#?\d{1,12}$/)
    .nullable()
    .describe('The order number, with or without #.'),
  customerPhone: z
    .string()
    .trim()
    .min(1)
    .max(30)
    .nullable()
    .describe('The customer phone in any usual form; customers.reveal_phone (OWN, OPS, SUP).'),
  restaurantId: z.uuid().nullable(),
  captainId: z.uuid().nullable().describe('The captain who held the order last.'),
  from: day.nullable().describe('The first business day, YYYY-MM-DD on the city clock.'),
  to: day.nullable().describe('The last business day, included.'),
  status: z.enum(orderStatusValues).nullable(),
  outcome: z.enum(orderOutcomeValues).nullable(),
  responsible: z
    .enum(responsibleValues)
    .nullable()
    .describe("The outcome's party in force, or operations' cancellation's."),
  code: z.string().trim().min(1).max(40).nullable().describe('The code used, any letter case.'),
  zoneId: z.uuid().nullable(),
  kind: z.enum(historyKinds).describe('all, real or test orders.'),
});
export type OrderHistoryFilterBody = z.infer<typeof orderHistoryFilterBody>;

export type HistoryFilterRefusal = 'invalid_period' | 'invalid_phone' | 'phone_not_allowed';

// The day after a YYYY-MM-DD day.
export function dayAfter(day: string): string {
  return new Date(Date.parse(`${day}T00:00:00Z`) + 86_400_000).toISOString().slice(0, 10);
}

@Injectable()
export class OrderHistoryService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly customerAccounts: CustomerAccountsService,
  ) {}

  // The body as a filter: the phone found as the customer's account, only for customers.reveal_phone (AP
  // §9.5, the rule of AP §7.2); the last day not before the first.
  async resolve(
    body: OrderHistoryFilterBody,
    permissions: readonly string[],
  ): Promise<AdminHistoryFilter | HistoryFilterRefusal> {
    if (body.from !== null && body.to !== null && body.to < body.from) return 'invalid_period';
    let customerAccountIds: string[] | null = null;
    if (body.customerPhone !== null) {
      if (!permissions.includes('customers.reveal_phone')) return 'phone_not_allowed';
      const phone = phoneOf(body.customerPhone);
      if (phone === null) return 'invalid_phone';
      // Every account of the number; none matches no order.
      customerAccountIds = await this.customerAccounts.customersByPhone(phone);
    }
    return {
      cityId: body.cityId,
      number: body.number === null ? null : BigInt(body.number.replace('#', '')),
      customerAccountIds,
      restaurantId: body.restaurantId,
      captainId: body.captainId,
      from: body.from,
      to: body.to,
      status: body.status,
      outcome: body.outcome,
      responsible: body.responsible,
      code: body.code,
      zoneId: body.zoneId,
      kind: body.kind,
    };
  }

  // One page, newest first by the placing time then the id; `after` is the
  // last row of the page before.
  async page(
    filter: AdminHistoryFilter,
    after: { placedAt: Date; id: string } | null,
  ): Promise<{ rows: AdminHistoryRow[]; more: boolean }> {
    const rows = await this.read(
      filter,
      after === null
        ? undefined
        : or(
            lt(orders.placedAt, after.placedAt),
            and(eq(orders.placedAt, after.placedAt), lt(orders.id, after.id)),
          ),
      ADMIN_HISTORY_PAGE + 1,
    );
    return { rows: rows.slice(0, ADMIN_HISTORY_PAGE), more: rows.length > ADMIN_HISTORY_PAGE };
  }

  // Every row of the filter for the Excel export, newest first, up to
  // ADMIN_HISTORY_EXPORT_MAX (a bigger export is refused when asked).
  all(filter: AdminHistoryFilter): Promise<AdminHistoryRow[]> {
    return this.read(filter, undefined, ADMIN_HISTORY_EXPORT_MAX);
  }

  async correctionTarget(orderId: string): Promise<CorrectionTarget | null> {
    const [order] = await this.database.db
      .select({
        cityId: orders.cityId,
        placedAt: orders.placedAt,
        number: orders.number,
        status: orders.status,
        restaurantId: orders.restaurantId,
        customerAccountId: orders.customerAccountId,
        captainId: orders.captainId,
        redeliveryCaptainId: orders.redeliveryCaptainId,
      })
      .from(orders)
      .where(eq(orders.id, orderId));
    if (!order) return null;
    // Every captain who held the order: the handovers received (both
    // sides) and the captains withdrawn from it, whose pickup payment a
    // «لا» left on their custody.
    const [handed, withdrawn] = await Promise.all([
      this.database.db
        .select({ from: handovers.fromCaptainId, to: handovers.toCaptainId })
        .from(handovers)
        .where(
          and(
            eq(handovers.orderId, orderId),
            eq(handovers.orderPlacedAt, order.placedAt),
            isNotNull(handovers.receivedAt),
          ),
        ),
      this.database.db
        .select({ captainId: reassignments.captainId })
        .from(reassignments)
        .where(
          and(eq(reassignments.orderId, orderId), eq(reassignments.orderPlacedAt, order.placedAt)),
        ),
    ]);
    const captainIds = new Set<string>();
    if (order.captainId) captainIds.add(order.captainId);
    for (const each of handed) {
      captainIds.add(each.from);
      captainIds.add(each.to);
    }
    for (const each of withdrawn) captainIds.add(each.captainId);
    return {
      cityId: order.cityId,
      number: order.number,
      status: order.status,
      finished: FINISHED_STATUSES.includes(order.status),
      restaurantId: order.restaurantId,
      customerAccountId: order.customerAccountId,
      captainIds: [...captainIds],
    };
  }

  // How many orders the filter holds, for the export's limit.
  async count(filter: AdminHistoryFilter): Promise<number> {
    const { where } = await this.where(filter, undefined);
    const [row] = await this.database.db
      .select({ count: sql<number>`count(*)::int` })
      .from(orders)
      .leftJoin(
        orderOutcomeRows,
        and(
          eq(orderOutcomeRows.orderId, orders.id),
          eq(orderOutcomeRows.orderPlacedAt, orders.placedAt),
          isNull(orderOutcomeRows.replacedAt),
        ),
      )
      .where(where);
    return Number(row?.count ?? 0);
  }

  // The filter as one condition; `responsible` is the outcome's party in
  // force, else the cancellation's (the outcome's row joined).
  private async where(filter: AdminHistoryFilter, cursor: SQL | undefined) {
    const conditions = [eq(orders.cityId, filter.cityId), cursor];
    if (filter.from !== null || filter.to !== null) {
      const [timeZone, cutoff] = await Promise.all([
        this.geo.cityTimeZone(filter.cityId),
        this.settings.get('finance.business_day_cutoff', { cityId: filter.cityId }),
      ]);
      if (timeZone === null) throw new Error('the city has no clock');
      const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
      const cutoffMinutes = hours * 60 + minutes;
      if (filter.from !== null) {
        conditions.push(gte(orders.placedAt, cutoffOn(filter.from, cutoffMinutes, timeZone)));
      }
      if (filter.to !== null) {
        conditions.push(
          lt(orders.placedAt, cutoffOn(dayAfter(filter.to), cutoffMinutes, timeZone)),
        );
      }
    }
    const responsible = sql<ResponsibleParty | null>`coalesce(${orderOutcomeRows.responsible}, ${orders.cancelResponsible})`;
    if (filter.number !== null) conditions.push(eq(orders.number, filter.number));
    if (filter.customerAccountIds !== null) {
      conditions.push(
        filter.customerAccountIds.length === 0
          ? sql`false`
          : inArray(orders.customerAccountId, filter.customerAccountIds),
      );
    }
    if (filter.restaurantId !== null) conditions.push(eq(orders.restaurantId, filter.restaurantId));
    if (filter.captainId !== null) conditions.push(eq(orders.captainId, filter.captainId));
    if (filter.status !== null) conditions.push(eq(orders.status, filter.status));
    if (filter.outcome !== null) conditions.push(eq(orders.outcome, filter.outcome));
    if (filter.responsible !== null) conditions.push(sql`${responsible} = ${filter.responsible}`);
    if (filter.code !== null) {
      conditions.push(sql`upper(${orders.promoCode}) = upper(${filter.code})`);
    }
    if (filter.zoneId !== null) conditions.push(eq(orders.zoneId, filter.zoneId));
    if (filter.kind !== 'all') conditions.push(eq(orders.testOrder, filter.kind === 'test'));
    return { where: and(...conditions), responsible };
  }

  private async read(
    filter: AdminHistoryFilter,
    cursor: SQL | undefined,
    limit: number,
  ): Promise<AdminHistoryRow[]> {
    const { where, responsible } = await this.where(filter, cursor);
    const rows = await this.database.db
      .select({
        id: orders.id,
        number: orders.number,
        placedAt: orders.placedAt,
        restaurantId: orders.restaurantId,
        neighbourhood: orders.neighbourhood,
        captainId: orders.captainId,
        status: orders.status,
        outcome: orders.outcome,
        responsible,
        currency: orders.currency,
        total: orders.total,
        promoCode: orders.promoCode,
        deliveredAt: orders.deliveredAt,
        testOrder: orders.testOrder,
        redeliveryOfId: orders.redeliveryOfId,
      })
      .from(orders)
      .leftJoin(
        orderOutcomeRows,
        and(
          eq(orderOutcomeRows.orderId, orders.id),
          eq(orderOutcomeRows.orderPlacedAt, orders.placedAt),
          isNull(orderOutcomeRows.replacedAt),
        ),
      )
      .where(where)
      .orderBy(desc(orders.placedAt), desc(orders.id))
      .limit(limit);
    return rows.map(({ deliveredAt, redeliveryOfId, ...row }) => ({
      ...row,
      deliveryMinutes:
        deliveredAt === null
          ? null
          : Math.round((deliveredAt.getTime() - row.placedAt.getTime()) / 60_000),
      redelivery: redeliveryOfId !== null,
    }));
  }
}
