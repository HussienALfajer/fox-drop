import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { CaptainAccountsService, CustomerAccountsService, PhoneCipher } from '../identity/index.js';
import { CAPTAIN_ACTIVE } from './order-assignments.js';
import { lockOrder, type OrderRow } from './order-events.js';
import { contactChannels, orderContacts, orders, type orderStatuses } from './schema.js';

type OrderStatus = (typeof orderStatuses)[number];
export type ContactChannel = (typeof contactChannels)[number];

// Who taps, on which order.
export type ContactParty =
  // RA §8.9, R17: an owner or a cashier in the app, on the restaurant's order.
  | { type: 'restaurant'; restaurantId: string; accountId: string; deviceId: string }
  // CU §11.3: the customer, on their own order.
  | { type: 'customer'; accountId: string }
  // CA §9.5, C10: the order's captain.
  | { type: 'captain'; captainId: string };

// CU §11.3, §15: «اتصال بالكابتن» from the pickup until the order ends.
const CUSTOMER_CALLS: OrderStatus[] = ['picked_up', 'arrived'];

// A tap the order does not allow: another party's order, or outside the
// window (before it opens, or once the order ended or left the captain).
export class OrderContactRefusedError extends Error {
  constructor(readonly refusal: 'unknown_order' | 'order_state_changed') {
    super(refusal);
  }
}

// RA §8.9, §18, CU §11.3, §15, CA §9.5, §15 (slice L.1b): a number is shown
// to no one; each tap reveals it to the dialer or to WhatsApp only, and is
// recorded in the order's timeline. A tap changes no state and takes no
// Idempotency-Key: it dials at once or not at all, and a repeat is a tap of
// its own.
@Injectable()
export class OrderContacts {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly captainAccounts: CaptainAccountsService,
    private readonly customerAccounts: CustomerAccountsService,
    private readonly phones: PhoneCipher,
  ) {}

  async reveal(
    orderId: string,
    party: ContactParty,
    channel: ContactChannel,
    now: Date,
  ): Promise<{ phone: string }> {
    const [found] = await this.database.db
      .select({ placedAt: orders.placedAt })
      .from(orders)
      .where(eq(orders.id, orderId));
    if (!found) throw new OrderContactRefusedError('unknown_order');
    const tapped = await this.database.db.transaction(async (tx) => {
      const locked = await lockOrder(tx, orderId, found.placedAt);
      if (!locked) throw new OrderContactRefusedError('unknown_order');
      if (!ownedBy(locked, party)) throw new OrderContactRefusedError('unknown_order');
      if (!allowed(locked, party)) throw new OrderContactRefusedError('order_state_changed');
      const [row] = await tx
        .select({ contactPhoneEncrypted: orders.contactPhoneEncrypted })
        .from(orders)
        .where(eq(orders.id, locked.id));
      await tx.insert(orderContacts).values({
        orderId: locked.id,
        orderPlacedAt: locked.placedAt,
        cityId: locked.cityId,
        actorType: party.type,
        actorId: party.type === 'captain' ? party.captainId : party.accountId,
        actorDevice: party.type === 'restaurant' ? party.deviceId : null,
        channel,
        status: locked.status,
        version: locked.version,
        at: now,
      });
      return { locked, contactPhoneEncrypted: row?.contactPhoneEncrypted ?? null };
    });
    const { locked, contactPhoneEncrypted } = tapped;
    // CA §9.5: the address's contact number, else the account's own.
    const phone =
      party.type === 'captain'
        ? contactPhoneEncrypted
          ? this.phones.decrypt(contactPhoneEncrypted)
          : await this.customerAccounts.phone(locked.customerAccountId)
        : await this.captainAccounts.phone(locked.captainId!);
    if (phone === null) throw new Error(`order ${locked.id} has no number to reveal`);
    return { phone };
  }
}

function ownedBy(order: OrderRow, party: ContactParty): boolean {
  if (party.type === 'restaurant') return order.restaurantId === party.restaurantId;
  if (party.type === 'customer') return order.customerAccountId === party.accountId;
  // C10: once the order left the captain (a handover, a reassignment), it is
  // another's.
  return order.captainId === party.captainId;
}

function allowed(order: OrderRow, party: ContactParty): boolean {
  if (order.captainId === null) return false;
  // RA §8.9: from the assignment until delivered, failed or cancelled.
  // CA §9.5: while the order is active.
  if (party.type !== 'customer') return CAPTAIN_ACTIVE.includes(order.status);
  return CUSTOMER_CALLS.includes(order.status);
}
