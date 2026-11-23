// Stop hook: when a turn ends with uncommitted code changes, run the fast check
// (`node scripts/verify.mjs --changed`). It prints nothing when the check passes; on a failure
// it hands Claude the failing step, cut to its failures, and the path of the whole output, and
// Claude goes on to fix it. One attempt per stop (Claude Code sets stop_hook_active on the
// retry). Skipped when:
//   - `.claude/state/red-phase` exists (`build-slice` writes failing tests first, on purpose);
//   - this session edited no file itself since its last passing check: format.mjs records each
//     Edit or Write, this session's or its subagents', so a session watching another in the
//     same checkout never checks the other's half-done work (a change made only through Bash,
//     a generator or a checkout, is not recorded);
//   - no code changed (scripts/classify-changes.mjs), or the tree is the one the last passing
//     verify recorded (scripts/green-tree.mjs; the checker's run records it too);
//   - another check holds the folder's lock (verify.mjs exits 3): the edits stay recorded and
//     the next turn checks.
// History: docs/archive/claude-code-workflow.md, phases 4 and 6.
import { spawnSync } from 'node:child_process';
import {
  appendFileSync,
  closeSync,
  existsSync,
  mkdirSync,
  openSync,
  readFileSync,
  rmSync,
  statSync,
} from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { classify } from '../../scripts/classify-changes.mjs';
import { isGreen, treeState } from '../../scripts/green-tree.mjs';
import { projectDir } from './lib/io.mjs';

const DIR = path.join(os.tmpdir(), 'claude-stop-verify');
// scripts/verify.mjs exits with 3 while another check holds the folder's lock.
const BUSY = 3;

/** The file listing what a session edited since its last passing check. */
export function editsFile(sessionId, dir = DIR) {
  return path.join(dir, `${sessionId ?? 'session'}.edits`);
}

/** Records that a session edited a file (called by format.mjs). */
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

/** The uncommitted paths in `git status --porcelain --untracked-files=all` output. */
export function statusPaths(porcelain) {
  return porcelain
    .split('\n')
    .filter(Boolean)
    .map((line) =>
      line
        .slice(3)
        .replace(/^.* -> /, '')
        .replace(/^"|"$/g, ''),
    );
}

/** The output of the step that failed: from its `=== ` header to the end. */
export function failingStep(output) {
  const lines = output.replace(/\r/g, '').split('\n');
  const header = lines.findLastIndex((line) => line.startsWith('=== '));
  return lines.slice(Math.max(0, header)).join('\n').trim();
}

const WHOLE_UP_TO = 120;
const KEEP_AT_MOST = 300;
const BEFORE = 3;
const AFTER = 12;
const TAIL = 40;
// Terminal colours: ESC [ … letter.
const ANSI = new RegExp(`${String.fromCharCode(27)}\\[[0-9;?]*[A-Za-z]`, 'g');
const FAILURE =
  /\b(FAIL|FAILED|failed|Error|ERR!|error|AssertionError|Expected|Received|Exception)\b|✗|×|✘|❌|^\s*\d+\) |\[E\]|Some tests failed|exited with code [1-9]/;
const NOISE = /\b(0 failed|failed: 0|no errors?)\b/i;
// The log of the server a Playwright run starts is never a failure of its own.
const SERVER_LOG = /\[WebServer\]/;
const isFailure = (line) => FAILURE.test(line) && !NOISE.test(line) && !SERVER_LOG.test(line);

/** A failing step's output cut to its failures with context and its last lines. */
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

function main() {
  const input = JSON.parse(readFileSync(0, 'utf8') || '{}');
  const root = projectDir(input);
  if (!input.stop_hook_active && existsSync(path.join(root, '.claude', 'state', 'red-phase'))) {
    process.stdout.write(
      JSON.stringify({
        systemMessage:
          'The fast check is off: .claude/state/red-phase exists. Remove it when the red phase ends.',
      }),
    );
    return;
  }
  if (!shouldCheck(input, root)) return;
  const edits = readFileSync(editsFile(input.session_id), 'utf8');
  const tree = treeState(root);
  if (!tree) return;
  const files = statusPaths(tree.status);
  if (
    files.length === 0 ||
    !classify(files, (file) => readOrNull(root, file)).code ||
    isGreen(root, tree.fingerprint)
  ) {
    clearEdits(input.session_id, edits);
    return;
  }

  // The check writes straight to a file, so its whole output is kept however long it is. A
  // passing run records the tree itself, so the next stop on the same tree is skipped.
  mkdirSync(DIR, { recursive: true });
  const savedTo = path
    .join(DIR, `${new Date().toISOString().replace(/[:.]/g, '-')}.log`)
    .replaceAll('\\', '/');
  const out = openSync(savedTo, 'w');
  const result = spawnSync(process.execPath, ['scripts/verify.mjs', '--changed'], {
    cwd: root,
    stdio: ['ignore', out, out],
  });
  closeSync(out);
  if (result.status === 0) {
    clearEdits(input.session_id, edits);
    rmSync(savedTo, { force: true });
    return;
  }
  const output = readFileSync(savedTo, 'utf8');
  if (result.status === BUSY) {
    rmSync(savedTo, { force: true });
    process.stdout.write(
      JSON.stringify({ systemMessage: `The fast check was skipped: ${output.trim()}` }),
    );
    return;
  }
  process.stderr.write(
    `The fast check of the uncommitted changes failed (node scripts/verify.mjs --changed). Fix the cause, then stop again; if you are waiting for the owner on purpose (a wrong locked test, say), say so and stop.\n\n${cut(failingStep(output), savedTo)}\n\nThe whole output is in ${savedTo}.\n`,
  );
  process.exitCode = 2;
}

function readOrNull(root, file) {
  const full = path.join(root, file);
  return existsSync(full) && statSync(full).isFile() ? readFileSync(full, 'utf8') : null;
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
