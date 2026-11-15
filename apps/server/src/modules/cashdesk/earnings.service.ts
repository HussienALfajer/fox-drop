import { Injectable } from '@nestjs/common';
import { CaptainsService } from '../captains/index.js';
import { GeoService } from '../geo/index.js';
import { type OrderPayParts, OrdersService } from '../ordering/index.js';
import { SettingsService } from '../settings/index.js';
import { CashDeskService } from './cashdesk.service.js';
import { type OtherKind, orderLines, otherLines, payoutCycle, windowTotals } from './earnings.js';
import type { NegativeEarningsPolicy, PayoutWeekday } from './settlement.service.js';

export interface EarningsWindow {
  from: Date;
  earnings: bigint;
  orders: number;
  onlineMinutes: number;
}

// CA §10.6 «أرباحي» as the captain app shows it, in the city's base.
export interface CaptainEarnings {
  currency: string;
  today: EarningsWindow;
  week: EarningsWindow;
  // This week's orders, newest first: the parts as the collection recorded
  // them, null when the ledger's pay does not match them (an outcome without
  // a collection, a reversal), the total from the ledger.
  orders: {
    orderNumber: bigint | null;
    at: Date;
    parts: OrderPayParts | null;
    total: bigint;
  }[];
  // This week's other lines, newest first.
  lines: {
    kind: OtherKind;
    amount: bigint;
    reason: string | null;
    orderNumber: bigint | null;
    receiptNumber: string | null;
    at: Date;
  }[];
  balance: bigint;
  payoutWeekday: PayoutWeekday;
  nextPayout: string;
  policy: NegativeEarningsPolicy;
}

// CA §10.6 «أرباحي» (slice 2.18b): today and this week (the payout cycle
// since the last payout weekday, by business day; owner decision
// 2026-11-15) with the earnings, the orders and the online hours; this
// week's orders with their pay by part and the other lines with their
// reason, order or receipt; the balance and the next payout date. Read from
// the captain's earnings entries, the collections' pay parts, the online
// periods and the receipts.
@Injectable()
export class EarningsService {
  constructor(
    private readonly captains: CaptainsService,
    private readonly orders: OrdersService,
    private readonly desk: CashDeskService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
  ) {}

  async earnings(captainId: string, now: Date): Promise<CaptainEarnings> {
    const captain = await this.captains.captain(captainId, now);
    if (captain === null) throw new Error(`captain ${captainId} not found`);
    const { cityId } = captain;
    const [timeZone, cutoff, payoutWeekday, policy] = await Promise.all([
      this.geo.cityTimeZone(cityId),
      this.settings.get('finance.business_day_cutoff', { cityId }),
      this.settings.get('captain.payout_weekday', { cityId }),
      this.settings.get('captain.negative_earnings_policy', { cityId }),
    ]);
    if (timeZone === null) throw new Error(`city ${cityId} has no clock`);
    const [hours, minutes] = cutoff.split(':').map(Number) as [number, number];
    const cycle = payoutCycle(now, hours * 60 + minutes, timeZone, payoutWeekday);
    const [{ balance, entries }, todayOnline, weekOnline] = await Promise.all([
      this.captains.earnings(captainId, cycle.weekFrom),
      this.captains.onlineMinutes(captainId, cycle.todayFrom, now),
      this.captains.onlineMinutes(captainId, cycle.weekFrom, now),
    ]);
    const paid = orderLines(entries);
    const other = otherLines(entries);
    const orderIds = [
      ...paid.map((line) => line.orderId),
      ...other.flatMap((line) =>
        line.sourceKind === 'order' && line.sourceId ? [line.sourceId] : [],
      ),
    ];
    const receiptIds = other.flatMap((line) =>
      line.sourceKind === 'receipt' && line.sourceId ? [line.sourceId] : [],
    );
    const [numbers, parts, receipts] = await Promise.all([
      this.orders.orderNumbers(orderIds),
      this.orders.payParts(paid.map((line) => line.orderId)),
      this.desk.receiptNumbers(receiptIds),
    ]);
    return {
      currency: balance.currency,
      today: {
        from: cycle.todayFrom,
        ...windowTotals(entries, cycle.todayFrom),
        onlineMinutes: todayOnline,
      },
      week: {
        from: cycle.weekFrom,
        ...windowTotals(entries, cycle.weekFrom),
        onlineMinutes: weekOnline,
      },
      orders: paid.map((line) => {
        const recorded = parts.get(line.orderId);
        const matches =
          recorded !== undefined &&
          recorded.basePay + recorded.distancePay + recorded.topUpPay === line.orderPay &&
          recorded.waitingPay === line.waitingPay &&
          recorded.peakBonus === line.peakBonus;
        return {
          orderNumber: numbers.get(line.orderId) ?? null,
          at: line.at,
          parts: matches ? recorded : null,
          total: line.total,
        };
      }),
      lines: other.map((line) => ({
        kind: line.kind,
        amount: line.amount,
        reason: line.reason,
        orderNumber:
          line.sourceKind === 'order' && line.sourceId
            ? (numbers.get(line.sourceId) ?? null)
            : null,
        receiptNumber:
          line.sourceKind === 'receipt' && line.sourceId
            ? (receipts.get(line.sourceId) ?? null)
            : null,
        at: line.at,
      })),
      balance: balance.amount,
      payoutWeekday,
      nextPayout: cycle.nextPayout,
      policy,
    };
  }
}
