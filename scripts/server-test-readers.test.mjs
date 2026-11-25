import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import { describe, it } from 'node:test';

import { classify, READ_BY_SERVER_TESTS } from './classify-changes.mjs';
import {
  findServerTestReaders,
  SERVER_TESTS_READING,
  serverTestScope,
  testsReading,
} from './server-test-readers.mjs';

const tracked = () =>
  spawnSync('git', ['-c', 'core.quotePath=false', 'ls-files', 'apps/server'], { encoding: 'utf8' })
    .stdout.split(/\r?\n/)
    .filter(Boolean);

describe('the server tests that read files outside the server', () => {
  it('names every path READ_BY_SERVER_TESTS lists, and only those', () => {
    assert.deepEqual(Object.keys(SERVER_TESTS_READING).sort(), [...READ_BY_SERVER_TESTS].sort());
  });

  it('lists every test that reads one of them, through its helpers too', () => {
    const found = findServerTestReaders(tracked());
    for (const [entry, tests] of Object.entries(SERVER_TESTS_READING)) {
      if (tests === 'all') continue;
      assert.deepEqual(tests, found[entry], `${entry}: the tests that read it`);
      for (const test of tests) assert.ok(existsSync(`apps/server/${test}`), test);
    }
  });

  it('finds a reader by a path from its folder or the root, and through an import', () => {
    const files = {
      'apps/server/src/a/labels.test.ts':
        "readFileSync(new URL('../../../admin/src/locales/ar.json'))",
      'apps/server/src/b/helper.ts':
        "const config = new URL('infra/centrifugo/config.yaml', root);",
      'apps/server/src/b/uses-helper.test.ts': "import { start } from '../b/helper.js';",
      'apps/server/src/c/through.ts': "export * from '../b/helper.js';",
      'apps/server/src/c/deep.test.ts': "const m = await import('./through.js');",
      'apps/server/src/d/unrelated.test.ts': "const text = 'apps/admin/src/other.json';",
    };
    const found = findServerTestReaders(Object.keys(files), (file) => files[file]);
    assert.deepEqual(found['apps/admin/src/locales/**'], ['src/a/labels.test.ts']);
    assert.deepEqual(found['infra/**'], ['src/b/uses-helper.test.ts', 'src/c/deep.test.ts']);
    assert.deepEqual(found['compose.yaml'], []);
  });

  it('scopes the server tests to the changed modules, the readers of a file, or Vitest', () => {
    const isServerInput = (file) => classify([file]).server;
    const scope = (...files) => serverTestScope(files, 'abc', isServerInput);
    assert.equal(
      scope('apps/server/src/modules/geo/distance.ts', 'apps/server/src/modules/geo/geo.test.ts'),
      'src/modules/geo test/',
    );
    assert.equal(
      scope('apps/admin/src/locales/ar.json'),
      SERVER_TESTS_READING['apps/admin/src/locales/**'].join(' '),
    );
    assert.equal(
      scope('apps/server/src/modules/geo/distance.ts', 'apps/merchant-portal/src/locales/ar.json'),
      'src/modules/geo test/ src/modules/content/export-labels.test.ts',
    );
    assert.equal(scope('compose.yaml'), '');
    assert.equal(scope('apps/server/src/database/database.ts'), '--changed abc');
    assert.equal(scope('pnpm-lock.yaml', 'apps/admin/src/locales/ar.json'), '--changed abc');
    assert.equal(scope('apps/admin/src/App.tsx', 'apps/server/CLAUDE.md'), null);
  });

  it('runs the named tests, or all of them for a path every test reads', () => {
    const reading = {
      'apps/admin/src/locales/**': ['src/x.test.ts', 'src/y.test.ts'],
      'apps/merchant-portal/src/locales/**': ['src/y.test.ts'],
      'compose.yaml': 'all',
    };
    assert.deepEqual(
      testsReading(
        ['apps/admin/src/locales/ar.json', 'apps/merchant-portal/src/locales/ar.json'],
        reading,
      ),
      ['src/x.test.ts', 'src/y.test.ts'],
    );
    assert.equal(testsReading(['compose.yaml'], reading), null);
    assert.equal(testsReading(['apps/admin/src/App.tsx'], reading), null);
  });
});
