import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { admin, app, onlineCaptain, orderAtDoor, sql } from './delivery.fixture.js';

// AP §9.7.5–9.7.6, CA §11.3, §14 #25 (slice 2.36b): «تسجيل مخالفة» in the
// panel's «المخالفات والإيقافات», with the ladder's suggestion and the
// consequence of the step the admin confirms.
const pushes = async (captainId: string, templateKey: string) =>
  (
    await sql.query(
      'SELECT body FROM notifications.push_messages WHERE captain_id = $1 AND template_key = $2 ORDER BY created_at',
      [captainId, templateKey],
    )
  ).rows.map((row) => row.body as string);

const record = (
  ops: Awaited<ReturnType<typeof admin>>,
  captainId: string,
  fields: Partial<{
    severe: boolean;
    typeCode: string;
    typeNote: string | null;
    step: string;
    orderId: string | null;
    reason: string;
  }>,
  key?: string,
) =>
  ops.post(
    `/v1/admin/captains/${captainId}/violations`,
    {
      severe: false,
      typeCode: 'repeated_delay',
      typeNote: null,
      step: 'warning',
      orderId: null,
      reason: 'تأخر ثلاث مرات هذا الأسبوع',
      ...fields,
    },
    key,
  );

describe('«تسجيل مخالفة» (AP §9.7.5–9.7.6)', () => {
  it('suggests the ladder, records a warning on an order, then suspends for a day', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const { captainId } = door.captain;
    const ops = await admin(['OPS']);

    const empty = await ops.get(`/v1/admin/captains/${captainId}/violations`);
    expect(empty.statusCode).toBe(200);
    expect(empty.json()).toMatchObject({
      violations: [],
      suggestion: { step: 'warning', windowDays: 90 },
      suspensions: [],
    });
    expect(empty.json().types.regular.map((type: { code: string }) => type.code)).toEqual([
      'repeated_delay',
      'customer_mistreatment',
      'overcharging',
      'no_helmet',
      'packaging_neglect',
      'other',
    ]);
    expect(empty.json().types.severe.map((type: { label: string }) => type.label)).toEqual([
      'سرقة',
      'تحرش',
      'عنف',
    ]);

    const key = randomUUID();
    const warned = await record(ops, captainId, { orderId: door.order.id }, key);
    expect(warned.statusCode).toBe(201);
    expect(warned.json().violations).toEqual([
      expect.objectContaining({
        typeLabel: 'تأخير متكرر',
        severe: false,
        suggestedStep: 'warning',
        step: 'warning',
        orderId: door.order.id,
        orderNumber: expect.any(String),
        suspendedUntil: null,
        appeal: null,
      }),
    ]);
    expect(warned.json().suggestion.step).toBe('suspension_1d');
    // A repeat of the key records nothing more; another body is refused.
    expect(
      (await record(ops, captainId, { orderId: door.order.id }, key)).json().violations,
    ).toHaveLength(1);
    const reused = await record(ops, captainId, { reason: 'غير ذلك' }, key);
    expect(reused.statusCode).toBe(422);
    expect(reused.json().error).toBe('idempotency_key_reused');
    expect(await pushes(captainId, 'captain.violation')).toEqual([
      'سُجّلت عليك مخالفة: تأخير متكرر — تنبيه',
    ]);

    const suspended = await record(ops, captainId, {
      typeCode: 'other',
      typeNote: 'رمى الطلب',
      step: 'suspension_1d',
    });
    expect(suspended.statusCode).toBe(201);
    const latest = suspended.json().violations[0];
    expect(latest).toMatchObject({
      typeLabel: 'أخرى',
      typeNote: 'رمى الطلب',
      suggestedStep: 'suspension_1d',
      step: 'suspension_1d',
    });
    const until = new Date(latest.suspendedUntil).getTime();
    expect(until - new Date(latest.recordedAt).getTime()).toBe(86_400_000);
    const profile = (await ops.get(`/v1/admin/captains/${captainId}/profile`)).json();
    expect(profile.status).toBe('suspended');
    expect(profile.suspension.reason).toBe('إيقاف يوم: أخرى: رمى الطلب');
    // The violation's push tells it; the suspension's own is not sent too.
    expect(await pushes(captainId, 'captain.violation')).toEqual([
      'سُجّلت عليك مخالفة: تأخير متكرر — تنبيه',
      'سُجّلت عليك مخالفة: أخرى: رمى الطلب — إيقاف يوم',
    ]);
    expect(await pushes(captainId, 'captain.suspended')).toEqual([]);
    expect(suspended.json().suspensions).toEqual([
      expect.objectContaining({
        status: 'suspended',
        until: latest.suspendedUntil,
        reason: 'إيقاف يوم: أخرى: رمى الطلب',
      }),
    ]);
    expect(suspended.json().suggestion.step).toBe('suspension_7d');
  });

  it('refuses a wrong type, an order not the captain’s, and the termination of a captain with no contract', async () => {
    const { captainId } = await onlineCaptain();
    const ops = await admin(['OPS']);
    expect((await record(ops, captainId, { typeCode: 'theft' })).json().error).toBe(
      'unknown_reason',
    );
    expect((await record(ops, captainId, { typeCode: 'other' })).json().error).toBe(
      'reason_note_required',
    );
    const order = await record(ops, captainId, { orderId: randomUUID() });
    expect(order.statusCode).toBe(400);
    expect(order.json().error).toBe('unknown_order');
    const severe = await record(ops, captainId, {
      severe: true,
      typeCode: 'theft',
      step: 'termination',
    });
    expect(severe.statusCode).toBe(409);
    expect(severe.json().error).toBe('no_contract');
    // Nothing was recorded by the refusals.
    const read = (await ops.get(`/v1/admin/captains/${captainId}/violations`)).json();
    expect(read.violations).toEqual([]);
    const sup = await admin(['SUP']);
    expect((await record(sup, captainId, {})).statusCode).toBe(403);
    expect((await ops.get(`/v1/admin/captains/${randomUUID()}/violations`)).statusCode).toBe(404);
  });
});

