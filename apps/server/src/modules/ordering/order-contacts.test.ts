import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { CustomerAccountsService, MerchantAccountsService } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import {
  app,
  appSignIn,
  assignedOrder,
  azaz,
  captainAtRestaurant,
  centre,
  change,
  onlineCaptain,
  phoneNumber,
  placedOrder,
  sql,
} from './delivery.fixture.js';

// RA §8.9, §18, CU §11.3, §15, CA §9.5, §15 (slice L.1b): a number is in no
// read; each tap reveals it and is recorded in the order's timeline.

type Headers = Record<string, string>;

const tap = (url: string, headers: Headers, payload?: object) =>
  app.inject({ method: 'POST', url, headers, ...(payload ? { payload } : {}) });
const restaurantCall = (orderId: string, headers: Headers) =>
  tap(`/v1/merchant/orders/${orderId}/captain-call`, headers);
const customerCall = (orderId: string, headers: Headers) =>
  tap(`/v1/customer/orders/${orderId}/captain-call`, headers);
const captainContact = (orderId: string, headers: Headers, channel: 'call' | 'whatsapp') =>
  tap(`/v1/captain/orders/${orderId}/customer-contact`, headers, { channel });

async function contacts(orderId: string) {
  const { rows } = await sql.query(
    `SELECT actor_type, actor_id, actor_device, channel, status, version
       FROM ordering.order_contacts WHERE order_id = $1 ORDER BY at, id`,
    [orderId],
  );
  return rows;
}

async function end(orderId: string) {
  await sql.query(
    "UPDATE ordering.orders SET status = 'cancelled', cancelled_at = now(), cancel_reason = 'test', food_prepared = false WHERE id = $1",
    [orderId],
  );
}

async function pickUp(at: Awaited<ReturnType<typeof captainAtRestaurant>>) {
  expect((await at.requestPickup()).statusCode).toBe(200);
  expect((await at.restaurant('confirm')).statusCode).toBe(200);
}

async function customerCard(orderId: string, headers: Headers) {
  const answer = await app.inject({
    method: 'GET',
    url: `/v1/customer/orders/${orderId}`,
    headers,
  });
  expect(answer.statusCode).toBe(200);
  return answer.json().order.captain;
}

describe("the restaurant's «اتصال بالكابتن» (RA §8.9, R17)", () => {
  it('refuses before the assignment and after the end, records each tap with the device', async () => {
    const placed = await placedOrder();
    const before = await restaurantCall(placed.id, placed.cashier);
    expect(before.statusCode).toBe(409);
    expect(await contacts(placed.id)).toEqual([]);

    const { order } = await assignedOrder();
    const first = await restaurantCall(order.id, order.cashier);
    expect(first.statusCode).toBe(200);
    expect(first.json().phone).toMatch(/^\+963/);
    expect((await restaurantCall(order.id, order.cashier)).statusCode).toBe(200);
    const rows = await contacts(order.id);
    expect(rows).toHaveLength(2);
    expect(rows[0]).toMatchObject({
      actor_type: 'restaurant',
      channel: 'call',
      status: 'accepted',
    });
    expect(rows[0].actor_device).not.toBeNull();

    await end(order.id);
    const after = await restaurantCall(order.id, order.cashier);
    expect(after.statusCode).toBe(409);
    expect(after.json()).toEqual({ statusCode: 409, error: 'order_state_changed' });
    expect(await contacts(order.id)).toHaveLength(2);
  });

  it('answers another restaurant 404 and a terminated one 403, recording nothing', async () => {
    const { order } = await assignedOrder();
    const merchants = app.get(MerchantsService);
    const other = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطعم آخر',
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(other, 'active', change);
    // The owner, on a device: a termination signs the cashiers out (RA §5.5),
    // and keeps the owner's session for the 403.
    const phone = phoneNumber();
    await app
      .get(MerchantAccountsService)
      .addAccount(other, { role: 'owner', name: 'owner', phone }, change);
    const owner = await appSignIn('merchant', phone);
    await app.inject({
      method: 'PUT',
      url: '/v1/merchant/auth/device',
      headers: owner,
      payload: { name: 'مالك', platform: 'android', appVersion: '1.0.0' },
    });
    const stranger = await restaurantCall(order.id, owner);
    expect(stranger.statusCode).toBe(404);
    expect(stranger.json().error).toBe('unknown_order');

    await merchants.setAccountStatus(other, 'terminated', change);
    const terminated = await restaurantCall(order.id, owner);
    expect(terminated.statusCode).toBe(403);
    expect(terminated.json().error).toBe('restaurant_terminated');
    expect(await contacts(order.id)).toEqual([]);
  });
});

