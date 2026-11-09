// The deployment rules a machine can check (architecture §15.5, §17.2).
import assert from 'node:assert/strict';
import { readdirSync, readFileSync } from 'node:fs';
import { test } from 'node:test';
import { parse } from 'yaml';

const read = (path) => readFileSync(new URL(path, import.meta.url), 'utf8');
const compose = parse(read('compose.yaml'), { merge: true });
const osrm = parse(read('osrm/compose.yaml'), { merge: true });
const services = [compose, osrm].flatMap((file) => Object.entries(file.services));

test('every published port listens on 127.0.0.1 only', () => {
  // Docker bypasses the host firewall: a port on 0.0.0.0 is public.
  for (const [name, service] of services) {
    for (const port of service.ports ?? []) {
      assert.match(String(port), /^127\.0\.0\.1:/, `${name} publishes ${port}`);
    }
  }
});

test('every container has a memory limit', () => {
  // The server is shared with other sites (architecture §22 item 10).
  for (const [name, service] of services) {
    assert.ok(service.mem_limit, `${name} has no mem_limit`);
  }
});

test('the database image is the one development and the tests use', () => {
  const development = parse(read('../compose.yaml'));
  assert.equal(compose.services.postgres.image, development.services.postgres.image);
});

test('OSRM runs the image development uses, for every vehicle', () => {
  const development = parse(read('../compose.yaml'), { merge: true });
  const routed = ['osrm-car', 'osrm-motorbike', 'osrm-bicycle', 'osrm-walking'];
  for (const name of [...routed, 'build']) {
    assert.equal(osrm.services[name].image, development.services['osrm-car'].image, name);
  }
  // The server's OSRM_<VEHICLE>_URL names a routed service, which joins
  // every environment's own network to OSRM (§17.2: staging never reaches
  // production's containers).
  const environment = compose['x-server-environment'];
  const environments = readdirSync(new URL('environments/', import.meta.url)).map((file) =>
    file.replace(/\.env$/, ''),
  );
  for (const name of routed) {
    const vehicle = name.replace('osrm-', '').toUpperCase();
    assert.equal(environment[`OSRM_${vehicle}_URL`], `http://${name}:5000`);
    assert.deepEqual(osrm.services[name].networks.toSorted(), environments.toSorted(), name);
  }
  for (const env of environments) {
    assert.deepEqual(osrm.networks[env], { name: `foxdrop-osrm-${env}`, external: true });
  }
  // Frozen: Compose refuses an existing network whose declaration changed.
  assert.deepEqual(compose.networks.osrm, { name: 'foxdrop-osrm-${FOXDROP_ENV:?}' });
});

test("Centrifugo runs development's image and calls this environment's API", () => {
  const development = parse(read('../compose.yaml'), { merge: true });
  const centrifugo = compose.services.centrifugo;
  assert.equal(centrifugo.image, development.services.centrifugo.image);
  // The proxies reach the API on the environment's own network, and the
  // server publishes to this Centrifugo (§6.1).
  const proxies = JSON.parse(centrifugo.environment.CENTRIFUGO_PROXIES);
  assert.deepEqual(
    proxies.map((proxy) => [proxy.name, proxy.endpoint]),
    [
      ['merchant', 'http://api:3000/v1/merchant/realtime/subscribe'],
      ['customer', 'http://api:3000/v1/customer/realtime/subscribe'],
      ['captain', 'http://api:3000/v1/captain/realtime/subscribe'],
      ['admin', 'http://api:3000/v1/admin/realtime/subscribe'],
    ],
  );
  // Browsers connect only from the panel's origin.
  assert.equal(centrifugo.environment.CENTRIFUGO_CLIENT_ALLOWED_ORIGINS, 'https://${ADMIN_HOST:?}');
  // Only the API and the worker get its settings, and only the API the
  // token and proxy secrets.
  const realtime = (name) =>
    Object.keys(compose.services[name].environment)
      .filter((key) => key.startsWith('CENTRIFUGO_'))
      .toSorted();
  assert.deepEqual(realtime('api'), [
    'CENTRIFUGO_API_KEY',
    'CENTRIFUGO_API_URL',
    'CENTRIFUGO_PROXY_SECRET',
    'CENTRIFUGO_TOKEN_SECRET',
  ]);
  assert.deepEqual(realtime('worker'), ['CENTRIFUGO_API_KEY', 'CENTRIFUGO_API_URL']);
  for (const name of ['dispatcher', 'otp-sender']) assert.deepEqual(realtime(name), []);
  assert.equal(compose.services.api.environment.CENTRIFUGO_API_URL, 'http://centrifugo:8000/api');
});

