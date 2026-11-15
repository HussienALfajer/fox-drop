import { randomBytes } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { PostgreSqlContainer } from '@testcontainers/postgresql';
import pg from 'pg';
import { inject } from 'vitest';
import { runMigrations } from './migrate.js';

export interface TestDatabase {
  // The migration role and the application role.
  migratorUrl: string;
  appUrl: string;
  stop(): Promise<void>;
}

// Where the run's PostGIS listens, from the global setup to each test file.
export interface TestPostgres {
  host: string;
  port: number;
}

declare module 'vitest' {
  export interface ProvidedContext {
    testPostgres: TestPostgres;
  }
}

// One PostGIS for the whole test run, set up exactly as compose.yaml sets up
// the local one: the same image, the same bootstrap of the two roles, then
// every migration, once, into the template database. Each database test file
// takes its own copy of the template (startTestDatabase), so the files stay
// isolated without a container each. Needs Docker.
const serverDir = new URL('../../', import.meta.url);
const composeFile = readFileSync(new URL('../../compose.yaml', serverDir), 'utf8');
const image = /image: (postgis\/postgis:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no postgis image');
const postgisImage: string = image;

const TEMPLATE = 'fox_drop';
const passwords = {
  postgres: 'test-postgres-password',
  migrator: 'test-migrator-password',
  app: 'test-app-password',
};

const url = (where: TestPostgres, role: string, password: string, database: string) =>
  `postgres://${role}:${password}@${where.host}:${where.port}/${database}`;
const adminUrl = (where: TestPostgres) => url(where, 'postgres', passwords.postgres, 'postgres');

// The global setup's half (src/database/test-postgres.global-setup.ts).
export async function startTestPostgres(): Promise<TestPostgres & { stop(): Promise<void> }> {
  const container = await new PostgreSqlContainer(postgisImage)
    .withDatabase(TEMPLATE)
    .withUsername('postgres')
    .withPassword(passwords.postgres)
    .withEnvironment({
      FOX_DROP_MIGRATOR_PASSWORD: passwords.migrator,
      FOX_DROP_APP_PASSWORD: passwords.app,
    })
    .withCopyFilesToContainer([
      {
        source: fileURLToPath(new URL('db/init-container.sh', serverDir)),
        target: '/docker-entrypoint-initdb.d/20-fox-drop.sh',
        mode: 0o755,
      },
      {
        source: fileURLToPath(new URL('db/bootstrap.sql', serverDir)),
        target: '/fox-drop/bootstrap.sql',
      },
    ])
    // Throwaway data: no flush to disk. Every test file holds a few pools.
    .withCommand([
      'postgres',
      '-c',
      'fsync=off',
      '-c',
      'synchronous_commit=off',
      '-c',
      'full_page_writes=off',
      '-c',
      'max_connections=1000',
    ])
    .withSharedMemorySize(512 * 1024 * 1024)
    .start();
  const where = { host: container.getHost(), port: container.getPort() };
  await runMigrations(url(where, 'fox_drop_migrator', passwords.migrator, TEMPLATE));
  // A database is copied only while nobody is connected to it.
  const admin = new pg.Client({ connectionString: adminUrl(where) });
  await admin.connect();
  try {
    await admin.query(`ALTER DATABASE ${TEMPLATE} WITH ALLOW_CONNECTIONS false`);
  } finally {
    await admin.end();
  }
  return { ...where, stop: async () => void (await container.stop()) };
}

// A fresh, migrated database for one test file: a copy of the template, with
// the database grants of bootstrap.sql, which a copy does not take.
export async function startTestDatabase(): Promise<TestDatabase> {
  const where = inject('testPostgres');
  const database = `test_${randomBytes(8).toString('hex')}`;
  const admin = new pg.Client({ connectionString: adminUrl(where) });
  await admin.connect();
  try {
    await admin.query(`CREATE DATABASE ${database} TEMPLATE ${TEMPLATE}`);
    await admin.query(`REVOKE ALL ON DATABASE ${database} FROM PUBLIC`);
    await admin.query(`GRANT CONNECT, CREATE ON DATABASE ${database} TO fox_drop_migrator`);
    await admin.query(`GRANT CONNECT ON DATABASE ${database} TO fox_drop_app`);
  } finally {
    await admin.end();
  }
  return {
    migratorUrl: url(where, 'fox_drop_migrator', passwords.migrator, database),
    appUrl: url(where, 'fox_drop_app', passwords.app, database),
    stop: () => dropDatabase(where, database),
  };
}

// A pool's end() resolves before its clients' sockets close. Dropping the
// database while they close sends each one 57P01 («terminating connection
// due to administrator command»), an uncaught error in a pool without an
// error listener that fails the whole test run. So the drop waits, up to 5
// seconds, until no client is connected to it.
async function dropDatabase(where: TestPostgres, database: string): Promise<void> {
  const admin = new pg.Client({ connectionString: adminUrl(where) });
  await admin.connect();
  try {
    for (let attempt = 0; attempt < 50; attempt += 1) {
      const { rows } = await admin.query<{ connected: number }>(
        'SELECT count(*)::int AS connected FROM pg_stat_activity WHERE datname = $1',
        [database],
      );
      if (rows[0]!.connected === 0) break;
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    await admin.query(`DROP DATABASE ${database} WITH (FORCE)`);
  } finally {
    // A client's end() resolves once its socket has closed.
    await admin.end();
  }
}
