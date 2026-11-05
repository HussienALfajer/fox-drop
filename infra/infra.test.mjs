// The deployment rules a machine can check (architecture §15.5, §17.2).
import assert from 'node:assert/strict';
import { readdirSync, readFileSync } from 'node:fs';
import { test } from 'node:test';
import { parse } from 'yaml';

const read = (path) => readFileSync(new URL(path, import.meta.url), 'utf8');
const compose = parse(read('compose.yaml'), { merge: true });
const services = Object.entries(compose.services);

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
  ];
  for (const file of readdirSync(new URL('environments/', import.meta.url))) {
    const keys = read(`environments/${file}`)
      .split('\n')
      .filter((line) => /^[A-Z_]+=/.test(line))
      .map((line) => line.split('=')[0]);
    assert.deepEqual(keys.toSorted(), needed.toSorted(), file);
  }
});
