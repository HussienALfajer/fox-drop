// Starts the web image as compose.yaml runs it (read-only, no capabilities)
// and checks both apps: a deep link answers index.html (browser history
// routing, architecture §17.2), the hashed build files are cached for a year,
// and a missing build file is a 404. Usage: node infra/web/smoke-image.mjs <image>
import { execFileSync } from 'node:child_process';

const image = process.argv[2];
if (!image) throw new Error('Usage: smoke-image.mjs <image>');

const docker = (...args) => execFileSync('docker', args, { encoding: 'utf8' }).trim();
const pause = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const container = 'fox-drop-web-smoke';
const apps = { admin: 18080, 'merchant-portal': 18081 };

async function get(url) {
  for (let attempt = 0; attempt < 40; attempt += 1) {
    try {
      return await fetch(url);
    } catch {
      await pause(250);
    }
  }
  throw new Error(`${url} never answered:\n${docker('logs', container)}`);
}

function expect(condition, message) {
  if (!condition) throw new Error(message);
}

docker(
  'run',
  '--detach',
  '--name',
  container,
  '--read-only',
  '--tmpfs',
  '/tmp',
  '--cap-drop',
  'ALL',
  '--publish',
  `127.0.0.1:${apps.admin}:8080`,
  '--publish',
  `127.0.0.1:${apps['merchant-portal']}:8081`,
  image,
);
try {
  for (const [app, port] of Object.entries(apps)) {
    const origin = `http://127.0.0.1:${port}`;

    const deepLink = await get(`${origin}/some/deep/link`);
    const html = await deepLink.text();
    expect(deepLink.status === 200, `${app}: a deep link answered ${deepLink.status}`);
    expect(html.includes('<div id="root">'), `${app}: a deep link is not index.html`);
    expect(deepLink.headers.get('cache-control') === 'no-cache', `${app}: index.html is cached`);

    const asset = /src="(\/assets\/[^"]+\.js)"/.exec(html)?.[1];
    expect(asset, `${app}: index.html loads no build file`);
    const assetResponse = await get(`${origin}${asset}`);
    expect(assetResponse.status === 200, `${app}: ${asset} answered ${assetResponse.status}`);
    expect(
      assetResponse.headers.get('cache-control')?.includes('immutable'),
      `${app}: ${asset} is not cached for a year`,
    );

    const missing = await get(`${origin}/assets/missing.js`);
    expect(missing.status === 404, `${app}: a missing build file answered ${missing.status}`);
    console.log(`${app}: ok`);
  }
} finally {
  docker('rm', '--force', container);
}