describe("the customer's «اتصال بالكابتن» (CU §11.3, §15)", () => {
  it('works from the pickup until the order ends only, on their own order', async () => {
    const at = await captainAtRestaurant();
    const { order } = at;
    expect((await customerCard(order.id, order.customer)).canCall).toBe(false);
    expect((await customerCall(order.id, order.customer)).statusCode).toBe(409);

    await pickUp(at);
    expect((await customerCard(order.id, order.customer)).canCall).toBe(true);
    expect(await customerCard(order.id, order.customer)).not.toHaveProperty('phone');
    const call = await customerCall(order.id, order.customer);
    expect(call.statusCode).toBe(200);
    expect(call.json().phone).toMatch(/^\+963/);

    const stranger = await appSignIn('customer', phoneNumber());
    expect((await customerCall(order.id, stranger)).statusCode).toBe(404);

    await end(order.id);
    expect((await customerCard(order.id, order.customer)).canCall).toBe(false);
    expect((await customerCall(order.id, order.customer)).statusCode).toBe(409);
    expect(await contacts(order.id)).toEqual([
      expect.objectContaining({
        actor_type: 'customer',
        actor_device: null,
        channel: 'call',
        status: 'picked_up',
      }),
    ]);
  });
});

describe("the captain's «اتصال بالزبون» and «واتساب الزبون» (CA §9.5, C10)", () => {
  it("reveals the address's contact number, else the account's, while the order is theirs", async () => {
    const contactPhone = phoneNumber();
    const forSomeone = await assignedOrder({ recipientName: 'أبو أحمد', contactPhone });
    const whatsapp = await captainContact(
      forSomeone.order.id,
      forSomeone.captain.headers,
      'whatsapp',
    );
    expect(whatsapp.statusCode).toBe(200);
    expect(whatsapp.json()).toEqual({ phone: contactPhone });

    const own = await assignedOrder();
    const call = await captainContact(own.order.id, own.captain.headers, 'call');
    expect(call.statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT customer_account_id FROM ordering.orders WHERE id = $1',
      [own.order.id],
    );
    expect(call.json().phone).toBe(
      await app.get(CustomerAccountsService).phone(rows[0].customer_account_id),
    );
    expect(await contacts(own.order.id)).toEqual([
      expect.objectContaining({
        actor_type: 'captain',
        actor_id: own.captain.captainId,
        channel: 'call',
        status: 'accepted',
      }),
    ]);

    // Another captain's order is unknown; an ended one answers no number.
    const other = await onlineCaptain();
    expect((await captainContact(own.order.id, other.headers, 'call')).statusCode).toBe(404);
    await end(own.order.id);
    expect((await captainContact(own.order.id, own.captain.headers, 'call')).statusCode).toBe(409);
  });

  it('refuses a channel that is neither', async () => {
    const own = await assignedOrder();
    const answer = await tap(
      `/v1/captain/orders/${own.order.id}/customer-contact`,
      own.captain.headers,
      { channel: 'sms' },
    );
    expect(answer.statusCode).toBe(400);
  });
});

describe('the record of the taps', () => {
  it('is append-only for the application role', async () => {
    const { order } = await assignedOrder();
    expect((await restaurantCall(order.id, order.cashier)).statusCode).toBe(200);
    await expect(
      sql.query("UPDATE ordering.order_contacts SET channel = 'call' WHERE order_id = $1", [
        order.id,
      ]),
    ).rejects.toThrow(/permission denied/);
  });

  it('shows each tap in the admin timeline, by its time', async () => {
    const { order, captain, ops } = await assignedOrder();
    expect((await restaurantCall(order.id, order.cashier)).statusCode).toBe(200);
    expect((await captainContact(order.id, captain.headers, 'whatsapp')).statusCode).toBe(200);
    const detail = await ops.get(`/v1/admin/orders/${order.id}`);
    expect(detail.statusCode).toBe(200);
    const timeline: { type: string | null; at: string }[] = detail.json().order.timeline;
    const tapTypes = ['order.captain_called', 'order.customer_called', 'order.customer_whatsapp'];
    const taps = timeline.filter((event) => tapTypes.includes(event.type ?? ''));
    expect(taps).toEqual([
      expect.objectContaining({
        type: 'order.captain_called',
        from: 'accepted',
        to: 'accepted',
        actor: expect.objectContaining({ type: 'restaurant' }),
      }),
      expect.objectContaining({
        type: 'order.customer_whatsapp',
        actor: expect.objectContaining({ type: 'captain' }),
      }),
    ]);
    const times = timeline.map((event) => Date.parse(event.at));
    expect(times).toEqual([...times].sort((a, b) => a - b));
  });
});
