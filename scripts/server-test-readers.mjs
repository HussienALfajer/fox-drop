// Which of the server's tests read each path outside apps/server that
// READ_BY_SERVER_TESTS lists (scripts/classify-changes.mjs). Vitest's module
// graph cannot see a file read from disk, so `--changed` used to run all 248
// test files for a change of one locale file; `node scripts/verify.mjs
// --changed` runs only the tests named here when the change of the server's
// inputs is only such files. `all` is a path every database test reads (the
// helpers start their containers from compose.yaml). A test that reads one of
// these paths and is missing here fails server-test-readers.test.mjs, which
// finds the readers with `findServerTestReaders`.
import { readFileSync } from 'node:fs';
import path from 'node:path';

import { READ_BY_SERVER_TESTS } from './classify-changes.mjs';

export const SERVER_TESTS_READING = {
  'docs/product/v1/admin-panel/appendix-a-settings-catalogue.md': [
    'src/modules/settings/catalogue.test.ts',
  ],
  'compose.yaml': 'all',
  // The Centrifugo and Garage configuration the test containers start with.
  'infra/**': [
    'src/modules/captains/application-pipeline.test.ts',
    'src/modules/captains/captain-activation.test.ts',
    'src/modules/captains/captain-application.test.ts',
    'src/modules/captains/captain-offboarding.test.ts',
    'src/modules/content/category-image.test.ts',
    'src/modules/files/files.test.ts',
    'src/modules/merchants/change-request-photos.test.ts',
    'src/modules/merchants/menu-import-route.test.ts',
    'src/modules/merchants/restaurant-images.test.ts',
    'src/modules/notifications/alerts-relay.test.ts',
    'src/modules/notifications/platform-relay.test.ts',
    'src/modules/notifications/receiving-sweep.test.ts',
    'src/modules/ordering/customer-reports.test.ts',
    'src/modules/ordering/order-realtime.test.ts',
    'src/modules/ordering/outbox-relay.test.ts',
    'src/modules/reporting/exports.test.ts',
    'src/modules/reporting/merchant-exports.test.ts',
    'src/storage/maps-publish.test.ts',
    'src/storage/storage-setup.test.ts',
  ],
  'apps/admin/src/locales/**': [
    'src/modules/content/export-labels.test.ts',
    'src/modules/content/notification-templates.test.ts',
    'src/modules/identity/permission-labels.test.ts',
    'src/modules/settings/panel-labels.test.ts',
  ],
  'apps/merchant-portal/src/locales/**': ['src/modules/content/export-labels.test.ts'],
};

const SERVER = 'apps/server';

/** Whether a repository path is `entry` or under it (an entry ending in /** is a folder). */
export function underEntry(file, entry) {
  return entry.endsWith('/**') ? file.startsWith(entry.slice(0, -2)) : file === entry;
}

/**
 * The server's test files (relative to apps/server) to run for a change of
 * `files`, all of them paths outside the server that READ_BY_SERVER_TESTS
 * lists: the names, or null when one of the paths is read by every test.
 */
export function testsReading(files, reading = SERVER_TESTS_READING) {
  const tests = new Set();
  for (const file of files) {
    const entries = Object.keys(reading).filter((entry) => underEntry(file, entry));
    if (entries.length === 0) return null;
    for (const entry of entries) {
      if (reading[entry] === 'all') return null;
      for (const test of reading[entry]) tests.add(test);
    }
  }
  return [...tests].sort();
}

/**
 * What Vitest runs for the server's part of a change since `base`: the
 * arguments after `vitest run`, '' for every test, or null when no server test
 * can see the change. `isServerInput(file)` says whether a path sets the
 * server's tests (classify-changes.mjs). Every test that starts the app imports
 * every module, so Vitest's own `--changed` runs two thirds of the files for a
 * change to one module (162 of 242, 170 s): a change inside modules runs those
 * modules' tests and test/; a path outside the server that tests read from
 * disk runs the tests SERVER_TESTS_READING names; anything else, Vitest's
 * `--changed` with its forceRerunTriggers.
 */
