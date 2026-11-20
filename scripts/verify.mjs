// The single check command (architecture §18.4): TypeScript through Turborepo,
// then Dart through Melos. Stops at the first failing step.
//
// `pnpm verify` runs every part. CI runs each part as its own job, in
// parallel: `node scripts/verify.mjs <part>...`, and `--shard=<i>/<n>` splits
// the server's tests (Vitest's shards) or the Flutter packages across jobs.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';

// `fvm install` links the Flutter pinned in .fvmrc at .fvm/flutter_sdk; use it
// before any Flutter on PATH. CI puts the pinned Flutter on PATH instead.
const fvmFlutter = path.resolve('.fvm', 'flutter_sdk', 'bin');
if (existsSync(fvmFlutter)) process.env.PATH = `${fvmFlutter}${path.delimiter}${process.env.PATH}`;

function run(command, cwd = '.') {
  const result = spawnSync(command, { shell: true, stdio: 'inherit', cwd });
  return result.status ?? 1;
}

function read(command) {
  const result = spawnSync(command, { shell: true, encoding: 'utf8' });
  if (result.status !== 0) {
    process.stderr.write(result.stdout + result.stderr);
    fail(command);
  }
  return result.stdout;
}

function fail(step) {
  console.error(`\nverify: failed at "${step}"`);
  process.exit(1);
}

function step(name, command, cwd = '.') {
  console.log(`\n=== ${name}`);
  if (run(command, cwd) !== 0) fail(name);
}

// Dart packages that have a test folder, split by whether they need Flutter.
// The same filters as the test:dart and test:flutter scripts in pubspec.yaml.
function dartPackagesWithTests(flutterFlag) {
  return read(`dart run melos list --parsable --dir-exists=test ${flutterFlag}`).trim();
}

// Seconds each Flutter package's tests took alone (2026-11-16), to balance
// the shards. Only the balance depends on it: a package not listed counts as
// UNLISTED_SECONDS and is tested all the same.
const FLUTTER_TEST_SECONDS = {
  captain: 91,
  customer: 45,
  merchant: 35,
  core_platform: 19,
  core_l10n: 18,
  core_auth: 16,
  core_push: 13,
  core_storage: 13,
  core_maps: 5,
};
const UNLISTED_SECONDS = 30;

// The Flutter packages with tests of shard `<index>/<count>`: the slowest
// first, each to the shard with the least so far. Every package lands in
// exactly one shard.
function flutterShard(spec) {
  const [index, count] = spec.split('/').map(Number);
  if (index < 1 || index > count) fail(`--shard=${spec}`);
  const names = read('dart run melos list --dir-exists=test --flutter')
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => /^[a-z][a-z0-9_]*$/.test(line));
  // Melos prints the names for people; the paths are its parsable list. A
  // shard never tests nothing silently because a name was not read.
  const paths = dartPackagesWithTests('--flutter').split(/\r?\n/).filter(Boolean);
  if (names.length === 0 || names.length !== paths.length) {
    console.error(`\nRead ${names.length} Flutter package names for ${paths.length} packages.`);
    fail('Flutter shards');
  }
  const seconds = (name) => FLUTTER_TEST_SECONDS[name] ?? UNLISTED_SECONDS;
  const shards = Array.from({ length: count }, () => ({ seconds: 0, names: [] }));
  for (const name of names.sort((a, b) => seconds(b) - seconds(a) || a.localeCompare(b))) {
    const lightest = shards.reduce((least, each) => (each.seconds < least.seconds ? each : least));
    lightest.names.push(name);
    lightest.seconds += seconds(name);
  }
  return shards[index - 1].names;
}

// A mismatch only warns locally, but fails in CI, which must run the pinned version.
function checkFlutterVersion() {
  const pinned = JSON.parse(readFileSync('.fvmrc', 'utf8')).flutter;
  const installed = JSON.parse(read('flutter --version --machine')).frameworkVersion;
  if (installed === pinned) return;
  const message = `Flutter ${installed} is installed, .fvmrc pins ${pinned}.`;
  if (process.env.CI) {
    console.error(`\n${message}`);
    fail('Flutter version');
  }
  console.warn(`\nverify: warning: ${message}`);
}

