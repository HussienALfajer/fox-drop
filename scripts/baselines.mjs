// The image baselines in one command: the ui-web screenshots (the Playwright
// `visual` project over the built Storybook) and the core_ui goldens, both
// valid only from their Linux images in Docker (packages/ui-web/scripts/
// visual-docker.mjs, scripts/golden-docker.mjs).
//
//   pnpm baselines            update the images the change since origin/main can
//                             alter, then compare them again
//   pnpm baselines --check    compare only
//   pnpm baselines --all      every suite and every story, whatever changed
//   pnpm baselines --base=<ref>   the change since <ref> instead of origin/main
//   node scripts/baselines.mjs --status
//                             exit 0 when this tree's images are checked or the
//                             change cannot alter one, else 1 with what to run;
//                             fast, never starts Docker (hooks and verify call it)
//
// Which suites run comes from classify-changes.mjs (`visual`, `golden`), as in
// CI. For ui-web only the stories the change can reach are run: a changed
// module under src/ selects the stories whose file imports it, directly or
// not; anything else that can alter a screenshot (the theme, the tokens,
// Storybook's or Playwright's set-up, the lock file) selects every story.
// A passing compare records the tree's fingerprint per suite in the git
// folder, next to verify's pass records; --status reads that record.
import { spawn, spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import {
  closeSync,
  existsSync,
  mkdirSync,
  openSync,
  readdirSync,
  readFileSync,
  rmSync,
  writeSync,
} from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  changedFiles,
  classify,
  DOCS_READ_BY_TOKEN_TESTS,
  READ_BY_DART_TESTS,
} from './classify-changes.mjs';
import {
  cut,
  formatDuration,
  gitDir,
  hasPassed,
  passKey,
  recordStepPass,
  releaseLock,
  stepLine,
  takeLock,
} from './verify-support.mjs';

const ROOT = path.resolve(import.meta.dirname, '..');
const UI_WEB = 'packages/ui-web';
export const SCREENSHOTS = `${UI_WEB}/e2e/__screenshots__`;
export const GOLDENS = 'packages/core_ui/test/golden/goldens';
const GOLDEN_FAILURES = 'packages/core_ui/test/golden/failures';
export const SURFACES = ['phone', 'captain'];

// CI reruns its image jobs when their own definition changes (the workflow,
// the classifier) to test itself; locally those files cannot alter an image.
const CI_ONLY = ['.github/workflows/ci.yml', 'scripts/classify-changes.mjs'];

// ui-web files that classify-changes counts for `visual` (the whole package)
// but that no screenshot can see: the Vitest and functional Playwright tests,
// the Design System's bundle scripts and outputs, lint and Vitest settings.
// A class name they hold only adds an unused Tailwind rule.
const NO_SCREENSHOT = new RegExp(
  `^${UI_WEB}/(test/|design-system/|e2e/(rtl|forms|overlays)\\.spec\\.ts$|scripts/(?!visual-docker\\.mjs$)|src/.*\\.test\\.tsx?$|(vitest\\.config\\.ts|eslint\\.config\\.mjs)$)`,
);

/**
 * What each suite reads, for the record: what classify-changes counts for it
 * (baselines.test.mjs checks every tracked file it flags is covered), and the
 * git-ignored fonts the images are drawn with.
 */
const fontsScripts = [
  'scripts/fonts.mjs',
  'scripts/fonts-fetch.mjs',
  'scripts/github-known-hosts.mjs',
];
const shared = [
  '.node-version',
  '.gitattributes',
  ...fontsScripts,
  'docs/brand/fonts-manifest.json',
];
const folder = (entry) => entry.replace(/\/\*\*$/, '');
export const SUITES = {
  visual: {
    label: 'ui-web screenshots',
    paths: [
      UI_WEB,
      'packages/design-tokens',
      'package.json',
      'pnpm-lock.yaml',
      'pnpm-workspace.yaml',
      'tsconfig.base.json',
      '.npmrc',
      ...shared,
      ...DOCS_READ_BY_TOKEN_TESTS.map(folder),
    ],
    ignored: ['.fonts'],
  },
  golden: {
    label: 'core_ui goldens',
    paths: [
      'packages/core_ui',
      'packages/core_tokens',
      'packages/design-tokens',
      ':(glob)**/pubspec.yaml',
      ':(glob)**/pubspec.lock',
      '.fvmrc',
      'scripts/golden-docker.mjs',
      ...shared,
      ...READ_BY_DART_TESTS.map(folder),
    ],
    ignored: ['.fonts'],
  },
};

