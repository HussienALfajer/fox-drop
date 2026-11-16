import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, inArray, isNotNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { formatMoney, NotificationTexts } from '../content/index.js';
import { FxService, type RateSnapshot } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { AdminSessionsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PushQueue } from '../notifications/index.js';
import {
  type CashLine,
  CashDeskRefusedError,
  CashDeskService,
  cityYear,
  type ConversionRate,
  type DeskUser,
  type Executor,
  keepKey,
  nextNumber,
  openOf,
  quoteOf,
  type SessionKind,
  type Tx,
} from './cashdesk.service.js';
import { lockRestaurantAccount } from './merchant-statements.service.js';
import { drawerSessions, receiptLines, receiptMethods, receipts } from './schema.js';

export type MerchantReceiptType = 'merchant_settlement' | 'merchant_payout';
export type ReceiptMethod = (typeof receiptMethods)[number];

// One currency of the settlement: the cash, its value in the account's base
// at the current rate (AP §8.6: rounded by the base's rule), the rate
// version of a currency other than the base, and one unit of the dearer
// currency in the other, as the screen shows it.
export interface QuotedLine extends CashLine {
  base: bigint;
  rates: ConversionRate[];
  unit: { from: string; to: string; value: string } | null;
}

// What the screen shows before «تأكيد وإصدار الإيصال» (AP §9.10.3 tab 3):
// what the restaurant owes now (+ it owes, − the platform owes it), the
// cash per currency with its base value, their total and what stays due.
export interface MerchantSettlementPreview {
  restaurantId: string;
  restaurantName: string;
  cityId: string;
  currency: string;
  due: bigint;
  lines: QuotedLine[];
  total: bigint;
  // Of the same sign as `due`: what stays on the account.
  remaining: bigint;
}

// The settlement as the screen confirms it: what it showed, checked again
// under the restaurant's lock. The session it is recorded in: the user's
// office one, or their field one on a visit (slice 2.19c); at the office, a
// visit by a staff member without FIN names them (`visitorId`).
export interface MerchantSettleCommand {
  session: SessionKind;
  visitorId: string | null;
  restaurantId: string;
  due: bigint;
  lines: { currency: string; amount: bigint; base: bigint; rates: ConversionRate[] }[];
  idempotencyKey: string;
}

// A restaurant's receipt (AP §4.8, RA §12.4): the number, the amounts per
// currency with their base value, the method, the cashier and the time, and
// what the restaurant owed before and after it.
export interface MerchantReceipt {
  id: string;
  cityId: string;
  number: string;
  type: MerchantReceiptType;
  sessionId: string;
  // «في المكتب» or «زيارة ميدانية» with the staff member who visited, as
  // the receipt was issued (RA §12.4).
  method: ReceiptMethod;
  visitorId: string | null;
  visitorName: string | null;
  cashierId: string;
  cashierName: string | null;
  restaurantId: string;
  restaurantName: string;
  currency: string;
  dueBefore: bigint;
  total: bigint;
  dueAfter: bigint;
  createdAt: Date;
  lines: { currency: string; amount: bigint; base: bigint }[];
}

