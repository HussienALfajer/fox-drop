import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNotNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { formatMoney, NotificationTexts } from '../content/index.js';
import { CustomersService, lockCustomerDues as lockAccountDues } from '../customers/index.js';
import { FxService, type RateSnapshot } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { AdminSessionsService, CustomerAccountsService } from '../identity/index.js';
import { LedgerService } from '../ledger/index.js';
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
  type Tx,
} from './cashdesk.service.js';
import { checkLines, type QuotedLine, sameRates } from './merchant-settlement.service.js';
import { drawerSessions, receiptLines, receipts } from './schema.js';

// AP §8.8, §9.8 «تسجيل دفع المستحق»: what the screen shows before the
// confirmation: what the customer owes in the city's base (+ owes; 0 or
// less when nothing is), the cash per currency with its base value, their
// total and what stays owed.
export interface CustomerDuesPreview {
  customerId: string;
  customerName: string;
  cityId: string;
  currency: string;
  due: bigint;
  lines: QuotedLine[];
  total: bigint;
  remaining: bigint;
}

export interface CustomerDuesCommand {
  cityId: string;
  customerId: string;
  due: bigint;
  lines: { currency: string; amount: bigint; base: bigint; rates: ConversionRate[] }[];
  idempotencyKey: string;
}

// A customer's receipt (AP §4.8): the number, the cash per currency with its
// base value, the cashier, and what the customer owed before and after it.
export interface CustomerReceipt {
  id: string;
  cityId: string;
  number: string;
  sessionId: string;
  cashierId: string;
  cashierName: string | null;
  customerId: string;
  customerName: string;
  currency: string;
  dueBefore: bigint;
  total: bigint;
  dueAfter: bigint;
  createdAt: Date;
  lines: { currency: string; amount: bigint; base: bigint }[];
}

// The desk and «القيود التصحيحية» take turns on a customer's dues, and on
// every account of the line (slice 2.25c: its dues are read together), in
// order.
export async function lockCustomerDues(
  tx: Tx,
  customers: CustomersService,
  customerId: string,
): Promise<void> {
  for (const id of (await customers.lineage(customerId, tx)).toSorted()) {
    await lockAccountDues(tx, id);
  }
}

