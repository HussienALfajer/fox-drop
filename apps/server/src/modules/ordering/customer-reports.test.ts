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
  restaurant,
  sql,
} from './delivery.fixture.js';

// CU §12.2, §9.5, AP §9.9.1, §9.9.3 (slice 2.24a): the photos of the
// customer's reports in the private bucket of a real Garage (the reports'
// other rules are customer-report-rules.test.ts's).

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

describe('the photos of a report', () => {
  it("are the customer's own uploads, linked once and shown to the panel", async () => {
    const order = await deliveredOrder();
    const uploadId = await photo(order.customer);
    const sent = await report(order.id, order.customer, {
      items: [{ position: 0, quantity: 1 }],
      photoUploadIds: [uploadId],
    });
    expect(sent.statusCode).toBe(200);
    const { report: opened } = sent.json().order;

    const sup = await admin(['SUP']);
    const page = (await sup.get(`/v1/admin/tickets/${opened.ticketId}?cityId=${azaz}`)).json();
    expect(page.report.photoUrls).toHaveLength(1);
    const [link] = page.report.photoUrls;
    expect(new URL(link).pathname).toMatch(/^\/private-docs\/tickets\/photos\//);
    const fetched = await fetch(link);
    expect(fetched.status).toBe(200);
    expect(Buffer.from(await fetched.arrayBuffer())).toEqual(png);

    // A photo another report took is refused.
    const reused = await app.inject({
      method: 'POST',
      url: `/v1/customer/restaurants/${restaurant}/price-report`,
      headers: { ...order.customer, 'idempotency-key': randomUUID() },
      payload: { itemId: null, shopPrice: null, note: null, photoUploadId: uploadId },
    });
    expect(reused.statusCode).toBe(409);
    expect(reused.json().error).toBe('upload_used');
  });

  it("refuses another customer's upload and one never uploaded", async () => {
    const order = await deliveredOrder();
    const refused = async (body: object) => {
      const answer = await report(order.id, order.customer, body);
      expect(answer.statusCode).toBe(400);
      return answer.json().error;
    };
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
  });

  it("keeps a price report's one photo", async () => {
    const customer = await appSignIn('customer', phoneNumber());
    const uploadId = await photo(customer);
    const sent = await app.inject({
      method: 'POST',
      url: `/v1/customer/restaurants/${restaurant}/price-report`,
      headers: { ...customer, 'idempotency-key': randomUUID() },
      payload: { itemId: item, shopPrice: null, note: null, photoUploadId: uploadId },
    });
    expect(sent.statusCode).toBe(200);
    const { rows } = await sql.query(
      'SELECT photo_keys FROM support.tickets WHERE city_id = $1 AND number = $2',
      [azaz, sent.json().number],
    );
    expect(rows[0].photo_keys).toEqual([expect.stringMatching(/^tickets\/photos\//)]);
  });
});
