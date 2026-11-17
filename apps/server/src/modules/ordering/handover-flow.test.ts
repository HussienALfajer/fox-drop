import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import {
  app,
  sql,
  captainSpot,
  acceptedOrder,
  brokenDown,
  besideThem,
  onlineCaptain,
  admin,
  requireAccept,
  pickedUpOrder,
  balance,
  events,
  handoverRows,
  orderRow,
} from './handover-flow.fixture.js';

describe('POST /v1/admin/orders/{orderId}/handover (AP §9.3.2, CA §9.10.1)', () => {
  it('offers the order «استلام من كابتن» to a second captain, who pays nothing', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('باسل الثاني', besideThem);
    // The picker after the pickup measures from the first captain and leaves
    // them out.
    const picker = await ops.picker(order.id);
    expect(picker.map((each: { captainId: string }) => each.captainId)).not.toContain(
      first.captainId,
    );
    const listed = picker.find(
      (each: { captainId: string }) => each.captainId === second.captainId,
    );
    expect(listed.eligible).toBe(true);
    expect(listed.distanceMetres).toBeLessThan(200);

    await requireAccept(true);
    try {
      const answer = await ops.handover(order.id, second.captainId);
      expect(answer.statusCode).toBe(200);
      expect(answer.json().order).toMatchObject({
        status: 'picked_up',
        captainId: first.captainId,
        captainTrack: 'picked_up',
        offer: { captainId: second.captainId, handover: true },
      });
      const offer = await second.currentOffer();
      expect(offer).toMatchObject({
        orderId: order.id,
        fromOperations: true,
        pickupPayment: { amount: '0', currency: 'TRY' },
        collect: { amount: '28000', currency: 'TRY' },
        handover: { fromCaptainName: 'سامر الأول', location: expect.objectContaining(brokenDown) },
      });
      expect(await handoverRows(order.id)).toEqual([
        {
          from_captain_id: first.captainId,
          to_captain_id: second.captainId,
          offered: true,
          note: 'تعطلت الدراجة',
          assigned: false,
          received: false,
          close_reason: null,
          seen: false,
        },
      ]);
      expect((await second.accept(offer.id)).statusCode).toBe(200);
      expect((await handoverRows(order.id))[0]).toMatchObject({ assigned: true });
      // The second captain is busy; the order stays the first's until the
      // receipt (owner decision 2026-11-11).
      expect((await second.availability()).state).toBe('busy');
      expect(await orderRow(order.id)).toMatchObject({
        status: 'picked_up',
        captain_id: first.captainId,
      });
      expect((await events(order.id)).slice(-2)).toEqual([
        {
          type: 'order.handover_offered',
          actor_type: 'admin',
          reason: 'تعطلت الدراجة',
          captain_id: second.captainId,
          from_status: 'picked_up',
          to_status: 'picked_up',
        },
        {
          type: 'order.handover_assigned',
          actor_type: 'captain',
          reason: null,
          captain_id: second.captainId,
          from_status: 'picked_up',
          to_status: 'picked_up',
        },
      ]);
    } finally {
      await requireAccept(false);
    }
  });

  it('closes the handover when the offer is declined, and opens another', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('رافض', besideThem);
    await requireAccept(true);
    try {
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const offer = await second.currentOffer();
      expect((await second.decline(offer.id)).statusCode).toBe(200);
      expect(await handoverRows(order.id)).toMatchObject([{ close_reason: 'declined' }]);
      expect((await events(order.id)).at(-1)).toMatchObject({
        type: 'order.handover_closed',
        reason: 'declined',
      });
      expect((await second.availability()).state).toBe('online_available');
      const third = await onlineCaptain('قابل', besideThem);
      expect((await ops.handover(order.id, third.captainId)).statusCode).toBe(200);
    } finally {
      await requireAccept(false);
    }
  });

  it('assigns the handover at once without manual_assign_requires_accept', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('مباشر', besideThem);
    const custody = await balance('captain.custody', first.captainId);
    expect((await ops.detail(order.id)).handover).toEqual({ allowed: true, handovers: [] });
    const answer = await ops.handover(order.id, second.captainId);
    expect(answer.statusCode).toBe(200);
    expect(answer.json().order.offer).toBeNull();
    // AP §9.3.1: the detail lists it; another would replace it.
    expect((await ops.detail(order.id)).handover).toMatchObject({
      allowed: true,
      handovers: [
        {
          fromCaptainId: first.captainId,
          fromCaptainName: 'سامر الأول',
          toCaptainId: second.captainId,
          toCaptainName: 'مباشر',
          offered: false,
          receivedAt: null,
          closeReason: null,
          note: 'تعطلت الدراجة',
          adminId: ops.accountId,
        },
      ],
    });
    expect(await handoverRows(order.id)).toMatchObject([{ offered: false, assigned: true }]);
    expect((await second.availability()).state).toBe('busy');
    // Nothing moves in the ledger until the delivery: the pickup payment
    // stays in the first captain's custody.
    expect(await balance('captain.custody', first.captainId)).toBe(custody);
  });

  it('refuses before the pickup and the order’s own captain', async () => {
    const order = await acceptedOrder();
    const ops = await admin(['OPS']);
    const second = await onlineCaptain('مبكر', besideThem);
    const early = await ops.handover(order.id, second.captainId);
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_not_handoverable');

    const picked = await pickedUpOrder();
    const own = await picked.ops.handover(picked.order.id, picked.first.captainId);
    expect(own.statusCode).toBe(409);
    expect(own.json()).toMatchObject({ error: 'captain_not_eligible', reasons: ['busy'] });
  });
});

