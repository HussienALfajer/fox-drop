import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { createDatabase, type Database } from './database.js';
import { runMigrations } from './migrate.js';
import { startTestDatabase, type TestDatabase } from './test-database.js';

let database: TestDatabase;
let app: Database;

beforeAll(async () => {
  database = await startTestDatabase();
  app = createDatabase(database.appUrl);
}, 300_000);

afterAll(async () => {
  await app?.pool.end();
  await database?.stop();
});

async function appQuery(text: string) {
  return app.pool.query(text);
}

describe('migrations on a fresh database', () => {
  it('seed Azaz with a UUIDv7 key', async () => {
    const { rows } = await appQuery('SELECT id, code, name, time_zone, status FROM geo.cities');

    expect(rows).toEqual([
      {
        id: expect.stringMatching(/^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab]/),
        code: 'AZ',
        name: 'أعزاز',
        time_zone: 'Asia/Damascus',
        status: 'active',
      },
    ]);
  });

  it('apply nothing on a second run, even two at once', async () => {
    await Promise.all([runMigrations(database.migratorUrl), runMigrations(database.migratorUrl)]);

    const { rows } = await appQuery('SELECT count(*)::int AS count FROM geo.cities');
    expect(rows[0].count).toBe(1);
  });

  it('have only the extensions production has', async () => {
    const { rows } = await appQuery('SELECT extname FROM pg_extension ORDER BY extname');
    expect(rows.map((row) => row.extname)).toEqual(['plpgsql', 'postgis']);
  });

  it('give the application role PostGIS', async () => {
    const { rows } = await appQuery(
      'SELECT ST_Contains(ST_MakeEnvelope(0, 0, 2, 2, 4326), ST_SetSRID(ST_MakePoint(1, 1), 4326)) AS inside',
    );
    expect(rows[0].inside).toBe(true);
  });
});

describe('the application role', () => {
  it('adds and changes rows', async () => {
    await appQuery("INSERT INTO geo.cities (code, name) VALUES ('TS', 'test city')");
    await appQuery("UPDATE geo.cities SET status = 'inactive' WHERE code = 'TS'");

    const { rows } = await appQuery("SELECT status FROM geo.cities WHERE code = 'TS'");
    expect(rows[0].status).toBe('inactive');
  });

  it.each([
    ['delete a row', "DELETE FROM geo.cities WHERE code = 'TS'", /permission denied/],
    ['create a table', 'CREATE TABLE geo.extra (id int)', /permission denied/],
    ['alter a table', 'ALTER TABLE geo.cities ADD COLUMN extra int', /must be owner/],
    ['drop a table', 'DROP TABLE geo.cities', /must be owner/],
    ['create a schema', 'CREATE SCHEMA extra', /permission denied/],
    ['create a table in public', 'CREATE TABLE public.extra (id int)', /permission denied/],
    [
      'read the migration journal',
      'SELECT * FROM drizzle.__drizzle_migrations',
      /permission denied/,
    ],
  ])('cannot %s', async (_, statement, error) => {
    await expect(appQuery(statement)).rejects.toThrow(error);
  });
});

describe('the audit log (AP §9.16)', () => {
  const currentPartition = `audit.events_${new Date().toISOString().slice(0, 7).replace('-', '_')}`;

  it('has a partition for this month and the next', async () => {
    const { rows } = await appQuery(
      "SELECT inhrelid::regclass::text AS name FROM pg_inherits WHERE inhparent = 'audit.events'::regclass ORDER BY 1",
    );
    expect(rows).toHaveLength(2);
    expect(rows[0].name).toBe(currentPartition);
  });

  it('takes an event from the application role and reads it back', async () => {
    await appQuery(
      "INSERT INTO audit.events (actor_type, kind, action, target_type, target_id) VALUES ('system', 'write', 'test.write', 'city', 'AZ')",
    );

    const { rows } = await appQuery(
      `SELECT id, action FROM ${currentPartition} WHERE action = 'test.write'`,
    );
    expect(rows).toEqual([
      { id: expect.stringMatching(/^[0-9a-f]{8}-[0-9a-f]{4}-7/), action: 'test.write' },
    ]);
  });

  it('lets the application role create the coming partitions again', async () => {
    await appQuery('SELECT audit.create_month_partitions()');
  });

  it.each([
    ['an admin without an id', "'admin', NULL, 'write', NULL"],
    ['the system with an id', "'system', '0190f3a0-0000-7000-8000-000000000001', 'write', NULL"],
    ['a view with changes', "'system', NULL, 'view', '{}'"],
  ])('refuses %s', async (_, values) => {
    await expect(
      appQuery(
        `INSERT INTO audit.events (actor_type, actor_id, kind, changes, action, target_type, target_id) VALUES (${values}, 'test.refused', 'city', 'AZ')`,
      ),
    ).rejects.toThrow(/violates check constraint/);
  });

  it.each([
    ['change an event', "UPDATE audit.events SET reason = 'x'"],
    ['change an event in its partition', `UPDATE ${currentPartition} SET reason = 'x'`],
    ['delete an event', 'DELETE FROM audit.events'],
    ['delete an event from its partition', `DELETE FROM ${currentPartition}`],
    ['empty the log', 'TRUNCATE audit.events'],
    ['empty a partition', `TRUNCATE ${currentPartition}`],
    [
      'create a partition',
      "CREATE TABLE audit.events_2099_01 PARTITION OF audit.events FOR VALUES FROM ('2099-01-01') TO ('2099-02-01')",
    ],
  ])('refuses the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied|must be owner/);
  });
});

