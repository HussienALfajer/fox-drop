import 'reflect-metadata';
import { describe, expect, it } from 'vitest';
import { app, appSignIn, orderAtDoor, phoneNumber, sql } from './delivery.fixture.js';

// CU §5.3 (L.1a, DoD CU-3): the customer's gender and birthday are the
// customer's and the panel's only; no captain read or order event carries
// them.

const birthday = '1994-05-17';

function expectNoProfileDetails(payload: unknown) {
  const text = JSON.stringify(payload);
  expect(text).not.toContain('"gender');
  expect(text).not.toContain('"birthday');
  expect(text).not.toContain('female');
  expect(text).not.toContain(birthday);
}

describe("the captain never sees the customer's gender or birthday (CU §5.3)", () => {
  it('leaves them out of the active order, the history, the ratings and the order events', async () => {
    // The profile is saved before the order is placed, so every order event
    // could have carried it.
    const customer = await appSignIn('customer', phoneNumber());
    const saved = await app.inject({
      method: 'PUT',
      url: '/v1/customer/profile',
      headers: customer,
      payload: {
        firstName: 'ريم',
        lastName: 'الحلبي',
        gender: 'female',
        birthday,
        acceptTerms: true,
      },
    });
    expect(saved.statusCode).toBe(200);
    expect(saved.json()).toMatchObject({ profile: { gender: 'female', birthday } });
    const door = await orderAtDoor({ customer });

    const active = await door.captain.active();
    expect(active.statusCode).toBe(200);
    // The captain reads the customer's details at the door, the first name among them.
    expect(JSON.stringify(active.json())).toContain(door.order.id);
    expect(JSON.stringify(active.json())).toContain('ريم');
    expectNoProfileDetails(active.json());

    expect((await door.deliver()).statusCode).toBe(200);
    for (const url of ['/v1/captain/orders/history', '/v1/captain/ratings']) {
      const answer = await app.inject({ method: 'GET', url, headers: door.captain.headers });
      expect(answer.statusCode).toBe(200);
      if (url.endsWith('history')) expect(JSON.stringify(answer.json())).toContain(door.order.id);
      expectNoProfileDetails(answer.json());
    }

    const { rows } = await sql.query('SELECT payload FROM ordering.outbox WHERE order_id = $1', [
      door.order.id,
    ]);
    expect(rows.length).toBeGreaterThan(0);
    for (const row of rows) expectNoProfileDetails(row.payload);
  });
});
