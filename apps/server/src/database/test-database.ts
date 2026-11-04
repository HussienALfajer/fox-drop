import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { PostgreSqlContainer } from '@testcontainers/postgresql';
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
  const roleUrl = (role: string, password: string) =>
    `postgres://${role}:${password}@${container.getHost()}:${container.getPort()}/fox_drop`;
  const migratorUrl = roleUrl('fox_drop_migrator', passwords.migrator);
  await runMigrations(migratorUrl);
  return {
    migratorUrl,
    appUrl: roleUrl('fox_drop_app', passwords.app),
    stop: async () => {
      await container.stop();
    },
  };
}
