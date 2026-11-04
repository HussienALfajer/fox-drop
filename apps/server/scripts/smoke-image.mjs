// Starts the server image once per role and checks that each role starts,
// that the api answers with Server-Time, and that each stops cleanly on
// SIGTERM. Usage: node apps/server/scripts/smoke-image.mjs <image>
import { execFileSync } from 'node:child_process';

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

async function checkRole(role) {
  const container = docker(
    'run',
    '--detach',
    '--env',
    `PROCESS_ROLE=${role}`,
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

for (const role of ['api', 'worker', 'dispatcher', 'otp-sender']) await checkRole(role);
