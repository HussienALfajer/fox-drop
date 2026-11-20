import {
  BadRequestException,
  Body,
  ForbiddenException,
  HttpCode,
  HttpStatus,
  Inject,
  NotFoundException,
  Param,
  Post,
  Req,
} from '@nestjs/common';
import { eq } from 'drizzle-orm';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { MerchantController } from '../../http/route-groups.js';
import { NOTE_MAX } from '../content/index.js';
import {
  CustomerNewUploadDto,
  CustomerUploadDto,
  FilesRefusedError,
  FilesService,
  reportPhoto,
} from '../files/index.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  dataChangeSubjects,
  type MerchantReport,
  merchantTicketBody,
  merchantTicketOut,
  type ReportingMerchant,
  SupportService,
  type TicketOrder,
  ticketAnswered,
} from '../support/index.js';
import { UNTIL_ENDED } from './active-orders.js';
import { lockOrder } from './order-events.js';
import { orders } from './schema.js';

const note = z
  .string()
  .max(NOTE_MAX)
  .nullable()
  .describe('Optional, up to 300 characters; the text of «أخرى».');

class MerchantReportBodyDto extends createZodDto(
  z.object({
    typeCode: z
      .string()
      .min(1)
      .max(64)
      .describe("A code of Content's merchant_ticket_type list (RA Appendix C)."),
    orderId: z.uuid().nullable().describe("Optional: one of the restaurant's orders."),
    note,
    subject: z
      .enum(dataChangeSubjects)
      .nullable()
      .describe('«طلب تعديل بيانات» (data_change) only, and required with it.'),
    photoUploadId: z
      .uuid()
      .nullable()
      .describe('One photo at most, from POST /v1/merchant/uploads/report-photo once uploaded.'),
  }),
) {}

class MerchantOrderProblemBodyDto extends createZodDto(
  z.object({
    reasonCode: z
      .string()
      .min(1)
      .max(64)
      .describe("A code of Content's merchant_problem list (RA Appendix C)."),
    note,
  }),
) {}

class MerchantReportOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class MerchantReportTicketDto extends createZodDto(z.object({ ticket: merchantTicketBody })) {}

// RA §15 «إبلاغ عن مشكلة» and RA §8.19 «مشكلة في الطلب» (slice 2.24b): the
// restaurant's tickets, for owners and cashiers alike. They live here since
// a ticket on an order is opened under the order's lock, so it is urgent
// exactly while the order is active; «بلاغاتي» is support's.
@MerchantController()
export class MerchantTicketsController {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly support: SupportService,
    private readonly merchants: MerchantsService,
    private readonly files: FilesService,
  ) {}

  // RA §15: the report's photo, a pre-signed PUT into the private bucket,
  // as the customer's (the DTOs are theirs, so the clients share the
  // models); from the owner web portal signed for its own origin (slice
  // 2.45c), whose /private-docs/incoming/ nginx forwards for PUT. 403 restaurant_terminated; 429 too_many_uploads.
  @Post('uploads/report-photo')
  @AppSignedIn({ portal: true })
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerUploadDto })
  async uploadPhoto(
    @CurrentAppSession() session: AppSession,
    @Body() body: CustomerNewUploadDto,
    @Req() request: FastifyRequest,
  ) {
    const by = await this.reporter(session, request);
    return reportPhoto(this.files, body, by.accountId, session.portal ? 'portal' : 'app');
  }

  // 400 unknown_reason, too_many_photos, subject_required, invalid_subject
  // and the photo's upload_not_found, upload_expired, upload_missing,
  // upload_invalid; 404 unknown_order; 409 upload_used; 422
  // idempotency_key_reused.
  @Post('reports')
  @AppSignedIn({ portal: true })
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantReportTicketDto })
  report(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Body() body: MerchantReportBodyDto,
    @Req() request: FastifyRequest,
  ) {
    return this.open(session, idempotencyKey, request, body.orderId, {
      kind: 'report',
      typeCode: body.typeCode,
      note: body.note,
      subject: body.subject,
      photoUploadId: body.photoUploadId,
    });
  }

  // RA §8.19: a quick reason on any of the restaurant's orders. 400
  // unknown_reason; 404 unknown_order; 422 idempotency_key_reused.
  @Post('orders/:orderId/problem')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantReportTicketDto })
  problem(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantReportOrderParamsDto,
    @Body() body: MerchantOrderProblemBodyDto,
    @Req() request: FastifyRequest,
  ) {
    return this.open(session, idempotencyKey, request, params.orderId, {
      kind: 'order_problem',
      typeCode: body.reasonCode,
      note: body.note,
      subject: null,
      photoUploadId: null,
    });
  }

  private async open(
    session: AppSession,
    idempotencyKey: string,
    request: FastifyRequest,
    orderId: string | null,
    report: MerchantReport,
  ) {
    const by = await this.reporter(session, request);
    const viewer = { accountId: by.accountId, restaurantId: by.restaurantId, role: by.role };
    const now = new Date();
    const placed =
      orderId === null
        ? null
        : ((
            await this.database.db
              .select({ placedAt: orders.placedAt, restaurantId: orders.restaurantId })
              .from(orders)
              .where(eq(orders.id, orderId))
          )[0] ?? null);
    if (orderId !== null && (placed === null || placed.restaurantId !== by.restaurantId)) {
      throw unknownOrder();
    }
    const restaurant = await this.merchants.restaurant(by.restaurantId, now);
    if (restaurant === null) throw unknownOrder();
    const id = await answered(async () => {
      // A repeat answers its ticket before any refusal.
      const replayed = await this.support.replayed(
        by.accountId,
        idempotencyKey,
        this.support.merchantReportHash(report, orderId),
      );
      if (replayed !== null) return replayed;
      const ready = await this.support.prepareMerchantReport(restaurant.cityId, report, by, now);
      return this.database.db.transaction(async (tx) => {
        let order: TicketOrder | null = null;
        if (orderId !== null) {
          const locked = await lockOrder(tx, orderId, placed!.placedAt);
          if (!locked) throw unknownOrder();
          order = {
            id: locked.id,
            cityId: locked.cityId,
            number: locked.number,
            active: UNTIL_ENDED.includes(locked.status),
            customerId: locked.customerAccountId,
            restaurantId: locked.restaurantId,
            captainId: locked.captainId,
          };
        }
        return this.support.openMerchantReportIn(tx, ready, order, by, idempotencyKey, now);
      });
    });
    const ticket = await this.support.merchantTicket(viewer, id);
    return { ticket: merchantTicketOut(ticket!) };
  }

  // The session's restaurant user, refused once the restaurant is
  // terminated (RA §5.5).
  private async reporter(session: AppSession, request: FastifyRequest): Promise<ReportingMerchant> {
    const merchant = session.merchant;
    if (!merchant) throw new Error('a merchant route without a restaurant user');
    if ((await this.merchants.accountStatus(merchant.restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    return {
      accountId: session.accountId,
      restaurantId: merchant.restaurantId,
      role: merchant.role,
      context: requestContext(request),
    };
  }
}

function unknownOrder(): NotFoundException {
  return new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
}

async function answered<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await ticketAnswered(run);
  } catch (error) {
    if (error instanceof FilesRefusedError) {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
    }
    throw error;
  }
}