// «تسوية المطاعم» at the office (AP §8.7, §9.10.3 tab 3, RA §12.4, §16 #31;
// slice 2.19b): the restaurant pays what it owes, in part or in full, in any
// accepted currency at the current rate (merchant.settlement against the
// drawer's platform.cash, through platform.fx_rounding for another currency
// than the base); when the platform owes the restaurant, the desk pays it the
// same way. One numbered receipt per confirmation.
@Injectable()
export class MerchantSettlementService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly desk: CashDeskService,
    private readonly ledger: LedgerService,
    private readonly merchants: MerchantsService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
    private readonly admins: AdminSessionsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  async preview(restaurantId: string, lines: CashLine[]): Promise<MerchantSettlementPreview> {
    const restaurant = await this.restaurant(restaurantId);
    const account = await this.account(this.database.db, restaurant);
    const quoted = await this.quote(this.database.db, restaurant.cityId, account.currency, lines);
    const total = quoted.reduce((sum, line) => sum + line.base, 0n);
    return {
      restaurantId,
      restaurantName: restaurant.nameAr,
      cityId: restaurant.cityId,
      currency: account.currency,
      due: account.due,
      lines: quoted,
      total,
      remaining: account.due >= 0n ? account.due - total : account.due + total,
    };
  }

  async settle(
    user: DeskUser,
    command: MerchantSettleCommand,
    now: Date,
  ): Promise<MerchantReceipt> {
    checkLines(command.lines);
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          restaurantSettlement: command.restaurantId,
          session: command.session,
          visitorId: command.visitorId,
          due: command.due.toString(),
          lines: command.lines.map((line) => [
            line.currency,
            line.amount.toString(),
            line.base.toString(),
            line.rates.map((rate) => [rate.currency, rate.rateVersionId]),
          ]),
        }),
      )
      .digest('hex');
    const replayed = await this.desk.replay(
      this.database.db,
      user.accountId,
      command,
      requestHash,
      now,
    );
    if (replayed) return (await this.receipt(replayed.receiptIds[0]!))!;

    const restaurant = await this.restaurant(command.restaurantId);
    const visitor = await this.visitor(user, command);
    const [city, currencies] = await Promise.all([
      this.geo.cityCode(restaurant.cityId),
      this.fx.currencies(),
    ]);
    if (!city) throw new Error(`city ${restaurant.cityId} does not exist`);
    const known = new Map(
      currencies.map((each) => [each.code, { symbol: each.symbol, decimals: each.decimals }]),
    );

    const receiptId = await this.database.db.transaction(async (tx) => {
      const [session] = await tx
        .select()
        .from(drawerSessions)
        .where(openOf(user.accountId, command.session))
        .for('share');
      if (!session) throw new CashDeskRefusedError('no_open_session', 'open the drawer first');
      if (session.cityId !== restaurant.cityId) {
        throw new CashDeskRefusedError('unknown_restaurant', 'the restaurant is of another city');
      }
      // The statement's lock too: a payment is never half in a statement,
      // and two desks never settle one balance twice.
      await lockRestaurantAccount(tx, restaurant.id);
      const again = await this.desk.replay(tx, user.accountId, command, requestHash, now);
      if (again) return again.receiptIds[0]!;
      const account = await this.account(tx, restaurant);
      if (account.due === 0n) throw new CashDeskRefusedError('nothing_due', 'nothing is owed');
      if (account.due !== command.due) {
        throw new CashDeskRefusedError('balance_changed', 'the balance moved since the screen');
      }
      const quoted = await this.quote(tx, restaurant.cityId, account.currency, command.lines);
      for (const [index, line] of quoted.entries()) {
        const shown = command.lines[index]!;
        if (line.base !== shown.base || !sameRates(line.rates, shown.rates)) {
          throw new CashDeskRefusedError('rate_changed', 'the rate is not the one shown');
        }
      }
      const total = quoted.reduce((sum, line) => sum + line.base, 0n);
      const owed = account.due > 0n ? account.due : -account.due;
      if (total > owed) throw new CashDeskRefusedError('above_balance', 'more than is owed');
      const collect = account.due > 0n;
      if (!collect) {
        // The drawer pays out only the cash it holds in that currency; two
        // payouts of one session to two restaurants take turns, so both
        // never read the same cash.
        await tx.execute(
          sql`SELECT pg_advisory_xact_lock(hashtext(${`cashdesk.drawer:${session.id}`}))`,
        );
        const drawer = await this.desk.drawerCash(tx, session);
        for (const line of quoted) {
          if (line.amount > (drawer.get(line.currency) ?? 0n)) {
            throw new CashDeskRefusedError('drawer_short', `the drawer lacks ${line.currency}`);
          }
        }
      }

      const year = cityYear(now, city.timeZone);
      const number = await nextNumber(tx, restaurant.cityId, city.code, year);
      const type: MerchantReceiptType = collect ? 'merchant_settlement' : 'merchant_payout';
      const [created] = await tx
        .insert(receipts)
        .values({
          cityId: restaurant.cityId,
          year,
          sequence: number.sequence,
          number: number.number,
          type,
          sessionId: session.id,
          adminAccountId: user.accountId,
          restaurantId: restaurant.id,
          restaurantName: restaurant.nameAr,
          dueBefore: account.due,
          dueCurrency: account.currency,
          method: visitor ? 'field' : 'office',
          visitorId: visitor?.id ?? null,
          visitorName: visitor?.name ?? null,
          createdAt: now,
        })
        .returning({ id: receipts.id });
      const id = created!.id;
      for (const line of quoted) {
        const journalId = await this.post(tx, {
          user,
          cityId: restaurant.cityId,
          restaurantId: restaurant.id,
          sessionId: session.id,
          receiptId: id,
          base: account.currency,
          sign: collect ? 1n : -1n,
          line,
        });
        await this.desk.keepLine(tx, session.id, id, line, { baseAmount: line.base }, journalId);
      }
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId: restaurant.cityId,
          action: 'cash_desk.receipt',
          target: { type: 'receipt', id },
          before: null,
          after: {
            number: number.number,
            type,
            restaurantId: restaurant.id,
            sessionId: session.id,
            method: visitor ? 'field' : 'office',
            visitorId: visitor?.id ?? null,
            dueBefore: account.due.toString(),
            lines: quoted.map((line) => ({
              currency: line.currency,
              amount: line.amount.toString(),
              base: line.base.toString(),
              rates: line.rates,
            })),
          },
        },
        tx,
      );
      // RA §16 #31 «استلمنا منك»: a payment received; the receipt of a payout
      // is in the app only (to confirm with the owner).
      if (collect) {
        const templateKey = 'merchant.settlement_receipt';
        const rendered = await this.texts.render(
          templateKey,
          {
            رقم: number.number,
            المبلغ: quoted
              .map((line) => formatMoney(line.amount, line.currency, known))
              .join(' + '),
          },
          tx,
        );
        await this.pushes.enqueue(
          tx,
          [
            {
              source: `cashdesk:receipt:${id}`,
              recipient: { party: 'merchant', restaurantId: restaurant.id, owners: true },
              templateKey,
              body: rendered.body,
              level: rendered.level,
              priority: rendered.priority,
              data: { target: 'receipt', receiptId: id },
              at: now,
            },
          ],
          now,
        );
      }
      await keepKey(tx, user.accountId, command.idempotencyKey, requestHash, [id], null, now);
      return id;
    });
    return (await this.receipt(receiptId))!;
  }

  // A restaurant's receipt; a captain's is null.
  async receipt(receiptId: string): Promise<MerchantReceipt | null> {
    const [row] = await this.database.db
      .select()
      .from(receipts)
      .where(and(eq(receipts.id, receiptId), isNotNull(receipts.restaurantId)));
    if (!row) return null;
    const [lines, names, order] = await Promise.all([
      this.database.db
        .select()
        .from(receiptLines)
        .where(inArray(receiptLines.receiptId, [row.id]))
        .orderBy(asc(receiptLines.currency)),
      this.admins.names([row.adminAccountId]),
      this.desk.currencyOrder(row.cityId),
    ]);
    // receipts_party and receipt_lines_expected_or_base: a restaurant's
    // receipt names it and what it owed, and each line its base value.
    const kept = lines
      .map((line) => ({ currency: line.currency, amount: line.amount, base: line.baseAmount! }))
      .sort((a, b) => order(a.currency) - order(b.currency));
    const total = kept.reduce((sum, line) => sum + line.base, 0n);
    const dueBefore = row.dueBefore!;
    return {
      id: row.id,
      cityId: row.cityId,
      number: row.number,
      type: row.type as MerchantReceiptType,
      sessionId: row.sessionId,
      method: row.method,
      visitorId: row.visitorId,
      visitorName: row.visitorName,
      cashierId: row.adminAccountId,
      cashierName: names.get(row.adminAccountId) ?? null,
      restaurantId: row.restaurantId!,
      restaurantName: row.restaurantName!,
      currency: row.dueCurrency!,
      dueBefore,
      total,
      dueAfter: dueBefore >= 0n ? dueBefore - total : dueBefore + total,
      createdAt: row.createdAt,
      lines: kept,
    };
  }

  // The staff member who visited, or null at the office: the field
  // session's own user, or the team member the desk names (AP §9.10.3: a
  // visitor without FIN, recorded when the cash reaches the desk).
  private async visitor(
    user: DeskUser,
    command: Pick<MerchantSettleCommand, 'session' | 'visitorId'>,
  ): Promise<{ id: string; name: string } | null> {
    if (command.session === 'field') {
      if (command.visitorId !== null) {
        throw new CashDeskRefusedError('invalid_visitor', "a field session is its user's visit");
      }
      const names = await this.admins.names([user.accountId]);
      return { id: user.accountId, name: names.get(user.accountId) ?? '' };
    }
    if (command.visitorId === null) return null;
    const found = (await this.admins.team()).find((member) => member.id === command.visitorId);
    if (!found) throw new CashDeskRefusedError('unknown_visitor', 'not an active team member');
    return found;
  }

  private async restaurant(restaurantId: string) {
    const found = await this.merchants.restaurant(restaurantId);
    if (!found) throw new CashDeskRefusedError('unknown_restaurant', 'no such restaurant');
    return found;
  }

  // What the restaurant owes now, + it owes (the ledger's party view
  // negated), in the base of the city: its account is opened in the base.
  private async account(
    executor: Executor,
    restaurant: { id: string; cityId: string },
  ): Promise<{ currency: string; due: bigint }> {
    const base = await this.fx.baseCurrency(restaurant.cityId, executor);
    if (base === null) throw new CashDeskRefusedError('rate_missing', 'the city has no base');
    let due = 0n;
    for (const account of await this.ledger.ownerAccounts(
      restaurant.cityId,
      restaurant.id,
      'merchant.account',
      executor,
    )) {
      const balance = await this.ledger.balance(account.id, executor);
      if (account.currency !== base) {
        if (balance.amount !== 0n) throw new Error(`restaurant account in ${account.currency}`);
        continue;
      }
      due -= balance.amount;
    }
    return { currency: base, due };
  }

  // Each line's value in the base at the current rate.
  private async quote(
    executor: Executor,
    cityId: string,
    base: string,
    lines: readonly CashLine[],
  ): Promise<QuotedLine[]> {
    // The screen opens on the balance alone, before any amount.
    if (lines.length > 0) checkLines(lines);
    let snapshot: RateSnapshot | null = null;
    const quoted: QuotedLine[] = [];
    for (const line of lines) {
      if (line.currency === base) {
        quoted.push({ ...line, base: line.amount, rates: [], unit: null });
        continue;
      }
      snapshot ??= await this.desk.snapshotOf(cityId, executor);
      const quote = quoteOf(snapshot, { from: line.currency, to: base, amount: line.amount });
      quoted.push({
        currency: line.currency,
        amount: line.amount,
        base: quote.converted,
        rates: quote.rates,
        unit: quote.unit,
      });
    }
    return quoted;
  }

  // merchant.settlement (the ledger's rules), from the platform's side: the
  // restaurant pays (sign +1), so its account owes less and the drawer holds
  // more; or the desk pays it (sign −1), the other way. Another currency
  // than the base meets the base through platform.fx_rounding.
  private async post(
    tx: Tx,
    input: {
      user: DeskUser;
      cityId: string;
      restaurantId: string;
      sessionId: string;
      receiptId: string;
      base: string;
      sign: 1n | -1n;
      line: QuotedLine;
    },
  ): Promise<string> {
    const { cityId, base, sign, line } = input;
    const account = (
      purpose: 'merchant.account' | 'platform.cash' | 'platform.fx_rounding',
      currency: string,
    ) =>
      this.ledger.openAccount(
        {
          cityId,
          purpose,
          ownerId:
            purpose === 'merchant.account'
              ? input.restaurantId
              : purpose === 'platform.cash'
                ? input.sessionId
                : null,
          currency,
        },
        tx,
      );
    const entries = [
      {
        accountId: await account('merchant.account', base),
        currency: base,
        amount: -sign * line.base,
      },
      {
        accountId: await account('platform.cash', line.currency),
        currency: line.currency,
        amount: sign * line.amount,
      },
    ];
    if (line.currency !== base) {
      entries.push(
        {
          accountId: await account('platform.fx_rounding', base),
          currency: base,
          amount: sign * line.base,
        },
        {
          accountId: await account('platform.fx_rounding', line.currency),
          currency: line.currency,
          amount: -sign * line.amount,
        },
      );
    }
    return this.ledger.post(
      {
        cityId,
        type: 'merchant.settlement',
        source: { kind: 'receipt', id: input.receiptId },
        actor: { type: 'admin', id: input.user.accountId },
        entries,
        ...(line.currency === base ? {} : { rates: line.rates }),
      },
      tx,
    );
  }
}

// One line per currency, one at least, amounts above zero.
function checkLines(lines: readonly CashLine[]): void {
  if (
    lines.length === 0 ||
    new Set(lines.map((line) => line.currency)).size !== lines.length ||
    lines.some((line) => line.amount <= 0n)
  ) {
    throw new CashDeskRefusedError('invalid_amounts', 'one line per currency, above zero');
  }
}

function sameRates(a: readonly ConversionRate[], b: readonly ConversionRate[]): boolean {
  const key = (rates: readonly ConversionRate[]) =>
    JSON.stringify(
      [...rates]
        .map((rate) => [rate.currency, rate.rateVersionId] as const)
        .sort((x, y) => x[0].localeCompare(y[0])),
    );
  return key(a) === key(b);
}
