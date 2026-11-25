// What scripts/verify.mjs and the Claude Code hooks share: the lock that keeps
// two checks from running at once in one folder, and the pinned Flutter SDK.
// Also verify.mjs's own pieces that a test can reach: the record of the steps
// that passed on unchanged inputs, the cut of a failing step's output, the
// summary table and the end of a process tree.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import {
  existsSync,
  linkSync,
  readdirSync,
  readFileSync,
  renameSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';

/** Whether a process with this id is running. */
export function processAlive(pid) {
  try {
    process.kill(pid, 0);
    return true;
  } catch (error) {
    return error.code === 'EPERM';
  }
}

/**
 * Takes the lock file for this process: { taken: true }, or { taken: false,
 * holder } while another running process holds it. The file appears whole or
 * not at all (a hard link of a written file), so a reader never sees it half
 * written. A lock is stale, and taken over, when its process is gone or it is
 * older than any check (a hard kill skips the release, and Windows soon gives
 * its process id to another process).
 */
export function takeLock(
  file,
  { pid = process.pid, command = '', isAlive = processAlive, now = Date.now() } = {},
) {
  const pending = `${file}.${pid}`;
  writeFileSync(pending, JSON.stringify({ pid, command, started: new Date(now).toISOString() }));
  try {
    for (let attempt = 0; attempt < 3; attempt++) {
      try {
        linkSync(pending, file);
        return { taken: true };
      } catch (error) {
        if (error.code !== 'EEXIST') throw error;
      }
      const seen = readText(file);
      if (seen === null) continue; // released meanwhile: link again
      const holder = parse(seen);
      const age = now - Date.parse(holder?.started ?? '');
      if (holder && isAlive(holder.pid) && age < STALE_AFTER_MS) return { taken: false, holder };
      // Remove the stale lock only if it is still the one read, not a fresh one.
      if (readText(file) === seen) rmSync(file, { force: true });
    }
    return { taken: false, holder: parse(readText(file)) };
  } finally {
    rmSync(pending, { force: true });
  }
}

// The Stop hook gives a check 10 minutes and a full check takes under one hour.
const STALE_AFTER_MS = 3 * 60 * 60 * 1000;

/** Removes the lock file if this process holds it. */
export function releaseLock(file, pid = process.pid) {
  if (parse(readText(file))?.pid === pid) rmSync(file, { force: true });
}

function readText(file) {
  try {
    return readFileSync(file, 'utf8');
  } catch {
    return null;
  }
}

function parse(text) {
  try {
    return JSON.parse(text);
  } catch {
    return null;
  }
}

/** This folder's own git directory (a worktree has its own), where the lock lives. */
export function gitDir(cwd = '.') {
  return gitPath(['rev-parse', '--path-format=absolute', '--git-dir'], cwd);
}

function gitCommonDir(cwd) {
  return gitPath(['rev-parse', '--path-format=absolute', '--git-common-dir'], cwd);
}

function gitPath(args, cwd) {
  const result = spawnSync('git', args, { cwd, encoding: 'utf8' });
  return result.status === 0 ? path.resolve(result.stdout.trim()) : null;
}

/**
 * The bin folder of the Flutter pinned in .fvmrc: this checkout's
 * .fvm/flutter_sdk (`fvm install` links it), else the main checkout's when
 * this is a worktree, which `fvm install` never ran in. Null when neither has
 * one (CI puts the pinned Flutter on PATH instead).
 */
export function pinnedFlutterBin(root, commonDirOf = gitCommonDir) {
  const own = path.join(root, '.fvm', 'flutter_sdk', 'bin');
  if (existsSync(own)) return own;
  const commonDir = commonDirOf(root);
  if (!commonDir) return null;
  const main = path.join(path.dirname(commonDir), '.fvm', 'flutter_sdk', 'bin');
  return existsSync(main) ? main : null;
}

/**
 * The folders to put first on PATH for the pinned Flutter: its Dart SDK's bin
 * (`dart.exe` there starts in 75 ms; Flutter's `bin/dart.bat` wrapper costs
 * 1.1 s a call on Windows), then Flutter's own bin. Only the folders that exist.
 */
export function pinnedSdkPath(flutterBin) {
  if (!flutterBin) return [];
  const dart = path.join(flutterBin, 'cache', 'dart-sdk', 'bin');
  return [dart, flutterBin].filter((dir) => existsSync(dir));
}

