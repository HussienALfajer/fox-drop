import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { CaptainsService } from '../captains/index.js';
import { DispatchService } from '../dispatch/index.js';
import {
  app,
  sql,
  besideThem,
  onlineCaptain,
  requireAccept,
  pickedUpOrder,
  balance,
  events,
  handoverRows,
  waitedAtRestaurant,
} from './handover-flow.fixture.js';

describe('the handover’s pay and its other ways out (slice 2.12b)', () => {
  it('pays the first captain’s waiting to nobody after a handover (AP §9.3.2)', async () => {
    // Without a handover the waiting is paid (the control).
    const control = await pickedUpOrder();
    await waitedAtRestaurant(control.order.id);
    expect((await control.first.arriveAtCustomer(control.order.id)).statusCode).toBe(200);
    const paid = await control.first.deliver(control.order.id);
    expect(paid.json().summary.pay).toMatchObject({ waiting: '2000', total: '4500' });

    const { order, first, ops } = await pickedUpOrder();
    await waitedAtRestaurant(order.id);
    const second = await onlineCaptain('بلا انتظار', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    expect((await second.receive(order.id)).statusCode).toBe(200);
    expect((await second.arriveAtCustomer(order.id)).statusCode).toBe(200);
    const delivered = await second.deliver(order.id);
    expect(delivered.json().summary.pay).toMatchObject({ waiting: '0', total: '2500' });
    expect(await balance('captain.earnings', second.captainId)).toBe(2_500n);
    expect(await balance('captain.earnings', first.captainId)).toBe(0n);
  });

  it('replaces an assigned handover with another captain (owner decision 2026-11-11)', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('لم يصل', besideThem);
    const third = await onlineCaptain('البديل', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    expect((await second.lastOrder()).statusCode).toBe(200);
    expect((await ops.detail(order.id)).handover.allowed).toBe(true);
    expect((await ops.handover(order.id, third.captainId)).statusCode).toBe(200);
    expect(await handoverRows(order.id)).toMatchObject([
      { to_captain_id: second.captainId, close_reason: 'replaced' },
      { to_captain_id: third.captainId, assigned: true, close_reason: null },
    ]);
    // Slice 2.13a: replaced while in last-order mode, the second captain is
    // offline.
    expect((await second.availability()).state).toBe('offline');
    expect((await second.active()).order).toBeNull();
    expect((await third.active()).order.handover).toMatchObject({ role: 'receiving' });
    expect((await second.receive(order.id)).statusCode).toBe(404);
  });

  it('replaces an offered handover, withdrawing its offer', async () => {
    const { order, ops } = await pickedUpOrder();
    const second = await onlineCaptain('معروض عليه', besideThem);
    const third = await onlineCaptain('بديل العرض', besideThem);
    await requireAccept(true);
    try {
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const offered = await second.currentOffer();
      // Not accepted yet: the second captain cannot receive it.
      expect((await second.receive(order.id)).statusCode).toBe(409);
      expect((await ops.handover(order.id, third.captainId)).statusCode).toBe(200);
      expect(await second.currentOffer()).toBeNull();
      expect((await second.accept(offered.id)).statusCode).toBe(409);
      expect(await handoverRows(order.id)).toMatchObject([
        { close_reason: 'replaced' },
        { to_captain_id: third.captainId, offered: true, close_reason: null },
      ]);
    } finally {
      await requireAccept(false);
    }
  });

  it('closes a handover whose offer expires or whose captain goes offline', async () => {
    const expiring = await pickedUpOrder();
    const leaving = await pickedUpOrder();
    await requireAccept(true);
    try {
      const late = await onlineCaptain('لم يرد', besideThem);
      const state = await expiring.ops.handover(expiring.order.id, late.captainId);
      const { offer } = state.json().order;
      const [{ placed_at: placedAt }] = (
        await sql.query('SELECT placed_at FROM ordering.orders WHERE id = $1', [expiring.order.id])
      ).rows;
      const dispatch = app.get(DispatchService);
      const job = {
        offerId: offer.id,
        orderId: expiring.order.id,
        orderPlacedAt: new Date(placedAt).toISOString(),
      };
      const after = new Date(Date.parse(offer.expiresAt) + 1000);
      expect(await dispatch.expire(job, after)).toBe(true);
      // A late or repeated job changes nothing.
      expect(await dispatch.expire(job, after)).toBe(false);
      expect(await handoverRows(expiring.order.id)).toMatchObject([{ close_reason: 'expired' }]);

      const gone = await onlineCaptain('خرج', besideThem);
      expect((await leaving.ops.handover(leaving.order.id, gone.captainId)).statusCode).toBe(200);
      await app.get(CaptainsService).goOffline(gone.captainId, new Date());
      expect(await handoverRows(leaving.order.id)).toMatchObject([{ close_reason: 'withdrawn' }]);
    } finally {
      await requireAccept(false);
    }
  });

  it('ends an open handover with «تحديد النتيجة», its offer included', async () => {
    const { order, ops } = await pickedUpOrder();
    await requireAccept(true);
    try {
      const second = await onlineCaptain('عرض انتهى', besideThem);
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const { version } = await ops.detail(order.id);
      const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
        outcome: 'failed_other',
        responsible: 'platform',
        delivered: false,
        food: 'kept_by_captain',
        version,
        reason: 'تلف الطعام في الحادث',
      });
      expect(outcome.statusCode).toBe(200);
      expect(await handoverRows(order.id)).toMatchObject([{ close_reason: 'ended' }]);
      expect(await second.currentOffer()).toBeNull();
    } finally {
      await requireAccept(false);
    }
  });

  // CA §7.3 (slice 2.13a): «تحديد النتيجة» takes the order from its captain,
  // so their last order ends.
  it('takes a captain in last-order mode offline when operations set a failed outcome', async () => {
    const { order, first, ops } = await pickedUpOrder();
    expect((await first.lastOrder()).statusCode).toBe(200);
    const { version } = await ops.detail(order.id);
    const outcome = await ops.post(`/v1/admin/orders/${order.id}/outcome`, {
      outcome: 'failed_other',
      responsible: 'platform',
      delivered: false,
      food: 'kept_by_captain',
      version,
      reason: 'تعذّر الوصول إلى الزبون',
    });
    expect(outcome.statusCode).toBe(200);
    expect((await first.availability()).state).toBe('offline');
  });

  it('holds the first captain’s steps and gives a giver no details before the acceptance', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('لم يقبل بعد', besideThem);
    await requireAccept(true);
    try {
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const giving = (await first.active()).order.handover;
      expect(giving).toMatchObject({
        role: 'giving',
        assigned: false,
        captain: { name: 'لم يقبل بعد', phone: null, location: null },
      });
      const arrive = await first.arriveAtCustomer(order.id);
      expect(arrive.statusCode).toBe(409);
      expect(arrive.json().error).toBe('order_state_changed');
    } finally {
      await requireAccept(false);
    }
  });

  it('answers a repeated receipt with the order, and 404 to a captain who never handed over', async () => {
    const { order, first, ops } = await pickedUpOrder();
    const second = await onlineCaptain('مكرر', besideThem);
    expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
    const key = randomUUID();
    const receive = () =>
      app.inject({
        method: 'POST',
        url: `/v1/captain/orders/${order.id}/receive-handover`,
        headers: { ...second.headers, 'idempotency-key': key },
        payload: {
          location: {
            ...besideThem,
            accuracyMetres: 10,
            recordedAt: new Date().toISOString(),
            simulated: false,
          },
        },
      });
    expect((await receive()).statusCode).toBe(200);
    const again = await receive();
    expect(again.statusCode).toBe(200);
    expect(again.json().order.status).toBe('picked_up');
    expect((await events(order.id)).filter((e) => e.type === 'order.handed_over')).toHaveLength(1);
    expect((await second.acknowledgeHandover(order.id)).statusCode).toBe(404);
    expect((await first.acknowledgeHandover(order.id)).statusCode).toBe(200);
  });
});
