// What a change touches, from its paths (docs/archive/claude-code-workflow.md,
// phases 4 and 5). CI's `changes` job and `node scripts/verify.mjs --changed`
// both use it, so the two never disagree about what a path sets.
//
//   node scripts/classify-changes.mjs <base>   prints code=…, dart=…, native=…,
//                                              build=…, visual=…, golden=…
//                                              and hand_written=<count> (with
//                                              a base) for $GITHUB_OUTPUT
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

// The docs packages/design-tokens reads to build the Design System and the
// Guide (D.4): its tests check them, so a change to one runs the TypeScript
// tests. A path ending in /** is a folder.
export const DOCS_READ_BY_TOKEN_TESTS = [
  'docs/architecture/09-design-system.md',
  'docs/brand/fonts-manifest.json',
  'docs/brand/logo/**',
  'docs/brand/app-icon/**',
];

const readByTokenTests = (file) =>
  DOCS_READ_BY_TOKEN_TESTS.some((each) =>
    each.endsWith('/**') ? file.startsWith(each.slice(0, -2)) : file === each,
  );

const readByServerTests = (file) =>
  READ_BY_SERVER_TESTS.some((each) =>
    each.endsWith('/**') ? file.startsWith(each.slice(0, -2)) : file === each,
  );

// The Dart packages with native code of their own (a plugin's android/, ios/
// or windows/ folder), checked by classify-changes.test.mjs.
export const NATIVE_PACKAGES = ['packages/core_alerts'];

// Files outside the Dart packages that Dart tests read: core_ui's phone cases
// shared with ui-web and the brand mark the loader draws (D.11b). A path
// ending in /** is a folder. A change to one runs every Dart package's checks.
export const READ_BY_DART_TESTS = [
  'packages/ui-web/src/phone-field/phone-cases.json',
  'docs/brand/logo/mark/mark-orange-on-ivory-drop.svg',
];

// Files outside a Dart package that count as a change to that package (its
// folder) and so to its dependents: core_tokens' Dart is generated from the
// design tokens, and its test compares the two; core_ui's parity test (D.P2)
// measures the registry's states against the resolved CSS tokens. A path
// ending in /** is a folder.
export const DART_PACKAGE_SOURCES = {
  'packages/core_tokens': ['packages/design-tokens/tokens/**'],
  'packages/core_ui': [
    'packages/design-tokens/components.json',
    'packages/design-tokens/generated/tokens.css',
  ],
};

const matches = (file) => (each) =>
  each.endsWith('/**') ? file.startsWith(each.slice(0, -2)) : file === each;

const readByDartTests = (file) => READ_BY_DART_TESTS.some(matches(file));

/** The Dart package folders that the file outside them counts for (DART_PACKAGE_SOURCES). */
export const dartPackagesSourcedBy = (file) =>
  Object.keys(DART_PACKAGE_SOURCES).filter((dir) => DART_PACKAGE_SOURCES[dir].some(matches(file)));

// Generated Markdown is code: a test compares it with a fresh render.
const DOCS = /^(?!packages\/design-tokens\/generated\/)(.*\.md$|docs\/)/;
// packages/design-tokens generates the Dart tokens of packages/core_tokens.
// CI runs the Dart jobs for its workflow and for the check engine: verify.mjs
// and every script it runs or imports, and the golden job's image script.
const DART =
  /(\.dart$|\.arb$|(^|\/)(pubspec\.(yaml|lock)|analysis_options\.yaml|l10n\.yaml|dart_test\.yaml)$|^(apps\/(customer|captain|merchant|widgetbook)|packages\/(core_[a-z0-9_]+|fox_lints)|packages\/design-tokens)\/|^\.fvmrc$|^\.github\/workflows\/ci\.yml$|^scripts\/(verify(-support|-watchdog)?|classify-changes|green-tree|server-test-readers|outside-reads|baselines|golden-docker)\.mjs$)/;
// What the `golden` job reads besides Dart: the fonts it fetches and the
// scripts it runs (D.7). They set the Dart checks too.
const GOLDEN_INPUTS =
  /^(docs\/brand\/fonts-manifest\.json|scripts\/(fonts|fonts-fetch|github-known-hosts)\.mjs)$/;
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
  /(\.dart$|\.arb$|(^|\/)(pubspec\.(yaml|lock)|analysis_options\.yaml|l10n\.yaml|dart_test\.yaml)$|^(apps\/(customer|captain|merchant|widgetbook)|packages\/(core_[a-z0-9_]+|fox_lints))\/|^\.fvmrc$)/;
