import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { Jobs } from '../../jobs/jobs.module.js';
import { DATABASE } from '../../database/database.module.js';
import { CaptainsService } from '../captains/index.js';
import { LedgerService } from '../ledger/index.js';
import { AlertsService } from '../notifications/index.js';
import { SettingsService } from '../settings/index.js';
import { TicketSync } from '../support/index.js';
import { OrderAlerts } from './order-alerts.js';
import {
  admin,
  app,
  atCustomer,
  azaz,
  balances,
  cashier,
  moneyMoved,
  ORDER_PAY,
  onlineCaptain,
  pickedUpOrder,
  place,
  sql,
} from './order-edits.fixture.js';
import { REDELIVERY_PAY_REASON, REDELIVERY_REASON } from './redelivery.js';

// AP §9.9.3, docs/domain/10, §8.9, CU §11.2 (slice 2.23d; owner decisions
// 2026-11-17): «إعادة توصيل مجانية» from a customer's ticket after a normal
// delivery: the linked order at a total of 0 to the original address, taken
// by the restaurant like any order, never cancelled by the customer and out
// of the active-order limit; its money at its delivery for each responsible
// party; a re-delivery that does not happen reopens its ticket.

async function deliveredOrder() {
  const at = await pickedUpOrder();
  expect((await at.arriveAtCustomer()).statusCode).toBe(200);
  const [{ total }] = (
    await sql.query('SELECT total FROM ordering.orders WHERE id = $1', [at.order.id])
  ).rows;
  expect((await at.deliver(String(total))).statusCode).toBe(200);
  return at;
}

async function ticketOn(orderId: string, roles = ['SUP']) {
  const sup = await admin(roles);
  const opened = await app.inject({
    method: 'POST',
    url: `/v1/admin/orders/${orderId}/tickets`,
    cookies: sup.cookies,
    headers: { 'idempotency-key': randomUUID() },
    payload: { party: 'customer', typeCode: 'missing_item', description: 'اتصل الزبون' },
  });
  expect(opened.statusCode).toBe(200);
  const id: string = opened.json().id;
  const call = (path: string, payload: object) =>
    app.inject({
      method: 'POST',
      url: `/v1/admin/tickets/${id}/${path}`,
      cookies: sup.cookies,
      payload: { cityId: azaz, ...payload },
    });
  return {
    id,
    page: async () =>
      (
        await app.inject({
          method: 'GET',
          url: `/v1/admin/tickets/${id}?cityId=${azaz}`,
          cookies: sup.cookies,
        })
      ).json(),
    preview: (payload: object) => call('money-preview', payload),
    resolve: (payload: object) =>
      call('resolve', {
        resolution: 'free_redelivery',
        receivedLines: null,
        message: 'نرسل لك الصنف الناقص الآن',
        ...payload,
      }),
  };
}

const oneShawarma = [{ position: 0, quantity: 1 }];

const compensationCost = async () => {
  const ledger = app.get(LedgerService);
  return (
    await ledger.balance(
      await ledger.openAccount({
        cityId: azaz,
        purpose: 'platform.compensation_cost',
        ownerId: null,
        currency: 'TRY',
      }),
    )
  ).amount;
};

// The order's entries on a captain's earnings, through the ledger (its
// tables are its own).
const earningsEntries = async (captainId: string, orderId: string) => {
  const ledger = app.get(LedgerService);
  const accounts = await ledger.ownerAccounts(azaz, captainId, 'captain.earnings');
  return (
    await ledger.accountEntries(
      accounts.map((each) => each.id),
      'captain.earnings',
      50,
    )
  )
    .filter((entry) => entry.sourceId === orderId)
    .map((entry) => ({ type: entry.type, reason: entry.reason, amount: entry.amount }))
    .reverse();
};

