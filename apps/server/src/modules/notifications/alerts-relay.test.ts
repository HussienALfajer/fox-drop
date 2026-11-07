import 'reflect-metadata';
import { randomUUID } from 'node:crypto';
import { Module } from '@nestjs/common';
import { Test, type TestingModule } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, beforeEach, describe, expect, it } from 'vitest';
import { startTestCentrifugo, type TestCentrifugo } from '../../centrifugo/test-centrifugo.js';
import { DatabaseModule } from '../../database/database.module.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { GeoService } from '../geo/index.js';
import { AlertsRelay } from './alerts-relay.js';
import { PublishFailedError, RealtimePublisher } from './realtime-publisher.js';

// E4, architecture §6.2: every alert change in the outbox reaches the
// city's ops channel at least once, and a platform alert every active city.
let database: TestDatabase;
let centrifugo: TestCentrifugo;
let sql: pg.Pool;
let context: TestingModule;
let relay: AlertsRelay;
let azaz: string;
let other: string;

beforeAll(async () => {
  [database, centrifugo] = await Promise.all([startTestDatabase(), startTestCentrifugo()]);
  process.env.DATABASE_URL = database.appUrl;
  Object.assign(process.env, centrifugo.env);
  sql = new pg.Pool({ connectionString: database.appUrl });
  azaz = randomUUID();
  other = randomUUID();
  // The active cities (GeoService.activeCities is proved in geo.test.ts).
  const geo = { activeCities: async () => [{ id: azaz }, { id: other }] };
  @Module({
    imports: [DatabaseModule],
    providers: [RealtimePublisher, AlertsRelay, { provide: GeoService, useValue: geo }],
  })
  class RelayTestModule {}
  context = await Test.createTestingModule({ imports: [RelayTestModule] }).compile();
  relay = context.get(AlertsRelay);
}, 300_000);

afterAll(async () => {
  await context?.close();
  await sql?.end();
  await Promise.all([database?.stop(), centrifugo?.stop()]);
});

beforeEach(async () => {
  Object.assign(process.env, centrifugo.env);
  await relay.drain(new Date());
});

async function insert(cityId: string | null, type = 'alert.raised'): Promise<string> {
  const alertId = randomUUID();
  await sql.query(
    `INSERT INTO notifications.alert_outbox (created_at, city_id, type, alert_id, payload)
     VALUES (now(), $1, $2, $3, $4)`,
    [
      cityId,
      type,
      alertId,
      JSON.stringify({
        schema: 1,
        alertId,
        code: 'restaurant_not_accepted',
        severity: 'critical',
        at: new Date().toISOString(),
      }),
    ],
  );
  return alertId;
}

const alertsOn = async (cityId: string) =>
  ((await centrifugo.history(`ops:city.${cityId}`)) as { alertId: string; type: string }[]).map(
    (data) => `${data.type} ${data.alertId}`,
  );

const unpublished = async () =>
  (await sql.query('SELECT id FROM notifications.alert_outbox WHERE published_at IS NULL')).rows
    .length;

describe('the alerts relay (E4)', () => {
  it("publishes a city's alert changes to its channel, in order, once, with the alert's id only", async () => {
    const raised = await insert(azaz);
    await sql.query(
      `INSERT INTO notifications.alert_outbox (created_at, city_id, type, alert_id, payload)
       SELECT now(), city_id, 'alert.resolved', alert_id, payload FROM notifications.alert_outbox WHERE alert_id = $1`,
      [raised],
    );

    expect(await relay.drain(new Date())).toBe(2);
    expect(await unpublished()).toBe(0);
    const ofAlert = (await alertsOn(azaz)).filter((line) => line.endsWith(raised));
    expect(ofAlert).toEqual([`alert.raised ${raised}`, `alert.resolved ${raised}`]);
    const [data] = ((await centrifugo.history(`ops:city.${azaz}`)) as object[]).filter(
      (each) => (each as { alertId: string }).alertId === raised,
    );
    // Some subscribers do not receive the alert (AP §7.3): its rule stays out.
    expect(data).toEqual({
      type: 'alert.raised',
      schema: 1,
      alertId: raised,
      at: expect.any(String),
    });
    expect((await alertsOn(other)).some((line) => line.endsWith(raised))).toBe(false);

    expect(await relay.drain(new Date())).toBe(0);
    expect((await alertsOn(azaz)).filter((line) => line.endsWith(raised))).toHaveLength(2);
  });

  it('publishes an alert of the whole platform to every active city', async () => {
    const platform = await insert(null);

    expect(await relay.drain(new Date())).toBe(1);
    for (const city of [azaz, other]) {
      expect(await alertsOn(city)).toContain(`alert.raised ${platform}`);
    }
  });

  it('leaves the rows while Centrifugo is out of reach, and publishes them later', async () => {
    const waiting = await insert(azaz);
    process.env.CENTRIFUGO_API_URL = 'http://127.0.0.1:1/api';
    await expect(relay.drain(new Date())).rejects.toBeInstanceOf(PublishFailedError);
    expect(await unpublished()).toBe(1);

    Object.assign(process.env, centrifugo.env);
    expect(await relay.drain(new Date())).toBe(1);
    expect(await alertsOn(azaz)).toContain(`alert.raised ${waiting}`);
  });
});
