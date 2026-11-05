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
// migrated by the image itself, as a deploy does (architecture §17.3), and
// the Valkey the api reads its settings through.
const serverDir = new URL('../', import.meta.url);
const composeFile = readFileSync(new URL('../../compose.yaml', serverDir), 'utf8');
const postgisImage = /image: (postgis\/postgis:\S+)/.exec(composeFile)?.[1];
if (!postgisImage) throw new Error('compose.yaml has no postgis image');
const valkeyImage = /image: (valkey\/valkey:\S+)/.exec(composeFile)?.[1];
if (!valkeyImage) throw new Error('compose.yaml has no valkey image');
const network = 'fox-drop-smoke';
const databaseUrl = (role, password) => `postgres://${role}:${password}@postgis:5432/fox_drop`;

async function startDatabase() {
  docker('network', 'create', network);
  docker(
    'run',
    '--detach',
    '--name',
    'fox-drop-smoke-valkey',
    '--network',
    network,
    '--network-alias',
    'valkey',
    valkeyImage,
    'valkey-server',
    '--requirepass',
    'smoke-valkey-password',
  );
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
    `${fileURLToPath(new URL('db/init-container.sh', serverDir))}:/docker-entrypoint-initdb.d/20-fox-drop.sh:ro`,
    '--volume',
    `${fileURLToPath(new URL('db/bootstrap.sql', serverDir))}:/fox-drop/bootstrap.sql:ro`,
    postgisImage,
  );
  // The init scripts run on a server that listens on its socket only, so
  // TCP answers once the real server is up.
  let ready = false;
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
      ready = true;
      break;
    } catch {
      await pause(500);
    }
  }
  if (!ready)
    throw new Error(`PostGIS never started:
${docker('logs', 'fox-drop-smoke-postgis')}`);
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

// Runs after a failure too, so a step that never happened is not an error
// that would hide the real one.
function stopDatabase() {
  for (const args of [
    ['rm', '--force', '--volumes', 'fox-drop-smoke-postgis'],
    ['rm', '--force', 'fox-drop-smoke-valkey'],
    ['network', 'rm', network],
  ]) {
    try {
      docker(...args);
    } catch (error) {
      console.error(`docker ${args.join(' ')} failed: ${error.message}`);
    }
  }
}

async function checkRole(role) {
  const container = docker(
    'run',
    '--detach',
    // As infra/compose.yaml runs it: read-only, no capabilities, and the
    // environment's own user instead of the image's.
    '--read-only',
    '--tmpfs',
    '/tmp',
    '--cap-drop',
    'ALL',
    '--user',
    '12345:12345',
    '--network',
    network,
    '--env',
    `PROCESS_ROLE=${role}`,
    '--env',
    `DATABASE_URL=${databaseUrl('fox_drop_app', 'smoke-app-password')}`,
    '--env',
    'VALKEY_URL=redis://:smoke-valkey-password@valkey:6379',
    '--env',
    `IDENTITY_ENCRYPTION_KEY=${Buffer.alloc(32, 1).toString('base64')}`,
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