// AP §8.8 «FIN records the payment at the desk, which unblocks the customer
// automatically» (slice 2.25a; owner decision 2026-11-17: in part or in
// full): the cash in any accepted currency at the current rate, as
// dues.payment against the drawer's platform.cash (through
// platform.fx_rounding for another currency than the base), never above
// what is owed. One numbered receipt per confirmation, at the office.
@Injectable()
export class CustomerDuesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly desk: CashDeskService,
    private readonly ledger: LedgerService,
    private readonly customers: CustomersService,
    private readonly accounts: CustomerAccountsService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
    private readonly admins: AdminSessionsService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  async preview(
    cityId: string,
    customerId: string,
    lines: CashLine[],
  ): Promise<CustomerDuesPreview> {
    const name = await this.customerName(customerId);
    const account = await this.account(this.database.db, cityId, customerId);
    const quoted = await this.quote(this.database.db, cityId, account.currency, lines);
    const total = quoted.reduce((sum, line) => sum + line.base, 0n);
    return {
      customerId,
      customerName: name,
      cityId,
      currency: account.currency,
      due: account.due,
      lines: quoted,
      total,
      remaining: account.due - total,
    };
  }

  async pay(user: DeskUser, command: CustomerDuesCommand, now: Date): Promise<CustomerReceipt> {
    checkLines(command.lines);
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          customerDues: command.customerId,
          cityId: command.cityId,
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

    const name = await this.customerName(command.customerId);
    const [city, currencies] = await Promise.all([
      this.geo.cityCode(command.cityId),
      this.fx.currencies(),
    ]);
    if (!city) throw new CashDeskRefusedError('unknown_city', 'no such city');
    const known = new Map(
      currencies.map((each) => [each.code, { symbol: each.symbol, decimals: each.decimals }]),
    );

    const receiptId = await this.database.db.transaction(async (tx) => {
      const [session] = await tx
        .select()
        .from(drawerSessions)
        .where(openOf(user.accountId, 'office'))
        .for('share');
      if (!session) throw new CashDeskRefusedError('no_open_session', 'open the drawer first');
      if (session.cityId !== command.cityId) {
        throw new CashDeskRefusedError('unknown_party', 'the drawer is of another city');
      }
      await lockCustomerDues(tx, this.customers, command.customerId);
      const again = await this.desk.replay(tx, user.accountId, command, requestHash, now);
      if (again) return again.receiptIds[0]!;
      const account = await this.account(tx, command.cityId, command.customerId);
      if (account.due <= 0n) throw new CashDeskRefusedError('nothing_due', 'nothing is owed');
      if (account.due !== command.due) {
        throw new CashDeskRefusedError('balance_changed', 'the dues moved since the screen');
      }
      const quoted = await this.quote(tx, command.cityId, account.currency, command.lines);
      for (const [index, line] of quoted.entries()) {
        const shown = command.lines[index]!;
        if (line.base !== shown.base || !sameRates(line.rates, shown.rates)) {
          throw new CashDeskRefusedError('rate_changed', 'the rate is not the one shown');
        }
      }
      const total = quoted.reduce((sum, line) => sum + line.base, 0n);
      if (total > account.due) throw new CashDeskRefusedError('above_balance', 'more than is owed');

      const year = cityYear(now, city.timeZone);
      const number = await nextNumber(tx, command.cityId, city.code, year);
      const [created] = await tx
        .insert(receipts)
        .values({
          cityId: command.cityId,
          year,
          sequence: number.sequence,
          number: number.number,
          type: 'customer_dues_payment',
          sessionId: session.id,
          adminAccountId: user.accountId,
          customerId: command.customerId,
          customerName: name,
          dueBefore: account.due,
          dueCurrency: account.currency,
          createdAt: now,
        })
        .returning({ id: receipts.id });
      const id = created!.id;
      for (const line of quoted) {
        const journalId = await this.post(tx, {
          user,
          cityId: command.cityId,
          customerId: command.customerId,
          sessionId: session.id,
          receiptId: id,
          base: account.currency,
          line,
        });
        await this.desk.keepLine(tx, session.id, id, line, { baseAmount: line.base }, journalId);
      }
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId: command.cityId,
          action: 'cash_desk.receipt',
          target: { type: 'receipt', id },
          before: null,
          after: {
            number: number.number,
            type: 'customer_dues_payment',
            customerId: command.customerId,
            sessionId: session.id,
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
      // CU §14 #21 «تم استلام {المبلغ}. حسابك فعّال من جديد»: once the dues
      // reach zero, the block lifted; a part paid says nothing (to confirm
      // with the owner).
      if (total >= account.due) {
        const templateKey = 'customer.dues_paid';
        const rendered = await this.texts.render(
          templateKey,
          {
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
              recipient: { party: 'customer', accountId: command.customerId },
              templateKey,
              body: rendered.body,
              level: rendered.level,
              priority: rendered.priority,
              data: { target: 'home' },
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

  // A customer's receipt; another party's is null.
  async receipt(receiptId: string): Promise<CustomerReceipt | null> {
    const [row] = await this.database.db
      .select()
      .from(receipts)
      .where(and(eq(receipts.id, receiptId), isNotNull(receipts.customerId)));
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
    // receipts_party and receipt_lines_expected_or_base: a customer's receipt
    // names them and what they owed, and each line its base value.
    const kept = lines
      .map((line) => ({ currency: line.currency, amount: line.amount, base: line.baseAmount! }))
      .sort((a, b) => order(a.currency) - order(b.currency));
    const total = kept.reduce((sum, line) => sum + line.base, 0n);
    return {
      id: row.id,
      cityId: row.cityId,
      number: row.number,
      sessionId: row.sessionId,
      cashierId: row.adminAccountId,
      cashierName: names.get(row.adminAccountId) ?? null,
      customerId: row.customerId!,
      customerName: row.customerName!,
      currency: row.dueCurrency!,
      dueBefore: row.dueBefore!,
      total,
      dueAfter: row.dueBefore! - total,
      createdAt: row.createdAt,
      lines: kept,
    };
  }

  // The customer's latest receipts, newest first, for the profile.
  async customerReceipts(customerId: string, limit: number): Promise<CustomerReceipt[]> {
    const rows = await this.database.db
      .select({ id: receipts.id })
      .from(receipts)
      .where(eq(receipts.customerId, customerId))
      .orderBy(desc(receipts.createdAt), desc(receipts.id))
      .limit(limit);
    return (await Promise.all(rows.map((row) => this.receipt(row.id)))).filter(
      (each): each is CustomerReceipt => each !== null,
    );
  }

  // The name the receipt prints: the customer's details, or their masked
  // number before «أكمل بياناتك».
  private async customerName(customerId: string): Promise<string> {
    if (!(await this.accounts.exists(customerId))) {
      throw new CashDeskRefusedError('unknown_party', 'no such customer');
    }
    const profile = await this.customers.profile(customerId);
    if (profile) return [profile.firstName, profile.lastName].filter(Boolean).join(' ');
    const phone = await this.accounts.phone(customerId);
    return phone === null ? '—' : `••• ${phone.slice(-3)}`;
  }

  // What the customer owes in the city's base (+ owes): the dues accounts
  // are opened in the base. The line's (slice 2.25c): a payment on the new
  // account settles what a closed one of the line still holds.
  private async account(
    executor: Executor,
    cityId: string,
    customerId: string,
  ): Promise<{ currency: string; due: bigint }> {
    const base = await this.fx.baseCurrency(cityId, executor);
    if (base === null) throw new CashDeskRefusedError('rate_missing', 'the city has no base');
    let due = 0n;
    for (const balance of await this.customers.lineDues(cityId, customerId, executor)) {
      if (balance.currency !== base) {
        if (balance.amount !== 0n) throw new Error(`customer dues in ${balance.currency}`);
        continue;
      }
      due += balance.amount;
    }
    return { currency: base, due };
  }

  private async quote(
    executor: Executor,
    cityId: string,
    base: string,
    lines: readonly CashLine[],
  ): Promise<QuotedLine[]> {
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

  // dues.payment from the platform's side: the customer owes less (their
  // dues −) and the drawer holds more; another currency than the base meets
  // the base through platform.fx_rounding.
  private async post(
    tx: Tx,
    input: {
      user: DeskUser;
      cityId: string;
      customerId: string;
      sessionId: string;
      receiptId: string;
      base: string;
      line: QuotedLine;
    },
  ): Promise<string> {
    const { cityId, base, line } = input;
    const account = (
      purpose: 'customer.dues' | 'platform.cash' | 'platform.fx_rounding',
      currency: string,
    ) =>
      this.ledger.openAccount(
        {
          cityId,
          purpose,
          ownerId:
            purpose === 'customer.dues'
              ? input.customerId
              : purpose === 'platform.cash'
                ? input.sessionId
                : null,
          currency,
        },
        tx,
      );
    const entries = [
      { accountId: await account('customer.dues', base), currency: base, amount: -line.base },
      {
        accountId: await account('platform.cash', line.currency),
        currency: line.currency,
        amount: line.amount,
      },
    ];
    if (line.currency !== base) {
      entries.push(
        {
          accountId: await account('platform.fx_rounding', base),
          currency: base,
          amount: line.base,
        },
        {
          accountId: await account('platform.fx_rounding', line.currency),
          currency: line.currency,
          amount: -line.amount,
        },
      );
    }
    return this.ledger.post(
      {
        cityId,
        type: 'dues.payment',
        source: { kind: 'receipt', id: input.receiptId },
        actor: { type: 'admin', id: input.user.accountId },
        entries,
        ...(line.currency === base ? {} : { rates: line.rates }),
      },
      tx,
    );
  }
}