describe('POST /v1/captain/orders/{orderId}/receive-handover (CA §9.10.1, §15)', () => {
  it('hands an arrived order to the second captain near the first, who delivers it', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await first.arriveAtCustomer(order.id)).statusCode).toBe(200);
    await first.moveTo(brokenDown);
    const custody = await balance('captain.custody', first.captainId);
    expect(custody).toBe(-24_000n);
    const second = await onlineCaptain('باسل الثاني', captainSpot);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);

    // The first captain waits: their screen names the second, with a call
    // button, and their own steps are refused meanwhile.
    const giving = (await first.active()).order;
    expect(giving.handover).toMatchObject({
      role: 'giving',
      assigned: true,
      captain: { name: 'باسل الثاني', phone: expect.stringMatching(/^\+9639/) },
    });
    const early = await first.deliver(order.id);
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('order_state_changed');
    await first.moveTo(brokenDown);

    // The second captain is led to the first and pays nothing.
    const receiving = (await second.active()).order;
    expect(receiving).toMatchObject({
      id: order.id,
      pickupPayment: { amount: '0', currency: 'TRY' },
      collect: { amount: '28000', currency: 'TRY' },
      handover: {
        role: 'receiving',
        assigned: true,
        captain: {
          name: 'سامر الأول',
          location: expect.objectContaining(brokenDown),
        },
      },
    });
    // Too far from the first captain.
    const far = await second.receive(order.id);
    expect(far.statusCode).toBe(409);
    expect(far.json()).toMatchObject({ error: 'too_far_from_captain' });
    expect(far.json().distanceMetres).toBeGreaterThan(200);

    await second.moveTo(besideThem);
    const received = await second.receive(order.id);
    expect(received.statusCode).toBe(200);
    expect(received.json().order).toMatchObject({
      status: 'picked_up',
      captainTrack: 'picked_up',
      handover: null,
      customer: { arrival: null },
    });
    // docs/domain/01: arrived back to picked_up with the door arrival
    // cleared; the order is the second captain's now.
    expect(await orderRow(order.id)).toEqual({
      status: 'picked_up',
      captain_id: second.captainId,
      captain_track: 'picked_up',
      arrived_at_customer_at: null,
      away_reason: null,
    });
    expect((await events(order.id)).at(-1)).toEqual({
      type: 'order.handed_over',
      actor_type: 'captain',
      reason: null,
      captain_id: second.captainId,
      from_status: 'arrived',
      to_status: 'picked_up',
    });
    expect(await handoverRows(order.id)).toMatchObject([{ received: true, seen: false }]);

    // K17: the first captain is offline, the order gone from their app,
    // and the card «سلّمت الطلب للكابتن {الاسم}» shows until «حسناً».
    expect((await first.availability()).state).toBe('offline');
    const { rows: periods } = await sql.query(
      `SELECT end_reason FROM captains.online_periods
         WHERE captain_id = $1 ORDER BY started_at DESC LIMIT 1`,
      [first.captainId],
    );
    expect(periods).toEqual([{ end_reason: 'handed_over' }]);
    const firstNow = await first.active();
    expect(firstNow.order).toBeNull();
    expect(firstNow.handedOver).toMatchObject({
      orderId: order.id,
      toCaptainName: 'باسل الثاني',
    });
    const seen = await first.acknowledgeHandover(order.id);
    expect(seen.statusCode).toBe(200);
    expect(seen.json().handedOver).toBeNull();

    // The second captain collects at the door and earns the order pay; the
    // pickup payment stays in the first captain's custody (AP §9.3.2).
    expect((await second.arriveAtCustomer(order.id)).statusCode).toBe(200);
    const delivered = await second.deliver(order.id);
    expect(delivered.statusCode).toBe(200);
    expect(delivered.json().summary).toMatchObject({
      pay: { total: '2500', waiting: '0' },
      custodyChange: { amount: '28000' },
    });
    expect(await balance('captain.custody', second.captainId)).toBe(28_000n);
    expect(await balance('captain.earnings', second.captainId)).toBe(2_500n);
    expect(await balance('captain.custody', first.captainId)).toBe(-24_000n);
    expect(await balance('captain.earnings', first.captainId)).toBe(0n);

    // CU §12.1 (slice 2.26a): «قيّم الكابتن» rates the captain who delivered.
    const rated = await app.inject({
      method: 'POST',
      url: `/v1/customer/orders/${order.id}/rating`,
      headers: order.customer,
      payload: { restaurant: null, captain: { stars: 5, reasons: [], comment: null } },
    });
    expect(rated.statusCode).toBe(200);
    const { rows: ratings } = await sql.query(
      'SELECT captain_id FROM ordering.ratings WHERE order_id = $1',
      [order.id],
    );
    expect(ratings).toEqual([{ captain_id: second.captainId }]);
  });

  it('refuses a captain who is not the handover’s second captain', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('ثاني', besideThem);
    const stranger = await onlineCaptain('غريب', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    expect((await stranger.receive(order.id)).statusCode).toBe(404);
    expect((await stranger.active()).order).toBeNull();
  });

  it('ends an open handover when operations record the delivery', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('منتظر', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    // The assigned handover is the second captain's active order (K18).
    expect((await second.lastOrder()).json().availability.state).toBe('last_order');
    const recorded = await ops.post(`/v1/admin/orders/${order.id}/record-delivery`, {
      received: [{ currency: 'TRY', amount: '28000' }],
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'سلّمه الكابتن الأول بنفسه',
    });
    expect(recorded.statusCode).toBe(200);
    expect(await handoverRows(order.id)).toMatchObject([{ close_reason: 'ended' }]);
    // Slice 2.13a: the order left them with the handover, so their last
    // order ended.
    expect((await second.availability()).state).toBe('offline');
    expect((await second.active()).order).toBeNull();
  });
});

