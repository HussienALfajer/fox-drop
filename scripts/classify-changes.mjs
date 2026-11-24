// What a change touches, from its paths (docs/archive/claude-code-workflow.md,
// phases 4 and 5). CI's `changes` job and `node scripts/verify.mjs --changed`
// both use it, so the two never disagree about what a path sets.
//
//   node scripts/classify-changes.mjs <base>   prints code=…, dart=…, native=…,
//                                              build=… for $GITHUB_OUTPUT
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

// Generated Markdown is code: a test compares it with a fresh render.
const DOCS = /^(?!packages\/design-tokens\/generated\/)(.*\.md$|docs\/)/;
// packages/design-tokens generates the Dart tokens of packages/core_tokens.
const DART =
  /(\.dart$|\.arb$|(^|\/)(pubspec\.(yaml|lock)|analysis_options\.yaml|l10n\.yaml|dart_test\.yaml)$|^(apps\/(customer|captain|merchant|widgetbook)|packages\/(core_[a-z0-9_]+|fox_lints)|packages\/design-tokens)\/|^\.fvmrc$|^\.github\/workflows\/ci\.yml$|^scripts\/(verify(-support)?|golden-docker)\.mjs$)/;
// What the `golden` job (part of the Dart checks) reads besides Dart: the
// fonts it fetches and the scripts it runs (D.7).
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

/**
 * What the changed `files` (repository-relative, forward slashes) set.
 * `read(file)` returns a file's text, or null when it was deleted.
 * - code, dart, native, build: CI's jobs (docs/archive/claude-code-workflow.md,
 *   phase 5): the checks, the Dart checks, the native release builds of a
 *   pull request, the images and the staging builds and deploy.
 * - typescript: Turborepo's affected packages; server: the server's tests;
 *   contract: regenerate the API contract; tokenDocs: a doc the design tokens'
 *   tests read changed, so they run though no package file did; dartScope:
 *   null, 'changed' or 'all'.
 */
export function classify(files, read = readText) {
  const specRead = files.some(
    (file) => SPEC_FILES_READ_BY_TESTS.includes(file) || readByTokenTests(file),
  );
  const build = files.some((file) => !DOCS.test(file));
  const code = build || specRead;
  const dart = files.some(
    (file) => GOLDEN_INPUTS.test(file) || (!DOCS.test(file) && DART.test(file)),
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
  return {
    code,
    dart,
    native,
    build,
    typescript,
    server,
    contract,
    tokenDocs: files.some(readByTokenTests),
    dartScope: dartScope(files),
  };
}

// Which Dart packages the fast check covers: none, the changed ones and their
// dependents, or all of them after a change to what every package shares (the
// workspace pubspec, the lock file, the pinned Flutter, the analysis options).
// CI's own reasons to run Dart (its workflow, verify.mjs) are not local ones.
function dartScope(files) {
  const dartFiles = files.filter((file) => !DOCS.test(file) && DART_ONLY.test(file));
  if (dartFiles.length === 0) return null;
  const inPackage =
    /^(apps\/(customer|captain|merchant|widgetbook)|packages\/(core_[a-z0-9_]+|fox_lints))\//;
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
  const all = { code: true, dart: true, native: true, build: true };
  let flags = all;
  if (base && spawnSync('git', ['cat-file', '-e', `${base}^{commit}`]).status === 0) {
    const files = changedFiles(base, { workingTree: false });
    console.error(files.join('\n'));
    flags = classify(files);
  } else {
    // No commit to compare with (a new branch): check everything.
    console.error('No base commit: everything counts as changed.');
  }
  for (const key of Object.keys(all)) console.log(`${key}=${flags[key]}`);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
