import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Query,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { CustomersService } from '../customers/index.js';
import type { AdminSession } from '../identity/index.js';
import { CaptainOrderRefusedError, CaptainOrders } from './captain-orders.js';
import {
  doorCollection,
  doorPayment,
  linesBody,
  linesOfBody,
  paymentLines,
} from './captain-orders.controller.js';
import { ORDER_ALERT_CODES } from './order-alerts.js';
import type { EditChange } from './order-edits.js';
import { AFTER_PICKUP_PARTIES } from './order-edits.js';
import { AFTER_PICKUP, EDITABLE } from './order-views.js';
import {
  CANCELLABLE,
  TIME_CHANGEABLE,
  type CancellationPreview,
  type OutcomeChangePreview,
  type OutcomePreview,
  type EditPreview,
  OrderCommandRefusedError,
  OrderCommands,
  type Rejection,
} from './order-commands.js';
import { PickupCommands } from './pickup-commands.js';
import { REASSIGNABLE } from './reassignment.js';
import { ResendNotification, ResendRefusedError } from './resend-notification.js';
import { minor } from './customer-quote.controller.js';
import { type OperationsOrder, OperationsViews } from './operations-views.js';
import {
  captainTracks,
  cashAnswers,
  orderOutcomes,
  orderStatuses,
  responsibleParties,
} from './schema.js';

const money = z.object({ amount: minor, currency: z.string().length(3) });
const alerts = z
  .array(z.enum(ORDER_ALERT_CODES))
  .describe(
    'AP §9.1.3, open now by their conditions (GET /v1/admin/alerts holds the records, with who took each); «تسليم بعيد عن العنوان» only while the order is active.',
  );

const card = z.object({
  id: z.uuid(),
  number: z.string().describe('Shown as #10423 (AP §4.8).'),
  status: z.enum(orderStatuses).describe('The board column (AP §9.2.1).'),
  version: z.int().describe('Increases with every change (architecture §5.3).'),
  placedAt: z.iso.datetime(),
  restaurant: z.object({ id: z.uuid(), name: z.string() }),
  neighbourhood: z.string(),
  statusSince: z.iso.datetime().describe('The time in the current state counts from it.'),
  limitAt: z.iso
    .datetime()
    .nullable()
    .describe(
      "The column's limit (AP §9.2.1): green before 80% of it, amber from 80%, red past it; null where it is not built yet.",
    ),
  captainTrack: z
    .enum(captainTracks)
    .nullable()
    .describe('AP §8.2; null before the search starts and before any offer.'),
  captain: z
    .object({ id: z.uuid(), name: z.string(), vehicle: z.string() })
    .nullable()
    .describe('Null shows a red «بلا كابتن».'),
  total: money.describe('The customer total in the base currency.'),
  badges: z.object({
    needsAssignment: z.boolean().describe('«بحاجة لتعيين» (AP §8.3).'),
    note: z.boolean().describe('«ملاحظة».'),
    newCustomer: z.boolean().describe('«زبون جديد»: no delivered order yet.'),
    pickupPending: z.boolean().describe('«بانتظار تأكيد الاستلام» (AP §9.2.1).'),
    awaitingCollection: z
      .boolean()
      .describe(
        '«بانتظار تسجيل التحصيل»: an outcome with an amount to collect waits for the payment (CA §9.10, K9).',
      ),
    itemReport: z.boolean().describe('«صنف نفد»: an open item-unavailable report (RA §8.12).'),
  }),
  moments: z
    .object({
      acceptAlertAt: z.iso.datetime().nullable(),
      prepLateAlertAt: z.iso.datetime().nullable(),
      searchStartedAt: z.iso.datetime().nullable(),
      searchAlertAt: z.iso.datetime().nullable(),
      noCaptainAlertAt: z.iso.datetime().nullable(),
      captainArrivedAt: z.iso.datetime().nullable().describe('«وصل الكابتن».'),
      captainWaitingAlertAt: z.iso.datetime().nullable(),
    })
    .describe("The alerts' moments, so the panel raises each when it passes."),
  alerts,
});

class AdminBoardQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminBoardDto extends createZodDto(
  z.object({ orders: z.array(card).describe('Every live order, oldest first.') }),
) {}

class AdminShortfallsDto extends createZodDto(
  z.object({
    shortfalls: z
      .array(
        z.object({
          orderId: z.uuid(),
          number: z.string(),
          captainId: z.uuid(),
          amountDue: money,
          netReceived: money,
          shortfall: money,
          reason: z.string().describe("The captain's reason (K16), its code in Content."),
          label: z.string().describe('Its label as chosen.'),
          note: z.string().nullable(),
          recordedAt: z.iso.datetime(),
        }),
      )
      .describe('«نقص في التحصيل» (AP §8.6), newest first; all open until resolution is built.'),
  }),
) {}

class AdminOrderParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class AdminResendNotificationDto extends createZodDto(
  z.object({
    to: z
      .enum(['customer', 'merchant', 'captain'])
      .describe("The customer, the restaurant's devices or the assigned captain."),
  }),
) {}

class AdminNotificationResentDto extends createZodDto(
  z.object({ body: z.string().describe('The text pushed again.') }),
) {}

class AdminRecordArrivalDto extends createZodDto(
  z.object({ reason: z.string().trim().min(1).max(500).describe('Required (AP §9.3.2).') }),
) {}

class AdminConfirmPickupDto extends createZodDto(
  z.object({
    lines: paymentLines.describe("The agreed lines, prefilled from the captain's last request."),
    reason: z.string().trim().min(1).max(500).describe('Required (AP §9.3.2).'),
  }),
) {}

class AdminRecordDeliveryDto extends createZodDto(
  z.object({
    ...doorPayment,
    reason: z.string().trim().min(1).max(500).describe('Required (AP §9.3.2).'),
  }),
) {}

class AdminAcceptDto extends createZodDto(
  z.object({
    prepMin: z
      .int()
      .describe(
        'Whole minutes from merchant.prep_time_floor_min to merchant.prep_time_ceiling_min (RA §8.5); 400 invalid_prep_time otherwise.',
      ),
    reason: z.string().trim().min(1).max(500).describe('Required (AP §9.3.2).'),
  }),
) {}

class AdminCloseItemReportDto extends createZodDto(
  z.object({ reason: z.string().trim().min(1).max(500).describe('Required (AP §9.3.2).') }),
) {}

class AdminChangeTimeDto extends createZodDto(
  z.object({
    addMin: z
      .int()
      .describe(
        'Whole minutes added, from 1 to order.eta_change_max_min (owner decision 2026-11-10); 400 invalid_time_change otherwise.',
      ),
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .nullable()
      .describe("Operations' optional note (AP §9.3.2)."),
  }),
) {}

class AdminRejectDto extends createZodDto(
  z.object({
    rejection: z
      .string()
      .max(50)
      .describe(
        'A code of the restaurant rejection list (AP Appendix B): item_unavailable «صنف غير متوفر» (marks the items unavailable), restaurant_closed «المطعم مغلق» (also pauses the restaurant until it reopens), too_busy «ضغط طلبات»; 400 unknown_reason otherwise.',
      ),
    items: z
      .array(
        z.object({
          itemId: z.uuid(),
          until: z.enum(['tomorrow', 'turned_back_on']).describe('«حتى الغد» or «حتى أعيده».'),
        }),
      )
      .max(50)
      .describe("item_unavailable: one or more of the order's items; empty for the others."),
    busyExtraMin: z
      .int()
      .nullable()
      .describe('too_busy only: busy mode with one of merchant.busy_extra_options_min, or null.'),
    pauseMin: z
      .int()
      .nullable()
      .describe(
        'too_busy only: 30 for a 30-minute pause, or null; not with busyExtraMin (400 invalid_rejection otherwise).',
      ),
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Required (AP §9.3.2): the internal note, never shown to the apps.'),
  }),
) {}

// AP §9.3.2 «إلغاء الطلب» (slice 2.8b): operations' choices.
const cancellationChoices = {
  responsible: z
    .enum(responsibleParties)
    .describe('The responsible party (docs/domain/09): «المطعم», «الكابتن», «الزبون», «المنصة».'),
  foodPrepared: z
    .boolean()
    .describe(
      '«تم تحضير الطعام؟». From accepted or ready with the restaurant not responsible, the merchant net is credited on platform.operating_cost; true on a placed order is 400 invalid_cancellation.',
    ),
  compensateCaptain: z
    .boolean()
    .describe(
      "«تعويض الكابتن»: the pay table's base pay for the captain's vehicle; only once the assigned captain reached the restaurant (409 compensation_not_allowed; 409 captain_pay_unset without a rate).",
    ),
  cash: z
    .enum(cashAnswers)
    .nullable()
    .describe(
      "«هل أعاد المطعم المبلغ للكابتن؟», required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».",
    ),
};

