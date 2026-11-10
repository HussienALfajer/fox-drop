import {
  BadRequestException,
  Body,
  ConflictException,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { MerchantController } from '../../http/route-groups.js';
import { CaptainsService } from '../captains/index.js';
import { CustomersService } from '../customers/index.js';
import { type AppSession, MerchantAccountsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import { linesBody, linesOfBody, paymentLines } from './captain-orders.controller.js';
import { minor } from './customer-quote.controller.js';
import { PickupCommands } from './pickup-commands.js';
import { currentRequests, type PickupRequestView } from './pickup-views.js';
import { type MerchantCommand, OrderCommandRefusedError, OrderCommands } from './order-commands.js';
import type { OrderView } from './order-views.js';
import { OrdersService } from './orders.service.js';
import { captainTracks, orderStatuses } from './schema.js';

const boardOrder = z.object({
  id: z.uuid(),
  number: z.string().describe('Shown as #10423 (AP §4.8).'),
  status: z.enum(orderStatuses).describe('AP §8.1; the board column (RA §8.1–8.2).'),
  version: z
    .int()
    .describe(
      'Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).',
    ),
  placedAt: z.iso.datetime(),
  acceptAlertAt: z.iso
    .datetime()
    .nullable()
    .describe(
      'While placed from then: the card turns red and the prompt adds «تأخرتم في الرد — سيتصل بكم فريق العمليات» (RA §8.2–8.3).',
    ),
  autoCancelAt: z.iso
    .datetime()
    .nullable()
    .describe('«يُلغى تلقائياً خلال {د:ث}» counts down to it while placed (RA §8.3).'),
  acceptance: z
    .object({
      at: z.iso.datetime(),
      prepMin: z.int().describe('The prep time chosen (RA §8.5).'),
      prepDueAt: z.iso
        .datetime()
        .describe(
          'While accepted, the prep countdown runs to it; past it the card turns red and counts up, «متأخر {د} د» (RA §8.7).',
        ),
      deviceName: z
        .string()
        .nullable()
        .describe(
          '«قُبل الطلب من جهاز {اسم الجهاز}» (RA §4.7); null when not accepted on a named device of the restaurant.',
        ),
      byOperations: z
        .boolean()
        .describe(
          "Accepted by operations on the restaurant's behalf: the badge «قبلته العمليات», and every device chimes «قبلت العمليات الطلب #{رقم} نيابة عنكم — وقت التحضير {د} د» (RA §8.15, §16 #5).",
        ),
    })
    .nullable()
    .describe('Null until the order is accepted.'),
  readyAt: z.iso.datetime().nullable().describe('«الطلب جاهز» (RA §8.8).'),
  customer: z
    .object({
      firstName: z
        .string()
        .nullable()
        .describe('Null while the customer has not completed the account (CU §5.3).'),
      neighbourhood: z.string(),
    })
    .describe('Never the phone number, the last name or the full address (RA §8.4).'),
  note: z.string().nullable().describe("The customer's note."),
  lines: z.array(
    z.object({
      itemId: z.uuid().describe('«صنف غير متوفر» picks the items by it (RA §8.6).'),
      name: z.string(),
      quantity: z.int(),
      options: z.array(z.object({ name: z.string() })),
      note: z.string().nullable(),
      lineTotal: minor,
    }),
  ),
  currency: z.string().length(3),
  itemsValue: minor.describe(
    '«قيمة الأصناف — يدفعها لك الكابتن نقداً عند الاستلام» (RA §8.4); the delivery fee and the customer total are never shown (R11).',
  ),
  captainTrack: z
    .enum(captainTracks)
    .nullable()
    .describe(
      'The captain line (RA §8.1): searching or offered «بانتظار كابتن», assigned «الكابتن {الاسم} في الطريق»; null before the search starts.',
    ),
  captain: z
    .object({
      firstName: z.string(),
      vehicle: z.enum(['walking', 'bicycle', 'motorbike', 'car']),
    })
    .nullable()
    .describe('From assignment (RA §8.9); the photo and the ETA come with their slices.'),
  captainArrival: z
    .object({
      at: z.iso
        .datetime()
        .describe('«وصل الكابتن {الاسم} لاستلام الطلب #{رقم}»; the waiting timer counts from it.'),
      waitingAlertAt: z.iso
        .datetime()
        .describe(
          'Not picked up by then: every device chimes «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق» (RA §8.9).',
        ),
    })
    .nullable()
    .describe(
      'While the captain waits at the restaurant for an accepted or ready order (RA §8.9), else null.',
    ),
  itemReport: z
    .object({
      at: z.iso.datetime(),
      items: z.array(
        z.object({
          itemId: z.uuid(),
          name: z.string(),
          until: z.enum(['tomorrow', 'turned_back_on']),
        }),
      ),
      note: z
        .object({ code: z.string(), label: z.string() })
        .nullable()
        .describe("A reason of Content's item_unavailable_note list, its label as chosen."),
    })
    .nullable()
    .describe(
      'RA §8.12: the open item-unavailable report: the badge «صنف نفد — بانتظار العمليات», the line «العمليات تتواصل مع الزبون» and «تراجع — الصنف متوفر» (POST …/item-report/withdraw); pickup requests wait until it closes (RA §8.10). Null otherwise.',
    ),
  edits: z
    .array(
      z.object({
        at: z.iso.datetime(),
        addsItems: z
          .boolean()
          .describe(
            'Items added or a quantity raised: every device rings «تم تعديل الطلب #{رقم} — أُضيفت أصناف» until «اطلعت على التعديل», and pickup requests wait (RA §8.10, §16 #16); otherwise it chimes «تم تعديل الطلب #{رقم}» once and stays on the card (RA §16 #17).',
          ),
        changes: z
          .array(
            z.object({
              kind: z
                .enum(['added', 'removed', 'quantity'])
                .describe('A line whose options changed is removed and added again.'),
              name: z.string(),
              options: z.array(z.string()),
              quantity: z.int(),
              quantityBefore: z.int().optional().describe('quantity: the quantity before.'),
            }),
          )
          .describe('The prompt lists them (RA §8.13).'),
        itemsValue: minor.describe('The new items value after this edit.'),
        extraPrepMin: z
          .int()
          .nullable()
          .describe(
            'Items added to a ready order: back to «قيد التحضير» with this many minutes from the edit (RA §8.13); null otherwise.',
          ),
      }),
    )
    .describe(
      'RA §8.13: the edits by operations not yet acknowledged, oldest first; «اطلعت على التعديل» (POST …/acknowledge-edit) acknowledges them all. Empty after the pickup.',
    ),
  cancellation: z
    .object({
      at: z.iso.datetime(),
      reason: z.string().describe("The code of Content's ops_cancel list."),
      label: z.string().describe('{السبب} of «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}».'),
      byOperations: z.boolean().describe('Always true: only operations cancel after acceptance.'),
    })
    .nullable()
    .describe(
      'RA §8.14: operations cancelled the accepted order; every device rings with «أوقف التحضير — أُلغي الطلب #{رقم}: {السبب}» until «حسناً» on any of them (POST …/acknowledge-cancellation), then the board drops the order. Null otherwise, and once acknowledged.',
    ),
  pickup: z
    .object({
      request: z
        .object({
          id: z.uuid(),
          status: z.enum(['open', 'confirmed', 'rejected', 'voided']),
          outcome: z
            .enum([
              'restaurant',
              'automatic',
              'operations',
              'amount_incorrect',
              'incomplete',
              'cancelled',
            ])
            .nullable()
            .describe('automatic is «تأكيد تلقائي»; operations «أكّدت العمليات الاستلام».'),
          amount: z.object({ amount: minor, currency: z.string().length(3) }),
          lines: paymentLines.describe('«400 ₺» or «5 $ + 195 ₺».'),
          baseEquivalent: minor.describe('The lines in the base currency, by the order rates.'),
          confirmBy: z.iso.datetime().describe('«يُؤكَّد تلقائياً خلال {ث} ث» counts down to it.'),
          closedAt: z.iso.datetime().nullable(),
          closedByUserName: z
            .string()
            .nullable()
            .describe(
              'The other devices close the prompt with «أكّد {اسم المستخدم} الاستلام» or «أبلغ {اسم المستخدم} أن المبلغ غير صحيح» (RA §8.10).',
            ),
          closedByDeviceName: z.string().nullable(),
        })
        .nullable()
        .describe(
          'The latest request; while open every device rings with the pickup prompt (RA §8.10 item 3).',
        ),
      pickedUpAt: z.iso.datetime().nullable().describe('«تم الاستلام».'),
      readyNotPressed: z.boolean().describe('«لم يُضغط جاهز» (S8).'),
      disputeUntil: z.iso
        .datetime()
        .nullable()
        .describe(
          '«المبلغ غير صحيح» stays on the order until then after the pickup (RA §8.10 item 8); null once disputed or before the pickup.',
        ),
      disputedAt: z.iso.datetime().nullable(),
    })
    .describe('The pickup confirmation (RA §8.10).'),
});

class MerchantOrdersDto extends createZodDto(
  z.object({
    orders: z
      .array(boardOrder)
      .describe('Every order until it is delivered or ends, oldest first (RA §8.2).'),
    prepTime: z
      .object({
        options: z.array(z.int()).describe('The chips (merchant.prep_time_options).'),
        stepMin: z.int().describe('The «−» and «+» step.'),
        floorMin: z.int(),
        ceilingMin: z.int(),
        defaultMin: z
          .int()
          .describe(
            'Preselected: the default prep time plus the busy-mode minutes while busy mode is on, «قبول — {د} د».',
          ),
      })
      .describe("The accept prompt's prep-time chooser (RA §8.5)."),
  }),
) {}

class MerchantOrderDto extends createZodDto(z.object({ order: boardOrder })) {}

class MerchantRejectDto extends createZodDto(
  z.object({
    reason: z
      .string()
      .max(50)
      .describe(
        "A code of Content's merchant_rejection list: item_unavailable «صنف غير متوفر», restaurant_closed «المطعم مغلق», too_busy «ضغط طلبات» (R3); 400 unknown_reason otherwise.",
      ),
    items: z
      .array(
        z.object({
          itemId: z.uuid(),
          until: z
            .enum(['tomorrow', 'turned_back_on'])
            .describe('«حتى الغد» (the default) or «حتى أعيده» (RA §9.3).'),
        }),
      )
      .max(50)
      .describe(
        "item_unavailable: one or more of the order's items, switched off at once; empty for the other reasons.",
      ),
    busyExtraMin: z
      .int()
      .nullable()
      .describe(
        'too_busy only: «تفعيل وضع الضغط» with one of merchant.busy_extra_options_min, or null.',
      ),
    pauseMin: z
      .int()
      .nullable()
      .describe(
        'too_busy only: 30 for «إيقاف 30 د», or null; not with busyExtraMin (400 invalid_rejection otherwise).',
      ),
  }),
) {}

class MerchantOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class MerchantAcknowledgeEditDto extends createZodDto(
  z.object({
    through: z.iso
      .datetime()
      .describe(
        "The newest edit's `at` the prompt showed: the edits up to it are acknowledged, a newer one keeps ringing (RA §8.13).",
      ),
  }),
) {}

class MerchantPickupDisputeDto extends createZodDto(
  z.object({
    receivedLines: paymentLines.describe(
      "What the restaurant actually received, prefilled with the captain's lines.",
    ),
  }),
) {}

class MerchantItemReportDto extends createZodDto(
  z.object({
    items: z
      .array(
        z.object({
          itemId: z.uuid(),
          until: z
            .enum(['tomorrow', 'turned_back_on'])
            .describe('«حتى الغد» (the default) or «حتى أعيده» (RA §9.3).'),
        }),
      )
      .min(1)
      .max(50)
      .describe("One or more of the order's items, each once, switched off in the menu at once."),
    note: z
      .string()
      .max(50)
      .nullable()
      .describe(
        "Optional: a code of Content's item_unavailable_note list (GET /v1/merchant/content); 400 unknown_reason otherwise.",
      ),
  }),
) {}

class MerchantAcceptDto extends createZodDto(
  z.object({
    prepMin: z
      .int()
      .describe(
        'Whole minutes from merchant.prep_time_floor_min to merchant.prep_time_ceiling_min (RA §8.5); 400 invalid_prep_time otherwise.',
      ),
  }),
) {}

// RA §8.2–8.8, §18, §4.3: the board's orders, which the restaurant app
// fetches on opening and after every reconnect before it shows them, and the
// commands on them, for owners and cashiers alike. A terminated restaurant's
// owners keep only the money section (RA §5.5).
@MerchantController()
export class MerchantOrdersController {
  constructor(
    private readonly orders: OrdersService,
    private readonly commands: OrderCommands,
    private readonly merchants: MerchantsService,
    private readonly customers: CustomersService,
    private readonly captains: CaptainsService,
    private readonly pickups: PickupCommands,
    private readonly accounts: MerchantAccountsService,
    private readonly settings: SettingsService,
  ) {}

  @Get('orders')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: MerchantOrdersDto })
  async board(@CurrentAppSession() session: AppSession) {
    const restaurantId = await this.restaurantOf(session);
    const [orders, prepTime] = await Promise.all([
      this.orders.restaurantActiveOrders(restaurantId, new Date()),
      this.commands.prepTimeChooser(restaurantId, new Date()),
    ]);
    return { orders: await this.boardOrders(restaurantId, orders), prepTime };
  }

  // RA §8.5: «قبول — {د} د». 409 order_state_changed with the order as it is
  // now, accepted from another device or cancelled first (RA §4.7); 404
  // unknown_order; 400 invalid_prep_time; 422 idempotency_key_reused.
  @Post('orders/:orderId/accept')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async accept(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
    @Body() body: MerchantAcceptDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.commands.accept({ ...command, prepMin: body.prepMin }, new Date()),
    );
  }

  // RA §8.6: «رفض» with one of the three reasons and its steps. The items
  // are switched off, or the restaurant paused «حتى أعيد الفتح» (S2: only
  // while open or busy without an operations or auto pause), or busy mode or
  // «إيقاف 30 د» set, in the rejection's transaction. 409 order_state_changed
  // with the order as it is now; 404 unknown_order; 400 unknown_reason,
  // invalid_rejection; 422 idempotency_key_reused.
  @Post('orders/:orderId/reject')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async reject(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
    @Body() body: MerchantRejectDto,
    @Req() request: FastifyRequest,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.commands.reject(
        {
          ...command,
          ...(session.merchant ? { role: session.merchant.role } : {}),
          ipAddress: request.ip,
          code: body.reason,
          items: body.items,
          busyExtraMin: body.busyExtraMin,
          pauseMin: body.pauseMin,
        },
        new Date(),
      ),
    );
  }

  // RA §8.8: «الطلب جاهز», with no undo. 409 order_state_changed with the
  // order as it is now; 404 unknown_order; 422 idempotency_key_reused.
  @Post('orders/:orderId/ready')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async ready(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () => this.commands.ready(command, new Date()));
  }

  // RA §8.10 item 4 «تأكيد الاستلام»: the atomic pickup. 409
  // order_state_changed once another device answered, the request was
  // confirmed automatically or the order was cancelled.
  @Post('orders/:orderId/pickup/confirm')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async confirmPickup(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () => this.pickups.confirm(command, new Date()));
  }

  // RA §8.10 items 6 and 8 «المبلغ غير صحيح»: rejects an open request, or,
  // within order.pickup_dispute_window_min after the pickup, records the
  // dispute. 409 pickup_already_disputed, currency_not_accepted,
  // order_state_changed; 400 invalid_lines.
  @Post('orders/:orderId/pickup/dispute')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async disputePickup(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
    @Body() body: MerchantPickupDisputeDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.pickups.dispute(
        { ...command, receivedLines: linesOfBody(body.receivedLines) },
        new Date(),
      ),
    );
  }

  // RA §8.10 item 7 «الطلب غير مكتمل»: rejects the request without amounts.
  @Post('orders/:orderId/pickup/incomplete')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async pickupIncomplete(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () => this.pickups.incomplete(command, new Date()));
  }

  // RA §8.14, §18 «حسناً» (slice 2.8b): after operations cancelled an
  // accepted order; every device's board drops it and stops ringing
  // (order.cancellation_acknowledged). Already acknowledged answers the
  // order quietly; 409 order_state_changed for an order that does not ring;
  // 404 unknown_order; 422 idempotency_key_reused.
  @Post('orders/:orderId/acknowledge-cancellation')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async acknowledgeCancellation(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.commands.acknowledgeCancellation(command, new Date()),
    );
  }

  // RA §8.13 «اطلعت على التعديل» (slice 2.10a): every edit by operations not
  // yet acknowledged, on any device; the ring stops everywhere and the
  // captain's pickup request is free (order.edit_acknowledged). 409
  // order_state_changed with nothing to acknowledge; 404 unknown_order; 422
  // idempotency_key_reused.
  @Post('orders/:orderId/acknowledge-edit')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async acknowledgeEdit(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
    @Body() body: MerchantAcknowledgeEditDto,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.commands.acknowledgeEdits({ ...command, through: new Date(body.through) }, new Date()),
    );
  }

  // RA §8.12 «صنف غير متوفر — اتصلوا بالزبون»: on an accepted or ready
  // order with no pickup request open, the items switched off at once,
  // operations alerted and the customer told FOX DROP will call; the
  // restaurant keeps preparing the rest. 400 invalid_item_report; 409
  // order_state_changed (a request or a report already open, picked up,
  // cancelled); 404 unknown_order; 422 idempotency_key_reused.
  @Post('orders/:orderId/item-report')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async reportItems(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
    @Body() body: MerchantItemReportDto,
    @Req() request: FastifyRequest,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.commands.reportItems(
        {
          ...command,
          ...(session.merchant ? { role: session.merchant.role } : {}),
          ipAddress: request.ip,
          items: body.items,
          note: body.note,
        },
        new Date(),
      ),
    );
  }

  // RA §8.12 «تراجع — الصنف متوفر»: before operations act, the open report
  // withdrawn and its items switched on again. 409 order_state_changed
  // without an open report; 404 unknown_order; 422 idempotency_key_reused.
  @Post('orders/:orderId/item-report/withdraw')
  @AppSignedIn()
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: MerchantOrderDto })
  async withdrawItemReport(
    @CurrentAppSession() session: AppSession,
    @IdempotencyKey() idempotencyKey: string,
    @Param() params: MerchantOrderParamsDto,
    @Req() request: FastifyRequest,
  ) {
    const command = await this.command(session, idempotencyKey, params.orderId);
    return this.answer(command.restaurantId, () =>
      this.commands.withdrawItemReport(
        {
          ...command,
          ...(session.merchant ? { role: session.merchant.role } : {}),
          ipAddress: request.ip,
        },
        new Date(),
      ),
    );
  }

  private async command(
    session: AppSession,
    idempotencyKey: string,
    orderId: string,
  ): Promise<MerchantCommand> {
    return {
      restaurantId: await this.restaurantOf(session),
      accountId: session.accountId,
      deviceId: session.deviceId,
      idempotencyKey,
      orderId,
    };
  }

  private async answer(restaurantId: string, run: () => Promise<OrderView>) {
    try {
      const [order] = await this.boardOrders(restaurantId, [await run()]);
      return { order: order! };
    } catch (error) {
      if (!(error instanceof OrderCommandRefusedError)) throw error;
      const { refusal } = error;
      if (refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
      }
      if (
        refusal === 'invalid_prep_time' ||
        refusal === 'invalid_lines' ||
        refusal === 'unknown_reason' ||
        refusal === 'invalid_rejection' ||
        refusal === 'invalid_item_report'
      ) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: refusal,
          message: error.message,
        });
      }
      if (refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: refusal,
        });
      }
      if (error.order === null) {
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: refusal });
      }
      const [order] = await this.boardOrders(restaurantId, [error.order]);
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: refusal, order });
    }
  }

  // The signed-in user's restaurant, refused once terminated (RA §5.5).
  private async restaurantOf(session: AppSession): Promise<string> {
    if (!session.merchant) throw new Error('a merchant route without a restaurant user');
    const { restaurantId } = session.merchant;
    if ((await this.merchants.accountStatus(restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    return restaurantId;
  }

  // What the restaurant sees of its orders (RA §8.4): never the delivery fee,
  // the total, the address, a phone, the promised time or operations' alert
  // moments.
  private async boardOrders(restaurantId: string, orders: OrderView[]) {
    const captainIds = [...new Set(orders.flatMap((order) => order.captainId ?? []))];
    const now = new Date();
    const captains = new Map(
      (await Promise.all(captainIds.map((id) => this.captains.captain(id, now)))).flatMap(
        (captain) => (captain ? [[captain.id, captain] as const] : []),
      ),
    );
    const [requests, disputes, users] = await Promise.all([
      this.pickups.requests(orders),
      this.pickups.disputes(orders),
      this.accounts.accounts(restaurantId),
    ]);
    const userNames = new Map(users.map((user) => [user.id, user.name]));
    const latest = new Map(
      orders.flatMap((order) => {
        const request = currentRequests(requests.get(order.id), order)[0];
        return request ? [[order.id, request] as const] : [];
      }),
    );
    const [firstNames, deviceNames] = await Promise.all([
      this.customers.firstNames([...new Set(orders.map((order) => order.customerAccountId))]),
      this.merchants.deviceNames(restaurantId, [
        ...new Set([
          ...orders.flatMap((order) => order.acceptance?.device ?? []),
          ...[...latest.values()].flatMap((request) => request.closedBy?.device ?? []),
        ]),
      ]),
    ]);
    const windowMin =
      orders.length === 0
        ? 0
        : await this.settings.get('order.pickup_dispute_window_min', {
            cityId: orders[0]!.cityId,
          });
    return orders.map((order) => ({
      id: order.id,
      number: order.number.toString(),
      status: order.status,
      version: order.version,
      placedAt: order.placedAt.toISOString(),
      acceptAlertAt: order.acceptAlertAt?.toISOString() ?? null,
      autoCancelAt: order.autoCancelAt?.toISOString() ?? null,
      acceptance: order.acceptance && {
        at: order.acceptance.at.toISOString(),
        prepMin: order.acceptance.prepMin,
        prepDueAt: new Date(
          order.acceptance.at.getTime() + order.acceptance.prepMin * 60_000,
        ).toISOString(),
        deviceName:
          order.acceptance.device === null
            ? null
            : (deviceNames.get(order.acceptance.device) ?? null),
        byOperations: order.acceptance.byOperations,
      },
      readyAt: order.readyAt?.toISOString() ?? null,
      customer: {
        firstName: firstNames.get(order.customerAccountId) ?? null,
        neighbourhood: order.address.neighbourhood,
      },
      note: order.note,
      lines: order.lines.map((line) => ({
        itemId: line.itemId,
        name: line.name,
        quantity: line.quantity,
        options: line.options.map((option) => ({ name: option.name })),
        note: line.note,
        lineTotal: line.lineTotal.toString(),
      })),
      currency: order.currency,
      itemsValue: order.money.itemsValue.toString(),
      captainTrack: order.captainTrack,
      captain: captainLine(order.captainId === null ? undefined : captains.get(order.captainId)),
      // RA §8.9: only while the captain waits at the restaurant for an
      // accepted or ready order, so the app never chimes after pickup or a
      // cancellation.
      captainArrival:
        order.captainArrival &&
        (order.status === 'accepted' || order.status === 'ready') &&
        (order.captainTrack === 'at_merchant' || order.captainTrack === 'pickup_pending')
          ? {
              at: order.captainArrival.at.toISOString(),
              waitingAlertAt: order.captainArrival.waitingAlertAt.toISOString(),
            }
          : null,
      itemReport: order.itemReport && {
        at: order.itemReport.at.toISOString(),
        items: order.itemReport.items,
        note: order.itemReport.note,
      },
      edits: order.pendingEdits.map((edit) => ({
        at: edit.at.toISOString(),
        addsItems: edit.addsItems,
        changes: edit.changes,
        itemsValue: edit.itemsValueAfter.toString(),
        extraPrepMin: edit.extraPrepMin,
      })),
      // RA §8.14: only while it rings, until «حسناً» on any device.
      cancellation:
        order.cancellation &&
        order.cancellation.label !== null &&
        order.cancellation.acknowledgedAt === null &&
        order.acceptance
          ? {
              at: order.cancellation.at.toISOString(),
              reason: order.cancellation.reason,
              label: order.cancellation.label,
              byOperations: order.cancellation.byOperations,
            }
          : null,
      pickup: pickupBody(
        order,
        latest.get(order.id) ?? null,
        disputes.get(order.id)?.at ?? null,
        windowMin,
        deviceNames,
        userNames,
      ),
    }));
  }
}

// RA §8.9: the captain's first name and vehicle, never the phone number.
function captainLine(
  captain: { name: string; vehicle: 'walking' | 'bicycle' | 'motorbike' | 'car' } | undefined,
) {
  return captain ? { firstName: captain.name.split(' ')[0]!, vehicle: captain.vehicle } : null;
}

// RA §8.10: the latest request with its lines and their base equivalent, the
// pickup and the dispute window after it.
function pickupBody(
  order: OrderView,
  request: PickupRequestView | null,
  disputedAt: Date | null,
  windowMin: number,
  deviceNames: Map<string, string>,
  userNames: Map<string, string | null>,
) {
  return {
    request: request && {
      id: request.id,
      status: request.status,
      outcome: request.outcome,
      amount: { amount: request.amount.amount.toString(), currency: request.amount.currency },
      lines: linesBody(request.bookedLines ?? request.lines),
      baseEquivalent: request.baseEquivalent.toString(),
      confirmBy: request.confirmBy.toISOString(),
      closedAt: request.closedAt?.toISOString() ?? null,
      closedByUserName:
        request.closedBy?.type === 'restaurant' && request.closedBy.id !== null
          ? (userNames.get(request.closedBy.id) ?? null)
          : null,
      closedByDeviceName:
        request.closedBy?.device == null
          ? null
          : (deviceNames.get(request.closedBy.device) ?? null),
    },
    pickedUpAt: order.pickup?.at.toISOString() ?? null,
    readyNotPressed: order.pickup?.readyByPickup ?? false,
    disputeUntil:
      order.pickup && disputedAt === null
        ? new Date(order.pickup.at.getTime() + windowMin * 60_000).toISOString()
        : null,
    disputedAt: disputedAt?.toISOString() ?? null,
  };
}
