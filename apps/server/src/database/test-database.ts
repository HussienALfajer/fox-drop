import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { PostgreSqlContainer } from '@testcontainers/postgresql';
import pg from 'pg';
import { runMigrations } from './migrate.js';

export interface TestDatabase {
  // The migration role and the application role.
  migratorUrl: string;
  appUrl: string;
  stop(): Promise<void>;
}

// A fresh, migrated PostGIS for a database test, set up exactly as
// compose.yaml sets up the local one: the same image, the same bootstrap of
// the two roles. Needs Docker.
const serverDir = new URL('../../', import.meta.url);
const composeFile = readFileSync(new URL('../../compose.yaml', serverDir), 'utf8');
const image = /image: (postgis\/postgis:\S+)/.exec(composeFile)?.[1];
if (!image) throw new Error('compose.yaml has no postgis image');
const postgisImage: string = image;

const passwords = { migrator: 'test-migrator-password', app: 'test-app-password' };

export async function startTestDatabase(): Promise<TestDatabase> {
  const container = await new PostgreSqlContainer(postgisImage)
    .withDatabase('fox_drop')
    .withUsername('postgres')
    .withPassword('test-postgres-password')
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
    .start();
  const roleUrl = (role: string, password: string) =>
    `postgres://${role}:${password}@${container.getHost()}:${container.getPort()}/fox_drop`;
  const migratorUrl = roleUrl('fox_drop_migrator', passwords.migrator);
  await runMigrations(migratorUrl);
  return {
    migratorUrl,
    appUrl: roleUrl('fox_drop_app', passwords.app),
    stop: async () => {
      await closedConnections(container.getConnectionUri());
      await container.stop();
    },
  };
}

// A pool's end() resolves before its clients' sockets close. Stopping
// PostgreSQL while they close sends each one 57P01 («terminating connection
// due to administrator command»), an uncaught error in a pool without an
// error listener that fails the whole test run. So the stop waits, up to 5
// seconds, until no other client is connected.
async function closedConnections(adminUrl: string): Promise<void> {
  const admin = new pg.Client({ connectionString: adminUrl });
  await admin.connect();
  try {
    for (let attempt = 0; attempt < 50; attempt += 1) {
      const { rows } = await admin.query<{ connected: number }>(
        "SELECT count(*)::int AS connected FROM pg_stat_activity WHERE backend_type = 'client backend' AND pid <> pg_backend_pid()",
      );
      if (rows[0]!.connected === 0) return;
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
  } finally {
    // A client's end() resolves once its socket has closed.
    await admin.end();
  }
}