// AP §9.3.3 «تعديل الطلب» (slice 2.10a): the order's lines after the edit.
const editRequest = {
  keep: z
    .array(
      z.object({
        position: z.int().describe("A current line's position (the detail's lines)."),
        quantity: z.int().min(1).max(20),
      }),
    )
    .max(50)
    .describe(
      'The current lines kept, each with its quantity; a line left out is removed. A raised quantity keeps the unit price and counts as items added.',
    ),
  add: z
    .array(
      z.object({
        itemId: z.uuid(),
        optionIds: z.array(z.uuid()).max(30),
        quantity: z.int().min(1).max(20),
      }),
    )
    .max(20)
    .describe(
      "Lines added from the restaurant's current menu at current prices, available only (400 invalid_edit). A line whose options change is left out of keep and added again.",
    ),
  deliveryFee: z
    .string()
    .regex(/^\d{1,15}$/)
    .nullable()
    .describe(
      'A new delivery fee in minor units, or null to keep it (the threshold is not checked again).',
    ),
  extraPrepMin: z
    .int()
    .nullable()
    .describe(
      'Required exactly when items are added to a ready order: it goes back to accepted with this many minutes from now, and the promised time moves by them (400 invalid_edit otherwise).',
    ),
  responsible: z
    .enum(AFTER_PICKUP_PARTIES)
    .nullable()
    .default(null)
    .describe(
      'After the pickup (picked_up, arrived) only, and required then (400 invalid_edit otherwise; the preview answers without it): who bears the removed items and the lower fee (AP §9.3.3, docs/domain/09), «المطعم», «الكابتن» or «المنصة»; never the customer. After the pickup an edit only removes lines or lowers quantities and lowers the fee.',
    ),
};

class AdminEditDto extends createZodDto(
  z.object({
    ...editRequest,
    version: z
      .int()
      .describe(
        "The order's version the dialog showed; another is 409 order_state_changed, so the edit is the one previewed.",
      ),
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Required (AP §9.3.2): the internal note, never shown to the apps.'),
  }),
) {}

class AdminEditPreviewDto extends createZodDto(z.object(editRequest)) {}

const editChange = z.object({
  kind: z.enum(['added', 'removed', 'quantity']),
  name: z.string(),
  options: z.array(z.string()),
  quantity: z.int(),
  quantityBefore: z.int().optional().describe('quantity: the quantity before.'),
});

const editSide = z.object({
  itemsValue: minor.describe('Also the pickup payment (D26).'),
  deliveryFee: minor,
  discount: minor,
  rounding: z.string().regex(/^-?\d+$/),
  total: minor,
  commission: minor,
  merchantNet: minor,
});

class AdminEditPreviewAnswerDto extends createZodDto(
  z.object({
    currency: z.string().length(3),
    before: editSide,
    after: editSide,
    changes: z.array(editChange),
    addsItems: z
      .boolean()
      .describe('The restaurant must acknowledge it before the pickup (RA §8.13).'),
    backToPreparing: z.boolean().describe('A ready order goes back to «قيد التحضير».'),
    promisedAt: z.iso.datetime().nullable().describe('The new promised time when it moves.'),
    afterPickup: z
      .boolean()
      .describe('The order was picked up: the edit needs a responsible party (AP §9.3.3).'),
    entries: z
      .array(
        z.object({
          type: z.string().describe('The journal type, such as merchant.debit.'),
          reason: z
            .string()
            .nullable()
            .describe(
              "The journal's reason, its line on the party's account (RA §12.5): «أصناف حُذفت بعد الاستلام», «خُفّضت أجرة التوصيل بعد الاستلام», «إلغاء عمولة».",
            ),
          account: z.string().describe('The account purpose, such as merchant.account.'),
          party: z.object({
            kind: z.enum(['merchant', 'captain', 'platform']),
            id: z.uuid().nullable(),
            name: z.string().nullable(),
          }),
          amount: money.describe("From the platform's side: + a debit, − a credit."),
        }),
      )
      .describe(
        'After the pickup, every entry the edit would post for the responsible party (docs/domain/09); empty before the pickup or until the party is chosen.',
      ),
  }),
) {}

class AdminCancelDto extends createZodDto(
  z.object({
    cancellation: z
      .string()
      .max(50)
      .describe(
        "A code of Content's ops_cancel list (AP Appendix B); 400 unknown_reason otherwise.",
      ),
    ...cancellationChoices,
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Required (AP §9.3.2): the internal note, never shown to the apps.'),
  }),
) {}

class AdminCancelPreviewDto extends createZodDto(
  z.object({
    cancellation: z
      .string()
      .max(50)
      .nullable()
      .optional()
      .describe('Checked when given (400 unknown_reason).'),
    ...cancellationChoices,
  }),
) {}

class AdminCancelPreviewAnswerDto extends createZodDto(
  z.object({
    entries: z
      .array(
        z.object({
          type: z.string().describe('The journal type, such as merchant.credit.'),
          account: z.string().describe('The account purpose, such as merchant.account.'),
          party: z.object({
            kind: z.enum(['merchant', 'captain', 'platform']),
            id: z.uuid().nullable(),
            name: z.string().nullable(),
          }),
          amount: money.describe("From the platform's side: + a debit, − a credit."),
        }),
      )
      .describe('Every entry the cancellation would post (docs/domain/09).'),
    cashAsked: z.boolean().describe('The captain reached the restaurant: ask the cash question.'),
    compensationAllowed: z.boolean().describe('«تعويض الكابتن» may be chosen.'),
    cashLines: z
      .array(money)
      .nullable()
      .describe(
        "While asked: what the captain paid (the last pickup request's lines, or the items value).",
      ),
    strike: z
      .boolean()
      .describe(
        'The customer gets a late-cancellation strike (docs/domain/08): from accepted or ready with the customer responsible.',
      ),
  }),
) {}

// AP §9.3.2 «سحب وإعادة تعيين» (slice 2.12a): «هل أعاد المطعم المبلغ للكابتن؟».
const reassignmentCash = z
  .enum(cashAnswers)
  .nullable()
  .describe(
    "Required exactly when the captain reached the restaurant (409 cash_answer_required, cash_answer_not_allowed): returned «نعم», not_returned «لا» (the payment on the captain's custody and a merchant.debit), not_paid «لم يدفع الكابتن بعد».",
  );

class AdminReassignDto extends createZodDto(
  z.object({
    reassignment: z
      .string()
      .max(50)
      .describe(
        "A code of Content's reassignment list (AP Appendix B); 400 unknown_reason otherwise.",
      ),
    captainFault: z
      .boolean()
      .describe(
        "«بخطأ من الكابتن» (counts as a captain cancellation, CA §11.2; no charge in V1) or «دون خطأ»; the dialog prefills the reason's default.",
      ),
    cash: reassignmentCash,
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Required (AP §9.3.2): the internal note, never shown to the apps.'),
  }),
) {}

class AdminReassignPreviewDto extends createZodDto(z.object({ cash: reassignmentCash })) {}

class AdminReassignPreviewAnswerDto extends createZodDto(
  z.object({
    entries: z
      .array(
        z.object({
          type: z.string().describe('The journal type, such as custody.pay_merchant.'),
          account: z.string().describe('The account purpose, such as captain.custody.'),
          party: z.object({
            kind: z.enum(['merchant', 'captain', 'platform']),
            id: z.uuid().nullable(),
            name: z.string().nullable(),
          }),
          amount: money.describe("From the platform's side: + a debit, − a credit."),
        }),
      )
      .describe('Every entry the reassignment would post (docs/domain/09): the kept payment only.'),
    cashAsked: z.boolean().describe('The captain reached the restaurant: ask the cash question.'),
    cashLines: z
      .array(money)
      .nullable()
      .describe(
        "While asked: what the captain paid (the last pickup request's lines, or the items value).",
      ),
  }),
) {}

const outcomeChoices = {
  outcome: z
    .enum(['free', 'fake', 'damaged', 'wrong_refused', 'failed_other'])
    .describe('AP §8.9; fake needs the customer responsible, and only fake takes the customer.'),
  responsible: z.enum(['restaurant', 'captain', 'customer', 'platform']),
  delivered: z
    .boolean()
    .describe('Free is delivered, fake, wrong_refused and failed_other failed; damaged either.'),
  food: z
    .enum(['kept_by_captain', 'returned_to_restaurant', 'destroyed'])
    .nullable()
    .describe(
      "A failed order's food (CA §9.12), null when delivered; returned_to_restaurant only with the restaurant responsible.",
    ),
  amountToCollect: minor
    .default('0')
    .describe(
      'What the customer still pays, in the base currency (K9): above 0 only on a delivered outcome and below the order total (owner decisions 2026-11-10), else 400 invalid_outcome. Above 0 the order waits «بانتظار تسجيل التحصيل» and the outcome is posted from the payment recorded.',
    ),
};