// CA §11.3, AP §9.7.5, CA §14 #30 (slice 2.36b): «اعتراض» opens a ticket and
// its resolution records the outcome on the violation.
describe('«اعتراض» (CA §11.3)', () => {
  it('opens a ticket the panel sees; accepted, it voids the violation and lifts its suspension', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const { captainId, headers } = door.captain;
    const ops = await admin(['OPS']);
    const recorded = await record(ops, captainId, { step: 'suspension_1d' });
    const violationId = recorded.json().violations[0].id as string;
    const appeal = (key: string, text = 'كان الطريق مغلقاً') =>
      app.inject({
        method: 'POST',
        url: `/v1/captain/violations/${violationId}/appeal`,
        headers: { ...headers, 'idempotency-key': key },
        payload: { text, photoUploadId: null },
      });
    const key = randomUUID();
    const opened = await appeal(key);
    expect(opened.statusCode).toBe(200);
    const ticket = opened.json().ticket;
    expect(ticket).toMatchObject({
      typeLabel: 'اعتراض على مخالفة',
      description: 'كان الطريق مغلقاً',
      status: 'new',
      openedBy: 'me',
    });
    // A repeat answers the ticket; a second appeal is refused.
    expect((await appeal(key)).json().ticket.id).toBe(ticket.id);
    const again = await appeal(randomUUID());
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('already_appealed');
    const unknown = await app.inject({
      method: 'POST',
      url: `/v1/captain/violations/${randomUUID()}/appeal`,
      headers: { ...headers, 'idempotency-key': randomUUID() },
      payload: { text: 'x', photoUploadId: null },
    });
    expect(unknown.statusCode).toBe(404);
    // «بلاغاتي» lists it; the panel sees it on the violation.
    const mine = await app.inject({ method: 'GET', url: '/v1/captain/reports', headers });
    expect(mine.json().tickets.map((each: { id: string }) => each.id)).toContain(ticket.id);
    const listed = (await ops.get(`/v1/admin/captains/${captainId}/violations`)).json();
    expect(listed.violations[0].appeal).toMatchObject({ ticketId: ticket.id, outcome: null });
    expect(listed.suggestion.step).toBe('suspension_1d');

    // SUP cannot decide it, nor can anyone close it.
    const { cityId } = (await ops.get(`/v1/admin/captains/${captainId}/profile`)).json();
    const sup = await admin(['SUP']);
    const bySup = await sup.post(`/v1/admin/tickets/${ticket.id}/resolve`, {
      cityId,
      resolution: 'appeal_accepted',
      responsible: null,
      message: 'قبلنا اعتراضك',
      receivedLines: null,
    });
    expect(bySup.statusCode).toBe(403);
    const closed = await ops.post(`/v1/admin/tickets/${ticket.id}/close`, {
      cityId,
      reason: 'لا شيء',
    });
    expect(closed.statusCode).toBe(409);
    expect(closed.json().error).toBe('appeal_needs_decision');
    const wrong = await ops.post(`/v1/admin/tickets/${ticket.id}/resolve`, {
      cityId,
      resolution: 'none_explained',
      responsible: 'captain',
      message: 'x',
      receivedLines: null,
    });
    expect(wrong.statusCode).toBe(400);

    const accepted = await ops.post(`/v1/admin/tickets/${ticket.id}/resolve`, {
      cityId,
      resolution: 'appeal_accepted',
      responsible: null,
      message: 'قبلنا اعتراضك وأُلغيت المخالفة',
      receivedLines: null,
    });
    expect(accepted.statusCode).toBe(200);
    const after = (await ops.get(`/v1/admin/captains/${captainId}/violations`)).json();
    expect(after.violations[0].appeal).toMatchObject({ outcome: 'accepted' });
    // Voided: the ladder starts again, and the suspension it set is lifted.
    expect(after.suggestion.step).toBe('warning');
    const profile = (await ops.get(`/v1/admin/captains/${captainId}/profile`)).json();
    expect(profile.status).not.toBe('suspended');
    expect(await pushes(captainId, 'captain.ticket_resolved')).toEqual([
      expect.stringMatching(/^تم الرد على بلاغك T-\d+$/),
    ]);
    const performance = await app.inject({
      method: 'GET',
      url: '/v1/captain/performance',
      headers,
    });
    expect(performance.json().violations[0].appeal).toMatchObject({ outcome: 'accepted' });
  });

  it('rejected, the violation and its suspension stay', async () => {
    const door = await orderAtDoor();
    const { captainId, headers } = door.captain;
    const ops = await admin(['OPS']);
    const recorded = await record(ops, captainId, { step: 'suspension_7d' });
    const violationId = recorded.json().violations[0].id as string;
    const opened = await app.inject({
      method: 'POST',
      url: `/v1/captain/violations/${violationId}/appeal`,
      headers: { ...headers, 'idempotency-key': randomUUID() },
      payload: { text: 'لم أتأخر', photoUploadId: null },
    });
    const { cityId } = (await ops.get(`/v1/admin/captains/${captainId}/profile`)).json();
    const rejected = await ops.post(`/v1/admin/tickets/${opened.json().ticket.id}/resolve`, {
      cityId,
      resolution: 'appeal_rejected',
      responsible: null,
      message: 'راجعنا الطلب والتأخير ثابت',
      receivedLines: null,
    });
    expect(rejected.statusCode).toBe(200);
    const after = (await ops.get(`/v1/admin/captains/${captainId}/violations`)).json();
    expect(after.violations[0].appeal.outcome).toBe('rejected');
    expect(after.suggestion.step).toBe('suspension_1d');
    // The captain at the door is in the suspension's last-order mode.
    const suspended = (
      await sql.query('SELECT status FROM captains.captains WHERE id = $1', [captainId])
    ).rows[0].status;
    expect(suspended).toBe('suspended');
  });
});

