import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, gte, inArray, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { TermsService } from '../content/index.js';
import { GeoService, type Point } from '../geo/index.js';
import { CustomerAccountsService, PhoneCipher } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { type BlockKind, blockInForce } from './blocks.js';
import { type DeviceSighting, deviceLinks } from './devices.js';
import {
  type addressLabels,
  addresses,
  blocks,
  deviceLifts,
  type genders,
  lateCancelStrikes,
  profiles,
  reviewStops,
  strikeClears,
  testAccountFlags,
  trustMarks,
} from './schema.js';
import { strikesSince, type TrustMark } from './trust.js';

export type CustomersRefusal =
  | 'terms_required'
  | 'invalid_birthday'
  | 'outside_zones'
  | 'address_limit'
  | 'unknown_address'
  | 'idempotency_key_reused';

// A change the customers module refuses, with the reason its routes answer.
export class CustomersRefusedError extends Error {
  override readonly name = 'CustomersRefusedError';
  constructor(
    readonly refusal: CustomersRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface Profile {
  firstName: string;
  lastName: string | null;
  gender: (typeof genders)[number];
  // YYYY-MM-DD.
  birthday: string | null;
}

// AP §9.8: a manual block in force (CU §5.5 «محظور»).
export interface ActiveBlock {
  id: string;
  kind: BlockKind;
  // A duration's end; null «حتى إشعار آخر».
  until: Date | null;
  reason: string;
  reasonLabel: string;
  // CU Appendix C «Customer block»: what the banner says.
  customerText: string;
  note: string;
  startedAt: Date;
  startedBy: string;
  // The device block (slice 2.25d): the account of another line, signed in
  // on the same device, whose block this is; null for the line's own.
  viaAccountId: string | null;
}

// What ordering registers (useOrderFacts): the trust of D23 by the city's
// rules, the deliveries that count toward it, and the fake orders.
export interface CustomerOrders {
  trusted: boolean;
  delivered: number;
  trustedAfter: number;
  fakeOrders: number;
  // AP §9.8 «الطلبات» (slice 2.25b): the customer's orders in the city
  // (free re-deliveries left out), what the delivered ones totalled per
  // currency, and the latest.
  count: number;
  spent: { currency: string; amount: bigint }[];
  last: { id: string; number: bigint; status: string; placedAt: Date } | null;
}

// AP §9.8 «التذاكر» (slice 2.25b): what support registers
// (useCustomerTickets), the customer's latest tickets in the city.
export interface CustomerTicket {
  id: string;
  number: bigint;
  typeLabel: string;
  status: string;
  orderNumber: bigint | null;
  openedAt: Date;
}

export type CustomerTickets = (accountId: string, cityId: string) => Promise<CustomerTicket[]>;

export type CustomerActiveOrders = (
  accountId: string,
  executor?: Pick<NodePgDatabase, 'select'>,
) => Promise<boolean>;

export type CustomerOrderFacts = (accountId: string, cityId: string) => Promise<CustomerOrders>;

// CU §8.1 «الأكثر طلباً» (slice 2.27b): what ordering registers
// (useDeliveredCounts), each restaurant's orders delivered since a moment,
// test orders and free re-deliveries left out; a restaurant with none is
// missing from the map.
export type DeliveredCounts = (
  restaurantIds: string[],
  since: Date,
) => Promise<Map<string, number>>;

// AP §9.11.4 (slice 2.27d): what ordering registers (useLastDeliveries),
// each account's latest delivered order in the city, test orders and free
// re-deliveries left out; an account with none is missing from the map.
export type LastDeliveries = (cityId: string) => Promise<Map<string, Date>>;

// CU §12.1, AP §9.8 (slice 2.26a): what ordering registers (useRatings), the
// ratings it keeps: each restaurant's count and average for the cards, and
// the ratings a customer wrote for the profile.
export interface CustomerRating {
  orderId: string;
  orderNumber: bigint;
  party: 'restaurant' | 'captain';
  restaurantName: string | null;
  captainName: string | null;
  stars: number;
  reasons: { code: string; label: string }[];
  comment: string | null;
  at: Date;
}

export interface CustomerRatings {
  restaurants(restaurantIds: string[]): Promise<Map<string, { count: number; average: number }>>;
  written(accountId: string, cityId: string): Promise<CustomerRating[]>;
}

export interface AddressFields {
  location: Point;
  label: (typeof addressLabels)[number];
  customLabel: string | null;
  street: string;
  floor: string | null;
  landmark: string;
  // E.164; null is the account's own number.
  contactPhone: string | null;
  recipientName: string | null;
  directions: string | null;
}

export interface Address extends AddressFields {
  id: string;
  cityId: string;
  isDefault: boolean;
  // «الحي»: the name of the active zone the pin is in; null when no active
  // zone covers it any more, «خارج منطقة التوصيل حالياً» (Q6).
  neighbourhood: string | null;
}

// CU §7.4: an unsaved address, the fields of a saved one without its label.
export type UnsavedAddressFields = Omit<AddressFields, 'label' | 'customLabel'>;

// The address an order keeps (Q6): «الحي» is the zone at placing, and another
// contact number stays encrypted with identity's key.
export interface OrderAddress {
  // The saved address it was copied from; null for an unsaved one.
  addressId: string | null;
  cityId: string;
  location: Point;
  zone: { id: string; name: string };
  label: AddressFields['label'] | null;
  customLabel: string | null;
  street: string;
  floor: string | null;
  landmark: string;
  // null is the account's own number.
  contactPhoneEncrypted: string | null;
  recipientName: string | null;
  directions: string | null;
}

// CU §7.1: where a point stands. served has restaurants that cover it;
// no_restaurants is «لا توجد مطاعم توصل إلى موقعك حالياً»; outside_zones is
// «قريباً في منطقتك» with the vote (§7.2).
export interface Location {
  state: 'served' | 'no_restaurants' | 'outside_zones';
  cityId: string | null;
  zone: { id: string; name: string } | null;
}

// The desk and «القيود التصحيحية» take turns on a customer's dues (slice
// 2.25a), and the move to a new account with them (slice 2.25c).
export async function lockCustomerDues(tx: Tx, customerId: string): Promise<void> {
  await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtext(${`customer-dues:${customerId}`}))`);
}

// The device block (slice 2.25d; the wording ours, to confirm with the
// owner): what the customer sees for a block or dues of another account
// signed in on the same phone, never that account's reason, end or amount
// (a family member or a phone's buyer may see it). The app shows it as
// «حسابك محظور: {السبب}. تواصل مع الدعم.».
export const DEVICE_BLOCK_TEXT = 'هذا الهاتف مرتبط بحساب آخر محظور';

// The reasons of the two `dues.transfer` journals (AP §8.8, slice 2.25c;
// the wording ours).
export const DUES_MOVED_OUT = 'نقل المستحقات إلى الحساب الجديد بالرقم نفسه';
export const DUES_MOVED_IN = 'مستحقات منقولة من حساب مغلق بالرقم نفسه';

// A customer belongs to no city; V1 serves Syria only, so «a past date»
// is on Syria's clock.
const PROFILE_TIME_ZONE = 'Asia/Damascus';

// CU §7.3: up to 10 saved addresses (fixed).
export const MAX_ADDRESSES = 10;

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// The customers' profiles and saved addresses (architecture §4.2; CU §5.3,
// §7). Other modules read them through CustomersService only.
@Injectable()
export class CustomersService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly phones: PhoneCipher,
    private readonly terms: TermsService,
    private readonly ledger: LedgerService,
    private readonly accounts: CustomerAccountsService,
  ) {}

  // AP §8.8 (slice 2.25c): a new account on the number of a closed one
  // continues its line; its blocks, review stops, strikes, trust marks and
  // fake outcomes count for the line (`lineage`), and its dues move over
  // in the sign-in's transaction (`moveDues`).
  onModuleInit(): void {
    this.accounts.onRelinked((tx, link) => this.moveDues(tx, link));
  }

  // Every account of the account's line, itself included (identity's
  // `lineage`): what reads the customer's standing take.
  lineage(accountId: string, executor?: Pick<NodePgDatabase, 'select'>): Promise<string[]> {
    return this.accounts.lineage(accountId, executor);
  }

  // D19 (slice 2.25c): whether the account is not closed; placing reads it
  // under the customer's lock, which the closure takes.
  accountOpen(accountId: string, executor?: Pick<NodePgDatabase, 'select'>): Promise<boolean> {
    return this.accounts.isOpen(accountId, executor);
  }

  // The customer's ordering lock on every account of the line, in order:
  // placing takes its own account's, so a command on any account of the
  // line takes turns with it.
  async lockLine(tx: Tx, accountId: string): Promise<string[]> {
    const line = await this.lineage(accountId, tx);
    for (const id of line.toSorted()) {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${customerOrderLock(id)}, 0))`,
      );
    }
    return line;
  }

  // AP §8.8 (owner decision 2026-11-17): the closed account's dues in each
  // city, owed or a credit, move to the new account: one `dues.transfer`
  // per account against platform.adjustments, so the two net to zero there.
  private async moveDues(
    tx: Tx,
    link: { accountId: string; closedAccountId: string; now: Date },
  ): Promise<void> {
    // The desk and «القيود التصحيحية» take this lock before they read a
    // balance, so a payment on the closed account commits before the move
    // reads it, or waits and finds the dues moved.
    await lockCustomerDues(tx, link.closedAccountId);
    const owned = await this.ledger.ownedAccounts(link.closedAccountId, 'customer.dues', tx);
    for (const from of owned) {
      const balance = await this.ledger.balance(from.id, tx);
      if (balance.amount === 0n) continue;
      const open = (purpose: 'customer.dues' | 'platform.adjustments', ownerId: string | null) =>
        this.ledger.openAccount(
          { cityId: from.cityId, purpose, ownerId, currency: from.currency },
          tx,
        );
      const adjustments = await open('platform.adjustments', null);
      const to = await open('customer.dues', link.accountId);
      const journal = (accountId: string, amount: bigint, reason: string) =>
        this.ledger.post(
          {
            cityId: from.cityId,
            type: 'dues.transfer',
            source: null,
            actor: { type: 'system', id: null },
            reason,
            entries: [
              { accountId, currency: from.currency, amount },
              { accountId: adjustments, currency: from.currency, amount: -amount },
            ],
          },
          tx,
        );
      await journal(from.id, -balance.amount, DUES_MOVED_OUT);
      await journal(to, balance.amount, DUES_MOVED_IN);
    }
  }

  // What ordering knows of a customer, for the panel's profile (AP §9.8):
  // registered by ordering at start, which customers cannot import.
  private orderFacts: CustomerOrderFacts | null = null;

  useOrderFacts(facts: CustomerOrderFacts): void {
    this.orderFacts = facts;
  }

  ordersOf(accountId: string, cityId: string): Promise<CustomerOrders> {
    if (this.orderFacts === null) throw new Error('ordering has not registered its facts');
    return this.orderFacts(accountId, cityId);
  }

  // CU §8.1 (slice 2.27b): the delivered counts of «الأكثر طلباً»,
  // registered by ordering at start.
  private deliveredPort: DeliveredCounts | null = null;
  private lastDeliveriesPort: LastDeliveries | null = null;

  useLastDeliveries(port: LastDeliveries): void {
    this.lastDeliveriesPort = port;
  }

  lastDeliveries(cityId: string): Promise<Map<string, Date>> {
    if (this.lastDeliveriesPort === null) {
      throw new Error('ordering has not registered its last deliveries');
    }
    return this.lastDeliveriesPort(cityId);
  }

  // AP §9.11.4 (slice 2.27d): every registered customer (a profile).
  async registered(): Promise<string[]> {
    const rows = await this.database.db.select({ id: profiles.accountId }).from(profiles);
    return rows.map((row) => row.id);
  }

  // AP §9.11.4: the customers with a saved address (not deleted) in the
  // zone.
  async withAddressIn(cityId: string, zoneId: string): Promise<Set<string>> {
    const rows = await this.database.db
      .select({
        id: addresses.id,
        accountId: addresses.accountId,
        latitude: addressColumns.latitude,
        longitude: addressColumns.longitude,
      })
      .from(addresses)
      .where(and(eq(addresses.cityId, cityId), isNull(addresses.deletedAt)));
    const inside = await this.geo.covered(zoneId, rows);
    return new Set(rows.filter((row) => inside.has(row.id)).map((row) => row.accountId));
  }

  useDeliveredCounts(port: DeliveredCounts): void {
    this.deliveredPort = port;
  }

  deliveredCounts(restaurantIds: string[], since: Date): Promise<Map<string, number>> {
    if (this.deliveredPort === null) {
      throw new Error('ordering has not registered its delivered counts');
    }
    return this.deliveredPort(restaurantIds, since);
  }

  // CU §12.1, AP §9.8 (slice 2.26a): the ratings ordering keeps, registered
  // at start.
  private ratingsPort: CustomerRatings | null = null;

  useRatings(port: CustomerRatings): void {
    this.ratingsPort = port;
  }

  get ratings(): CustomerRatings {
    if (this.ratingsPort === null) throw new Error('ordering has not registered its ratings');
    return this.ratingsPort;
  }

  // AP §8.8, CU §5.6 (slice 2.25c): whether the account has an order not
  // ended, which refuses its closure; registered by ordering at start.
  private activeOrders: CustomerActiveOrders | null = null;

  useActiveOrders(check: CustomerActiveOrders): void {
    this.activeOrders = check;
  }

  hasActiveOrder(accountId: string, executor?: Pick<NodePgDatabase, 'select'>): Promise<boolean> {
    if (this.activeOrders === null)
      throw new Error('ordering has not registered its active orders');
    return this.activeOrders(accountId, executor);
  }

  private tickets: CustomerTickets | null = null;

  // Registered by support at start, which imports this module.
  useCustomerTickets(tickets: CustomerTickets): void {
    this.tickets = tickets;
  }

  ticketsOf(accountId: string, cityId: string): Promise<CustomerTicket[]> {
    if (this.tickets === null) throw new Error('support has not registered its tickets');
    return this.tickets(accountId, cityId);
  }

  // The device block (docs/domain/08; slice 2.25d, owner decisions
  // 2026-11-10 and 2026-11-18): the accounts outside the line signed in on a
  // device the line used, after the device's latest «فك حظر الجهاز», with
  // the devices; one step only (an account linked to a linked account is
  // not), so a block never spreads beyond the phones it was seen on.
  async deviceLinked(
    accountId: string,
    executor: Pick<NodePgDatabase, 'select' | 'selectDistinct'> = this.database.db,
  ): Promise<Map<string, string[]>> {
    const line = await this.lineage(accountId, executor);
    const sightings = await this.accounts.deviceSightings(line, executor);
    return deviceLinks(line, sightings, await this.deviceLiftTimes(sightings, executor));
  }

  // The latest lift of each device seen, by device.
  async deviceLiftTimes(
    sightings: readonly DeviceSighting[],
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<Map<string, Date>> {
    const devices = [...new Set(sightings.map((sighting) => sighting.deviceId))];
    if (devices.length === 0) return new Map();
    const rows = await executor
      .select({
        deviceId: deviceLifts.deviceId,
        at: sql<Date>`max(${deviceLifts.at})`.mapWith(deviceLifts.at),
      })
      .from(deviceLifts)
      .where(inArray(deviceLifts.deviceId, devices))
      .groupBy(deviceLifts.deviceId);
    return new Map(rows.map((row) => [row.deviceId, row.at]));
  }

  // AP §9.8 «حظر» (slice 2.25a): the block that stops the account's ordering
  // now, a duration or «حتى إشعار آخر» (the dues block is the dues balance,
  // `dues`), or null: the line's own (`lineBlock`), else one of an account
  // signed in on the same device (slice 2.25d, `viaAccountId`). The quote
  // shows it as account_blocked; placing reads it again under the
  // customer's lock, which a block takes too (a block on a linked account
  // takes that account's lock, so a placing racing it may pass).
  async activeBlock(
    accountId: string,
    now: Date,
    executor: Pick<NodePgDatabase, 'select' | 'selectDistinct'> = this.database.db,
  ): Promise<ActiveBlock | null> {
    const own = await this.lineBlock(accountId, now, executor);
    if (own !== null) return own;
    for (const linked of (await this.deviceLinked(accountId, executor)).keys()) {
      const block = await this.lineBlock(linked, now, executor);
      if (block !== null) {
        return { ...block, until: null, customerText: DEVICE_BLOCK_TEXT, viaAccountId: linked };
      }
    }
    return null;
  }

  // The block in force on the line itself (`viaAccountId` null): what
  // «فك الحظر» ends.
  async lineBlock(
    accountId: string,
    now: Date,
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<ActiveBlock | null> {
    const line = await this.lineage(accountId, executor);
    const rows = await executor
      .select()
      .from(blocks)
      .where(
        and(
          inArray(blocks.customerAccountId, line),
          isNull(blocks.endedAt),
          sql`${blocks.kind} <> 'dues'`,
        ),
      );
    const row = rows.find((each) => blockInForce(each, now));
    if (!row) return null;
    return {
      id: row.id,
      kind: row.kind,
      until: row.until,
      reason: row.reason,
      reasonLabel: row.reasonLabel,
      customerText: row.customerText,
      note: row.note,
      startedAt: row.startedAt,
      startedBy: row.startedBy,
      viaAccountId: null,
    };
  }

  // AP §8.8 «مستحقات الزبون» (slice 2.11a): what the customer owes in the
  // city, from their customer.dues accounts (the base currency; one per
  // currency should another appear), or null when nothing is owed. A dues
  // block lasts exactly while this is above zero, so it lifts by itself when
  // the desk's payment, «تغيير النتيجة» or an adjustment brings the balance
  // to 0 or less. Since slice 2.25c the line's (`lineDues`); since 2.25d,
  // else the dues of an account signed in on the same device
  // (`viaAccountId`), which the desk takes on that account's profile.
  async dues(
    cityId: string,
    accountId: string,
    executor?: Parameters<LedgerService['balance']>[1] &
      Pick<NodePgDatabase, 'select' | 'selectDistinct'>,
  ): Promise<{ amount: bigint; currency: string; viaAccountId: string | null } | null> {
    const owed = async (id: string) => {
      for (const balance of await this.lineDues(cityId, id, executor)) {
        if (balance.amount > 0n) return balance;
      }
      return null;
    };
    const own = await owed(accountId);
    if (own !== null) return { ...own, viaAccountId: null };
    for (const linked of (await this.deviceLinked(accountId, executor)).keys()) {
      const balance = await owed(linked);
      // The quote and the account state show it as a device block.
      if (balance !== null) return { ...balance, viaAccountId: linked };
    }
    return null;
  }

  // The device block (slice 2.25d): whether the line owes dues in any city,
  // for «فك حظر الجهاز» (a phone blocked by dues in one city is blocked in
  // all of them).
  async owesAnywhere(
    accountId: string,
    executor?: Parameters<LedgerService['balance']>[1] & Pick<NodePgDatabase, 'select'>,
  ): Promise<boolean> {
    const sums = new Map<string, bigint>();
    for (const id of await this.lineage(accountId, executor)) {
      for (const account of await this.ledger.ownedAccounts(id, 'customer.dues', executor)) {
        const balance = await this.ledger.balance(account.id, executor);
        const key = `${account.cityId}:${balance.currency}`;
        sums.set(key, (sums.get(key) ?? 0n) + balance.amount);
      }
    }
    return [...sums.values()].some((amount) => amount > 0n);
  }

  // AP §8.8 (slice 2.25c): the dues of every account of the line in the
  // city, summed per currency (+ owes, − a credit). The move at
  // re-registration leaves a closed account at zero, and anything posted on
  // it later (a «تغيير النتيجة» of its order, a reversal) still counts for
  // the account that continues it.
  async lineDues(
    cityId: string,
    accountId: string,
    executor?: Parameters<LedgerService['balance']>[1],
  ): Promise<{ amount: bigint; currency: string }[]> {
    const sums = new Map<string, bigint>();
    for (const id of await this.lineage(accountId, executor)) {
      for (const account of await this.ledger.ownerAccounts(
        cityId,
        id,
        'customer.dues',
        executor,
      )) {
        const balance = await this.ledger.balance(account.id, executor);
        sums.set(balance.currency, (sums.get(balance.currency) ?? 0n) + balance.amount);
      }
    }
    return [...sums].map(([currency, amount]) => ({ currency, amount }));
  }

  // CU §7.1: the zone check of a point, and whether any restaurant covers it.
  async location(point: Point): Promise<Location> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) {
      return { state: 'outside_zones', cityId: place?.cityId ?? null, zone: null };
    }
    const covering = await this.merchants.coveringRestaurants(place.cityId, point);
    return {
      state: covering.length > 0 ? 'served' : 'no_restaurants',
      cityId: place.cityId,
      zone: place.zone,
    };
  }

  // docs/domain/08 (slice 2.8b): operations cancelled the customer's order
  // after acceptance with the customer responsible. In the cancellation's
  // transaction, under the customer's ordering lock (the lock placing takes
  // first, so a stop and a placing take turns): the strike, then the
  // customer's strikes within windowDays; at `strikes` the account's
  // ordering stops until support reviews it (one open stop at a time).
  async recordLateCancel(
    tx: Tx,
    strike: {
      accountId: string;
      orderId: string;
      cityId: string;
      at: Date;
      strikes: number;
      windowDays: number;
    },
  ): Promise<{ reviewStopped: boolean }> {
    const line = await this.lockLine(tx, strike.accountId);
    await tx
      .insert(lateCancelStrikes)
      .values({
        customerAccountId: strike.accountId,
        orderId: strike.orderId,
        cityId: strike.cityId,
        at: strike.at,
      })
      .onConflictDoNothing({ target: lateCancelStrikes.orderId });
    const since = strikesSince(
      new Date(strike.at.getTime() - strike.windowDays * 24 * 60 * 60 * 1000),
      await this.strikesClearedAt(strike.accountId, tx),
    );
    const [counted] = await tx
      .select({ n: count() })
      .from(lateCancelStrikes)
      .where(
        and(inArray(lateCancelStrikes.customerAccountId, line), gte(lateCancelStrikes.at, since)),
      );
    if ((counted?.n ?? 0) < strike.strikes) return { reviewStopped: false };
    await tx
      .insert(reviewStops)
      .values({
        customerAccountId: strike.accountId,
        startedAt: strike.at,
        orderId: strike.orderId,
      })
      .onConflictDoNothing({
        target: reviewStops.customerAccountId,
        where: sql`${reviewStops.endedAt} IS NULL`,
      });
    return { reviewStopped: true };
  }

  // docs/domain/08: the account's ordering is stopped until support reviews
  // it («حسابك موقوف حتى مراجعة فريق الدعم»); placing reads it again under
  // the customer's lock through its transaction.
  async reviewStopped(
    accountId: string,
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<boolean> {
    const rows = await executor
      .select({ id: reviewStops.id })
      .from(reviewStops)
      .where(
        and(
          inArray(reviewStops.customerAccountId, await this.lineage(accountId, executor)),
          isNull(reviewStops.endedAt),
        ),
      )
      .limit(1);
    return rows.length > 0;
  }

  // AP §9.8 «مسح المخالفات» (slice 2.25b): the latest clear, from which the
  // strikes count again (`strikesSince`), or null.
  async strikesClearedAt(
    accountId: string,
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<Date | null> {
    const [row] = await executor
      .select({ at: strikeClears.at })
      .from(strikeClears)
      .where(inArray(strikeClears.customerAccountId, await this.lineage(accountId, executor)))
      .orderBy(desc(strikeClears.at), desc(strikeClears.id))
      .limit(1);
    return row?.at ?? null;
  }

  // AP §9.8 «توثيق» and «إزالة الثقة» (slice 2.25b): the latest mark, which
  // ordering's D23 count reads through `trustBasis`, or null.
  async trustMark(
    accountId: string,
    executor: Pick<NodePgDatabase, 'select'> = this.database.db,
  ): Promise<TrustMark | null> {
    const [row] = await executor
      .select({ trusted: trustMarks.trusted, at: trustMarks.at })
      .from(trustMarks)
      .where(inArray(trustMarks.customerAccountId, await this.lineage(accountId, executor)))
      .orderBy(desc(trustMarks.at), desc(trustMarks.id))
      .limit(1);
    return row ?? null;
  }

  // AP §9.8 «حساب تجريبي للإدارة» (slice 2.25b): whether the latest flag
  // says the account sees and orders from the restaurants in test mode.
  async isTestAccount(accountId: string): Promise<boolean> {
    const [row] = await this.database.db
      .select({ flagged: testAccountFlags.flagged })
      .from(testAccountFlags)
      .where(eq(testAccountFlags.customerAccountId, accountId))
      .orderBy(desc(testAccountFlags.at), desc(testAccountFlags.id))
      .limit(1);
    return row?.flagged ?? false;
  }

  // The details of CU §5.3; null until the customer completes them.
  async profile(accountId: string): Promise<Profile | null> {
    const [row] = await this.database.db
      .select({
        firstName: profiles.firstName,
        lastName: profiles.lastName,
        gender: profiles.gender,
        birthday: profiles.birthday,
      })
      .from(profiles)
      .where(eq(profiles.accountId, accountId));
    return row ?? null;
  }

  // The completed customers' first names by account, in one read: all a
  // restaurant sees of its customer with «الحي» (RA §8.4, principle 6).
  async firstNames(accountIds: string[]): Promise<Map<string, string>> {
    if (accountIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ accountId: profiles.accountId, firstName: profiles.firstName })
      .from(profiles)
      .where(inArray(profiles.accountId, accountIds));
    return new Map(rows.map((row) => [row.accountId, row.firstName]));
  }

  // AP §9.17 «Customers» (slice 2.41): the completed customers' names,
  // gender and birthday by account, in one read.
  async reportProfiles(
    accountIds: string[],
  ): Promise<
    Map<
      string,
      { firstName: string; lastName: string | null; gender: string; birthday: string | null }
    >
  > {
    if (accountIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({
        accountId: profiles.accountId,
        firstName: profiles.firstName,
        lastName: profiles.lastName,
        gender: profiles.gender,
        birthday: profiles.birthday,
      })
      .from(profiles)
      .where(inArray(profiles.accountId, accountIds));
    return new Map(rows.map(({ accountId, ...row }) => [accountId, row]));
  }

  // AP §9.17 «Customers» (slice 2.41): the panel's blocks (not the dues
  // blocks, which follow the balance) started between two moments, by the
  // reason's label as chosen, and how many are in force at `to`. A customer
  // belongs to no city, so they count every city.
  async blocksBetween(
    from: Date,
    to: Date,
  ): Promise<{ started: { label: string; count: number }[]; inForce: number }> {
    const [started, [inForce]] = await Promise.all([
      this.database.db
        .select({ label: blocks.reasonLabel, count: sql<number>`count(*)::int` })
        .from(blocks)
        .where(
          and(
            sql`${blocks.kind} <> 'dues'`,
            gte(blocks.startedAt, from),
            sql`${blocks.startedAt} < ${to.toISOString()}`,
          ),
        )
        .groupBy(blocks.reasonLabel)
        .orderBy(sql`count(*) DESC`, blocks.reasonLabel),
      this.database.db
        .select({ count: sql<number>`count(DISTINCT ${blocks.customerAccountId})::int` })
        .from(blocks)
        .where(
          and(
            sql`${blocks.kind} <> 'dues'`,
            sql`${blocks.startedAt} < ${to.toISOString()}`,
            sql`(${blocks.endedAt} IS NULL OR ${blocks.endedAt} > ${to.toISOString()})`,
            sql`(${blocks.until} IS NULL OR ${blocks.until} > ${to.toISOString()})`,
          ),
        ),
    ]);
    return {
      started: started.map((row) => ({ label: row.label, count: Number(row.count) })),
      inForce: Number(inForce?.count ?? 0),
    };
  }

  // «أكمل بياناتك» (CU §5.3), and later edits in «حسابي» (§13). The terms
  // are ticked once, when the details are first completed; a later version
  // is accepted on its own (CU §4.7).
  async saveProfile(
    accountId: string,
    profile: Profile,
    { acceptTerms, now }: { acceptTerms: boolean; now: Date },
  ): Promise<Profile> {
    if (profile.birthday !== null && profile.birthday >= dateIn(PROFILE_TIME_ZONE, now)) {
      throw new CustomersRefusedError('invalid_birthday', 'the birthday is a past date');
    }
    const updated = await this.database.db
      .update(profiles)
      .set({ ...profile, updatedAt: now })
      .where(eq(profiles.accountId, accountId))
      .returning({ accountId: profiles.accountId });
    if (updated.length === 0) {
      if (!acceptTerms) {
        throw new CustomersRefusedError('terms_required', 'the terms are accepted first');
      }
      // «أوافق على الشروط وسياسة الخصوصية» accepts the version in force
      // (AP §9.13), with the profile.
      await this.database.db.transaction(async (tx) => {
        await tx
          .insert(profiles)
          .values({ accountId, ...profile, termsAcceptedAt: now, createdAt: now, updatedAt: now })
          .onConflictDoUpdate({ target: profiles.accountId, set: { ...profile, updatedAt: now } });
        await this.terms.acceptCurrent('customer', accountId, now, tx);
      });
    }
    return profile;
  }

  // CU §7.3–7.4, Q6: the address an order keeps, copied from a saved address
  // or from the fields of an unsaved one, with «الحي» from the active zone at
  // the pin now. Refused outside every active zone.
  async orderAddress(
    accountId: string,
    choice: { addressId: string } | { fields: UnsavedAddressFields },
  ): Promise<OrderAddress> {
    let source: {
      addressId: string | null;
      label: Address['label'] | null;
      customLabel: string | null;
      fields: UnsavedAddressFields;
      contactPhoneEncrypted: string | null;
    };
    if ('addressId' in choice) {
      const [row] = await this.database.db
        .select(addressColumns)
        .from(addresses)
        .where(mine(accountId, choice.addressId));
      if (!row) throw new CustomersRefusedError('unknown_address', 'no such address');
      source = {
        addressId: row.id,
        label: row.label,
        customLabel: row.customLabel,
        fields: {
          location: { latitude: row.latitude, longitude: row.longitude },
          street: row.street,
          floor: row.floor,
          landmark: row.landmark,
          contactPhone: null,
          recipientName: row.recipientName,
          directions: row.directions,
        },
        contactPhoneEncrypted: row.contactPhoneEncrypted,
      };
    } else {
      const { fields } = choice;
      source = {
        addressId: null,
        label: null,
        customLabel: null,
        fields,
        contactPhoneEncrypted:
          fields.contactPhone === null ? null : this.phones.encrypt(fields.contactPhone),
      };
    }
    const place = await this.geo.locate(source.fields.location);
    if (place === null || place.zone === null) throw outsideZones();
    const { fields } = source;
    return {
      addressId: source.addressId,
      cityId: place.cityId,
      location: fields.location,
      zone: place.zone,
      label: source.label,
      customLabel: source.customLabel,
      street: fields.street,
      floor: fields.floor,
      landmark: fields.landmark,
      contactPhoneEncrypted: source.contactPhoneEncrypted,
      recipientName: source.contactPhoneEncrypted === null ? null : fields.recipientName,
      directions: fields.directions,
    };
  }

  // The saved addresses, the default first, then the newest.
  async addresses(accountId: string): Promise<Address[]> {
    const rows = await this.database.db
      .select(addressColumns)
      .from(addresses)
      .where(and(eq(addresses.accountId, accountId), isNull(addresses.deletedAt)))
      .orderBy(desc(addresses.isDefault), desc(addresses.id));
    return Promise.all(rows.map((row) => this.addressOf(row)));
  }

  // CU §7.3: a new address, its pin inside an active zone. The first is the
  // default; isDefault makes a later one the default. CU §19 item 28: the
  // key is kept on the row, so a retry answers the first save (even at the
  // limit, or 404 if it was deleted since) and another body with the key is
  // idempotency_key_reused.
  async addAddress(
    accountId: string,
    fields: AddressFields & { isDefault: boolean },
    idempotencyKey: string,
    now: Date,
  ): Promise<Address> {
    // The other contact number stays out of the hash, which is not keyed: it
    // would undo its encryption (architecture §15.3). A repeat compares it
    // with the row's, decrypted.
    const { contactPhone, ...hashed } = fields;
    const requestHash = createHash('sha256').update(JSON.stringify(hashed)).digest('hex');
    const earlier = async (executor: Pick<Database['db'], 'select'>) => {
      const [row] = await executor
        .select({
          id: addresses.id,
          requestHash: addresses.requestHash,
          contactPhoneEncrypted: addresses.contactPhoneEncrypted,
        })
        .from(addresses)
        .where(
          and(eq(addresses.accountId, accountId), eq(addresses.idempotencyKey, idempotencyKey)),
        );
      const phone =
        row?.contactPhoneEncrypted == null ? null : this.phones.decrypt(row.contactPhoneEncrypted);
      if (row && (row.requestHash !== requestHash || phone !== contactPhone)) {
        throw new CustomersRefusedError('idempotency_key_reused', 'the key named another address');
      }
      return row?.id;
    };
    const saved = async (id: string) => {
      const address = await this.address(accountId, id);
      if (address === null) throw unknownAddress();
      return address;
    };
    const before = await earlier(this.database.db);
    if (before !== undefined) return saved(before);
    const cityId = await this.zoneCity(fields.location);
    const id = await this.database.db.transaction(async (tx) => {
      await lockAddresses(tx, accountId);
      const first = await earlier(tx);
      if (first !== undefined) return first;
      const [{ count }] = (await tx
        .select({ count: sql<number>`count(*)::int` })
        .from(addresses)
        .where(and(eq(addresses.accountId, accountId), isNull(addresses.deletedAt)))) as [
        { count: number },
      ];
      if (count >= MAX_ADDRESSES) {
        throw new CustomersRefusedError('address_limit', `up to ${MAX_ADDRESSES} addresses`);
      }
      const isDefault = count === 0 || fields.isDefault;
      if (isDefault) await clearDefault(tx, accountId, now);
      const [row] = (await tx
        .insert(addresses)
        .values({
          accountId,
          cityId,
          ...this.columns(fields),
          isDefault,
          createdAt: now,
          updatedAt: now,
          idempotencyKey,
          requestHash,
        })
        .returning({ id: addresses.id })) as [{ id: string }];
      return row.id;
    });
    return saved(id);
  }

  // CU §7.3 (U5): every field may change, the pin only inside active zones.
  async updateAddress(
    accountId: string,
    id: string,
    fields: AddressFields,
    now: Date,
  ): Promise<Address> {
    const cityId = await this.zoneCity(fields.location);
    const updated = await this.database.db
      .update(addresses)
      .set({ cityId, ...this.columns(fields), updatedAt: now })
      .where(mine(accountId, id))
      .returning({ id: addresses.id });
    if (updated.length === 0) throw unknownAddress();
    return (await this.address(accountId, id))!;
  }

  // The default address (CU §7.3); one outside every active zone cannot be
  // chosen (Q6, 409 outside_zones).
  async setDefaultAddress(accountId: string, id: string, now: Date): Promise<Address> {
    const address = await this.address(accountId, id);
    if (address === null) throw unknownAddress();
    if (address.neighbourhood === null) throw outsideZones();
    await this.database.db.transaction(async (tx) => {
      await lockAddresses(tx, accountId);
      if (!(await exists(tx, accountId, id))) throw unknownAddress();
      await clearDefault(tx, accountId, now);
      await tx
        .update(addresses)
        .set({ isDefault: true, updatedAt: now })
        .where(mine(accountId, id));
    });
    return { ...address, isDefault: true };
  }

  // Deleting hides the address; no order changes (Q6). When it was the
  // default, the newest remaining address inside an active zone becomes the
  // default, or else the newest remaining one.
  async deleteAddress(accountId: string, id: string, now: Date): Promise<void> {
    // The zones are read before the transaction, which holds a connection;
    // the others come newest first.
    const others = (await this.addresses(accountId)).filter((address) => address.id !== id);
    const heirs = [
      ...others.filter((address) => address.neighbourhood !== null),
      ...others.filter((address) => address.neighbourhood === null),
    ].map((address) => address.id);
    await this.database.db.transaction(async (tx) => {
      await lockAddresses(tx, accountId);
      const [row] = await tx
        .select({ isDefault: addresses.isDefault })
        .from(addresses)
        .where(mine(accountId, id));
      if (!row) throw unknownAddress();
      await tx
        .update(addresses)
        .set({ deletedAt: now, isDefault: false, updatedAt: now })
        .where(eq(addresses.id, id));
      if (!row.isDefault) return;
      for (const heir of heirs) {
        const moved = await tx
          .update(addresses)
          .set({ isDefault: true, updatedAt: now })
          .where(mine(accountId, heir))
          .returning({ id: addresses.id });
        if (moved.length === 1) return;
      }
    });
  }

  private async address(accountId: string, id: string): Promise<Address | null> {
    const [row] = await this.database.db
      .select(addressColumns)
      .from(addresses)
      .where(mine(accountId, id));
    return row ? this.addressOf(row) : null;
  }

  private async addressOf(row: AddressRow): Promise<Address> {
    const location = { latitude: row.latitude, longitude: row.longitude };
    const zone = await this.geo.zoneAt(row.cityId, location);
    return {
      id: row.id,
      cityId: row.cityId,
      location,
      label: row.label,
      customLabel: row.customLabel,
      street: row.street,
      floor: row.floor,
      landmark: row.landmark,
      contactPhone:
        row.contactPhoneEncrypted === null ? null : this.phones.decrypt(row.contactPhoneEncrypted),
      recipientName: row.recipientName,
      directions: row.directions,
      isDefault: row.isDefault,
      neighbourhood: zone?.name ?? null,
    };
  }

  private async zoneCity(point: Point): Promise<string> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) throw outsideZones();
    return place.cityId;
  }

  private columns(fields: AddressFields) {
    const { latitude, longitude } = fields.location;
    return {
      location: sql`ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)`,
      label: fields.label,
      customLabel: fields.label === 'other' ? fields.customLabel : null,
      street: fields.street,
      floor: fields.floor,
      landmark: fields.landmark,
      contactPhoneEncrypted:
        fields.contactPhone === null ? null : this.phones.encrypt(fields.contactPhone),
      recipientName: fields.contactPhone === null ? null : fields.recipientName,
      directions: fields.directions,
    };
  }
}

