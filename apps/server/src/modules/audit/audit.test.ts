import 'reflect-metadata';
import { Test } from '@nestjs/testing';
import pg from 'pg';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { startTestDatabase, type TestDatabase } from '../../database/test-database.js';
import { AuditModule, AuditService, AuditWorkerModule } from './index.js';

// The audit module on a fresh database, connected as the application role
// through DATABASE_URL, as the server connects.
let database: TestDatabase;
let reader: pg.Pool;

beforeAll(async () => {
  database = await startTestDatabase();
  process.env.DATABASE_URL = database.appUrl;
  reader = new pg.Pool({ connectionString: database.appUrl });
}, 300_000);

afterAll(async () => {
  await reader?.end();
  await database?.stop();
});

const owner = { type: 'admin', id: '0190f3a0-0000-7000-8000-000000000001', role: 'OWN' } as const;
const context = { ipAddress: '203.0.113.7', device: 'Firefox 140 on Windows' };

async function withAudit(
  test: (audit: AuditService, database: Database) => Promise<void>,
): Promise<void> {
  const moduleRef = await Test.createTestingModule({ imports: [AuditModule] }).compile();
  await moduleRef.init();
  try {
    await test(moduleRef.get(AuditService), moduleRef.get(DATABASE, { strict: false }));
  } finally {
    await moduleRef.close();
  }
}

async function eventsFor(action: string) {
  const { rows } = await reader.query(
    `SELECT city_id, actor_type, actor_id, actor_role, kind, target_type, target_id,
            changes, reason, host(ip_address) AS ip_address, device
       FROM audit.events WHERE action = $1`,
    [action],
  );
  return rows;
}

describe('AuditService', () => {
  it('records a write with its actor, context and changed fields', async () => {
    await withAudit((audit, { db }) =>
      db.transaction((tx) =>
        audit.recordWrite(
          {
            actor: owner,
            context,
            cityId: null,
            action: 'setting.update',
            target: { type: 'setting', id: 'dispatch.offer_seconds' },
            before: { value: 30, scope: 'global' },
            after: { value: 45, scope: 'global' },
            reason: 'Captains need more time to read offers',
          },
          tx,
        ),
      ),
    );

    expect(await eventsFor('setting.update')).toEqual([
      {
        city_id: null,
        actor_type: 'admin',
        actor_id: owner.id,
        actor_role: 'OWN',
        kind: 'write',
        target_type: 'setting',
        target_id: 'dispatch.offer_seconds',
        changes: { value: { before: 30, after: 45 } },
        reason: 'Captains need more time to read offers',
        ip_address: '203.0.113.7',
        device: 'Firefox 140 on Windows',
      },
    ]);
  });

  it('records a sensitive view without changes', async () => {
    const cityId = '0190f3a0-0000-7000-8000-0000000000aa';
    await withAudit((audit) =>
      audit.recordView({
        actor: { type: 'admin', id: owner.id, role: 'SUP' },
        context,
        cityId,
        action: 'customer.phone.view',
        target: { type: 'customer', id: '0190f3a0-0000-7000-8000-0000000000bb' },
      }),
    );

    expect(await eventsFor('customer.phone.view')).toEqual([
      expect.objectContaining({ city_id: cityId, kind: 'view', changes: null, reason: null }),
    ]);
  });

  it('records nothing when the audited transaction rolls back', async () => {
    await withAudit(async (audit, { db }) => {
      await expect(
        db.transaction(async (tx) => {
          await audit.recordView(
            {
              actor: { type: 'system', id: null, role: null },
              context: { ipAddress: null, device: null },
              cityId: null,
              action: 'test.rolled_back',
              target: { type: 'city', id: 'AZ' },
            },
            tx,
          );
          throw new Error('the write failed');
        }),
      ).rejects.toThrow('the write failed');
    });

    expect(await eventsFor('test.rolled_back')).toEqual([]);
  });
});

describe('AuditWorkerModule', () => {
  // Next month's partition, dropped by the migration role so the worker has to
  // create it, as it will every month.
  const next = new Date();
  next.setUTCDate(1);
  next.setUTCMonth(next.getUTCMonth() + 1);
  const nextPartition = `audit.events_${next.toISOString().slice(0, 7).replace('-', '_')}`;

  it('creates the next partition, append-only like the others', async () => {
    const migrator = new pg.Client({ connectionString: database.migratorUrl });
    await migrator.connect();
    await migrator.query(`DROP TABLE ${nextPartition}`);
    await migrator.end();

    const moduleRef = await Test.createTestingModule({ imports: [AuditWorkerModule] }).compile();
    await moduleRef.init();
    await moduleRef.close();

    const { rows } = await reader.query(
      `SELECT pg_get_userbyid(relowner) AS owner,
              has_table_privilege('fox_drop_app', oid, 'INSERT') AS can_insert,
              has_table_privilege('fox_drop_app', oid, 'UPDATE') AS can_update,
              has_table_privilege('fox_drop_app', oid, 'DELETE') AS can_delete,
              has_table_privilege('fox_drop_app', oid, 'TRUNCATE') AS can_truncate
         FROM pg_class WHERE oid = $1::regclass`,
      [nextPartition],
    );
    expect(rows).toEqual([
      {
        owner: 'fox_drop_migrator',
        can_insert: true,
        can_update: false,
        can_delete: false,
        can_truncate: false,
      },
    ]);
  });
});