/** Whether a changed file can alter an image of `suite` ('visual' or 'golden'). */
export function altersImages(suite, file) {
  if (CI_ONLY.includes(file)) return false;
  if (suite === 'visual' && NO_SCREENSHOT.test(file)) return false;
  return classify([file], () => null)[suite];
}

/** The suites a set of changed files can alter: { visual: [files], golden: [files] }. */
export function suitesFor(files) {
  return Object.fromEntries(
    Object.keys(SUITES).map((suite) => [suite, files.filter((file) => altersImages(suite, file))]),
  );
}

// ---------------------------------------------------------------- stories

const MODULE = new RegExp(`^${UI_WEB}/src/.*\\.tsx?$`);
const IMPORT = /(?:\bfrom\s*|\bimport\s*\(?\s*)['"](\.{1,2}\/[^'"?]+)(?:\?[^'"]*)?['"]/g;

/** The repository paths a module imports relatively, resolved against `known` paths. */
export function importsOf(file, text, known) {
  const out = [];
  for (const [, specifier] of text.matchAll(IMPORT)) {
    const base = path.posix.join(path.posix.dirname(file), specifier);
    const hit = ['', '.ts', '.tsx', '/index.ts', '/index.tsx'].find((ext) => known.has(base + ext));
    if (hit !== undefined) out.push(base + hit);
  }
  return out;
}

/**
 * Which ui-web stories the changed `files` (those that can alter a screenshot)
 * can change: { all: true, why } or { stories: [ids], why }. `sources` maps
 * every module under src/ to its text; `entries` are the built Storybook's
 * stories ({ id, importPath }). A changed module selects the stories whose
 * file imports it (transitively); a changed baseline selects its story;
 * anything else, or a deleted module, selects every story.
 */
export function selectStories(files, { sources, entries }) {
  const ids = new Set(entries.map((entry) => entry.id));
  const modules = new Set();
  const baselines = new Set();
  for (const file of files) {
    const png =
      file.startsWith(`${SCREENSHOTS}/`) && /^(.*)-([a-z]+)\.png$/.exec(path.posix.basename(file));
    if (png && SURFACES.includes(png[2])) {
      // A baseline whose story is gone is an orphan, found on its own.
      if (ids.has(png[1])) baselines.add(png[1]);
      continue;
    }
    if (MODULE.test(file) && sources.has(file)) {
      modules.add(file);
      continue;
    }
    return {
      all: true,
      why: MODULE.test(file) ? `${file} was deleted` : `${file} can alter every story`,
    };
  }
  const known = new Set(sources.keys());
  const imports = new Map([...sources].map(([file, text]) => [file, importsOf(file, text, known)]));
  const reaches = (start) => {
    const seen = new Set([start]);
    const queue = [start];
    while (queue.length > 0)
      for (const next of imports.get(queue.pop()) ?? [])
        if (!seen.has(next)) {
          seen.add(next);
          queue.push(next);
        }
    return seen;
  };
  const byFile = new Map();
  const stories = entries.filter((entry) => {
    const file = path.posix.join(UI_WEB, entry.importPath);
    if (!byFile.has(file))
      byFile.set(
        file,
        [...reaches(file)].some((each) => modules.has(each)),
      );
    return byFile.get(file) || baselines.has(entry.id);
  });
  const why = [...modules];
  if (baselines.size > 0) why.push(`the baselines of ${baselines.size} stories`);
  return { stories: stories.map((entry) => entry.id), why: why.join(', ') };
}

/** Baselines of no story (`files`: names in the screenshots folder). */
export function orphans(files, entries) {
  const names = new Set(
    entries.flatMap((entry) => SURFACES.map((surface) => `${entry.id}-${surface}.png`)),
  );
  return files.filter((file) => file.endsWith('.png') && !names.has(file)).sort();
}

/** The ui-web modules and their text. */
function readSources() {
  const dir = path.join(ROOT, UI_WEB, 'src');
  return new Map(
    readdirSync(dir, { recursive: true })
      .map((each) => `${UI_WEB}/src/${String(each).replaceAll('\\', '/')}`)
      .filter((file) => /\.tsx?$/.test(file))
      .map((file) => [file, readFileSync(path.join(ROOT, file), 'utf8')]),
  );
}

function storyEntries() {
  const index = JSON.parse(
    readFileSync(path.join(ROOT, UI_WEB, 'dist/storybook/index.json'), 'utf8'),
  );
  return Object.values(index.entries).filter((entry) => entry.type === 'story');
}

// ---------------------------------------------------------------- the record

export const recordFile = (dir) => path.join(dir, 'baselines-passes.json');

/** The key of a suite's pass on this tree. */
export function suiteKey(suite, root = ROOT) {
  const { paths, ignored } = SUITES[suite];
  return passKey({ suite, inputs: treeFingerprint(root, paths, { ignoredDirs: ignored }) });
}

/**
 * A fingerprint of the files the `pathspecs` name as they are on disk: each
 * path with the blob id git gives its content (clean filters applied, so a
 * line-ending-only change does not count), and the files of `ignoredDirs`.
 * Unlike verify-support's inputsFingerprint it does not see the index, so
 * committing a checked tree keeps it checked.
 */
export function treeFingerprint(root, pathspecs, { ignoredDirs = [] } = {}) {
  const git = (args, input) => {
    const result = spawnSync('git', ['-c', 'core.quotePath=false', ...args], {
      cwd: root,
      input,
      maxBuffer: 512 * 1024 * 1024,
    });
    if (result.status !== 0) throw new Error(`git ${args.join(' ')}: ${result.stderr}`);
    return result.stdout.toString('utf8');
  };
  const blobs = new Map();
  for (const entry of git(['ls-files', '-s', '-z', '--', ...pathspecs]).split('\0'))
    if (entry) blobs.set(entry.slice(entry.indexOf('\t') + 1), entry.split(' ')[1]);
  const differing = [
    ...git(['diff', '--name-only', '--no-renames', '-z', '--', ...pathspecs]).split('\0'),
    ...git(['ls-files', '--others', '--exclude-standard', '-z', '--', ...pathspecs]).split('\0'),
  ].filter(Boolean);
  const present = differing.filter((file) => existsSync(path.join(root, file)));
  for (const file of differing) blobs.delete(file);
  if (present.length > 0) {
    const ids = git(['hash-object', '--stdin-paths'], present.join('\n')).trim().split(/\r?\n/);
    present.forEach((file, i) => blobs.set(file, ids[i]));
  }
  const hash = createHash('sha256');
  for (const file of [...blobs.keys()].sort()) hash.update(`${file}\0${blobs.get(file)}\0`);
  for (const dir of ignoredDirs) {
    const full = path.join(root, dir);
    hash.update(`\0dir:${dir}\0`);
    if (!existsSync(full)) continue;
    for (const file of readdirSync(full, { recursive: true, withFileTypes: true })
      .filter((entry) => entry.isFile())
      .map((entry) => path.join(entry.parentPath, entry.name))
      .sort()) {
      hash.update(`\0${path.relative(root, file).replaceAll('\\', '/')}\0`);
      hash.update(readFileSync(file));
    }
  }
  return hash.digest('hex');
}

/**
 * Whether the tree's images are checked: { ok, line, unchecked: [suites] }.
 * `files` are the changed files since `since` (null: no base to compare with,
 * so every suite counts).
 */
export function imageStatus(
  files,
  { root = ROOT, record = recordFile(gitDir(root)), since = 'origin/main' } = {},
) {
  const touched = files ? suitesFor(files) : { visual: [true], golden: [true] };
  const needed = Object.keys(SUITES).filter((suite) => touched[suite].length > 0);
  if (needed.length === 0)
    return { ok: true, unchecked: [], line: `no change since ${since} can alter an image` };
  const unchecked = needed.filter((suite) => !hasPassed(record, suiteKey(suite, root)));
  const names = (suites) => suites.map((suite) => SUITES[suite].label).join(' and ');
  if (unchecked.length === 0)
    return { ok: true, unchecked, line: `the ${names(needed)} of this tree are checked` };
  return {
    ok: false,
    unchecked,
    line: `the ${names(unchecked)} of this tree are not checked: run \`pnpm baselines\` (updates and compares them; \`--check\` only compares)`,
  };
}

/** The changed files since `ref` (its merge base with HEAD), or null without one. */
export function changedSince(ref = 'origin/main', root = ROOT) {
  const base = spawnSync('git', ['merge-base', ref, 'HEAD'], {
    cwd: root,
    encoding: 'utf8',
  });
  if (base.status !== 0) return null;
  const cwd = process.cwd();
  process.chdir(root);
  try {
    return changedFiles(base.stdout.trim());
  } finally {
    process.chdir(cwd);
  }
}

// ---------------------------------------------------------------- images

/** path → sha1 of every file under `dir` (repository-relative), for what an update changed. */
export function snapshot(dir, root = ROOT) {
  const full = path.join(root, dir);
  if (!existsSync(full)) return new Map();
  return new Map(
    readdirSync(full, { recursive: true, withFileTypes: true })
      .filter((entry) => entry.isFile())
      .map((entry) => {
        const file = path.join(entry.parentPath, entry.name);
        return [
          path.relative(root, file).replaceAll('\\', '/'),
          createHash('sha1').update(readFileSync(file)).digest('hex'),
        ];
      }),
  );
}

/** What changed between two snapshots: [{ file, change: 'added'|'changed'|'removed' }]. */
export function changedImages(before, after) {
  const out = [];
  for (const [file, hash] of after)
    if (!before.has(file)) out.push({ file, change: 'added' });
    else if (before.get(file) !== hash) out.push({ file, change: 'changed' });
  for (const file of before.keys()) if (!after.has(file)) out.push({ file, change: 'removed' });
  return out.sort((a, b) => a.file.localeCompare(b.file));
}

const COLOURS = new RegExp(`${String.fromCharCode(27)}\\[[0-9;]*m`, 'g');

/**
 * The failed tests of a Playwright JSON report: [{ title, error, diff }], the
 * diff image's path made repository-relative (the run's /work is the repository).
 */
export function failedScreenshots(report) {
  const out = [];
  const walk = (suite) => {
    for (const spec of suite.specs ?? []) {
      if (spec.ok) continue;
      const results = spec.tests.flatMap((test) => test.results);
      const diff = results
        .flatMap((result) => result.attachments ?? [])
        .find((attachment) => attachment.path?.endsWith('-diff.png'))?.path;
      const error = results
        .map((result) => result.error?.message ?? '')
        .find(Boolean)
        ?.replace(COLOURS, '')
        .split('\n')
        .map((line) => line.trim())
        .filter(Boolean)
        .slice(0, 3)
        .join(' ');
      out.push({
        title: spec.title,
        error: error ?? 'failed',
        diff: diff ? diff.replace(/^\/work\//, '') : null,
      });
    }
    for (const child of suite.suites ?? []) walk(child);
  };
  for (const suite of report.suites ?? []) walk(suite);
  return out;
}

// ---------------------------------------------------------------- the run

const USAGE =
  'Usage: node scripts/baselines.mjs [--check] [--all | --base=<ref>] | --status (the change since origin/main)';

async function main() {
  const args = process.argv.slice(2);
  const baseArg = args.find((arg) => /^--base=[\w./^~-]+$/.test(arg));
  const ref = baseArg?.slice('--base='.length) ?? 'origin/main';
  const unknown = args.filter(
    (arg) => arg !== baseArg && !['--check', '--all', '--status'].includes(arg),
  );
  if (unknown.length > 0 || (args.includes('--status') && args.length > 1)) {
    console.error(`baselines: unknown or mixed arguments ${args.join(' ')}\n${USAGE}`);
    process.exit(2);
  }
  if (args.includes('--status')) {
    const status = imageStatus(changedSince());
    console.log(`baselines: ${status.line}`);
    process.exit(status.ok ? 0 : 1);
  }
  const check = args.includes('--check');
  const all = args.includes('--all');
  const started = Date.now();

  const dir = gitDir(ROOT);
  const lock = path.join(dir, 'baselines.lock');
  const taken = takeLock(lock, { command: process.argv.join(' ') });
  if (!taken.taken) {
    console.error(`baselines: another run holds this folder (pid ${taken.holder?.pid}).`);
    process.exit(3);
  }
  process.on('exit', () => releaseLock(lock));
  for (const signal of ['SIGINT', 'SIGTERM', 'SIGHUP']) process.on(signal, () => process.exit(130));

  const files = all ? null : changedSince(ref);
  const touched = files ? suitesFor(files) : null;
  const runs = Object.keys(SUITES).filter((suite) => !touched || touched[suite].length > 0);
  console.log(
    `baselines: ${check ? 'compare' : 'update, then compare'}; ${
      all
        ? '--all: every suite'
        : files
          ? `${files.length} files changed since ${ref}`
          : `no merge base with ${ref}: every suite`
    }`,
  );
  for (const suite of Object.keys(SUITES))
    if (!runs.includes(suite))
      console.log(
        stepLine({ name: `${SUITES[suite].label}: no change can alter them`, result: 'skipped' }),
      );
  if (runs.length === 0) return finish(started, true, []);

  // Prerequisites, each with what to do.
  if (!existsSync(path.join(ROOT, '.fonts/cofo-sans-pro-arabic'))) {
    console.error('baselines: CoFo is missing from .fonts/: run `pnpm fonts:fetch` first.');
    process.exit(1);
  }
  if (
    spawnSync('docker', ['info', '--format', '{{.ServerVersion}}'], { stdio: 'ignore' }).status !==
    0
  ) {
    console.error('baselines: Docker is not running: start Docker Desktop, then run this again.');
    process.exit(1);
  }

  const runDir = newRunFolder(dir);
  console.log(`baselines: each step's whole output goes to ${shown(runDir)}`);
  const before = new Map([
    ['visual', snapshot(SCREENSHOTS)],
    ['golden', snapshot(GOLDENS)],
  ]);
  const results = await Promise.all(
    runs.map((suite) =>
      (suite === 'visual' ? runVisual : runGolden)({
        check,
        all: !touched,
        files: touched?.visual ?? [],
        runDir,
      }),
    ),
  );
  const images = changedImages(
    new Map([...before.get('visual'), ...before.get('golden')]),
    new Map([...snapshot(SCREENSHOTS), ...snapshot(GOLDENS)]),
  );
  return finish(started, results.every(Boolean), images);
}

function finish(started, passed, images) {
  if (images.length > 0) {
    console.log(`\nbaselines: ${images.length} images changed (review them, then commit):`);
    for (const { file, change } of images) console.log(`  ${change.padEnd(8)} ${file}`);
  } else console.log('\nbaselines: no image changed');
  console.log(
    `baselines: ${passed ? 'passed' : 'FAILED'} in ${formatDuration(Date.now() - started)}`,
  );
  process.exit(passed ? 0 : 1);
}

function newRunFolder(dir) {
  const runs = path.join(dir, 'baselines-runs');
  mkdirSync(runs, { recursive: true });
  for (const old of readdirSync(runs).sort().slice(0, -9))
    rmSync(path.join(runs, old), { recursive: true, force: true });
  const run = path.join(runs, new Date().toISOString().replace(/[:.]/g, '-'));
  mkdirSync(run);
  return run;
}

const shown = (file) => file.replaceAll('\\', '/');
let stepCount = 0;

/** Runs a shell command with its output in a log file; resolves to { ok, log, ms }. */
function run(name, command, { runDir, env = process.env }) {
  const log = path.join(
    runDir,
    `${String(++stepCount).padStart(2, '0')}-${name.toLowerCase().replace(/[^a-z0-9]+/g, '-')}.log`,
  );
  const out = openSync(log, 'w');
  writeSync(out, `$ ${command}\n\n`);
  const started = Date.now();
  return new Promise((resolve) => {
    const child = spawn(command, { cwd: ROOT, env, shell: true, stdio: ['ignore', out, out] });
    const done = (code) => {
      closeSync(out);
      const ms = Date.now() - started;
      const ok = code === 0;
      console.log(
        stepLine({ name, result: ok ? 'passed' : 'FAILED', ms }) + (ok ? '' : `  (${shown(log)})`),
      );
      resolve({ ok, log, ms });
    };
    child.on('error', (error) => {
      writeSync(out, String(error.stack));
      done(1);
    });
    child.on('close', done);
  });
}

/**
 * Runs a suite's compare and records its pass, unless the suite's inputs
 * changed while it ran (an edit mid-run proves nothing about the new tree).
 */
async function compareAndRecord(suite, name, command, options) {
  const key = suiteKey(suite);
  const result = await run(name, command, options);
  if (result.ok && suiteKey(suite) === key) recordPass(key);
  return result;
}

function recordPass(key) {
  try {
    recordStepPass(recordFile(gitDir(ROOT)), key);
  } catch {
    // A read-only git folder only costs a repeat run.
  }
}

async function runVisual({ check, all, files, runDir }) {
  const label = SUITES.visual.label;
  const build = await run(
    'Storybook build (Turborepo)',
    'pnpm exec turbo run build --filter=@fox-drop/ui-web --output-logs=new-only',
    { runDir },
  );
  if (!build.ok) return printCut(build.log);
  const entries = storyEntries();
  const selected = all
    ? { all: true, why: '--all, or no origin/main to compare with' }
    : selectStories(files, { sources: readSources(), entries });
  const ids = selected.all ? null : selected.stories;

  // Baselines of no story (a story renamed or removed): an update removes
  // them, a compare fails on them after comparing the rest.
  const stray = orphans(readdirSync(path.join(ROOT, SCREENSHOTS)), entries);
  if (stray.length > 0) {
    console.log(
      stepLine({
        name: `${label}: baselines of no story: ${stray.join(', ')}${check ? ' (`pnpm baselines` removes them)' : ', removed'}`,
        result: check ? 'FAILED' : 'passed',
      }),
    );
    if (!check) for (const file of stray) rmSync(path.join(ROOT, SCREENSHOTS, file));
  }
  const strayFails = check && stray.length > 0;
  if (ids && ids.length === 0) {
    console.log(
      stepLine({
        name: `${label}: the change reaches no story (${selected.why})`,
        result: 'skipped',
      }),
    );
    // Nothing to compare: the tree's screenshots are checked all the same.
    if (!strayFails) recordPass(suiteKey('visual'));
    return !strayFails;
  }
  const scope = ids
    ? `${ids.length} of ${entries.length} stories (${selected.why})`
    : `all ${entries.length} stories (${selected.why})`;
  console.log(`baselines: ${label}: ${scope}, on ${SURFACES.join(' and ')}`);
  const report = 'test-results/baselines-report.json';
  const env = {
    ...process.env,
    FD_VISUAL_REPORT: report,
    ...(ids && { FD_VISUAL_STORIES: ids.join(',') }),
  };
  const script = `node ${UI_WEB}/scripts/visual-docker.mjs`;
  const reportFile = path.join(ROOT, UI_WEB, report);
  if (!check) {
    rmSync(reportFile, { force: true });
    const update = await run(`${label}: update`, `${script} --update-snapshots=changed`, {
      runDir,
      env,
    });
    if (!update.ok) return visualFailure(update, reportFile);
  }
  rmSync(reportFile, { force: true });
  const compare = strayFails
    ? await run(`${label}: compare`, script, { runDir, env })
    : await compareAndRecord('visual', `${label}: compare`, script, { runDir, env });
  if (!compare.ok) return visualFailure(compare, reportFile);
  return !strayFails;
}

function visualFailure(result, file) {
  const failed = existsSync(file) ? failedScreenshots(JSON.parse(readFileSync(file, 'utf8'))) : [];
  if (failed.length === 0) return printCut(result.log);
  for (const { title, error, diff } of failed)
    console.error(`  ${title}: ${error}${diff ? `\n    diff: ${diff}` : ''}`);
  console.error(
    `  expected, actual and diff images: ${UI_WEB}/test-results/; whole output: ${shown(result.log)}`,
  );
  return false;
}

async function runGolden({ check, runDir }) {
  const label = SUITES.golden.label;
  const script = 'node scripts/golden-docker.mjs';
  if (!check) {
    const update = await run(`${label}: update`, `${script} --update-goldens`, { runDir });
    if (!update.ok) return printCut(update.log);
  }
  const compare = await compareAndRecord('golden', `${label}: compare`, script, { runDir });
  if (!compare.ok) {
    const failures = path.join(ROOT, GOLDEN_FAILURES);
    const names = existsSync(failures)
      ? [
          ...new Set(
            readdirSync(failures).map((name) =>
              name.replace(/_(isolatedDiff|maskedDiff|masterImage|testImage)\.png$/, ''),
            ),
          ),
        ]
      : [];
    printCut(compare.log);
    if (names.length > 0)
      console.error(`  failed goldens: ${names.join(', ')}\n  their images: ${GOLDEN_FAILURES}/`);
    return false;
  }
  return true;
}

function printCut(log) {
  console.error(cut(readFileSync(log, 'utf8'), shown(log)));
  return false;
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url))
  await main();