describe('the settings tables (AP §4.4)', () => {
  const editor = "'0190f3a0-0000-7000-8000-000000000001', '{OWN}'";

  it('keep one stored value per key and scope, global included', async () => {
    await appQuery("INSERT INTO settings.values (key, value) VALUES ('test.global', '1')");

    await expect(
      appQuery("INSERT INTO settings.values (key, value) VALUES ('test.global', '2')"),
    ).rejects.toThrow(/values_key_city/);
  });

  it('let the application role change a stored value', async () => {
    await appQuery("UPDATE settings.values SET value = '3' WHERE key = 'test.global'");
  });

  it('refuse a value on a row reset to the default', async () => {
    await expect(
      appQuery(
        "INSERT INTO settings.values (key, value, is_default) VALUES ('test.reset', '1', true)",
      ),
    ).rejects.toThrow(/values_default_has_no_value/);
  });

  it('take a change from the application role', async () => {
    await appQuery(
      `INSERT INTO settings.changes (key, action, before, after, editor_id, editor_roles) VALUES ('test.global', 'update', '1', '3', ${editor})`,
    );
  });

  it.each([
    ['change a change', "UPDATE settings.changes SET reason = 'x'"],
    ['delete a change', 'DELETE FROM settings.changes'],
    ['delete a stored value', 'DELETE FROM settings.values'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the identity tables (AP §5.1–5.2)', () => {
  it('refuse an admin account without an email or a phone', async () => {
    await expect(
      appQuery("INSERT INTO identity.admin_accounts (roles) VALUES ('{OWN}')"),
    ).rejects.toThrow(/admin_accounts_has_sign_in_name/);
  });

  it('refuse an active admin account without a password and a TOTP secret', async () => {
    await expect(
      appQuery(
        "INSERT INTO identity.admin_accounts (email, roles, status) VALUES ('a@example.test', '{OWN}', 'active')",
      ),
    ).rejects.toThrow(/admin_accounts_active_is_set_up/);
  });

  it('keep one account per email', async () => {
    await appQuery(
      "INSERT INTO identity.admin_accounts (email, roles) VALUES ('owner@example.test', '{OWN}')",
    );
    await expect(
      appQuery(
        "INSERT INTO identity.admin_accounts (email, roles) VALUES ('owner@example.test', '{OPS}')",
      ),
    ).rejects.toThrow(/admin_accounts_email_unique/);
  });

  it('let the application role end a session', async () => {
    await appQuery(
      "INSERT INTO identity.admin_sessions (account_id, token_hash) SELECT id, 'h1' FROM identity.admin_accounts WHERE email = 'owner@example.test'",
    );
    await appQuery(
      "UPDATE identity.admin_sessions SET ended_at = now(), end_reason = 'sign_out' WHERE token_hash = 'h1'",
    );
  });

  it.each([
    ['delete an account', 'DELETE FROM identity.admin_accounts'],
    ['delete a session', 'DELETE FROM identity.admin_sessions'],
    ['delete a backup code', 'DELETE FROM identity.admin_backup_codes'],
    ['delete a setup link', 'DELETE FROM identity.admin_setup_links'],
    ['delete a sign-in code', 'DELETE FROM identity.app_sign_in_codes'],
    ['delete a customer account', 'DELETE FROM identity.customer_accounts'],
    ['delete an app session', 'DELETE FROM identity.app_sessions'],
    ['delete a refresh token', 'DELETE FROM identity.app_refresh_tokens'],
    ['delete a signing key', 'DELETE FROM identity.app_signing_keys'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the app sign-in tables (architecture §8.3.2, §15.1)', () => {
  const code = (phoneHash: string) =>
    `INSERT INTO identity.app_sign_in_codes (party, phone_hash, device_id, code_hash, expires_at) VALUES ('customer', '${phoneHash}', 'd1', 'c1', now())`;

  it('keep one open code per number', async () => {
    await appQuery(code('p1'));
    await expect(appQuery(code('p1'))).rejects.toThrow(/app_sign_in_codes_open_per_number/);
    await appQuery(
      "UPDATE identity.app_sign_in_codes SET ended_at = now(), end_reason = 'replaced' WHERE phone_hash = 'p1'",
    );
    await appQuery(code('p1'));
  });

  it('keep one active customer account per number', async () => {
    const account =
      "INSERT INTO identity.customer_accounts (phone_encrypted, phone_hash) VALUES ('e', 'p2')";
    await appQuery(account);
    await expect(appQuery(account)).rejects.toThrow(/customer_accounts_active_phone/);
  });

  it('refuse a party no app signs in with yet', async () => {
    await expect(appQuery(code('p3').replace("'customer'", "'courier'"))).rejects.toThrow(
      /app_sign_in_codes_party_values/,
    );
  });
});
