import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { admin, app, azaz, orderAtDoor, sql } from './delivery.fixture.js';

// AP §9.7.3–9.7.5 (slice 2.36a): the panel's captain list, profile and
// actions, read through the routes over the orders this module counts.
const pushes = async (captainId: string, templateKey: string) =>
  (
    await sql.query(
      'SELECT body FROM notifications.push_messages WHERE captain_id = $1 AND template_key = $2',
      [captainId, templateKey],
    )
  ).rows.map((row) => row.body as string);

describe('the captain list and profile (AP §9.7.3–9.7.4)', () => {
  it('lists a captain with its figures, and opens its overview', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const { captainId } = door.captain;
    const ops = await admin(['OPS']);
    const listed = await ops.post('/v1/admin/captain-list', {
      cityId: azaz,
      status: null,
      q: null,
    });
    expect(listed.statusCode).toBe(200);
    const row = listed.json().captains.find((each: { id: string }) => each.id === captainId);
    expect(row).toMatchObject({
      name: 'كابتن الوصول',
      vehicle: 'motorbike',
      status: 'online',
      applicationId: null,
      contractPhase: null,
      ordersToday: 1,
      acceptance: null,
      ratingAverage: null,
      ratingCount: 0,
    });
    expect(row.maskedPhone).toMatch(/^\+963 ••• \d{3}$/);
    expect(row.custody.limit).toEqual({ amount: '300000', currency: 'TRY' });

    const online = await ops.post('/v1/admin/captain-list', {
      cityId: azaz,
      status: 'online',
      q: 'كابتن',
    });
    expect(online.json().captains.map((each: { id: string }) => each.id)).toContain(captainId);
    const offline = await ops.post('/v1/admin/captain-list', {
      cityId: azaz,
      status: 'offline',
      q: null,
    });
    expect(offline.json().captains.map((each: { id: string }) => each.id)).not.toContain(captainId);

    const profile = await ops.get(`/v1/admin/captains/${captainId}/profile`);
    expect(profile.statusCode).toBe(200);
    expect(profile.json()).toMatchObject({
      id: captainId,
      status: 'online',
      suspension: null,
      ordersToday: 1,
      delivered: 1,
      onTime: { onTime: 1, counted: 1 },
      cancellations: 0,
      earnings: { currency: 'TRY', month: { orders: 1 } },
      app: { maxPickup: null, carriedCurrencies: ['TRY'], expiredInRow: 0 },
    });
    // OPS manages captains: the number in full, audited as a view.
    expect(profile.json().phone).toMatch(/^\+9639\d{8}$/);
    const views = await sql.query(
      "SELECT count(*)::int AS n FROM audit.events WHERE action = 'captain.phone_view' AND target_id = $1",
      [captainId],
    );
    expect(views.rows[0].n).toBe(1);
    const fin = await admin(['FIN']);
    const masked = await fin.get(`/v1/admin/captains/${captainId}/profile`);
    expect(masked.statusCode).toBe(200);
    expect(masked.json().phone).toMatch(/^\+963 ••• \d{3}$/);

    const offers = await ops.get(`/v1/admin/captains/${captainId}/offers`);
    expect(offers.statusCode).toBe(200);
    expect(offers.json().offers).toEqual([]);
  });

  it('answers 404 for an unknown captain and an unknown city', async () => {
    const ops = await admin(['OPS']);
    expect((await ops.get(`/v1/admin/captains/${randomUUID()}/profile`)).statusCode).toBe(404);
    const unknown = await ops.post('/v1/admin/captain-list', {
      cityId: randomUUID(),
      status: null,
      q: null,
    });
    expect(unknown.statusCode).toBe(404);
  });
});

