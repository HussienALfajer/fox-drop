import { describe, expect, it } from 'vitest';
import { LedgerService } from '../ledger/index.js';
import { SupportService, TicketRefusedError } from '../support/index.js';
import {
  admin,
  admin as admin_,
  app,
  azaz,
  balances,
  moneyMoved,
  pickedUpOrder,
  placedOrder,
  sql,
} from './order-edits.fixture.js';

// AP §8.10, §9.9.3, §6.4, §10 (slice 2.23c; owner decisions 2026-11-17): a
// customer's ticket after a normal delivery, resolved with its money: the
// responsible party's entries against platform.compensation_cost, «كود
// تعويض» within the cap or waiting for OWN, the wrong change's code uncapped,
// and the pushes of the debit and the charge.

async function deliveredOrder() {
  const at = await pickedUpOrder();
  expect((await at.arriveAtCustomer()).statusCode).toBe(200);
  const [{ total }] = (
    await sql.query('SELECT total FROM ordering.orders WHERE id = $1', [at.order.id])
  ).rows;
  expect((await at.deliver(String(total))).statusCode).toBe(200);
  return { ...at, total: BigInt(total) };
}

async function ticketOn(orderId: string, typeCode: string) {
  const sup = await admin(['SUP']);
  const opened = await app.inject({
    method: 'POST',
    url: `/v1/admin/orders/${orderId}/tickets`,
    cookies: sup.cookies,
    headers: { 'idempotency-key': crypto.randomUUID() },
    payload: { party: 'customer', typeCode, description: 'اتصل الزبون' },
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
      call('resolve', { message: 'نعتذر، أضفنا لك كود تعويض', ...payload }),
  };
}

const compensation = async (id: string) =>
  (
    await sql.query(
      'SELECT status, amount, reason_code, code_id FROM marketing.compensations WHERE id = $1',
      [id],
    )
  ).rows[0];

const pushes = async (template: string, like: string) =>
  (
    await sql.query(
      'SELECT body FROM notifications.push_messages WHERE template_key = $1 AND source LIKE $2',
      [template, like],
    )
  ).rows.map((row) => row.body);

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

const fixed = (amount: string) => ({
  value: { kind: 'fixed_amount', amount, percentBp: null, maxDiscount: null },
  reason: { code: 'missing_item', note: null },
});

describe('a missing item after a normal delivery', () => {
  it('debits the restaurant V with its commission reversed and gives the customer a code', async () => {
    const order = await deliveredOrder();
    const ticket = await ticketOn(order.order.id, 'missing_item');
    const page = await ticket.page();
    expect(page.order).toMatchObject({ deliveredNormally: true, currency: 'TRY' });
    expect(page.order.lines).toEqual([
      expect.objectContaining({ position: 0, quantity: 2, unitPrice: '12000' }),
    ]);

    // One shawarma of the two: V 12 000, the commission on it 1 800 (15%).
    const affected = [{ position: 0, quantity: 1 }];
    const preview = await ticket.preview({
      responsible: 'restaurant',
      affected,
      shortAmount: null,
      code: true,
    });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({
      affectedValue: '12000',
      merchantDebit: '10200',
      captainCharge: '0',
    });

    const before = await balances(order.captain.captainId);
    const costBefore = await compensationCost();
    const resolved = await ticket.resolve({
      resolution: 'compensation_code',
      responsible: 'restaurant',
      receivedLines: null,
      affected,
      code: fixed('5000'),
    });
    expect(resolved.statusCode).toBe(200);
    const body = resolved.json();
    expect(body.status).toBe('resolved');
    expect(body.resolution).toMatchObject({
      code: 'compensation_code',
      responsible: 'restaurant',
      affectedLines: [{ position: 0, quantity: 1, name: expect.any(String), value: '12000' }],
      affectedValue: '12000',
      shortAmount: null,
      moneyCurrency: 'TRY',
    });
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      restaurant: -10_200n,
      earnings: 0n,
      clearing: 0n,
    });
    // The restaurant's debit recovers the remedy's cost.
    expect((await compensationCost()) - costBefore).toBe(-12_000n);
    // Within SUP's cap (30% of the total): issued at once.
    expect(await compensation(body.resolution.compensationId)).toMatchObject({
      status: 'issued',
      amount: '5000',
      reason_code: 'missing_item',
    });
    expect(await pushes('merchant.ticket_debit', `%${ticket.id}`)).toEqual([
      expect.stringContaining('يُقيَّد عليكم 102'),
    ]);
    // A repeat is refused by what the first changed.
    expect(
      (
        await ticket.resolve({
          resolution: 'none_explained',
          responsible: 'restaurant',
          receivedLines: null,
        })
      ).json(),
    ).toMatchObject({ statusCode: 409, error: 'ticket_not_open' });
  });

  it('charges the captain the merchant net of V, and a code above the cap waits for OWN', async () => {
    const order = await deliveredOrder();
    const ticket = await ticketOn(order.order.id, 'missing_item');
    const before = await balances(order.captain.captainId);
    const resolved = await ticket.resolve({
      resolution: 'compensation_code',
      responsible: 'captain',
      receivedLines: null,
      affected: [{ position: 0, quantity: 1 }],
      // Above 30% of the total.
      code: fixed(String(order.total)),
    });
    expect(resolved.statusCode).toBe(200);
    expect(resolved.json().status).toBe('resolved');
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      restaurant: 0n,
      earnings: -10_200n,
    });
    expect(await compensation(resolved.json().resolution.compensationId)).toMatchObject({
      status: 'waiting',
      code_id: null,
    });
    expect(await pushes('captain.charge', `%ticket:${ticket.id}%`)).toEqual([
      expect.stringContaining('مشكلة بعد التسليم'),
    ]);
  });

  it('posts nothing for the platform with no remedy, and refuses items before the delivery', async () => {
    const order = await deliveredOrder();
    const ticket = await ticketOn(order.order.id, 'missing_item');
    const before = await balances(order.captain.captainId);
    const resolved = await ticket.resolve({
      resolution: 'none_explained',
      responsible: 'platform',
      receivedLines: null,
      affected: [{ position: 0, quantity: 2 }],
    });
    expect(resolved.statusCode).toBe(200);
    expect(resolved.json().resolution).toMatchObject({ affectedValue: '24000' });
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      restaurant: 0n,
      earnings: 0n,
    });

    const placed = await placedOrder();
    const early = await ticketOn(placed.id, 'missing_item');
    expect(
      (
        await early.resolve({
          resolution: 'none_explained',
          responsible: 'restaurant',
          receivedLines: null,
          affected: [{ position: 0, quantity: 1 }],
        })
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'not_delivered' });
    expect(
      (
        await ticket.preview({
          responsible: 'restaurant',
          affected: [{ position: 0, quantity: 3 }],
          shortAmount: null,
          code: false,
        })
      ).json(),
    ).toMatchObject({ statusCode: 409, error: 'ticket_not_open' });
  });
});

