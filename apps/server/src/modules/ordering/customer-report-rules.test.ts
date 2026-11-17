import { randomUUID } from 'node:crypto';
import pg from 'pg';
import { beforeAll, describe, expect, it } from 'vitest';
import {
  admin,
  app,
  appSignIn,
  azaz,
  database,
  item,
  orderAtDoor,
  phoneNumber,
  pickedUpOrder,
  restaurant,
  sql,
} from './delivery.fixture.js';

// CU §12.2, §9.5, AP §9.9.1 (slice 2.24a): the rules of the customer's
// reports on a real delivered order and a restaurant, without photos (their
// storage is customer-reports.test.ts's).

// Signing an upload needs no storage running: the URL is signed locally.
beforeAll(() => {
  process.env.STORAGE_URL ??= 'http://127.0.0.1:1';
  process.env.STORAGE_KEY_ID ??= 'GK000000000000000000000001';
  process.env.STORAGE_SECRET ??= '0'.repeat(64);
  process.env.ADMIN_PANEL_URL ??= 'http://127.0.0.1:1';
  process.env.APP_UPLOAD_URL ??= 'http://127.0.0.1:1';
});

async function deliveredOrder() {
  const door = await orderAtDoor();
  expect((await door.deliver()).statusCode).toBe(200);
  return { id: door.order.id as string, customer: door.order.customer };
}

const report = (
  orderId: string,
  customer: { authorization: string },
  body: object,
  key: string = randomUUID(),
) =>
  app.inject({
    method: 'POST',
    url: `/v1/customer/orders/${orderId}/report`,
    headers: { ...customer, 'idempotency-key': key },
    payload: { typeCode: 'missing_item', note: null, items: [], photoUploadIds: [], ...body },
  });

const customerOrder = async (orderId: string, customer: { authorization: string }) =>
  (
    await app.inject({ method: 'GET', url: `/v1/customer/orders/${orderId}`, headers: customer })
  ).json().order;

const oneShawarma = [{ position: 0, quantity: 1 }];

