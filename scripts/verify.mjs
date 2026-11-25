// The single check command (architecture §18.4): TypeScript through Turborepo,
// the server's tests through Vitest, Dart through Melos.
//
// `pnpm verify` runs every part. CI runs each part as its own job, in
// parallel: `node scripts/verify.mjs <part>...`, and `--shard=<i>/<n>` splits
// the server's tests (Vitest's shards) or the Flutter packages across jobs.
// `node scripts/verify.mjs --changed` runs only what the change since
// origin/main can break: the check a session runs after each finished layer.
//
// Outside CI the format checks and the contract run first (the contract writes
// the generated clients the others read), then the TypeScript, server and Dart
// parts at the same time (`--serial`: one after another). Each step prints one
// line when it ends and writes its whole output to a log file in the run's
// folder; a failing step does not stop the other parts, and at the end the
// failing steps' output is printed cut to their failures. Turborepo's cache
// replays its tasks whose inputs did not change (turbo.json), and with
// `--changed` a server or Dart step whose inputs are unchanged since it passed
// is skipped (`--fresh` runs everything again). In CI (`CI` set) the output
// streams as it comes, the first failing step stops the run and nothing is
// skipped or replayed: CI is the gate.
import { spawn, spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import {
  closeSync,
  existsSync,
  mkdirSync,
  openSync,
  readdirSync,
  readFileSync,
  renameSync,
  rmSync,
  writeFileSync,
  writeSync,
} from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import { imageStatus } from './baselines.mjs';
import { changedFiles, classify, READ_BY_SERVER_TESTS } from './classify-changes.mjs';
import { recordGreen, treeState } from './green-tree.mjs';
import { serverTestScope } from './server-test-readers.mjs';
import {
  changedDartPackages,
  chromiumInstalled,
  cut,
  dartInputs,
  endSteps,
  flutterVersionOf,
  gitDir,
  hasPassed,
  inputsFingerprint,
  NO_PLUGINS_PROBE,
  noPluginsProblem,
  passKey,
  pinnedFlutterBin,
  pinnedSdkPath,
  processAlive,
  pubspecDependencies,
  recordStepPass,
  releaseLock,
  removeIf,
  ROOT_FILES,
  stepLine,
  stepTable,
  turboNote,
  waitForLock,
  withDependents,
} from './verify-support.mjs';

const CI = Boolean(process.env.CI);
const ROOT = path.resolve('.');
const startedAt = Date.now();

// ---------------------------------------------------------------- arguments

const PARTS = ['contract', 'format', 'typescript', 'lint', 'e2e', 'server', 'dart', 'flutter'];
const USAGE =
  `Usage: node scripts/verify.mjs [${PARTS.join('|')}]... [--shard=<index>/<count>] [--package=<name>]` +
  ' | --changed[=<ref>]; and --serial, --no-wait, --fresh';
const args = process.argv.slice(2);
const SWITCHES = ['--serial', '--no-wait', '--fresh'];
const serial = CI || args.includes('--serial');
const fresh = args.includes('--fresh');
const changed = args.find((arg) => /^--changed(=[\w./^~-]+)?$/.test(arg));
const shard = args.find((arg) => arg.startsWith('--shard='))?.slice('--shard='.length);
const e2ePackage = args.find((arg) => arg.startsWith('--package='))?.slice('--package='.length);
const named = args.filter(
  (arg) =>
    !SWITCHES.includes(arg) &&
    arg !== changed &&
    !arg.startsWith('--shard=') &&
    !arg.startsWith('--package='),
);

function usage(message) {
  console.error(`verify: ${message}\n${USAGE}`);
  process.exit(1);
}

const unknown = named.filter((arg) => !PARTS.includes(arg));
if (unknown.length > 0) usage(`unknown argument ${unknown.join(' ')}.`);
if (shard !== undefined && !/^\d+\/\d+$/.test(shard)) usage(`unknown argument --shard=${shard}.`);
if (changed && (named.length > 0 || shard !== undefined || e2ePackage !== undefined))
  usage('--changed takes no part, shard or package: it picks them from the change.');
// The whole check: every part but lint and e2e, which typescript covers.
const ALL = PARTS.filter((part) => part !== 'lint' && part !== 'e2e');
const parts = new Set(named.length > 0 ? named : changed ? [] : ALL);
// A shard of one part: with any other part it would cut that one too.
if (shard !== undefined && !(parts.size === 1 && (parts.has('server') || parts.has('flutter'))))
  usage('--shard needs exactly one of the parts server and flutter.');
if (e2ePackage !== undefined && !(parts.size === 1 && parts.has('e2e')))
  usage('--package needs exactly the part e2e.');

// ---------------------------------------------------------------- the lock

// One check at a time in a folder (docs/archive/claude-code-workflow.md, phase 6): two
// at once share the Playwright ports and write packages/core_api together.
// A check waits for the one running (up to LOCK_WAIT_MS); `--no-wait`, or the
// wait running out, exits 3. A lock whose process is gone is taken over.
const BUSY = 3;
const LOCK_WAIT_MS = 20 * 60 * 1000;
const lockDir = gitDir();
if (!lockDir) {
  console.error('verify: run it inside the repository, with git 2.31 or later.');
  process.exit(1);
}
const lockFile = path.join(lockDir, 'verify.lock');

// ---------------------------------------------------------------- no orphans

// Every step runs as a process tree (a shell, pnpm, Vitest's workers, a
// browser, a `vite preview`, the Dart analyzer). Whatever ends verify (a
// failure, Ctrl+C, a closed terminal, its parent ending) ends those trees
// too, and releases the lock. A hard kill of verify itself, which on Windows
// is what a hard kill of a Node parent does to it, is left to the watchdog
// (verify-watchdog.mjs): verify keeps its running steps' ids in `stateFile`.
const children = new Set();
const stateFile = path.join(lockDir, 'verify-steps.json');
// A second early, against the rounding of the process table's start times.
const startedAtProcess = Date.now() - process.uptime() * 1000 - 1000;
// The state file belongs to the run that holds the lock: a run that waits for
// it, or gives up, never writes or removes it.
let holdsLock = false;
/** Writes the state file whole (renamed into place), with the time verify was last alive. */
function writeState() {
  if (CI || !holdsLock) return;
  try {
    const pending = `${stateFile}.${process.pid}`;
    writeFileSync(
      pending,
      JSON.stringify({
        pid: process.pid,
        started: startedAtProcess,
        alive: Date.now(),
        lock: lockFile,
        steps: [...children].map((child) => child.pid),
      }),
    );
    renameSync(pending, stateFile);
  } catch {
    // Only the watchdog reads it.
  }
}
function ownState(text) {
  try {
    return JSON.parse(text).pid === process.pid;
  } catch {
    return false;
  }
}
process.on('exit', () => {
  endSteps(
    [...children].map((child) => child.pid),
    startedAtProcess,
  );
  if (holdsLock && !CI) removeIf(stateFile, (text) => ownState(text));
  releaseLock(lockFile);
});
for (const [signal, code] of [
  ['SIGINT', 130],
  ['SIGTERM', 143],
  ['SIGHUP', 129],
  ['SIGBREAK', 149],
]) {
  process.on(signal, () => process.exit(code));
}
// A parent killed without a signal to us (the Stop hook's timeout, a closed
// tool call) leaves verify running alone: notice it and stop.
const parent = process.ppid;
if (parent > 1) {
  setInterval(() => {
    if (processAlive(parent)) return;
    console.error('verify: the process that started it ended; ending the checks.');
    process.exit(129);
  }, 2000).unref();
}

const describeHolder = ({ pid, command, started } = {}) =>
  `process ${pid ?? '?'}, \`verify.mjs ${command ?? ''}\`, started ${started ?? '?'}`;
const lock = await waitForLock(lockFile, {
  command: args.join(' '),
  wait: !args.includes('--no-wait'),
  limitMs: LOCK_WAIT_MS,
  onWait: (holder) =>
    console.error(
      `verify: waiting for another check in this folder to end (${describeHolder(holder)});` +
        ` up to ${LOCK_WAIT_MS / 60_000} min. --no-wait exits at once instead.`,
    ),
});
if (!lock.taken) {
  console.error(
    `verify: another check is running in this folder (${describeHolder(lock.holder)}).` +
      ' Wait for it to end, then run this one again.' +
      ` If no check is running, delete ${lockFile.replaceAll('\\', '/')}.`,
  );
  process.exit(BUSY);
}
holdsLock = true;
if (!CI) {
  writeState();
  // The time verify was last alive, for the watchdog's guard against reused ids.
  setInterval(writeState, 5000).unref();
  spawn(
    process.execPath,
    [path.join(import.meta.dirname, 'verify-watchdog.mjs'), String(process.pid), stateFile],
    {
      detached: true,
      stdio: 'ignore',
      // Not in the checkout: a process whose folder is there keeps it from being removed.
      cwd: os.tmpdir(),
    },
  ).unref();
}

// ---------------------------------------------------------------- the pinned Flutter

// `fvm install` links the Flutter pinned in .fvmrc at .fvm/flutter_sdk; use it,
// or the main checkout's in a worktree, before any Flutter on PATH, with its
// Dart SDK's own bin first (dart.exe, not the slow dart.bat wrapper; Pub finds
// Flutter through FLUTTER_ROOT then). CI puts the pinned Flutter on PATH instead.
const fvmFlutter = pinnedFlutterBin(ROOT);
const sdkPath = pinnedSdkPath(fvmFlutter);
if (sdkPath.length > 0) {
  process.env.PATH = [...sdkPath, process.env.PATH].join(path.delimiter);
  process.env.FLUTTER_ROOT = path.dirname(fvmFlutter);
}

// ---------------------------------------------------------------- running steps

// The record of the steps that passed, by the fingerprint of their inputs, and
// each run's logs: in the git folder, outside the tree.
const passesFile = path.join(lockDir, 'verify-passes.json');
const runDir = CI ? null : newRunFolder();
const rows = [];
const failures = [];
let stepCount = 0;

function newRunFolder() {
  const runs = path.join(lockDir, 'verify-runs');
  mkdirSync(runs, { recursive: true });
  // Keep the last ten runs.
  for (const old of readdirSync(runs).sort().slice(0, -9))
    rmSync(path.join(runs, old), { recursive: true, force: true });
  const dir = path.join(runs, new Date().toISOString().replace(/[:.]/g, '-'));
  mkdirSync(dir);
  return dir;
}

const shown = (file) => file.replaceAll('\\', '/');

/** Keeps a running step in `children` and in the watchdog's state file. */
function track(child) {
  children.add(child);
  writeState();
  const forget = () => {
    if (children.delete(child)) writeState();
  };
  child.on('error', forget);
  child.on('close', forget);
}

/**
 * Runs a shell command as its own process tree; resolves to its exit code.
 * After `timeoutMs` the tree is ended and the step fails (124), so a check
 * that stops answering fails with a message instead of holding the run.
 */
function spawnCommand(command, { cwd, env, stdio, timeoutMs }) {
  const say = (text) =>
    typeof stdio[1] === 'number' ? writeSync(stdio[1], `\n${text}\n`) : console.error(text);
  return new Promise((resolve) => {
    const child = spawn(command, {
      shell: true,
      cwd,
      env,
      stdio,
      // A process group of its own on POSIX, so it can be ended whole.
      detached: process.platform !== 'win32',
    });
    track(child);
    let timedOut = false;
    const timer =
      timeoutMs &&
      setTimeout(() => {
        timedOut = true;
        endSteps([child.pid], startedAtProcess);
      }, timeoutMs);
    child.on('error', (error) => {
      clearTimeout(timer);
      say(error.stack);
      resolve(1);
    });
    child.on('close', (code) => {
      clearTimeout(timer);
      if (!timedOut) return resolve(code ?? 1);
      say(`verify: ended after ${timeoutMs / 60_000} min without finishing: \`${command}\`.`);
      resolve(124);
    });
  });
}

/** Runs a command and returns its output, for the small reads between steps. */
async function capture(command, env = process.env) {
  const result = await new Promise((resolve) => {
    const child = spawn(command, { shell: true, env, detached: process.platform !== 'win32' });
    track(child);
    let stdout = '';
    let stderr = '';
    child.stdout.on('data', (data) => (stdout += data));
    child.stderr.on('data', (data) => (stderr += data));
    child.on('error', (error) => resolve({ status: 1, stdout, stderr: String(error) }));
    child.on('close', (code) => resolve({ status: code ?? 1, stdout, stderr }));
  });
  if (result.status !== 0)
    throw new StepFailure(`\`${command}\` failed:\n${result.stdout}${result.stderr}`);
  return result.stdout;
}

class StepFailure extends Error {}

function read(command) {
  const result = spawnSync(command, { shell: true, encoding: 'utf8' });
  if (result.status !== 0)
    throw new StepFailure(`\`${command}\` failed:\n${result.stdout}${result.stderr}`);
  return result.stdout;
}

function stepKey({ name, command, cwd = '.', env = process.env, inputs }) {
  return passKey({
    name,
    command,
    cwd,
    melosPackages: env.MELOS_PACKAGES ?? '',
    node: process.version,
    platform: process.platform,
    // Its version, not its folder: a worktree's link may point at another SDK later.
    flutter: inputs.flutter ? flutterForKey() : '',
    inputs: inputsFingerprint(ROOT, inputs.paths, { ignoredDirs: inputs.ignored ?? [] }),
  });
}

function report(row, log) {
  rows.push(row);
  if (!CI) console.log(stepLine(row) + (row.result === 'FAILED' && log ? `  (${shown(log)})` : ''));
}

/**
 * One step: a shell `command`, or a `check` in this process that returns
 * null or what failed. Resolves to whether it passed. With `inputs` (the
 * pathspecs it reads), a pass is recorded, and `--changed` skips the step when
 * those inputs are unchanged since a pass. In CI a failure ends the run.
 */
async function step(definition) {
  const { name, command, check, cwd = '.', env = process.env, inputs } = definition;
  const started = Date.now();
  if (CI) {
    console.log(`\n=== ${name}`);
    const failed = check
      ? await runCheck(check)
      : (await spawnCommand(command, {
          cwd,
          env,
          stdio: 'inherit',
          timeoutMs: definition.timeoutMs,
        })) !== 0;
    if (failed) {
      if (typeof failed === 'string') console.error(`\n${failed}`);
      console.error(`\nverify: failed at "${name}"`);
      process.exit(1);
    }
    return true;
  }
  let key = null;
  if (inputs) {
    key = stepKey(definition);
    if (changed && !fresh && hasPassed(passesFile, key)) {
      report({ name, result: 'unchanged', ms: Date.now() - started });
      return true;
    }
  }
  if (check) {
    const failed = await runCheck(check);
    report({ name, result: failed ? 'FAILED' : 'passed', ms: Date.now() - started });
    if (failed) failures.push({ name, message: failed });
    return !failed;
  }
  const log = path.join(runDir, `${String(++stepCount).padStart(2, '0')}-${slug(name)}.log`);
  const out = openSync(log, 'w');
  writeSync(out, `$ ${command}\n${cwd === '.' ? '' : `(in ${cwd})\n`}\n`);
  const status = await spawnCommand(command, {
    cwd,
    env,
    stdio: ['ignore', out, out],
    timeoutMs: definition.timeoutMs,
  });
  closeSync(out);
  const ms = Date.now() - started;
  if (status !== 0) {
    report({ name, result: 'FAILED', ms }, log);
    failures.push({ name, log });
    return false;
  }
  report({
    name: name + (definition.note?.(readFileSync(log, 'utf8')) ?? ''),
    result: 'passed',
    ms,
  });
  // Record the pass only if its inputs did not change while it ran.
  if (key && stepKey(definition) === key) {
    try {
      recordStepPass(passesFile, key);
    } catch {
      // A read-only git folder only costs a repeat run.
    }
  }
  return true;
}

async function runCheck(check) {
  try {
    return (await check()) ?? null;
  } catch (error) {
    if (error instanceof StepFailure) return error.message;
    throw error;
  }
}

const slug = (name) =>
  name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .slice(0, 60);

/**
 * Runs steps one after another, each given as a definition or a function that
 * returns one (or a list of them, or null), called when its turn comes. After a
 * failure the rest are listed as not run.
 */
async function sequence(steps) {
  for (let i = 0; i < steps.length; i++) {
    let next;
    try {
      next = typeof steps[i] === 'function' ? await steps[i]() : steps[i];
    } catch (error) {
      if (!(error instanceof StepFailure)) throw error;
      if (CI) {
        console.error(`\n${error.message}\nverify: failed`);
        process.exit(1);
      }
      report({ name: 'Preparing the next step', result: 'FAILED', ms: 0 });
      failures.push({ name: 'Preparing the next step', message: error.message });
      return false;
    }
    for (const each of [next].flat().filter(Boolean)) {
      if (await step(each)) continue;
      for (const rest of steps.slice(i + 1))
        if (typeof rest !== 'function') report({ name: rest.name, result: 'not run' });
      return false;
    }
  }
  return true;
}

/** Runs independent parts at the same time, or one after another with --serial and in CI. */
async function together(lanes) {
  if (serial) for (const lane of lanes) await lane();
  else await Promise.all(lanes.map((lane) => lane()));
}

function skipped(name, why) {
  report({ name: `${name}: ${why}`, result: 'skipped' });
}

// ---------------------------------------------------------------- inputs

// The paths each part reads, over-approximated: a needless run is fine, a
// wrong skip is not (ROOT_FILES and the Dart part's in verify-support.mjs).
const pathspec = (entry) => (entry.endsWith('/**') ? entry.slice(0, -3) : entry);
const SERVER_INPUTS = {
  paths: ['apps/server', ...READ_BY_SERVER_TESTS.map(pathspec), ...ROOT_FILES],
};

// ---------------------------------------------------------------- the format checks

// Claude Code loads a folder's CLAUDE.md whenever it reads a file there and
// resends it every turn after (docs/process/development-workflow.md §8): keep
// the instruction files small. What a feature does goes in docs/code instead.
// A path-scoped rule in .claude/rules loads the same way.
const INSTRUCTION_LIMITS = [
  { test: (file) => file === 'CLAUDE.md', bytes: 10_240 },
  { test: (file) => file.endsWith('/CLAUDE.md'), bytes: 4_096 },
  { test: (file) => file.startsWith('.claude/rules/'), bytes: 4_096 },
];

function checkInstructionSizes() {
  const files = read(
    'git ls-files --cached --others --exclude-standard -- CLAUDE.md "*/CLAUDE.md" ".claude/rules/*.md"',
  )
    .split(/\r?\n/)
    .filter((file) => file && existsSync(file));
  const tooBig = files.flatMap((file) => {
    const limit = INSTRUCTION_LIMITS.find((each) => each.test(file));
    const bytes = readFileSync(file).length;
    return limit && bytes > limit.bytes ? [`${file}: ${bytes} bytes, at most ${limit.bytes}`] : [];
  });
  if (tooBig.length === 0) return null;
  return `${tooBig.join('\n')}\nKeep only the rules for working in the folder; move what features do to docs/code/<folder path>.md.`;
}

// The Node tests of the Claude Code hooks and of the scripts here: seconds.
const SCRIPT_TESTS = {
  name: 'Claude Code hooks and scripts',
  command:
    'node --test .claude/hooks/hooks.test.mjs scripts/classify-changes.test.mjs scripts/verify-support.test.mjs scripts/green-tree.test.mjs scripts/fonts.test.mjs scripts/font-metrics.test.mjs scripts/server-test-readers.test.mjs scripts/turbo-inputs.test.mjs scripts/baselines.test.mjs scripts/dependency-pins.test.mjs scripts/parity-report.test.mjs',
};

function formatSteps(files) {
  const steps = [{ name: 'Instruction file sizes', check: checkInstructionSizes }, SCRIPT_TESTS];
  if (!files) return [...steps, { name: 'Prettier', command: 'pnpm exec prettier --check .' }];
  const present = files.filter((file) => existsSync(file)).map((file) => `"${file}"`);
  const prettierConfig = files.some((file) => /^\.prettier|^package\.json$/.test(file));
  // cmd.exe takes 8,191 characters at most: a longer list checks everything.
  if (prettierConfig || present.join(' ').length > 7_000)
    steps.push({ name: 'Prettier', command: 'pnpm exec prettier --check .' });
  else if (present.length > 0)
    steps.push({
      name: 'Prettier, changed files',
      command: `pnpm exec prettier --check --ignore-unknown ${present.join(' ')}`,
    });
  return steps;
}

// ---------------------------------------------------------------- generated files

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

/**
 * A generator step, then a check that it changed none of the committed files
 * under `paths`. The generator reads `inputs` (its outputs among them): with
 * `--changed` it is skipped when they are unchanged since it passed.
 */
function generated(name, command, cwd, paths, stale, inputs) {
  let before;
  return [
    () => {
      before = fingerprint(paths);
      return { name, command, cwd, inputs };
    },
    () => ({
      name: `${name}: committed files current`,
      check: () => (fingerprint(paths) === before ? null : stale),
    }),
  ];
}

// Architecture §5.3, E6: the committed OpenAPI document and both clients must
// match the server. Regenerating changes no file when they do; otherwise the
// regenerated files are left in place to review and commit.
const contractSteps = () =>
  generated(
    'Generate the API contract and clients',
    'pnpm generate:api',
    '.',
    'packages/api-schema packages/core_api',
    'The committed OpenAPI document or a generated client was stale. It is regenerated' +
      ' now: review the changes in packages/api-schema and packages/core_api and commit them.' +
      ' A second run passes locally, but CI fails until they are committed.',
    // 4 min on 2026-11-25 (the server's build, then the Java generator).
    { paths: ['apps/server', 'packages/api-schema', 'packages/core_api', ...ROOT_FILES] },
  );

// Architecture §11.2: the committed localizations must match the ARB files.
const localizationSteps = () =>
  generated(
    'Generate the Flutter localizations',
    'flutter gen-l10n',
    'packages/core_l10n',
    'packages/core_l10n/lib',
    'The committed localizations in packages/core_l10n/lib/src/generated were stale.' +
      ' They are regenerated now: review and commit them.',
  );

// ---------------------------------------------------------------- TypeScript

// Turborepo replays a task whose inputs did not change (turbo.json); CI and
// --fresh run every task again.
// (`--force` alone would take the next task's name as its value.) Locally the
// log holds each task's output in one piece and a replayed task as one line.
// A failing task still stops the rest: the fix changes the package's inputs,
// so its other tasks would run again anyway.
const TURBO = `pnpm exec turbo run${CI || fresh ? ' --force=true' : ''}${
  CI ? '' : ' --output-logs=new-only --log-order=grouped'
}`;
const LINT_TASKS = 'lint:root lint typecheck';
const E2E_TASKS = 'build test:e2e';
// The web apps' smoke tests run in Chromium; this downloads it once. One app
// at a time: two installs at once race on the shared browser cache. Skipped
// locally when the pinned Chromium is already complete.
function playwrightStep() {
  if (!CI && chromiumInstalled(['apps/admin', 'apps/merchant-portal', 'packages/ui-web']))
    return null;
  return {
    name: 'Playwright browser',
    command:
      'pnpm --workspace-concurrency=1 --filter @fox-drop/admin --filter @fox-drop/merchant-portal --filter @fox-drop/ui-web exec playwright install chromium',
  };
}

const turbo = (name, tasks, filters = '') => ({
  name,
  command: `${TURBO} ${tasks}${filters ? ` ${filters}` : ''}`,
  note: turboNote,
});

const NOT_SERVER = '--filter="!@fox-drop/server"';
const OTHER_TESTS = "Tests other than the server's (Turborepo)";
// `typescript` is `lint` and `e2e` together, run as today: one Turborepo run
// for the lint, type check, build and smoke tests, then the other tests.
const typescriptSteps = () => [
  playwrightStep,
  turbo('Lint, type check, build and smoke test (Turborepo)', `${LINT_TASKS} ${E2E_TASKS}`),
  turbo(OTHER_TESTS, 'test', NOT_SERVER),
];
const lintSteps = () => [
  turbo('Lint and type check (Turborepo)', LINT_TASKS),
  turbo(OTHER_TESTS, 'test', NOT_SERVER),
];
const e2eSteps = () => [
  playwrightStep,
  turbo(
    `Build and smoke test${e2ePackage ? `, ${e2ePackage}` : ''} (Turborepo)`,
    E2E_TASKS,
    e2ePackage ? `--filter="${e2ePackage}"` : '',
  ),
];

// ---------------------------------------------------------------- Dart

// One `melos list` gives the workspace: each package's name, folder and kind
// (Melos's type 0 is a pure Dart package); the dependencies come from the
// pubspec files. Melos sees only the packages listed in the root pubspec.yaml
// `workspace:`, so a Dart package missing from that list would never be
// checked: that is a failure.
async function dartWorkspace() {
  const listed = JSON.parse(await capture('dart run melos list --json'));
  const workspace = listed.map((each) => {
    const dir = path.relative(ROOT, each.location).replaceAll('\\', '/');
    return {
      name: each.name,
      dir,
      flutter: each.type !== 0,
      hasTests: existsSync(path.join(dir, 'test')),
      dependencies: pubspecDependencies(readFileSync(path.join(dir, 'pubspec.yaml'), 'utf8')),
    };
  });
  const normal = (dir) => (process.platform === 'win32' ? dir.toLowerCase() : dir);
  const known = new Set(workspace.map((each) => normal(each.dir)));
  const missing = ['apps', 'packages', 'tools']
    .filter((dir) => existsSync(dir))
    .flatMap((dir) => readdirSync(dir).map((name) => `${dir}/${name}`))
    .filter((dir) => existsSync(path.join(dir, 'pubspec.yaml')) && !known.has(normal(dir)));
  if (missing.length > 0)
    throw new StepFailure(`Not in the root pubspec.yaml workspace: ${missing.join(', ')}`);
  return workspace;
}

// A mismatch only warns locally, but fails in CI, which must run the pinned version.
let flutterVersion;
/** The Flutter that runs the checks: the pinned SDK's own record answers at once, `flutter --version` takes seconds. */
function installedFlutter() {
  flutterVersion ??=
    flutterVersionOf(fvmFlutter) ??
    JSON.parse(read('flutter --version --machine')).frameworkVersion;
  return flutterVersion;
}

/** The Flutter version for a pass key; a fresh value, so no pass matches, when none answers. */
function flutterForKey() {
  try {
    return installedFlutter();
  } catch {
    return `unknown ${Date.now()}`;
  }
}

function checkFlutterVersion() {
  const pinned = JSON.parse(readFileSync('.fvmrc', 'utf8')).flutter;
  const installed = installedFlutter();
  if (installed === pinned) return null;
  const message =
    `Flutter ${installed} is installed, .fvmrc pins ${pinned}.` +
    (fvmFlutter
      ? ''
      : ' Run `fvm install` in the main checkout; a worktree uses its .fvm/flutter_sdk.');
  if (CI) return message;
  console.warn(`verify: warning: ${message}`);
  return null;
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
function flutterShard(workspace, spec) {
  const [index, count] = spec.split('/').map(Number);
  if (index < 1 || index > count) usage(`--shard=${spec} names no shard.`);
  const names = workspace.filter((each) => each.flutter && each.hasTests).map((each) => each.name);
  if (names.length === 0) throw new StepFailure('Melos lists no Flutter package with tests.');
  const seconds = (name) => FLUTTER_TEST_SECONDS[name] ?? UNLISTED_SECONDS;
  const shards = Array.from({ length: count }, () => ({ seconds: 0, names: [] }));
  for (const name of names.sort((a, b) => seconds(b) - seconds(a) || a.localeCompare(b))) {
    const lightest = shards.reduce((least, each) => (each.seconds < least.seconds ? each : least));
    lightest.names.push(name);
    lightest.seconds += seconds(name);
  }
  return shards[index - 1].names;
}

/** A Melos script over the named packages (Melos scopes a script to MELOS_PACKAGES). */
function melosStep(name, script, names, inputs) {
  if (names.length === 0) return null;
  return {
    name,
    command: `dart run melos run ${script} --no-select`,
    env: { ...process.env, MELOS_PACKAGES: names.join(',') },
    inputs,
  };
}

// ---------------------------------------------------------------- --changed

async function verifyChanged(since) {
  const base = read(`git merge-base ${since} HEAD`).trim();
  const files = changedFiles(base);
  console.log(`verify: ${files.length} files changed since ${since} (${base.slice(0, 9)})`);
  if (files.length === 0) return;
  const touched = classify(files);
  console.log(
    `verify: the change touches ${
      Object.keys(touched)
        .filter((key) => touched[key])
        .join(', ') || 'Markdown only'
    }`,
  );
  console.log(`verify: each step's whole output goes to ${shown(runDir)}`);

  await sequence(formatSteps(files));
  if (touched.contract) await sequence(contractSteps());

  // The changed packages and every package that depends on one, committed or
  // not. A doc the design tokens' tests read lies outside every package, so
  // Turborepo sees no change: name the package and its dependents (PR 274,
  // a §9.5 change that passed here and failed the guide test in CI).
  const tokenDocs = touched.tokenDocs ? ' --filter="...@fox-drop/design-tokens"' : '';
  const affected = `--filter="...[${base}]"${tokenDocs}`;
  const scope = serverTestScope(files, base, (file) => classify([file]).server);
  await together([
    () =>
      touched.typescript
        ? sequence([
            playwrightStep,
            turbo(
              'Lint, type check, build and smoke test, affected packages (Turborepo)',
              `${LINT_TASKS} ${E2E_TASKS}`,
              affected,
            ),
            turbo(
              "Tests other than the server's, affected packages (Turborepo)",
              'test',
              `${affected} ${NOT_SERVER}`,
            ),
          ])
        : skipped('TypeScript', 'no change it can break'),
    () => {
      if (!touched.server) return skipped('Server tests', 'no change they read');
      if (scope === null) return skipped('Server tests', 'no server test reads the changed files');
      return sequence([
        {
          name: `Server tests: ${scope || 'all'}`,
          command:
            scope === ''
              ? 'pnpm --filter @fox-drop/server test'
              : `pnpm --filter @fox-drop/server exec vitest run ${scope} --passWithNoTests`,
          inputs: SERVER_INPUTS,
        },
      ]);
    },
    () =>
      touched.dartScope
        ? dartChanged(files, touched.dartScope)
        : skipped('Dart', 'no change it can break'),
  ]);
  imageBaselines(files, since);
}

// The image baselines take minutes in Docker, so verify does not run them:
// `pnpm baselines` does, and records the tree it checked. The table says
// whether this tree's images are checked (CI's `visual` and `golden` jobs are
// the gate).
function imageBaselines(files, since) {
  const status = imageStatus(files, { since });
  const result = !status.ok
    ? 'UNCHECKED'
    : status.line.startsWith('no change')
      ? 'skipped'
      : 'checked';
  report({ name: `Image baselines: ${status.line}`, result });
}

async function dartChanged(files, dartScope) {
  let workspace;
  let scoped;
  let inputs;
  return sequence([
    { name: 'Flutter version', check: checkFlutterVersion },
    {
      name: 'Dart workspace',
      check: async () => {
        workspace = await dartWorkspace();
        inputs = dartInputs(workspace);
        // The changed Dart packages and the packages that depend on them, or all.
        // Melos's own --diff sees commits only, not the working tree.
        const changedNames = changedDartPackages(workspace, files);
        scoped =
          dartScope === 'all'
            ? workspace
            : workspace.filter((each) => withDependents(workspace, changedNames).has(each.name));
        return null;
      },
    },
    ...(files.some((file) => file.startsWith('packages/core_l10n/')) ? localizationSteps() : []),
    NO_PLUGINS_STEP,
    () => scoped.length > 0 && analyzeStep(scoped, workspace, inputs),
    () => foxLintsStep(inputs),
    () =>
      scoped.length > 0 && {
        name: `Dart format, ${scopeLabel(scoped, workspace)}`,
        command: `dart format --output=none --set-exit-if-changed ${scoped.map((each) => each.dir).join(' ')}`,
        inputs,
      },
    () =>
      melosStep(
        `Dart tests, ${scopeLabel(scoped, workspace)}`,
        'test:dart',
        scoped.filter((each) => !each.flutter && each.hasTests).map((each) => each.name),
        inputs,
      ),
    () =>
      melosStep(
        `Flutter tests, ${scopeLabel(scoped, workspace)}`,
        'test:flutter',
        scoped.filter((each) => each.flutter && each.hasTests).map((each) => each.name),
        inputs,
      ),
  ]);
}

const scopeLabel = (scoped, workspace) =>
  scoped.length === workspace.length
    ? 'all packages'
    : `${scoped.length} changed or dependent packages`;

// The analyzer without the fox_lints plugin (`--no-plugins`, the editor's:
// it re-resolves the whole workspace on every run), whose rules the check
// runs on its own (foxLintsStep). One analyzer process over the changed
// packages and their dependents: 11 s against 23 s over the workspace for
// core_ui's six (2026-11-25, warm).
function analyzeStep(scoped, workspace, inputs) {
  const all = scoped.length === workspace.length;
  return {
    name: `Dart analyze, ${scopeLabel(scoped, workspace)}`,
    command: `dart analyze --fatal-infos --no-plugins${all ? '' : ` ${scoped.map((each) => each.dir).join(' ')}`}`,
    inputs,
    timeoutMs: ANALYZE_LIMIT_MS,
  };
}

// An SDK whose `dart analyze` lacks the undocumented --no-plugins stops here,
// with what to do (noPluginsProblem), before any analysis.
const NO_PLUGINS_STEP = {
  name: 'Dart analyze takes --no-plugins',
  check: () => noPluginsProblem(spawnSync(NO_PLUGINS_PROBE, { shell: true, encoding: 'utf8' })),
};

// The fox_lints rules (architecture §9.5 R2, R5) over the packages they
// enforce, as the analyzer plugin runs them in the editor
// (packages/fox_lints/CLAUDE.md): it compiles itself once per change to
// fox_lints, pubspec.lock or the SDK (35 s), then takes 2.5 s.
const foxLintsStep = (inputs) => ({
  name: 'fox_lints rules',
  command: 'dart packages/fox_lints/tool/check.dart',
  inputs,
  timeoutMs: ANALYZE_LIMIT_MS,
});

// A cold analysis of the workspace took 7 min 13 s on 2026-11-25 in a new
// worktree, without the plugin too (the analyzer's cache does not follow a new
// folder); warm, 20 to 36 s. One that runs far longer has stopped answering.
const ANALYZE_LIMIT_MS = 15 * 60 * 1000;

// ---------------------------------------------------------------- the parts

async function verifyParts() {
  if (!CI)
    console.log(
      `verify: ${[...parts].join(', ')}; each step's whole output goes to ${shown(runDir)}`,
    );
  if (parts.has('contract')) await sequence(contractSteps());
  if (parts.has('format')) await sequence(formatSteps(null));

  const typescript = parts.has('typescript');
  await together([
    async () => {
      if (CI && typescript && parts.has('server') && shard === undefined) {
        // One Turborepo run, so the server's tests overlap the rest.
        return sequence([
          playwrightStep,
          turbo(
            'Lint, type check, test, build and smoke test (Turborepo)',
            `${LINT_TASKS} ${E2E_TASKS} test`,
          ),
        ]);
      }
      if (typescript) return sequence(typescriptSteps());
      if (parts.has('lint')) await sequence(lintSteps());
      if (parts.has('e2e')) await sequence(e2eSteps());
    },
    async () => {
      if (!parts.has('server') || (CI && typescript && shard === undefined)) return;
      await sequence([
        {
          name: `Server tests${shard ? `, shard ${shard}` : ''}`,
          command: `pnpm --filter @fox-drop/server test${shard ? ` --shard=${shard}` : ''}`,
          inputs: SERVER_INPUTS,
        },
      ]);
    },
    async () => {
      if (!parts.has('dart') && !parts.has('flutter')) return;
      let workspace;
      await sequence([
        { name: 'Flutter version', check: checkFlutterVersion },
        {
          name: 'Dart workspace',
          check: async () => {
            workspace = await dartWorkspace();
            return null;
          },
        },
        ...(parts.has('dart')
          ? [
              ...localizationSteps(),
              NO_PLUGINS_STEP,
              // `dart analyze --fatal-infos --no-plugins`, then the fox_lints rules.
              () => ({
                name: 'Dart analyze and the fox_lints rules',
                command: 'dart run melos run analyze --no-select',
                inputs: dartInputs(workspace),
                timeoutMs: ANALYZE_LIMIT_MS,
              }),
              () => ({
                name: 'Dart format',
                command: 'dart run melos run format:check --no-select',
                inputs: dartInputs(workspace),
              }),
              () =>
                workspace.some((each) => !each.flutter && each.hasTests) && {
                  name: 'Dart tests',
                  command: 'dart run melos run test:dart --no-select',
                  inputs: dartInputs(workspace),
                },
            ]
          : []),
        ...(parts.has('flutter')
          ? [
              () => {
                if (shard === undefined)
                  return (
                    workspace.some((each) => each.flutter && each.hasTests) && {
                      name: 'Flutter tests',
                      command: 'dart run melos run test:flutter --no-select',
                      inputs: dartInputs(workspace),
                    }
                  );
                const packages = flutterShard(workspace, shard);
                if (packages.length === 0) {
                  console.log(`\n=== Flutter tests, shard ${shard}: no package`);
                  return null;
                }
                return melosStep(
                  `Flutter tests, shard ${shard}: ${packages.join(', ')}`,
                  'test:flutter',
                  packages,
                  dartInputs(workspace),
                );
              },
            ]
          : []),
      ]);
    },
  ]);
}

// ---------------------------------------------------------------- the end

// The tree as it was when the check started: a passing `--changed` or full run records it, so
// the Stop hook does not check the same tree again (green-tree.mjs). Not in CI.
const treeBefore = CI ? null : treeState(ROOT);

/** Records the tree as green, unless it changed while the checks ran (an edit mid-run). */
function recordGreenTree() {
  if (!treeBefore) return;
  if (treeState(ROOT)?.fingerprint !== treeBefore.fingerprint) return;
  try {
    recordGreen(ROOT, treeBefore.fingerprint);
  } catch {
    // A read-only state folder only costs the Stop hook a repeat run.
  }
}

if (changed) {
  const since = changed.split('=')[1] ?? 'origin/main';
  await verifyChanged(since);
} else {
  await verifyParts();
}

if (!CI && rows.length > 0) console.log(`\n${stepTable(rows, Date.now() - startedAt)}`);
if (failures.length > 0) {
  for (const failure of failures) {
    console.error(
      `\n=== ${failure.name}: failed${failure.log ? ` (whole output: ${shown(failure.log)})` : ''}`,
    );
    console.error(
      failure.log ? cut(readFileSync(failure.log, 'utf8'), shown(failure.log)) : failure.message,
    );
  }
  console.error(`\nverify: failed: ${failures.map((failure) => failure.name).join('; ')}`);
  process.exit(1);
}
// Only the whole check proves the tree; a part or a shard does not. The Stop
// hook compares with origin/main: a check against another base proves nothing for it.
if (changed ? (changed.split('=')[1] ?? 'origin/main') === 'origin/main' : named.length === 0)
  recordGreenTree();
console.log(
  changed
    ? '\nverify: the checks of the change passed'
    : `\nverify: ${named.length > 0 ? [...parts].join(', ') : 'all checks'} passed`,
);
process.exit(0);
