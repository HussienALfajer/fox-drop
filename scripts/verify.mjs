// The single check command (architecture §18.4): TypeScript through Turborepo,
// then Dart through Melos. Stops at the first failing step.
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';

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

function warnOnFlutterMismatch() {
  const pinned = JSON.parse(readFileSync('.fvmrc', 'utf8')).flutter;
  const installed = JSON.parse(read('flutter --version --machine')).frameworkVersion;
  if (installed !== pinned) {
    console.warn(`\nverify: warning: Flutter ${installed} is installed, .fvmrc pins ${pinned}.`);
  }
}

step('Prettier', 'pnpm exec prettier --check .');
step('Lint, type check and test (Turborepo)', 'pnpm exec turbo run lint:root lint typecheck test');

warnOnFlutterMismatch();
step('Dart analyze', 'dart run melos run analyze --no-select');
step('Dart format', 'dart run melos run format:check --no-select');
if (dartPackagesWithTests('--no-flutter'))
  step('Dart tests', 'dart run melos run test:dart --no-select');
if (dartPackagesWithTests('--flutter'))
  step('Flutter tests', 'dart run melos run test:flutter --no-select');

console.log('\nverify: all checks passed');
