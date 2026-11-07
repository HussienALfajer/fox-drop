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

export type ResendRefusal =
  | 'unknown_order'
  // Not active, or no captain to send to.
  | 'order_state_changed'
  // The order sent that party no push yet.
  | 'nothing_to_resend';

export class ResendRefusedError extends Error {
  constructor(readonly refusal: ResendRefusal) {
    super(refusal);
  }
}

// AP §9.3.2 «إعادة إرسال الإشعار» (OWN, OPS, SUP): pushes the order's
// current state again to the customer, the restaurant's devices or the
// assigned captain, as the latest push the order sent them; audited as
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
      const sent = await this.queue.resend(tx, order.id, recipient, now);
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