const addressColumns = {
  id: addresses.id,
  cityId: addresses.cityId,
  latitude: sql<number>`ST_Y(${addresses.location})`.mapWith(Number),
  longitude: sql<number>`ST_X(${addresses.location})`.mapWith(Number),
  label: addresses.label,
  customLabel: addresses.customLabel,
  street: addresses.street,
  floor: addresses.floor,
  landmark: addresses.landmark,
  contactPhoneEncrypted: addresses.contactPhoneEncrypted,
  recipientName: addresses.recipientName,
  directions: addresses.directions,
  isDefault: addresses.isDefault,
};

interface AddressRow {
  id: string;
  cityId: string;
  latitude: number;
  longitude: number;
  label: AddressFields['label'];
  customLabel: string | null;
  street: string;
  floor: string | null;
  landmark: string;
  contactPhoneEncrypted: string | null;
  recipientName: string | null;
  directions: string | null;
  isDefault: boolean;
}

function mine(accountId: string, id: string) {
  return and(eq(addresses.id, id), eq(addresses.accountId, accountId), isNull(addresses.deletedAt));
}

async function exists(tx: Tx, accountId: string, id: string): Promise<boolean> {
  const rows = await tx.select({ id: addresses.id }).from(addresses).where(mine(accountId, id));
  return rows.length === 1;
}