export function serverTestScope(files, base, isServerInput, reading = SERVER_TESTS_READING) {
  const inputs = files.filter(isServerInput);
  if (inputs.length === 0) return null;
  const own = inputs.filter((file) => file.startsWith(`${SERVER}/`));
  const outside = inputs.filter((file) => !file.startsWith(`${SERVER}/`));
  if (!outside.every((file) => READ_BY_SERVER_TESTS.some((entry) => underEntry(file, entry))))
    return `--changed ${base}`;
  const modules = new Set(
    own.map((file) => /^apps\/server\/(src\/modules\/[\w-]+)\//.exec(file)?.[1]),
  );
  if (modules.has(undefined)) return `--changed ${base}`;
  const readers = testsReading(outside, reading);
  if (readers === null) return '';
  const scope = [...[...modules].sort(), ...(modules.size > 0 ? ['test/'] : []), ...readers];
  return scope.length > 0 ? scope.join(' ') : null;
}

// A quoted string without interpolation: a path a file may read.
const LITERAL = /'([^'\\\n]+)'|"([^"\\\n]+)"|`([^`$\\\n]+)`/g;
const RELATIVE_IMPORT = /\bfrom\s+'(\.{1,2}\/[^']+)'|\bimport\(\s*'(\.{1,2}\/[^']+)'\s*\)/g;
const TEST = /\.test\.ts$/;

/**
 * The repository paths a quoted string in `file` (a repository path) may name:
 * the string taken from the file's folder and from each folder above it, up to
 * the root. Over-approximated on purpose: a needless test run is fine, a
 * missed reader is not.
 */
function candidates(file, literal) {
  const out = new Set();
  let dir = path.posix.dirname(file);
  for (;;) {
    const joined = path.posix.normalize(dir === '.' ? literal : `${dir}/${literal}`);
    if (!joined.startsWith('../') && joined !== '..') out.add(joined.replace(/\/$/, ''));
    if (dir === '.') break;
    dir = path.posix.dirname(dir);
  }
  return out;
}

/**
 * For each READ_BY_SERVER_TESTS entry, the server's test files that read it:
 * the test files whose own strings name a path under it, and every test file
 * that imports (directly or through other files) a server file that does.
 * `files` are the server's tracked TypeScript files, repository paths.
 */
export function findServerTestReaders(files, read = (file) => readFileSync(file, 'utf8')) {
  const sources = files.filter((file) => file.startsWith(`${SERVER}/`) && file.endsWith('.ts'));
  const known = new Set(sources);
  const importers = new Map(sources.map((file) => [file, new Set()]));
  const texts = new Map(sources.map((file) => [file, read(file)]));
  for (const [file, text] of texts) {
    for (const match of text.matchAll(RELATIVE_IMPORT)) {
      const target = path.posix
        .normalize(`${path.posix.dirname(file)}/${match[1] ?? match[2]}`)
        .replace(/\.js$/, '.ts');
      if (known.has(target)) importers.get(target).add(file);
    }
  }
  const testsReaching = (file) => {
    const seen = new Set([file]);
    const queue = [file];
    while (queue.length > 0)
      for (const each of importers.get(queue.shift())) {
        if (!seen.has(each)) {
          seen.add(each);
          queue.push(each);
        }
      }
    return [...seen].filter((each) => TEST.test(each));
  };
  const readers = Object.fromEntries(READ_BY_SERVER_TESTS.map((entry) => [entry, new Set()]));
  for (const [file, text] of texts) {
    const named = new Set();
    for (const match of text.matchAll(LITERAL)) {
      for (const candidate of candidates(file, match[1] ?? match[2] ?? match[3]))
        for (const entry of READ_BY_SERVER_TESTS)
          if (underEntry(candidate, entry)) named.add(entry);
    }
    if (named.size === 0) continue;
    const tests = testsReaching(file).map((test) => test.slice(SERVER.length + 1));
    for (const entry of named) for (const test of tests) readers[entry].add(test);
  }
  return Object.fromEntries(
    Object.entries(readers).map(([entry, tests]) => [entry, [...tests].sort()]),
  );
}
