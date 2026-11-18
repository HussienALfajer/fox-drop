import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it, vi } from 'vitest';
import { CaptainsService } from '../captains/index.js';
import { RealtimePublisher } from '../notifications/index.js';
import {
  acceptedOrder,
  app,
  assignedOrder,
  atCustomer,
  centre,
  home,
  onlineCaptain,
  pickedUpOrder,
} from './delivery.fixture.js';

// CA §4.6, §9.2, §9.5, CU §11.3, architecture §6.2, §7.1: the leg's route
// and the captain's live position after the pickup. The tests set no OSRM
// server, so every route is the straight line × 1.3 without a line.

const captainRoute = (orderId: string, headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: `/v1/captain/orders/${orderId}/route`, headers });

const customerRoute = (orderId: string, headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: `/v1/customer/orders/${orderId}/route`, headers });

describe('GET /v1/captain/orders/{orderId}/route (CA §4.6, §9.2, §9.5)', () => {
  it('routes to the restaurant until the pickup, then to the pin', async () => {
    const { order, captain } = await assignedOrder();
    const toRestaurant = await captainRoute(order.id, captain.headers);
    expect(toRestaurant.statusCode).toBe(200);
    expect(toRestaurant.json()).toMatchObject({
      leg: 'to_restaurant',
      destination: centre,
      route: { method: 'straight_x1.3', line: null },
    });
    expect(toRestaurant.json().route.metres).toBeGreaterThan(1000);
    expect(toRestaurant.json().route.seconds).toBeGreaterThan(0);

    const picked = await pickedUpOrder();
    const toCustomer = await captainRoute(picked.order.id, picked.captain.headers);
    expect(toCustomer.statusCode).toBe(200);
    expect(toCustomer.json()).toMatchObject({ leg: 'to_customer', destination: home });
  });

  it("refuses another captain's order and an order no longer active", async () => {
    const { order } = await assignedOrder();
    const other = await onlineCaptain();
    expect((await captainRoute(order.id, other.headers)).json()).toMatchObject({
      error: 'unknown_order',
    });
    expect((await captainRoute(randomUUID(), other.headers)).statusCode).toBe(404);
  });
});

describe('GET /v1/customer/orders/{orderId}/route (CU §11.3)', () => {
  it('answers the captain and the route to the pin from the pickup only', async () => {
    const accepted = await acceptedOrder();
    const before = await customerRoute(accepted.id, accepted.customer);
    expect(before.statusCode).toBe(409);
    expect(before.json()).toMatchObject({ error: 'order_state_changed' });

    const picked = await pickedUpOrder();
    const route = await customerRoute(picked.order.id, picked.order.customer);
    expect(route.statusCode).toBe(200);
    // The captain's newest point is the pickup request's fix at the door.
    expect(route.json()).toMatchObject({
      captain: { latitude: expect.any(Number), longitude: expect.any(Number) },
      destination: home,
      route: { method: 'straight_x1.3', line: null },
    });
    // Another customer's order is unknown.
    expect((await customerRoute(picked.order.id, accepted.customer)).statusCode).toBe(404);
  });
});

describe("the captain's live position on order:{id} (architecture §6.2, CU §11.3)", () => {
  it('publishes each new point after the pickup, never before or an older one', async () => {
    const publisher = app.get(RealtimePublisher);
    const enabled = vi.spyOn(publisher, 'enabled', 'get').mockReturnValue(true);
    const broadcast = vi.spyOn(publisher, 'broadcast').mockResolvedValue();
    try {
      const captains = app.get(CaptainsService);
      const assigned = await assignedOrder();
      const point = (at: Date) => [
        { ...atCustomer, accuracyMetres: 8, recordedAt: at, simulated: false },
      ];
      broadcast.mockClear();
      await captains.recordLocations(assigned.captain.captainId, point(new Date()), new Date());
      expect(
        broadcast.mock.calls.filter(([channels]) => channels[0]?.startsWith('order:')),
      ).toEqual([]);

      const picked = await pickedUpOrder();
      broadcast.mockClear();
      const at = new Date(Date.now() + 1000);
      await captains.recordLocations(
        picked.captain.captainId,
        point(at),
        new Date(at.getTime() + 1),
      );
      expect(broadcast).toHaveBeenCalledWith(
        [`order:${picked.order.id}`],
        {
          type: 'captain.position',
          schema: 1,
          orderId: picked.order.id,
          ...atCustomer,
          recordedAt: at.toISOString(),
        },
        `captain-position:${picked.order.id}:${at.getTime()}`,
      );

      // A late point older than the live one is not published.
      broadcast.mockClear();
      await captains.recordLocations(
        picked.captain.captainId,
        point(new Date(at.getTime() - 500)),
        new Date(at.getTime() + 2),
      );
      expect(broadcast).not.toHaveBeenCalled();

      // A failed publication never fails the point.
      broadcast.mockRejectedValueOnce(new Error('down'));
      const later = new Date(at.getTime() + 2000);
      await expect(
        captains.recordLocations(
          picked.captain.captainId,
          point(later),
          new Date(later.getTime() + 1),
        ),
      ).resolves.toEqual({ accepted: 1 });
    } finally {
      enabled.mockRestore();
      broadcast.mockRestore();
    }
  });
});