/**
 * The folders `playwright install chromium` fills, from playwright-core's
 * browsers.json: Chromium, its headless shell, FFmpeg and, on Windows, winldd.
 */
export function chromiumFolders(browsers, platform = process.platform) {
  const wanted = ['chromium', 'chromium-headless-shell', 'ffmpeg'];
  if (platform === 'win32') wanted.push('winldd');
  return wanted.map((name) => {
    const browser = browsers.browsers.find((each) => each.name === name);
    return browser ? `${name.replaceAll('-', '_')}-${browser.revision}` : null;
  });
}

/**
 * Whether the Chromium that the Playwright of each package (folders with a
 * package.json) installs is already complete in the shared browser cache, so
 * the install step can be skipped. Anything unexpected answers false: the
 * install runs.
 */
export function chromiumInstalled(
  packageDirs,
  { env = process.env, platform = process.platform } = {},
) {
  const home = env.USERPROFILE ?? env.HOME ?? '';
  const cache =
    env.PLAYWRIGHT_BROWSERS_PATH ??
    (platform === 'win32'
      ? path.join(env.LOCALAPPDATA ?? path.join(home, 'AppData', 'Local'), 'ms-playwright')
      : platform === 'darwin'
        ? path.join(home, 'Library', 'Caches', 'ms-playwright')
        : path.join(env.XDG_CACHE_HOME ?? path.join(home, '.cache'), 'ms-playwright'));
  if (cache === '0') return false;
  try {
    return packageDirs.every((dir) => {
      const from = (file) => createRequire(path.resolve(file));
      const test = from(path.join(dir, 'package.json')).resolve('@playwright/test/package.json');
      const playwright = from(test).resolve('playwright/package.json');
      const core = from(playwright).resolve('playwright-core/package.json');
      const browsers = JSON.parse(
        readFileSync(path.join(path.dirname(core), 'browsers.json'), 'utf8'),
      );
      return chromiumFolders(browsers, platform).every(
        (folder) => folder && existsSync(path.join(cache, folder, 'INSTALLATION_COMPLETE')),
      );
    });
  } catch {
    return false;
  }
}

/**
 * Waits for the folder's lock: resolves to takeLock's answer once taken, or once
 * `limitMs` passed (or at once without `wait`) with the holder. `onWait` hears
 * each new holder once. A stale lock is taken over at the first try (takeLock).
 */
export async function waitForLock(
  file,
  {
    command = '',
    wait = true,
    limitMs = 20 * 60 * 1000,
    everyMs = 2000,
    onWait = () => {},
    take = takeLock,
    now = Date.now,
    sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms)),
  } = {},
) {
  const start = now();
  let told = null;
  for (;;) {
    const lock = take(file, { command });
    if (lock.taken || !wait || now() - start >= limitMs) return lock;
    const holder = JSON.stringify(lock.holder ?? null);
    if (holder !== told) onWait(lock.holder);
    told = holder;
    await sleep(everyMs);
  }
}

/**
 * Ends a process and every process it started, at once: on Windows `taskkill
 * /T /F` (a shell's children outlive it otherwise), elsewhere its process group
 * (verify.mjs starts each step as a group of its own), else the process.
 */
export function killTree(pid, platform = process.platform) {
  if (pid) killTrees([pid], platform);
}

/** killTree for several processes; on Windows in one taskkill (each call costs about a second). */
export function killTrees(pids, platform = process.platform) {
  if (pids.length === 0) return;
  if (platform === 'win32') {
    spawnSync('taskkill', [...pids.flatMap((pid) => ['/PID', String(pid)]), '/T', '/F'], {
      stdio: 'ignore',
    });
    return;
  }
  for (const pid of pids) {
    for (const target of [-pid, pid]) {
      try {
        process.kill(target, 'SIGKILL');
        break;
      } catch {
        // No such group: try the process alone.
      }
    }
  }
}

/**
 * The processes of `table` ({ pid, ppid, created } in ms) that descend from
 * one of the `roots` (pids) and started at or after `since`, the live roots
 * included. A root may be gone already: its children still name it as their
 * parent. The time guard keeps a reused process id out.
 */
