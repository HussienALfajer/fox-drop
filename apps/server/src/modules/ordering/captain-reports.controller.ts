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
import { and, eq } from 'drizzle-orm';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { CaptainController } from '../../http/route-groups.js';
import { NOTE_MAX } from '../content/index.js';
import {
  CustomerNewUploadDto,
  CustomerUploadDto,
  FilesRefusedError,
  FilesService,
  reportPhoto,
} from '../files/index.js';
import type { AppSession } from '../identity/index.js';
import { CaptainsService } from '../captains/index.js';
import {
  type CaptainReport,
  captainProblemProblem,
  captainTicketBody,
  captainTicketOut,
  openingHash,
  PICKUP_AMOUNT_REASON,
  type ReportingCaptain,
  SupportService,
  type TicketOrder,
  ticketAnswered,
  TicketRefusedError,
} from '../support/index.js';
import { UNTIL_ENDED } from './active-orders.js';
import { linesOfBody, paymentLines } from './captain-orders.controller.js';
import { CAPTAIN_ACTIVE } from './order-assignments.js';
import { lockOrder } from './order-events.js';
import { AFTER_PICKUP } from './order-views.js';
import {
  checkLines,
  linesOf,
  lockForPickup,
  type PaymentLine,
  storedLines,
} from './pickup-booking.js';
import { pickupCorrection } from './pickup-correction.js';
import { orders, pickupDisputes, pickupRequests } from './schema.js';

const note = z
  .string()
  .max(NOTE_MAX)
  .nullable()
  .describe('Optional, up to 300 characters; the text of «أخرى».');

class CaptainReportBodyDto extends createZodDto(
  z.object({
    typeCode: z
      .string()
      .min(1)
      .max(64)
      .describe("A code of Content's captain_ticket_type list (CA Appendix C)."),
    orderId: z.uuid().nullable().describe("Optional: one of the captain's orders."),
    note,
    photoUploadId: z
      .uuid()
      .nullable()
      .describe('One photo at most, from POST /v1/captain/uploads/report-photo once uploaded.'),
  }),
) {}

class CaptainProblemBodyDto extends createZodDto(
  z.object({
    reasonCode: z
      .string()
      .min(1)
      .max(64)
      .describe("A code of Content's captain_problem list (CA Appendix C)."),
    note,
    paidLines: paymentLines
      .nullable()
      .describe(
        '«مشكلة في مبلغ الاستلام» (pickup_amount) only, and required with it: the lines the captain actually handed the restaurant.',
      ),
  }),
) {}

class CaptainProblemParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class CaptainReportTicketDto extends createZodDto(z.object({ ticket: captainTicketBody })) {}

