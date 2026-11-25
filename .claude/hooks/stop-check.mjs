// Stop hook: a light check of the files this session edited since its last pass, so a turn
// never ends with a file CI's format or lint step would refuse, and never waits minutes for it.
// Prettier `--check` on the edited files, `dart format --set-exit-if-changed` (the pinned Dart)
// on the Dart ones and ESLint on the script ones, each package from its own folder with its own
// config, all at the same time. Never tests, builds, type checks or analyzers: the session runs
// `node scripts/verify.mjs --changed` itself, in the background, once per finished layer.
//
// It always says what it did in one line (systemMessage), and once per tree that the full check
// has not run on it (scripts/green-tree.mjs). A failure exits 2 with the failing tool's output,
// so Claude fixes it; the edits stay recorded for the next stop. Skipped:
//   - on the retry (Claude Code sets stop_hook_active);
//   - in the red phase (`.claude/state/red-phase`; `build-slice` writes failing tests first);
//   - when this session edited no file since its last pass: format.mjs records each Edit or
//     Write, this session's or its subagents', so another session's work, an untracked file or a
//     change made through Bash or a generator never starts anything.
// History: docs/archive/claude-code-workflow.md, phases 4 and 6; until 2026-11-25 it ran the
// whole `verify --changed` (stop-verify.mjs) and was killed at its 600 s timeout nine times in
// three days.
import { spawn } from 'node:child_process';
import {
  appendFileSync,
  existsSync,
  mkdirSync,
  readFileSync,
  rmSync,
  statSync,
  writeFileSync,
} from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { classify } from '../../scripts/classify-changes.mjs';
import { isGreen, treeState } from '../../scripts/green-tree.mjs';
import { projectDir } from './lib/io.mjs';
import { pinnedDart } from './lib/sdk.mjs';

const DIR = path.join(os.tmpdir(), 'claude-stop-check');
// Above this many edited files the light check is skipped: the full check is the tool then.
export const MAX_FILES = 60;
// Each tool gets this long; the hook's own timeout in settings.json is 60 s.
const TOOL_TIMEOUT_MS = 40_000;
const DART = /\.dart$/i;
const LINTED = /\.(?:[cm]?[jt]s|[jt]sx)$/i;
const FULL_CHECK =
  'node scripts/verify.mjs --changed (run_in_background, output to a log file; you are told when it exits)';

/** The file listing what a session edited since its last pass. */
export function editsFile(sessionId, dir = DIR) {
  return path.join(dir, `${sessionId ?? 'session'}.edits`);
}

/** Records that a session edited a file, by its absolute path (called by format.mjs). */
export function recordEdit(sessionId, file, dir = DIR) {
  mkdirSync(dir, { recursive: true });
  appendFileSync(editsFile(sessionId, dir), `${file}\n`);
}

/**
 * Whether the hook looks at the changes at the end of a turn: not on the retry after its own
 * report, not in the red phase, and not when the session edited nothing since its last pass.
 */
export function shouldCheck(input, root, dir = DIR) {
  if (input.stop_hook_active) return false;
  if (existsSync(path.join(root, '.claude', 'state', 'red-phase'))) return false;
  return existsSync(editsFile(input.session_id, dir));
}

/** Forgets the recorded edits after a pass, unless more were recorded meanwhile. */
export function clearEdits(sessionId, seen, dir = DIR) {
  const file = editsFile(sessionId, dir);
  if (existsSync(file) && readFileSync(file, 'utf8') === seen) rmSync(file, { force: true });
}

/**
 * The recorded edits that are still files of this checkout, once each, as forward-slash paths
 * relative to `root`. A path recorded relative (older hooks) is taken from `root`; files in
 * another checkout, a worktree under `.claude/worktrees/` included, are left to that checkout.
 */
