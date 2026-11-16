import { ForbiddenException, Get, HttpStatus } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { MerchantAccountService } from './merchant-account.service.js';
import { actorTypes } from './merchant-records.service.js';
import { merchantExceptionCauses, merchantStatementLineKinds } from './schema.js';

const signedMinor = z
  .string()
  .regex(/^-?\d{1,19}$/)
  .describe("Integer minor units of the city's base currency (AP §8.6).");
const currency = z.string().regex(/^[A-Z]{3}$/);

// Flat lists, since the Dart generator misnames an enum inside a nested
// object.
class MerchantAccountDto extends createZodDto(
  z.object({
    currency: currency.nullable().describe("The city's base currency."),
    balance: signedMinor.describe(
      '«المستحق عليك حتى الآن»: + the restaurant owes, − the platform owes it (AP §8.7).',
    ),
    settlementDate: z.iso
      .date()
      .describe(
        "«موعد التسوية»: the settlement day on the city's clock, the latest statement's while it is unpaid, else the next.",
      ),
    commissionBp: z
      .int()
      .nullable()
      .describe('The current commission in basis points (1500 is 15%).'),
    nextCommission: z
      .object({ rateBp: z.int(), from: z.iso.datetime() })
      .nullable()
      .describe('A change scheduled for new orders (AP D16), or null.'),
    todayFrom: z.iso.datetime().describe("The business day's start (its cutoff)."),
    pickups: z
      .array(
        z.object({
          orderId: z.uuid(),
          orderNumber: z.string(),
          at: z.iso.datetime(),
          captainName: z.string().nullable().describe("The captain's first name."),
          amount: signedMinor.describe('The full items value (RA §12.7).'),
          lines: z
            .array(z.object({ currency, amount: signedMinor }))
            .describe('The currency lines the captain paid.'),
        }),
      )
      .describe('«قبضت اليوم من الكباتن»: the pickups confirmed today, newest first.'),
    weekFrom: z.iso
      .datetime()
      .nullable()
      .describe("The latest statement's cutoff; null before the first statement."),
    weekLines: z
      .array(
        z.object({
          day: z.iso.date().describe("The business day on the city's clock."),
          kind: z.enum(merchantStatementLineKinds),
          at: z.iso.datetime(),
          orderId: z.uuid().nullable(),
          orderNumber: z.string().nullable(),
          itemsValue: signedMinor.nullable().describe('An order: its pickup payment.'),
          commission: signedMinor.nullable().describe('An order: its commission that day.'),
          discountShare: signedMinor
            .nullable()
            .describe('An order: the restaurant-funded discount that day.'),
          cause: z
            .enum(merchantExceptionCauses)
            .nullable()
            .describe('An exception: what it is (RA §12.5).'),
          amount: signedMinor
            .nullable()
            .describe('An exception or a payment: + raises what is owed, − lowers it.'),
          reason: z.string().nullable(),
          decidedBy: z
            .enum(actorTypes)
            .nullable()
            .describe('«من قرّر» on an exception (RA §12.5): who posted it.'),
          decidedByName: z.string().nullable().describe('The FOX DROP staff member, by name.'),
        }),
      )
      .describe(
        "«هذا الأسبوع»: every entry since the latest statement closed, newest day first, each day's orders then its exceptions and payments in the ledger's order.",
      ),
  }),
) {}

// RA §12.2 «الحساب» (slice 2.19d): owners only (R10, a cashier gets 403
// owner_only); a terminated restaurant's owners keep it (RA §5.5).
@MerchantController()
export class MerchantAccountController {
  constructor(
    private readonly account: MerchantAccountService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get('account')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantAccountDto })
  async read(@CurrentAppSession() session: AppSession) {
    if (!session.merchant) throw new Error('a merchant route without a restaurant user');
    if (session.merchant.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    const restaurant = await this.merchants.restaurant(session.merchant.restaurantId);
    if (!restaurant) throw new Error('the session names no restaurant');
    const found = await this.account.account(restaurant.id, restaurant.cityId, new Date());
    return {
      currency: found.currency,
      balance: found.balance.toString(),
      settlementDate: found.settlementDate,
      commissionBp: found.commissionBp,
      nextCommission: found.nextCommission && {
        rateBp: found.nextCommission.rateBp,
        from: found.nextCommission.from.toISOString(),
      },
      todayFrom: found.todayFrom.toISOString(),
      pickups: found.pickups.map((pickup) => ({
        orderId: pickup.orderId,
        orderNumber: pickup.number.toString(),
        at: pickup.at.toISOString(),
        captainName: pickup.captainName,
        amount: pickup.amount.toString(),
        lines: pickup.lines.map((line) => ({
          currency: line.currency,
          amount: line.amount.toString(),
        })),
      })),
      weekFrom: found.weekFrom?.toISOString() ?? null,
      weekLines: found.weekLines.map((line) =>
        line.kind === 'order'
          ? {
              day: line.day,
              kind: line.kind,
              at: line.at.toISOString(),
              orderId: line.orderId,
              orderNumber: line.orderNumber?.toString() ?? null,
              itemsValue: line.itemsValue?.toString() ?? null,
              commission: line.commission.toString(),
              discountShare: line.discountShare.toString(),
              cause: null,
              amount: null,
              reason: null,
              decidedBy: null,
              decidedByName: null,
            }
          : {
              day: line.day,
              kind: line.kind,
              at: line.at.toISOString(),
              orderId: line.orderId,
              orderNumber: line.orderNumber?.toString() ?? null,
              itemsValue: null,
              commission: null,
              discountShare: null,
              cause: line.cause,
              amount: line.amount.toString(),
              reason: line.reason,
              decidedBy: line.decidedBy?.type ?? null,
              decidedByName: line.decidedBy?.name ?? null,
            },
      ),
    };
  }
}
