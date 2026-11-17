import { BadRequestException, Body, HttpCode, HttpStatus, Param, Post, Req } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { CustomerController } from '../../http/route-groups.js';
import { NOTE_MAX } from '../content/index.js';
import { FilesRefusedError } from '../files/index.js';
import type { AppSession } from '../identity/index.js';
import { SupportService } from './support.service.js';
import { answered } from './ticket-body.js';

class CustomerPriceReportParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class CustomerPriceReportBodyDto extends createZodDto(
  z.object({
    itemId: z.uuid().nullable().describe('Optional, picked from the menu.'),
    shopPrice: z
      .string()
      .regex(/^\d{1,15}$/)
      .nullable()
      .describe("Optional: the shop's price in minor units of the city's base currency."),
    note: z.string().max(NOTE_MAX).nullable().describe('Optional, up to 300 characters.'),
    photoUploadId: z
      .uuid()
      .nullable()
      .describe(
        "Optional, 1, such as of the shop's menu board (POST /v1/customer/uploads/report-photo).",
      ),
  }),
) {}

class CustomerPriceReportDto extends createZodDto(
  z.object({
    number: z.string().describe('The ticket «سعر مختلف عن المحل», shown as T-{number}.'),
  }),
) {}

// CU §9.5, AP §9.9.1 (slice 2.24a): «أبلغ عن سعر مختلف» on a restaurant page.
// The app answers «شكراً، سنتحقق من السعر»; the resolution reaches the
// customer as a push.
@CustomerController('restaurants')
export class CustomerPriceReportsController {
  constructor(private readonly support: SupportService) {}

  // 404 unknown_restaurant; 400 unknown_item, invalid_price and the photo's
  // upload_not_found, upload_expired, upload_missing, upload_invalid; 409
  // already_reported_today («أرسلت بلاغاً عن هذا المطعم اليوم»),
  // no_base_currency, upload_used; 422 idempotency_key_reused.
  @Post(':restaurantId/price-report')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerPriceReportDto })
  async report(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CustomerPriceReportParamsDto,
    @Body() body: CustomerPriceReportBodyDto,
    @Req() request: FastifyRequest,
  ) {
    try {
      const ticket = await answered(() =>
        this.support.reportPrice(
          {
            restaurantId: params.restaurantId,
            itemId: body.itemId,
            shopPrice: body.shopPrice === null ? null : BigInt(body.shopPrice),
            note: body.note,
            photoUploadId: body.photoUploadId,
          },
          { accountId: session.accountId, context: requestContext(request) },
          idempotencyKey,
          new Date(),
        ),
      );
      return { number: ticket.number.toString() };
    } catch (error) {
      if (error instanceof FilesRefusedError) {
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
      }
      throw error;
    }
  }
}