// What the OpenAPI document and both clients are generated from, besides the
// server files that declare a schema (see `declaresSchema`).
const CONTRACT =
  /^(scripts\/generate-api\.mjs|openapitools\.json|apps\/server\/scripts\/write-openapi\.mjs|apps\/server\/src\/http\/|packages\/(api-schema|core_api)\/)|^apps\/server\/src\/.*\.controller\.ts$/;
const SERVER_SOURCE = /^apps\/server\/src\/.*\.ts$/;
// What CI's own image jobs depend on besides their inputs: the workflow and
// this classifier, so a change to either runs both.
const CI_ITSELF = /^(\.github\/workflows\/ci\.yml|scripts\/classify-changes\.mjs)$/;
// What can change a ui-web screenshot (the `visual` job): ui-web itself (its
// stories, Storybook, Playwright set-up and baselines), the design tokens it
// reads, the root manifest, lock and workspace files (the Playwright and
// Storybook versions, pnpm), the TypeScript base Vite reads, the Node it runs
// on, the line endings it is checked out with, and the fonts it fetches (the
// manifest, read with the token docs, and the scripts). A path's doubt goes to
// true; classify-changes.test.mjs derives the job's inputs from ci.yml.
const VISUAL =
  /^(packages\/(ui-web|design-tokens)\/|(package\.json|pnpm-lock\.yaml|pnpm-workspace\.yaml|tsconfig\.base\.json|\.npmrc|\.node-version|\.gitattributes)$|scripts\/(fonts|fonts-fetch|github-known-hosts)\.mjs$)/;
// The root package.json scripts the `visual` job runs: the ones it names
// (classify-changes.test.mjs reads them from ci.yml) and pnpm's install
// hooks. A change to the root package.json that leaves every other field
// alone (only other scripts changed) cannot change a screenshot.
export const VISUAL_ROOT_SCRIPTS = [
  'fonts:fetch',
  'pnpm:devPreinstall',
  'preinstall',
  'install',
  'postinstall',
  'prepare',
];

/**
 * Whether the root package.json changed only in scripts the `visual` job does
 * not run, from its text now and at the base (null: missing or unknown).
 */
function onlyOtherRootScripts(now, before) {
  if (now === null || before === null || before === undefined) return false;
  const visualPart = (text) => {
    const manifest = JSON.parse(text);
    const scripts = Object.fromEntries(
      Object.entries(manifest.scripts ?? {}).filter(([name]) => VISUAL_ROOT_SCRIPTS.includes(name)),
    );
    return canonical({ ...manifest, scripts });
  };
  try {
    return visualPart(now) === visualPart(before);
  } catch {
    return false; // not JSON: in doubt, it counts
  }
}

/** JSON with every object's keys sorted, so a reordering is no change. */
function canonical(value) {
  return JSON.stringify(value, (_, each) =>
    each && typeof each === 'object' && !Array.isArray(each)
      ? Object.fromEntries(Object.entries(each).sort(([a], [b]) => a.localeCompare(b)))
      : each,
  );
}
// What can change a core_ui golden (the `golden` job): core_ui and the tokens
// it is generated from, every pubspec and the lock file (the job resolves the
// whole workspace), the pinned Flutter, the files outside Dart its tests read
// (READ_BY_DART_TESTS), the fonts and scripts it fetches them with
// (GOLDEN_INPUTS), the image script and what Node and git hand it.
const GOLDEN =
  /^(packages\/(core_ui|core_tokens|design-tokens)\/|\.fvmrc$|\.node-version$|\.gitattributes$|scripts\/golden-docker\.mjs$)|(^|\/)pubspec\.(yaml|lock)$/;

// The files nobody writes by hand, left out of the pull request size notice
// (CI's `changes` job): what a generator writes, the same list as the edit
// guard's (.claude/hooks/lib/policy.mjs, GENERATED; classify-changes.test.mjs
// keeps the two in step), then images (the icons, the screenshot and golden
// baselines, the app icons), fonts and test snapshots.
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
 * - code, dart, native, build, visual, golden: CI's jobs
 *   (docs/archive/claude-code-workflow.md, phase 5): the checks, the Dart
 *   checks, the native release builds of a pull request, the images and the
 *   staging builds and deploy, the ui-web screenshots, the core_ui goldens.
 * - typescript: Turborepo's affected packages; server: the server's tests;
 *   contract: regenerate the API contract; tokenDocs: a doc the design tokens'
 *   tests read changed, so they run though no package file did; dartScope:
 *   null, 'changed' or 'all'.
 * `readBase(file)` returns a file's text at the base commit, or null; without
 * it, the root package.json counts for `visual` whatever changed in it.
 */
