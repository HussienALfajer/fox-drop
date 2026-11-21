// The single check command (architecture §18.4): TypeScript through Turborepo,
// then Dart through Melos. Stops at the first failing step.
//
// `pnpm verify` runs every part. CI runs each part as its own job, in
// parallel: `node scripts/verify.mjs <part>...`, and `--shard=<i>/<n>` splits
// the server's tests (Vitest's shards) or the Flutter packages across jobs.
// `node scripts/verify.mjs --changed` runs only what the change since
// origin/main can break: the checker's default.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';

import { changedFiles, classify } from './classify-changes.mjs';
import { gitDir, pinnedFlutterBin, releaseLock, takeLock } from './verify-support.mjs';

// One check at a time in a folder (docs/claude-code-workflow.md, phase 6): two
// at once share the Playwright ports and write packages/core_api together.
// The Stop hook, the checker and a manual run all come through here. Exit 3
// says another check is running.
const BUSY = 3;
const lockDir = gitDir();
if (!lockDir) {
  console.error('verify: run it inside the repository, with git 2.31 or later.');
  process.exit(1);
}
const lockFile = path.join(lockDir, 'verify.lock');
const lock = takeLock(lockFile, { command: process.argv.slice(2).join(' ') });
if (!lock.taken) {
  const { pid, command, started } = lock.holder ?? {};
  console.error(
    `verify: another check is running in this folder (process ${pid ?? '?'}, ` +
      `\`verify.mjs ${command ?? ''}\`, started ${started ?? '?'}). Wait for it to end, then run this one again.` +
      ` If no check is running, delete ${lockFile.replaceAll('\\', '/')}.`,
  );
  process.exit(BUSY);
}
process.on('exit', () => releaseLock(lockFile));
// Ctrl+C and a closed terminal release the lock too; a hard kill leaves it
// stale, and the next check takes it over (verify-support.mjs).
process.on('SIGINT', () => process.exit(130));
process.on('SIGHUP', () => process.exit(129));

// `fvm install` links the Flutter pinned in .fvmrc at .fvm/flutter_sdk; use it,
// or the main checkout's in a worktree, before any Flutter on PATH. CI puts the
// pinned Flutter on PATH instead.
const fvmFlutter = pinnedFlutterBin(path.resolve('.'));
if (fvmFlutter) process.env.PATH = `${fvmFlutter}${path.delimiter}${process.env.PATH}`;

