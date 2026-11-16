import { ForbiddenException, Get, HttpStatus, NotFoundException, Param } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { MerchantController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import type { MerchantReceipt } from './merchant-settlement.service.js';
import { actorTypes, MerchantRecordsService } from './merchant-records.service.js';
import { merchantExceptionCauses, merchantStatementLineKinds, receiptMethods } from './schema.js';

const minor = z
  .string()
  .regex(/^\d{1,19}$/)
  .describe('Integer minor units (AP §8.6).');
const signedMinor = z
  .string()
  .regex(/^-?\d{1,19}$/)
  .describe('Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).');
const currency = z.string().regex(/^[A-Z]{3}$/);
// RA §12.3 «غير مسدّد», «مسدّد جزئياً», «مسدّد»; null when the statement asked
// nothing of the restaurant.
const status = z.enum(['unpaid', 'partly_paid', 'paid']).nullable();

class MerchantStatementListDto extends createZodDto(
  z.object({
    statements: z
      .array(
        z.object({
          id: z.uuid(),
          cutoff: z.iso.datetime().describe('The settlement day’s cutoff that closed it.'),
          periodFrom: z.iso
            .datetime()
            .nullable()
            .describe('The previous statement’s cutoff, null for the first.'),
          currency,
          weekTotal: signedMinor,
          totalDue: signedMinor,
          status,
          unpaid: signedMinor.describe('What of the total due is still unpaid, oldest first.'),
        }),
      )
      .describe('The latest statements (a year), newest first.'),
  }),
) {}

class MerchantStatementParamsDto extends createZodDto(z.object({ statementId: z.uuid() })) {}

class MerchantStatementDto extends createZodDto(
  z.object({
    id: z.uuid(),
    restaurantName: z.string(),
    cutoff: z.iso.datetime(),
    periodFrom: z.iso.datetime().nullable(),
    currency,
    orders: z.int(),
    itemsValue: signedMinor,
    commission: signedMinor,
    discountShare: signedMinor,
    exceptions: signedMinor,
    weekTotal: signedMinor,
    previousDue: signedMinor,
    paid: signedMinor,
    earlierUnpaid: signedMinor,
    totalDue: signedMinor,
    status,
    unpaid: signedMinor.describe('What of the total due is still unpaid, oldest first.'),
    // Flat, since the Dart generator misnames an enum inside a nested object.
    lines: z.array(
      z.object({
        kind: z.enum(merchantStatementLineKinds),
        at: z.iso.datetime(),
        orderId: z.uuid().nullable(),
        orderNumber: z.string().nullable(),
        itemsValue: signedMinor.nullable().describe('An order: its pickup payment.'),
        pickupLines: z
          .array(z.object({ currency, amount: signedMinor }))
          .nullable()
          .describe('An order: the currency lines the captain paid.'),
        commission: signedMinor.nullable(),
        discountShare: signedMinor.nullable(),
        cause: z.enum(merchantExceptionCauses).nullable().describe('An exception (RA §12.5).'),
        amount: signedMinor.nullable().describe('An exception or a payment.'),
        reason: z.string().nullable(),
        decidedBy: z
          .enum(actorTypes)
          .nullable()
          .describe('«من قرّر» on an exception (RA §12.5): who posted it.'),
        decidedByName: z.string().nullable().describe('The FOX DROP staff member, by name.'),
      }),
    ),
  }),
) {}

const receiptFields = {
  id: z.uuid(),
  number: z.string(),
  type: z
    .enum(['merchant_settlement', 'merchant_payout'])
    .describe('The restaurant paid, or FOX DROP paid it.'),
  method: z.enum(receiptMethods).describe('«في المكتب» or «زيارة ميدانية».'),
  staffName: z
    .string()
    .nullable()
    .describe('The staff member: the visitor on a field visit, else the cashier.'),
  currency: currency.describe("The account's base currency."),
  total: minor.describe('In the base.'),
  createdAt: z.iso.datetime(),
  lines: z.array(z.object({ currency, amount: minor, base: minor })),
};

class MerchantReceiptListDto extends createZodDto(
  z.object({ receipts: z.array(z.object(receiptFields)).describe('Newest first.') }),
) {}

class MerchantReceiptParamsDto extends createZodDto(z.object({ receiptId: z.uuid() })) {}

class MerchantReceiptDto extends createZodDto(
  z.object({
    ...receiptFields,
    dueBefore: signedMinor,
    dueAfter: signedMinor,
  }),
) {}

function receiptBody(found: MerchantReceipt) {
  return {
    id: found.id,
    number: found.number,
    type: found.type,
    method: found.method,
    staffName: found.method === 'field' ? found.visitorName : found.cashierName,
    currency: found.currency,
    total: found.total.toString(),
    createdAt: found.createdAt.toISOString(),
    lines: found.lines.map((line) => ({
      currency: line.currency,
      amount: line.amount.toString(),
      base: line.base.toString(),
    })),
  };
}

// RA §12.3–12.5, R10 (slice 2.19e): «الكشوف» and «الإيصالات», owners only
// (a cashier gets 403 owner_only); another restaurant's is unknown.
@MerchantController()
export class MerchantRecordsController {
  constructor(
    private readonly records: MerchantRecordsService,
    private readonly merchants: MerchantsService,
  ) {}

  @Get('statements')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantStatementListDto })
  async statements(@CurrentAppSession() session: AppSession) {
    const restaurant = await this.ownersRestaurant(session);
    const found = await this.records.statementList(restaurant.id, restaurant.cityId);
    return {
      statements: found.map((row) => ({
        id: row.id,
        cutoff: row.cutoff.toISOString(),
        periodFrom: row.periodFrom?.toISOString() ?? null,
        currency: row.currency,
        weekTotal: row.weekTotal.toString(),
        totalDue: row.totalDue.toString(),
        status: row.status,
        unpaid: row.unpaid.toString(),
      })),
    };
  }

  @Get('statements/:statementId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantStatementDto })
  async statement(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantStatementParamsDto,
  ) {
    const restaurant = await this.ownersRestaurant(session);
    const found = await this.records.statement(restaurant.id, params.statementId);
    if (!found) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_statement' });
    }
    return {
      id: found.id,
      restaurantName: found.restaurantName,
      cutoff: found.cutoff.toISOString(),
      periodFrom: found.periodFrom?.toISOString() ?? null,
      currency: found.currency,
      orders: found.orders,
      itemsValue: found.itemsValue.toString(),
      commission: found.commission.toString(),
      discountShare: found.discountShare.toString(),
      exceptions: found.exceptions.toString(),
      weekTotal: found.weekTotal.toString(),
      previousDue: found.previousDue.toString(),
      paid: found.paid.toString(),
      earlierUnpaid: found.earlierUnpaid.toString(),
      totalDue: found.totalDue.toString(),
      status: found.status,
      unpaid: found.unpaid.toString(),
      lines: found.lines.map((line) => {
        const shared = {
          kind: line.kind,
          at: line.at.toISOString(),
          orderId: line.orderId,
          orderNumber: line.orderNumber?.toString() ?? null,
          decidedBy: line.decidedBy?.type ?? null,
          decidedByName: line.decidedBy?.name ?? null,
        };
        return line.kind === 'order'
          ? {
              ...shared,
              itemsValue: line.itemsValue?.toString() ?? null,
              pickupLines:
                line.pickupLines?.map((each) => ({
                  currency: each.currency,
                  amount: each.amount.toString(),
                })) ?? null,
              commission: line.commission.toString(),
              discountShare: line.discountShare.toString(),
              cause: null,
              amount: null,
              reason: null,
            }
          : {
              ...shared,
              itemsValue: null,
              pickupLines: null,
              commission: null,
              discountShare: null,
              cause: line.cause,
              amount: line.amount.toString(),
              reason: line.reason,
            };
      }),
    };
  }

  @Get('receipts')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantReceiptListDto })
  async receipts(@CurrentAppSession() session: AppSession) {
    const restaurant = await this.ownersRestaurant(session);
    return { receipts: (await this.records.receipts(restaurant.id)).map(receiptBody) };
  }

  @Get('receipts/:receiptId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantReceiptDto })
  async receipt(
    @CurrentAppSession() session: AppSession,
    @Param() params: MerchantReceiptParamsDto,
  ) {
    const restaurant = await this.ownersRestaurant(session);
    const found = await this.records.receipt(restaurant.id, params.receiptId);
    if (!found) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_receipt' });
    }
    return {
      ...receiptBody(found),
      dueBefore: found.dueBefore.toString(),
      dueAfter: found.dueAfter.toString(),
    };
  }

  // R10: owners only; a terminated restaurant's owners keep it (RA §5.5).
  private async ownersRestaurant(session: AppSession) {
    if (!session.merchant) throw new Error('a merchant route without a restaurant user');
    if (session.merchant.role !== 'owner') {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'owner_only' });
    }
    const restaurant = await this.merchants.restaurant(session.merchant.restaurantId);
    if (!restaurant) throw new Error('the session names no restaurant');
    return restaurant;
  }
}
