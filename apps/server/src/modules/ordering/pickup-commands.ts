import { Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { Jobs } from '../../jobs/jobs.module.js';
import { AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import type { AdminOrderCommand } from './captain-orders.js';
import { commandHash, IdempotencyKeyReusedError, keepKey, replayKey } from './idempotency-keys.js';
import { recordTransition } from './order-events.js';
import { type MerchantCommand, OrderCommandRefusedError } from './order-commands.js';
import { orderKey, readOrders, type OrderView } from './order-views.js';
import {
  checkLines,
  linesOf,
  lockForPickup,
  type PaymentLine,
  pickable,
  PickupBooking,
  type PickupOrder,
  storedLines,
} from './pickup-booking.js';
import { pickupDisputesOf, pickupRequestsOf } from './pickup-views.js';
import { orders, pickupDisputes, pickupRequests } from './schema.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];
type RequestRow = typeof pickupRequests.$inferSelect;

const MINUTE_MS = 60_000;

// What a command does on the locked order: done, or the state it needs is
// gone (order_state_changed), or a refusal of its own.
type Act = (tx: Tx, order: PickupOrder) => Promise<boolean>;

// The restaurant's answers to a pickup request (RA §8.10, §18) and
// operations' «تأكيد الاستلام نيابة عن المطعم» (AP §9.3.2). Each locks the
// order, then its open request, as the automatic confirmation does; the
// first answer wins, and a later one finds the request closed
// (order_state_changed with the order as it is now).
@Injectable()
export class PickupCommands {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jobs: Jobs,
    private readonly booking: PickupBooking,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
  ) {}

  // Each order's pickup requests, newest first, and its dispute after the
  // pickup, for the reads.
  requests(orderIds: string[]) {
    return pickupRequestsOf(this.database.db, orderIds);
  }

  disputes(orderIds: string[]) {
    return pickupDisputesOf(this.database.db, orderIds);
  }

  // RA §8.10 item 4: «تأكيد الاستلام».
  async confirm(command: MerchantCommand, now: Date): Promise<OrderView> {
    return this.restaurant(command, { verb: 'confirm_pickup' }, now, async (tx, order) => {
      const request = await openRequest(tx, order.id);
      if (!request || !pickable(order)) return false;
      await this.booking.complete(
        tx,
        order,
        request.id,
        linesOfRow(request),
        { outcome: 'restaurant', actor: restaurantActor(command) },
        now,
      );
      return true;
    });
  }

  // RA §8.10 item 7: «الطلب غير مكتمل» rejects the request without amounts or
  // an operations alert.
  async incomplete(command: MerchantCommand, now: Date): Promise<OrderView> {
    return this.restaurant(command, { verb: 'pickup_incomplete' }, now, async (tx, order) => {
      const request = await openRequest(tx, order.id);
      if (!request || !pickable(order)) return false;
      await this.reject(tx, order, request, command, 'incomplete', null, now);
      return true;
    });
  }

  // RA §8.10 items 6 and 8: «المبلغ غير صحيح» with the lines the restaurant
  // received. On an open request it rejects it (operations' «خلاف على مبلغ
  // الاستلام»); within order.pickup_dispute_window_min after the pickup it
  // records the dispute, a report linked to the order (owner decision
  // 2026-11-06), and the captain is told on their channel. The order
  // continues normally.
  async dispute(
    command: MerchantCommand & { receivedLines: PaymentLine[] },
    now: Date,
  ): Promise<OrderView> {
    const windowMin = await this.settings.get('order.pickup_dispute_window_min', {
      cityId: (await this.find(command)).cityId,
    });
    return this.restaurant(
      command,
      { verb: 'dispute_pickup', receivedLines: storedLines(command.receivedLines) },
      now,
      async (tx, order) => {
        const refusal = checkLines(order.snapshot, command.receivedLines, null);
        if (refusal !== null) throw new OrderCommandRefusedError(refusal, 'invalid lines');
        const request = await openRequest(tx, order.id);
        if (request) {
          if (!pickable(order)) return false;
          await this.reject(
            tx,
            order,
            request,
            command,
            'amount_incorrect',
            command.receivedLines,
            now,
          );
          return true;
        }
        if (
          order.pickedUpAt === null ||
          now.getTime() >= order.pickedUpAt.getTime() + windowMin * MINUTE_MS
        ) {
          return false;
        }
        const [disputed] = await tx
          .select({ id: pickupDisputes.id })
          .from(pickupDisputes)
          .where(eq(pickupDisputes.orderId, order.id));
        if (disputed) {
          throw new OrderCommandRefusedError(
            'pickup_already_disputed',
            'the pickup was disputed already',
          );
        }
        const [confirmed] = await tx
          .select({ id: pickupRequests.id })
          .from(pickupRequests)
          .where(and(eq(pickupRequests.orderId, order.id), eq(pickupRequests.status, 'confirmed')));
        await tx.insert(pickupDisputes).values({
          orderId: order.id,
          orderPlacedAt: order.placedAt,
          cityId: order.cityId,
          pickupRequestId: confirmed!.id,
          accountId: command.accountId,
          device: command.deviceId,
          receivedLines: storedLines(command.receivedLines),
          createdAt: now,
          status: 'open',
        });
        const version = order.version + 1;
        await setVersion(tx, order, version);
        await recordTransition(tx, this.jobs, order, {
          type: 'order.pickup_disputed',
          from: order.status,
          to: order.status,
          version,
          actor: restaurantActor(command),
          reason: null,
          at: now,
        });
        return true;
      },
    );
  }

  // AP §9.3.2 «تأكيد الاستلام نيابة عن المطعم»: the order accepted or ready,
  // the assigned captain at the restaurant; the admin's lines, prefilled from
  // the captain's last request, checked as the captain's are; with a reason,
  // audited. An open request closes confirmed by operations; without one, a
  // confirmed request is written. It does not wait for an unacknowledged edit.
  async confirmForRestaurant(
    command: AdminOrderCommand & { lines: PaymentLine[] },
    now: Date,
  ): Promise<OrderView> {
    const accountId = command.admin.accountId;
    const requestHash = commandHash({
      verb: 'confirm_pickup_for_restaurant',
      orderId: command.orderId,
      lines: storedLines(command.lines),
      reason: command.reason,
    });
    const earlier = await this.replay(accountId, command.idempotencyKey, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const found = await this.findAny(command.orderId);
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const order = await lockForPickup(tx, found.id, found.placedAt);
      if (!order) throw new Error(`order ${found.id} not found`);
      if ((await this.replay(accountId, command.idempotencyKey, requestHash, now, tx)) !== null) {
        return true;
      }
      if (!pickable(order)) return false;
      const refusal = checkLines(order.snapshot, command.lines, order.itemsValue);
      if (refusal !== null) throw new OrderCommandRefusedError(refusal, 'invalid lines');
      let request = await openRequest(tx, order.id);
      if (!request) {
        [request] = await tx
          .insert(pickupRequests)
          .values({
            orderId: order.id,
            orderPlacedAt: order.placedAt,
            cityId: order.cityId,
            captainId: order.captainId!,
            currency: order.currency,
            amount: order.itemsValue,
            lines: storedLines(command.lines),
            openedAt: now,
            confirmBy: now,
            status: 'open',
          })
          .returning();
      }
      await this.booking.complete(
        tx,
        order,
        request!.id,
        command.lines,
        {
          outcome: 'operations',
          actor: { type: 'admin', id: accountId },
          reason: command.reason,
        },
        now,
      );
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: accountId, role: command.admin.roles.join(',') },
          context: command.context,
          cityId: order.cityId,
          action: 'order.confirm_pickup',
          target: { type: 'order', id: order.id },
          before: { status: order.status, captainTrack: order.captainTrack },
          after: {
            status: 'picked_up',
            captainTrack: 'picked_up',
            lines: storedLines(command.lines),
          },
          reason: command.reason,
        },
        tx,
      );
      await keepKey(tx, accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) throw await this.stateChanged(found);
    return this.read(found);
  }

  // RA §8.10 items 6-7: the request rejected, the track back to at_merchant;
  // the captain sees the restaurant's answer and pays the difference or
  // rechecks the items before a new request.
  private async reject(
    tx: Tx,
    order: PickupOrder,
    request: RequestRow,
    command: MerchantCommand,
    outcome: 'amount_incorrect' | 'incomplete',
    receivedLines: PaymentLine[] | null,
    now: Date,
  ): Promise<void> {
    await tx
      .update(pickupRequests)
      .set({
        status: 'rejected',
        outcome,
        closedAt: now,
        closedByType: 'restaurant',
        closedById: command.accountId,
        closedByDevice: command.deviceId,
        receivedLines: receivedLines && storedLines(receivedLines),
      })
      .where(eq(pickupRequests.id, request.id));
    const version = order.version + 1;
    await tx
      .update(orders)
      .set({ version, captainTrack: 'at_merchant' })
      .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
    await recordTransition(tx, this.jobs, order, {
      type: 'order.pickup_rejected',
      from: order.status,
      to: order.status,
      version,
      actor: restaurantActor(command),
      reason: outcome,
      at: now,
      captainTrack: 'at_merchant',
    });
  }

  // The restaurant's commands: replay the key, read the order, then lock it
  // and act in one transaction with the key (as OrderCommands.run does).
  private async restaurant(
    command: MerchantCommand,
    body: object,
    now: Date,
    act: Act,
  ): Promise<OrderView> {
    const requestHash = commandHash({ orderId: command.orderId, ...body });
    const earlier = await this.replay(command.accountId, command.idempotencyKey, requestHash, now);
    if (earlier !== null) return this.read(earlier);
    const found = await this.find(command);
    await this.jobs.ready();
    const done = await this.database.db.transaction(async (tx) => {
      const order = await lockForPickup(tx, found.id, found.placedAt);
      if (!order) throw new Error(`order ${found.id} not found`);
      const repeat = await this.replay(
        command.accountId,
        command.idempotencyKey,
        requestHash,
        now,
        tx,
      );
      if (repeat !== null) return true;
      if (!(await act(tx, order))) return false;
      await keepKey(tx, command.accountId, command.idempotencyKey, requestHash, order, now);
      return true;
    });
    if (!done) {
      // A repeat sent with the first answers the first's order.
      const first = await this.replay(command.accountId, command.idempotencyKey, requestHash, now);
      if (first !== null) return this.read(first);
      throw await this.stateChanged(found);
    }
    return this.read(found);
  }

  // The restaurant's own order; another restaurant's or an unknown one is
  // unknown_order.
  private async find(command: MerchantCommand) {
    const [order] = await this.database.db
      .select({ id: orders.id, placedAt: orders.placedAt, cityId: orders.cityId })
      .from(orders)
      .where(and(eq(orders.id, command.orderId), eq(orders.restaurantId, command.restaurantId)));
    if (!order) throw new OrderCommandRefusedError('unknown_order', 'no such order');
    return order;
  }

  private async findAny(orderId: string) {
    const [order] = await this.database.db
      .select({ id: orders.id, placedAt: orders.placedAt })
      .from(orders)
      .where(eq(orders.id, orderId));
    if (!order) throw new OrderCommandRefusedError('unknown_order', 'no such order');
    return order;
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
    accountId: string,
    key: string,
    requestHash: string,
    now: Date,
    executor: Parameters<typeof replayKey>[0] = this.database.db,
  ) {
    try {
      return await replayKey(executor, accountId, key, requestHash, now);
    } catch (error) {
      if (!(error instanceof IdempotencyKeyReusedError)) throw error;
      throw new OrderCommandRefusedError('idempotency_key_reused', error.message);
    }
  }
}

// The order's open request, locked after the order.
async function openRequest(tx: Tx, orderId: string): Promise<RequestRow | undefined> {
  const [request] = await tx
    .select()
    .from(pickupRequests)
    .where(and(eq(pickupRequests.orderId, orderId), eq(pickupRequests.status, 'open')))
    .for('update');
  return request;
}

function linesOfRow(request: RequestRow): PaymentLine[] {
  return linesOf(request.lines);
}

function restaurantActor(command: MerchantCommand) {
  return { type: 'restaurant' as const, id: command.accountId, device: command.deviceId };
}

async function setVersion(tx: Tx, order: PickupOrder, version: number) {
  await tx
    .update(orders)
    .set({ version })
    .where(and(eq(orders.id, order.id), eq(orders.placedAt, order.placedAt)));
}
