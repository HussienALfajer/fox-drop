import {
  Body,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import {
  type CustomerDuesPreview,
  CustomerDuesService,
  type CustomerReceipt,
} from './customer-dues.service.js';
import { deskUser, refusalsAsHttp } from './desk-http.js';

const minor = z.string().regex(/^\d{1,18}$/);
const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);
const rates = z
  .array(z.object({ currency, rateVersionId: z.uuid() }))
  .max(10)
  .describe('The rate version of each currency but the base, as the quote gave it.');

class AdminCustomerDuesPreviewRequestDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    customerId: z.uuid(),
    lines: z
      .array(z.object({ currency, amount: minor }))
      .max(10)
      .describe('The cash per currency; none to read the dues alone.'),
  }),
) {}

class AdminCustomerDuesPreviewDto extends createZodDto(
  z.object({
    customerId: z.uuid(),
    customerName: z.string(),
    cityId: z.uuid(),
    currency,
    due: signedMinor.describe('+ the customer owes; 0 or less when nothing is owed.'),
    lines: z.array(
      z.object({
        currency,
        amount: minor,
        base: minor.describe('The value in the base at the current rate.'),
        rates,
        unit: z.object({ from: currency, to: currency, value: z.string() }).nullable(),
      }),
    ),
    total: minor,
    remaining: signedMinor.describe('What stays owed after the payment.'),
  }),
) {}

class AdminCustomerDuesPayDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    customerId: z.uuid(),
    due: signedMinor.describe('The dues the screen showed.'),
    lines: z
      .array(z.object({ currency, amount: minor, base: minor, rates }))
      .min(1)
      .max(10),
  }),
) {}

class AdminCustomerReceiptParamsDto extends createZodDto(z.object({ receiptId: z.uuid() })) {}

class AdminCustomerReceiptsParamsDto extends createZodDto(z.object({ customerId: z.uuid() })) {}

const receipt = z.object({
  id: z.uuid(),
  cityId: z.uuid(),
  number: z.string(),
  sessionId: z.uuid(),
  cashierId: z.uuid(),
  cashierName: z.string().nullable(),
  customerId: z.uuid(),
  customerName: z.string(),
  currency,
  dueBefore: signedMinor,
  total: minor,
  dueAfter: signedMinor,
  createdAt: z.iso.datetime(),
  lines: z.array(z.object({ currency, amount: minor, base: minor })),
});

class AdminCustomerReceiptDto extends createZodDto(receipt) {}

class AdminCustomerReceiptsDto extends createZodDto(z.object({ receipts: z.array(receipt) })) {}

// The latest receipts the profile lists (decided by us).
const CUSTOMER_RECEIPTS = 20;

// AP §8.8, §9.8 «تسجيل دفع المستحق» at the desk (slice 2.25a; OWN and FIN
// through cash_desk.record): the dues and the cash's value, the receipt,
// and the customer's receipts. Money travels as strings of minor units.
@AdminController('cash-desk')
export class AdminCustomerDuesController {
  constructor(private readonly dues: CustomerDuesService) {}

  // A read, so no key. Refused 400 invalid_amounts; 404 unknown_party;
  // 409 rate_missing.
  @Post('customer-dues/preview')
  @RequirePermission('cash_desk.record')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCustomerDuesPreviewDto })
  preview(@Body() body: AdminCustomerDuesPreviewRequestDto) {
    return refusalsAsHttp(async () =>
      previewBody(
        await this.dues.preview(
          body.cityId,
          body.customerId,
          body.lines.map((line) => ({ currency: line.currency, amount: BigInt(line.amount) })),
        ),
      ),
    );
  }

  // «تأكيد وإصدار الإيصال»: the receipt; the block lifts by itself once the
  // dues reach zero. Refused 400 invalid_amounts; 404 unknown_party (also a
  // drawer of another city); 409 no_open_session, nothing_due,
  // balance_changed, rate_changed, above_balance, rate_missing;
  // 422 idempotency_key_reused.
  @Post('customer-dues')
  @RequirePermission('cash_desk.record')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminCustomerReceiptDto })
  pay(
    @Body() body: AdminCustomerDuesPayDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      receiptBody(
        await this.dues.pay(
          deskUser(session, request),
          {
            cityId: body.cityId,
            customerId: body.customerId,
            due: BigInt(body.due),
            lines: body.lines.map((line) => ({
              currency: line.currency,
              amount: BigInt(line.amount),
              base: BigInt(line.base),
              rates: line.rates,
            })),
            idempotencyKey,
          },
          new Date(),
        ),
      ),
    );
  }

  // A customer's receipt, to print on 80 mm or A4.
  @Get('customer-receipts/:receiptId')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminCustomerReceiptDto })
  async receipt(@Param() params: AdminCustomerReceiptParamsDto) {
    const found = await this.dues.receipt(params.receiptId);
    if (!found) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_receipt' });
    }
    return receiptBody(found);
  }

  // The customer's latest receipts, newest first.
  @Get('customers/:customerId/receipts')
  @RequirePermission('cash_desk.record')
  @ZodResponse({ status: 200, type: AdminCustomerReceiptsDto })
  async receipts(@Param() params: AdminCustomerReceiptsParamsDto) {
    const found = await this.dues.customerReceipts(params.customerId, CUSTOMER_RECEIPTS);
    return { receipts: found.map(receiptBody) };
  }
}

function previewBody(found: CustomerDuesPreview) {
  return {
    ...found,
    due: found.due.toString(),
    lines: found.lines.map((line) => ({
      currency: line.currency,
      amount: line.amount.toString(),
      base: line.base.toString(),
      rates: line.rates,
      unit: line.unit,
    })),
    total: found.total.toString(),
    remaining: found.remaining.toString(),
  };
}

function receiptBody(found: CustomerReceipt) {
  return {
    ...found,
    dueBefore: found.dueBefore.toString(),
    total: found.total.toString(),
    dueAfter: found.dueAfter.toString(),
    createdAt: found.createdAt.toISOString(),
    lines: found.lines.map((line) => ({
      currency: line.currency,
      amount: line.amount.toString(),
      base: line.base.toString(),
    })),
  };
}
