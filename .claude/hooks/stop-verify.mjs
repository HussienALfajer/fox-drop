// Stop hook (docs/claude-code-workflow.md, phase 4): when a turn ends with
// uncommitted code changes it has not checked yet, run the fast check
// (`node scripts/verify.mjs --changed`). It prints nothing when the check
// passes; on a failure it hands Claude the failing step, cut to its failures,
// and the path of the whole output, and Claude goes on to fix it.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { classify } from '../../scripts/classify-changes.mjs';
import { cut } from './test-summary.mjs';

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
  // Claude is already fixing what this hook reported: let the turn end.
  if (input.stop_hook_active) return;
  const root = process.env.CLAUDE_PROJECT_DIR ?? input.cwd;
  const files = statusPaths(git(['status', '--porcelain', '-z', '--untracked-files=all'], root));
  if (files.length === 0 || !classify(files, (file) => readOrNull(root, file)).code) return;

  // Changes that passed are not checked again: a turn that changed nothing
  // since ends at once. A failure, a timeout or an interruption leaves no
  // marker, so the next turn checks again.
  const hash = createHash('sha256').update(git(['diff', 'HEAD'], root));
  for (const file of files) {
    const full = path.join(root, file);
    hash.update(`${file}:${existsSync(full) ? statSync(full).mtimeMs : 'deleted'}\n`);
  }
  const fingerprint = hash.digest('hex');
  const dir = path.join(os.tmpdir(), 'claude-stop-verify');
  mkdirSync(dir, { recursive: true });
  const marker = path.join(dir, `${input.session_id ?? 'session'}.txt`);
  if (existsSync(marker) && readFileSync(marker, 'utf8') === fingerprint) return;

  const result = spawnSync(process.execPath, ['scripts/verify.mjs', '--changed'], {
    cwd: root,
    encoding: 'utf8',
    maxBuffer: 256 * 1024 * 1024,
  });
  if (result.status === 0) {
    writeFileSync(marker, fingerprint);
    return;
  }
  const output = `${result.stdout ?? ''}${result.stderr ?? ''}`;
  const savedTo = path
    .join(dir, `${new Date().toISOString().replace(/[:.]/g, '-')}.log`)
    .replaceAll('\\', '/');
  writeFileSync(savedTo, output);
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