async function clearDefault(tx: Tx, accountId: string, now: Date): Promise<void> {
  await tx
    .update(addresses)
    .set({ isDefault: false, updatedAt: now })
    .where(and(eq(addresses.accountId, accountId), eq(addresses.isDefault, true)));
}

// docs/domain/08, CU §10.7: the name of the customer's ordering advisory
// lock, which placing takes first and a late-cancellation strike takes, so
// a review stop and a placing take turns.
export function customerOrderLock(accountId: string): string {
  return `orders:customer:${accountId}`;
}

// A customer's address changes take turns, so the limit and the one default
// hold under concurrent requests.
async function lockAddresses(tx: Tx, accountId: string): Promise<void> {
  await tx.execute(
    sql`SELECT pg_advisory_xact_lock(hashtextextended(${`addresses:${accountId}`}, 0))`,
  );
}

function outsideZones(): CustomersRefusedError {
  return new CustomersRefusedError('outside_zones', 'the pin is outside every active zone');
}

function unknownAddress(): CustomersRefusedError {
  return new CustomersRefusedError('unknown_address', 'no such address');
}

// The date at a moment on a time zone's clock, as YYYY-MM-DD.
function dateIn(timeZone: string, at: Date): string {
  return new Intl.DateTimeFormat('en-CA', { timeZone }).format(at);
}
