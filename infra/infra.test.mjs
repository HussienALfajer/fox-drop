// The deployment rules a machine can check (architecture §15.5, §17.2).
import assert from 'node:assert/strict';
import { readdirSync, readFileSync } from 'node:fs';
import { test } from 'node:test';
import { parse } from 'yaml';
import { mapStyle } from './maps/style.mjs';

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
  // Browsers connect only from the panel's and the portal's origins.
  assert.equal(
    centrifugo.environment.CENTRIFUGO_CLIENT_ALLOWED_ORIGINS,
    'https://${ADMIN_HOST:?} https://${PORTAL_HOST:?}',
  );
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
    // The storage's website endpoint behind /maps/ (architecture §7.2).
    'MAPS_PORT',
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
  // The server's key reads and writes: the API signs and checks uploads and
  // signs the exports' downloads; the worker writes and removes the exports.
  // maps-publish writes the map to public-maps (§7.2).
  assert.deepEqual(holders('STORAGE_SECRET'), ['api', 'maps-publish', 'storage-setup', 'worker']);
  // The reader key: imgproxy.
  assert.deepEqual(holders('STORAGE_READER_SECRET'), ['imgproxy', 'storage-setup']);
  // The nightly copy's key reads private-docs: no container holds it; the
  // copy reads it from the environment file on the server (slice 2.34a).
  assert.deepEqual(holders('STORAGE_BACKUP_SECRET'), ['storage-setup']);
  assert.deepEqual(holders('GARAGE_ADMIN_TOKEN'), ['storage', 'storage-setup']);
});

test("nginx serves /media/ for exactly the files module's public folders", () => {
  const service = read('../apps/server/src/modules/files/files.service.ts');
  const folders = /const folders[^{]*\{([^}]*)\}/.exec(service)[1];
  const privatePurposes = /PRIVATE_PURPOSES[^=]*=\s*\[([^\]]*)\]/.exec(service)[1];
  const published = [...folders.matchAll(/(\w+): '([^']+)'/g)]
    .filter(([, purpose]) => !privatePurposes.includes(`'${purpose}'`))
    .map(([, , folder]) => folder)
    .sort();
  const served = /\/plain\/\(([^)]*)\)\//.exec(read('nginx/api.conf.template'))[1];
  assert.deepEqual(served.split('|').sort(), published);
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

test('the map style is the one maps/style.mjs writes, on our own storage only', () => {
  // Run `pnpm --filter @fox-drop/infra maps:style` after updating
  // @protomaps/basemaps (architecture §7.2).
  const style = JSON.parse(read('maps/style.json'));
  assert.deepEqual(style, mapStyle());
  // No outside host at run time: the source, the glyphs and the sprite are
  // under the environment's /maps/ (maps-publish fills {{MAPS_URL}}).
  const urls = [style.glyphs, style.sprite, ...Object.values(style.sources).map((s) => s.url)];
  for (const url of urls) {
    assert.match(url, /^(pmtiles:\/\/)?\{\{MAPS_URL\}\}\/\{\{BUILD\}\}\//, url);
  }
  // Arabic labels first (AP §4.7).
  assert.match(JSON.stringify(style.layers), /"name:ar"/);
});

test('the map covers the region OSRM routes over', () => {
  const region = (text) => /^region=(.*)$/m.exec(text)[1];
  assert.equal(region(read('maps/build.sh')), region(read('osrm/cut.sh')));
});

test('nginx serves /maps/ from public-maps only, for reads', () => {
  const maps = /^location \/maps\/ \{$([\s\S]*?)^\}$/m.exec(read('nginx/api.conf.template'))[1];
  assert.match(maps, /limit_except GET \{ deny all; \}/);
  assert.match(maps, /proxy_pass http:\/\/127\.0\.0\.1:\$\{MAPS_PORT\}\/;/);
  assert.match(maps, /proxy_set_header Host public-maps;/);
  // Its own rate limit, so the map never uses up the API's (limits.conf).
  assert.match(maps, /limit_req zone=foxdrop_\$\{FOXDROP_ENV\}_maps /);
  assert.match(read('nginx/limits.conf.template'), /zone=foxdrop_\$\{FOXDROP_ENV\}_maps:/);
  // The build downloads from outside: never on the environment's network.
  assert.deepEqual(compose.services['maps-build'].networks, ['maps-build']);
  assert.ok(compose.services.storage.ports.includes('127.0.0.1:${MAPS_PORT:?}:3902'));
  const development = parse(read('../compose.yaml'));
  assert.match(development.configs['maps-nginx'].content, /proxy_set_header Host public-maps;/);
  assert.match(read('storage/garage.toml'), /^\[s3_web\]$/m);
});

test("nginx serves the portal's Excel files for reads only, from private-docs' exports/", () => {
  const site = read('nginx/site.conf.template');
  const portal = /server_name \$\{PORTAL_HOST\};([\s\S]*?)\n\}\n/.exec(site)[1];
  const exports = /location \/private-docs\/exports\/ \{([\s\S]*?)\n {4}\}/.exec(portal)[1];
  assert.match(exports, /limit_except GET \{ deny all; \}/);
  assert.match(exports, /proxy_pass http:\/\/127\.0\.0\.1:\$\{STORAGE_PORT\};/);
  assert.match(exports, /proxy_set_header Cookie "";/);
});

test("nginx serves the Windows downloads for reads only, from the publish script's folder", () => {
  const downloads = /^location \/downloads\/windows\/ \{$([\s\S]*?)^\}$/m.exec(
    read('nginx/api.conf.template'),
  )[1];
  assert.match(downloads, /limit_except GET \{ deny all; \}/);
  assert.match(downloads, /alias \/var\/www\/foxdrop-\$\{FOXDROP_ENV\}-downloads\/windows\/;/);
  const publish = read('server/windows-publish.sh');
  assert.match(publish, /^target=\/var\/www\/foxdrop-\$environment-downloads\/windows$/m);
  // The deploy key reaches it with one exact request, through its own sudo rule.
  const ssh = read('server/deploy-ssh.sh');
  assert.match(ssh, /\^\(staging\)\\ windows\$/);
  assert.match(
    read('server/provision.sh'),
    /NOPASSWD: \/usr\/local\/bin\/foxdrop-windows-publish staging" >>"\$sudoers"/,
  );
  // A PC's registration is limited like a code request.
  assert.match(
    read('nginx/api.conf.template'),
    /auth\/\(sign-in\|code\|setup\/\|windows-registration\|portal\/\(sign-in\|code\)\)/,
  );
});