export function descendants(table, roots, since) {
  const fresh = table.filter((each) => each.created >= since);
  const found = new Set(fresh.filter((each) => roots.includes(each.pid)).map((each) => each.pid));
  const parents = new Set(roots);
  let grew = true;
  while (grew) {
    grew = false;
    for (const each of fresh) {
      if (parents.has(each.ppid) && !found.has(each.pid)) {
        found.add(each.pid);
        parents.add(each.pid);
        grew = true;
      }
    }
  }
  return [...found];
}

/** Every process on Windows: { pid, ppid, created } (ms since the epoch). */
export function windowsProcessTable() {
  const result = spawnSync(
    'powershell.exe',
    [
      '-NoProfile',
      '-NonInteractive',
      '-Command',
      'Get-CimInstance Win32_Process | ForEach-Object { "$($_.ProcessId) $($_.ParentProcessId) $($_.CreationDate.ToFileTimeUtc())" }',
    ],
    { encoding: 'utf8', maxBuffer: 16 * 1024 * 1024 },
  );
  return (
    result.stdout
      .split(/\r?\n/)
      .map((line) => line.trim().split(' ').map(Number))
      .filter((fields) => fields.length === 3 && fields.every(Number.isFinite))
      // A Windows file time counts 100 ns from 1601.
      .map(([pid, ppid, fileTime]) => ({
        pid,
        ppid,
        created: fileTime / 10_000 - 11_644_473_600_000,
      }))
  );
}

/**
 * A fingerprint of the files the `pathspecs` name in the repository at `root`:
 * the index's entries (path, mode and blob), and the content of each file that
 * differs from the index or is untracked and not ignored, or "deleted". Ignored
 * folders that a check reads too (the licensed fonts in `.fonts/`) go in
 * `ignoredDirs`, hashed file by file. Git compares the working tree with the
 * index itself, so a line-ending-only change does not count.
 */
