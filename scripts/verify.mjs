// The single check command (architecture §18.4): TypeScript through Turborepo,
// then Dart through Melos. Stops at the first failing step.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';

// `fvm install` links the Flutter pinned in .fvmrc at .fvm/flutter_sdk; use it
// before any Flutter on PATH. CI puts the pinned Flutter on PATH instead.
const fvmFlutter = path.resolve('.fvm', 'flutter_sdk', 'bin');
if (existsSync(fvmFlutter)) process.env.PATH = `${fvmFlutter}${path.delimiter}${process.env.PATH}`;

function run(command) {
  const result = spawnSync(command, { shell: true, stdio: 'inherit' });
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

function step(name, command) {
  console.log(`\n=== ${name}`);
  if (run(command) !== 0) fail(name);
}

// Dart packages that have a test folder, split by whether they need Flutter.
// The same filters as the test:dart and test:flutter scripts in pubspec.yaml.
function dartPackagesWithTests(flutterFlag) {
  return read(`dart run melos list --parsable --dir-exists=test ${flutterFlag}`).trim();
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

// Architecture §5.3, E6: the committed OpenAPI document and both clients must
// match the server. Regenerating changes no file when they do; otherwise the
// regenerated files are left in place to review and commit.
function contractFingerprint() {
  const hash = createHash('sha256');
  const files = read(
    'git ls-files --cached --others --exclude-standard -- packages/api-schema packages/core_api',
  )
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

function checkApiContract() {
  const before = contractFingerprint();
  step('Generate the API contract and clients', 'pnpm generate:api');
  if (contractFingerprint() === before) return;
  console.error(
    '\nThe committed OpenAPI document or a generated client was stale. It is regenerated' +
      ' now: review the changes in packages/api-schema and packages/core_api and commit them.' +
      ' A second run passes locally, but CI fails until they are committed.',
  );
  fail('API contract');
}

checkApiContract();
step('Prettier', 'pnpm exec prettier --check .');
step('Lint, type check and test (Turborepo)', 'pnpm exec turbo run lint:root lint typecheck test');

checkFlutterVersion();
checkDartWorkspace();
step('Dart analyze', 'dart run melos run analyze --no-select');
step('Dart format', 'dart run melos run format:check --no-select');
if (dartPackagesWithTests('--no-flutter'))
  step('Dart tests', 'dart run melos run test:dart --no-select');
if (dartPackagesWithTests('--flutter'))
  step('Flutter tests', 'dart run melos run test:flutter --no-select');

console.log('\nverify: all checks passed');
