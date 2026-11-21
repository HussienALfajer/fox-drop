// Stop hook (docs/claude-code-workflow.md, phase 4): when a turn ends with
// uncommitted code changes it has not checked yet, run the fast check
// (`node scripts/verify.mjs --changed`). It prints nothing when the check
// passes; on a failure it hands Claude the failing step, cut to its failures,
// and the path of the whole output, and Claude goes on to fix it.
//
// Only a session that edited files itself checks (phase 6): format.mjs records
// each Edit or Write, this session's or its subagents', and a session watching
// another in the same checkout never checks the other's half-done work. A
// change made only through Bash (a generator, a checkout) is not recorded.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import {
  appendFileSync,
  closeSync,
  existsSync,
  mkdirSync,
  openSync,
  readFileSync,
  rmSync,
  statSync,
  writeFileSync,
} from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { classify } from '../../scripts/classify-changes.mjs';
import { cut } from './test-summary.mjs';

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
 * Whether the hook looks at the changes at the end of a turn: not when the
 * session edited nothing since its last passing check.
 */
export function shouldCheck(input, dir = DIR) {
  if (input.stop_hook_active) return false; // Claude is fixing what this hook reported
  return existsSync(editsFile(input.session_id, dir));
}

/** Forgets the recorded edits after a pass, unless more were recorded meanwhile. */
export function clearEdits(sessionId, seen, dir = DIR) {
  const file = editsFile(sessionId, dir);
  if (existsSync(file) && readFileSync(file, 'utf8') === seen) rmSync(file, { force: true });
}

/** The uncommitted paths in `git status --porcelain -z` output, the new name of a rename. */
export function statusPaths(porcelain) {
  const entries = porcelain.split('\0').filter(Boolean);
  const files = [];
  for (let i = 0; i < entries.length; i++) {
    files.push(entries[i].slice(3));
    if (/^[RC]/.test(entries[i])) i++; // the old name follows a rename or copy
  }
  return files;
}

/** The output of the step that failed: from its `=== ` header to the end. */
export function failingStep(output) {
  const lines = output.replace(/\r/g, '').split('\n');
  const header = lines.findLastIndex((line) => line.startsWith('=== '));
  return lines.slice(Math.max(0, header)).join('\n').trim();
}

function git(args, cwd) {
  return spawnSync('git', args, { cwd, encoding: 'utf8', maxBuffer: 256 * 1024 * 1024 }).stdout;
}

function main() {
  const input = JSON.parse(readFileSync(0, 'utf8'));
  if (!shouldCheck(input)) return;
  const edits = readFileSync(editsFile(input.session_id), 'utf8');
  const root = process.env.CLAUDE_PROJECT_DIR ?? input.cwd;
  const files = statusPaths(git(['status', '--porcelain', '-z', '--untracked-files=all'], root));
  if (files.length === 0 || !classify(files, (file) => readOrNull(root, file)).code) {
    clearEdits(input.session_id, edits);
    return;
  }

  // Changes that passed are not checked again: a turn that changed nothing
  // since ends at once. A failure, a timeout or an interruption leaves no
  // marker, so the next turn checks again.
  const hash = createHash('sha256').update(git(['diff', 'HEAD'], root));
  for (const file of files) {
    const full = path.join(root, file);
    hash.update(`${file}:${existsSync(full) ? statSync(full).mtimeMs : 'deleted'}\n`);
  }
  const fingerprint = hash.digest('hex');
  mkdirSync(DIR, { recursive: true });
  const marker = path.join(DIR, `${input.session_id ?? 'session'}.txt`);
  if (existsSync(marker) && readFileSync(marker, 'utf8') === fingerprint) {
    clearEdits(input.session_id, edits);
    return;
  }

  // The check writes straight to the file, so its whole output is kept
  // however long it is.
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
    writeFileSync(marker, fingerprint);
    clearEdits(input.session_id, edits);
    rmSync(savedTo, { force: true });
    return;
  }
  const output = readFileSync(savedTo, 'utf8');
  if (result.status === BUSY) {
    // Another check holds this folder; the edits stay recorded for the next
    // turn. The owner sees why this turn was not checked.
    rmSync(savedTo, { force: true });
    process.stdout.write(
      JSON.stringify({ systemMessage: `The fast check was skipped: ${output.trim()}` }),
    );
    return;
  }
  process.stderr.write(
    `The fast check of the uncommitted changes failed (node scripts/verify.mjs --changed):\n\n${cut(failingStep(output), savedTo)}\n\nThe whole output is in ${savedTo}.\n`,
  );
  process.exitCode = 2;
}

function readOrNull(root, file) {
  const full = path.join(root, file);
  return existsSync(full) && statSync(full).isFile() ? readFileSync(full, 'utf8') : null;
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
