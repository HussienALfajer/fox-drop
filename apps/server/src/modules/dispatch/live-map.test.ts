import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { describe, expect, it } from 'vitest';
import { CaptainsService } from '../captains/index.js';
import { GeoService } from '../geo/index.js';
import { LiveMap, LiveMapPublisher } from './live-map.js';
import {
  app,
  azaz,
  restaurant,
  centre,
  captainSpot,
  home,
  admin,
  acceptedOrder,
  onlineCaptain,
} from './dispatch.fixture.js';

const readMap = async (roles: string[] = ['OPS']) => {
  const answer = await (await admin(roles)).get(`/v1/admin/live-map?cityId=${azaz}`);
  expect(answer.statusCode).toBe(200);
  return answer.json();
};

describe('GET /v1/admin/live-map (AP §9.4, slice 2.39)', () => {
  it('shows the zones, the restaurants, the captains and the active orders', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const map = await readMap();
    expect(map.zones).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ name: 'المركز', active: true, area: expect.any(Array) }),
      ]),
    );
    expect(map.restaurants).toContainEqual({
      id: restaurant,
      name: 'مطعم التوزيع',
      location: centre,
      state: 'open',
    });
    expect(map.captains).toContainEqual(
      expect.objectContaining({
        captainId: captain.captainId,
        vehicle: 'motorbike',
        state: 'online_available',
        blocks: [],
        custody: {
          usage: { amount: '0', currency: 'TRY' },
          limit: { amount: '300000', currency: 'TRY' },
        },
        position: { ...captainSpot, recordedAt: expect.any(String) },
        order: null,
      }),
    );
    expect(map.orders).toContainEqual(
      expect.objectContaining({
        id: order.id,
        status: 'accepted',
        restaurantId: restaurant,
        restaurantName: 'مطعم التوزيع',
        from: centre,
        to: home,
        captainId: null,
        assignable: true,
      }),
    );
  });

  it('assigns from the map: an offered order leaves the list, a busy captain carries its number', async () => {
    const order = await acceptedOrder();
    const captain = await onlineCaptain();
    const ops = await admin(['OPS']);
    const assigned = await ops.assign(order.id, captain.captainId);
    expect(assigned.statusCode).toBe(200);
    const offered = await readMap();
    expect(offered.orders.find((each: { id: string }) => each.id === order.id)).toMatchObject({
      assignable: false,
      captainId: null,
    });
    const offerId: string = assigned.json().order.offer.id;
    const accepted = await captain.call('POST', `/v1/captain/offers/${offerId}/accept`);
    expect(accepted.statusCode).toBe(200);
    const busy = await readMap();
    const number = busy.orders.find((each: { id: string }) => each.id === order.id).number;
    expect(
      busy.captains.find((each: { captainId: string }) => each.captainId === captain.captainId),
    ).toMatchObject({ state: 'busy', order: { id: order.id, number } });
  });

  it('keeps an offline captain at the last known position and its time', async () => {
    const captain = await onlineCaptain({ latitude: 36.6, longitude: 37.05 });
    await app.get(CaptainsService).goOffline(captain.captainId, new Date());
    const map = await readMap(['SUP']);
    expect(
      map.captains.find((each: { captainId: string }) => each.captainId === captain.captainId),
    ).toMatchObject({
      state: 'offline',
      position: { latitude: 36.6, longitude: 37.05, recordedAt: expect.any(String) },
    });
  });

  it('is for live_map.read (OWN, OPS, SUP); an unknown city is 404', async () => {
    for (const roles of [['OWN'], ['SUP']]) {
      const answer = await (await admin(roles)).get(`/v1/admin/live-map?cityId=${azaz}`);
      expect(answer.statusCode, roles.join()).toBe(200);
    }
    for (const roles of [['FIN'], ['DATA']]) {
      const answer = await (await admin(roles)).get(`/v1/admin/live-map?cityId=${azaz}`);
      expect(answer.statusCode, roles.join()).toBe(403);
    }
    const unknown = await (await admin(['OPS'])).get(`/v1/admin/live-map?cityId=${randomUUID()}`);
    expect(unknown.statusCode).toBe(404);
    expect(unknown.json()).toMatchObject({ error: 'unknown_city' });
  });
});

describe('the live map channel (architecture §6.2, slice 2.39)', () => {
  it("publishes each active city's captains on ops_map:city.{city_id}", async () => {
    const captain = await onlineCaptain();
    const sent: { channels: string[]; data: { type: string; captains: unknown[] } }[] = [];
    const publisher = {
      enabled: true,
      broadcast: (channels: string[], data: object) => {
        sent.push({ channels, data: data as (typeof sent)[number]['data'] });
        return Promise.resolve();
      },
    };
    const live = new LiveMapPublisher(
      app.get(GeoService),
      app.get(LiveMap),
      publisher as unknown as ConstructorParameters<typeof LiveMapPublisher>[2],
    );
    await live.publish(new Date());
    const toAzaz = sent.find((each) => each.channels[0] === `ops_map:city.${azaz}`);
    expect(toAzaz?.data.type).toBe('captains');
    expect(toAzaz?.data.captains).toContainEqual(
      expect.objectContaining({ captainId: captain.captainId, state: 'online_available' }),
    );
  });

  it('publishes nothing while real time is off', async () => {
    let calls = 0;
    const publisher = {
      enabled: false,
      broadcast: () => {
        calls += 1;
        return Promise.resolve();
      },
    };
    const live = new LiveMapPublisher(
      app.get(GeoService),
      app.get(LiveMap),
      publisher as unknown as ConstructorParameters<typeof LiveMapPublisher>[2],
    );
    await live.publish(new Date());
    expect(calls).toBe(0);
  });
});
