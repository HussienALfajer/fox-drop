import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, gt, gte, inArray, lte, ne, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { NotificationTexts } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService, lastCutoff } from '../geo/index.js';
import { PushQueue } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import {
  type AvailableCode,
  type CodeContext,
  type CodeRefusal,
  codeRefusal,
  ENDED_CODES_DAYS,
  type MyCode,
  openToCustomer,
  runsNow,
  type CodeTerms,
  fixedAmountAboveItems,
  minuteOfDay,
  normalizeCode,
  promoDiscount,
  type PromoDiscount,
} from './promo-codes.js';
import { promoCodes, promoCodeUses, type PromoCodeUseStatus } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type Executor = Database['db'] | Tx;

// What a typed code is checked against (CU §10.4, §10.6): the cart priced in
// the city's base currency, and the signed-in customer (null for a guest).
export interface CodeCart {
  cityId: string;
  // The city's clock and business day at the moment checked (`clock`), read
  // before any transaction, so the hold reads nothing through the pool.
  clock: CodeClock;
  code: string;
  baseCurrency: string;
  restaurantId: string;
  zoneId: string | null;
  itemsValue: bigint;
  deliveryFee: bigint;
  customer: {
    accountId: string;
    // AP §8.8 (slice 2.25c): every account of the number and of the
    // account's line, whose uses count toward the per-customer limit.
    accountIds: string[];
    // identity's keyed hash of the number, and the app installation.
    phoneHash: string;
    deviceId: string;
    // AP §9.11.1, §8.8: no delivered order on any account of the number.
    newUser: boolean;
  } | null;
}

// AP §9.8 «الأكواد المستخدمة» (slice 2.25b): one use of a code by the
// customer, newest first.
export interface CustomerCodeUse {
  code: string;
  kind: (typeof promoCodes.$inferSelect)['kind'];
  orderId: string;
  currency: string;
  discount: bigint;
  status: PromoCodeUseStatus;
  heldAt: Date;
}

export interface CodeClock {
  timeZone: string;
  // The cutoff that started the business day (finance.business_day_cutoff).
  businessDay: Date;
}

// A code that applies: what the order keeps of it and its discount.
export interface AppliedCode {
  codeId: string;
  code: string;
  terms: CodeTerms;
  discount: PromoDiscount;
  // CU §10.4: «قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق».
  fixedAmountAboveItems: boolean;
}

export type CodeCheck =
  | { applied: true; code: AppliedCode }
  // missing: what below_minimum lacks («أضف {المبلغ} لاستخدام هذا الكود»).
  | { applied: false; refusal: CodeRefusal; missing: bigint | null };

// The use a placing holds, recorded once the order has its id.
export type HeldCode = CodeCheck & {
  record?: (order: { id: string; placedAt: Date }) => Promise<void>;
};

