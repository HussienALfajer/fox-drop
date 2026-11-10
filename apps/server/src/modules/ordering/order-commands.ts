import { Inject, Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { and, desc, eq, inArray, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { inTransaction, QUEUES } from '../../jobs/job-queue.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { AuditService } from '../audit/index.js';
import { CaptainsService } from '../captains/index.js';
import { CustomersService } from '../customers/index.js';
import { ContentRefusedError, ContentService } from '../content/index.js';
import { GeoService, tripMinutes } from '../geo/index.js';
import { LedgerService } from '../ledger/index.js';
import {
  type MerchantChange,
  MerchantsService,
  RestaurantStatusService,
} from '../merchants/index.js';
import { SettingsService } from '../settings/index.js';
import type { AdminOrderCommand } from './captain-orders.js';
import {
  type CancellationChoices,
  type CancellationFacts,
  cancellationEntries,
  type CashAnswer,
  type ResponsibleParty,
} from './cancellation.js';
import { commandHash, IdempotencyKeyReusedError, keepKey, replayKey } from './idempotency-keys.js';
import {
  type AfterPickupJournal,
  afterPickupEntries,
  type CurrentLine,
  frozenAtPickup,
  type EditChange,
  type EditRequest,
  pendingEdits,
  planEdit,
} from './order-edits.js';
import { lockOrder, type OrderEventType, recordTransition } from './order-events.js';
import { OrderAssignments } from './order-assignments.js';
import { baseTotal, linesOf } from './pickup-booking.js';
import type { SearchStartJob } from './order-timers.js';
import {
  AFTER_PICKUP,
  BEFORE_PICKUP,
  EDITABLE,
  orderKey,
  readOrders,
  snapshotOf,
  type OrderView,
} from './order-views.js';
import { commission } from './door-payment.js';
import { priceLines, quoteMoney, type QuoteMoney } from './quote.js';
import {
  type ItemReportNote,
  itemReportProblem,
  openItemReport,
  openReportOf,
  type ReportedItem,
} from './item-reports.js';
import {
  itemReports,
  orderEdits,
  orderLines,
  orders,
  pickupRequests,
  timeChanges,
} from './schema.js';

const MINUTE_MS = 60_000;
// docs/domain/03: the promised time is rounded up to the next 5 minutes.
const PROMISE_STEP_MS = 5 * MINUTE_MS;

export type OrderCommandRefusal =
  | 'unknown_order'
  | 'order_state_changed'
  | 'invalid_prep_time'
  | 'idempotency_key_reused'
  // RA §8.6: a reason not on the list, or steps that do not fit it.
  | 'unknown_reason'
  | 'invalid_rejection'
  // CU §11.4: «سبب آخر» takes its optional text; the other reasons none.
  | 'reason_note_required'
  | 'reason_note_not_allowed'
  // RA §8.10: payment lines (pickup-commands.ts).
  | 'invalid_lines'
  | 'currency_not_accepted'
  | 'amount_mismatch'
  | 'pickup_already_disputed'
  // AP §9.3.2 «إلغاء الطلب» (slice 2.8b, cancellation.ts).
  | 'invalid_cancellation'
  | 'compensation_not_allowed'
  | 'captain_pay_unset'
  | 'cash_answer_required'
  | 'cash_answer_not_allowed'
  // AP §9.3.2 «تعديل الوقت»: whole minutes from 1 to order.eta_change_max_min.
  | 'invalid_time_change'
  // RA §8.12: the report's items are one or more of the order's, each once.
  | 'invalid_item_report'
  // RA §8.10, §8.12: an open item report blocks the pickup.
  | 'item_report_open'
  // AP §9.3.3 «تعديل الطلب» (slice 2.10a, order-edits.ts): the lines, the fee
  // or the extra prep time do not fit; no edit while a pickup request is
  // open (RA §8.10).
  | 'invalid_edit'
  | 'pickup_request_open';

// A restaurant command the order refuses; order_state_changed carries the
// order as it is now, which the app explains (RA §4.7).
export class OrderCommandRefusedError extends Error {
  override readonly name = 'OrderCommandRefusedError';
  constructor(
    readonly refusal: OrderCommandRefusal,
    message: string,
    readonly order: OrderView | null = null,
  ) {
    super(message);
  }
}

// RA §18: who runs a restaurant command and on which order.
export interface MerchantCommand {
  restaurantId: string;
  accountId: string;
  // The app installation (RA §18 records the device).
  deviceId: string;
  idempotencyKey: string;
  orderId: string;
  // The user's role and address, which the audit of a rejection's side
  // effects keeps (RA §8.6).
  role?: string;
  ipAddress?: string | null;
}

// CU §11.4: the customer's own command on their order.
export interface CustomerCommand {
  accountId: string;
  idempotencyKey: string;
  orderId: string;
}

// RA §8.6, R3: the three reasons of Content's closed merchant_rejection
// list, each with its own behaviour.
export const REJECTION_REASONS = ['item_unavailable', 'restaurant_closed', 'too_busy'] as const;
export type RejectionReason = (typeof REJECTION_REASONS)[number];

// RA §8.6: the rejection with its steps: the items of «صنف غير متوفر», each
// «حتى الغد» or «حتى أعيده»; for «ضغط طلبات» optionally «تفعيل وضع الضغط»
// (its minutes) or «إيقاف 30 د».
export interface Rejection {
  // The reason's code in Content's merchant_rejection list.
  code: string;
  items: { itemId: string; until: 'tomorrow' | 'turned_back_on' }[];
  busyExtraMin: number | null;
  pauseMin: number | null;
}

// AP §9.3.2 «تعديل الوقت»: accepted, ready or picked up.
export const TIME_CHANGEABLE: OrderView['status'][] = ['accepted', 'ready', 'picked_up'];

// RA §8.12: the restaurant reports an item on an accepted or ready order,
// before pickup; operations close it while it is open.
export const REPORTABLE: OrderView['status'][] = ['accepted', 'ready'];

// AP §8.1, docs/domain/01: operations cancel before pickup.
export const CANCELLABLE: OrderView['status'][] = ['placed', 'accepted', 'ready'];

// AP §9.3.2 «إلغاء الطلب»: operations' choices (the reason's code apart).
export interface OpsCancellation {
  responsible: ResponsibleParty;
  foodPrepared: boolean;
  compensateCaptain: boolean;
  cash: CashAnswer | null;
}

function choicesOf(choices: OpsCancellation): CancellationChoices {
  return {
    responsible: choices.responsible,
    foodPrepared: choices.foodPrepared,
    compensateCaptain: choices.compensateCaptain,
    cash: choices.cash,
  };
}

// docs/domain/09: the preview of every entry the cancellation would post.
export interface CancellationPreview {
  entries: {
    type: string;
    account: string;
    party: { kind: 'merchant' | 'captain' | 'platform'; id: string | null; name: string | null };
    amount: bigint;
    currency: string;
  }[];
  cashAsked: boolean;
  compensationAllowed: boolean;
  cashLines: { currency: string; amount: bigint }[] | null;
  // docs/domain/08: the choices give the customer a late-cancellation strike.
  strike: boolean;
}

// RA §8.6: «إيقاف 30 د» is the only pause «ضغط طلبات» offers.
export const TOO_BUSY_PAUSE_MIN = 30;

// RA §8.6: why the rejection's steps do not fit its reason, or null. The
// items are the order's (each once) and only for «صنف غير متوفر», where at
// least one is required; busy mode or the 30-minute pause, not both, only
// for «ضغط طلبات».
export function rejectionProblem(rejection: Rejection, orderItemIds: string[]): string | null {
  if (!(REJECTION_REASONS as readonly string[]).includes(rejection.code)) {
    return 'unknown_reason';
  }
  const ids = rejection.items.map((item) => item.itemId);
  if (rejection.code === 'item_unavailable') {
    if (ids.length === 0) return 'pick the unavailable items';
    if (new Set(ids).size !== ids.length) return 'each item once';
    if (ids.some((id) => !orderItemIds.includes(id))) return "the items are the order's";
  } else if (ids.length > 0) {
    return 'items only for item_unavailable';
  }
  if (rejection.code !== 'too_busy') {
    if (rejection.busyExtraMin !== null || rejection.pauseMin !== null) {
      return 'busy mode or a pause only for too_busy';
    }
  } else if (rejection.busyExtraMin !== null && rejection.pauseMin !== null) {
    return 'busy mode or a pause, not both';
  } else if (rejection.pauseMin !== null && rejection.pauseMin !== TOO_BUSY_PAUSE_MIN) {
    return `the pause is ${TOO_BUSY_PAUSE_MIN} minutes`;
  }
  return null;
}

// What a rejection's key hashes: the reason and its steps.
function rejectionHash(rejection: Rejection) {
  return {
    code: rejection.code,
    items: rejection.items,
    busyExtraMin: rejection.busyExtraMin,
    pauseMin: rejection.pauseMin,
  };
}

// RA §8.5: the prep-time chooser of the accept prompt.
export interface PrepTimeChooser {
  options: number[];
  stepMin: number;
  floorMin: number;
  ceilingMin: number;
  // The restaurant's default prep time plus the busy-mode minutes while it is
  // on, within the floor and the ceiling.
  defaultMin: number;
}

// AP §9.3.2: what operations choose from to accept or reject on the
// restaurant's behalf, as the restaurant's own prompt and sheet do (RA §8.5,
// §8.6).
export interface OnBehalfChoices {
  prepTime: PrepTimeChooser;
  // Content's active merchant_rejection reasons, in order.
  rejectionReasons: { code: string; label: string }[];
  // «تفعيل وضع الضغط» with «ضغط طلبات».
  busyExtraOptionsMin: number[];
}

// The state a command needs and the one it leaves: `to` null keeps the
// order's status (a change within it, AP §9.3.2 «تعديل الوقت»), with its
// event type.
type Transition = {
  verb:
    | 'accept'
    | 'ready'
    | 'reject'
    | 'cancel'
    | 'change_time'
    | 'report_item'
    | 'withdraw_item_report'
    | 'close_item_report'
    | 'edit';
  from: OrderView['status'][];
  to: 'accepted' | 'ready' | 'rejected' | 'cancelled' | null;
  event?: OrderEventType;
};

// Who runs a command: a user of the restaurant on its device (RA §18),
// operations on the restaurant's behalf (AP §9.3.2), on any order, with the
// reason the event and the audit keep, or the customer on their own order
// (CU §11.4).
type Caller =
  | { kind: 'restaurant'; command: MerchantCommand }
  // «تعديل الوقت» takes an optional note (AP §9.3.2).
  | { kind: 'admin'; command: Omit<AdminOrderCommand, 'reason'> & { reason: string | null } }
  | { kind: 'customer'; command: CustomerCommand };

// A state change of the command (the columns it sets) and what the
// transaction sends with it.
type Change = {
  set: Partial<typeof orders.$inferInsert>;
  // The status it leaves when the transition's `to` depends on the order (an
  // edit sends a ready order back to accepted, AP §9.3.3).
  to?: OrderView['status'];
  searchStartAt?: Date;
  // What the apps' channels publish as the reason (RA §8.6: the rejection's
  // code); the restaurant's event keeps it too, operations' keeps their note.
  publicReason?: string;
  // What the event row keeps as the reason, when not the public one: the
  // customer's text of «سبب آخر» (CU §11.4).
  eventReason?: string;
  // Under the order's lock: false when what the change was worked out from
  // moved since, answered as order_state_changed (slice 2.8b).
  guard?: (tx: Tx) => Promise<boolean>;
  // Written in the transaction before the order's own transition, which
  // follows its version (an offer withdrawn, slice 2.8b).
  before?: (tx: Tx) => Promise<void>;
  // Written in the transaction after the order's own change (RA §8.6).
  effects?: (tx: Tx) => Promise<void>;
  // What the audit keeps beside the status («تعديل الوقت»: the times it
  // moved, before and after).
  audit?: { before: Record<string, unknown>; after: Record<string, unknown> };
};

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// The restaurant's commands on an order (RA §8.5–8.8, §18): each takes the
// order's lock, checks its state, writes the change, its event, its outbox row
// and its timers in one transaction (architecture §5.5), and keeps the
// command's key with the order (architecture §5.3). Whatever is slow (the
// settings, the nearest captain and its distance) is read before the
// transaction, so it never holds the order's lock while it waits.
@Injectable()
export class OrderCommands {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly captains: CaptainsService,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly jobs: Jobs,
    private readonly content: ContentService,
    private readonly status: RestaurantStatusService,
    private readonly audit: AuditService,
    private readonly ledger: LedgerService,
    private readonly customers: CustomersService,
    private readonly assignments: OrderAssignments,
  ) {}

  async prepTimeChooser(restaurantId: string, now: Date): Promise<PrepTimeChooser> {
    const [restaurant, state] = await Promise.all([
      this.merchants.restaurant(restaurantId, now),
      this.merchants.operatingState(restaurantId, now),
    ]);
    if (!restaurant) throw new Error(`restaurant ${restaurantId} not found`);
    const cityId = restaurant.cityId;
    const [options, stepMin, floorMin, ceilingMin] = await Promise.all([
      this.settings.get('merchant.prep_time_options', { cityId }),
      this.settings.get('merchant.prep_time_step_min', { cityId }),
      this.settings.get('merchant.prep_time_floor_min', { cityId }),
      this.settings.get('merchant.prep_time_ceiling_min', { cityId }),
    ]);
    // RA §7.3: busy mode counts only while the restaurant is open, as in the
    // quote's estimate.
    const busyExtraMin = state.state === 'open' ? (state.busyExtraMin ?? 0) : 0;
    const preselected = restaurant.defaultPrepMin + busyExtraMin;
    return {
      options,
      stepMin,
      floorMin,
      ceilingMin,
      defaultMin: Math.min(Math.max(preselected, floorMin), ceilingMin),
    };
  }

  async onBehalfChoices(restaurantId: string, cityId: string, now: Date): Promise<OnBehalfChoices> {
    const [prepTime, lists, busyExtraOptionsMin] = await Promise.all([
      this.prepTimeChooser(restaurantId, now),
      this.content.listsFor('merchant'),
      this.settings.get('merchant.busy_extra_options_min', { cityId }),
    ]);
    return {
      prepTime,
      rejectionReasons: (lists.merchant_rejection ?? []).map(({ code, label }) => ({
        code,
        label,
      })),
      busyExtraOptionsMin,
    };
  }

  // RA §8.5: a placed order becomes accepted with the chosen prep time, any
  // whole minute from merchant.prep_time_floor_min to its ceiling. It sets
  // the promised time (docs/domain/03), the search-start moment with its
  // timer (AP §8.3, §9.12.6) and operations' prep-late moment.
  async accept(command: MerchantCommand & { prepMin: number }, now: Date): Promise<OrderView> {
    return this.run(
      { kind: 'restaurant', command },
      { verb: 'accept', from: ['placed'], to: 'accepted' },
      { prepMin: command.prepMin },
      now,
      (order) => this.acceptance(order, command.prepMin, now),
    );
  }

  // AP §9.3.2 «قبول نيابة عن المطعم» (RA §8.15): the same acceptance by
  // operations, with their reason; the restaurant's devices chime with the
  // prep time (RA §16 #5) and its card shows «قبلته العمليات».
  async acceptFor(command: AdminOrderCommand & { prepMin: number }, now: Date): Promise<OrderView> {
    return this.run(
      { kind: 'admin', command },
      { verb: 'accept', from: ['placed'], to: 'accepted' },
      { prepMin: command.prepMin, reason: command.reason },
      now,
      (order) => this.acceptance(order, command.prepMin, now),
    );
  }

  // RA §8.6: «رفض» with one of the three reasons and its steps. The order
  // becomes rejected and keeps the reason, its label, the customer's text
  // (CU Appendix C; «{الأصناف}» filled with the items' names) and the items;
  // in the same transaction the items are switched off, or the restaurant
  // paused «حتى أعيد الفتح» (S2), or busy mode or «إيقاف 30 د» set, each only
  // when the restaurant could set it now. 400 unknown_reason,
  // invalid_rejection.
  async reject(command: MerchantCommand & Rejection, now: Date): Promise<OrderView> {
    const change: MerchantChange = {
      actor: { type: 'merchant', id: command.accountId, role: command.role ?? null },
      context: { ipAddress: command.ipAddress ?? null, device: command.deviceId },
    };
    return this.run(
      { kind: 'restaurant', command },
      { verb: 'reject', from: ['placed'], to: 'rejected' },
      rejectionHash(command),
      now,
      (order) => this.rejection(order, command, change, now),
    );
  }

  // AP §9.3.2 «رفض نيابة عن المطعم» (RA §8.15): the same rejection by
  // operations, with their reason; the restaurant's devices chime with the
  // rejection's label (RA §16 #6).
  async rejectFor(command: AdminOrderCommand & Rejection, now: Date): Promise<OrderView> {
    const change: MerchantChange = {
      actor: { type: 'admin', id: command.admin.accountId, role: command.admin.roles.join(',') },
      context: command.context,
      reason: command.reason,
    };
    return this.run(
      { kind: 'admin', command },
      { verb: 'reject', from: ['placed'], to: 'rejected' },
      { ...rejectionHash(command), reason: command.reason },
      now,
      (order) => this.rejection(order, command, change, now),
    );
  }

  // CU §11.4: the customer cancels their own order while the restaurant has
  // not answered, with a reason of Content's customer_cancel list (AP
  // Appendix B) and the text «سبب آخر» takes. No food was prepared, no strike
  // applies and the restaurant's unanswered count is left alone (only the
  // automatic cancellation counts). Once the order left placed (the race
  // with acceptance) it answers order_state_changed with the order as it is
  // now. 400 unknown_reason, reason_note_required, reason_note_not_allowed.
  async cancelByCustomer(
    command: CustomerCommand & { reason: string; note: string | null },
    now: Date,
  ): Promise<OrderView> {
    return this.run(
      { kind: 'customer', command },
      { verb: 'cancel', from: ['placed'], to: 'cancelled' },
      { reason: command.reason, note: command.note },
      now,
      async () => {
        let chosen: { code: string; note: string | null };
        try {
          chosen = await this.content.choose('customer_cancel', {
            code: command.reason,
            note: command.note,
          });
        } catch (error) {
          if (!(error instanceof ContentRefusedError)) throw error;
          const refusal =
            error.refusal === 'reason_note_required' || error.refusal === 'reason_note_not_allowed'
              ? error.refusal
              : 'unknown_reason';
          throw new OrderCommandRefusedError(refusal, error.message);
        }
        return {
          // CU §11.9 «ألغيت طلبك»: no customer text of a reason.
          set: {
            cancelledAt: now,
            cancelReason: chosen.code,
            cancelCustomerText: null,
            foodPrepared: false,
          },
          publicReason: chosen.code,
          ...(chosen.note === null ? {} : { eventReason: chosen.note }),
        };
      },
    );
  }

  // AP §9.3.2 «إلغاء الطلب» (slice 2.8b; docs/domain/01, 08, 09; AP §8.1):
  // operations cancel a placed, accepted or ready order with a reason of
  // Content's ops_cancel list, the responsible party, whether food was
  // prepared, «تعويض الكابتن» and the cash answer, and their note (the
  // event row's reason and the audit's; the apps hear only the code). In one
  // transaction: an open offer withdrawn first (dispatch's hook), the order
  // cancelled with the label and the customer text copied, the open pickup
  // request voided, the entries (cancellationEntries), the late-cancellation
  // strike and the audit. The order keeps its captain, who is free at once
  // (CAPTAIN_ACTIVE ends at cancelled). 400 unknown_reason,
  // invalid_cancellation; 409 compensation_not_allowed, captain_pay_unset,
  // cash_answer_required, cash_answer_not_allowed, order_state_changed.
  async cancelFor(
    command: AdminOrderCommand & OpsCancellation & { code: string },
    now: Date,
  ): Promise<OrderView> {
    const choices = choicesOf(command);
    const actor = { type: 'admin' as const, id: command.admin.accountId };
    return this.run(
      { kind: 'admin', command },
      { verb: 'cancel', from: CANCELLABLE, to: 'cancelled' },
      { cancellation: command.code, ...choices, reason: command.reason },
      now,
      async (order) => {
        const { label } = await this.opsReason(command.code);
        const customerText = await this.content.customerText('ops_cancel', command.code);
        const read = await this.cancellationFacts(this.database.db, order, now);
        const result = this.entries(read.facts, choices);
        const [strikes, windowDays] = result.strike
          ? await Promise.all([
              this.settings.get('customer.late_cancel_strikes', { cityId: order.cityId }),
              this.settings.get('customer.late_cancel_window_days', { cityId: order.cityId }),
            ])
          : [0, 0];
        return {
          set: {
            cancelledAt: now,
            cancelReason: command.code,
            cancelReasonLabel: label,
            cancelCustomerText: customerText,
            foodPrepared: choices.foodPrepared,
            cancelResponsible: choices.responsible,
            cancelCash: choices.cash,
            cancelMerchantCredit: result.merchantCredit,
            cancelCaptainCompensation: result.captainCompensation,
          },
          publicReason: command.code,
          // The entries were worked out from the order before the lock.
          guard: async (tx) => (await this.ownFacts(tx, order)).key === read.key,
          before: async (tx) => {
            await this.assignments.beforeCancel(tx, order.id, order.placedAt, actor, now);
            // docs/domain/02: the open request voided below returns the
            // track to at_merchant, which the cancellation publishes.
            await tx
              .update(orders)
              .set({ captainTrack: 'at_merchant' })
              .where(
                and(orderKey(order.id, order.placedAt), eq(orders.captainTrack, 'pickup_pending')),
              );
          },
          effects: async (tx) => {
            await tx
              .update(pickupRequests)
              .set({
                status: 'voided',
                outcome: 'cancelled',
                closedAt: now,
                closedByType: 'admin',
                closedById: actor.id,
                reason: command.reason,
              })
              .where(
                and(
                  eq(pickupRequests.orderId, order.id),
                  eq(pickupRequests.orderPlacedAt, order.placedAt),
                  eq(pickupRequests.status, 'open'),
                ),
              );
            // RA §8.12: the cancellation clears an open item report.
            await tx
              .update(itemReports)
              .set({
                closedAt: now,
                closedHow: 'cancelled',
                closedByType: 'admin',
                closedById: actor.id,
              })
              .where(openReportOf(order.id, order.placedAt));
            await this.postJournals(tx, order, actor, result.journals);
            if (result.strike) {
              await this.customers.recordLateCancel(tx, {
                accountId: read.customerAccountId,
                orderId: order.id,
                cityId: order.cityId,
                at: now,
                strikes,
                windowDays,
              });
            }
          },
        };
      },
    );
  }

  // AP §9.3.2, docs/domain/09: what a cancellation with these choices would
  // book, for the dialog; it writes nothing. It refuses what the choices
  // can never be (invalid_cancellation, captain_pay_unset), not a missing
  // cash answer or a choice the order does not allow: it books what is
  // allowed and answers cashAsked, compensationAllowed and cashLines, which
  // tell the dialog what to ask. The reason is checked only when given.
  async previewCancel(
    orderId: string,
    choices: OpsCancellation & { code: string | null },
    now: Date,
  ): Promise<CancellationPreview> {
    const order = await this.find(orderId, {});
    if (!CANCELLABLE.includes(order.status)) throw await this.stateChanged(order);
    if (choices.code !== null) await this.opsReason(choices.code);
    const { facts } = await this.cancellationFacts(this.database.db, order, now);
    const result = this.entries(facts, choicesOf(choices), { preview: true });
    const entries = result.journals.flatMap((journal) =>
      journal.entries.map((entry) => ({ type: journal.type, ...entry })),
    );
    const [names, captain] = await Promise.all([
      this.merchants.names([order.restaurantId]),
      facts.captainId === null ? null : this.captains.captain(facts.captainId, now),
    ]);
    const name = (party: { kind: string; id: string | null }) =>
      party.kind === 'merchant'
        ? (names.get(order.restaurantId)?.nameAr ?? null)
        : party.kind === 'captain'
          ? (captain?.name ?? null)
          : null;
    return {
      entries: entries.map((entry) => ({
        ...entry,
        party: { ...entry.party, name: name(entry.party) },
      })),
      cashAsked: result.cashAsked,
      compensationAllowed: result.compensationAllowed,
      cashLines: result.cashAsked ? facts.cashLines : null,
      strike: result.strike,
    };
  }

  // AP §9.3.2 «إلغاء الطلب» (slice 2.8c): the reasons the panel's dialog
  // offers, Content's active ops_cancel reasons in order (AP Appendix B).
  // AP §9.3.2 «تعديل الوقت»: the most minutes one change adds.
  async timeChangeChoices(cityId: string): Promise<{ maxMin: number }> {
    return { maxMin: await this.settings.get('order.eta_change_max_min', { cityId }) };
  }

  async cancelReasons(): Promise<{ code: string; label: string }[]> {
    return (await this.content.reasonsOf('ops_cancel'))
      .filter((reason) => reason.active)
      .map(({ code, label }) => ({ code, label }));
  }

  // AP §9.3.1 (slice 2.8c): the label of the customer's own cancel reason,
  // which the order keeps by its code only; a reason removed since still
  // has its label (removing only hides it from new choices).
  async customerCancelLabel(code: string): Promise<string | null> {
    const reasons = await this.content.reasonsOf('customer_cancel');
    return reasons.find((reason) => reason.code === code)?.label ?? null;
  }

  // RA §8.14, §18 (slice 2.8b): «حسناً» on any of the restaurant's devices
  // after operations cancelled an accepted order: the order keeps who and
  // which device, and order.cancellation_acknowledged (cancelled to
  // cancelled) tells every device to drop it and stop ringing. Already
  // acknowledged answers the order quietly; any other order is
  // order_state_changed.
  async acknowledgeCancellation(command: MerchantCommand, now: Date): Promise<OrderView> {
    const key = { accountId: command.accountId, idempotencyKey: command.idempotencyKey };
    const requestHash = commandHash({ verb: 'acknowledge_cancellation', orderId: command.orderId });
    const earlier = await this.replay(this.database.db, key, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const order = await this.find(command.orderId, { restaurantId: command.restaurantId });
    const before = await this.ringing(this.database.db, order);
    if (before === 'acknowledged') return this.read(order);
    if (before === 'not_ringing') throw await this.stateChanged(order);
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(tx, key, requestHash, now)) !== null) return true;
      const state = await this.ringing(tx, order);
      if (state === 'acknowledged') return true;
      if (state === 'not_ringing') return false;
      const version = locked.version + 1;
      await tx
        .update(orders)
        .set({
          version,
          cancelAcknowledgedAt: now,
          cancelAcknowledgedBy: command.accountId,
          cancelAcknowledgedDevice: command.deviceId,
        })
        .where(orderKey(order.id, order.placedAt));
      await recordTransition(tx, this.jobs, locked, {
        type: 'order.cancellation_acknowledged',
        from: 'cancelled',
        to: 'cancelled',
        version,
        actor: { type: 'restaurant', id: command.accountId, device: command.deviceId },
        reason: null,
        at: now,
      });
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(order);
    return this.read(order);
  }

  // Whether the order rings for «حسناً»: cancelled by operations (only
  // their path keeps the label) after acceptance.
  private async ringing(
    executor: Pick<Database['db'], 'select'>,
    order: { id: string; placedAt: Date },
  ): Promise<'ringing' | 'acknowledged' | 'not_ringing'> {
    const [row] = await executor
      .select({
        status: orders.status,
        acceptedAt: orders.acceptedAt,
        label: orders.cancelReasonLabel,
        acknowledgedAt: orders.cancelAcknowledgedAt,
      })
      .from(orders)
      .where(orderKey(order.id, order.placedAt));
    if (!row || row.status !== 'cancelled' || row.acceptedAt === null || row.label === null) {
      return 'not_ringing';
    }
    return row.acknowledgedAt === null ? 'ringing' : 'acknowledged';
  }

  // The ops_cancel reason and its label; a note is not allowed by the list.
  private async opsReason(code: string): Promise<{ label: string }> {
    try {
      return await this.content.choose('ops_cancel', { code, note: null });
    } catch (error) {
      if (!(error instanceof ContentRefusedError)) throw error;
      throw new OrderCommandRefusedError('unknown_reason', error.message);
    }
  }

  private entries(
    facts: CancellationFacts,
    choices: CancellationChoices,
    options: { preview?: boolean } = {},
  ) {
    const result = cancellationEntries(facts, choices, options);
    if ('problem' in result) {
      throw new OrderCommandRefusedError(result.problem, `the cancellation is ${result.problem}`);
    }
    return result;
  }

  // What the cancellation's entries depend on: the order's own rows, read
  // again under the lock (the key), and the captain's base pay for their
  // vehicle, read before the transaction.
  private async cancellationFacts(
    executor: Pick<Database['db'], 'select'>,
    order: OrderAtStart,
    now: Date,
  ): Promise<{ facts: CancellationFacts; key: string; customerAccountId: string }> {
    const own = await this.ownFacts(executor, order);
    const { row } = own;
    let captainPay: bigint | null = null;
    if (row.captainId !== null && row.payTableId !== null) {
      const captain = await this.captains.captain(row.captainId, now);
      if (!captain) throw new Error(`captain ${row.captainId} not found`);
      const parts = await this.captains.payParts(
        row.payTableId,
        captain.vehicle,
        row.tripMetres ?? 0,
        0,
      );
      captainPay = parts?.base ?? null;
    }
    const snapshot = snapshotOf(row.rateSnapshot);
    // Owner decision 2026-11-09: the captain's last request's lines (what the
    // restaurant says it received when it disputed the amount), else the
    // items value in the base currency.
    const cashLines = own.request
      ? linesOf(
          own.request.outcome === 'amount_incorrect'
            ? own.request.receivedLines
            : own.request.lines,
        )
      : [{ currency: row.currency, amount: row.itemsValue }];
    return {
      key: own.key,
      customerAccountId: row.customerAccountId,
      facts: {
        status: row.status as CancellationFacts['status'],
        restaurantId: row.restaurantId,
        captainId: row.captainId,
        arrivedAtMerchant: row.arrivedAtMerchantAt !== null,
        currency: row.currency,
        itemsValue: row.itemsValue,
        discount: row.discount,
        commissionBp: row.commissionBp,
        testOrder: row.testOrder,
        cashLines,
        cashBase: baseTotal(snapshot, cashLines),
        captainPay,
      },
    };
  }

  private async ownFacts(
    executor: Pick<Database['db'], 'select'>,
    order: { id: string; placedAt: Date },
  ) {
    const [row] = await executor
      .select({
        status: orders.status,
        customerAccountId: orders.customerAccountId,
        restaurantId: orders.restaurantId,
        captainId: orders.captainId,
        arrivedAtMerchantAt: orders.arrivedAtMerchantAt,
        currency: orders.currency,
        itemsValue: orders.itemsValue,
        discount: orders.discount,
        commissionBp: orders.commissionBp,
        testOrder: orders.testOrder,
        payTableId: orders.payTableId,
        tripMetres: orders.tripMetres,
        rateSnapshot: orders.rateSnapshot,
      })
      .from(orders)
      .where(orderKey(order.id, order.placedAt));
    if (!row) throw new Error(`order ${order.id} not found`);
    const [request] = await executor
      .select({
        id: pickupRequests.id,
        status: pickupRequests.status,
        outcome: pickupRequests.outcome,
        lines: pickupRequests.lines,
        receivedLines: pickupRequests.receivedLines,
      })
      .from(pickupRequests)
      .where(
        and(eq(pickupRequests.orderId, order.id), eq(pickupRequests.orderPlacedAt, order.placedAt)),
      )
      .orderBy(desc(pickupRequests.openedAt))
      .limit(1);
    const key = JSON.stringify([
      row.status,
      row.captainId,
      row.arrivedAtMerchantAt?.toISOString() ?? null,
      request ? [request.id, request.status, request.outcome] : null,
    ]);
    return { row, request: request ?? null, key };
  }

  private async rejection(
    order: OrderAtStart,
    rejection: Rejection,
    change: MerchantChange,
    now: Date,
  ): Promise<Change> {
    const view = await this.read(order);
    const problem = rejectionProblem(
      rejection,
      view.lines.map((line) => line.itemId),
    );
    if (problem !== null) {
      throw problem === 'unknown_reason'
        ? new OrderCommandRefusedError('unknown_reason', `${rejection.code} is not a reason`)
        : new OrderCommandRefusedError('invalid_rejection', problem);
    }
    const reason = rejection.code as RejectionReason;
    let label: string;
    try {
      ({ label } = await this.content.choose('merchant_rejection', { code: reason, note: null }));
    } catch (error) {
      if (!(error instanceof ContentRefusedError)) throw error;
      throw new OrderCommandRefusedError('unknown_reason', error.message);
    }
    const names = [
      ...new Set(
        view.lines
          .filter((line) => rejection.items.some((item) => item.itemId === line.itemId))
          .map((line) => line.name),
      ),
    ];
    const customerText = (await this.content.customerText('merchant_rejection', reason)).replace(
      '{الأصناف}',
      names.join('، '),
    );
    if (rejection.busyExtraMin !== null) {
      const options = await this.settings.get('merchant.busy_extra_options_min', {
        cityId: order.cityId,
      });
      if (!options.includes(rejection.busyExtraMin)) {
        throw new OrderCommandRefusedError(
          'invalid_rejection',
          `busy mode adds one of ${options.join(', ')} minutes`,
        );
      }
    }
    const ends = new Map<string, Date | null>();
    for (const until of new Set(rejection.items.map((item) => item.until))) {
      ends.set(until, await this.merchants.switchedOffUntil(order.restaurantId, until, now));
    }
    const { restaurantId } = order;
    return {
      set: {
        rejectedAt: now,
        rejectReason: reason,
        rejectReasonLabel: label,
        rejectCustomerText: customerText,
        rejectItemIds: rejection.items.map((item) => item.itemId),
      },
      publicReason: reason,
      effects: async (tx) => {
        if (reason === 'item_unavailable') {
          const switches = rejection.items.map((item) => ({
            itemId: item.itemId,
            until: ends.get(item.until) ?? null,
          }));
          await this.merchants.switchOffForRejection(tx, restaurantId, switches, change, now);
        } else if (reason === 'restaurant_closed') {
          await this.status.afterRejection(tx, restaurantId, { pauseMin: null }, change, now);
        } else if (rejection.busyExtraMin !== null) {
          const effect = { busyExtraMin: rejection.busyExtraMin };
          await this.status.afterRejection(tx, restaurantId, effect, change, now);
        } else if (rejection.pauseMin !== null) {
          const effect = { pauseMin: rejection.pauseMin };
          await this.status.afterRejection(tx, restaurantId, effect, change, now);
        }
      },
    };
  }

  // RA §8.5: the acceptance's columns and its search start.
  private async acceptance(order: OrderAtStart, prepMin: number, now: Date): Promise<Change> {
    const { cityId } = order;
    const [floor, ceiling, bufferMin, speedKmh, searchBufferMin, prepLateMin] = await Promise.all([
      this.settings.get('merchant.prep_time_floor_min', { cityId }),
      this.settings.get('merchant.prep_time_ceiling_min', { cityId }),
      this.settings.get('order.eta_buffer_min', { cityId }),
      this.settings.get('order.eta_speed_kmh', { cityId }),
      this.settings.get('dispatch.search_start_buffer_min', { cityId }),
      this.settings.get('order.prep_late_ops_alert_min', { cityId }),
    ]);
    if (!Number.isInteger(prepMin) || prepMin < floor || prepMin > ceiling) {
      throw new OrderCommandRefusedError(
        'invalid_prep_time',
        `the prep time is whole minutes from ${floor} to ${ceiling}`,
      );
    }
    const prepDue = now.getTime() + prepMin * MINUTE_MS;
    // An order placed before slice 1.10 kept no trip.
    const promisedAt = new Date(
      Math.ceil(
        (prepDue + (order.tripSeconds ?? 0) * 1000 + bufferMin * MINUTE_MS) / PROMISE_STEP_MS,
      ) * PROMISE_STEP_MS,
    );
    const etaMs = await this.nearestCaptainEta(order, speedKmh, now);
    // Owner decision 2026-11-06: once, at acceptance; at once when the
    // moment has passed or no captain is online.
    const searchStartAt = new Date(
      etaMs === null
        ? now.getTime()
        : Math.max(now.getTime(), Math.round(prepDue - etaMs - searchBufferMin * MINUTE_MS)),
    );
    return {
      set: {
        acceptedAt: now,
        prepMin,
        promisedAt,
        searchStartAt,
        prepLateAlertAt: new Date(prepDue + prepLateMin * MINUTE_MS),
      },
      searchStartAt,
    };
  }

  // RA §8.8: an accepted order becomes ready, early or late, with no undo.
  // No captain is ever assigned yet, so operations' no-captain moment is set
  // at dispatch.no_captain_after_ready_min (AP §8.3). A ready order has no
  // prep time left, so a search start still ahead moves to now (AP §9.12.6),
  // with its timer.
  async ready(command: MerchantCommand, now: Date): Promise<OrderView> {
    return this.run(
      { kind: 'restaurant', command },
      { verb: 'ready', from: ['accepted'], to: 'ready' },
      {},
      now,
      async (order) => {
        const noCaptainMin = await this.settings.get('dispatch.no_captain_after_ready_min', {
          cityId: order.cityId,
        });
        const early = order.searchStartAt !== null && order.searchStartAt.getTime() > now.getTime();
        return {
          set: {
            readyAt: now,
            noCaptainAlertAt: new Date(now.getTime() + noCaptainMin * MINUTE_MS),
            ...(early ? { searchStartAt: now } : {}),
          },
          ...(early ? { searchStartAt: now } : {}),
        };
      },
    );
  }

  // AP §9.3.2 «تعديل الوقت» (owner decision 2026-11-10): operations add
  // whole minutes, from 1 to order.eta_change_max_min, to an accepted, ready
  // or picked-up order. The promised time moves by them, rounded up to the
  // next 5 minutes (docs/domain/03). While the food is still being prepared
  // (accepted) the prep time moves too: the restaurant's countdown, the
  // prep-late moment and a search start still ahead, with its timer. The
  // customer hears the new time (CU §14 #12) and, when the prep time moved,
  // the restaurant the new prep time (RA §16 #12). The note is optional.
  // 400 invalid_time_change; 409 order_state_changed.
  async changeTime(
    command: Omit<AdminOrderCommand, 'reason'> & { reason: string | null; addMin: number },
    now: Date,
  ): Promise<OrderView> {
    return this.run(
      { kind: 'admin', command },
      { verb: 'change_time', from: TIME_CHANGEABLE, to: null, event: 'order.time_changed' },
      { addMin: command.addMin, reason: command.reason },
      now,
      async (order) => {
        const maxMin = await this.settings.get('order.eta_change_max_min', {
          cityId: order.cityId,
        });
        if (!Number.isInteger(command.addMin) || command.addMin < 1 || command.addMin > maxMin) {
          throw new OrderCommandRefusedError(
            'invalid_time_change',
            `the minutes added are whole minutes from 1 to ${maxMin}`,
          );
        }
        const times = await this.times(this.database.db, order);
        const add = command.addMin * MINUTE_MS;
        const promisedAt = new Date(
          Math.ceil((times.promisedAt.getTime() + add) / PROMISE_STEP_MS) * PROMISE_STEP_MS,
        );
        const preparing = times.status === 'accepted';
        const prepMin = preparing ? times.prepMin + command.addMin : times.prepMin;
        // A search already started, or due now, stays as it is.
        const searchStartAt =
          preparing &&
          times.searchStartedAt === null &&
          times.searchStartAt.getTime() > now.getTime()
            ? new Date(times.searchStartAt.getTime() + add)
            : undefined;
        return {
          set: {
            promisedAt,
            ...(preparing
              ? { prepMin, prepLateAlertAt: new Date(times.prepLateAlertAt.getTime() + add) }
              : {}),
            ...(searchStartAt ? { searchStartAt } : {}),
          },
          ...(searchStartAt ? { searchStartAt } : {}),
          // The apps hear whether the prep time moved (RA §16 #12).
          publicReason: preparing ? 'prep_time_changed' : 'promised_time_changed',
          // The times were read before the lock.
          guard: async (tx) => sameTimes(await this.times(tx, order), times),
          effects: async (tx) => {
            await tx.insert(timeChanges).values({
              orderId: order.id,
              orderPlacedAt: order.placedAt,
              cityId: order.cityId,
              at: now,
              adminId: command.admin.accountId,
              addMin: command.addMin,
              promisedBefore: times.promisedAt,
              promisedAfter: promisedAt,
              prepMinBefore: times.prepMin,
              prepMinAfter: prepMin,
            });
          },
          audit: {
            before: { promisedAt: times.promisedAt.toISOString(), prepMin: times.prepMin },
            after: {
              promisedAt: promisedAt.toISOString(),
              prepMin,
            },
          },
        };
      },
    );
  }

  // RA §8.12 «صنف غير متوفر — اتصلوا بالزبون»: on an accepted or ready order
  // without an open pickup request (RA §8.10) or another open report, the
  // restaurant reports one or more of the order's items, each «حتى الغد» or
  // «حتى أعيده», with an optional note. In one transaction: the report, the
  // items switched off in the menu (RA §9.3, audited as the restaurant's own
  // switch) and the event order.item_reported, which raises operations'
  // critical alert (AP §9.1.3) and tells the customer FOX DROP will call (CU
  // §11.6, §14 #10). The pickup waits until the report is closed. 400
  // invalid_item_report; 409 order_state_changed.
  async reportItems(
    command: MerchantCommand & { items: ReportedItem[]; note: string | null },
    now: Date,
  ): Promise<OrderView> {
    const change = merchantChange(command);
    return this.run(
      { kind: 'restaurant', command },
      { verb: 'report_item', from: REPORTABLE, to: null, event: 'order.item_reported' },
      { items: command.items, note: command.note },
      now,
      async (order) => {
        const view = await this.read(order);
        const problem = itemReportProblem(
          command.items,
          view.lines.map((line) => line.itemId),
        );
        if (problem !== null) throw new OrderCommandRefusedError('invalid_item_report', problem);
        let note: ItemReportNote | null = null;
        if (command.note !== null) {
          try {
            const chosen = await this.content.choose('item_unavailable_note', {
              code: command.note,
              note: null,
            });
            note = { code: chosen.code, label: chosen.label };
          } catch (error) {
            if (!(error instanceof ContentRefusedError)) throw error;
            throw new OrderCommandRefusedError('unknown_reason', error.message);
          }
        }
        const switches = await Promise.all(
          command.items.map(async (item) => ({
            itemId: item.itemId,
            until: await this.merchants.switchedOffUntil(order.restaurantId, item.until, now),
          })),
        );
        return {
          set: {},
          // RA §8.12: no pickup request open and no report open, under the lock.
          guard: async (tx) => {
            const [row] = await tx
              .select({ captainTrack: orders.captainTrack })
              .from(orders)
              .where(orderKey(order.id, order.placedAt));
            return (
              row?.captainTrack !== 'pickup_pending' &&
              (await openItemReport(tx, order.id, order.placedAt)) === null
            );
          },
          effects: async (tx) => {
            await tx.insert(itemReports).values({
              orderId: order.id,
              orderPlacedAt: order.placedAt,
              cityId: order.cityId,
              items: command.items.map(({ itemId, until }) => ({ itemId, until })),
              note: note?.code ?? null,
              noteLabel: note?.label ?? null,
              accountId: command.accountId,
              device: command.deviceId,
              reportedAt: now,
            });
            await this.merchants.switchOffForRejection(
              tx,
              order.restaurantId,
              switches,
              change,
              now,
            );
          },
        };
      },
    );
  }

  // RA §8.12 «تراجع — الصنف متوفر»: before operations act, the restaurant
  // withdraws its open report; the items are switched on again and the
  // pickup is free. 409 order_state_changed without an open report.
  async withdrawItemReport(command: MerchantCommand, now: Date): Promise<OrderView> {
    const change = merchantChange(command);
    return this.run(
      { kind: 'restaurant', command },
      {
        verb: 'withdraw_item_report',
        from: REPORTABLE,
        to: null,
        event: 'order.item_report_withdrawn',
      },
      {},
      now,
      async (order) => {
        const report = await openItemReport(this.database.db, order.id, order.placedAt);
        if (report === null) throw await this.stateChanged(order);
        return {
          set: {},
          guard: async (tx) =>
            (await openItemReport(tx, order.id, order.placedAt))?.id === report.id,
          effects: async (tx) => {
            await tx
              .update(itemReports)
              .set({
                closedAt: now,
                closedHow: 'withdrawn',
                closedByType: 'restaurant',
                closedById: command.accountId,
              })
              .where(eq(itemReports.id, report.id));
            await this.merchants.switchOnItems(
              tx,
              order.restaurantId,
              report.items.map((item) => item.itemId),
              change,
              now,
            );
          },
        };
      },
    );
  }

  // AP §9.3.2 «إغلاق بلاغ صنف نفد»: operations close the open report without
  // an edit (the restaurant found the item, for example), with their
  // required reason, which the restaurant's devices chime with (RA §16 #37).
  // The menu is left as it is. 409 order_state_changed without an open
  // report.
  async closeItemReport(command: AdminOrderCommand, now: Date): Promise<OrderView> {
    return this.run(
      { kind: 'admin', command },
      { verb: 'close_item_report', from: REPORTABLE, to: null, event: 'order.item_report_closed' },
      { reason: command.reason },
      now,
      async (order) => {
        const report = await openItemReport(this.database.db, order.id, order.placedAt);
        if (report === null) throw await this.stateChanged(order);
        return {
          set: {},
          // RA §16 #37 shows the restaurant operations' reason.
          publicReason: command.reason,
          guard: async (tx) =>
            (await openItemReport(tx, order.id, order.placedAt))?.id === report.id,
          effects: async (tx) => {
            await tx
              .update(itemReports)
              .set({
                closedAt: now,
                closedHow: 'closed',
                closedByType: 'admin',
                closedById: command.admin.accountId,
                closeReason: command.reason,
              })
              .where(eq(itemReports.id, report.id));
          },
        };
      },
    );
  }

  // AP §9.3.3 «تعديل الطلب» before the pickup (slice 2.10a; owner decisions
  // 2026-11-10): the lines kept with their quantities (a raised quantity
  // keeps the line's unit price), the lines added from the current menu at
  // current prices, a new delivery fee or the same, and for items added to a
  // ready order the extra prep time, which sends it back to accepted with the
  // restaurant's countdown from now and the promised time moved by the same
  // minutes, rounded up to the next 5. The money is recalculated from the
  // order's snapshot (pickup payment, commission and merchant net follow the
  // items value). In one transaction: the edit row, the lines, an open item
  // report closed `edited` (RA §8.12), the order and order.edited, which
  // rings the restaurant when items were added (RA §16 #16) and tells the
  // customer the new total (CU §14 #11). 400 invalid_edit; 409
  // pickup_request_open, order_state_changed.
  //
  // After the pickup (slice 2.10b, AP §9.3.3, docs/domain/09): only lines
  // removed or lowered and a lower fee, with the responsible party, who bears
  // it in entries posted with the edit (`afterPickupEntries`); no prompt to
  // acknowledge, and order.edited publishes removed_after_pickup or
  // fee_lowered_after_pickup.
  async editOrder(
    command: AdminOrderCommand & EditRequest & { version: number },
    now: Date,
  ): Promise<OrderView> {
    const request: EditRequest = {
      keep: command.keep,
      add: command.add,
      deliveryFee: command.deliveryFee,
      extraPrepMin: command.extraPrepMin,
      responsible: command.responsible,
    };
    const actor = { type: 'admin' as const, id: command.admin.accountId };
    return this.run(
      { kind: 'admin', command },
      { verb: 'edit', from: EDITABLE, to: null, event: 'order.edited' },
      {
        keep: request.keep,
        add: request.add,
        deliveryFee: request.deliveryFee?.toString() ?? null,
        extraPrepMin: request.extraPrepMin,
        responsible: request.responsible,
        version: command.version,
      },
      now,
      async (order) => {
        const edit = await this.prepareEdit(order, request, now, { version: command.version });
        // AP §9.3.3: the edit is the one previewed on the order as the
        // dialog showed it; any change since is order_state_changed.
        if (edit.version !== command.version) throw await this.stateChanged(order);
        const { plan, before, after, times, booking } = edit;
        const editId = randomUUID();
        return {
          set: {
            itemsValue: after.itemsValue,
            deliveryFee: after.deliveryFee,
            rounding: after.rounding,
            total: after.total,
            ...(times
              ? {
                  readyAt: null,
                  noCaptainAlertAt: null,
                  prepMin: times.prepMinAfter,
                  prepLateAlertAt: times.prepLateAlertAt,
                  promisedAt: times.promisedAfter,
                }
              : {}),
          },
          ...(times ? { to: 'accepted' as const } : {}),
          publicReason: booking
            ? plan.changes.length > 0
              ? 'removed_after_pickup'
              : 'fee_lowered_after_pickup'
            : times
              ? 'items_added_back_to_preparing'
              : plan.addsItems
                ? 'items_added'
                : 'changed',
          guard: async (tx) =>
            (await this.editBasis(tx, order)) === edit.basis &&
            (await lockOrder(tx, order.id, order.placedAt))?.version === command.version,
          effects: async (tx) => {
            await tx.insert(orderEdits).values({
              id: editId,
              orderId: order.id,
              orderPlacedAt: order.placedAt,
              cityId: order.cityId,
              at: now,
              adminId: command.admin.accountId,
              status: edit.status,
              changes: plan.changes,
              addsItems: plan.addsItems,
              currency: edit.currency,
              itemsValueBefore: before.itemsValue,
              itemsValueAfter: after.itemsValue,
              deliveryFeeBefore: before.deliveryFee,
              deliveryFeeAfter: after.deliveryFee,
              totalBefore: before.total,
              totalAfter: after.total,
              ...(booking
                ? {
                    responsible: request.responsible,
                    charge: booking.charge,
                    commissionCut: booking.commissionCut,
                  }
                : {}),
              ...(times
                ? {
                    extraPrepMin: times.extraPrepMin,
                    prepMinBefore: times.prepMinBefore,
                    prepMinAfter: times.prepMinAfter,
                    promisedBefore: times.promisedBefore,
                    promisedAfter: times.promisedAfter,
                  }
                : {}),
            });
            const line = (position: number) =>
              and(
                eq(orderLines.orderId, order.id),
                eq(orderLines.orderPlacedAt, order.placedAt),
                eq(orderLines.position, position),
              );
            for (const update of plan.updates) {
              await tx
                .update(orderLines)
                .set({
                  quantity: update.quantity,
                  lineTotal: update.lineTotal,
                  quantityBefore: update.quantityBefore,
                })
                .where(line(update.position));
            }
            for (const position of plan.removals) {
              await tx.update(orderLines).set({ removedByEdit: editId }).where(line(position));
            }
            if (plan.additions.length > 0) {
              await tx.insert(orderLines).values(
                plan.additions.map((addition, index) => ({
                  orderId: order.id,
                  orderPlacedAt: order.placedAt,
                  position: edit.nextPosition + index,
                  cityId: order.cityId,
                  itemId: addition.itemId,
                  itemName: addition.name,
                  quantity: addition.quantity,
                  options: addition.options.map((option) => ({
                    id: option.id,
                    name: option.name,
                    priceDelta: option.priceDelta.toString(),
                  })),
                  unitPrice: addition.unitPrice,
                  lineTotal: addition.lineTotal,
                  note: null,
                  addedByEdit: editId,
                })),
              );
            }
            // RA §8.12: an edit clears an open item report.
            await tx
              .update(itemReports)
              .set({
                closedAt: now,
                closedHow: 'edited',
                closedByType: 'admin',
                closedById: command.admin.accountId,
              })
              .where(
                and(
                  eq(itemReports.orderId, order.id),
                  eq(itemReports.orderPlacedAt, order.placedAt),
                  isNull(itemReports.closedAt),
                ),
              );
            if (booking) await this.postJournals(tx, order, actor, booking.journals);
          },
          audit: {
            before: { money: moneyAudit(before) },
            after: {
              money: moneyAudit(after),
              changes: plan.changes,
              ...(booking
                ? { responsible: request.responsible, charge: booking.charge.toString() }
                : {}),
            },
          },
        };
      },
    );
  }

  // AP §9.3.3: the edit dialog's before-and-after money preview; it writes
  // nothing, so it takes no key. 400 invalid_edit; 409 pickup_request_open,
  // order_state_changed.
  async previewEdit(orderId: string, request: EditRequest, now: Date): Promise<EditPreview> {
    const order = await this.find(orderId, {});
    if (!EDITABLE.includes(order.status)) throw await this.stateChanged(order);
    const { plan, before, after, times, commissionOf, booking, captainId } = await this.prepareEdit(
      order,
      request,
      now,
      { preview: true },
    );
    const entries = (booking?.journals ?? []).flatMap((journal) =>
      journal.entries.map((entry) => ({ type: journal.type, reason: journal.reason, ...entry })),
    );
    const [names, captain] =
      entries.length === 0
        ? [null, null]
        : await Promise.all([
            this.merchants.names([order.restaurantId]),
            captainId === null ? null : this.captains.captain(captainId, now),
          ]);
    const name = (party: { kind: string }) =>
      party.kind === 'merchant'
        ? (names?.get(order.restaurantId)?.nameAr ?? null)
        : party.kind === 'captain'
          ? (captain?.name ?? null)
          : null;
    const side = (money: QuoteMoney) => {
      const cut = commissionOf(money.itemsValue);
      return { ...money, commission: cut, merchantNet: money.itemsValue - cut };
    };
    let sides = { before: side(before), after: side(after) };
    if (AFTER_PICKUP.includes(order.status)) {
      // AP §9.3.3: after the pickup the commission's base is frozen; the
      // restaurant keeps the pickup payment less the commission and its own
      // edits' debits, and only an edit it bears changes them.
      const frozen = await frozenAtPickup(this.database.db, {
        id: order.id,
        placedAt: order.placedAt,
        itemsValue: before.itemsValue,
        deliveryFee: before.deliveryFee,
      });
      const ownCut = request.responsible === 'restaurant' && booking ? booking.commissionCut : 0n;
      const ownCharge = request.responsible === 'restaurant' && booking ? booking.charge : 0n;
      const commissionBefore = commissionOf(frozen.itemsValue) - frozen.restaurantCommissionCut;
      const netBefore = frozen.itemsValue - commissionBefore - frozen.restaurantCharge;
      sides = {
        before: { ...before, commission: commissionBefore, merchantNet: netBefore },
        after: {
          ...after,
          commission: commissionBefore - ownCut,
          merchantNet: netBefore + ownCut - ownCharge,
        },
      };
    }
    return {
      ...sides,
      changes: plan.changes,
      addsItems: plan.addsItems,
      backToPreparing: times !== null,
      promisedAt: times?.promisedAfter ?? null,
      afterPickup: AFTER_PICKUP.includes(order.status),
      entries: entries.map((entry) => ({
        ...entry,
        party: { ...entry.party, name: name(entry.party) },
      })),
    };
  }

  // The journals of an order's change, posted in its transaction, all with
  // the order as their source (E3).
  private async postJournals(
    tx: Tx,
    order: { id: string; cityId: string },
    actor: { type: 'admin'; id: string },
    journals: AfterPickupJournal[],
  ): Promise<void> {
    for (const journal of journals) {
      const entries = [];
      for (const entry of journal.entries) {
        const accountId = await this.ledger.openAccount(
          {
            cityId: order.cityId,
            purpose: entry.account,
            ownerId: entry.party.id,
            currency: entry.currency,
          },
          tx,
        );
        entries.push({ accountId, currency: entry.currency, amount: entry.amount });
      }
      await this.ledger.post(
        {
          cityId: order.cityId,
          type: journal.type,
          source: { kind: 'order', id: order.id },
          actor,
          reason: journal.reason,
          entries,
        },
        tx,
      );
    }
  }

  // AP §9.3.3: what the edit dialog offers: the items customers can order
  // now from the restaurant's menu, with their option groups, and the extra
  // prep time of a ready order, whole minutes from 1 to
  // order.eta_change_max_min.
  async editChoices(
    order: { cityId: string; restaurantId: string; status: OrderView['status'] },
    now: Date,
  ) {
    // AP §9.3.3: after the pickup nothing is added, so no menu.
    const afterPickup = AFTER_PICKUP.includes(order.status);
    if (afterPickup) return { afterPickup, extraPrepMaxMin: 0, items: [] };
    const [extraPrepMaxMin, menu] = await Promise.all([
      this.settings.get('order.eta_change_max_min', { cityId: order.cityId }),
      this.merchants.menu(order.restaurantId, now),
    ]);
    const items = menu.categories
      .filter((category) => !category.hidden)
      .flatMap((category) =>
        category.items
          .filter((item) => !item.hidden && item.available)
          .map((item) => ({
            id: item.id,
            name: item.name,
            category: category.name,
            price: item.price.amount,
            optionGroups: item.optionGroups.map((group) => ({
              id: group.id,
              name: group.name,
              minChoices: group.minChoices,
              maxChoices: group.maxChoices,
              options: group.options
                .filter((option) => option.available)
                .map((option) => ({
                  id: option.id,
                  name: option.name,
                  priceDelta: option.priceDelta.amount,
                })),
            })),
          })),
      );
    return { afterPickup, extraPrepMaxMin, items };
  }

  // AP §9.3.1: the order's edits, oldest first, for the detail.
  async editsOf(order: { id: string; placedAt: Date }) {
    return this.database.db
      .select()
      .from(orderEdits)
      .where(and(eq(orderEdits.orderId, order.id), eq(orderEdits.orderPlacedAt, order.placedAt)))
      .orderBy(orderEdits.at);
  }

  // RA §8.13 «اطلعت على التعديل» on any device: every edit of the order not
  // yet acknowledged, with the user and the device; order.edit_acknowledged
  // (the status unchanged) stops the ring on every device and frees the
  // captain's pickup request. Nothing to acknowledge, or an order past its
  // pickup, is 409 order_state_changed.
  async acknowledgeEdits(
    command: MerchantCommand & { through: Date },
    now: Date,
  ): Promise<OrderView> {
    const key = { accountId: command.accountId, idempotencyKey: command.idempotencyKey };
    const requestHash = commandHash({
      verb: 'acknowledge_edit',
      orderId: command.orderId,
      through: command.through.toISOString(),
    });
    const earlier = await this.replay(this.database.db, key, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const order = await this.find(command.orderId, { restaurantId: command.restaurantId });
    // Only the edits the prompt showed: a newer one keeps ringing.
    const waiting = async (executor: Pick<Database['db'], 'select'>) =>
      (await pendingEdits(executor, [order]))
        .filter((edit) => edit.at.getTime() <= command.through.getTime())
        .map((edit) => edit.id);
    if (!BEFORE_PICKUP.includes(order.status) || (await waiting(this.database.db)).length === 0) {
      throw await this.stateChanged(order);
    }
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      if ((await this.replay(tx, key, requestHash, now)) !== null) return true;
      if (!BEFORE_PICKUP.includes(locked.status)) return false;
      const ids = await waiting(tx);
      if (ids.length === 0) return false;
      await tx
        .update(orderEdits)
        .set({
          acknowledgedAt: now,
          acknowledgedBy: command.accountId,
          acknowledgedDevice: command.deviceId,
        })
        .where(inArray(orderEdits.id, ids));
      const version = locked.version + 1;
      await tx.update(orders).set({ version }).where(orderKey(order.id, order.placedAt));
      await recordTransition(tx, this.jobs, locked, {
        type: 'order.edit_acknowledged',
        from: locked.status,
        to: locked.status,
        version,
        actor: { type: 'restaurant', id: command.accountId, device: command.deviceId },
        reason: null,
        at: now,
      });
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(order);
    return this.read(order);
  }

  // The edit worked out from the order as it is, before the lock: its plan,
  // the money before and after, and the times of a ready order sent back to
  // accepted; `basis` is what the guard compares under the lock.
  private async prepareEdit(
    order: OrderAtStart,
    request: EditRequest,
    now: Date,
    { preview = false, version }: { preview?: boolean; version?: number } = {},
  ) {
    const [row] = await this.database.db
      .select({
        status: orders.status,
        version: orders.version,
        captainId: orders.captainId,
        captainTrack: orders.captainTrack,
        currency: orders.currency,
        discount: orders.discount,
        deliveryFee: orders.deliveryFee,
        rateSnapshot: orders.rateSnapshot,
        commissionBp: orders.commissionBp,
        testOrder: orders.testOrder,
      })
      .from(orders)
      .where(orderKey(order.id, order.placedAt));
    if (!row || !EDITABLE.includes(row.status)) throw await this.stateChanged(order);
    // AP §9.3.3: the edit is the one previewed; an order that moved since
    // (picked up under the dialog, say) is order_state_changed first.
    if (version !== undefined && row.version !== version) throw await this.stateChanged(order);
    const afterPickup = AFTER_PICKUP.includes(row.status);
    // AP §9.3.3: after the pickup an edit names who bears it; before, none.
    // The preview may come before the dialog's party is chosen.
    if (afterPickup ? request.responsible === null && !preview : request.responsible !== null) {
      throw new OrderCommandRefusedError(
        'invalid_edit',
        afterPickup
          ? 'an edit after the pickup needs the responsible party'
          : 'only an edit after the pickup has a responsible party',
      );
    }
    // RA §8.10: no edit while the captain's pickup request is open.
    if (row.captainTrack === 'pickup_pending') {
      throw new OrderCommandRefusedError(
        'pickup_request_open',
        'a pickup request is open',
        await this.read(order),
      );
    }
    const basis = await this.editBasis(this.database.db, order);
    const view = await this.read(order);
    const allLines = await this.database.db
      .select({ position: orderLines.position, quantityBefore: orderLines.quantityBefore })
      .from(orderLines)
      .where(and(eq(orderLines.orderId, order.id), eq(orderLines.orderPlacedAt, order.placedAt)));
    const current: CurrentLine[] = view.lines.map((line) => ({
      ...line,
      quantityBefore:
        allLines.find((entry) => entry.position === line.position)?.quantityBefore ?? null,
    }));
    const menu = await this.merchants.menu(order.restaurantId, now);
    const priced = priceLines(
      menu,
      request.add.map((line) => ({
        itemId: line.itemId,
        optionIds: line.optionIds,
        quantity: line.quantity,
        note: null,
        knownUnitPrice: 0n,
      })),
      row.currency,
    );
    const plan = planEdit(current, request, priced, { afterPickup });
    if (typeof plan === 'string') throw new OrderCommandRefusedError('invalid_edit', plan);
    const deliveryFee = request.deliveryFee ?? row.deliveryFee;
    if (deliveryFee < 0n) {
      throw new OrderCommandRefusedError('invalid_edit', 'the delivery fee is not negative');
    }
    if (afterPickup && deliveryFee > row.deliveryFee) {
      throw new OrderCommandRefusedError(
        'invalid_edit',
        'after the pickup the delivery fee can only be lowered',
      );
    }
    if (plan.changes.length === 0 && deliveryFee === row.deliveryFee) {
      throw new OrderCommandRefusedError('invalid_edit', 'the edit changes nothing');
    }
    const backToPreparing = row.status === 'ready' && plan.addsItems;
    const maxMin = await this.settings.get('order.eta_change_max_min', { cityId: order.cityId });
    const extra = request.extraPrepMin;
    if (backToPreparing) {
      if (extra === null || !Number.isInteger(extra) || extra < 1 || extra > maxMin) {
        throw new OrderCommandRefusedError(
          'invalid_edit',
          `items added to a ready order need the extra prep time, whole minutes from 1 to ${maxMin}`,
        );
      }
    } else if (extra !== null) {
      throw new OrderCommandRefusedError(
        'invalid_edit',
        'the extra prep time is for items added to a ready order',
      );
    }
    const snapshot = snapshotOf(row.rateSnapshot);
    const base = snapshot.currencies.find((entry) => entry.code === snapshot.baseCurrency);
    const after = quoteMoney({
      itemsValue: plan.itemsValue,
      deliveryFee,
      // Codes wait for Phase 2: the discount stays as placed (AP §9.3.3).
      discount: row.discount,
      rounding: base ? { unitMinor: base.roundingUnitMinor, mode: base.roundingMode } : null,
    });
    let times: EditTimes | null = null;
    if (backToPreparing && extra !== null && view.acceptance) {
      const at = await this.times(this.database.db, order);
      const acceptedAt = view.acceptance.at.getTime();
      // RA §8.13: the restaurant gets the extra minutes from now.
      const prepMinAfter = Math.ceil((now.getTime() - acceptedAt) / MINUTE_MS) + extra;
      const lateAfterDue = at.prepLateAlertAt.getTime() - (acceptedAt + at.prepMin * MINUTE_MS);
      times = {
        extraPrepMin: extra,
        prepMinBefore: at.prepMin,
        prepMinAfter,
        prepLateAlertAt: new Date(acceptedAt + prepMinAfter * MINUTE_MS + lateAfterDue),
        promisedBefore: at.promisedAt,
        promisedAfter: new Date(
          Math.ceil((at.promisedAt.getTime() + extra * MINUTE_MS) / PROMISE_STEP_MS) *
            PROMISE_STEP_MS,
        ),
      };
    }
    const positions = allLines.map((entry) => entry.position);
    // AP §8.4; none on a test order (AP §9.6.3).
    const commissionOf = (itemsValue: bigint) =>
      row.testOrder ? 0n : commission(itemsValue, row.commissionBp);
    const booking =
      afterPickup && request.responsible !== null
        ? afterPickupEntries({
            responsible: request.responsible,
            restaurantId: order.restaurantId,
            captainId: row.captainId,
            currency: row.currency,
            itemsValueBefore: view.money.itemsValue,
            itemsValueAfter: after.itemsValue,
            deliveryFeeBefore: row.deliveryFee,
            deliveryFeeAfter: after.deliveryFee,
            commissionOf,
          })
        : null;
    return {
      plan,
      before: view.money,
      after,
      times,
      booking,
      captainId: row.captainId,
      basis,
      version: row.version,
      status: row.status,
      currency: row.currency,
      nextPosition: positions.length === 0 ? 0 : Math.max(...positions) + 1,
      commissionOf,
    };
  }

  // What an edit was worked out from: the status, the money, the times, the
  // current lines and whether a pickup request is open.
  private async editBasis(
    executor: Pick<Database['db'], 'select'>,
    order: { id: string; placedAt: Date },
  ): Promise<string> {
    const [row] = await executor
      .select({
        status: orders.status,
        captainTrack: orders.captainTrack,
        itemsValue: orders.itemsValue,
        deliveryFee: orders.deliveryFee,
        promisedAt: orders.promisedAt,
        prepMin: orders.prepMin,
      })
      .from(orders)
      .where(orderKey(order.id, order.placedAt));
    const lines = await executor
      .select({
        position: orderLines.position,
        quantity: orderLines.quantity,
        removed: orderLines.removedByEdit,
      })
      .from(orderLines)
      .where(and(eq(orderLines.orderId, order.id), eq(orderLines.orderPlacedAt, order.placedAt)))
      .orderBy(orderLines.position);
    return JSON.stringify([
      row?.status,
      row?.captainTrack === 'pickup_pending',
      row?.itemsValue.toString(),
      row?.deliveryFee.toString(),
      row?.promisedAt?.toISOString() ?? null,
      row?.prepMin,
      lines.map((line) => [line.position, line.quantity, line.removed]),
    ]);
  }

  private async times(
    executor: Database['db'] | Tx,
    order: { id: string; placedAt: Date },
  ): Promise<OrderTimes> {
    const [row] = await executor
      .select({
        status: orders.status,
        promisedAt: orders.promisedAt,
        prepMin: orders.prepMin,
        prepLateAlertAt: orders.prepLateAlertAt,
        searchStartAt: orders.searchStartAt,
        searchStartedAt: orders.searchStartedAt,
      })
      .from(orders)
      .where(orderKey(order.id, order.placedAt));
    // Every accepted order has them together (a CHECK).
    if (!row?.promisedAt || row.prepMin === null || !row.prepLateAlertAt || !row.searchStartAt) {
      throw new Error(`order ${order.id} has no acceptance`);
    }
    return {
      status: row.status,
      promisedAt: row.promisedAt,
      prepMin: row.prepMin,
      prepLateAlertAt: row.prepLateAlertAt,
      searchStartAt: row.searchStartAt,
      searchStartedAt: row.searchStartedAt,
    };
  }

  private async run(
    caller: Caller,
    transition: Transition,
    body: object,
    now: Date,
    change: (order: OrderAtStart) => Promise<Change>,
  ): Promise<OrderView> {
    const { command } = caller;
    const accountId =
      caller.kind === 'admin' ? caller.command.admin.accountId : caller.command.accountId;
    const owner =
      caller.kind === 'restaurant'
        ? { restaurantId: caller.command.restaurantId }
        : caller.kind === 'customer'
          ? { customerAccountId: caller.command.accountId }
          : {};
    const key = { accountId, idempotencyKey: command.idempotencyKey };
    const requestHash = commandHash({ verb: transition.verb, orderId: command.orderId, ...body });
    const earlier = await this.replay(this.database.db, key, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const order = await this.find(command.orderId, owner);
    if (!transition.from.includes(order.status)) {
      // A repeat sent with the first may read the order after the first
      // committed: it answers the first's order (architecture §5.3).
      const first = await this.replay(this.database.db, key, requestHash, now);
      if (first !== null) return this.read(first);
      throw await this.stateChanged(order);
    }
    const prepared = await change(order);
    const noCaptainAlertMin = prepared.searchStartAt
      ? await this.settings.get('dispatch.no_captain_alert_min', { cityId: order.cityId })
      : 0;
    const publicReason = prepared.publicReason ?? null;

    // pg-boss connects before the lock is taken, never while it is held.
    await this.jobs.ready();
    const outcome = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, order.id, order.placedAt);
      if (!locked) throw new Error(`order ${order.id} not found`);
      // A repeat sent with the first waits on the lock, then answers the
      // first's order.
      const repeat = await this.replay(tx, key, requestHash, now);
      if (repeat !== null) return { done: true as const };
      if (!transition.from.includes(locked.status)) return { done: false as const };
      if (prepared.guard && !(await prepared.guard(tx))) return { done: false as const };
      // A change of the captain track before the transition (an offer
      // withdrawn) moves the version: the order is read again under its lock.
      let current = locked;
      if (prepared.before) {
        await prepared.before(tx);
        current = (await lockOrder(tx, order.id, order.placedAt))!;
      }
      const version = current.version + 1;
      const to = prepared.to ?? transition.to ?? current.status;
      await tx
        .update(orders)
        .set({ ...prepared.set, status: to, version })
        .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
      await recordTransition(tx, this.jobs, current, {
        type: transition.event ?? `order.${to as 'accepted' | 'ready' | 'rejected' | 'cancelled'}`,
        from: current.status,
        to,
        version,
        actor:
          caller.kind === 'restaurant'
            ? { type: 'restaurant', id: accountId, device: caller.command.deviceId }
            : { type: caller.kind, id: accountId },
        // An operations note stays in the event row and the audit (AP §10).
        reason:
          caller.kind === 'admin' ? caller.command.reason : (prepared.eventReason ?? publicReason),
        publicReason,
        at: now,
      });
      if (prepared.searchStartAt) {
        // AP §8.3: the timer exists exactly when its moment does.
        const job: SearchStartJob = {
          orderId: order.id,
          placedAt: order.placedAt.toISOString(),
          searchStartAt: prepared.searchStartAt.toISOString(),
          noCaptainAlertMin,
        };
        await this.jobs.send(QUEUES.searchStart, job, {
          startAfter: prepared.searchStartAt,
          db: inTransaction(tx),
        });
      }
      await prepared.effects?.(tx);
      if (caller.kind === 'admin') {
        const { admin, context, reason } = caller.command;
        await this.audit.recordWrite(
          {
            actor: { type: 'admin', id: admin.accountId, role: admin.roles.join(',') },
            context,
            cityId: locked.cityId,
            action: `order.${transition.verb}`,
            target: { type: 'order', id: locked.id },
            before: { status: locked.status, ...prepared.audit?.before },
            after: { status: to, ...body, reason: publicReason, ...prepared.audit?.after },
            reason,
          },
          tx,
        );
      }
      await keepKey(tx, accountId, command.idempotencyKey, requestHash, order, now);
      return { done: true as const };
    });
    if (!outcome.done) throw await this.stateChanged(order);
    return this.read(order);
  }

  // The order, read without a lock; the restaurant's own only when a
  // restaurant asks, the customer's own when a customer does: another's or an
  // unknown one is unknown_order.
  private async find(
    orderId: string,
    owner: { restaurantId?: string; customerAccountId?: string },
  ): Promise<OrderAtStart> {
    const [order] = await this.database.db
      .select({
        id: orders.id,
        placedAt: orders.placedAt,
        cityId: orders.cityId,
        restaurantId: orders.restaurantId,
        status: orders.status,
        tripSeconds: orders.tripSeconds,
        tripMetres: orders.tripMetres,
        searchStartAt: orders.searchStartAt,
      })
      .from(orders)
      .where(
        and(
          eq(orders.id, orderId),
          owner.restaurantId === undefined
            ? undefined
            : eq(orders.restaurantId, owner.restaurantId),
          owner.customerAccountId === undefined
            ? undefined
            : eq(orders.customerAccountId, owner.customerAccountId),
        ),
      );
    if (!order) throw new OrderCommandRefusedError('unknown_order', 'no such order');
    return order;
  }

  // AP §9.12.6: the nearest eligible captain's time to the restaurant at
  // order.eta_speed_kmh, by pricing.distance_method and its vehicle; null
  // without one.
  private async nearestCaptainEta(
    order: OrderAtStart,
    speedKmh: number,
    now: Date,
  ): Promise<number | null> {
    const restaurant = await this.merchants.restaurant(order.restaurantId, now);
    if (!restaurant) throw new Error(`restaurant ${order.restaurantId} not found`);
    const captain = await this.captains.nearestEligible(
      order.cityId,
      restaurant.location,
      order.tripMetres ?? 0,
      now,
    );
    if (captain === null) return null;
    const distance = await this.geo.distance(captain.position, restaurant.location, {
      vehicle: captain.vehicle,
    });
    return tripMinutes(distance.metres, speedKmh) * MINUTE_MS;
  }

  private async stateChanged(order: { id: string; placedAt: Date }) {
    return new OrderCommandRefusedError(
      'order_state_changed',
      'the order is no longer in the state the command needs',
      await this.read(order),
    );
  }

  private async read({ id, placedAt }: { id: string; placedAt: Date }): Promise<OrderView> {
    const [order] = await readOrders(this.database.db, orderKey(id, placedAt));
    if (!order) throw new Error(`order ${id} not found`);
    return order;
  }

  private async replay(
    executor: Parameters<typeof replayKey>[0],
    key: { accountId: string; idempotencyKey: string },
    requestHash: string,
    now: Date,
  ) {
    try {
      return await replayKey(executor, key.accountId, key.idempotencyKey, requestHash, now);
    } catch (error) {
      if (!(error instanceof IdempotencyKeyReusedError)) throw error;
      throw new OrderCommandRefusedError('idempotency_key_reused', error.message);
    }
  }
}

