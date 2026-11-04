// Starts the server image once per role against a migrated PostGIS and checks
// that each role starts, that the api answers with Server-Time, and that each
// stops cleanly on SIGTERM. Usage: node apps/server/scripts/smoke-image.mjs <image>
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const image = process.argv[2];
if (!image) throw new Error('Usage: smoke-image.mjs <image>');

const docker = (...args) => execFileSync('docker', args, { encoding: 'utf8' }).trim();
const pause = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function waitForLog(container, text) {
  for (let attempt = 0; attempt < 60; attempt += 1) {
    const logs = docker('logs', container);
    if (logs.includes(text)) return logs;
    if (docker('inspect', '--format', '{{.State.Running}}', container) !== 'true') break;
    await pause(500);
  }
  throw new Error(`"${text}" never appeared:\n${docker('logs', container)}`);
}

// The database the roles connect to, bootstrapped as compose.yaml does it and
// migrated by the image itself, as a deploy does (architecture §17.3).
const serverDir = new URL('../', import.meta.url);
const postgisImage = /image: (postgis\/postgis:\S+)/.exec(
  readFileSync(new URL('../../compose.yaml', serverDir), 'utf8'),
)?.[1];
if (!postgisImage) throw new Error('compose.yaml has no postgis image');
const network = 'fox-drop-smoke';
const databaseUrl = (role, password) => `postgres://${role}:${password}@postgis:5432/fox_drop`;

async function startDatabase() {
  docker('network', 'create', network);
  docker(
    'run',
    '--detach',
    '--name',
    'fox-drop-smoke-postgis',
    '--network',
    network,
    '--network-alias',
    'postgis',
    '--env',
    'POSTGRES_DB=fox_drop',
    '--env',
    'POSTGRES_PASSWORD=smoke-postgres-password',
    '--env',
    'FOX_DROP_MIGRATOR_PASSWORD=smoke-migrator-password',
    '--env',
    'FOX_DROP_APP_PASSWORD=smoke-app-password',
    '--volume',
    `${fileURLToPath(new URL('db/init-development.sh', serverDir))}:/docker-entrypoint-initdb.d/20-fox-drop.sh:ro`,
    '--volume',
    `${fileURLToPath(new URL('db/bootstrap.sql', serverDir))}:/fox-drop/bootstrap.sql:ro`,
    postgisImage,
  );
  // The init scripts run on a server that listens on its socket only, so
  // TCP answers once the real server is up.
  for (let attempt = 0; attempt < 60; attempt += 1) {
    try {
      docker(
        'exec',
        'fox-drop-smoke-postgis',
        'pg_isready',
        '--username',
        'postgres',
        '--host',
        '127.0.0.1',
      );
      break;
    } catch {
      await pause(500);
    }
  }
  docker(
    'run',
    '--rm',
    '--network',
    network,
    '--env',
    `MIGRATION_DATABASE_URL=${databaseUrl('fox_drop_migrator', 'smoke-migrator-password')}`,
    image,
    'node',
    'dist/database/migrate-command.js',
  );
}

function stopDatabase() {
  try {
    docker('rm', '--force', '--volumes', 'fox-drop-smoke-postgis');
  } finally {
    docker('network', 'rm', network);
  }
}

async function checkRole(role) {
  const container = docker(
    'run',
    '--detach',
    '--network',
    network,
    '--env',
    `PROCESS_ROLE=${role}`,
    '--env',
    `DATABASE_URL=${databaseUrl('fox_drop_app', 'smoke-app-password')}`,
    '--publish',
    '127.0.0.1::3000',
    image,
  );
  try {
    await waitForLog(container, `"msg":"${role} started"`);
    if (role === 'api') {
      const port = docker('port', container, '3000/tcp').split(':').pop();
      const response = await fetch(`http://127.0.0.1:${port}/v1/unknown`);
      if (response.status !== 404 || !/^\d+$/.test(response.headers.get('server-time') ?? '')) {
        throw new Error(`api answered ${response.status} without a Server-Time header`);
      }
    }
    docker('stop', '--timeout', '10', container);
    const exitCode = docker('inspect', '--format', '{{.State.ExitCode}}', container);
    if (exitCode !== '0') throw new Error(`${role} exited with ${exitCode} on SIGTERM`);
    console.log(`${role}: started and stopped cleanly`);
  } finally {
    docker('rm', '--force', container);
  }
}

try {
  await startDatabase();
  for (const role of ['api', 'worker', 'dispatcher', 'otp-sender']) await checkRole(role);
} finally {
  stopDatabase();
}
