// "This exact tree already passed verify": a fingerprint of HEAD, origin/main, the status and
// the diff, shared by scripts/verify.mjs (writes it after a passing run) and the Stop hook
// (.claude/hooks/stop-verify.mjs skips a tree that matches it). Without the shared record, a
// passing check by the `checker` was followed by the hook running the same checks on the same
// tree again. Ported from the owner's Shifa project (2026-11-23).
import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import path from 'node:path';

/** Where the last green fingerprint lives (git-ignored, one per worktree). */
export function greenFile(root) {
  return path.join(root, '.claude', 'state', 'last-green-verify');
}

/** @returns {Buffer} raw output (diffs may hold binary data) */
function gitRaw(args, root) {
  return execFileSync('git', args, {
    cwd: root,
    maxBuffer: 256 * 1024 * 1024,
    stdio: ['ignore', 'pipe', 'ignore'],
  });
}

const git = (args, root) => gitRaw(args, root).toString('utf8');

/** The `origin/main` commit, or '' when there is none: `verify --changed` compares with it. */
function baseRef(root) {
  try {
    return git(['rev-parse', '--verify', '--quiet', 'origin/main'], root);
  } catch {
    return '';
  }
}

/**
 * sha256 of HEAD, origin/main, `git status --porcelain --untracked-files=all`, `git diff HEAD`
 * (no external diff drivers or textconv, binary changes included) and the name and content of
 * every untracked, not-ignored file, or null when git cannot answer (not a repository, no commit
 * yet). Ignored files are not part of the tree.
 * @param {string} root
 * @returns {{ fingerprint: string, status: string } | null}
 */
export function treeState(root) {
  try {
    // Unquoted paths, so an Arabic file name reaches the classifier as it is on disk.
    const status = git(
      ['-c', 'core.quotePath=false', 'status', '--porcelain', '--untracked-files=all'],
      root,
    );
    const hash = createHash('sha256')
      .update(git(['rev-parse', 'HEAD'], root))
      .update(`\0base:${baseRef(root)}\0`)
      .update(status)
      .update(gitRaw(['diff', '--no-ext-diff', '--no-textconv', '--binary', 'HEAD'], root));
    const untracked = git(['ls-files', '--others', '--exclude-standard', '-z'], root)
      .split('\0')
      .filter(Boolean)
      .sort();
    for (const name of untracked) {
      hash.update(`\0untracked:${name}\0`);
      try {
        hash.update(readFileSync(path.join(root, name)));
      } catch {
        hash.update('\0unreadable\0');
      }
    }
    return { fingerprint: hash.digest('hex'), status };
  } catch {
    return null;
  }
}

/** True when `fingerprint` is the recorded green tree. */
export function isGreen(root, fingerprint) {
  const file = greenFile(root);
  return (
    Boolean(fingerprint) && existsSync(file) && readFileSync(file, 'utf8').trim() === fingerprint
  );
}

export function recordGreen(root, fingerprint) {
  const file = greenFile(root);
  mkdirSync(path.dirname(file), { recursive: true });
  writeFileSync(file, fingerprint);
}
