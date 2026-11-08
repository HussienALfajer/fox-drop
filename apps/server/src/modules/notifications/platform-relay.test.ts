import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Module } from '@nestjs/common';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { startTestCentrifugo, type TestCentrifugo } from '../../centrifugo/test-centrifugo.js';
import { DATABASE, DatabaseModule } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { CaptainsService } from '../captains/index.js';
import { GeoService } from '../geo/index.js';
import { MerchantsService } from '../merchants/index.js';
import { PlatformBroadcasts } from './platform-broadcasts.js';
import { PlatformRelay } from './platform-relay.js';
import { RealtimePublisher } from './realtime-publisher.js';

// RA §18, CA §15, AP §7: a platform broadcast reaches every restaurant's and
// captain's channel of its city and the panel, and an app's change every
// active city's devices of that app, at least once (E4).
let database: TestDatabase;
let centrifugo: TestCentrifugo;
let sql: pg.Pool;
let context: TestingModule;
let relay: PlatformRelay;
let broadcasts: PlatformBroadcasts;
const azaz = randomUUID();
const other = randomUUID();
const restaurants = { [azaz]: [randomUUID(), randomUUID()], [other]: [randomUUID()] };
const order = randomUUID();
const captains = { [azaz]: [randomUUID()], [other]: [randomUUID()] };

beforeAll(async () => {
  [database, centrifugo] = await Promise.all([startTestDatabase(), startTestCentrifugo()]);
  process.env.DATABASE_URL = database.appUrl;
  Object.assign(process.env, centrifugo.env);
  sql = new pg.Pool({ connectionString: database.appUrl });
  // The cities, restaurants and captains (proved in their own modules).
  const geo = { activeCities: async () => [{ id: azaz }, { id: other }] };
  const merchants = {
    restaurantIds: async (cityId: string) => (restaurants[cityId] ?? []).map((id) => ({ id })),
  };
  const captainsService = {
    captainIds: async (cityId: string) => (captains[cityId] ?? []).map((id) => ({ id })),
  };
  @Module({
    imports: [DatabaseModule],
    providers: [
      RealtimePublisher,
      PlatformRelay,
      PlatformBroadcasts,
      { provide: GeoService, useValue: geo },
      { provide: MerchantsService, useValue: merchants },
      { provide: CaptainsService, useValue: captainsService },
    ],
  })
  class RelayTestModule {}
  context = await Test.createTestingModule({ imports: [RelayTestModule] }).compile();
  relay = context.get(PlatformRelay);
  broadcasts = context.get(PlatformBroadcasts);
}, 300_000);

afterAll(async () => {
  await context?.close();
  await sql?.end();
  await Promise.all([database?.stop(), centrifugo?.stop()]);
});

const on = async (channel: string) =>
  ((await centrifugo.history(channel)) as { type: string; active?: boolean; app?: string }[]).map(
    (data) => `${data.type} ${data.active ?? data.app}`,
  );

describe('the platform relay', () => {
  it("publishes the stop to the city's restaurants, captains and panel, and an app's change to every city", async () => {
    const db = context.get<Database>(DATABASE).db;
    const at = new Date();
    await broadcasts.enqueue(db, {
      type: 'platform.emergency_stop',
      cityId: azaz,
      active: true,
      orderIds: [order],
      at,
    });
    await broadcasts.enqueue(db, { type: 'platform.app_changed', app: 'captain', at });
    expect(await relay.drain(new Date())).toBe(2);
    expect(await relay.drain(new Date())).toBe(0);

    for (const id of restaurants[azaz]!) {
      expect(await on(`merchant:${id}`)).toEqual(['platform.emergency_stop true']);
    }
    expect(await on(`captain:${captains[azaz]![0]}`)).toEqual([
      'platform.emergency_stop true',
      'platform.app_changed captain',
    ]);
    expect(await on(`ops:city.${azaz}`)).toEqual(['platform.emergency_stop true']);
    // The customer's tracking screen of an active order.
    expect(await on(`order:${order}`)).toEqual(['platform.emergency_stop true']);
    // The other city hears only the captain app's change.
    expect(await on(`merchant:${restaurants[other]![0]}`)).toEqual([]);
    expect(await on(`captain:${captains[other]![0]}`)).toEqual(['platform.app_changed captain']);
    expect(await on(`ops:city.${other}`)).toEqual([]);
    const { rows } = await sql.query(
      'SELECT count(*)::int AS left FROM notifications.platform_outbox WHERE published_at IS NULL',
    );
    expect(rows[0].left).toBe(0);
  });

  it('leaves the rows while Centrifugo is out of reach', async () => {
    const db = context.get<Database>(DATABASE).db;
    await broadcasts.enqueue(db, {
      type: 'platform.emergency_stop',
      cityId: azaz,
      active: false,
      orderIds: [],
      at: new Date(),
    });
    process.env.CENTRIFUGO_API_URL = 'http://127.0.0.1:9/api';
    try {
      await expect(relay.drain(new Date())).rejects.toThrow();
    } finally {
      Object.assign(process.env, centrifugo.env);
    }
    expect(await relay.drain(new Date())).toBe(1);
  });
});