// The re-delivery through the restaurant, a captain, the pickup and the door.
async function deliverRedelivery(orderId: string, pickupAmount: string) {
  const restaurantUser = await cashier();
  const accepted = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/accept`,
    headers: { ...restaurantUser, 'idempotency-key': randomUUID() },
    payload: { prepMin: 10 },
  });
  expect(accepted.statusCode).toBe(200);
  const captain = await onlineCaptain();
  const ops = await admin(['OPS']);
  expect((await ops.assign(orderId, captain.captainId)).statusCode).toBe(200);
  expect((await captain.arrive(orderId)).statusCode).toBe(200);
  const active = (await captain.active()).json().order;
  expect(active.redeliveryOf).not.toBeNull();
  const command = (path: string, payload: object) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${orderId}/${path}`,
      headers: { ...captain.headers, 'idempotency-key': randomUUID() },
      payload,
    });
  const fix = () => ({
    ...atCustomer,
    accuracyMetres: 10,
    recordedAt: new Date().toISOString(),
    simulated: false,
  });
  const atRestaurant = {
    latitude: 36.5875,
    longitude: 37.046,
    accuracyMetres: 10,
    recordedAt: new Date().toISOString(),
    simulated: false,
  };
  const lines = pickupAmount === '0' ? [] : [{ currency: 'TRY', amount: pickupAmount }];
  const requested = await command('pickup-request', { lines, location: atRestaurant });
  expect(requested.statusCode).toBe(200);
  const confirmed = await app.inject({
    method: 'POST',
    url: `/v1/merchant/orders/${orderId}/pickup/confirm`,
    headers: { ...restaurantUser, 'idempotency-key': randomUUID() },
  });
  expect(confirmed.statusCode).toBe(200);
  expect((await command('arrive-at-customer', { location: fix(), away: null })).statusCode).toBe(
    200,
  );
  const delivered = await command('deliver', {
    received: [],
    change: [],
    amountDue: { amount: '0', currency: 'TRY' },
    shortfall: null,
    away: null,
    location: fix(),
  });
  expect(delivered.statusCode).toBe(200);
  return captain;
}

describe('«إعادة توصيل مجانية» with the restaurant responsible', () => {
  it('places the linked order at 0, which the restaurant replaces for free', async () => {
    const original = await deliveredOrder();
    const ticket = await ticketOn(original.order.id);

    const preview = await ticket.preview({
      responsible: 'restaurant',
      affected: oneShawarma,
      shortAmount: null,
      code: false,
      redelivery: true,
    });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({
      entries: [],
      redelivery: { pickupPayment: '0', commission: '0', merchantNet: '0' },
    });

    const before = await balances(original.captain.captainId);
    const resolved = await ticket.resolve({ responsible: 'restaurant', affected: oneShawarma });
    expect(resolved.statusCode).toBe(200);
    expect(resolved.json()).toMatchObject({ status: 'resolved' });
    // docs/domain/10: nothing is posted for V with a free re-delivery.
    expect(moneyMoved(before, await balances(original.captain.captainId))).toMatchObject({
      restaurant: 0n,
      commission: 0n,
      earnings: 0n,
    });
    const page = await ticket.page();
    expect(page.redeliveries).toHaveLength(1);
    const { orderId } = page.redeliveries[0];

    const [row] = (
      await sql.query(
        `SELECT o.status, o.total, o.items_value, o.redelivery_of_id, o.redelivery_responsible,
                ST_Equals(o.location, src.location) AS same_place, o.street = src.street AS same_street
           FROM ordering.orders o
           JOIN ordering.orders src ON src.id = o.redelivery_of_id
          WHERE o.id = $1`,
        [orderId],
      )
    ).rows;
    expect(row).toMatchObject({
      status: 'placed',
      total: '0',
      items_value: '0',
      redelivery_of_id: original.order.id,
      redelivery_responsible: 'restaurant',
      same_place: true,
      same_street: true,
    });

    // CU §11.2: the customer sees it with the original's number and cannot
    // cancel it; it is outside the active-order limit (a new account may
    // have one active order), so another order goes through.
    const shown = await app.inject({
      method: 'GET',
      url: `/v1/customer/orders/${orderId}`,
      headers: original.order.customer,
    });
    expect(shown.json().order).toMatchObject({
      redeliveryOf: { orderId: original.order.id },
      money: expect.objectContaining({ total: '0' }),
    });
    const cancelled = await app.inject({
      method: 'POST',
      url: `/v1/customer/orders/${orderId}/cancel`,
      headers: { ...original.order.customer, 'idempotency-key': randomUUID() },
      payload: { reason: 'changed_mind', note: null },
    });
    expect(cancelled.statusCode).toBe(400);
    expect(cancelled.json().error).toBe('redelivery_not_cancellable');
    expect((await place(original.order.customer)).statusCode).toBe(201);

    // The restaurant's board shows the badge's order and no price.
    const board = (
      await app.inject({
        method: 'GET',
        url: '/v1/merchant/orders',
        headers: await cashier(),
      })
    ).json();
    expect(board.orders.find((each: { id: string }) => each.id === orderId)).toMatchObject({
      redeliveryOf: { orderId: original.order.id },
      itemsValue: '0',
    });

    const costBefore = await compensationCost();
    const atStart = await balances();
    const captain = await deliverRedelivery(orderId, '0');
    // Pickup 0, no commission: only the captain's pay, on the remedy's cost.
    expect(moneyMoved(atStart, await balances())).toMatchObject({
      clearing: 0n,
      commission: 0n,
      restaurant: 0n,
      captainPay: 0n,
    });
    expect((await compensationCost()) - costBefore).toBe(ORDER_PAY);
    expect(await earningsEntries(captain.captainId, orderId)).toEqual([
      { type: 'earn.order_pay', reason: null, amount: ORDER_PAY },
    ]);
  });
});