export function editedFiles(recorded, root, isFile = isRegularFile) {
  const out = new Set();
  for (const line of recorded.split(/\r?\n/)) {
    if (!line.trim()) continue;
    const full = path.resolve(root, line.trim());
    const relative = path.relative(root, full);
    if (!relative || relative.startsWith('..') || path.isAbsolute(relative)) continue;
    const repoPath = relative.replaceAll('\\', '/');
    if (/^\.claude\/worktrees\//i.test(repoPath) || !isFile(full)) continue;
    out.add(repoPath);
  }
  return [...out];
}

/**
 * What to run on the edited files: Prettier on all but Dart (it skips what it does not know),
 * `dart format` on Dart, and ESLint per folder that holds the nearest `eslint.config.mjs`
 * (`''` is the root), with the paths relative to that folder.
 * @param {string[]} files forward-slash paths relative to the root
 * @param {(dir: string) => boolean} hasEslintConfig dir is '' for the root
 */
export function planChecks(files, hasEslintConfig) {
  const eslint = new Map();
  for (const file of files.filter((f) => LINTED.test(f))) {
    let dir = path.posix.dirname(file);
    for (;;) {
      const at = dir === '.' ? '' : dir;
      if (hasEslintConfig(at)) {
        if (!eslint.has(at)) eslint.set(at, []);
        eslint.get(at).push(at ? path.posix.relative(at, file) : file);
        break;
      }
      if (!at) break;
      dir = path.posix.dirname(dir);
    }
  }
  return {
    prettier: files.filter((f) => !DART.test(f)),
    dart: files.filter((f) => DART.test(f)),
    eslint,
  };
}

/** The one line the session sees after a light check. */
export function summary({ files, counts, failed, seconds, notes = [] }) {
  const parts = Object.entries(counts)
    .filter(([, n]) => n > 0)
    .map(([tool, n]) => `${tool} ${n}`)
    .join(', ');
  const result = failed.length ? `failed (${failed.join(', ')})` : 'passed';
  const extra = notes.length ? ` ${notes.join(' ')}` : '';
  return `Light check of ${files} edited file${files === 1 ? '' : 's'} (${parts || 'nothing to check'}): ${result} in ${seconds.toFixed(1)} s.${extra}`;
}

/**
 * Whether to remind the session, once per tree, that the full check has not run on it: the
 * session's edits are code and the tree is not the one the last passing verify recorded.
 */
export function needsReminder({ code, green, fingerprint, reminded }) {
  return Boolean(code && fingerprint && !green && reminded !== fingerprint);
}

const WHOLE_UP_TO = 120;
const KEEP_AT_MOST = 300;
const BEFORE = 3;
const AFTER = 12;
const TAIL = 40;
// Terminal colours: ESC [ … letter.
const ANSI = new RegExp(`${String.fromCharCode(27)}\\[[0-9;?]*[A-Za-z]`, 'g');
const FAILURE =
  /\b(FAIL|FAILED|failed|Error|ERR!|error|AssertionError|Expected|Received|Exception)\b|✗|×|✘|❌|^\s*\d+\) |\[E\]|\[warn\]|Some tests failed|exited with code [1-9]/;
const NOISE = /\b(0 failed|failed: 0|no errors?)\b/i;
// The log of the server a Playwright run starts is never a failure of its own.
const SERVER_LOG = /\[WebServer\]/;
const isFailure = (line) => FAILURE.test(line) && !NOISE.test(line) && !SERVER_LOG.test(line);

/** A failing tool's output cut to its failures with context and its last lines. */
export function cut(text, savedTo) {
  const lines = text.replace(ANSI, '').replace(/\r/g, '').split('\n');
  if (lines.length <= WHOLE_UP_TO) return lines.join('\n');
  const keep = new Set();
  lines.forEach((line, i) => {
    if (isFailure(line))
      for (let j = Math.max(0, i - BEFORE); j <= Math.min(lines.length - 1, i + AFTER); j++)
        keep.add(j);
  });
  const tailStart = Math.max(0, lines.length - TAIL);
  const body = [...keep].filter((i) => i < tailStart).sort((a, b) => a - b);
  const kept = body.slice(0, KEEP_AT_MOST - TAIL);
  const out = [];
  let previous = -1;
  for (const i of [...kept, ...lines.keys().filter((i) => i >= tailStart)]) {
    if (i > previous + 1) out.push(`[… ${i - previous - 1} lines …]`);
    out.push(lines[i]);
    previous = i;
  }
  out.push(`\n[Output cut from ${lines.length} lines; the whole output is in ${savedTo}]`);
  return out.join('\n');
}

/** Runs one tool without a shell; resolves with its exit code, output and whether it timed out. */
function run(name, command, args, cwd) {
  return new Promise((resolve) => {
    let output = '';
    let timedOut = false;
    const child = spawn(command, args, { cwd, stdio: ['ignore', 'pipe', 'pipe'] });
    const timer = setTimeout(() => {
      timedOut = true;
      child.kill();
    }, TOOL_TIMEOUT_MS);
    child.stdout.on('data', (chunk) => (output += chunk));
    child.stderr.on('data', (chunk) => (output += chunk));
    child.on('error', (error) => (output += `${error.message}\n`));
    child.on('close', (status) => {
      clearTimeout(timer);
      resolve({ name, cwd, status: status ?? 1, output, timedOut });
    });
  });
}