export function classify(files, read = readText, readBase = null) {
  const specRead = files.some(
    (file) => SPEC_FILES_READ_BY_TESTS.includes(file) || readByTokenTests(file),
  );
  const build = files.some((file) => !DOCS.test(file));
  const code = build || specRead;
  const dart = files.some(
    (file) =>
      GOLDEN_INPUTS.test(file) || readByDartTests(file) || (!DOCS.test(file) && DART.test(file)),
  );
  const native = files.some(
    (file) => !DOCS.test(file) && (NATIVE.test(file) || nativePackage(file)),
  );
  const typescript = specRead || files.some((file) => !DOCS.test(file) && !DART_ONLY.test(file));
  const server = files.some(
    (file) =>
      readByServerTests(file) ||
      (file.startsWith('apps/server/') && !DOCS.test(file)) ||
      /^(package\.json|pnpm-lock\.yaml|pnpm-workspace\.yaml|tsconfig[\w.]*\.json)$/.test(file),
  );
  const contract = files.some(
    (file) =>
      CONTRACT.test(file) ||
      (SERVER_SOURCE.test(file) && !file.endsWith('.test.ts') && declaresSchema(read(file))),
  );
  const visual = files.some(
    (file) =>
      CI_ITSELF.test(file) ||
      readByTokenTests(file) ||
      (!DOCS.test(file) &&
        VISUAL.test(file) &&
        !(file === 'package.json' && readBase && onlyOtherRootScripts(read(file), readBase(file)))),
  );
  const golden = files.some(
    (file) =>
      CI_ITSELF.test(file) ||
      GOLDEN_INPUTS.test(file) ||
      readByDartTests(file) ||
      (!DOCS.test(file) && GOLDEN.test(file)),
  );
  return {
    code,
    dart,
    native,
    build,
    visual,
    golden,
    typescript,
    server,
    contract,
    tokenDocs: files.some(readByTokenTests),
    dartScope: dartScope(files),
  };
}

// Which Dart packages the fast check covers: none, the changed ones and their
// dependents (a package's sources outside it, DART_PACKAGE_SOURCES, count as
// the package), or all of them after a change to what every package shares
// (the workspace pubspec, the lock file, the pinned Flutter, the analysis
// options) or to a file outside them that a Dart test reads. CI's own reasons
// to run Dart (its workflow, the check engine) are not local ones.
function dartScope(files) {
  if (files.some(readByDartTests)) return 'all';
  const sourced = (file) => dartPackagesSourcedBy(file).length > 0;
  const dartFiles = files.filter(
    (file) => sourced(file) || (!DOCS.test(file) && DART_ONLY.test(file)),
  );
  if (dartFiles.length === 0) return null;
  const inPackage =
    /^(apps\/(customer|captain|merchant|widgetbook)|packages\/(core_[a-z0-9_]+|fox_lints))\//;
  return dartFiles.every((file) => sourced(file) || inPackage.test(file)) ? 'changed' : 'all';
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
  return result.stdout.split(/\r?\n/).filter(Boolean);
}

/**
 * The paths changed since `base`: its commits, the uncommitted changes and the
 * untracked files. Without renames, a file moved into docs/ counts at its old
 * path too.
 */
export function changedFiles(base, { workingTree = true } = {}) {
  // Paths as they are, not quoted when they hold non-ASCII characters.
  const raw = ['-c', 'core.quotePath=false'];
  const committed = git([...raw, 'diff', '--name-only', '--no-renames', base, 'HEAD']);
  if (!workingTree) return committed;
  const uncommitted = git([...raw, 'diff', '--name-only', '--no-renames', 'HEAD']);
  const untracked = git([...raw, 'ls-files', '--others', '--exclude-standard']);
  return [...new Set([...committed, ...uncommitted, ...untracked])].sort();
}

function main() {
  const base = process.argv[2];
  const all = { code: true, dart: true, native: true, build: true, visual: true, golden: true };
  let flags = all;
  if (base && spawnSync('git', ['cat-file', '-e', `${base}^{commit}`]).status === 0) {
    const files = changedFiles(base, { workingTree: false });
    console.error(files.join('\n'));
    flags = classify(files, readText, (file) => {
      const shown = spawnSync('git', ['show', `${base}:${file}`], { encoding: 'utf8' });
      return shown.status === 0 ? shown.stdout : null;
    });
    console.log(`hand_written=${handWritten(files).length}`);
  } else {
    // No commit to compare with (a new branch): check everything.
    console.error('No base commit: everything counts as changed.');
  }
  for (const key of Object.keys(all)) console.log(`${key}=${flags[key]}`);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
