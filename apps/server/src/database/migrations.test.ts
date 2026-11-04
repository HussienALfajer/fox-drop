import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { PostgreSqlContainer, type StartedPostgreSqlContainer } from '@testcontainers/postgresql';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { createDatabase, type Database } from './database.js';
import { runMigrations } from './migrate.js';

// The migrations on a fresh PostGIS, set up exactly as compose.yaml sets up
// the local one: the same image, the same bootstrap of the two roles.
const serverDir = new URL('../../', import.meta.url);
const composeFile = readFileSync(new URL('../../compose.yaml', serverDir), 'utf8');
const image = /image: (postgis\/postgis:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no postgis image');

const passwords = { migrator: 'test-migrator-password', app: 'test-app-password' };

let container: StartedPostgreSqlContainer;
let app: Database;

function roleUrl(role: string, password: string): string {
  return `postgres://${role}:${password}@${container.getHost()}:${container.getPort()}/fox_drop`;
}

beforeAll(async () => {
  container = await new PostgreSqlContainer(image)
    .withDatabase('fox_drop')
    .withUsername('postgres')
    .withPassword('test-postgres-password')
    .withEnvironment({
      FOX_DROP_MIGRATOR_PASSWORD: passwords.migrator,
      FOX_DROP_APP_PASSWORD: passwords.app,
    })
    .withCopyFilesToContainer([
      {
        source: fileURLToPath(new URL('db/init-development.sh', serverDir)),
        target: '/docker-entrypoint-initdb.d/20-fox-drop.sh',
        mode: 0o755,
      },
      {
        source: fileURLToPath(new URL('db/bootstrap.sql', serverDir)),
        target: '/fox-drop/bootstrap.sql',
      },
    ])
    .start();
  await runMigrations(roleUrl('fox_drop_migrator', passwords.migrator));
  app = createDatabase(roleUrl('fox_drop_app', passwords.app));
}, 300_000);

afterAll(async () => {
  await app?.pool.end();
  await container?.stop();
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
    const url = roleUrl('fox_drop_migrator', passwords.migrator);
    await Promise.all([runMigrations(url), runMigrations(url)]);

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