// Review of slice 2.36b: a step never shortens a running suspension, the
// suspensions' history reads a replaced suspension as one, an appeal is
// the captain's own, and the application role changes only the appeal.
describe('the suspension a step sets', () => {
  it('keeps a longer suspension, which an accepted appeal leaves alone', async () => {
    const { captainId, headers } = await onlineCaptain();
    const ops = await admin(['OPS']);
    const manual = await ops.post(`/v1/admin/captains/${captainId}/status`, {
      status: 'suspended',
      until: null,
      reason: 'تحقيق',
    });
    expect(manual.statusCode).toBe(200);
    const recorded = await record(ops, captainId, { step: 'suspension_1d' });
    expect(recorded.statusCode).toBe(201);
    const profile = (await ops.get(`/v1/admin/captains/${captainId}/profile`)).json();
    expect(profile.suspension).toEqual({ reason: 'تحقيق', until: null });
    const violationId = recorded.json().violations[0].id as string;
    const opened = await app.inject({
      method: 'POST',
      url: `/v1/captain/violations/${violationId}/appeal`,
      headers: { ...headers, 'idempotency-key': randomUUID() },
      payload: { text: 'لم أخطئ', photoUploadId: null },
    });
    const accepted = await ops.post(`/v1/admin/tickets/${opened.json().ticket.id}/resolve`, {
      cityId: profile.cityId,
      resolution: 'appeal_accepted',
      responsible: null,
      message: 'قُبل',
      receivedLines: null,
    });
    expect(accepted.statusCode).toBe(200);
    const after = (await ops.get(`/v1/admin/captains/${captainId}/profile`)).json();
    expect(after.suspension).toEqual({ reason: 'تحقيق', until: null });
  });

  it('lists a suspension that replaced a running one as a suspension', async () => {
    const { captainId } = await onlineCaptain();
    const ops = await admin(['OPS']);
    await record(ops, captainId, { step: 'suspension_1d' });
    const second = await record(ops, captainId, { step: 'suspension_7d' });
    expect(second.json().suspensions.map((each: { status: string }) => each.status)).toEqual([
      'suspended',
      'suspended',
    ]);
  });

  it('refuses an appeal on another captain’s violation, and the role changes only the appeal', async () => {
    const first = await onlineCaptain();
    const second = await onlineCaptain();
    const ops = await admin(['OPS']);
    const recorded = await record(ops, first.captainId, {});
    const violationId = recorded.json().violations[0].id as string;
    const theirs = await app.inject({
      method: 'POST',
      url: `/v1/captain/violations/${violationId}/appeal`,
      headers: { ...second.headers, 'idempotency-key': randomUUID() },
      payload: { text: 'x', photoUploadId: null },
    });
    expect(theirs.statusCode).toBe(404);
    expect(theirs.json().error).toBe('unknown_violation');
    await expect(
      sql.query("UPDATE captains.violations SET reason = 'x' WHERE id = $1", [violationId]),
    ).rejects.toThrow(/permission denied/);
  });
});