// AP §9.11.1 (slice 2.21b): a code checked on a quote, held when the order
// is placed and settled when the order ends. The ordering module calls it;
// a use counts while it is not given back.
@Injectable()
export class PromoCodeUsesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
    private readonly fx: FxService,
  ) {}

  // The city's clock for a cart (owner decision 2026-11-16: the daily
  // report's business day), read through the pool before the transaction.
  async clock(cityId: string, now: Date): Promise<CodeClock> {
    const timeZone = await this.geo.cityTimeZone(cityId);
    if (timeZone === null) throw new Error(`city ${cityId} does not exist`);
    const cutoff = await this.settings.get('finance.business_day_cutoff', { cityId });
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    return { timeZone, businessDay: lastCutoff(now, hours * 60 + minutes, timeZone) };
  }

  // The quote's check, outside any transaction.
  async check(cart: CodeCart, now: Date): Promise<CodeCheck> {
    return this.evaluate(this.database.db, cart, now, false);
  }

  // Placing's check, in its transaction under the code's lock, so two orders
  // never take a code's last use or the rest of its day; record() keeps the
  // use with the order.
  async hold(tx: Tx, cart: CodeCart, now: Date): Promise<HeldCode> {
    if (cart.customer === null) throw new Error('a code is held for a signed-in customer');
    const customer = cart.customer;
    const checked = await this.evaluate(tx, cart, now, true);
    if (!checked.applied) return checked;
    const { code } = checked;
    const { businessDay } = cart.clock;
    return {
      ...checked,
      record: async (order) => {
        await tx.insert(promoCodeUses).values({
          codeId: code.codeId,
          cityId: cart.cityId,
          orderId: order.id,
          orderPlacedAt: order.placedAt,
          customerAccountId: customer.accountId,
          phoneHash: customer.phoneHash,
          deviceId: customer.deviceId,
          businessDay,
          currency: cart.baseCurrency,
          discount: code.discount.total,
          merchantShare: code.discount.merchant,
          heldAt: now,
          newUser: customer.newUser,
        });
      },
    };
  }

  // The order ended (AP §9.11.1): spent when delivered or failed with the
  // customer responsible, given back otherwise. An outcome changed later
  // settles it again. An order without a code has no use: nothing happens.
  // `delivered`: the order ended delivered, for the code report's new
  // customers (slice 2.21d).
  async settle(
    tx: Tx,
    orderId: string,
    status: Exclude<PromoCodeUseStatus, 'held'>,
    now: Date,
    delivered = false,
  ): Promise<void> {
    const [use] = await tx
      .update(promoCodeUses)
      .set({ status, settledAt: now, delivered })
      .where(
        and(
          eq(promoCodeUses.orderId, orderId),
          or(ne(promoCodeUses.status, status), ne(promoCodeUses.delivered, delivered)),
        ),
      )
      .returning({
        codeId: promoCodeUses.codeId,
        cityId: promoCodeUses.cityId,
        accountId: promoCodeUses.customerAccountId,
        phoneHash: promoCodeUses.phoneHash,
        deviceId: promoCodeUses.deviceId,
        newUser: promoCodeUses.newUser,
      });
    if (status !== 'returned' || use === undefined) return;
    // CU §10.4, §14 #23 (owner decision 2026-11-16): «أُعيد الكود {الكود}
    // إلى أكوادك» once the code is back in the customer's «متاحة», by
    // `mine`'s rule. Whether they are still new is the placing's answer: the
    // order given back was not delivered.
    const [code] = await tx.select().from(promoCodes).where(eq(promoCodes.id, use.codeId));
    const baseCurrency = await this.fx.baseCurrency(use.cityId, tx);
    if (!code || baseCurrency === null || !runsNow(code, baseCurrency, now)) return;
    const count =
      (
        await this.counts(tx, [code.id], {
          customer: {
            accountId: use.accountId,
            accountIds: [use.accountId],
            phoneHash: use.phoneHash,
            deviceId: use.deviceId,
            newUser: use.newUser,
          },
          // The day's cost is not read here.
          clock: { timeZone: 'UTC', businessDay: now },
        })
      ).get(code.id) ?? NO_USES;
    const open = openToCustomer(code, {
      newUser: use.newUser,
      mine: count.mine,
      phoneOrDeviceUsed: count.sameNumberOrDevice > 0,
      total: count.total,
    });
    if (!open) return;
    const templateKey = 'customer.code_returned';
    const rendered = await this.texts.render(templateKey, { الكود: code.code }, tx);
    await this.pushes.enqueue(
      tx,
      [
        {
          source: `marketing:${templateKey}:${orderId}:${now.toISOString()}`,
          recipient: { party: 'customer', accountId: use.accountId },
          templateKey,
          body: rendered.body,
          level: rendered.level,
          priority: rendered.priority,
          data: { target: 'codes' },
          at: now,
        },
      ],
      now,
    );
  }

  // CU §12.4 «أكوادي» (slice 2.21d): «متاحة», the visible codes running in
  // the city now that are open to this customer (`openToCustomer`), and
  // «منتهية», those they used up or that ended within the last 30 days. A
  // code the account used (a use not given back) and can no longer use is
  // `used`, a secret one included; a visible code that ended without being
  // used up is `expired` when its audience took the customer.
  async mine(
    scope: Pick<CodeCart, 'cityId' | 'baseCurrency' | 'clock'> & {
      customer: NonNullable<CodeCart['customer']>;
    },
    now: Date,
  ): Promise<MyCode[]> {
    const since = new Date(now.getTime() - ENDED_CODES_DAYS * 24 * 60 * 60 * 1000);
    const { customer } = scope;
    const used = await this.database.db
      .select({
        codeId: promoCodeUses.codeId,
        last: sql<string>`max(${promoCodeUses.heldAt})::text`,
      })
      .from(promoCodeUses)
      .where(
        and(
          inArray(promoCodeUses.customerAccountId, customer.accountIds),
          eq(promoCodeUses.cityId, scope.cityId),
          counting,
          gte(promoCodeUses.heldAt, since),
        ),
      )
      .groupBy(promoCodeUses.codeId);
    const lastUse = new Map(used.map((row) => [row.codeId, new Date(row.last)]));
    const running = and(
      listedFor(customer),
      eq(promoCodes.currency, scope.baseCurrency),
      lte(promoCodes.validFrom, now),
      gt(promoCodes.validTo, since),
    );
    const rows = await this.database.db
      .select()
      .from(promoCodes)
      .where(
        and(
          eq(promoCodes.cityId, scope.cityId),
          lastUse.size === 0 ? running : or(running, inArray(promoCodes.id, [...lastUse.keys()])),
        ),
      );
    if (rows.length === 0) return [];
    const counts = await this.counts(
      this.database.db,
      rows.map((row) => row.id),
      scope,
    );
    const listed: MyCode[] = [];
    for (const row of rows) {
      const count = counts.get(row.id) ?? NO_USES;
      const open = openToCustomer(row, {
        newUser: customer.newUser,
        mine: count.mine,
        phoneOrDeviceUsed: count.sameNumberOrDevice > 0,
        total: count.total,
      });
      const last = lastUse.get(row.id);
      let ended: MyCode['ended'];
      if (open && runsNow(row, scope.baseCurrency, now)) ended = null;
      // Used up by this customer; a code they may still use but that is
      // paused or secret waits, and shows as expired once it ends.
      else if (last !== undefined && !open) ended = { reason: 'used', at: last };
      else if (
        row.visibility !== 'secret' &&
        row.validTo.getTime() <= now.getTime() &&
        (row.audience === 'everyone' || customer.newUser)
      ) {
        ended = { reason: 'expired', at: row.validTo };
      } else continue;
      listed.push({
        codeId: row.id,
        code: row.code,
        kind: row.kind,
        percentBp: row.percentBp,
        amount: row.amount,
        maxDiscount: row.maxDiscount,
        minOrder: row.minOrder,
        restaurantIds: row.restaurantIds,
        zoneIds: row.zoneIds,
        startMinute: row.startMinute,
        endMinute: row.endMinute,
        validTo: row.validTo,
        usesLeft:
          row.perCustomerLimit === null ? null : Math.max(row.perCustomerLimit - count.mine, 0),
        ended,
      });
    }
    // «متاحة» by the nearest end, «منتهية» newest first.
    return listed.sort((a, b) => {
      if (a.ended === null || b.ended === null) {
        if (a.ended !== b.ended) return a.ended === null ? -1 : 1;
        const by = a.validTo.getTime() - b.validTo.getTime();
        return by !== 0 ? by : a.code < b.code ? -1 : 1;
      }
      const by = b.ended.at.getTime() - a.ended.at.getTime();
      return by !== 0 ? by : a.code < b.code ? -1 : 1;
    });
  }

  // AP §9.8 (slice 2.25b): the customer's latest code uses in the city, for
  // the panel's profile: held, spent or given back.
  async usesOf(accountId: string, cityId: string, limit: number): Promise<CustomerCodeUse[]> {
    return this.database.db
      .select({
        code: promoCodes.code,
        kind: promoCodes.kind,
        orderId: promoCodeUses.orderId,
        currency: promoCodeUses.currency,
        discount: promoCodeUses.discount,
        status: promoCodeUses.status,
        heldAt: promoCodeUses.heldAt,
      })
      .from(promoCodeUses)
      .innerJoin(promoCodes, eq(promoCodes.id, promoCodeUses.codeId))
      .where(and(eq(promoCodeUses.customerAccountId, accountId), eq(promoCodeUses.cityId, cityId)))
      .orderBy(desc(promoCodeUses.heldAt), desc(promoCodeUses.id))
      .limit(limit);
  }

  // AP §9.3.3 (slice 2.21b): an edit worked the order's discount out again
  // (owner decision 2026-11-16), so the use's cost follows it.
  async adjust(tx: Tx, orderId: string, discount: PromoDiscount): Promise<void> {
    await tx
      .update(promoCodeUses)
      .set({ discount: discount.total, merchantShare: discount.merchant })
      .where(eq(promoCodeUses.orderId, orderId));
  }

  // AP §9.11.1 «Code report» (slice 2.21d): the orders that used the code
  // and the customers (accounts) behind them, its cost and the restaurants'
  // part of it, counting the uses not given back; the uses given back; and
  // the new customers it acquired: numbers whose order with the code was
  // placed while they had no delivered order and ended delivered (owner
  // decision 2026-11-16).
  async report(codeId: string): Promise<CodeReport> {
    const [row] = await this.database.db
      .select({
        orders: sql<number>`count(*) FILTER (WHERE ${counting})::int`,
        returned: sql<number>`count(*) FILTER (WHERE NOT (${counting}))::int`,
        customers: sql<number>`count(DISTINCT ${promoCodeUses.customerAccountId}) FILTER (WHERE ${counting})::int`,
        cost: sql<string>`coalesce(sum(${promoCodeUses.discount}) FILTER (WHERE ${counting}), 0)::text`,
        merchantShare: sql<string>`coalesce(sum(${promoCodeUses.merchantShare}) FILTER (WHERE ${counting}), 0)::text`,
        newCustomers: sql<number>`count(DISTINCT ${promoCodeUses.phoneHash}) FILTER (WHERE ${promoCodeUses.newUser} AND ${promoCodeUses.delivered})::int`,
      })
      .from(promoCodeUses)
      .where(eq(promoCodeUses.codeId, codeId));
    return {
      orders: row!.orders,
      returned: row!.returned,
      customers: row!.customers,
      cost: BigInt(row!.cost),
      merchantShare: BigInt(row!.merchantShare),
      newCustomers: row!.newCustomers,
    };
  }

  // AP §9.17 «Codes» (slice 2.41): each code's uses held between two
  // moments, not given back: the orders, the discount (the cost), the
  // restaurants' share and the new customers who got their order delivered
  // with it, by code, the most used first.
  async periodReport(
    cityId: string,
    from: Date,
    to: Date,
  ): Promise<(CodeReport & { codeId: string; code: string; currency: string })[]> {
    const rows = await this.database.db
      .select({
        codeId: promoCodeUses.codeId,
        code: promoCodes.code,
        currency: promoCodeUses.currency,
        orders: sql<number>`count(*) FILTER (WHERE ${counting})::int`,
        returned: sql<number>`count(*) FILTER (WHERE NOT (${counting}))::int`,
        customers: sql<number>`count(DISTINCT ${promoCodeUses.customerAccountId}) FILTER (WHERE ${counting})::int`,
        cost: sql<string>`coalesce(sum(${promoCodeUses.discount}) FILTER (WHERE ${counting}), 0)::text`,
        merchantShare: sql<string>`coalesce(sum(${promoCodeUses.merchantShare}) FILTER (WHERE ${counting}), 0)::text`,
        newCustomers: sql<number>`count(DISTINCT ${promoCodeUses.phoneHash}) FILTER (WHERE ${promoCodeUses.newUser} AND ${promoCodeUses.delivered})::int`,
      })
      .from(promoCodeUses)
      .innerJoin(promoCodes, eq(promoCodes.id, promoCodeUses.codeId))
      .where(
        and(
          eq(promoCodeUses.cityId, cityId),
          gte(promoCodeUses.heldAt, from),
          sql`${promoCodeUses.heldAt} < ${to.toISOString()}`,
        ),
      )
      .groupBy(promoCodeUses.codeId, promoCodes.code, promoCodeUses.currency)
      .orderBy(sql`count(*) DESC`, promoCodes.code);
    return rows.map((row) => ({
      ...row,
      cost: BigInt(row.cost),
      merchantShare: BigInt(row.merchantShare),
    }));
  }

  // The list's «الاستخدامات» and «التكلفة حتى الآن»: the uses not given back
  // and their discounts, per code.
  async totals(codeIds: readonly string[]): Promise<Map<string, { uses: number; cost: bigint }>> {
    if (codeIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({
        codeId: promoCodeUses.codeId,
        uses: sql<number>`count(*)::int`,
        cost: sql<string>`coalesce(sum(${promoCodeUses.discount}), 0)::text`,
      })
      .from(promoCodeUses)
      .where(and(inArray(promoCodeUses.codeId, [...codeIds]), counting))
      .groupBy(promoCodeUses.codeId);
    return new Map(rows.map((row) => [row.codeId, { uses: row.uses, cost: BigInt(row.cost) }]));
  }

  // CU §10.4 «الأكواد المتاحة لك» (slice 2.21d, owner decision 2026-11-16):
  // the visible codes running in the city that apply to this cart, largest
  // discount first, then those only its minimum keeps out, by what is
  // missing. A code refused for anything else is left out (another
  // restaurant's, used up, for new users only, the day's budget reached).
  async available(cart: Omit<CodeCart, 'code'>, now: Date): Promise<AvailableCode[]> {
    const rows = await this.database.db
      .select()
      .from(promoCodes)
      .where(
        and(
          eq(promoCodes.cityId, cart.cityId),
          listedFor(cart.customer),
          eq(promoCodes.status, 'active'),
          eq(promoCodes.currency, cart.baseCurrency),
          lte(promoCodes.validFrom, now),
          gt(promoCodes.validTo, now),
        ),
      );
    if (rows.length === 0) return [];
    const counts = await this.counts(
      this.database.db,
      rows.map((row) => row.id),
      cart,
    );
    const listed: AvailableCode[] = [];
    for (const row of rows) {
      const count = counts.get(row.id) ?? NO_USES;
      // Checked as if the minimum were reached, so only the minimum is missing.
      const below = row.minOrder !== null && cart.itemsValue < row.minOrder;
      const refused = codeRefusal(
        row,
        this.context(cart, now, count, below ? row.minOrder! : cart.itemsValue),
      );
      if (refused !== null) continue;
      const terms = codeTerms(row);
      listed.push({
        codeId: row.id,
        code: row.code,
        kind: row.kind,
        percentBp: row.percentBp,
        amount: row.amount,
        maxDiscount: row.maxDiscount,
        minOrder: row.minOrder,
        startMinute: row.startMinute,
        endMinute: row.endMinute,
        validTo: row.validTo,
        discount: below ? null : promoDiscount(terms, cart),
        missing: below ? row.minOrder! - cart.itemsValue : null,
      });
    }
    return listed.sort((a, b) => {
      if ((a.discount === null) !== (b.discount === null)) return a.discount === null ? 1 : -1;
      const by =
        a.discount !== null
          ? Number(b.discount!.total - a.discount.total)
          : Number(a.missing! - b.missing!);
      return by !== 0 ? by : a.code < b.code ? -1 : a.code > b.code ? 1 : 0;
    });
  }

  // The uses of codes that count, per code: in all, this account's, by the
  // same number or device, and the business day's cost.
  private async counts(
    db: Executor,
    codeIds: string[],
    cart: Pick<CodeCart, 'customer' | 'clock'>,
  ): Promise<Map<string, UseCounts>> {
    const { customer } = cart;
    const rows = await db
      .select({
        codeId: promoCodeUses.codeId,
        total: sql<number>`count(*)::int`,
        mine: customer
          ? sql<number>`count(*) FILTER (WHERE ${inArray(promoCodeUses.customerAccountId, customer.accountIds)})::int`
          : sql<number>`0`,
        sameNumberOrDevice: customer
          ? sql<number>`count(*) FILTER (WHERE ${or(
              eq(promoCodeUses.phoneHash, customer.phoneHash),
              eq(promoCodeUses.deviceId, customer.deviceId),
            )})::int`
          : sql<number>`0`,
        dayCost: sql<string>`coalesce(sum(${promoCodeUses.discount}) FILTER (WHERE ${promoCodeUses.businessDay} = ${cart.clock.businessDay.toISOString()}::timestamptz), 0)::text`,
      })
      .from(promoCodeUses)
      .where(and(inArray(promoCodeUses.codeId, codeIds), counting))
      .groupBy(promoCodeUses.codeId);
    return new Map(
      rows.map((row) => [
        row.codeId,
        {
          total: row.total,
          mine: row.mine,
          sameNumberOrDevice: row.sameNumberOrDevice,
          dayCost: BigInt(row.dayCost),
        },
      ]),
    );
  }

  private context(
    cart: Omit<CodeCart, 'code'>,
    now: Date,
    count: UseCounts,
    itemsValue: bigint,
  ): CodeContext {
    const { customer } = cart;
    return {
      now,
      minuteOfDay: minuteOfDay(now, cart.clock.timeZone),
      baseCurrency: cart.baseCurrency,
      restaurantId: cart.restaurantId,
      zoneId: cart.zoneId,
      itemsValue,
      customer: customer && {
        newUser: customer.newUser,
        uses: count.mine,
        phoneOrDeviceUsed: count.sameNumberOrDevice > 0,
      },
      totalUses: count.total,
      dayCost: count.dayCost,
    };
  }

  private async evaluate(
    db: Executor,
    cart: CodeCart,
    now: Date,
    lock: boolean,
  ): Promise<CodeCheck> {
    const typed = normalizeCode(cart.code);
    const [row] = await db
      .select()
      .from(promoCodes)
      .where(and(eq(promoCodes.cityId, cart.cityId), eq(promoCodes.code, typed)));
    // A personal code (compensation, late code; slice 2.22b) exists only for
    // its customer: anyone else, a guest included, is told it does not.
    if (
      !row ||
      (row.visibility === 'personal' &&
        (cart.customer === null || cart.customer.accountId !== row.customerAccountId))
    ) {
      return { applied: false, refusal: 'unknown_code', missing: null };
    }
    if (lock) {
      await db.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`marketing.code:${row.id}`}, 0))`,
      );
    }
    const count = (await this.counts(db, [row.id], cart)).get(row.id) ?? NO_USES;
    const refused = codeRefusal(row, this.context(cart, now, count, cart.itemsValue));
    if (refused !== null) return { applied: false, ...refused };
    const terms = codeTerms(row);
    return {
      applied: true,
      code: {
        codeId: row.id,
        code: row.code,
        terms,
        discount: promoDiscount(terms, cart),
        fixedAmountAboveItems: fixedAmountAboveItems(terms, cart.itemsValue),
      },
    };
  }
}

export interface CodeReport {
  orders: number;
  returned: number;
  customers: number;
  cost: bigint;
  merchantShare: bigint;
  newCustomers: number;
}

// A use counts while it is not given back.
const counting = ne(promoCodeUses.status, 'returned');

interface UseCounts {
  total: number;
  mine: number;
  sameNumberOrDevice: number;
  dayCost: bigint;
}

const NO_USES: UseCounts = { total: 0, mine: 0, sameNumberOrDevice: 0, dayCost: 0n };

function codeTerms(row: typeof promoCodes.$inferSelect): CodeTerms {
  return {
    kind: row.kind,
    percentBp: row.percentBp,
    amount: row.amount,
    maxDiscount: row.maxDiscount,
    merchantShareBp: row.merchantShareBp,
    compensation: row.visibility === 'personal',
  };
}

// The codes a customer may read in a city's lists: the visible ones, and
// their own personal codes (CU §10.4, §12.4; slice 2.22b).
function listedFor(customer: { accountId: string } | null) {
  const visible = eq(promoCodes.visibility, 'visible');
  return customer === null
    ? visible
    : or(
        visible,
        and(
          eq(promoCodes.visibility, 'personal'),
          eq(promoCodes.customerAccountId, customer.accountId),
        ),
      );
}