describe('the captain actions (AP §9.7.5)', () => {
  it('suspends with a reason the captain hears, then reactivates', async () => {
    const door = await orderAtDoor();
    expect((await door.deliver()).statusCode).toBe(200);
    const { captainId } = door.captain;
    const ops = await admin(['OPS']);
    const until = new Date(Date.now() + 86_400_000).toISOString();
    const suspended = await ops.post(`/v1/admin/captains/${captainId}/status`, {
      status: 'suspended',
      until,
      reason: 'شكاوى متكررة',
    });
    expect(suspended.statusCode).toBe(200);
    expect(suspended.json().state).toBe('suspended');
    const profile = (await ops.get(`/v1/admin/captains/${captainId}/profile`)).json();
    expect(profile.status).toBe('suspended');
    expect(profile.suspension).toEqual({ reason: 'شكاوى متكررة', until });
    expect(await pushes(captainId, 'captain.suspended')).toEqual([
      'أوقفت العمليات حسابك: شكاوى متكررة',
    ]);

    const back = await ops.post(`/v1/admin/captains/${captainId}/status`, {
      status: 'active',
      until: null,
      reason: 'انتهت المراجعة',
    });
    expect(back.statusCode).toBe(200);
    expect(back.json().state).toBe('offline');
    expect(await pushes(captainId, 'captain.reactivated')).toHaveLength(1);
    const again = await ops.post(`/v1/admin/captains/${captainId}/status`, {
      status: 'active',
      until: null,
      reason: 'مرة ثانية',
    });
    expect(again.statusCode).toBe(409);
    expect(again.json().error).toBe('status_change_not_allowed');
    const past = await ops.post(`/v1/admin/captains/${captainId}/status`, {
      status: 'suspended',
      until: new Date(Date.now() - 1000).toISOString(),
      reason: 'x',
    });
    expect(past.statusCode).toBe(400);

    const log = (await ops.get(`/v1/admin/captains/${captainId}/change-log`)).json();
    expect(log.entries.map((entry: { action: string }) => entry.action)).toEqual([
      'captain.status',
      'captain.status',
      'captain.create',
    ]);
    expect(log.entries[1]).toMatchObject({ actorType: 'admin', reason: 'شكاوى متكررة' });
  });

  it('changes the cash limit for FIN only, effective at once', async () => {
    const door = await orderAtDoor();
    const { captainId } = door.captain;
    const put = (cookies: Record<string, string>, payload: object) =>
      app.inject({
        method: 'PUT',
        url: `/v1/admin/captains/${captainId}/cash-limit`,
        cookies,
        payload,
      });
    const body = { amount: '500000', currency: 'TRY', reason: 'كابتن موثوق' };
    const ops = await admin(['OPS']);
    expect((await put(ops.cookies, body)).statusCode).toBe(403);
    const fin = await admin(['FIN']);
    expect((await put(fin.cookies, body)).statusCode).toBe(200);
    const profile = (await fin.get(`/v1/admin/captains/${captainId}/profile`)).json();
    expect(profile.custody.limit).toEqual({ amount: '500000', currency: 'TRY' });
    expect((await put(fin.cookies, { ...body, currency: 'USD' })).json().error).toBe(
      'not_in_base_currency',
    );
    expect((await put(fin.cookies, { ...body, amount: '0' })).statusCode).toBe(400);
  });

  it('sends a message once per key, and keeps notes', async () => {
    const door = await orderAtDoor();
    const { captainId } = door.captain;
    const ops = await admin(['OPS']);
    const key = randomUUID();
    const send = () =>
      ops.post(`/v1/admin/captains/${captainId}/message`, { text: 'مرّ على المكتب اليوم' }, key);
    expect((await send()).statusCode).toBe(200);
    expect((await send()).statusCode).toBe(200);
    expect(await pushes(captainId, 'captain.message')).toEqual(['مرّ على المكتب اليوم']);

    const sup = await admin(['SUP']);
    expect(
      (await sup.post(`/v1/admin/captains/${captainId}/message`, { text: 'x' })).statusCode,
    ).toBe(403);
    const noteKey = randomUUID();
    const added = await sup.post(
      `/v1/admin/captains/${captainId}/notes`,
      { body: 'يفضّل العمل مساءً' },
      noteKey,
    );
    expect(added.statusCode).toBe(201);
    expect(
      (
        await sup.post(
          `/v1/admin/captains/${captainId}/notes`,
          { body: 'يفضّل العمل مساءً' },
          noteKey,
        )
      ).statusCode,
    ).toBe(201);
    const reused = await sup.post(
      `/v1/admin/captains/${captainId}/notes`,
      { body: 'نص آخر' },
      noteKey,
    );
    expect(reused.statusCode).toBe(422);
    const notes = (await sup.get(`/v1/admin/captains/${captainId}/notes`)).json().notes;
    expect(notes).toHaveLength(1);
    expect(notes[0]).toMatchObject({ body: 'يفضّل العمل مساءً' });
    expect(notes[0].authorName).toMatch(/^Operator /);
  });
});