function run(command, cwd = '.', env = process.env) {
  const result = spawnSync(command, { shell: true, stdio: 'inherit', cwd, env });
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

function step(name, command, cwd = '.', env = process.env) {
  console.log(`\n=== ${name}`);
  if (run(command, cwd, env) !== 0) fail(name);
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
// The names of the packages Melos lists for these filters (it prints names
// for people, paths with --parsable).
function packageNames(filters) {
  return read(`dart run melos list ${filters}`)
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => /^[a-z][a-z0-9_]*$/.test(line));
}

function flutterShard(spec) {
  const [index, count] = spec.split('/').map(Number);
  if (index < 1 || index > count) fail(`--shard=${spec}`);
  const names = packageNames('--dir-exists=test --flutter');
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
  const message =
    `Flutter ${installed} is installed, .fvmrc pins ${pinned}.` +
    (fvmFlutter
      ? ''
      : ' Run `fvm install` in the main checkout; a worktree uses its .fvm/flutter_sdk.');
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

const turboTasks = 'lint:root lint typecheck build test:e2e';
// The web apps' smoke tests run in Chromium; this downloads it once. One app
// at a time: two installs at once race on the shared browser cache.
const PLAYWRIGHT_INSTALL =
  'pnpm --workspace-concurrency=1 --filter @fox-drop/admin --filter @fox-drop/merchant-portal exec playwright install chromium';

// The Node tests of the Claude Code hooks and of the scripts here: a second each.
function scriptTests() {
  step(
    'Claude Code hooks and scripts',
    'node --test .claude/hooks/hooks.test.mjs scripts/classify-changes.test.mjs scripts/verify-support.test.mjs scripts/fonts.test.mjs',
  );
}

// `--changed` (docs/claude-code-workflow.md, phase 4): only what the change
// since origin/main can break, committed or not; `--changed=<ref>` compares
// with another commit (a branch stacked on another). CI runs everything and
// stays the gate.
function verifyChanged(since) {
  const base = read(`git merge-base ${since} HEAD`).trim();
  const files = changedFiles(base);
  console.log(`\n=== ${files.length} files changed since ${since} (${base.slice(0, 9)})`);
  if (files.length === 0) return;
  const touched = classify(files);
  console.log(
    Object.keys(touched)
      .filter((key) => touched[key])
      .join(', ') || 'Markdown only',
  );

  checkInstructionSizes();
  scriptTests();
  const present = files.filter((file) => existsSync(file)).map((file) => `"${file}"`);
  const prettierConfig = files.some((file) => /^\.prettier|^package\.json$/.test(file));
  // cmd.exe takes 8,191 characters at most: a longer list checks everything.
  if (prettierConfig || present.join(' ').length > 7_000)
    step('Prettier', 'pnpm exec prettier --check .');
  else if (present.length > 0)
    step(
      'Prettier, changed files',
      `pnpm exec prettier --check --ignore-unknown ${present.join(' ')}`,
    );

  if (touched.contract) checkApiContract();
  if (touched.typescript) {
    // The changed packages and every package that depends on one, committed or not.
    const affected = `--filter="...[${base}]"`;
    step('Playwright browser', PLAYWRIGHT_INSTALL);
    step(
      'Lint, type check, build and smoke test, affected packages (Turborepo)',
      `pnpm exec turbo run ${turboTasks} ${affected}`,
    );
    step(
      "Tests other than the server's, affected packages (Turborepo)",
      `pnpm exec turbo run test ${affected} --filter="!@fox-drop/server"`,
    );
  }
  if (touched.server) {
    // Every test that starts the app imports every module, so Vitest's
    // `--changed` runs two thirds of the files for a change to one module
    // (162 of 242, 170 s). A change inside modules runs those modules' tests;
    // anything else in the server, `--changed` with forceRerunTriggers.
    const server = files.filter((file) => file.startsWith('apps/server/'));
    const modules = new Set(
      server.map((file) => /^apps\/server\/(src\/modules\/[\w-]+)\//.exec(file)?.[1]),
    );
    const scope =
      server.length > 0 && !modules.has(undefined)
        ? [...modules, 'test/'].join(' ')
        : `--changed ${base}`;
    step(
      `Server tests: ${scope}`,
      `pnpm --filter @fox-drop/server exec vitest run ${scope} --passWithNoTests`,
    );
  }

  if (!touched.dartScope) return;
  checkFlutterVersion();
  checkDartWorkspace();
  if (files.some((file) => file.startsWith('packages/core_l10n/'))) checkLocalizations();
  // The changed Dart packages and the packages that depend on them, or all.
  // Melos's own --diff sees commits only, not the working tree.
  const changedPackages = new Set(
    files.flatMap((file) => {
      const dir = /^(apps|packages)\/[\w-]+/.exec(file)?.[0];
      const pubspec = dir && path.join(dir, 'pubspec.yaml');
      if (!pubspec || !existsSync(pubspec)) return [];
      return [/^name:\s*(\S+)/m.exec(readFileSync(pubspec, 'utf8'))[1]];
    }),
  );
  const which =
    touched.dartScope === 'all'
      ? ''
      : `${[...changedPackages].map((name) => `--scope=${name}`).join(' ')} --include-dependents`;
  const label = touched.dartScope === 'all' ? 'all packages' : 'changed packages';
  // One analyzer over the workspace takes no longer than over a few packages.
  step('Dart analyze', 'dart run melos run analyze --no-select');
  // Filters on `melos run` replace the script's own packageFilters, and
  // --include-dependents adds the dependents after the other filters, Flutter
  // apps under --no-flutter too: a scoped test:dart ran `dart test` in them.
  // So take the changed packages and their dependents that also pass the
  // script's filters, and name them in MELOS_PACKAGES, as the Flutter shards
  // do. Melos fails a script whose filters match no package: skip it then.
  const scoped = new Set(packageNames(which));
  const melos = (name, script, filters) => {
    const names = packageNames(filters).filter((each) => scoped.has(each));
    if (names.length === 0) return;
    step(`${name}, ${label}`, `dart run melos run ${script} --no-select`, '.', {
      ...process.env,
      MELOS_PACKAGES: names.join(','),
    });
  };
  melos('Dart format', 'format:check', '');
  melos('Dart tests', 'test:dart', '--dir-exists=test --no-flutter');
  melos('Flutter tests', 'test:flutter', '--dir-exists=test --flutter');
}

const PARTS = ['contract', 'format', 'typescript', 'server', 'dart', 'flutter'];
const args = process.argv.slice(2);
const changed = args.find((arg) => /^--changed(=[\w./^~-]+)?$/.test(arg));
if (changed) {
  if (args.length > 1) {
    console.error('verify: --changed takes no part or shard: it picks them from the change.');
    process.exit(1);
  }
  verifyChanged(changed.split('=')[1] ?? 'origin/main');
  console.log('\nverify: the checks of the change passed');
  process.exit(0);
}
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
  scriptTests();
  step('Prettier', 'pnpm exec prettier --check .');
}

if (parts.has('typescript')) step('Playwright browser', PLAYWRIGHT_INSTALL);
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