describe('«الإبلاغ عن مشكلة» on a delivered order', () => {
  it('opens a report once, repeats its key, and shows its resolution on the order', async () => {
    const order = await deliveredOrder();
    const before = await customerOrder(order.id, order.customer);
    expect(before.report).toBeNull();
    const until = new Date(before.reportUntil).getTime();
    expect(until).toBeGreaterThan(Date.now() + 23 * 3_600_000);
    expect(until).toBeLessThanOrEqual(Date.now() + 24 * 3_600_000);

    const body = { note: 'نقصت شاورما', items: oneShawarma };
    const key = randomUUID();
    const sent = await report(order.id, order.customer, body, key);
    expect(sent.statusCode).toBe(200);
    const { report: opened, reportUntil } = sent.json().order;
    expect(opened).toMatchObject({ status: 'new', message: null });
    expect(reportUntil).toBeNull();
    const again = await report(order.id, order.customer, body, key);
    expect(again.statusCode).toBe(200);
    expect(again.json().order.report.ticketId).toBe(opened.ticketId);
    const second = await report(order.id, order.customer, { items: oneShawarma });
    expect(second.statusCode).toBe(409);
    expect(second.json().error).toBe('already_reported');

    const sup = await admin(['SUP']);
    const page = (await sup.get(`/v1/admin/tickets/${opened.ticketId}?cityId=${azaz}`)).json();
    expect(page).toMatchObject({
      number: opened.number,
      source: 'customer_report',
      party: 'customer',
      partyName: expect.any(String),
      orderId: order.id,
      urgent: false,
      typeCode: 'missing_item',
      typeLabel: 'صنف ناقص',
      description: 'نقصت شاورما',
      sla: { kind: 'resolution' },
      report: {
        lines: [{ position: 0, name: 'شاورما', quantity: 1 }],
        photoUrls: [],
        item: null,
        shopPrice: null,
      },
    });

    // AP §9.9.3: the resolution reaches the order.
    const resolved = await sup.post(`/v1/admin/tickets/${opened.ticketId}/resolve`, {
      cityId: azaz,
      resolution: 'none_explained',
      responsible: 'restaurant',
      message: 'نعتذر، نبهنا المطعم.',
      receivedLines: null,
    });
    expect(resolved.statusCode).toBe(200);
    expect((await customerOrder(order.id, order.customer)).report).toMatchObject({
      status: 'resolved',
      message: 'نعتذر، نبهنا المطعم.',
    });
  });

  it('opens one report when two with different keys arrive together', async () => {
    const order = await deliveredOrder();
    const answers = await Promise.all([
      report(order.id, order.customer, { items: oneShawarma }),
      report(order.id, order.customer, { typeCode: 'cold_food' }),
    ]);
    expect(answers.map((each) => each.statusCode).sort()).toEqual([200, 409]);
    const { rows } = await sql.query(
      "SELECT count(*)::int AS n FROM support.tickets WHERE order_id = $1 AND source = 'customer_report'",
      [order.id],
    );
    expect(rows[0].n).toBe(1);
  });

  it('is closed before the delivery and after its window', async () => {
    const picked = await pickedUpOrder();
    const early = await report(picked.order.id, picked.order.customer, { items: oneShawarma });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('report_closed');
    expect((await customerOrder(picked.order.id, picked.order.customer)).reportUntil).toBeNull();

    const order = await deliveredOrder();
    await sql.query(
      "UPDATE ordering.orders SET delivered_at = now() - interval '25 hours' WHERE id = $1",
      [order.id],
    );
    const late = await report(order.id, order.customer, { items: oneShawarma });
    expect(late.statusCode).toBe(409);
    expect(late.json().error).toBe('report_closed');
    expect((await customerOrder(order.id, order.customer)).reportUntil).toBeNull();
  });

  it('checks the type, the items and the photos', async () => {
    const order = await deliveredOrder();
    const refused = async (body: object) => {
      const answer = await report(order.id, order.customer, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
    expect(await refused({})).toBe('items_required');
    expect(await refused({ items: [{ position: 0, quantity: 3 }] })).toBe('invalid_items');
    expect(await refused({ typeCode: 'cold_food', items: oneShawarma })).toBe('invalid_items');
    expect(await refused({ typeCode: 'other' })).toBe('reason_note_required');
    expect(await refused({ typeCode: 'no_such_type' })).toBe('unknown_reason');
    // The same photo twice, and more than 3.
    const id = randomUUID();
    expect((await report(order.id, order.customer, { photoUploadIds: [id, id] })).statusCode).toBe(
      400,
    );
    const four = [1, 2, 3, 4].map(() => randomUUID());
    expect((await report(order.id, order.customer, { photoUploadIds: four })).statusCode).toBe(400);
    // Another customer's order is not found.
    const stranger = await appSignIn('customer', phoneNumber());
    expect((await report(order.id, stranger, { typeCode: 'cold_food' })).statusCode).toBe(404);

    expect((await report(order.id, order.customer, { typeCode: 'cold_food' })).statusCode).toBe(
      200,
    );
  });
});

describe('«أبلغ عن سعر مختلف»', () => {
  const priceReport = (
    customer: { authorization: string },
    body: object,
    restaurantId = restaurant,
    key: string = randomUUID(),
  ) =>
    app.inject({
      method: 'POST',
      url: `/v1/customer/restaurants/${restaurantId}/price-report`,
      headers: { ...customer, 'idempotency-key': key },
      payload: { itemId: null, shopPrice: null, note: null, photoUploadId: null, ...body },
    });

  it('opens «سعر مختلف عن المحل» on the restaurant, once a business day', async () => {
    const customer = await appSignIn('customer', phoneNumber());
    const body = { itemId: item, shopPrice: '11000', note: 'السعر في المحل أقل' };
    const key = randomUUID();
    const sent = await priceReport(customer, body, restaurant, key);
    expect(sent.statusCode).toBe(200);
    const { number } = sent.json();
    const again = await priceReport(customer, body, restaurant, key);
    expect(again.json().number).toBe(number);
    const today = await priceReport(customer, {});
    expect(today.statusCode).toBe(409);
    expect(today.json().error).toBe('already_reported_today');

    const { rows } = await sql.query(
      'SELECT id FROM support.tickets WHERE city_id = $1 AND number = $2',
      [azaz, number],
    );
    const sup = await admin(['SUP']);
    const page = (await sup.get(`/v1/admin/tickets/${rows[0].id}?cityId=${azaz}`)).json();
    expect(page).toMatchObject({
      source: 'price_report',
      kind: 'price_difference',
      orderId: null,
      restaurantId: restaurant,
      restaurantName: 'مطعم الاستلام',
      description: 'السعر في المحل أقل',
      report: {
        lines: [],
        photoUrls: [],
        item: { id: item, name: 'شاورما' },
        shopPrice: { amount: '11000', currency: 'TRY' },
      },
    });

    // The business day starts at finance.business_day_cutoff on the city's
    // clock: the report moved to before today's cutoff lets another in.
    const migrator = new pg.Client({ connectionString: database.migratorUrl });
    await migrator.connect();
    try {
      await migrator.query(
        "UPDATE support.tickets SET opened_at = opened_at - interval '1 day' WHERE id = $1",
        [rows[0].id],
      );
    } finally {
      await migrator.end();
    }
    expect((await priceReport(customer, {})).statusCode).toBe(200);
  });

  it('opens one report when two with different keys arrive together', async () => {
    const customer = await appSignIn('customer', phoneNumber());
    const answers = await Promise.all([
      priceReport(customer, { note: 'الأول' }),
      priceReport(customer, { note: 'الثاني' }),
    ]);
    expect(answers.map((each) => each.statusCode).sort()).toEqual([200, 409]);
  });

  it('refuses a restaurant customers do not see, an item not on its menu and a price of 0', async () => {
    const customer = await appSignIn('customer', phoneNumber());
    expect((await priceReport(customer, {}, randomUUID())).statusCode).toBe(404);
    const unknown = await priceReport(customer, { itemId: randomUUID() });
    expect(unknown.statusCode).toBe(400);
    expect(unknown.json().error).toBe('unknown_item');
    const zero = await priceReport(customer, { shopPrice: '0' });
    expect(zero.statusCode).toBe(400);
    expect(zero.json().error).toBe('invalid_price');
  });
});

describe('the report photos a customer asks', () => {
  it('are at most REPORT_UPLOADS_PER_HOUR an hour (architecture §15)', async () => {
    const customer = await appSignIn('customer', phoneNumber());
    const ask = () =>
      app.inject({
        method: 'POST',
        url: '/v1/customer/uploads/report-photo',
        headers: customer,
        payload: { contentType: 'image/jpeg', sizeBytes: 1000 },
      });
    for (let i = 0; i < 20; i += 1) expect((await ask()).statusCode).toBe(201);
    const refused = await ask();
    expect(refused.statusCode).toBe(429);
    expect(refused.json().error).toBe('too_many_uploads');
  });
});
