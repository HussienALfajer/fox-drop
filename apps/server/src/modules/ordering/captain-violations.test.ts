import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { admin, onlineCaptain, orderAtDoor, sql } from './delivery.fixture.js';

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
