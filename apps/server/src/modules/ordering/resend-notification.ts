import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService, type AuditRequestContext } from '../audit/index.js';
import { PushQueue, type PushRecipient } from '../notifications/index.js';
import { orders } from './schema.js';

export type ResendTarget = 'customer' | 'merchant' | 'captain';

// AP §9.3.2: the active statuses, from placed to the captain at the door.
const ACTIVE = new Set(['placed', 'accepted', 'ready', 'picked_up', 'arrived']);

// The captain is on the order from its assignment to the pickup.
const CAPTAIN_ON = new Set(['assigned', 'at_merchant', 'pickup_pending']);

// AP §9.3.2 «the current state»: the templates whose push tells the order's
// state now to that party (order-pushes.ts), so a resend never rings an old
// step again («طلب جديد» after acceptance, an offer once assigned). The
// latest of them the order sent is sent again.
export function currentTemplates(to: ResendTarget, status: string, track: string | null): string[] {
  const beforePickup = status === 'accepted' || status === 'ready';
  if (to === 'customer') {
    if (status === 'arrived') {
      return ['customer.captain_arrived', 'customer.captain_arrived_recipient'];
    }
    if (status === 'picked_up') return ['customer.picked_up'];
    if (beforePickup) {
      return track !== null && CAPTAIN_ON.has(track)
        ? ['customer.captain_assigned']
        : ['customer.accepted'];
    }
    return [];
  }
  if (to === 'merchant') {
    if (status === 'placed') return ['merchant.new_order'];
    if (beforePickup && track === 'pickup_pending') return ['merchant.pickup_requested'];
    if (beforePickup && track === 'at_merchant') return ['merchant.captain_arrived'];
    return [];
  }
  if (status === 'picked_up' || status === 'arrived') return ['captain.picked_up'];
  if (beforePickup && track !== null && CAPTAIN_ON.has(track)) {
    return [
      'captain.assigned_by_operations',
      ...(status === 'ready' ? ['captain.order_ready'] : []),
      ...(track === 'at_merchant'
        ? ['captain.pickup_amount_incorrect', 'captain.pickup_incomplete']
        : []),
    ];
  }
  return [];
}

export type ResendRefusal =
  | 'unknown_order'
  // Not active, or no captain to send to.
  | 'order_state_changed'
  // The order sent that party no push that tells its current state.
  | 'nothing_to_resend';

export class ResendRefusedError extends Error {
  constructor(readonly refusal: ResendRefusal) {
    super(refusal);
  }
}

// AP §9.3.2 «إعادة إرسال الإشعار» (OWN, OPS, SUP): pushes the order's
// current state again to the customer, the restaurant's devices or the
// assigned captain, as the latest push the order sent them that tells it
// (currentTemplates); audited as
// order.resend_notification. A repeat sends it again, which is what the
// button asks, so it takes no Idempotency-Key.
@Injectable()
export class ResendNotification {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly queue: PushQueue,
    private readonly audit: AuditService,
  ) {}

  async resend(
    command: {
      orderId: string;
      to: ResendTarget;
      admin: { accountId: string; roles: string[] };
      context: AuditRequestContext;
    },
    now: Date,
  ): Promise<{ body: string }> {
    return this.database.db.transaction(async (tx) => {
      const [order] = await tx
        .select({
          id: orders.id,
          cityId: orders.cityId,
          status: orders.status,
          customerAccountId: orders.customerAccountId,
          restaurantId: orders.restaurantId,
          captainId: orders.captainId,
          captainTrack: orders.captainTrack,
        })
        .from(orders)
        .where(eq(orders.id, command.orderId));
      if (!order) throw new ResendRefusedError('unknown_order');
      if (!ACTIVE.has(order.status)) throw new ResendRefusedError('order_state_changed');
      let recipient: PushRecipient;
      if (command.to === 'customer') {
        recipient = { party: 'customer', accountId: order.customerAccountId };
      } else if (command.to === 'merchant') {
        recipient = { party: 'merchant', restaurantId: order.restaurantId, owners: false };
      } else {
        if (order.captainId === null) throw new ResendRefusedError('order_state_changed');
        recipient = { party: 'captain', captainId: order.captainId };
      }
      const sent = await this.queue.resend(
        tx,
        order.id,
        recipient,
        currentTemplates(command.to, order.status, order.captainTrack),
        now,
      );
      if (sent === null) throw new ResendRefusedError('nothing_to_resend');
      await this.audit.recordWrite(
        {
          actor: {
            type: 'admin',
            id: command.admin.accountId,
            role: command.admin.roles.join(','),
          },
          context: command.context,
          cityId: order.cityId,
          action: 'order.resend_notification',
          target: { type: 'order', id: order.id },
          before: null,
          after: { to: command.to, templateKey: sent.templateKey },
          reason: null,
        },
        tx,
      );
      return { body: sent.body };
    });
  }
}
