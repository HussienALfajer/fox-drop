import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import pg from 'pg';
import { describe, expect, it } from 'vitest';
import { MerchantsService } from '../merchants/index.js';
import {
  database,
  app,
  sql,
  azaz,
  fries,
  soldOut,
  change,
  centre,
  admin,
  cashier,
  placedOrder,
  acceptedOrder,
  captainAtRestaurant,
  board,
  events,
  outboxReason,
  times,
  MINUTE,
  moved,
  ready,
  customerOrder,
  report,
  switchOn,
  reportRow,
  boardOrder,
  acknowledge,
  money,
  editRow,
  addFries,
  pickedUpOrder,
  balances,
  moneyMoved,
  oneShawarma,
  ORDER_PAY,
} from './order-edits.fixture.js';

describe('POST /v1/admin/orders/{orderId}/edit before the pickup (AP §9.3.3)', () => {
  it('recalculates the money from the lines and keeps a raised line at its unit price', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const answer = await ops.edit(order.id, addFries);
    expect(answer.statusCode).toBe(200);
    // 3 × 12000 + 7300 = 43300; the fee 4000; rounded to 500.
    const after = await money(order.id);
    expect(after.items_value).toBe('43300');
    expect(after.delivery_fee).toBe('4000');
    expect(BigInt(after.total)).toBe(43_300n + 4_000n + BigInt(after.rounding));
    expect(BigInt(after.total) % 500n).toBe(0n);
    const lines = (
      await sql.query(
        `SELECT position, quantity, line_total, quantity_before, added_by_edit IS NOT NULL AS added
           FROM ordering.order_lines WHERE order_id = $1 ORDER BY position`,
        [order.id],
      )
    ).rows;
    expect(lines).toEqual([
      { position: 0, quantity: 3, line_total: '36000', quantity_before: 2, added: false },
      { position: 1, quantity: 1, line_total: '7300', quantity_before: null, added: true },
    ]);
    const edit = await editRow(order.id);
    expect(edit).toMatchObject({
      status: 'accepted',
      adds_items: true,
      items_value_before: '24000',
      items_value_after: '43300',
      extra_prep_min: null,
      acknowledged_at: null,
    });
    expect(edit.changes).toEqual([
      { kind: 'quantity', name: 'شاورما', options: [], quantity: 3, quantityBefore: 2 },
      { kind: 'added', name: 'بطاطا', options: [], quantity: 1 },
    ]);
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.edited',
      actor_type: 'admin',
      reason: 'اتفقنا مع الزبون',
    });
    expect(await outboxReason(order.id, 'order.edited')).toBe('items_added');
    // The customer's summary: the new total, «أُضيف» and the quantity change.
    const seen = await customerOrder(order.customer, order.id);
    expect(seen.money.total).toBe(after.total);
    expect(
      seen.lines.map((line: { name: string; added: boolean; quantityBefore: number | null }) => [
        line.name,
        line.added,
        line.quantityBefore,
      ]),
    ).toEqual([
      ['شاورما', false, 2],
      ['بطاطا', true, null],
    ]);
    expect(seen.removedLines).toEqual([]);
  });

  it('removes a line, changes the delivery fee, and an edit without additions blocks nothing', async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    expect((await acknowledge(order.cashier, order.id)).statusCode).toBe(200);
    // Fries out, the shawarma back to two, the fee down.
    const answer = await ops.edit(order.id, {
      keep: [{ position: 0, quantity: 2 }],
      add: [],
      deliveryFee: '2000',
      extraPrepMin: null,
    });
    expect(answer.statusCode).toBe(200);
    expect(await money(order.id)).toMatchObject({ items_value: '24000', delivery_fee: '2000' });
    expect(await editRow(order.id)).toMatchObject({
      adds_items: false,
      delivery_fee_before: '4000',
      delivery_fee_after: '2000',
    });
    expect(await outboxReason(order.id, 'order.edited')).toBe('changed');
    const seen = await customerOrder(order.customer, order.id);
    expect(seen.removedLines).toEqual([{ name: 'بطاطا', quantity: 1, options: [] }]);
    // The line is back at its first quantity: no change shows.
    expect(seen.lines[0].quantityBefore).toBeNull();
    // Not acknowledged, but it added nothing: the pickup goes on at the new amount.
    const card = await boardOrder(order.cashier, order.id);
    expect(card.edits).toHaveLength(1);
    expect(card.edits[0].addsItems).toBe(false);
    expect((await captain.active()).json().order.editUnacknowledged).toBe(false);
    expect((await captain.requestPickup(order.id, '24000')).statusCode).toBe(200);
    // And no edit while the request is open.
    const during = await ops.edit(order.id, addFries);
    expect(during.statusCode).toBe(409);
    expect(during.json().error).toBe('pickup_request_open');
  });

  it('blocks the pickup until «اطلعت على التعديل» when items were added, and clears an open item report', async () => {
    const { order, captain } = await captainAtRestaurant();
    const ops = await admin(['OPS']);
    expect((await report(order.cashier, order.id)).statusCode).toBe(200);
    // The reported shawarma replaced by fries.
    const answer = await ops.edit(order.id, {
      keep: [],
      add: [{ itemId: fries, optionIds: [], quantity: 2 }],
      deliveryFee: null,
      extraPrepMin: null,
    });
    expect(answer.statusCode).toBe(200);
    expect(await reportRow(order.id)).toMatchObject({
      closed_how: 'edited',
      closed_by_type: 'admin',
    });
    expect((await ops.detail(order.id)).alerts).not.toContain('item_unavailable');
    expect((await captain.active()).json().order).toMatchObject({
      itemReportOpen: false,
      editUnacknowledged: true,
    });
    const blocked = await captain.requestPickup(order.id, '14600');
    expect(blocked.statusCode).toBe(409);
    expect(blocked.json().error).toBe('edit_unacknowledged');
    const card = await boardOrder(order.cashier, order.id);
    expect(card.edits).toEqual([
      {
        at: expect.any(String),
        addsItems: true,
        changes: [
          { kind: 'removed', name: 'شاورما', options: [], quantity: 2 },
          { kind: 'added', name: 'بطاطا', options: [], quantity: 2 },
        ],
        itemsValue: '14600',
        extraPrepMin: null,
      },
    ]);
    const acknowledged = await acknowledge(order.cashier, order.id);
    expect(acknowledged.statusCode).toBe(200);
    expect(acknowledged.json().order.edits).toEqual([]);
    expect(await editRow(order.id)).toMatchObject({ acknowledged_device: expect.any(String) });
    expect((await events(order.id)).at(-1)).toMatchObject({
      type: 'order.edit_acknowledged',
      actor_type: 'restaurant',
    });
    // A second acknowledgement has nothing to acknowledge.
    expect((await acknowledge(order.cashier, order.id)).statusCode).toBe(409);
    // The captain's request carries the new amount.
    expect((await captain.requestPickup(order.id, '24000')).json().error).toBe('amount_mismatch');
    expect((await captain.requestPickup(order.id, '14600')).statusCode).toBe(200);
    await switchOn(order.cashier);
  });

  it('sends a ready order back to preparing with the extra prep time, and moves the promised time', async () => {
    const order = await acceptedOrder();
    expect((await ready(order.cashier, order.id)).statusCode).toBe(200);
    const before = await times(order.id);
    const ops = await admin(['OPS']);
    const missing = await ops.edit(order.id, addFries);
    expect(missing.statusCode).toBe(400);
    expect(missing.json().error).toBe('invalid_edit');
    const preview = await ops.editPreview(order.id, { ...addFries, extraPrepMin: 10 });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({
      before: {
        itemsValue: '24000',
        deliveryFee: '4000',
        commission: '3600',
        merchantNet: '20400',
      },
      after: {
        itemsValue: '43300',
        deliveryFee: '4000',
        commission: '6495',
        merchantNet: '36805',
      },
      addsItems: true,
      backToPreparing: true,
    });
    expect(await money(order.id)).toMatchObject({ items_value: '24000' });
    const answer = await ops.edit(order.id, { ...addFries, extraPrepMin: 10 });
    expect(answer.statusCode).toBe(200);
    const after = await times(order.id);
    expect(after.status).toBe('accepted');
    expect(moved(after.promised_at, before.promised_at)).toBeGreaterThanOrEqual(10);
    expect(moved(after.promised_at, before.promised_at)).toBeLessThan(15);
    expect(after.promised_at.getTime() % (5 * MINUTE)).toBe(0);
    const row = (
      await sql.query('SELECT ready_at, no_captain_alert_at FROM ordering.orders WHERE id = $1', [
        order.id,
      ])
    ).rows[0];
    expect(row).toEqual({ ready_at: null, no_captain_alert_at: null });
    // The restaurant's countdown runs 10 minutes from now.
    const card = await boardOrder(order.cashier, order.id);
    const due = new Date(card.acceptance.prepDueAt).getTime();
    expect(due - Date.now()).toBeGreaterThan(9 * MINUTE);
    expect(due - Date.now()).toBeLessThanOrEqual(11 * MINUTE);
    expect(card.edits[0].extraPrepMin).toBe(10);
    expect(await editRow(order.id)).toMatchObject({
      status: 'ready',
      extra_prep_min: 10,
      prep_min_before: 20,
    });
    expect(await outboxReason(order.id, 'order.edited')).toBe('items_added_back_to_preparing');
  });

  it('refuses what an edit cannot do', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const refused = async (body: object) => {
      const answer = await ops.edit(order.id, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
    const base = {
      keep: [{ position: 0, quantity: 2 }],
      add: [],
      deliveryFee: null,
      extraPrepMin: null,
    };
    // Nothing changed, no line left, an unknown or repeated line.
    expect(await refused(base)).toBe('invalid_edit');
    expect(await refused({ ...base, keep: [] })).toBe('invalid_edit');
    expect(await refused({ ...base, keep: [{ position: 7, quantity: 1 }] })).toBe('invalid_edit');
    expect(
      await refused({
        ...base,
        keep: [
          { position: 0, quantity: 1 },
          { position: 0, quantity: 2 },
        ],
      }),
    ).toBe('invalid_edit');
    // Extra prep time only for a ready order with items added.
    expect(await refused({ ...addFries, extraPrepMin: 10 })).toBe('invalid_edit');
    // An item the menu has switched off.
    const unavailable = await app.inject({
      method: 'PUT',
      url: '/v1/merchant/menu/availability',
      headers: order.cashier,
      payload: { type: 'item', id: soldOut, available: false, until: 'turned_back_on' },
    });
    expect(unavailable.statusCode).toBe(200);
    expect(await refused({ ...base, add: [{ itemId: soldOut, optionIds: [], quantity: 1 }] })).toBe(
      'invalid_edit',
    );
    // A role without operations.manage, and an ended order.
    expect((await (await admin(['FIN'])).edit(order.id, addFries)).statusCode).toBe(403);
    const placed = await placedOrder();
    expect((await ops.edit(placed.id, addFries)).statusCode).toBe(200);
    const cancelled = await ops.cancel(placed.id, {
      cancellation: 'emergency',
      responsible: 'platform',
      foodPrepared: false,
      compensateCaptain: false,
      cash: null,
      reason: 'ملاحظة',
    });
    expect(cancelled.statusCode).toBe(200);
    const late = await ops.edit(placed.id, addFries);
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('order_state_changed');
  });

  it('answers a repeat of the key once', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const key = randomUUID();
    const body = { ...addFries, version: (await ops.detail(order.id)).version };
    expect((await ops.edit(order.id, body, key)).statusCode).toBe(200);
    expect((await ops.edit(order.id, body, key)).statusCode).toBe(200);
    const count = await sql.query(
      'SELECT count(*)::int AS n FROM ordering.order_edits WHERE order_id = $1',
      [order.id],
    );
    expect(count.rows[0].n).toBe(1);
    expect((await money(order.id)).items_value).toBe('43300');
  });

  it("lets the application role change only an edit's acknowledgement, and the panel shows the edit", async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    await expect(
      sql.query("UPDATE ordering.order_edits SET changes = '[]' WHERE order_id = $1", [order.id]),
    ).rejects.toThrow(/permission denied/);
    const detail = await ops.detail(order.id);
    expect(detail.edits).toHaveLength(1);
    expect(detail.edits[0]).toMatchObject({ addsItems: true, acknowledgedAt: null });
    expect(detail.timeline.at(-1)).toMatchObject({ type: 'order.edited' });
    expect(detail.editChoices).toMatchObject({ extraPrepMaxMin: expect.any(Number) });
  });

  it('acknowledges only the edits the prompt showed; a newer addition keeps blocking', async () => {
    const { order, captain } = await captainAtRestaurant();
    const ops = await admin(['OPS']);
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    const shown = (await boardOrder(order.cashier, order.id)).edits[0].at;
    const more = await ops.edit(order.id, {
      keep: [
        { position: 0, quantity: 3 },
        { position: 1, quantity: 2 },
      ],
      add: [],
      deliveryFee: null,
      extraPrepMin: null,
    });
    expect(more.statusCode).toBe(200);
    expect((await acknowledge(order.cashier, order.id, shown)).statusCode).toBe(200);
    const card = await boardOrder(order.cashier, order.id);
    expect(card.edits).toHaveLength(1);
    expect(card.edits[0].addsItems).toBe(true);
    expect((await captain.requestPickup(order.id, '50600')).json().error).toBe(
      'edit_unacknowledged',
    );
  });

  it('refuses an edit of an order that moved since the dialog showed it', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const shown = (await ops.detail(order.id)).version;
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    const stale = await app.inject({
      method: 'POST',
      url: `/v1/admin/orders/${order.id}/edit`,
      cookies: ops.cookies,
      headers: { 'idempotency-key': randomUUID() },
      payload: { ...addFries, keep: [{ position: 0, quantity: 1 }], version: shown, reason: 'x' },
    });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('order_state_changed');
    expect((await money(order.id)).items_value).toBe('43300');
    const huge = await ops.edit(order.id, { ...addFries, deliveryFee: '9'.repeat(30) });
    expect(huge.statusCode).toBe(400);
  });

  it('answers unknown_order for an unknown order and for another restaurant', async () => {
    const ops = await admin(['OPS']);
    const unknown = randomUUID();
    expect((await ops.edit(unknown, addFries)).statusCode).toBe(404);
    expect((await ops.editPreview(unknown, addFries)).statusCode).toBe(404);
    const order = await acceptedOrder();
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    const merchants = app.get(MerchantsService);
    const other = await merchants.createRestaurant(
      azaz,
      {
        nameAr: 'مطعم آخر',
        address: 'شارع آخر',
        location: centre,
        coverage: { kind: 'radius', radiusMetres: 1000 },
        minimumOrder: { amount: 10_000n, currency: 'TRY' },
        commissionBp: 1500,
        defaultPrepMin: 20,
      },
      change,
    );
    await merchants.setAccountStatus(other, 'active', change);
    const stranger = await acknowledge(await cashier(other), order.id, new Date().toISOString());
    expect(stranger.statusCode).toBe(404);
  });

  it('raises «المطعم لم يؤكد التعديل» after order.merchant_accept_alert_min', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    expect((await ops.edit(order.id, addFries)).statusCode).toBe(200);
    expect((await ops.detail(order.id)).alerts).not.toContain('edit_unacknowledged');
    const owner = new pg.Pool({ connectionString: database.migratorUrl });
    await owner.query(
      "UPDATE ordering.order_edits SET at = at - interval '4 minutes' WHERE order_id = $1",
      [order.id],
    );
    await owner.end();
    expect((await ops.detail(order.id)).alerts).toContain('edit_unacknowledged');
    expect((await acknowledge(order.cashier, order.id)).statusCode).toBe(200);
    expect((await ops.detail(order.id)).alerts).not.toContain('edit_unacknowledged');
  });

  it("moves the assigned captain's prep due time when a ready order goes back to preparing", async () => {
    const { order, captain, ops } = await captainAtRestaurant();
    expect((await ready(order.cashier, order.id)).statusCode).toBe(200);
    expect((await captain.active()).json().order.preparation.ready).toBe(true);
    expect((await ops.edit(order.id, { ...addFries, extraPrepMin: 15 })).statusCode).toBe(200);
    const preparation = (await captain.active()).json().order.preparation;
    expect(preparation.ready).toBe(false);
    expect(new Date(preparation.prepDueAt).getTime() - Date.now()).toBeGreaterThan(14 * MINUTE);
    expect((await customerOrder(order.customer, order.id)).edited).toBe(true);
  });
});