async function main() {
  const started = performance.now();
  const input = JSON.parse(readFileSync(0, 'utf8') || '{}');
  const root = projectDir(input);
  const say = (message) => process.stdout.write(JSON.stringify({ systemMessage: message }));
  if (!input.stop_hook_active && existsSync(path.join(root, '.claude', 'state', 'red-phase'))) {
    say(
      'The light check is off: .claude/state/red-phase exists. Remove it when the red phase ends.',
    );
    return;
  }
  if (!shouldCheck(input, root)) return;
  const seen = readFileSync(editsFile(input.session_id), 'utf8');
  const files = editedFiles(seen, root);
  if (files.length === 0) {
    clearEdits(input.session_id, seen);
    return;
  }
  if (files.length > MAX_FILES) {
    clearEdits(input.session_id, seen);
    say(
      `Light check skipped: ${files.length} edited files, more than ${MAX_FILES}. Run the full check: ${FULL_CHECK}.`,
    );
    return;
  }

  const plan = planChecks(files, (dir) => existsSync(path.join(root, dir, 'eslint.config.mjs')));
  const notes = [];
  const runs = [];
  const counts = { Prettier: 0, 'dart format': 0, ESLint: 0 };
  const prettier = path.join(root, 'node_modules', 'prettier', 'bin', 'prettier.cjs');
  if (plan.prettier.length && existsSync(prettier)) {
    counts.Prettier = plan.prettier.length;
    const args = [prettier, '--check', '--ignore-unknown', '--log-level', 'warn', ...plan.prettier];
    runs.push(run('Prettier', process.execPath, args, root));
  } else if (plan.prettier.length) notes.push('Prettier skipped: run pnpm install.');
  if (plan.dart.length) {
    const dart = pinnedDart(root);
    if (dart) {
      counts['dart format'] = plan.dart.length;
      const args = ['format', '--output=none', '--set-exit-if-changed', ...plan.dart];
      runs.push(run('dart format', dart, args, root));
    } else notes.push('dart format skipped: the pinned Flutter (.fvm/flutter_sdk) is missing.');
  }
  for (const [dir, list] of plan.eslint) {
    const cwd = path.join(root, dir);
    const own = path.join(cwd, 'node_modules', 'eslint', 'bin', 'eslint.js');
    const eslint = existsSync(own)
      ? own
      : path.join(root, 'node_modules', 'eslint', 'bin', 'eslint.js');
    if (!existsSync(eslint)) {
      notes.push(`ESLint skipped in ${dir || 'the root'}: run pnpm install.`);
      continue;
    }
    counts.ESLint += list.length;
    runs.push(
      run(`ESLint ${dir || '.'}`, process.execPath, [eslint, '--no-warn-ignored', ...list], cwd),
    );
  }

  const results = await Promise.all(runs);
  for (const r of results.filter((r) => r.timedOut))
    notes.push(`${r.name} timed out after ${TOOL_TIMEOUT_MS / 1000} s and was not counted.`);
  const failed = results.filter((r) => r.status !== 0 && !r.timedOut);
  const seconds = (performance.now() - started) / 1000;
  const line = summary({
    files: files.length,
    counts,
    failed: failed.map((r) => r.name),
    seconds,
    notes,
  });

  if (failed.length) {
    const output = failed
      .map((r) => `=== ${r.name} (in ${r.cwd.replaceAll('\\', '/')})\n${r.output.trim()}`)
      .join('\n\n');
    mkdirSync(DIR, { recursive: true });
    const savedTo = path
      .join(DIR, `${new Date().toISOString().replace(/[:.]/g, '-')}.log`)
      .replaceAll('\\', '/');
    writeFileSync(savedTo, output);
    process.stderr.write(
      `${line}\nFix the files (Prettier: \`node node_modules/prettier/bin/prettier.cjs --write <file>\`; Dart: the pinned \`dart format <file>\`), then stop again; if you are waiting for the owner on purpose, say so and stop.\n\n${cut(output, savedTo)}\n`,
    );
    process.exitCode = 2;
    return;
  }

  clearEdits(input.session_id, seen);
  const lines = [line];
  const tree = treeState(root);
  const remindedFile = path.join(DIR, `${input.session_id ?? 'session'}.reminded`);
  const reminded = existsSync(remindedFile) ? readFileSync(remindedFile, 'utf8') : '';
  const reminder = {
    code: classify(files, (file) => readOrNull(root, file)).code,
    green: tree ? isGreen(root, tree.fingerprint) : false,
    fingerprint: tree?.fingerprint,
    reminded,
  };
  if (needsReminder(reminder)) {
    lines.push(`The full check has not run on this tree: ${FULL_CHECK}.`);
    mkdirSync(DIR, { recursive: true });
    writeFileSync(remindedFile, tree.fingerprint);
  }
  say(lines.join('\n'));
}

function isRegularFile(full) {
  return existsSync(full) && statSync(full).isFile();
}

function readOrNull(root, file) {
  const full = path.join(root, file);
  return isRegularFile(full) ? readFileSync(full, 'utf8') : null;
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url))
  await main();