describe('«إعادة توصيل مجانية» with the captain responsible', () => {
  it('pays the restaurant at the pickup and charges the original captain the merchant net and the pay', async () => {
    const original = await deliveredOrder();
    // AP §9.9.3: OPS charge the pay; SUP may not.
    const ticket = await ticketOn(original.order.id, ['OPS']);
    const bySupport = await ticketOn(original.order.id);
    expect(
      (await bySupport.resolve({ responsible: 'captain', affected: oneShawarma, chargePay: true }))
        .statusCode,
    ).toBe(403);
    const preview = await ticket.preview({
      responsible: 'captain',
      affected: oneShawarma,
      shortAmount: null,
      code: false,
      redelivery: true,
    });
    // 12 000 at 15%: the commission 1 800, the merchant net 10 200.
    expect(preview.json()).toMatchObject({
      captainCharge: '10200',
      redelivery: { pickupPayment: '12000', commission: '1800', merchantNet: '10200' },
    });
    expect(
      (await ticket.resolve({ responsible: 'platform', affected: oneShawarma, chargePay: true }))
        .statusCode,
    ).toBe(400);
    const resolved = await ticket.resolve({
      responsible: 'captain',
      affected: oneShawarma,
      chargePay: true,
    });
    expect(resolved.statusCode).toBe(200);
    const { orderId } = (await ticket.page()).redeliveries[0];
    // Its total stays 0: no edit.
    const ops = await admin(['OPS']);
    expect((await ops.detail(orderId)).editChoices).toBeNull();

    const responsible = original.captain.captainId;
    const before = await balances(responsible);
    const costBefore = await compensationCost();
    await deliverRedelivery(orderId, '12000');
    expect(moneyMoved(before, await balances(responsible))).toMatchObject({
      // The pickup's 12 000 left the clearing account for the remedy's cost.
      clearing: 0n,
      commission: 1_800n,
      // What the restaurant and the captain owe (−).
      restaurant: -1_800n,
      // The merchant net and the delivering captain's pay, charged.
      earnings: -(10_200n + ORDER_PAY),
    });
    // The cost: the items 12 000 and the pay, less what the captain bears.
    expect((await compensationCost()) - costBefore).toBe(12_000n + ORDER_PAY - 10_200n - ORDER_PAY);
    expect(await earningsEntries(responsible, orderId)).toEqual([
      { type: 'earn.charge', reason: REDELIVERY_REASON, amount: -10_200n },
      { type: 'earn.charge', reason: REDELIVERY_PAY_REASON, amount: -ORDER_PAY },
    ]);
  });
});

describe('a re-delivery that does not happen', () => {
  it('posts no ticket money and returns the ticket to «قيد المعالجة»', async () => {
    const original = await deliveredOrder();
    const ticket = await ticketOn(original.order.id);
    expect(
      (await ticket.resolve({ responsible: 'platform', affected: oneShawarma })).statusCode,
    ).toBe(200);
    const { orderId } = (await ticket.page()).redeliveries[0];
    const ops = await admin(['OPS']);
    const cancelled = await ops.cancel(orderId, {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: false,
      compensateCaptain: false,
      cash: null,
      reason: 'المطعم لا يستطيع',
    });
    expect(cancelled.statusCode).toBe(200);
    const [{ placed_at: placedAt }] = (
      await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [orderId])
    ).rows;
    const alerts = new OrderAlerts(
      app.get(DATABASE),
      app.get(Jobs),
      app.get(AlertsService),
      app.get(CaptainsService),
      app.get(SettingsService),
      app.get(TicketSync),
    );
    const sync = () =>
      alerts.sync({ orderId, placedAt: new Date(placedAt).toISOString() }, new Date(), false);
    await sync();
    const page = await ticket.page();
    expect(page).toMatchObject({ status: 'in_progress', resolution: null });
    // The items are free again for another remedy, such as a code.
    expect(
      (
        await ticket.preview({
          responsible: 'platform',
          affected: oneShawarma,
          shortAmount: null,
          code: true,
        })
      ).statusCode,
    ).toBe(200);
    const [audit] = (
      await sql.query(
        "SELECT actor_type FROM audit.events WHERE target_id = $1 AND action = 'ticket.reopen'",
        [ticket.id],
      )
    ).rows;
    expect(audit).toEqual({ actor_type: 'system' });

    // Resolved again with a second re-delivery: a late sync of the first
    // changes nothing.
    expect(
      (await ticket.resolve({ responsible: 'platform', affected: oneShawarma })).statusCode,
    ).toBe(200);
    expect((await ticket.page()).redeliveries).toHaveLength(2);
    await sync();
    expect(await ticket.page()).toMatchObject({ status: 'resolved' });
  });
});