describe('POST /v1/admin/orders/{orderId}/edit after the pickup (AP §9.3.3)', () => {
  it('books a removal with the restaurant responsible: the value returned, its commission reversed', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const preview = await order.ops.editPreview(order.order.id, {
      ...oneShawarma,
      responsible: 'restaurant',
    });
    expect(preview.statusCode).toBe(200);
    expect(preview.json()).toMatchObject({ afterPickup: true, addsItems: false });
    expect(
      preview
        .json()
        .entries.map((entry: { type: string; account: string; amount: { amount: string } }) => [
          entry.type,
          entry.account,
          entry.amount.amount,
        ]),
    ).toEqual([
      ['merchant.debit', 'merchant.account', '12000'],
      ['merchant.debit', 'platform.order_clearing', '-12000'],
      ['merchant.commission', 'merchant.account', '-1800'],
      ['merchant.commission', 'platform.revenue_commission', '1800'],
    ]);
    const answer = await order.ops.edit(order.order.id, {
      ...oneShawarma,
      responsible: 'restaurant',
    });
    expect(answer.statusCode).toBe(200);
    expect(await money(order.order.id)).toMatchObject({ items_value: '12000', total: '16000' });
    expect(await editRow(order.order.id)).toMatchObject({
      status: 'picked_up',
      responsible: 'restaurant',
      charge: '12000',
      commission_cut: '1800',
    });
    expect(await outboxReason(order.order.id, 'order.edited')).toBe('removed_after_pickup');
    // The panel: what the captain paid stays, and the edit names its party.
    const detail = await order.ops.detail(order.order.id);
    expect(detail.money.pickupPayment).toBe('24000');
    expect(detail.edits.at(-1)).toMatchObject({ responsible: 'restaurant', charge: '12000' });
    expect(detail.editChoices).toMatchObject({ afterPickup: true, items: [] });
    // The restaurant's prompt is for edits before the pickup only.
    expect((await board(order.order.cashier, order.order.id)).edits).toEqual([]);
    // The captain collects the new total, and the clearing account settles.
    expect((await order.captain.active()).json().order.collect.amount).toBe('16000');
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    expect((await order.deliver('16000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      // The restaurant returns 12000 and pays the commission on what it kept.
      restaurant: -(12_000n + 1_800n),
      commission: 1_800n,
      delivery: 4_000n,
      operatingCost: 0n,
    });
  });

  it('charges the captain the merchant net and a lower fee, and the commission recovers the rest', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    const answer = await order.ops.edit(order.order.id, {
      ...oneShawarma,
      deliveryFee: '2000',
      responsible: 'captain',
    });
    expect(answer.statusCode).toBe(200);
    expect(await money(order.order.id)).toMatchObject({
      items_value: '12000',
      delivery_fee: '2000',
      total: '14000',
    });
    expect(await editRow(order.order.id)).toMatchObject({
      status: 'arrived',
      responsible: 'captain',
      // 12000 − 1800 of merchant net, and the 2000 off the fee.
      charge: '12200',
      commission_cut: '1800',
    });
    expect(await outboxReason(order.order.id, 'order.edited')).toBe('removed_after_pickup');
    expect((await order.deliver('14000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      earnings: ORDER_PAY - 12_200n,
      // The restaurant was paid in full: it owes the commission on all
      // 24000, of which the removed items' 1800 recovers the pickup payment.
      restaurant: -3_600n,
      commission: 1_800n,
      // The fee at the pickup is the platform's revenue; the captain bore the cut.
      delivery: 4_000n,
      operatingCost: 0n,
    });
  });

  it('books a lower fee alone on the platform as an operating cost', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    const answer = await order.ops.edit(order.order.id, {
      keep: [{ position: 0, quantity: 2 }],
      add: [],
      deliveryFee: '1000',
      extraPrepMin: null,
      responsible: 'platform',
    });
    expect(answer.statusCode).toBe(200);
    expect(await outboxReason(order.order.id, 'order.edited')).toBe('fee_lowered_after_pickup');
    expect(await money(order.order.id)).toMatchObject({ total: '25000' });
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    expect((await order.deliver('25000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances())).toMatchObject({
      clearing: 0n,
      operatingCost: 3_000n,
      restaurant: -3_600n,
      commission: 3_600n,
      delivery: 4_000n,
    });
  });

  it('settles several edits with different parties, and previews the frozen commission', async () => {
    const before = await balances();
    const order = await pickedUpOrder();
    expect(
      (await order.ops.edit(order.order.id, { ...oneShawarma, responsible: 'restaurant' }))
        .statusCode,
    ).toBe(200);
    const lowerFee = {
      keep: [{ position: 0, quantity: 1 }],
      add: [],
      deliveryFee: '1000',
      extraPrepMin: null,
      responsible: 'captain',
    };
    // The restaurant already gave back 12000 and its commission on them: it
    // owes 1800 and keeps 10200, and the captain's fee cut changes neither.
    const preview = (await order.ops.editPreview(order.order.id, lowerFee)).json();
    expect(preview.before).toMatchObject({ commission: '1800', merchantNet: '10200' });
    expect(preview.after).toMatchObject({ commission: '1800', merchantNet: '10200' });
    expect(preview.entries.map((entry: { reason: string }) => entry.reason)).toEqual([
      'خُفّضت أجرة التوصيل بعد الاستلام',
      'خُفّضت أجرة التوصيل بعد الاستلام',
    ]);
    expect((await order.ops.edit(order.order.id, lowerFee)).statusCode).toBe(200);
    expect(await money(order.order.id)).toMatchObject({ total: '13000' });
    expect((await order.arriveAtCustomer()).statusCode).toBe(200);
    expect((await order.deliver('13000')).statusCode).toBe(200);
    expect(moneyMoved(before, await balances(order.captain.captainId))).toMatchObject({
      clearing: 0n,
      restaurant: -(12_000n + 3_600n - 1_800n),
      earnings: ORDER_PAY - 3_000n,
      commission: 1_800n,
      delivery: 4_000n,
    });
  });

  it('previews a captain-responsible removal with the commission left on the restaurant', async () => {
    const order = await pickedUpOrder();
    const preview = (
      await order.ops.editPreview(order.order.id, { ...oneShawarma, responsible: 'captain' })
    ).json();
    expect(preview.before).toMatchObject({ commission: '3600', merchantNet: '20400' });
    expect(preview.after).toMatchObject({ commission: '3600', merchantNet: '20400' });
    expect(preview.entries[0]).toMatchObject({
      type: 'earn.charge',
      reason: 'أصناف حُذفت بعد الاستلام',
      account: 'captain.earnings',
      party: { kind: 'captain', name: 'كابتن التعديل' },
      amount: { amount: '10200', currency: 'TRY' },
    });
    // A dialog shown before the order moved is refused as such.
    const stale = await order.ops.edit(order.order.id, {
      ...oneShawarma,
      responsible: 'captain',
      version: (await order.ops.detail(order.order.id)).version - 1,
    });
    expect(stale.statusCode).toBe(409);
    expect(stale.json().error).toBe('order_state_changed');
  });

  it('refuses what an edit after the pickup cannot do', async () => {
    const order = await pickedUpOrder();
    const refused = async (body: object, status = 400) => {
      const answer = await order.ops.edit(order.order.id, body);
      expect(answer.statusCode).toBe(status);
      return answer.json().error;
    };
    // No responsible party, or the customer.
    expect(await refused(oneShawarma)).toBe('invalid_edit');
    await refused({ ...oneShawarma, responsible: 'customer' });
    // Additions, a raised quantity and a higher fee.
    expect(await refused({ ...addFries, responsible: 'platform' })).toBe('invalid_edit');
    expect(
      await refused({
        keep: [{ position: 0, quantity: 3 }],
        add: [],
        deliveryFee: null,
        extraPrepMin: null,
        responsible: 'platform',
      }),
    ).toBe('invalid_edit');
    expect(await refused({ ...oneShawarma, deliveryFee: '5000', responsible: 'platform' })).toBe(
      'invalid_edit',
    );
    expect(await editRow(order.order.id)).toBeUndefined();
    // Before the pickup, a responsible party is refused.
    const accepted = await acceptedOrder();
    const before = await order.ops.edit(accepted.id, { ...addFries, responsible: 'restaurant' });
    expect(before.statusCode).toBe(400);
    expect(before.json().error).toBe('invalid_edit');
  });
});
