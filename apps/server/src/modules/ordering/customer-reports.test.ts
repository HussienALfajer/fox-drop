import { randomBytes, randomUUID } from 'node:crypto';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestStorage, type TestStorage } from '../../storage/test-storage.js';
import {
  admin,
  app,
  appSignIn,
  azaz,
  item,
  orderAtDoor,
  phoneNumber,
  pickedUpOrder,
  restaurant,
  sql,
} from './delivery.fixture.js';

// CU §12.2, §9.5, AP §9.9.1, §9.9.3 (slice 2.24a): the customer's reports on
// a real delivered order and a restaurant, with their photos in the private
// bucket of a real Garage.

let storage: TestStorage;

beforeAll(async () => {
  storage = await startTestStorage();
  // The storage client is built on first use: the tests upload to the
  // storage itself, as the panel's and the API's hosts forward to it.
  process.env.STORAGE_URL = storage.url;
  process.env.STORAGE_KEY_ID = storage.key.id;
  process.env.STORAGE_SECRET = storage.key.secret;
  process.env.ADMIN_PANEL_URL = storage.url;
  process.env.APP_UPLOAD_URL = storage.url;
}, 300_000);

afterAll(async () => {
  await storage?.stop();
});

const png = Buffer.concat([
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
  randomBytes(40),
]);

async function photo(customer: { authorization: string }) {
  const asked = await app.inject({
    method: 'POST',
    url: '/v1/customer/uploads/report-photo',
    headers: customer,
    payload: { contentType: 'image/png', sizeBytes: png.length },
  });
  expect(asked.statusCode).toBe(201);
  const { uploadId, url } = asked.json();
  expect(new URL(url).pathname).toMatch(/^\/private-docs\/incoming\//);
  const put = await fetch(url, {
    method: 'PUT',
    body: png,
    headers: { 'content-type': 'image/png' },
  });
  expect(put.status).toBe(200);
  return uploadId as string;
}

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

describe('«الإبلاغ عن مشكلة» on a delivered order', () => {
  it('opens a ticket with the items and a photo the panel sees, once per order', async () => {
    const order = await deliveredOrder();
    const before = await customerOrder(order.id, order.customer);
    expect(before.report).toBeNull();
    const until = new Date(before.reportUntil).getTime();
    expect(until).toBeGreaterThan(Date.now() + 23 * 3_600_000);
    expect(until).toBeLessThanOrEqual(Date.now() + 24 * 3_600_000);

    const uploadId = await photo(order.customer);
    const body = {
      note: 'نقصت شاورما',
      items: [{ position: 0, quantity: 1 }],
      photoUploadIds: [uploadId],
    };
    const key = randomUUID();
    const sent = await report(order.id, order.customer, body, key);
    expect(sent.statusCode).toBe(200);
    const { report: opened, reportUntil } = sent.json().order;
    expect(opened).toMatchObject({ status: 'new', message: null });
    expect(reportUntil).toBeNull();
    // A repeat of the key answers the same report.
    const again = await report(order.id, order.customer, body, key);
    expect(again.statusCode).toBe(200);
    expect(again.json().order.report.ticketId).toBe(opened.ticketId);
    // Q17: one report per order.
    const second = await report(order.id, order.customer, { items: body.items });
    expect(second.statusCode).toBe(409);
    expect(second.json().error).toBe('already_reported');

    const sup = await admin(['SUP']);
    const page = await sup.get(`/v1/admin/tickets/${opened.ticketId}?cityId=${azaz}`);
    expect(page.statusCode).toBe(200);
    expect(page.json()).toMatchObject({
      number: opened.number,
      source: 'customer_report',
      party: 'customer',
      orderId: order.id,
      urgent: false,
      typeCode: 'missing_item',
      typeLabel: 'صنف ناقص',
      description: 'نقصت شاورما',
      sla: { kind: 'resolution' },
      report: {
        lines: [{ position: 0, name: 'شاورما', quantity: 1 }],
        item: null,
        shopPrice: null,
      },
    });
    const [link] = page.json().report.photoUrls;
    expect(new URL(link).pathname).toMatch(/^\/private-docs\/tickets\/photos\//);
    const fetched = await fetch(link);
    expect(fetched.status).toBe(200);
    expect(Buffer.from(await fetched.arrayBuffer())).toEqual(png);

    // AP §9.9.3: the resolution reaches the order.
    const resolved = await sup.post(
      `/v1/admin/tickets/${opened.ticketId}/resolve`,
      {
        cityId: azaz,
        resolution: 'none_explained',
        responsible: 'restaurant',
        message: 'نعتذر، نبهنا المطعم.',
        receivedLines: null,
      },
      undefined,
    );
    expect(resolved.statusCode).toBe(200);
    expect((await customerOrder(order.id, order.customer)).report).toMatchObject({
      status: 'resolved',
      message: 'نعتذر، نبهنا المطعم.',
    });
  });

  it('is closed before the delivery and after its window', async () => {
    const picked = await pickedUpOrder();
    const early = await report(picked.order.id, picked.order.customer, {
      items: [{ position: 0, quantity: 1 }],
    });
    expect(early.statusCode).toBe(409);
    expect(early.json().error).toBe('report_closed');
    expect((await customerOrder(picked.order.id, picked.order.customer)).reportUntil).toBeNull();

    const order = await deliveredOrder();
    await sql.query(
      "UPDATE ordering.orders SET delivered_at = now() - interval '25 hours' WHERE id = $1",
      [order.id],
    );
    const late = await report(order.id, order.customer, { items: [{ position: 0, quantity: 1 }] });
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
    expect(await refused({ typeCode: 'cold_food', items: [{ position: 0, quantity: 1 }] })).toBe(
      'invalid_items',
    );
    expect(await refused({ typeCode: 'other' })).toBe('reason_note_required');
    expect(await refused({ typeCode: 'no_such_type' })).toBe('unknown_reason');
    // Only the customer's own upload, once uploaded.
    const stranger = await appSignIn('customer', phoneNumber());
    const theirs = await photo(stranger);
    expect(await refused({ typeCode: 'cold_food', photoUploadIds: [theirs] })).toBe(
      'upload_not_found',
    );
    const asked = await app.inject({
      method: 'POST',
      url: '/v1/customer/uploads/report-photo',
      headers: order.customer,
      payload: { contentType: 'image/png', sizeBytes: png.length },
    });
    expect(await refused({ typeCode: 'cold_food', photoUploadIds: [asked.json().uploadId] })).toBe(
      'upload_missing',
    );
    const four = await Promise.all([1, 2, 3, 4].map(() => photo(order.customer)));
    expect((await report(order.id, order.customer, { photoUploadIds: four })).statusCode).toBe(400);
    // Another customer's order is not found.
    expect((await report(order.id, stranger, { typeCode: 'cold_food' })).statusCode).toBe(404);

    const sent = await report(order.id, order.customer, { typeCode: 'cold_food', note: null });
    expect(sent.statusCode).toBe(200);
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
    const uploadId = await photo(customer);
    const body = {
      itemId: item,
      shopPrice: '11000',
      note: 'السعر في المحل أقل',
      photoUploadId: uploadId,
    };
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
        item: { id: item, name: 'شاورما' },
        shopPrice: { amount: '11000', currency: 'TRY' },
      },
    });
    expect(page.report.photoUrls).toHaveLength(1);
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