export function inputsFingerprint(root, pathspecs, { ignoredDirs = [] } = {}) {
  const git = (args) => {
    const result = spawnSync('git', ['-c', 'core.quotePath=false', ...args], {
      cwd: root,
      maxBuffer: 512 * 1024 * 1024,
    });
    if (result.status !== 0) throw new Error(`git ${args.join(' ')}: ${result.stderr}`);
    return result.stdout;
  };
  const names = (buffer) => buffer.toString('utf8').split('\0').filter(Boolean);
  const hash = createHash('sha256');
  hash.update(git(['ls-files', '-s', '-z', '--', ...pathspecs]));
  const differing = new Set([
    ...names(git(['diff', '--name-only', '--no-renames', '-z', '--', ...pathspecs])),
    ...names(git(['ls-files', '--others', '--exclude-standard', '-z', '--', ...pathspecs])),
  ]);
  for (const file of [...differing].sort()) {
    hash.update(`\0file:${file}\0`);
    const full = path.join(root, file);
    hash.update(existsSync(full) ? readFileSync(full) : '\0deleted\0');
  }
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

/** The key of one step's pass: what it ran, where, and the fingerprint of what it read. */
export function passKey(fields) {
  return createHash('sha256').update(JSON.stringify(fields)).digest('hex');
}

const PASSES_KEPT = 400;

function readPasses(file) {
  return parse(readText(file))?.passes ?? {};
}

/** Whether a step with this key passed before (scripts/verify.mjs's record in the git folder). */
export function hasPassed(file, key) {
  return Object.hasOwn(readPasses(file), key);
}

/** Records a step's pass; keeps the newest PASSES_KEPT. Written whole, then renamed. */
export function recordStepPass(file, key, now = new Date()) {
  const passes = { ...readPasses(file), [key]: now.toISOString() };
  const newest = Object.entries(passes)
    .sort((a, b) => b[1].localeCompare(a[1]))
    .slice(0, PASSES_KEPT);
  const pending = `${file}.${process.pid}`;
  writeFileSync(pending, JSON.stringify({ passes: Object.fromEntries(newest) }));
  renameSync(pending, file);
}

/** " (3 of 8 tasks replayed from the cache)" from Turborepo's summary, or ''. */
export function turboNote(output) {
  const match = /Cached:\s+(\d+) cached, (\d+) total/.exec(output.replace(COLOURS, ''));
  return match ? ` (${match[1]} of ${match[2]} tasks replayed from the cache)` : '';
}

/** The names under a pubspec's dependencies and dev_dependencies. */
export function pubspecDependencies(text) {
  const names = [];
  let section = null;
  for (const line of text.split(/\r?\n/)) {
    const top = /^([a-z_]+):/.exec(line);
    if (top) section = top[1];
    const entry = /^ {2}([a-z0-9_]+):/.exec(line);
    if (entry && (section === 'dependencies' || section === 'dev_dependencies'))
      names.push(entry[1]);
  }
  return names;
}

/**
 * The named packages and every package of `workspace` ({ name, dependencies })
 * that depends on one of them, directly or not.
 */
export function withDependents(workspace, names) {
  const out = new Set(names);
  let grew = true;
  while (grew) {
    grew = false;
    for (const each of workspace) {
      if (!out.has(each.name) && each.dependencies.some((name) => out.has(name))) {
        out.add(each.name);
        grew = true;
      }
    }
  }
  return out;
}

/** "0.4 s", "42 s", "3 min 05 s". */
export function formatDuration(ms) {
  if (ms < 10_000) return `${(ms / 1000).toFixed(1)} s`;
  const seconds = Math.round(ms / 1000);
  if (seconds < 60) return `${seconds} s`;
  return `${Math.floor(seconds / 60)} min ${String(seconds % 60).padStart(2, '0')} s`;
}

/** One line of the progress and of the final table. */
export function stepLine({ name, result, ms }) {
  const time = ms === undefined ? '' : formatDuration(ms);
  return `  ${result.padEnd(9)} ${time.padStart(10)}  ${name}`;
}

/** The final table: every step, its result and its time, and the total. */
export function stepTable(rows, totalMs) {
  return [
    `  ${'result'.padEnd(9)} ${'time'.padStart(10)}  step`,
    ...rows.map(stepLine),
    `  ${''.padEnd(9)} ${formatDuration(totalMs).padStart(10)}  wall time`,
  ].join('\n');
}

const ESC = String.fromCharCode(27);
const COLOURS = new RegExp(`${ESC}\\[[0-9;?]*[A-Za-z]`, 'g');
// A line that reports a failure, in the output of Vitest, Playwright, ESLint,
// tsc, Turborepo, Prettier, the Dart analyzer and `dart test` / `flutter test`.
const FAILED_LINE =
  /\b(FAIL|FAILED|failed|Failed|Error|ERROR|ERR!|error|AssertionError|Expected|Received|Exception|TimeoutError)\b|✗|×|✘|❌|^\s*\d+\) |\[(E|warn)\]|Some tests failed|exited with code [1-9]|^\s*(info|warning|error) - /;
const NOT_FAILED = /\b(0 failed|failed: 0|no errors?|0 errors?)\b|\[WebServer\]/i;

/**
 * A failing step's output cut to what failed: each failure line with a little
 * context, then the last lines (the runner's summary), at most `limit` lines.
 * Short output stays whole. The whole output stays in `savedTo`.
 */
export function cut(
  text,
  savedTo,
  { whole = 120, limit = 300, before = 3, after = 12, tail = 40 } = {},
) {
  const lines = text.replace(COLOURS, '').replaceAll('\r', '').split('\n');
  if (lines.length <= whole) return lines.join('\n');
  const tailFrom = Math.max(0, lines.length - tail);
  const kept = new Set();
  for (let i = 0; i < tailFrom; i++) {
    if (!FAILED_LINE.test(lines[i]) || NOT_FAILED.test(lines[i])) continue;
    const end = Math.min(tailFrom - 1, i + after);
    for (let j = Math.max(0, i - before); j <= end; j++) kept.add(j);
  }
  const body = [...kept].sort((a, b) => a - b).slice(0, limit - tail);
  const shown = [
    ...body,
    ...Array.from({ length: lines.length - tailFrom }, (_, i) => tailFrom + i),
  ];
  const out = [];
  let last = -1;
  for (const i of shown) {
    if (i > last + 1) out.push(`[… ${i - last - 1} lines …]`);
    out.push(lines[i]);
    last = i;
  }
  out.push(`[cut from ${lines.length} lines; the whole output is in ${savedTo}]`);
  return out.join('\n');
}