class AdminSetOutcomeDto extends createZodDto(
  z.object({
    ...outcomeChoices,
    version: z
      .int()
      .describe(
        "The order's version the dialog previewed (AP §8.9 «Preview»); any other is 409 order_state_changed.",
      ),
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Required (AP §9.3.2): the internal note, never shown to the apps.'),
  }),
) {}

class AdminOutcomePreviewDto extends createZodDto(z.object(outcomeChoices)) {}

// AP §8.9 «تغيير النتيجة» (slice 2.11c): the same choices without an amount
// to collect, which stays as collected.
const outcomeChangeChoices = {
  outcome: outcomeChoices.outcome,
  responsible: outcomeChoices.responsible,
  delivered: outcomeChoices.delivered,
  food: outcomeChoices.food,
};

class AdminChangeOutcomeDto extends createZodDto(
  z.object({
    ...outcomeChangeChoices,
    version: z
      .int()
      .describe(
        "The order's version the dialog previewed (AP §8.9 «Preview»); any other is 409 order_state_changed.",
      ),
    reason: z
      .string()
      .trim()
      .min(1)
      .max(500)
      .describe('Required (AP §8.9): why the outcome changes, never shown to the apps.'),
  }),
) {}

class AdminOutcomeChangePreviewDto extends createZodDto(z.object(outcomeChangeChoices)) {}

const previewEntry = z.object({
  type: z.string().describe('The journal type, such as dues.charge.'),
  reason: z
    .string()
    .nullable()
    .describe("The journal's reason, its line on the party's account (RA §12.5)."),
  account: z.string().describe('The account purpose, such as customer.dues.'),
  party: z.object({
    kind: z.enum(['merchant', 'captain', 'customer', 'platform']),
    id: z.uuid().nullable(),
    name: z.string().nullable(),
  }),
  amount: money.describe("From the platform's side: + a debit, − a credit."),
});

const outcomePreviewAnswer = z.object({
  status: z.enum(['delivered', 'failed']),
  provisional: z
    .boolean()
    .describe(
      'With an amount to collect: the entries are posted from the payment recorded (AP §9.3.2), the custody line as the collection books it.',
    ),
  loss: money.describe('docs/domain/09 rule 3: what the responsible party bears for the food.'),
  dues: money.nullable().describe("The customer's dues (AP §8.8), with the customer responsible."),
  captainPay: money.describe("The captain's pay, 0 when the captain is responsible."),
  entries: z
    .array(previewEntry)
    .describe('Every entry the outcome would post (AP §8.9 «Preview»).'),
});

class AdminOutcomePreviewAnswerDto extends createZodDto(outcomePreviewAnswer) {}

class AdminOutcomeChangePreviewAnswerDto extends createZodDto(
  outcomePreviewAnswer.extend({
    reversed: z
      .array(previewEntry)
      .describe(
        "Every entry of the outcome in force reversed (AP §8.9 «Changing an outcome»), before the new outcome's entries; each carries the reversed journal's own reason, which names it, while the reversal is posted with the reason «تغيير النتيجة».",
      ),
  }),
) {}

class AdminOrderCardDto extends createZodDto(z.object({ order: card })) {}

