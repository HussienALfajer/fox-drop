// What a change touches, from its paths. CI's `changes` job and `node scripts/verify.mjs --changed`
// both use it, so the two never disagree about what a path sets.
//
//   node scripts/classify-changes.mjs <base> [--push]
//     prints code=…, dart=…, native=…, build=…, the jobs
//     typescript=…, server=…, contract=… (ciJobs; --push: main, every job
//     `code` runs) and hand_written=<count> (with a base) for $GITHUB_OUTPUT
import { spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

// The spec files a test reads: the only Markdown that counts as code. A change
// to one of them runs that test, which a module graph cannot see;
// apps/server/vitest.config.ts lists them as forceRerunTriggers. A test that
// reads a spec file missing here fails classify-changes.test.mjs.
export const SPEC_FILES_READ_BY_TESTS = [
  'docs/product/v1/admin-panel/appendix-a-settings-catalogue.md',
];

// Everything outside apps/server that the server's tests read from disk: the
// specs above, the services' configuration they start, the web apps' labels.
// A path ending in /** is a folder. Also forceRerunTriggers.
export const READ_BY_SERVER_TESTS = [
  ...SPEC_FILES_READ_BY_TESTS,
  'compose.yaml',
  'infra/**',
  'apps/admin/src/locales/**',
  'apps/merchant-portal/src/locales/**',
];

const readByServerTests = (file) =>
  READ_BY_SERVER_TESTS.some((each) =>
    each.endsWith('/**') ? file.startsWith(each.slice(0, -2)) : file === each,
  );

// The Dart packages with native code of their own (a plugin's android/, ios/
// or windows/ folder), checked by classify-changes.test.mjs.
export const NATIVE_PACKAGES = ['packages/core_alerts'];

const DOCS = /(.*\.md$|^docs\/)/;
// CI runs the Dart jobs for its workflow and for the check engine: verify.mjs
// and every script it runs or imports.
const DART =
  /(\.dart$|\.arb$|(^|\/)(pubspec\.(yaml|lock)|analysis_options\.yaml|l10n\.yaml|dart_test\.yaml)$|^(apps\/(customer|captain|merchant)|packages\/core_[a-z0-9_]+)\/|^\.fvmrc$|^\.github\/workflows\/ci\.yml$|^scripts\/(verify(-support|-watchdog)?|classify-changes|green-tree|server-test-readers|outside-reads)\.mjs$)/;
// What can break a native release build that the Dart tests cannot see: a
// native project, a resolved dependency (the lock file), a package with
// native code, the pinned Flutter. A pubspec.yaml whose change leaves the
// lock file alone resolves the same packages, and a change to the native
// jobs of ci.yml takes the native-builds label (owner decision 2026-11-23:
// 9 of 20 native runs were one of these two). Main builds Android only
// (staging-apks), so iOS and Windows have no later catch-all.
const NATIVE =
  /(^apps\/(customer|captain|merchant)\/(android|ios|windows|macos|linux)\/|(^|\/)pubspec\.lock$|^\.fvmrc$)/;
const nativePackage = (file) => NATIVE_PACKAGES.some((each) => file.startsWith(`${each}/`));
// Only Dart and Flutter look at these; everything else counts for TypeScript.
const DART_ONLY =
  /(\.dart$|\.arb$|(^|\/)(pubspec\.(yaml|lock)|analysis_options\.yaml|l10n\.yaml|dart_test\.yaml)$|^(apps\/(customer|captain|merchant)|packages\/core_[a-z0-9_]+)\/|^\.fvmrc$)/;
// What the OpenAPI document and both clients are generated from, besides the
// server files that declare a schema (see `declaresSchema`).
const CONTRACT =
  /^(scripts\/generate-api\.mjs|openapitools\.json|apps\/server\/scripts\/write-openapi\.mjs|apps\/server\/src\/http\/|packages\/(api-schema|core_api)\/)|^apps\/server\/src\/.*\.controller\.ts$/;
const SERVER_SOURCE = /^apps\/server\/src\/.*\.ts$/;
// The check engine: CI's workflow, Turborepo's task graph, verify.mjs and the
// scripts it runs or imports. A change to one runs every CI job (ciJobs).
export const CHECK_ENGINE =
  /^(\.github\/workflows\/ci\.yml|turbo\.json|scripts\/(verify(-support|-watchdog)?|classify-changes|green-tree|server-test-readers|outside-reads)\.mjs)$/;

// The files outside a package that a package's Turborepo task reads, from
// turbo.json (`$TURBO_ROOT$/…`, which turbo-inputs.test.mjs keeps complete):
// `name` is the package, or null for a task every package runs. Turborepo's
// `...[base]` filter cannot see a change to one, so turboScope names them.
// Its globalDependencies count for every package.
const TURBO = JSON.parse(
  readFileSync(fileURLToPath(new URL('../turbo.json', import.meta.url)), 'utf8'),
);
export const TURBO_ROOT_INPUTS = [
  ...(TURBO.globalDependencies ?? []).map((glob) => ({ name: null, glob })),
  ...Object.entries(TURBO.tasks).flatMap(([task, { inputs = [] }]) =>
    inputs
      .filter((input) => input.startsWith('$TURBO_ROOT$/'))
      .map((input) => ({
        name: task.includes('#') && !task.startsWith('//#') ? task.split('#')[0] : null,
        glob: input.slice('$TURBO_ROOT$/'.length),
      })),
  ),
];
const readByTurboTask = (file) =>
  TURBO_ROOT_INPUTS.filter((each) => path.posix.matchesGlob(file, each.glob));
// The files nobody writes by hand, left out of the pull request size notice
// (CI's `changes` job): what a generator writes, the same list as the edit
// guard's (.claude/hooks/lib/policy.mjs, GENERATED; classify-changes.test.mjs
// keeps the two in step), then images, fonts and test snapshots.
export const NOT_HAND_WRITTEN = [
  /(^|\/)generated\//i,
  /^packages\/core_api\/lib\//i,
  /^packages\/api-schema\/openapi\.json$/i,
  /^packages\/api-schema\/src\/schema\.ts$/i,
  /(^|\/)pnpm-lock\.yaml$/i,
  /(^|\/)pubspec\.lock$/i,
  /\.g\.dart$/i,
  /\.freezed\.dart$/i,
  /\.mocks\.dart$/i,
  /(^|\/)migrations\/meta\/[^/]+\.json$/i,
  /\.(png|jpe?g|gif|webp|ico|svg|ttf|otf|woff2?)$/i,
  /(^|\/)__snapshots__\/|\.snap$/i,
];

/** The changed `files` written by hand (not in NOT_HAND_WRITTEN). */
export const handWritten = (files) =>
  files.filter((file) => !NOT_HAND_WRITTEN.some((pattern) => pattern.test(file)));

/**
 * What the changed `files` (repository-relative, forward slashes) set.
 * `read(file)` returns a file's text, or null when it was deleted.
 * - code, dart, native, build: CI's jobs: the checks, the Dart checks, the
 *   native release builds of a pull request, the images and the staging
 *   builds and deploy.
 * - typescript: Turborepo's affected packages (turboScope says which); server:
 *   the server's tests; contract: regenerate the API contract; dartScope:
 *   null, 'changed' or 'all'. ciJobs turns the first three into CI's jobs.
 */
export function classify(files, read = readText) {
  const specRead = files.some((file) => SPEC_FILES_READ_BY_TESTS.includes(file));
  const build = files.some((file) => !DOCS.test(file));
  const code = build || specRead;
  const dart = files.some((file) => !DOCS.test(file) && DART.test(file));
  const native = files.some(
    (file) => !DOCS.test(file) && (NATIVE.test(file) || nativePackage(file)),
  );
  // A Dart file a TypeScript task reads (turbo.json) counts too.
  const typescript =
    specRead ||
    files.some(
      (file) => (!DOCS.test(file) && !DART_ONLY.test(file)) || readByTurboTask(file).length > 0,
    );
  const server = files.some(
    (file) =>
      readByServerTests(file) ||
      (file.startsWith('apps/server/') && !DOCS.test(file)) ||
      /^(package\.json|pnpm-lock\.yaml|pnpm-workspace\.yaml|\.npmrc|\.node-version|tsconfig[\w.]*\.json)$/.test(
        file,
      ),
  );
  const contract = files.some(
    (file) =>
      CONTRACT.test(file) ||
      (SERVER_SOURCE.test(file) && !file.endsWith('.test.ts') && declaresSchema(read(file))),
  );
  return {
    code,
    dart,
    native,
    build,
    typescript,
    server,
    contract,
    dartScope: dartScope(files),
  };
}

/**
 * Which of CI's TypeScript, server and contract jobs run for the changed
 * `files`, from their classification `touched`. On main (`push`) and for a
 * change to the check engine, every one that `code` runs, as before; on a pull
 * request only those the change can break. The contract job runs for every
 * server change: a schema can read a constant from a file that never imports
 * zod, which `contract` alone (the fast local check) cannot see. It runs too
 * for what the Dart client is formatted and built with (dartScope 'all').
 */
export function ciJobs(files, touched, { push = false } = {}) {
  if (push || files.some((file) => CHECK_ENGINE.test(file)))
    return { typescript: touched.code, server: touched.code, contract: touched.code };
  return {
    typescript: touched.typescript,
    server: touched.server,
    contract: touched.contract || touched.server || touched.dartScope === 'all',
  };
}

// A root file the root lint (`lint:root`) checks.
const ROOT_SCRIPT = /^(?!(apps|packages|tools)\/)[^]*\.[cm]?[jt]sx?$/;

/**
 * The packages Turborepo must check besides `...[base]` (the changed packages
 * and their dependents) for the changed `files`, given the workspace package
 * folders `packageDirs`: each package whose task reads a changed file outside
 * it (TURBO_ROOT_INPUTS), to run with its dependents, or 'all' for a change
 * outside every package that none of them declares (a manifest, the lock, a
 * shared configuration, a root script), which Turborepo cannot place.
 * Markdown and Dart files outside the packages count only where a task reads them.
 */
export function turboScope(files, packageDirs) {
  const names = new Set();
  for (const file of files) {
    const readers = readByTurboTask(file);
    if (readers.some((each) => each.name === null)) return 'all';
    for (const each of readers) names.add(each.name);
    if (packageDirs.some((dir) => file.startsWith(`${dir}/`))) continue;
    if (ROOT_SCRIPT.test(file)) return 'all';
    if (readers.length === 0 && !DOCS.test(file) && !DART_ONLY.test(file)) return 'all';
  }
  return [...names].sort();
}

// Which Dart packages the fast check covers: none, the changed ones and their
// dependents, or all of them after a change to what every package shares (the
// workspace pubspec, the lock file, the pinned Flutter, the analysis options).
// CI's own reasons to run Dart (its workflow, the check engine) are not local ones.
function dartScope(files) {
  const dartFiles = files.filter((file) => !DOCS.test(file) && DART_ONLY.test(file));
  if (dartFiles.length === 0) return null;
  const inPackage = /^(apps\/(customer|captain|merchant)|packages\/core_[a-z0-9_]+)\//;
  return dartFiles.every((file) => inPackage.test(file)) ? 'changed' : 'all';
}

// A server file that builds a request or response schema: a change to it can
// change the OpenAPI document. A deleted file may have.
function declaresSchema(text) {
  return text === null || /from 'zod'|createZodDto|ZodResponse/.test(text);
}

function readText(file) {
  return existsSync(file) ? readFileSync(file, 'utf8') : null;
}

function git(args) {
  const result = spawnSync('git', args, { encoding: 'utf8' });
  if (result.status !== 0) throw new Error(`git ${args.join(' ')}: ${result.stderr.trim()}`);
  return result.stdout.split('\0').filter(Boolean);
}

/**
 * The paths changed since `base`: its commits, the uncommitted changes and the
 * untracked files. Without renames, a file moved into docs/ counts at its old
 * path too.
 */
export function changedFiles(base, { workingTree = true } = {}) {
  // Paths as they are (-z): never quoted, even with a tab, quote or backslash.
  const committed = git(['diff', '--name-only', '-z', '--no-renames', base, 'HEAD']);
  if (!workingTree) return committed;
  const uncommitted = git(['diff', '--name-only', '-z', '--no-renames', 'HEAD']);
  const untracked = git(['ls-files', '-z', '--others', '--exclude-standard']);
  return [...new Set([...committed, ...uncommitted, ...untracked])].sort();
}

function main() {
  const base = process.argv[2];
  const push = process.argv.includes('--push');
  const all = {
    code: true,
    dart: true,
    native: true,
    build: true,
    typescript: true,
    server: true,
    contract: true,
  };
  let flags = all;
  if (base && spawnSync('git', ['cat-file', '-e', `${base}^{commit}`]).status === 0) {
    const files = changedFiles(base, { workingTree: false });
    console.error(files.join('\n'));
    const touched = classify(files);
    flags = { ...touched, ...ciJobs(files, touched, { push }) };
    console.log(`hand_written=${handWritten(files).length}`);
  } else {
    // No commit to compare with (a new branch): check everything.
    console.error('No base commit: everything counts as changed.');
  }
  for (const key of Object.keys(all)) console.log(`${key}=${flags[key]}`);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