// Melos sees only the packages listed in the root pubspec.yaml `workspace:`,
// so a Dart package missing from that list would never be checked.
function checkDartWorkspace() {
  const normal = (dir) => {
    const resolved = path.resolve(dir);
    return process.platform === 'win32' ? resolved.toLowerCase() : resolved;
  };
  const listed = new Set(
    read('dart run melos list --parsable').split(/\r?\n/).filter(Boolean).map(normal),
  );
  const missing = ['apps', 'packages', 'tools']
    .filter((dir) => existsSync(dir))
    .flatMap((dir) => readdirSync(dir).map((name) => path.join(dir, name)))
    .filter((dir) => existsSync(path.join(dir, 'pubspec.yaml')) && !listed.has(normal(dir)));
  if (missing.length > 0) {
    console.error(`\nNot in the root pubspec.yaml workspace: ${missing.join(', ')}`);
    fail('Dart workspace');
  }
}

// A hash of the files under `paths`, to see whether a generator changed any.
function fingerprint(paths) {
  const hash = createHash('sha256');
  const files = read(`git ls-files --cached --others --exclude-standard -- ${paths}`)
    .split(/\r?\n/)
    .filter(Boolean)
    .sort();
  for (const file of new Set(files)) {
    hash.update(`${file}\n`);
    // Git stores LF (.gitattributes), so CRLF written on Windows is not a change.
    const content = existsSync(file) ? readFileSync(file, 'utf8') : 'deleted';
    hash.update(content.replaceAll('\r\n', '\n'));
  }
  return hash.digest('hex');
}

// Architecture §5.3, E6: the committed OpenAPI document and both clients must
// match the server. Regenerating changes no file when they do; otherwise the
// regenerated files are left in place to review and commit.
const contractPaths = 'packages/api-schema packages/core_api';

function checkApiContract() {
  const before = fingerprint(contractPaths);
  step('Generate the API contract and clients', 'pnpm generate:api');
  if (fingerprint(contractPaths) === before) return;
  console.error(
    '\nThe committed OpenAPI document or a generated client was stale. It is regenerated' +
      ' now: review the changes in packages/api-schema and packages/core_api and commit them.' +
      ' A second run passes locally, but CI fails until they are committed.',
  );
  fail('API contract');
}

// Architecture §11.2: the committed localizations must match the ARB files.
function checkLocalizations() {
  const before = fingerprint('packages/core_l10n/lib');
  step('Generate the Flutter localizations', 'flutter gen-l10n', 'packages/core_l10n');
  if (fingerprint('packages/core_l10n/lib') === before) return;
  console.error(
    '\nThe committed localizations in packages/core_l10n/lib/src/generated were stale.' +
      ' They are regenerated now: review and commit them.',
  );
  fail('Flutter localizations');
}

// Claude Code loads a folder's CLAUDE.md whenever it reads a file there and
// resends it every turn after (docs/claude-code-workflow.md): keep the
// instruction files small. What a feature does goes in docs/code instead.
const INSTRUCTION_LIMITS = [
  { test: (file) => file === 'CLAUDE.md', bytes: 10_240 },
  { test: (file) => file === 'TASKS.md', bytes: 8_192 },
  { test: (file) => file.endsWith('/CLAUDE.md'), bytes: 4_096 },
];

function checkInstructionSizes() {
  console.log('\n=== Instruction file sizes');
  const files = read(
    'git ls-files --cached --others --exclude-standard -- CLAUDE.md TASKS.md "*/CLAUDE.md"',
  )
    .split(/\r?\n/)
    .filter((file) => file && existsSync(file));
  const tooBig = files.flatMap((file) => {
    const limit = INSTRUCTION_LIMITS.find((each) => each.test(file));
    const bytes = readFileSync(file).length;
    return limit && bytes > limit.bytes ? [`${file}: ${bytes} bytes, at most ${limit.bytes}`] : [];
  });
  if (tooBig.length > 0) {
    console.error(
      `\n${tooBig.join('\n')}\nKeep only the rules for working in the folder; move what features do to docs/code/<folder path>.md.`,
    );
    fail('Instruction file sizes');
  }
}

