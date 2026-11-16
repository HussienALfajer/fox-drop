import { Inject, Injectable } from '@nestjs/common';
import { and, eq, gt, inArray, lte, ne, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService, lastCutoff } from '../geo/index.js';
import { SettingsService } from '../settings/index.js';
import {
  type AvailableCode,
  type CodeContext,
  type CodeRefusal,
  codeRefusal,
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
    // identity's keyed hash of the number, and the app installation.
    phoneHash: string;
    deviceId: string;
    // AP §9.11.1, §8.8: no delivered order on any account of the number.
    newUser: boolean;
  } | null;
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
        });
      },
    };
  }

  // The order ended (AP §9.11.1): spent when delivered or failed with the
  // customer responsible, given back otherwise. An outcome changed later
  // settles it again. An order without a code has no use: nothing happens.
  async settle(
    tx: Tx,
    orderId: string,
    status: Exclude<PromoCodeUseStatus, 'held'>,
    now: Date,
  ): Promise<void> {
    await tx
      .update(promoCodeUses)
      .set({ status, settledAt: now })
      .where(and(eq(promoCodeUses.orderId, orderId), ne(promoCodeUses.status, status)));
  }

  // AP §9.3.3 (slice 2.21b): an edit worked the order's discount out again
  // (owner decision 2026-11-16), so the use's cost follows it.
  async adjust(tx: Tx, orderId: string, discount: PromoDiscount): Promise<void> {
    await tx
      .update(promoCodeUses)
      .set({ discount: discount.total, merchantShare: discount.merchant })
      .where(eq(promoCodeUses.orderId, orderId));
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
          eq(promoCodes.visibility, 'visible'),
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
          ? sql<number>`count(*) FILTER (WHERE ${promoCodeUses.customerAccountId} = ${customer.accountId})::int`
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
    if (!row) return { applied: false, refusal: 'unknown_code', missing: null };
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
  };
}