describe('the handover tables (AP §9.7.4)', () => {
  it('lets the application role change only the steps of a handover', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('جدول', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    await expect(
      sql.query("UPDATE ordering.handovers SET note = 'x' WHERE order_id = $1", [order.id]),
    ).rejects.toThrow(/permission denied/);
  });
});

describe('the handover after «لا أستطيع إكمال الطلب» (CA §9.11, AP §9.7.6; slice 2.13b)', () => {
  const faults = async (orderId: string) =>
    (
      await sql.query(
        'SELECT captain_fault FROM ordering.handovers WHERE order_id = $1 ORDER BY opened_at',
        [orderId],
      )
    ).rows.map((row) => row.captain_fault);

  it('keeps the fault operations chose while the request is open, and the receipt closes it', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const asked = await app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${order.id}/cannot-complete`,
      headers: { ...first.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...brokenDown,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        reason: 'vehicle_breakdown',
        note: null,
      },
    });
    expect(asked.statusCode).toBe(200);
    expect((await ops.detail(order.id)).cannotComplete).toMatchObject({
      captainId: first.captainId,
    });
    const second = await onlineCaptain('بلا خطأ', besideThem);
    const handedOver = await ops.post(`/v1/admin/orders/${order.id}/handover`, {
      captainId: second.captainId,
      reason: 'حادث',
      captainFault: false,
    });
    expect(handedOver.statusCode).toBe(200);
    expect(await faults(order.id)).toEqual([false]);
    expect((await ops.detail(order.id)).handover.handovers[0].captainFault).toBe(false);
    expect((await second.receive(order.id)).statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT closed_how FROM ordering.cannot_complete_requests WHERE order_id = $1',
      [order.id],
    );
    expect(rows).toEqual([{ closed_how: 'handed_over' }]);
    expect((await first.availability()).state).toBe('offline');
  });

  const ask = (captain: { headers: Record<string, string> }, orderId: string, path = '') =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${orderId}/cannot-complete${path}`,
      headers: { ...captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...brokenDown,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
        ...(path === '' ? { reason: 'vehicle_breakdown', note: null } : {}),
      },
    });
  const periodEnd = async (captainId: string) =>
    (
      await sql.query(
        `SELECT end_reason FROM captains.online_periods WHERE captain_id = $1
          ORDER BY started_at DESC LIMIT 1`,
        [captainId],
      )
    ).rows[0].end_reason;
  const closedHow = async (orderId: string) =>
    (
      await sql.query(
        'SELECT closed_how FROM ordering.cannot_complete_requests WHERE order_id = $1',
        [orderId],
      )
    ).rows.map((row) => row.closed_how);

  it('takes the captain offline when the order is delivered with the request open (K17)', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await ask(first, order.id)).statusCode).toBe(200);
    const recorded = await ops.post(`/v1/admin/orders/${order.id}/record-delivery`, {
      received: [{ currency: 'TRY', amount: '28000' }],
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'أوصله الكابتن بنفسه',
    });
    expect(recorded.statusCode).toBe(200);
    expect(await closedHow(order.id)).toEqual(['ended']);
    expect(await periodEnd(first.captainId)).toBe('cannot_complete');
  });

  it('ends a last order with cannot_complete after an outcome, and refuses another captain’s «تراجع»', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await first.lastOrder()).statusCode).toBe(200);
    expect((await ask(first, order.id)).statusCode).toBe(200);
    const stranger = await onlineCaptain('غريب', besideThem);
    expect((await ask(stranger, order.id, '/withdraw')).statusCode).toBe(404);
    const { version } = await ops.detail(order.id);
    const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
      version,
      reason: 'تعطلت الدراجة',
    });
    expect(outcome.statusCode).toBe(200);
    expect(await closedHow(order.id)).toEqual(['ended']);
    expect(await periodEnd(first.captainId)).toBe('cannot_complete');
    // The order ended: nothing left to withdraw.
    expect((await ask(first, order.id, '/withdraw')).json()).toMatchObject({
      error: 'order_state_changed',
    });
  });

  it('keeps no fault on a handover without a request', async () => {
    const plain = await pickedUpOrder();
    const second = await onlineCaptain('عادي', besideThem);
    expect(
      (
        await plain.ops.post(`/v1/admin/orders/${plain.order.id}/handover`, {
          captainId: second.captainId,
          reason: 'تأخر',
          captainFault: false,
        })
      ).statusCode,
    ).toBe(200);
    expect(await faults(plain.order.id)).toEqual([null]);
  });
});

