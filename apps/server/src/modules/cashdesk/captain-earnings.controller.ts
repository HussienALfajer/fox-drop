import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { otherKinds } from './earnings.js';
import { type EarningsWindow, EarningsService } from './earnings.service.js';

const signedMinor = z
  .string()
  .regex(/^-?\d{1,19}$/)
  .describe('Integer minor units of the base currency (AP §8.6).');

const window = z.object({
  from: z.iso.datetime().describe('The start of the window: a business-day cutoff.'),
  earnings: signedMinor.describe('Every earning since, the payouts left out.'),
  orders: z.int().min(0).describe('The orders whose pay nets above zero.'),
  onlineMinutes: z.int().min(0),
});

class CaptainEarningsDto extends createZodDto(
  z.object({
    currency: z.string().length(3).describe("The city's base currency."),
    today: window.describe('The business day now.'),
    week: window.describe(
      '«هذا الأسبوع»: the payout cycle since the latest payout weekday, by business day.',
    ),
    orders: z
      .array(
        z.object({
          orderNumber: z.string().nullable(),
          at: z.iso.datetime(),
          parts: z
            .object({
              base: signedMinor.describe('Including the first km.'),
              distance: signedMinor,
              topUp: signedMinor.describe('«إكمال للحد الأدنى».'),
              waiting: signedMinor,
              peak: signedMinor,
            })
            .nullable()
            .describe('Null when only the total is known (an order ended by an outcome).'),
          total: signedMinor,
        }),
      )
      .describe("This week's orders, newest first."),
    lines: z
      .array(
        z.object({
          kind: z.enum(otherKinds),
          amount: signedMinor.describe('+ to the captain, − taken off.'),
          reason: z.string().nullable(),
          orderNumber: z.string().nullable().describe("A charge's order."),
          receiptNumber: z.string().nullable().describe("A payout's receipt."),
          at: z.iso.datetime(),
        }),
      )
      .describe(
        "This week's bonuses, charges, instalments, payouts and corrections, newest first.",
      ),
    balance: signedMinor.describe(
      '«رصيدك المستحق»: + the platform owes the captain, − carried or collected by the policy.',
    ),
    payoutWeekday: z.enum([
      'saturday',
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
    ]),
    nextPayout: z.iso.date().describe('«موعد القبض»: today on a payout day, on the city clock.'),
    negativePolicy: z.enum(['carry_forward', 'collect_at_desk']),
  }),
) {}

// CA §10.6 «أرباحي» (slice 2.18b). The app reads it again on the captain
// channel's captain.availability_changed, which every desk receipt sends.
@CaptainController('earnings')
export class CaptainEarningsController {
  constructor(private readonly earnings: EarningsService) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainEarningsDto })
  async read(@CurrentAppSession() session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    const read = await this.earnings.earnings(session.captain.captainId, new Date());
    const windowBody = (each: EarningsWindow) => ({
      from: each.from.toISOString(),
      earnings: each.earnings.toString(),
      orders: each.orders,
      onlineMinutes: each.onlineMinutes,
    });
    return {
      currency: read.currency,
      today: windowBody(read.today),
      week: windowBody(read.week),
      orders: read.orders.map((order) => ({
        orderNumber: order.orderNumber?.toString() ?? null,
        at: order.at.toISOString(),
        parts: order.parts && {
          base: order.parts.basePay.toString(),
          distance: order.parts.distancePay.toString(),
          topUp: order.parts.topUpPay.toString(),
          waiting: order.parts.waitingPay.toString(),
          peak: order.parts.peakBonus.toString(),
        },
        total: order.total.toString(),
      })),
      lines: read.lines.map((line) => ({
        kind: line.kind,
        amount: line.amount.toString(),
        reason: line.reason,
        orderNumber: line.orderNumber?.toString() ?? null,
        receiptNumber: line.receiptNumber,
        at: line.at.toISOString(),
      })),
      balance: read.balance.toString(),
      payoutWeekday: read.payoutWeekday,
      nextPayout: read.nextPayout,
      negativePolicy: read.policy,
    };
  }
}