class AdminOrderDto extends createZodDto(
  z.object({
    order: card.extend({
      promisedAt: z.iso.datetime().nullable(),
      acceptance: z
        .object({ at: z.iso.datetime(), prepMin: z.int(), prepDueAt: z.iso.datetime() })
        .nullable(),
      readyAt: z.iso.datetime().nullable(),
      cancellation: z
        .object({
          at: z.iso.datetime(),
          reason: z.string().describe('The stored code (merchant_auto_cancel for the timer).'),
          label: z
            .string()
            .nullable()
            .describe(
              "The reason's label: operations' as chosen (ops_cancel), the customer's from Content (customer_cancel); null for the automatic cancellation.",
            ),
          note: z
            .string()
            .nullable()
            .describe("The customer's «سبب آخر» text, or operations' internal note."),
          customerText: z
            .string()
            .nullable()
            .describe('What the customer sees (CU Appendix C); null for their own cancellation.'),
          by: z.object({ type: z.string(), id: z.uuid().nullable() }).describe('Who cancelled.'),
          responsible: z
            .enum(responsibleParties)
            .nullable()
            .describe("Operations' cancellation only (docs/domain/09)."),
          foodPrepared: z.boolean().describe('«تم تحضير الطعام؟».'),
          cash: z
            .enum(cashAnswers)
            .nullable()
            .describe(
              '«هل أعاد المطعم المبلغ للكابتن؟», when the captain had reached the restaurant.',
            ),
          merchantCredit: money.nullable().describe('The food credited to the restaurant.'),
          captainCompensation: money.nullable().describe('«تعويض الكابتن».'),
          acknowledgedAt: z.iso.datetime().nullable().describe("A restaurant device's «حسناً»."),
          captainSeenAt: z.iso.datetime().nullable().describe("The captain's «حسناً»."),
        })
        .nullable()
        .describe('AP §9.3.1 «cancellation (reason and party)».'),
      cancelChoices: z
        .object({
          reasons: z
            .array(z.object({ code: z.string(), label: z.string() }))
            .describe("Content's active ops_cancel reasons, in order (AP Appendix B)."),
        })
        .nullable()
        .describe('While placed, accepted or ready: the choices of «إلغاء الطلب» (AP §9.3.2).'),
      reassignChoices: z
        .object({
          reasons: z
            .array(
              z.object({
                code: z.string(),
                label: z.string(),
                captainFault: z.boolean().describe('The default fault the dialog prefills.'),
              }),
            )
            .describe("Content's active reassignment reasons, in order (AP Appendix B)."),
        })
        .nullable()
        .describe(
          'While accepted or ready with a captain: the choices of «سحب وإعادة تعيين» (AP §9.3.2); refused with 409 pickup_request_open while a request is open.',
        ),
      handover: z
        .object({
          allowed: z
            .boolean()
            .describe(
              '«تسليم لكابتن آخر» is offered: picked up or arrived with a captain, no handover open, no outcome waiting.',
            ),
          handovers: z
            .array(
              z.object({
                openedAt: z.iso.datetime(),
                fromCaptainId: z.uuid(),
                fromCaptainName: z.string().nullable(),
                toCaptainId: z.uuid(),
                toCaptainName: z.string().nullable(),
                offered: z.boolean().describe('Sent as an offer «استلام من كابتن», else assigned.'),
                assignedAt: z.iso
                  .datetime()
                  .nullable()
                  .describe('The second captain has it (accepted or assigned).'),
                receivedAt: z.iso
                  .datetime()
                  .nullable()
                  .describe('«استلمت الطلب من الكابتن {الاسم}».'),
                closedAt: z.iso.datetime().nullable(),
                closeReason: z
                  .enum(['declined', 'expired', 'withdrawn', 'ended', 'replaced'])
                  .nullable()
                  .describe(
                    'Why it closed without the receipt: the offer declined, expired or withdrawn, or the order ended first.',
                  ),
                note: z.string().describe("Operations' internal note."),
                adminId: z.uuid(),
              }),
            )
            .describe('Every handover of the order, oldest first.'),
        })
        .describe('AP §9.3.1, §9.3.2 «تسليم لكابتن آخر» (slice 2.12b).'),
      reassignments: z
        .array(
          z.object({
            at: z.iso.datetime(),
            captainId: z.uuid().describe('The captain the order was taken from.'),
            captainName: z.string().nullable(),
            reason: z.string().describe("The reassignment list's code."),
            label: z.string().describe('The label as chosen.'),
            captainFault: z.boolean().describe('«بخطأ من الكابتن».'),
            cash: z.enum(cashAnswers).nullable(),
            note: z.string().describe("Operations' internal note."),
            adminId: z.uuid(),
            captainSeenAt: z.iso.datetime().nullable().describe("The captain's «حسناً»."),
          }),
        )
        .describe('AP §9.3.1: every «سحب وإعادة تعيين» of the order, oldest first.'),
      outcome: z
        .object({
          at: z.iso.datetime(),
          awaitingCollection: z
            .boolean()
            .describe(
              '«بانتظار تسجيل التحصيل» (K9): the money below is provisional until the captain or operations record the payment.',
            ),
          collectedAt: z.iso.datetime().nullable(),
          outcome: outcomeChoices.outcome,
          status: z.enum(['delivered', 'failed']),
          responsible: outcomeChoices.responsible,
          food: outcomeChoices.food,
          amountToCollect: money,
          loss: money,
          dues: money.nullable(),
          merchantDebit: money.nullable().describe('«استرداد مبلغ الاستلام» (RA §12.5).'),
          captainPay: money,
          customerText: z.string().nullable().describe('What the customer sees of a failed order.'),
          note: z.string().describe("Operations' internal note."),
          setBy: z.uuid().describe('The admin who set it.'),
          history: z
            .array(
              z.object({
                at: z.iso.datetime(),
                replacedAt: z.iso.datetime(),
                outcome: outcomeChoices.outcome,
                status: z.enum(['delivered', 'failed']),
                responsible: outcomeChoices.responsible,
                food: outcomeChoices.food,
                note: z.string(),
                setBy: z.uuid(),
              }),
            )
            .describe('The outcomes «تغيير النتيجة» replaced, oldest first (slice 2.11c).'),
        })
        .nullable()
        .describe(
          'AP §9.3.2 «تحديد النتيجة»: the outcome in force (AP §8.9), the last one set or changed.',
        ),
      outcomeChange: z
        .object({
          until: z.iso.datetime().describe('order.outcome_change_days after the first outcome.'),
          foods: z
            .array(
              z.object({
                code: z.enum(['kept_by_captain', 'returned_to_restaurant', 'destroyed']),
                label: z.string(),
              }),
            )
            .describe("Content's food_after_failed list, in order (AP Appendix B)."),
        })
        .nullable()
        .describe(
          'AP §8.9 «تغيير النتيجة» (OWN only, orders.change_outcome): while the outcome can change; null otherwise.',
        ),
      outcomeChoices: z
        .object({
          foods: z
            .array(
              z.object({
                code: z.enum(['kept_by_captain', 'returned_to_restaurant', 'destroyed']),
                label: z.string(),
              }),
            )
            .describe("Content's food_after_failed list, in order (AP Appendix B)."),
        })
        .nullable()
        .describe('While picked up or arrived: the choices of «تحديد النتيجة» (AP §9.3.2).'),
      itemReport: z
        .object({
          at: z.iso.datetime(),
          items: z.array(
            z.object({
              itemId: z.uuid(),
              name: z.string(),
              until: z.enum(['tomorrow', 'turned_back_on']).describe('«حتى الغد» or «حتى أعيده».'),
            }),
          ),
          note: z
            .object({ code: z.string(), label: z.string() })
            .nullable()
            .describe("A reason of Content's item_unavailable_note list, its label as chosen."),
        })
        .nullable()
        .describe(
          'RA §8.12: the open item-unavailable report, which blocks the pickup; «إغلاق بلاغ صنف نفد» closes it (POST …/item-report/close). Null otherwise.',
        ),
      timeChange: z
        .object({ maxMin: z.int().describe('order.eta_change_max_min.') })
        .nullable()
        .describe('While accepted, ready or picked up: «تعديل الوقت» (AP §9.3.2).'),
      editChoices: z
        .object({
          afterPickup: z
            .boolean()
            .describe(
              'Picked up or arrived: only lines removed or lowered and a lower fee, with a responsible party (no menu).',
            ),
          extraPrepMaxMin: z.int().describe('order.eta_change_max_min.'),
          items: z
            .array(
              z.object({
                id: z.uuid(),
                name: z.string(),
                category: z.string(),
                price: minor,
                optionGroups: z.array(
                  z.object({
                    id: z.uuid(),
                    name: z.string(),
                    minChoices: z.int(),
                    maxChoices: z.int(),
                    options: z.array(
                      z.object({ id: z.uuid(), name: z.string(), priceDelta: minor }),
                    ),
                  }),
                ),
              }),
            )
            .describe('The items customers can order now, with their available options.'),
        })
        .nullable()
        .describe(
          'While placed, accepted, ready, picked up or arrived: «تعديل الطلب» (AP §9.3.3).',
        ),
      edits: z
        .array(
          z.object({
            at: z.iso.datetime(),
            adminId: z.uuid(),
            status: z.enum(orderStatuses).describe('The status when edited.'),
            changes: z.array(editChange),
            addsItems: z.boolean(),
            itemsValue: z.object({ before: minor, after: minor }),
            deliveryFee: z.object({ before: minor, after: minor }),
            total: z.object({ before: minor, after: minor }),
            extraPrepMin: z.int().nullable(),
            responsible: z
              .enum(AFTER_PICKUP_PARTIES)
              .nullable()
              .describe('After the pickup: who bore the edit.'),
            charge: minor
              .nullable()
              .describe(
                'After the pickup: what the responsible party bore (the removed value or its merchant net, and the fee cut).',
              ),
            acknowledgedAt: z.iso
              .datetime()
              .nullable()
              .describe('«اطلعت على التعديل» on a restaurant device (RA §8.13).'),
          }),
        )
        .describe("The order's edits by operations, oldest first (AP §9.3.1)."),
      removedLines: z
        .array(z.object({ name: z.string(), quantity: z.int() }))
        .describe('Lines an edit removed.'),
      rejection: z
        .object({
          at: z.iso.datetime(),
          reason: z.string().describe('The code of the restaurant rejection list.'),
          label: z.string().describe('Its label as chosen (AP Appendix B).'),
          customerText: z.string().describe('What the customer sees (CU Appendix C).'),
          itemIds: z.array(z.uuid()).describe('The items switched off for item_unavailable.'),
          byOperations: z.boolean().describe("Rejected by operations on the restaurant's behalf."),
        })
        .nullable()
        .describe('While rejected (AP §9.3.1 «rejected (with reason)»).'),
      onBehalf: z
        .object({
          prepTime: z
            .object({
              options: z.array(z.int()).describe('The chips (merchant.prep_time_options).'),
              stepMin: z.int(),
              floorMin: z.int(),
              ceilingMin: z.int(),
              defaultMin: z
                .int()
                .describe(
                  "Preselected: the restaurant's default prep time plus busy mode's minutes while it is on.",
                ),
            })
            .describe('«قبول نيابة عن المطعم»: the prep-time chooser of RA §8.5.'),
          rejectionReasons: z
            .array(z.object({ code: z.string(), label: z.string() }))
            .describe("«رفض نيابة عن المطعم»: the restaurant's reasons (AP Appendix B), in order."),
          busyExtraOptionsMin: z
            .array(z.int())
            .describe('«ضغط طلبات»: busy mode with one of merchant.busy_extra_options_min.'),
        })
        .nullable()
        .describe(
          "While placed: the choices of AP §9.3.2's accept and reject on the restaurant's behalf.",
        ),
      customer: z
        .object({
          name: z.string().nullable().describe('Null before «أكمل بياناتك» (CU §5.3).'),
          address: z.object({
            location: z.object({ latitude: z.number(), longitude: z.number() }),
            neighbourhood: z.string(),
            street: z.string(),
            floor: z.string().nullable(),
            landmark: z.string(),
            directions: z.string().nullable(),
          }),
          recipientName: z.string().nullable(),
          payIn: z.string().nullable().describe('«سأدفع بـ».'),
          arrival: z
            .object({
              at: z.iso.datetime(),
              away: z
                .object({ reason: z.string(), label: z.string(), note: z.string().nullable() })
                .nullable()
                .describe('The reason given beyond captain.customer_radius_m (CA §9.6).'),
            })
            .nullable()
            .describe('The captain at the customer (CA §9.6).'),
        })
        .describe('The phone, masked and revealed with a log (AP §5.4), comes with its slice.'),
      note: z.string().nullable(),
      lines: z.array(
        z.object({
          itemId: z.uuid().describe('«رفض نيابة عن المطعم» picks the unavailable items by it.'),
          position: z.int().describe('«تعديل الطلب» names the line by it.'),
          name: z.string(),
          quantity: z.int(),
          added: z.boolean().describe('Added by an edit.'),
          quantityBefore: z.int().nullable().describe('The quantity before an edit changed it.'),
          options: z.array(z.object({ name: z.string(), priceDelta: minor })),
          note: z.string().nullable(),
          unitPrice: minor,
          lineTotal: minor,
        }),
      ),
      money: z.object({
        currency: z.string().length(3),
        itemsValue: minor,
        deliveryFee: minor,
        discount: minor,
        rounding: z.string().regex(/^-?\d+$/),
        total: minor,
        pickupPayment: minor.describe('Paid by the captain at pickup (D26: the items value).'),
      }),
      pickup: z.object({
        at: z.iso.datetime().nullable(),
        readyNotPressed: z.boolean().describe('«لم يُضغط جاهز».'),
        requests: z
          .array(
            z.object({
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
                .nullable(),
              captainId: z.uuid(),
              lines: paymentLines.describe('Paid by the captain.'),
              bookedLines: paymentLines.nullable().describe('Booked at confirmation.'),
              receivedLines: paymentLines
                .nullable()
                .describe('What the restaurant says it received.'),
              openedAt: z.iso.datetime(),
              closedAt: z.iso.datetime().nullable(),
              closedBy: z
                .object({
                  type: z.string(),
                  id: z.uuid().nullable(),
                  device: z.string().nullable().describe("The restaurant's app installation."),
                })
                .nullable(),
            }),
          )
          .describe("Newest first; the last one's lines prefill «تأكيد الاستلام نيابة عن المطعم»."),
        dispute: z
          .object({
            at: z.iso.datetime(),
            accountId: z.uuid().describe('The restaurant user.'),
            device: z.string(),
            receivedLines: paymentLines.describe('What the restaurant says it received.'),
          })
          .nullable()
          .describe('«خلاف على دفعة الاستلام» after the pickup (RA §8.10 item 8), always urgent.'),
      }),
      delivery: z
        .object({
          at: z.iso.datetime(),
          outcome: z.enum(orderOutcomes),
          received: paymentLines.describe('The payment lines (AP §9.3.1).'),
          change: z.array(money).describe('The change given.'),
          netReceived: money.describe("Received minus change, by the order's rates."),
          shortfall: z
            .object({
              amount: money,
              reason: z.string().describe('The code in Content.'),
              label: z.string().describe('Its label as chosen.'),
              note: z.string().nullable(),
            })
            .nullable()
            .describe('«نقص في التحصيل» (AP §8.6), open until operations resolve it.'),
          recordedBy: z.object({
            type: z.enum(['captain', 'admin']),
            id: z.uuid(),
            reason: z.string().nullable().describe("Operations' reason."),
          }),
        })
        .nullable()
        .describe('After «تم التسليم» (AP §9.3.1).'),
      timeline: z.array(
        z.object({
          version: z.int(),
          at: z.iso.datetime(),
          type: z.string().nullable().describe('Such as order.accepted or order.offered.'),
          from: z.enum(orderStatuses).nullable(),
          to: z.enum(orderStatuses),
          actor: z.object({ type: z.string(), id: z.uuid().nullable() }),
          captainId: z.uuid().nullable().describe("The offer's captain, or the one assigned."),
          reason: z.string().nullable(),
          timeChange: z
            .object({ addMin: z.int(), promisedAt: z.iso.datetime() })
            .nullable()
            .describe('order.time_changed: the minutes added and the new promised time.'),
          itemReport: z
            .object({
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
            .describe('order.item_reported: the items reported and the note.'),
        }),
      ),
    }),
  }),
) {}

// AP §8.9 «Preview»: the answer of both outcome previews.
function previewEntryBody(entry: OutcomePreview['entries'][number]) {
  return {
    type: entry.type,
    reason: entry.reason,
    account: entry.account,
    party: entry.party,
    amount: { amount: entry.amount.toString(), currency: entry.currency },
  };
}

function outcomePreviewBody(preview: OutcomePreview) {
  const { status, loss, dues, captainPay, currency, entries, provisional } = preview;
  const amount = (value: bigint) => ({ amount: value.toString(), currency });
  return {
    status,
    provisional,
    loss: amount(loss),
    dues: dues === null ? null : amount(dues),
    captainPay: amount(captainPay),
    entries: entries.map(previewEntryBody),
  };
}

function cardBody(item: OperationsOrder) {
  const { order } = item;
  const at = (moment: Date | null) => moment?.toISOString() ?? null;
  return {
    id: order.id,
    number: order.number.toString(),
    status: order.status,
    version: order.version,
    placedAt: order.placedAt.toISOString(),
    restaurant: { id: order.restaurantId, name: item.restaurantName },
    neighbourhood: order.address.neighbourhood,
    statusSince: item.statusSince.toISOString(),
    limitAt: at(item.limitAt),
    captainTrack: item.captainTrack,
    captain: item.captain,
    total: { amount: order.money.total.toString(), currency: order.currency },
    badges: {
      needsAssignment: item.needsAssignment,
      note: order.note !== null,
      newCustomer: item.newCustomer,
      pickupPending: item.pickupPending,
      awaitingCollection: item.awaitingCollection,
      itemReport: order.itemReport !== null,
    },
    moments: {
      acceptAlertAt: at(item.moments.acceptAlertAt),
      prepLateAlertAt: at(item.moments.prepLateAlertAt),
      searchStartedAt: at(item.moments.searchStartedAt),
      searchAlertAt: at(item.moments.searchAlertAt),
      noCaptainAlertAt: at(item.moments.noCaptainAlertAt),
      captainArrivedAt: at(item.moments.captainArrivedAt),
      captainWaitingAlertAt: at(item.moments.captainWaitingAlertAt),
    },
    alerts: item.alerts,
  };
}

// AP §9.2, §9.3.1: the operations room's board and an order's detail, for
// the roles that read operations (OWN, OPS, SUP).
@AdminController('orders')
export class AdminOrdersController {
  constructor(
    private readonly views: OperationsViews,
    private readonly customers: CustomersService,
    private readonly captainOrders: CaptainOrders,
    private readonly pickups: PickupCommands,
    private readonly resends: ResendNotification,
    private readonly commands: OrderCommands,
  ) {}

  // AP §9.3.2 «إعادة إرسال الإشعار», for OWN, OPS and SUP (operations.manage
  // or operations.compensate, checked by the guard): the order's latest push to that party, sent
  // again. 404 unknown_order; 409 order_state_changed (not active, or no
  // captain), nothing_to_resend.
  @Post(':orderId/resend-notification')
  @RequireAnyPermission('operations.manage', 'operations.compensate')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminNotificationResentDto })
  async resendNotification(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminResendNotificationDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      return await this.resends.resend(
        {
          orderId: params.orderId,
          to: body.to,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
        },
        new Date(),
      );
    } catch (error) {
      if (!(error instanceof ResendRefusedError)) throw error;
      if (error.refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
    }
  }

  // AP §9.3.2 «تأكيد الاستلام نيابة عن المطعم», for OWN and OPS: the order
  // accepted or ready and the assigned captain at the restaurant; the
  // pickup is booked with the admin's lines (AP §8.1). 409 amount_mismatch,
  // currency_not_accepted, order_state_changed with the order as it is now;
  // 400 invalid_lines; 404 unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/confirm-pickup')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async confirmPickup(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminConfirmPickupDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.pickups.confirmForRestaurant(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          lines: linesOfBody(body.lines),
          idempotencyKey,
        },
        new Date(),
      );
    } catch (error) {
      if (!(error instanceof OrderCommandRefusedError)) throw error;
      const { refusal } = error;
      if (refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
      }
      if (refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: refusal,
        });
      }
      if (refusal === 'invalid_lines') {
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: refusal });
      }
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: refusal,
        order: await this.card(params.orderId),
      });
    }
    return { order: await this.card(params.orderId) };
  }

  // AP §9.3.2 «قبول نيابة عن المطعم» (RA §8.15): a placed order accepted with
  // the prep time operations pick and their reason; the restaurant's devices
  // chime (RA §16 #5) and its card shows «قبلته العمليات». 409
  // order_state_changed with the order as it is now; 404 unknown_order; 400
  // invalid_prep_time; 422 idempotency_key_reused.
  @Post(':orderId/accept')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async accept(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminAcceptDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.acceptFor(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          idempotencyKey,
          prepMin: body.prepMin,
        },
        new Date(),
      ),
    );
  }

  // AP §9.3.2 «إغلاق بلاغ صنف نفد»: the open item-unavailable report closed
  // without an edit, with the required reason, which the restaurant's
  // devices chime with (RA §16 #37); the pickup is free again. 409
  // order_state_changed without an open report; 404 unknown_order; 422
  // idempotency_key_reused.
  @Post(':orderId/item-report/close')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async closeItemReport(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminCloseItemReportDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.closeItemReport(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          idempotencyKey,
        },
        new Date(),
      ),
    );
  }

  // AP §9.3.3 «تعديل الطلب» before the pickup (slice 2.10a): the lines kept
  // and added, a new delivery fee, and the extra prep time of a ready order
  // with items added; the money recalculated, an open item report cleared,
  // the restaurant prompted (RA §8.13), the captain and the customer told
  // the new amounts (CA §9.10, CU §11.6). 400 invalid_edit; 409
  // pickup_request_open, order_state_changed; 404 unknown_order; 422
  // idempotency_key_reused.
  @Post(':orderId/edit')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async edit(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminEditDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.editOrder(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          idempotencyKey,
          keep: body.keep,
          add: body.add,
          deliveryFee: body.deliveryFee === null ? null : BigInt(body.deliveryFee),
          extraPrepMin: body.extraPrepMin,
          responsible: body.responsible,
          version: body.version,
        },
        new Date(),
      ),
    );
  }

  // AP §9.3.3: the edit dialog's before-and-after money; it writes nothing,
  // so it takes no key. 400 invalid_edit; 409 pickup_request_open,
  // order_state_changed; 404 unknown_order.
  @Post(':orderId/edit-preview')
  @RequirePermission('operations.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminEditPreviewAnswerDto })
  async editPreview(@Param() params: AdminOrderParamsDto, @Body() body: AdminEditPreviewDto) {
    let preview: EditPreview | undefined;
    await this.onBehalf(params.orderId, async () => {
      preview = await this.commands.previewEdit(
        params.orderId,
        {
          keep: body.keep,
          add: body.add,
          deliveryFee: body.deliveryFee === null ? null : BigInt(body.deliveryFee),
          extraPrepMin: body.extraPrepMin,
          responsible: body.responsible,
        },
        new Date(),
      );
    });
    const card = await this.card(params.orderId);
    const currency = card.total.currency;
    const side = (money: EditPreview['before']) => ({
      itemsValue: money.itemsValue.toString(),
      deliveryFee: money.deliveryFee.toString(),
      discount: money.discount.toString(),
      rounding: money.rounding.toString(),
      total: money.total.toString(),
      commission: money.commission.toString(),
      merchantNet: money.merchantNet.toString(),
    });
    const answer = preview!;
    return {
      currency,
      before: side(answer.before),
      after: side(answer.after),
      changes: answer.changes,
      addsItems: answer.addsItems,
      backToPreparing: answer.backToPreparing,
      promisedAt: answer.promisedAt?.toISOString() ?? null,
      afterPickup: answer.afterPickup,
      entries: answer.entries.map((entry) => ({
        type: entry.type,
        reason: entry.reason,
        account: entry.account,
        party: entry.party,
        amount: { amount: entry.amount.toString(), currency: entry.currency },
      })),
    };
  }

  // AP §9.3.2 «تعديل الوقت» (owner decision 2026-11-10): minutes added to an
  // accepted, ready or picked-up order's promised time, and to its prep time
  // while accepted; the customer hears the new time (CU §14 #12). 409
  // order_state_changed; 404 unknown_order; 400 invalid_time_change; 422
  // idempotency_key_reused.
  @Post(':orderId/change-time')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async changeTime(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminChangeTimeDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.changeTime(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          idempotencyKey,
          addMin: body.addMin,
        },
        new Date(),
      ),
    );
  }

  // AP §9.3.2 «رفض نيابة عن المطعم» (RA §8.15): a placed order rejected with
  // one of the restaurant's three reasons and their side effects (RA §8.6)
  // and operations' reason; the customer sees the reason's text, the
  // restaurant's devices chime with its label (RA §16 #6). 409
  // order_state_changed; 404 unknown_order; 400 unknown_reason,
  // invalid_rejection; 422 idempotency_key_reused.
  @Post(':orderId/reject')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async reject(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminRejectDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const rejection: Rejection = {
      code: body.rejection,
      items: body.items,
      busyExtraMin: body.busyExtraMin,
      pauseMin: body.pauseMin,
    };
    return this.onBehalf(params.orderId, () =>
      this.commands.rejectFor(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          idempotencyKey,
          ...rejection,
          reason: body.reason,
        },
        new Date(),
      ),
    );
  }

  // AP §9.3.2 «إلغاء الطلب» (slice 2.8b): a placed, accepted or ready order
  // cancelled with an ops_cancel reason, the responsible party, «تم تحضير
  // الطعام؟», «تعويض الكابتن», the cash answer and the internal note; the
  // entries, the strike and the audit in one transaction. 400
  // unknown_reason, invalid_cancellation; 409 compensation_not_allowed,
  // captain_pay_unset, cash_answer_required, cash_answer_not_allowed,
  // order_state_changed, each with the order as it is now; 404
  // unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/cancel')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async cancel(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminCancelDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.cancelFor(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          idempotencyKey,
          code: body.cancellation,
          responsible: body.responsible,
          foodPrepared: body.foodPrepared,
          compensateCaptain: body.compensateCaptain,
          cash: body.cash,
          reason: body.reason,
        },
        new Date(),
      ),
    );
  }

  // docs/domain/09: the preview of every entry the dialog's choices would
  // post; it writes nothing, so it takes no key. It answers before every
  // question is answered (no cash_answer_required, compensation_not_allowed
  // or cash_answer_not_allowed): cashAsked and compensationAllowed say which
  // questions the dialog asks.
  @Post(':orderId/cancel-preview')
  @RequirePermission('operations.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminCancelPreviewAnswerDto })
  async cancelPreview(@Param() params: AdminOrderParamsDto, @Body() body: AdminCancelPreviewDto) {
    let preview: CancellationPreview | undefined;
    await this.onBehalf(params.orderId, async () => {
      preview = await this.commands.previewCancel(
        params.orderId,
        {
          code: body.cancellation ?? null,
          responsible: body.responsible,
          foodPrepared: body.foodPrepared,
          compensateCaptain: body.compensateCaptain,
          cash: body.cash,
        },
        new Date(),
      );
    });
    const { entries, cashAsked, compensationAllowed, cashLines, strike } = preview!;
    return {
      entries: entries.map((entry) => ({
        type: entry.type,
        account: entry.account,
        party: entry.party,
        amount: { amount: entry.amount.toString(), currency: entry.currency },
      })),
      cashAsked,
      compensationAllowed,
      cashLines: cashLines && linesBody(cashLines),
      strike,
    };
  }

  // AP §9.3.2 «سحب وإعادة تعيين» (slice 2.12a): an accepted or ready order
  // taken from its captain before the pickup, with a reassignment reason, the
  // fault, the cash answer and the internal note; the order goes back to
  // «بحاجة لتعيين», and operations offer or assign it again. 400
  // unknown_reason; 409 pickup_request_open, cash_answer_required,
  // cash_answer_not_allowed, order_state_changed, each with the order as it
  // is now; 404 unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/reassign')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async reassign(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminReassignDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.reassign(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          idempotencyKey,
          code: body.reassignment,
          captainFault: body.captainFault,
          cash: body.cash,
          reason: body.reason,
        },
        new Date(),
      ),
    );
  }

  // docs/domain/09: what the reassignment's cash answer would post; it
  // writes nothing, so it takes no key, and answers before the question is
  // answered (cashAsked says to ask it). 409 pickup_request_open,
  // order_state_changed.
  @Post(':orderId/reassign-preview')
  @RequirePermission('operations.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminReassignPreviewAnswerDto })
  async reassignPreview(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminReassignPreviewDto,
  ) {
    let preview: Awaited<ReturnType<OrderCommands['previewReassign']>> | undefined;
    await this.onBehalf(params.orderId, async () => {
      preview = await this.commands.previewReassign(params.orderId, body.cash);
    });
    const { entries, cashAsked, cashLines } = preview!;
    return {
      entries: entries.map((entry) => ({
        type: entry.type,
        account: entry.account,
        party: entry.party,
        amount: { amount: entry.amount.toString(), currency: entry.currency },
      })),
      cashAsked,
      cashLines: cashLines && linesBody(cashLines),
    };
  }

  // AP §9.3.2 «تحديد النتيجة», AP §8.9 (slice 2.11a): a picked-up or
  // arrived order ended with an outcome, the responsible party, whether a
  // damaged order was delivered, where a failed order's food went and the
  // internal note, nothing to collect; the entries and the audit in one
  // transaction. 400 invalid_outcome; 409 dues_rule_unset,
  // captain_pay_unset, order_state_changed, each with the order as it is
  // now; 404 unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/outcome')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async setOutcome(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminSetOutcomeDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.setOutcome(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          idempotencyKey,
          outcome: body.outcome,
          responsible: body.responsible,
          delivered: body.delivered,
          food: body.food,
          amountToCollect: BigInt(body.amountToCollect),
          version: body.version,
          reason: body.reason,
        },
        new Date(),
      ),
    );
  }

  // AP §8.9 «Preview»: every entry the outcome's choices would post; it
  // writes nothing, so it takes no key. 400 invalid_outcome; 409
  // dues_rule_unset, captain_pay_unset, order_state_changed.
  @Post(':orderId/outcome-preview')
  @RequirePermission('operations.manage')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOutcomePreviewAnswerDto })
  async outcomePreview(@Param() params: AdminOrderParamsDto, @Body() body: AdminOutcomePreviewDto) {
    let preview: OutcomePreview | undefined;
    await this.onBehalf(params.orderId, async () => {
      preview = await this.commands.previewOutcome(
        params.orderId,
        { ...body, amountToCollect: BigInt(body.amountToCollect) },
        new Date(),
      );
    });
    return outcomePreviewBody(preview!);
  }

  // AP §8.9 «Changing an outcome», AP §9.3.2 «تغيير النتيجة» (slice 2.11c):
  // OWN only (orders.change_outcome) changes a finished order's outcome, its
  // party or where the food went, within order.outcome_change_days of the
  // first outcome, with a reason: the old outcome's entries reversed and the
  // new ones posted in one transaction. 400 invalid_outcome; 409
  // outcome_change_closed, dues_rule_unset, captain_pay_unset,
  // order_state_changed; 404 unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/outcome-change')
  @RequirePermission('orders.change_outcome')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async changeOutcome(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminChangeOutcomeDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return this.onBehalf(params.orderId, () =>
      this.commands.changeOutcome(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          idempotencyKey,
          outcome: body.outcome,
          responsible: body.responsible,
          delivered: body.delivered,
          food: body.food,
          version: body.version,
          reason: body.reason,
        },
        new Date(),
      ),
    );
  }

  // AP §8.9 «The same preview is shown first»: the entries the change would
  // reverse and post; it writes nothing, so it takes no key.
  @Post(':orderId/outcome-change-preview')
  @RequirePermission('orders.change_outcome')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOutcomeChangePreviewAnswerDto })
  async outcomeChangePreview(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminOutcomeChangePreviewDto,
  ) {
    let preview: OutcomeChangePreview | undefined;
    await this.onBehalf(params.orderId, async () => {
      preview = await this.commands.previewOutcomeChange(params.orderId, body, new Date());
    });
    const { reversed, ...rest } = preview!;
    return { ...outcomePreviewBody(rest), reversed: reversed.map(previewEntryBody) };
  }

  // Runs a command on the restaurant's behalf and answers the card, or its
  // refusal.
  private async onBehalf(orderId: string, run: () => Promise<unknown>) {
    try {
      await run();
    } catch (error) {
      if (!(error instanceof OrderCommandRefusedError)) throw error;
      const { refusal } = error;
      if (refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: refusal });
      }
      if (refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: refusal,
        });
      }
      if (
        refusal === 'invalid_prep_time' ||
        refusal === 'invalid_time_change' ||
        refusal === 'invalid_item_report' ||
        refusal === 'unknown_reason' ||
        refusal === 'invalid_rejection' ||
        refusal === 'invalid_cancellation' ||
        refusal === 'invalid_edit' ||
        refusal === 'invalid_outcome'
      ) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: refusal,
          message: error.message,
        });
      }
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: refusal,
        order: await this.card(orderId),
      });
    }
    return { order: await this.card(orderId) };
  }

  // AP §9.3.2 «تسجيل وصول الكابتن», for OWN and OPS when GPS fails at the
  // restaurant (CA §9.2): the assigned captain's track becomes at_merchant.
  // 409 order_state_changed with the order as it is now (no captain, already
  // arrived, picked up or ended); 404 unknown_order; 422
  // idempotency_key_reused.
  @Post(':orderId/record-arrival')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async recordArrival(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminRecordArrivalDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.captainOrders.recordArrival(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          idempotencyKey,
        },
        new Date(),
      );
    } catch (error) {
      if (!(error instanceof CaptainOrderRefusedError)) throw error;
      if (error.refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      if (error.refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: error.refusal,
        });
      }
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: error.refusal,
        order: await this.card(params.orderId),
      });
    }
    return { order: await this.card(params.orderId) };
  }

  // AP §9.3.2 «تسجيل التسليم نيابة عن الكابتن»: picked_up or arrived, the
  // lines and change the captain reports by phone, a reason; the same entries
  // as the captain's delivery, audited as order.record_delivery. 409
  // order_state_changed, amount_due_changed and currency_not_accepted with
  // the card, overpaid, shortfall_reason_required with `shortfall`; 400
  // invalid_lines; 404 unknown_order; 422 idempotency_key_reused.
  @Post(':orderId/record-delivery')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async recordDelivery(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminRecordDeliveryDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.doorRefusals(params.orderId, () =>
      this.captainOrders.recordDelivery(
        {
          orderId: params.orderId,
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
          reason: body.reason,
          idempotencyKey,
          ...doorCollection(body),
        },
        new Date(),
      ),
    );
    return { order: await this.card(params.orderId) };
  }

  // The door payment's refusals as HTTP answers, with the card.
  private async doorRefusals(orderId: string, run: () => Promise<unknown>): Promise<void> {
    try {
      await run();
    } catch (error) {
      if (!(error instanceof CaptainOrderRefusedError)) throw error;
      if (error.refusal === 'unknown_order') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      if (
        error.refusal === 'invalid_lines' ||
        error.refusal === 'unknown_reason' ||
        error.refusal === 'reason_note_required' ||
        error.refusal === 'reason_note_not_allowed'
      ) {
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
      }
      if (error.refusal === 'idempotency_key_reused') {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: error.refusal,
        });
      }
      throw new ConflictException({
        statusCode: HttpStatus.CONFLICT,
        error: error.refusal,
        order: await this.card(orderId),
        ...(error.shortfall
          ? {
              shortfall: {
                amount: error.shortfall.amount.toString(),
                currency: error.shortfall.currency,
              },
            }
          : {}),
      });
    }
  }

  // AP §9.3.2, CA §9.10 (K9): operations enter the payment of an outcome's
  // amount to collect when the captain cannot, with a reason; the outcome is
  // posted from it, audited as order.record_outcome_payment. The refusals of
  // «تسجيل التسليم نيابة عن الكابتن».
  @Post(':orderId/outcome-payment')
  @RequirePermission('operations.manage')
  @Idempotent()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminOrderCardDto })
  async collectOutcome(
    @Param() params: AdminOrderParamsDto,
    @Body() body: AdminRecordDeliveryDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await this.doorRefusals(params.orderId, () =>
      this.captainOrders.collectOutcome(
        {
          kind: 'admin',
          command: {
            orderId: params.orderId,
            admin: { accountId: session.accountId, roles: session.roles },
            context: requestContext(request),
            reason: body.reason,
            idempotencyKey,
          },
        },
        doorCollection(body),
        new Date(),
      ),
    );
    return { order: await this.card(params.orderId) };
  }

  private async card(orderId: string) {
    const item = await this.views.order(orderId, new Date());
    if (item === null) throw new Error(`order ${orderId} not found`);
    return cardBody(item);
  }

  // AP §8.6: the open collection shortfalls of the city, «نقص في التحصيل».
  @Get('shortfalls')
  @RequirePermission('operations.read')
  @ZodResponse({ status: 200, type: AdminShortfallsDto })
  async shortfalls(@Query() query: AdminBoardQueryDto) {
    const money = (amount: bigint, currency: string) => ({ amount: amount.toString(), currency });
    return {
      shortfalls: (await this.views.shortfalls(query.cityId)).map((each) => ({
        orderId: each.orderId,
        number: each.number.toString(),
        captainId: each.captainId,
        amountDue: money(each.amountDue, each.currency),
        netReceived: money(each.netReceived, each.currency),
        shortfall: money(each.amount, each.currency),
        reason: each.reason,
        label: each.label ?? each.reason,
        note: each.note,
        recordedAt: each.recordedAt.toISOString(),
      })),
    };
  }

  @Get()
  @RequirePermission('operations.read')
  @ZodResponse({ status: 200, type: AdminBoardDto })
  async board(@Query() query: AdminBoardQueryDto) {
    return { orders: (await this.views.board(query.cityId, new Date())).map(cardBody) };
  }

  @Get(':orderId')
  @RequirePermission('operations.read')
  @ZodResponse({ status: 200, type: AdminOrderDto })
  async order(@Param() params: AdminOrderParamsDto) {
    const now = new Date();
    const item = await this.views.order(params.orderId, now);
    if (item === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_order' });
    }
    const { order } = item;
    const { cancellation } = order;
    const [
      profile,
      timeline,
      onBehalf,
      cancelReasons,
      customerLabel,
      timeChange,
      editChoices,
      edits,
      outcomeFoods,
      outcomeChange,
      reassignReasons,
      reassignmentRows,
      handoverRows,
    ] = await Promise.all([
      this.customers.profile(order.customerAccountId),
      this.views.timeline(order),
      order.status === 'placed'
        ? this.commands.onBehalfChoices(order.restaurantId, order.cityId, now)
        : null,
      CANCELLABLE.includes(order.status) ? this.commands.cancelReasons() : null,
      cancellation?.byCustomer ? this.commands.customerCancelLabel(cancellation.reason) : null,
      TIME_CHANGEABLE.includes(order.status) ? this.commands.timeChangeChoices(order.cityId) : null,
      EDITABLE.includes(order.status) && !order.outcome?.awaitingCollection
        ? this.commands.editChoices(order, now)
        : null,
      this.commands.editsOf(order),
      AFTER_PICKUP.includes(order.status) && order.outcome === null
        ? this.commands.outcomeFoods()
        : null,
      this.commands.outcomeChangeChoices(order, now),
      REASSIGNABLE.includes(order.status) && item.captain !== null
        ? this.commands.reassignReasons()
        : null,
      this.commands.reassignmentsOf(order),
      this.commands.handoversOf(order, now),
    ]);
    const { acceptance } = order;
    // The cancellation itself, not its acknowledgement (RA §8.14).
    const cancelEvent = timeline.find(
      (event) => event.to === 'cancelled' && event.from !== 'cancelled',
    );
    // The event row keeps operations' note, or the customer's «سبب آخر» text
    // when given (else the code), or the timer's code.
    const cancelNote =
      cancelEvent && cancellation && cancelEvent.reason !== cancellation.reason
        ? (cancelEvent.reason ?? null)
        : null;
    const base = (amount: bigint | null) =>
      amount === null ? null : { amount: amount.toString(), currency: order.currency };
    return {
      order: {
        ...cardBody(item),
        promisedAt: acceptance?.promisedAt.toISOString() ?? null,
        acceptance: acceptance && {
          at: acceptance.at.toISOString(),
          prepMin: acceptance.prepMin,
          prepDueAt: new Date(acceptance.at.getTime() + acceptance.prepMin * 60_000).toISOString(),
        },
        readyAt: order.readyAt?.toISOString() ?? null,
        cancellation: cancellation && {
          at: cancellation.at.toISOString(),
          reason: cancellation.reason,
          label: cancellation.label ?? customerLabel,
          note:
            cancelEvent?.actor.type === 'admin' || cancelEvent?.actor.type === 'customer'
              ? cancelNote
              : null,
          customerText: cancellation.customerText,
          by: cancelEvent?.actor ?? { type: 'system', id: null },
          responsible: cancellation.responsible,
          foodPrepared: cancellation.foodPrepared,
          cash: cancellation.cash,
          merchantCredit: base(cancellation.merchantCredit),
          captainCompensation: base(cancellation.captainCompensation),
          acknowledgedAt: cancellation.acknowledgedAt?.toISOString() ?? null,
          captainSeenAt: cancellation.captainSeenAt?.toISOString() ?? null,
        },
        cancelChoices: cancelReasons && { reasons: cancelReasons },
        reassignChoices: reassignReasons && { reasons: reassignReasons },
        handover: {
          allowed: handoverRows.allowed,
          handovers: handoverRows.rows.map((each) => ({
            ...each,
            openedAt: each.openedAt.toISOString(),
            assignedAt: each.assignedAt?.toISOString() ?? null,
            receivedAt: each.receivedAt?.toISOString() ?? null,
            closedAt: each.closedAt?.toISOString() ?? null,
          })),
        },
        reassignments: reassignmentRows.map((each) => ({
          ...each,
          at: each.at.toISOString(),
          captainSeenAt: each.captainSeenAt?.toISOString() ?? null,
        })),
        outcome: order.outcome && {
          at: order.outcome.at.toISOString(),
          awaitingCollection: order.outcome.awaitingCollection,
          collectedAt: order.outcome.collectedAt?.toISOString() ?? null,
          outcome: order.outcome.outcome,
          status: order.outcome.status,
          responsible: order.outcome.responsible,
          food: order.outcome.food,
          amountToCollect: base(order.outcome.amountToCollect)!,
          loss: base(order.outcome.loss)!,
          dues: base(order.outcome.dues),
          merchantDebit: base(order.outcome.merchantDebit),
          captainPay: base(order.outcome.captainPay)!,
          customerText: order.outcome.customerText,
          note: order.outcome.note,
          setBy: order.outcome.setBy,
          history: order.outcome.history.map((each) => ({
            ...each,
            at: each.at.toISOString(),
            replacedAt: each.replacedAt.toISOString(),
          })),
        },
        outcomeChoices: outcomeFoods && { foods: outcomeFoods },
        outcomeChange: outcomeChange && {
          until: outcomeChange.until.toISOString(),
          foods: outcomeChange.foods,
        },
        itemReport: order.itemReport && {
          at: order.itemReport.at.toISOString(),
          items: order.itemReport.items,
          note: order.itemReport.note,
        },
        timeChange,
        editChoices: editChoices && {
          afterPickup: editChoices.afterPickup,
          extraPrepMaxMin: editChoices.extraPrepMaxMin,
          items: editChoices.items.map((entry) => ({
            ...entry,
            price: entry.price.toString(),
            optionGroups: entry.optionGroups.map((group) => ({
              ...group,
              options: group.options.map((option) => ({
                ...option,
                priceDelta: option.priceDelta.toString(),
              })),
            })),
          })),
        },
        edits: edits.map((edit) => ({
          at: edit.at.toISOString(),
          adminId: edit.adminId,
          status: edit.status,
          changes: edit.changes as EditChange[],
          addsItems: edit.addsItems,
          itemsValue: {
            before: edit.itemsValueBefore.toString(),
            after: edit.itemsValueAfter.toString(),
          },
          deliveryFee: {
            before: edit.deliveryFeeBefore.toString(),
            after: edit.deliveryFeeAfter.toString(),
          },
          total: { before: edit.totalBefore.toString(), after: edit.totalAfter.toString() },
          extraPrepMin: edit.extraPrepMin,
          responsible: edit.responsible,
          charge: edit.charge?.toString() ?? null,
          acknowledgedAt: edit.acknowledgedAt?.toISOString() ?? null,
        })),
        removedLines: order.removedLines.map((line) => ({
          name: line.name,
          quantity: line.quantity,
        })),
        rejection: order.rejection && {
          at: order.rejection.at.toISOString(),
          reason: order.rejection.reason,
          label: order.rejection.label,
          customerText: order.rejection.customerText,
          itemIds: order.rejection.itemIds,
          byOperations: order.rejection.byOperations,
        },
        onBehalf,
        customer: {
          name: profile ? [profile.firstName, profile.lastName].filter(Boolean).join(' ') : null,
          address: {
            location: order.address.location,
            neighbourhood: order.address.neighbourhood,
            street: order.address.street,
            floor: order.address.floor,
            landmark: order.address.landmark,
            directions: order.address.directions,
          },
          recipientName: order.address.recipientName,
          payIn: order.payIn,
          arrival: order.customerArrival && {
            at: order.customerArrival.at.toISOString(),
            away: order.away,
          },
        },
        note: order.note,
        lines: order.lines.map((line) => ({
          itemId: line.itemId,
          position: line.position,
          name: line.name,
          quantity: line.quantity,
          added: line.added,
          quantityBefore: line.quantityBefore,
          options: line.options.map((option) => ({
            name: option.name,
            priceDelta: option.priceDelta.toString(),
          })),
          note: line.note,
          unitPrice: line.unitPrice.toString(),
          lineTotal: line.lineTotal.toString(),
        })),
        money: {
          currency: order.currency,
          itemsValue: order.money.itemsValue.toString(),
          deliveryFee: order.money.deliveryFee.toString(),
          discount: order.money.discount.toString(),
          rounding: order.money.rounding.toString(),
          total: order.money.total.toString(),
          // AP §9.3.3: an edit after the pickup leaves what the captain paid.
          pickupPayment: (
            edits.find((edit) => edit.responsible !== null)?.itemsValueBefore ??
            order.money.itemsValue
          ).toString(),
        },
        pickup: {
          at: order.pickup?.at.toISOString() ?? null,
          readyNotPressed: order.pickup?.readyByPickup ?? false,
          requests: item.pickupRequests.map((request) => ({
            id: request.id,
            status: request.status,
            outcome: request.outcome,
            captainId: request.captainId,
            lines: linesBody(request.lines),
            bookedLines: request.bookedLines && linesBody(request.bookedLines),
            receivedLines: request.receivedLines && linesBody(request.receivedLines),
            openedAt: request.openedAt.toISOString(),
            closedAt: request.closedAt?.toISOString() ?? null,
            closedBy: request.closedBy,
          })),
          dispute: item.pickupDispute && {
            at: item.pickupDispute.at.toISOString(),
            accountId: item.pickupDispute.accountId,
            device: item.pickupDispute.device,
            receivedLines: linesBody(item.pickupDispute.receivedLines),
          },
        },
        delivery: order.delivery && {
          at: order.delivery.at.toISOString(),
          outcome: order.delivery.outcome,
          received: linesBody(order.delivery.received),
          change: linesBody(order.delivery.change),
          netReceived: {
            amount: order.delivery.netReceived.toString(),
            currency: order.currency,
          },
          shortfall: order.delivery.shortfall && {
            amount: {
              amount: order.delivery.shortfall.amount.toString(),
              currency: order.currency,
            },
            reason: order.delivery.shortfall.reason,
            label: order.delivery.shortfall.label,
            note: order.delivery.shortfall.note,
          },
          recordedBy: {
            type: order.delivery.recordedBy.type as 'captain' | 'admin',
            id: order.delivery.recordedBy.id,
            reason: order.delivery.recordedBy.reason,
          },
        },
        timeline: timeline.map((event) => ({
          ...event,
          at: event.at.toISOString(),
          timeChange: event.timeChange && {
            addMin: event.timeChange.addMin,
            promisedAt: event.timeChange.promisedAt.toISOString(),
          },
        })),
      },
    };
  }
}