// CA §13 «إبلاغ عن مشكلة» and CA §9.11 «مشكلة» with a quick reason (slice
// 2.24c). They live here since a ticket on an order is opened under the
// order's lock, so it is urgent exactly while the order is active, and
// «مشكلة في مبلغ الاستلام» records the pickup dispute (CA §9.4 item 6);
// «بلاغاتي» is support's.
@CaptainController()
export class CaptainTicketsController {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly support: SupportService,
    private readonly captains: CaptainsService,
    private readonly files: FilesService,
  ) {}

  // CA §13: the report's photo, a pre-signed PUT into the private bucket, as
  // the customer's (the DTOs are theirs, so the clients share the models).
  // 429 too_many_uploads.
  @Post('uploads/report-photo')
  @AppSignedIn()
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerUploadDto })
  uploadPhoto(@CurrentAppSession() session: AppSession, @Body() body: CustomerNewUploadDto) {
    reporterOf(session, null);
    return reportPhoto(this.files, body, session.accountId);
  }

  // 400 unknown_reason, too_many_photos and the photo's upload_not_found,
  // upload_expired, upload_missing, upload_invalid; 404 unknown_order (not
  // one of the captain's orders); 409 upload_used; 422
  // idempotency_key_reused.
  @Post('reports')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainReportTicketDto })
  report(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Body() body: CaptainReportBodyDto,
    @Req() request: FastifyRequest,
  ) {
    const by = reporterOf(session, request);
    return this.open(by, idempotencyKey, body.orderId, {
      kind: 'report',
      typeCode: body.typeCode,
      note: body.note,
      photoUploadId: body.photoUploadId,
    });
  }

  // CA §9.11: a quick reason on the captain's active order. «مشكلة في مبلغ
  // الاستلام» opens «خلاف على دفعة الاستلام» (CA §9.4 item 6). 400
  // unknown_reason, lines_required, lines_not_allowed, invalid_lines,
  // no_difference; 404 unknown_order (not the captain's order); 409
  // order_state_changed (not the captain's active order; for the pickup
  // amount, not after the pickup or not the captain who paid),
  // pickup_already_disputed; 422 idempotency_key_reused.
  @Post('orders/:orderId/problem')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CaptainReportTicketDto })
  async problem(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: CaptainProblemParamsDto,
    @Body() body: CaptainProblemBodyDto,
    @Req() request: FastifyRequest,
  ) {
    const by = reporterOf(session, request);
    const refusal = captainProblemProblem({
      reasonCode: body.reasonCode,
      lines: body.paidLines?.length ?? null,
    });
    if (refusal !== null) {
      throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: refusal });
    }
    if (body.reasonCode === PICKUP_AMOUNT_REASON) {
      return this.pickupAmount(by, idempotencyKey, params.orderId, {
        device: session.deviceId,
        note: body.note,
        paid: linesOfBody(body.paidLines!),
      });
    }
    return this.open(by, idempotencyKey, params.orderId, {
      kind: 'problem',
      typeCode: body.reasonCode,
      note: body.note,
      photoUploadId: null,
    });
  }

  private async open(
    by: ReportingCaptain,
    idempotencyKey: string,
    orderId: string | null,
    report: CaptainReport,
  ) {
    const now = new Date();
    const placed = orderId === null ? null : await this.ownOrder(orderId, by.captainId);
    const cityId = placed?.cityId ?? (await this.captains.captain(by.captainId, now))?.cityId;
    if (cityId === undefined) throw new ForbiddenException();
    const id = await answered(async () => {
      // A repeat answers its ticket before any refusal.
      const replayed = await this.support.replayed(
        by.accountId,
        idempotencyKey,
        this.support.captainReportHash(report, orderId),
      );
      if (replayed !== null) return replayed;
      const ready = await this.support.prepareCaptainReport(cityId, report, by, now);
      return this.database.db.transaction(async (tx) => {
        let order: TicketOrder | null = null;
        if (placed !== null) {
          const locked = await lockOrder(tx, placed.id, placed.placedAt);
          if (!locked || locked.captainId !== by.captainId) throw unknownOrder();
          // «مشكلة» is on the active order's steps only (CA §9.11).
          if (report.kind === 'problem' && !CAPTAIN_ACTIVE.includes(locked.status)) {
            throw new TicketRefusedError('order_state_changed', 'the order is not active');
          }
          order = ticketOrderOf(locked);
        }
        return this.support.openCaptainReportIn(tx, ready, order, by, idempotencyKey, now);
      });
    });
    return this.answer(by, id);
  }

  // CA §9.4 item 6 (owner decision 2026-11-17): while the order is active
  // after the pickup, the captain who paid records the lines they actually
  // handed over; once per order, whoever disputed first. The same
  // `pickup_disputes` row as the restaurant's «المبلغ غير صحيح» (opened by
  // the captain) and its ticket, in one transaction under the order's lock.
  // The order's state does not change, so no order event.
  private async pickupAmount(
    by: ReportingCaptain,
    idempotencyKey: string,
    orderId: string,
    input: { device: string; note: string | null; paid: PaymentLine[] },
  ) {
    const now = new Date();
    const placed = await this.ownOrder(orderId, by.captainId);
    const requestHash = openingHash(
      {
        cityId: placed.cityId,
        party: 'captain',
        partyId: by.captainId,
        typeCode: PICKUP_AMOUNT_REASON,
        description: `${input.note?.trim() ?? ''}|${JSON.stringify(storedLines(input.paid))}`,
        restaurantId: null,
      },
      orderId,
    );
    const id = await answered(async () => {
      const replayed = await this.support.replayed(by.accountId, idempotencyKey, requestHash);
      if (replayed !== null) return replayed;
      const timers = await this.support.preparePickupDispute(placed.cityId);
      return this.database.db.transaction(async (tx) => {
        const order = await lockForPickup(tx, placed.id, placed.placedAt);
        if (!order || order.captainId !== by.captainId) throw unknownOrder();
        const again = await this.support.captainDisputeReplayedIn(
          tx,
          by.accountId,
          idempotencyKey,
          requestHash,
        );
        if (again !== null) return again;
        const [confirmed] = await tx
          .select({
            id: pickupRequests.id,
            captainId: pickupRequests.captainId,
            lines: pickupRequests.lines,
            bookedLines: pickupRequests.bookedLines,
          })
          .from(pickupRequests)
          .where(and(eq(pickupRequests.orderId, order.id), eq(pickupRequests.status, 'confirmed')));
        if (
          !AFTER_PICKUP.includes(order.status) ||
          !confirmed ||
          confirmed.captainId !== by.captainId
        ) {
          throw new TicketRefusedError(
            'order_state_changed',
            'the pickup amount is reported after the pickup by the captain who paid',
          );
        }
        const [disputed] = await tx
          .select({ id: pickupDisputes.id })
          .from(pickupDisputes)
          .where(eq(pickupDisputes.orderId, order.id));
        if (disputed) {
          throw new TicketRefusedError(
            'pickup_already_disputed',
            'the pickup was disputed already',
          );
        }
        // What the captain handed over, in any currency the order accepted,
        // and something «تصحيح في الحسابات» could post.
        const currencies = order.snapshot.currencies.map((entry) => entry.code);
        if (checkLines(order.snapshot, input.paid, null, currencies) !== null) {
          throw new TicketRefusedError('invalid_lines', 'invalid lines');
        }
        const correction = pickupCorrection({
          snapshot: order.snapshot,
          captainId: by.captainId,
          restaurantId: order.restaurantId,
          recorded: linesOf(confirmed.bookedLines ?? confirmed.lines),
          received: input.paid,
        });
        if (correction.journals.length === 0) {
          throw new TicketRefusedError('no_difference', 'the lines are those recorded');
        }
        const [dispute] = await tx
          .insert(pickupDisputes)
          .values({
            orderId: order.id,
            orderPlacedAt: order.placedAt,
            cityId: order.cityId,
            pickupRequestId: confirmed.id,
            accountId: by.accountId,
            device: input.device,
            receivedLines: storedLines(input.paid),
            createdAt: now,
            status: 'open',
            openedBy: 'captain',
          })
          .returning({ id: pickupDisputes.id });
        return this.support.openCaptainPickupDisputeIn(
          tx,
          timers,
          {
            order: ticketOrderOf(order),
            disputeId: dispute!.id,
            by,
            note: input.note,
            idempotencyKey,
            requestHash,
          },
          now,
        );
      });
    });
    return this.answer(by, id);
  }

  // One of the captain's orders (its current captain); 404 unknown_order
  // otherwise.
  private async ownOrder(orderId: string, captainId: string) {
    const [placed] = await this.database.db
      .select({ id: orders.id, placedAt: orders.placedAt, cityId: orders.cityId })
      .from(orders)
      .where(and(eq(orders.id, orderId), eq(orders.captainId, captainId)));
    if (!placed) throw unknownOrder();
    return placed;
  }

  private async answer(by: ReportingCaptain, id: string) {
    const ticket = await this.support.captainTicket(
      { accountId: by.accountId, captainId: by.captainId },
      id,
    );
    return { ticket: captainTicketOut(ticket!) };
  }
}

function ticketOrderOf(locked: {
  id: string;
  cityId: string;
  number: bigint;
  status: (typeof UNTIL_ENDED)[number];
  customerAccountId: string;
  restaurantId: string;
  captainId: string | null;
}): TicketOrder {
  return {
    id: locked.id,
    cityId: locked.cityId,
    number: locked.number,
    active: UNTIL_ENDED.includes(locked.status),
    customerId: locked.customerAccountId,
    restaurantId: locked.restaurantId,
    captainId: locked.captainId,
  };
}

// The session's captain.
function reporterOf(session: AppSession, request: FastifyRequest | null): ReportingCaptain {
  if (session.captain === null) throw new ForbiddenException();
  return {
    accountId: session.accountId,
    captainId: session.captain.captainId,
    context: request === null ? { ipAddress: null, device: null } : requestContext(request),
  };
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