describe('«مشكلة في المبلغ أو الباقي»', () => {
  it('charges the captain M and gives the customer M as a code, uncapped', async () => {
    const order = await deliveredOrder();
    const ticket = await ticketOn(order.order.id, 'amount_or_change');
    expect(
      (
        await ticket.resolve({
          resolution: 'compensation_code',
          responsible: 'captain',
          receivedLines: null,
        })
      ).json(),
    ).toMatchObject({ statusCode: 400, error: 'amount_required' });
    const before = await balances(order.captain.captainId);
    // Above SUP's cap: the wrong change's code is not capped.
    const short = String(order.total);
    const resolved = await ticket.resolve({
      resolution: 'compensation_code',
      responsible: 'captain',
      receivedLines: null,
      shortAmount: short,
    });
    expect(resolved.statusCode).toBe(200);
    expect(resolved.json().resolution).toMatchObject({ shortAmount: short, affectedValue: null });
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      earnings: -order.total,
    });
    expect(await compensation(resolved.json().resolution.compensationId)).toMatchObject({
      status: 'issued',
      amount: short,
      reason_code: 'wrong_change',
    });
  });

  it('charges nothing when the captain returned it in person', async () => {
    const order = await deliveredOrder();
    const ticket = await ticketOn(order.order.id, 'amount_or_change');
    const before = await balances(order.captain.captainId);
    const resolved = await ticket.resolve({
      resolution: 'none_explained',
      responsible: 'captain',
      receivedLines: null,
      shortAmount: '2000',
    });
    expect(resolved.statusCode).toBe(200);
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      earnings: 0n,
    });
  });
});