describe('the handover after «طوارئ» (CA §9.11, AP §9.7.6; slice 2.13c)', () => {
  const press = (captain: { headers: Record<string, string> }, orderId: string) =>
    app.inject({
      method: 'POST',
      url: `/v1/captain/orders/${orderId}/emergency`,
      headers: { ...captain.headers, 'idempotency-key': randomUUID() },
      payload: {
        location: {
          ...brokenDown,
          accuracyMetres: 10,
          recordedAt: new Date().toISOString(),
          simulated: false,
        },
      },
    });

  it('counts no fault by default, and the receipt closes it and takes the first captain offline', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await press(first, order.id)).statusCode).toBe(200);
    const second = await onlineCaptain('بعد الطوارئ', besideThem);
    const handedOver = await ops.post(`/v1/admin/orders/${order.id}/handover`, {
      captainId: second.captainId,
      reason: 'حادث',
      captainFault: null,
    });
    expect(handedOver.statusCode).toBe(200);
    const { rows: faults } = await sql.query(
      'SELECT captain_fault FROM ordering.handovers WHERE order_id = $1',
      [order.id],
    );
    expect(faults).toEqual([{ captain_fault: false }]);
    expect((await second.receive(order.id)).statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT closed_how FROM ordering.emergencies WHERE order_id = $1',
      [order.id],
    );
    expect(rows).toEqual([{ closed_how: 'handed_over' }]);
    expect((await first.availability()).state).toBe('offline');
  });

  it('takes the captain offline when operations record the delivery with it open (K17)', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await press(first, order.id)).statusCode).toBe(200);
    const recorded = await ops.post(`/v1/admin/orders/${order.id}/record-delivery`, {
      received: [{ currency: 'TRY', amount: '28000' }],
      change: [],
      amountDue: { amount: '28000', currency: 'TRY' },
      shortfall: null,
      reason: 'أوصله الكابتن بعد الطوارئ',
    });
    expect(recorded.statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT closed_how FROM ordering.emergencies WHERE order_id = $1',
      [order.id],
    );
    expect(rows).toEqual([{ closed_how: 'ended' }]);
    const { rows: periods } = await sql.query(
      `SELECT end_reason FROM captains.online_periods WHERE captain_id = $1
        ORDER BY started_at DESC LIMIT 1`,
      [first.captainId],
    );
    expect(periods).toEqual([{ end_reason: 'emergency' }]);
  });

  it('ends the period with emergency after an outcome', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await press(first, order.id)).statusCode).toBe(200);
    const { version } = await ops.detail(order.id);
    const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
      version,
      reason: 'حادث',
    });
    expect(outcome.statusCode).toBe(200);
    expect((await first.availability()).state).toBe('offline');
  });
});
