import { describe, expect, it } from 'vitest';
import { CaptainsService } from '../captains/index.js';
import { CaptainAccountsService } from '../identity/index.js';
import { searchTerms } from './admin-search.js';
import {
  acceptedOrder,
  admin,
  app,
  appSignIn,
  azaz,
  change,
  phoneNumber,
  sql,
} from './delivery.fixture.js';

// AP §7.2 (slice 2.38b): the top bar's search by order number, restaurant
// name, captain name or phone, ticket number or customer phone, the last for
// OWN, OPS and SUP only (AP §9.5), answered masked.
describe('what a searched text is', () => {
  it('reads a number, a phone or a part of a name', () => {
    expect(searchTerms(' #10001 ')).toEqual({ text: '#10001', phone: null, number: 10001n });
    expect(searchTerms('T-5521').number).toBe(5521n);
    expect(searchTerms('t5521').number).toBe(5521n);
    expect(searchTerms('0944 123 456')).toEqual({
      text: '0944 123 456',
      phone: '+963944123456',
      number: null,
    });
    expect(searchTerms('مطعم 1')).toEqual({ text: 'مطعم 1', phone: null, number: null });
  });
});

describe('the global search', () => {
  const search = (user: Awaited<ReturnType<typeof admin>>, q: string) =>
    user.post('/v1/admin/search', { cityId: azaz, q });

  it('finds an order and its ticket by number, for those who read them', async () => {
    const order = await acceptedOrder();
    const { rows } = await sql.query('SELECT number FROM ordering.orders WHERE id = $1', [
      order.id,
    ]);
    const number: string = rows[0].number;
    const ops = await admin(['OPS']);
    const ticket = await ops.post(`/v1/admin/orders/${order.id}/tickets`, {
      party: 'customer',
      typeCode: 'missing_item',
      description: 'ناقص صنف',
    });
    expect(ticket.statusCode).toBe(200);

    const byOrder = await search(ops, `#${number}`);
    expect(byOrder.statusCode).toBe(200);
    expect(byOrder.json().orders).toEqual([{ id: order.id, number, status: 'accepted' }]);

    const ticketNumber: string = ticket.json().number;
    const byTicket = await search(ops, `T-${ticketNumber}`);
    expect(byTicket.json().tickets).toEqual([
      { id: ticket.json().id, number: ticketNumber, status: 'new' },
    ]);

    // Another city's search finds none of them.
    const elsewhere = await ops.post('/v1/admin/search', {
      cityId: '00000000-0000-4000-8000-000000000000',
      q: number,
    });
    expect(elsewhere.json()).toMatchObject({ orders: [], tickets: [] });

    // DATA reads neither the operations room nor support (AP §6.2).
    const data = await admin(['DATA']);
    expect((await search(data, number)).json()).toEqual({
      orders: [],
      restaurants: [],
      captains: [],
      tickets: [],
      customers: [],
    });
  });

  it('finds a restaurant and a captain by name, and a captain by phone', async () => {
    const phone = phoneNumber();
    const captainId = await app.get(CaptainsService).createCaptain(
      azaz,
      {
        name: 'كابتن البحث',
        vehicle: 'motorbike',
        plateNumber: 'S-1',
        custodyLimit: { amount: 300_000n, currency: 'TRY' },
      },
      change,
    );
    await app.get(CaptainAccountsService).addAccount(captainId, phone, change);
    const ops = await admin(['OPS']);

    expect((await search(ops, 'الاستلام')).json().restaurants).toEqual([
      expect.objectContaining({ name: 'مطعم الاستلام' }),
    ]);
    expect((await search(ops, 'البحث')).json().captains).toEqual([
      { id: captainId, name: 'كابتن البحث' },
    ]);
    expect((await search(ops, `0${phone.slice(4)}`)).json().captains).toEqual([
      { id: captainId, name: 'كابتن البحث' },
    ]);
    // FIN reads the captains through captains.money, not the restaurants.
    const fin = await admin(['FIN']);
    expect((await search(fin, 'البحث')).json().captains).toEqual([
      { id: captainId, name: 'كابتن البحث' },
    ]);
    expect((await search(fin, 'الاستلام')).json().restaurants).toEqual([]);
    // DATA reads neither, by name or by phone; another city has neither.
    const data = await admin(['DATA']);
    expect((await search(data, 'الاستلام')).json()).toMatchObject({
      restaurants: [],
      captains: [],
    });
    expect((await search(data, phone)).json().captains).toEqual([]);
    const elsewhere = await ops.post('/v1/admin/search', {
      cityId: '00000000-0000-4000-8000-000000000000',
      q: 'البحث',
    });
    expect(elsewhere.json()).toMatchObject({ restaurants: [], captains: [] });
  });

  it('finds a customer by phone for OWN, OPS and SUP only, masked', async () => {
    const phone = phoneNumber();
    await appSignIn('customer', phone);
    for (const role of ['OWN', 'OPS', 'SUP']) {
      const found = (await search(await admin([role]), phone)).json().customers;
      expect(found).toEqual([
        expect.objectContaining({ maskedPhone: `+963 ••• ${phone.slice(-3)}` }),
      ]);
      expect(JSON.stringify(found)).not.toContain(phone);
    }
    // FIN reads customers but may not search them by phone.
    expect((await search(await admin(['FIN']), phone)).json().customers).toEqual([]);
  });
});
