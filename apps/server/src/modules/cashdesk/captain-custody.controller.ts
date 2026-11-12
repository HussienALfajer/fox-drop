import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import { CaptainsService } from '../captains/index.js';
import type { AppSession } from '../identity/index.js';
import type { JournalType } from '../ledger/index.js';
import { OrdersService } from '../ordering/index.js';
import { CashDeskService, type Receipt } from './cashdesk.service.js';

// CA §10.2: the newest entries and receipts «عهدتي» lists (decided by us:
// the screen scrolls through the latest, the rest stays in the ledger).
export const CUSTODY_ENTRIES = 100;
export const CUSTODY_RECEIPTS = 50;

const currency = z.string().length(3);
const signedMinor = z
  .string()
  .regex(/^-?\d{1,19}$/)
  .describe('Integer minor units (AP §8.6).');
const money = z.object({ amount: signedMinor, currency });

// CA §10.2's entry kinds: pickup payment, collection, change, hand-in,
// reimbursement, conversion, correction.
const entryKinds = [
  'pay_merchant',
  'collect',
  'change_given',
  'hand_in',
  'reimburse',
  'fx_convert',
  'pickup_correction',
  'adjustment',
] as const;
type EntryKind = (typeof entryKinds)[number];

const kindOf: Partial<Record<JournalType, EntryKind>> = {
  'custody.pay_merchant': 'pay_merchant',
  'custody.collect': 'collect',
  'custody.change_given': 'change_given',
  'custody.hand_in': 'hand_in',
  'custody.reimburse': 'reimburse',
  'custody.fx_convert': 'fx_convert',
  'custody.pickup_correction': 'pickup_correction',
  'custody.adjustment': 'adjustment',
};

class CaptainCustodyDto extends createZodDto(
  z.object({
    usage: money.describe('The cash held, in the base currency (AP §8.5.3).'),
    limit: money.describe('The cash limit «حد العهدة» (§10.4).'),
    warn: z.boolean().describe('At captain.custody_warn_pct of the limit or more.'),
    total: money.describe(
      'Every currency at the current rate, netted: + «عليك تسليم {المبلغ}», − «لك عند المكتب {المبلغ}».',
    ),
    closedDue: money.describe('«من أيام سابقة»: due from closed days, netted (AP §8.5.4).'),
    lastCutoff: z.iso.datetime(),
    handInGraceUntil: z.iso
      .datetime()
      .nullable()
      .describe('A hand-in grace running now (AP §8.5.4): until when; null otherwise.'),
    currencies: z
      .array(
        z.object({
          currency,
          balance: signedMinor.describe('+ to hand in, − the office owes the captain.'),
          closedDue: signedMinor.describe('«من أيام سابقة».'),
          today: signedMinor.describe('«من اليوم».'),
          balanceInBase: signedMinor.describe('The balance in the base currency, current rate.'),
        }),
      )
      .describe('Each currency held, the base first (AP §8.6).'),
    entries: z
      .array(
        z.object({
          kind: z.enum(entryKinds).nullable().describe('Null for a kind the app does not name.'),
          orderNumber: z.string().nullable().describe("The order's number, for an order's entry."),
          receiptNumber: z.string().nullable().describe('The receipt, for a desk entry.'),
          amount: money.describe('+ adds to what the captain hands in.'),
          at: z.iso.datetime(),
        }),
      )
      .describe(`Every entry, newest first, the latest ${CUSTODY_ENTRIES}.`),
    receipts: z
      .array(
        z.object({
          id: z.uuid(),
          number: z.string().describe('Such as AZ-2026-000123 (AP §4.8).'),
          type: z.enum(['captain_hand_in', 'captain_reimbursement']),
          at: z.iso.datetime(),
          cashierName: z.string().nullable(),
          conversions: z.array(
            z.object({
              from: currency,
              amount: signedMinor,
              to: currency,
              converted: signedMinor,
            }),
          ),
          lines: z.array(
            z.object({
              currency,
              amount: signedMinor.describe('The cash that changed hands, above zero.'),
            }),
          ),
        }),
      )
      .describe(`Every desk receipt, newest first, the latest ${CUSTODY_RECEIPTS}.`),
  }),
) {}

// CA §10.2 «عهدتي»: the custody per currency, its two parts, the limit, the
// entries and the receipts. The app reads it again on the captain channel's
// captain.availability_changed, which the desk sends with every receipt
// (AP §9.10.3: receipts appear at once). The office comes with the
// availability (CA §7.5).
@CaptainController('custody')
export class CaptainCustodyController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly desk: CashDeskService,
    private readonly orders: OrdersService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainCustodyDto })
  async custody(@CurrentAppSession() session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    const captainId = session.captain.captainId;
    const now = new Date();
    const [held, entries, receipts] = await Promise.all([
      this.captains.deskCustody(captainId, now),
      this.captains.custodyEntries(captainId, CUSTODY_ENTRIES),
      this.desk.captainReceipts(captainId, CUSTODY_RECEIPTS),
    ]);
    const sourced = (kind: string) =>
      entries.flatMap((entry) =>
        entry.sourceKind === kind && entry.sourceId ? [entry.sourceId] : [],
      );
    const [orderNumbers, receiptNumbers] = await Promise.all([
      this.orders.orderNumbers(sourced('order')),
      this.desk.receiptNumbers(sourced('receipt')),
    ]);
    const { custody } = held;
    const base = custody.usage.currency;
    const total = custody.currencies.reduce((sum, each) => sum + each.balanceInBase, 0n);
    return {
      usage: moneyBody(custody.usage.amount, base),
      limit: moneyBody(custody.limit.amount, base),
      warn: custody.warn,
      total: moneyBody(total, base),
      closedDue: moneyBody(custody.closedDue.amount, base),
      lastCutoff: custody.lastCutoff.toISOString(),
      handInGraceUntil: held.handInGrace?.until.toISOString() ?? null,
      currencies: custody.currencies.map((each) => ({
        currency: each.currency,
        balance: each.balance.toString(),
        closedDue: each.closedDue.toString(),
        today: each.today.toString(),
        balanceInBase: each.balanceInBase.toString(),
      })),
      entries: entries.map((entry) => ({
        kind: kindOf[entry.type] ?? null,
        orderNumber:
          entry.sourceKind === 'order' && entry.sourceId
            ? (orderNumbers.get(entry.sourceId)?.toString() ?? null)
            : null,
        receiptNumber:
          entry.sourceKind === 'receipt' && entry.sourceId
            ? (receiptNumbers.get(entry.sourceId) ?? null)
            : null,
        amount: moneyBody(entry.amount, entry.currency),
        at: entry.createdAt.toISOString(),
      })),
      receipts: receipts.map(receiptBody),
    };
  }
}

function moneyBody(amount: bigint, currency: string) {
  return { amount: amount.toString(), currency };
}

function receiptBody(receipt: Receipt) {
  return {
    id: receipt.id,
    number: receipt.number,
    type: receipt.type,
    at: receipt.createdAt.toISOString(),
    cashierName: receipt.cashierName,
    conversions: receipt.conversions.map((each) => ({
      from: each.from,
      amount: each.amount.toString(),
      to: each.to,
      converted: each.converted.toString(),
    })),
    lines: receipt.lines.map((line) => ({
      currency: line.currency,
      amount: line.amount.toString(),
    })),
  };
}