// RA §18: who changed the menu from a restaurant command, for its audit.
function merchantChange(command: MerchantCommand): MerchantChange {
  return {
    actor: { type: 'merchant', id: command.accountId, role: command.role ?? null },
    context: { ipAddress: command.ipAddress ?? null, device: command.deviceId },
  };
}

// What «تعديل الوقت» moves, and what decides it.
type OrderTimes = {
  status: OrderView['status'];
  promisedAt: Date;
  prepMin: number;
  prepLateAlertAt: Date;
  searchStartAt: Date;
  searchStartedAt: Date | null;
};

function sameTimes(a: OrderTimes, b: OrderTimes): boolean {
  return (
    a.status === b.status &&
    a.promisedAt.getTime() === b.promisedAt.getTime() &&
    a.prepMin === b.prepMin &&
    a.searchStartAt.getTime() === b.searchStartAt.getTime() &&
    (a.searchStartedAt === null) === (b.searchStartedAt === null)
  );
}

type OrderAtStart = {
  id: string;
  placedAt: Date;
  cityId: string;
  restaurantId: string;
  status: OrderView['status'];
  tripSeconds: number | null;
  tripMetres: number | null;
  searchStartAt: Date | null;
};

// AP §9.3.3: a ready order sent back to accepted by an edit that adds items.
type EditTimes = {
  extraPrepMin: number;
  prepMinBefore: number;
  prepMinAfter: number;
  prepLateAlertAt: Date;
  promisedBefore: Date;
  promisedAfter: Date;
};

// AP §9.3.3: the edit dialog's before-and-after money, with the commission
// and the merchant net (owners' net, RA §8.13).
export interface EditPreview {
  before: QuoteMoney & { commission: bigint; merchantNet: bigint };
  after: QuoteMoney & { commission: bigint; merchantNet: bigint };
  changes: EditChange[];
  addsItems: boolean;
  backToPreparing: boolean;
  promisedAt: Date | null;
  // After the pickup: the entries the responsible party's edit posts, each
  // with its party's name (empty until the party is chosen).
  afterPickup: boolean;
  entries: (AfterPickupJournal['entries'][number] & {
    type: AfterPickupJournal['type'];
    reason: string | null;
    party: { name: string | null };
  })[];
}

function moneyAudit(money: QuoteMoney) {
  return {
    itemsValue: money.itemsValue.toString(),
    deliveryFee: money.deliveryFee.toString(),
    total: money.total.toString(),
  };
}
