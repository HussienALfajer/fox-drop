import 'reflect-metadata';
import { describe, expect, it, vi } from 'vitest';
import { CaptainsService } from '../captains/index.js';
import { RealtimePublisher } from '../notifications/index.js';
import { app, besideThem, home, onlineCaptain, pickedUpOrder } from './handover-flow.fixture.js';
import { OrderRoutes } from './order-routes.js';

// CA §9.10.1, CU §11.3 (slice 2.29b): after a handover the second captain's
// route and position, from the receipt only.
const captainRoute = (orderId: string, headers: Record<string, string>) =>
  app.inject({ method: 'GET', url: `/v1/captain/orders/${orderId}/route`, headers });

describe('the route and the position after a handover (CA §9.10.1, CU §11.3)', () => {
  it("routes the second captain only from the receipt, and publishes only the carrier's points", async () => {
    const publisher = app.get(RealtimePublisher);
    const enabled = vi.spyOn(publisher, 'enabled', 'get').mockReturnValue(true);
    const broadcast = vi.spyOn(publisher, 'broadcast').mockResolvedValue();
    // The publications a point starts run after it, unawaited
    // (CaptainsService.onLivePosition): wait for those started, not a time.
    const publish = vi.spyOn(
      app.get(OrderRoutes) as unknown as { publish: (...args: unknown[]) => Promise<void> },
      'publish',
    );
    try {
      const { order, first, ops } = await pickedUpOrder();
      const second = await onlineCaptain('باسل الثاني', besideThem);
      expect((await ops.handover(order.id, second.captainId)).statusCode).toBe(200);
      const captains = app.get(CaptainsService);
      const point = (at: Date) => [
        { ...besideThem, accuracyMetres: 8, recordedAt: at, simulated: false },
      ];
      const sentTo = () =>
        broadcast.mock.calls
          .filter(([channels]) => channels[0] === `order:${order.id}`)
          .map(([, data]) => data);

      // Before the receipt the order is still the first captain's.
      expect((await captainRoute(order.id, second.headers)).json()).toMatchObject({
        error: 'unknown_order',
      });
      broadcast.mockClear();
      await captains.recordLocations(second.captainId, point(new Date()), new Date());
      expect(publish).toHaveBeenCalled();
      await Promise.allSettled(publish.mock.results.map((result) => result.value));
      expect(sentTo()).toEqual([]);

      expect((await second.receive(order.id)).statusCode).toBe(200);
      const route = await captainRoute(order.id, second.headers);
      expect(route.statusCode).toBe(200);
      expect(route.json()).toMatchObject({ leg: 'to_customer', destination: home });
      expect((await captainRoute(order.id, first.headers)).statusCode).toBe(404);

      // The second captain's points now go to the customer.
      broadcast.mockClear();
      const at = new Date(Date.now() + 1000);
      await captains.recordLocations(second.captainId, point(at), new Date(at.getTime() + 1));
      await vi.waitFor(() =>
        expect(sentTo()).toEqual([
          expect.objectContaining({ type: 'captain.position', recordedAt: at.toISOString() }),
        ]),
      );
    } finally {
      publish.mockRestore();
      enabled.mockRestore();
      broadcast.mockRestore();
    }
  });
});