describe('one problem paid once', () => {
  it('keeps every ticket on the order within each line, and the wrong change once', async () => {
    const order = await deliveredOrder();
    const first = await ticketOn(order.order.id, 'missing_item');
    const second = await ticketOn(order.order.id, 'wrong_item');
    const half = {
      resolution: 'none_explained',
      responsible: 'restaurant',
      receivedLines: null,
      affected: [{ position: 0, quantity: 1 }],
    };
    expect((await first.resolve(half)).statusCode).toBe(200);
    // Two of the line's two now: the second shawarma only.
    expect(
      (await second.resolve({ ...half, affected: [{ position: 0, quantity: 2 }] })).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_affected' });
    expect((await second.resolve(half)).statusCode).toBe(200);

    const change = await ticketOn(order.order.id, 'amount_or_change');
    const again = await ticketOn(order.order.id, 'amount_or_change');
    const short = {
      resolution: 'none_explained',
      responsible: 'captain',
      receivedLines: null,
      shortAmount: '1000',
    };
    // M is at most what the captain recorded as received.
    expect(
      (await change.resolve({ ...short, shortAmount: String(order.total + 1n) })).json(),
    ).toMatchObject({ statusCode: 400, error: 'invalid_value' });
    expect((await change.resolve({ ...short, responsible: 'restaurant' })).json()).toMatchObject({
      statusCode: 400,
      error: 'invalid_resolution',
    });
    expect((await change.resolve(short)).statusCode).toBe(200);
    expect((await again.resolve(short)).json()).toMatchObject({
      statusCode: 409,
      error: 'money_already_resolved',
    });
  });

  it('keeps an uncapped wrong-change code out of the cap of the next code', async () => {
    const order = await deliveredOrder();
    const change = await ticketOn(order.order.id, 'amount_or_change');
    expect(
      (
        await change.resolve({
          resolution: 'compensation_code',
          responsible: 'platform',
          receivedLines: null,
          shortAmount: String(order.total),
        })
      ).statusCode,
    ).toBe(200);
    const missing = await ticketOn(order.order.id, 'missing_item');
    const resolved = await missing.resolve({
      resolution: 'compensation_code',
      responsible: 'platform',
      receivedLines: null,
      code: fixed('5000'),
    });
    expect(await compensation(resolved.json().resolution.compensationId)).toMatchObject({
      status: 'issued',
    });
  });

  it('asks operations.compensate for any code, and keeps the preview to the city', async () => {
    const order = await deliveredOrder();
    const ticket = await ticketOn(order.order.id, 'amount_or_change');
    const support = app.get(SupportService);
    const admin = {
      accountId: crypto.randomUUID(),
      actor: { type: 'admin' as const, id: crypto.randomUUID(), role: 'X' },
      context: { ipAddress: null, device: null },
      permissions: ['support.manage'],
      roles: [],
    };
    await expect(
      support.resolve(
        azaz,
        ticket.id,
        {
          resolution: 'compensation_code',
          responsible: 'captain',
          message: 'x',
          lines: null,
          affected: [],
          shortAmount: 1_000n,
          code: null,
          chargePay: false,
        },
        admin,
        new Date(),
      ),
    ).rejects.toThrow(TicketRefusedError);
    const otherCity = crypto.randomUUID();
    const sup = await admin_(['SUP']);
    const preview = await app.inject({
      method: 'POST',
      url: `/v1/admin/tickets/${ticket.id}/money-preview`,
      cookies: sup.cookies,
      payload: {
        cityId: otherCity,
        responsible: 'captain',
        affected: [],
        shortAmount: '1000',
        code: false,
      },
    });
    expect(preview.json()).toMatchObject({ statusCode: 404, error: 'unknown_ticket' });
    const anonymous = await app.inject({
      method: 'POST',
      url: `/v1/admin/tickets/${ticket.id}/money-preview`,
      payload: {
        cityId: azaz,
        responsible: 'captain',
        affected: [],
        shortAmount: null,
        code: false,
      },
    });
    expect(anonymous.statusCode).toBe(401);
  });
});