const PARTS = ['contract', 'format', 'typescript', 'server', 'dart', 'flutter'];
const args = process.argv.slice(2);
const shard = args.find((arg) => arg.startsWith('--shard='))?.slice('--shard='.length);
const named = args.filter((arg) => arg !== `--shard=${shard}`);
const unknown = named.filter((arg) => !PARTS.includes(arg));
if (unknown.length > 0 || (shard !== undefined && !/^\d+\/\d+$/.test(shard))) {
  console.error(
    `verify: unknown argument ${[...unknown, ...(shard ? [`--shard=${shard}`] : [])].join(' ')}.` +
      ` Usage: node scripts/verify.mjs [${PARTS.join('|')}]... [--shard=<index>/<count>]`,
  );
  process.exit(1);
}
const parts = new Set(named.length > 0 ? named : PARTS);
// A shard of one part: with any other part it would cut that one too.
if (shard !== undefined && !(parts.size === 1 && (parts.has('server') || parts.has('flutter')))) {
  console.error('verify: --shard needs exactly one of the parts server and flutter.');
  process.exit(1);
}

if (parts.has('contract')) checkApiContract();
if (parts.has('format')) {
  checkInstructionSizes();
  step('Prettier', 'pnpm exec prettier --check .');
}

const turboTasks = 'lint:root lint typecheck build test:e2e';
if (parts.has('typescript')) {
  // The web apps' smoke tests run in Chromium; this downloads it once.
  step(
    'Playwright browser',
    // One app at a time: two installs at once race on the shared browser cache.
    'pnpm --workspace-concurrency=1 --filter @fox-drop/admin --filter @fox-drop/merchant-portal exec playwright install chromium',
  );
}
if (parts.has('typescript') && parts.has('server') && shard === undefined) {
  // One Turborepo run, so the server's tests overlap the rest.
  step(
    'Lint, type check, test, build and smoke test (Turborepo)',
    `pnpm exec turbo run ${turboTasks} test`,
  );
} else {
  if (parts.has('typescript')) {
    step('Lint, type check, build and smoke test (Turborepo)', `pnpm exec turbo run ${turboTasks}`);
    step(
      "Tests other than the server's (Turborepo)",
      'pnpm exec turbo run test --filter="!@fox-drop/server"',
    );
  }
  if (parts.has('server')) {
    step(
      `Server tests${shard ? `, shard ${shard}` : ''}`,
      `pnpm --filter @fox-drop/server test${shard ? ` --shard=${shard}` : ''}`,
    );
  }
}

if (parts.has('dart') || parts.has('flutter')) checkFlutterVersion();
if (parts.has('dart')) {
  checkDartWorkspace();
  checkLocalizations();
  step('Dart analyze', 'dart run melos run analyze --no-select');
  step('Dart format', 'dart run melos run format:check --no-select');
  if (dartPackagesWithTests('--no-flutter'))
    step('Dart tests', 'dart run melos run test:dart --no-select');
}
if (parts.has('flutter')) {
  if (shard === undefined) {
    if (dartPackagesWithTests('--flutter'))
      step('Flutter tests', 'dart run melos run test:flutter --no-select');
  } else {
    const packages = flutterShard(shard);
    if (packages.length === 0) {
      console.log(`\n=== Flutter tests, shard ${shard}: no package`);
    } else {
      // Melos scopes a script to the packages this variable names.
      process.env.MELOS_PACKAGES = packages.join(',');
      step(
        `Flutter tests, shard ${shard}: ${packages.join(', ')}`,
        'dart run melos run test:flutter --no-select',
      );
    }
  }
}

console.log(`\nverify: ${named.length > 0 ? [...parts].join(', ') : 'all checks'} passed`);
