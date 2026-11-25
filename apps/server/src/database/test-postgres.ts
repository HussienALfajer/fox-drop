import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { PostgreSqlContainer } from '@testcontainers/postgresql';
import pg from 'pg';
import { runMigrations } from './migrate.js';
import { adminUrl, passwords, TEMPLATE, type TestPostgres, url } from './test-database.js';

// One PostGIS for the whole test run, set up exactly as compose.yaml sets up
// the local one: the same image, the same bootstrap of the two roles, then
// every migration, once, into the template database. Each database test file
// takes its own copy of the template (startTestDatabase), so the files stay
// isolated without a container each. Needs Docker.
//
// Only the global setup (src/database/test-postgres.global-setup.ts) imports
// this file: a test file's worker then never loads Testcontainers.
const serverDir = new URL('../../', import.meta.url);
const composeFile = readFileSync(new URL('../../compose.yaml', serverDir), 'utf8');
const image = /image: (postgis\/postgis:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no postgis image');
const postgisImage: string = image;

export async function startTestPostgres(
  labels: Record<string, string>,
): Promise<TestPostgres & { stop(): Promise<void> }> {
  const container = await new PostgreSqlContainer(postgisImage)
    .withLabels(labels)
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