test('nginx replaces X-Forwarded-For with the address it sees', () => {
  // The API trusts exactly one hop; appending would let a client pick its address.
  for (const file of readdirSync(new URL('nginx/', import.meta.url))) {
    const directives = read(`nginx/${file}`).replace(/#.*$/gm, '');
    assert.doesNotMatch(directives, /\$proxy_add_x_forwarded_for/, file);
  }
  assert.match(read('nginx/proxy.conf'), /^proxy_set_header X-Forwarded-For \$remote_addr;$/m);
});

test('every environment names the settings compose.yaml and nginx need', () => {
  const needed = [
    'FOXDROP_ENV',
    'ADMIN_HOST',
    'PORTAL_HOST',
    'API_HOST',
    'API_PORT',
    'ADMIN_PORT',
    'PORTAL_PORT',
    'CENTRIFUGO_PORT',
    // The object storage and imgproxy, behind nginx (architecture §5.8).
    'STORAGE_PORT',
    'IMGPROXY_PORT',
    // The otp-sender's reply (architecture §8.3.3 item 9); may be empty.
    'SUPPORT_WHATSAPP_NUMBER',
    // The apps' support call button (AP §9.13 contact info); may be empty.
    'SUPPORT_PHONE_NUMBER',
    // App Check (architecture §8.3.3 item 1); may be empty.
    'FIREBASE_PROJECT_NUMBER',
    // The staging APKs' Firebase project (the deploy skill); may be empty.
    'FIREBASE_PROJECT_ID',
  ];
  for (const file of readdirSync(new URL('environments/', import.meta.url))) {
    const keys = read(`environments/${file}`)
      .split('\n')
      .filter((line) => /^[A-Z_]+=/.test(line))
      .map((line) => line.split('=')[0]);
    assert.deepEqual(keys.toSorted(), needed.toSorted(), file);
  }
});

test("the storage and imgproxy run development's images and configuration", () => {
  const development = parse(read('../compose.yaml'), { merge: true });
  for (const name of ['storage', 'imgproxy']) {
    assert.equal(compose.services[name].image, development.services[name].image, name);
  }
  assert.ok(compose.services.storage.volumes.includes('./storage/garage.toml:/etc/garage.toml:ro'));
  assert.ok(
    development.services.storage.volumes.includes(
      './infra/storage/garage.toml:/etc/garage.toml:ro',
    ),
  );
  assert.equal(compose.services.imgproxy.env_file, './imgproxy/imgproxy.env');
  assert.equal(development.services.imgproxy.env_file, 'infra/imgproxy/imgproxy.env');
});

test("the storage's keys reach only the processes that use them (§15)", () => {
  const holders = (variable) =>
    Object.entries(compose.services)
      .filter(([, service]) =>
        Object.values(service.environment ?? {}).some((value) =>
          String(value).includes(`\${${variable}:`),
        ),
      )
      .map(([name]) => name)
      .toSorted();
  // The server's key reads and writes: the API signs and checks uploads.
  assert.deepEqual(holders('STORAGE_SECRET'), ['api', 'storage-setup']);
  // The reader key: imgproxy (the nightly copy reads the file on the server).
  assert.deepEqual(holders('STORAGE_READER_SECRET'), ['imgproxy', 'storage-setup']);
  assert.deepEqual(holders('GARAGE_ADMIN_TOKEN'), ['storage', 'storage-setup']);
});

test("imgproxy's widths are the ones the panel and the customer app ask for", () => {
  const presets = /^IMGPROXY_PRESETS=(.*)$/m.exec(read('imgproxy/imgproxy.env'))[1];
  const widths = presets.split(',').map((preset) => {
    const [name, options] = preset.split('=');
    const width = Number(/width:(\d+)/.exec(options)[1]);
    assert.equal(name, `w${width}`);
    return width;
  });
  const list = (text) => JSON.parse(`[${/\[(\d+(?:, \d+)*)\]/.exec(text)[1]}]`);
  assert.deepEqual(list(read('../apps/admin/src/media.ts')), widths);
  assert.deepEqual(list(read('../apps/customer/lib/src/media.dart')), widths);
});
