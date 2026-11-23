#!/usr/bin/env node
// PreToolUse (Edit|Write|MultiEdit|NotebookEdit): refuses edits to generated files, the
// read-only archives, merged migrations and the slice's locked tests (lib/policy.mjs).
// Fails closed: any unexpected error blocks the call.
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { block, git, projectDir, readEvent } from './lib/io.mjs';
import { checkEdit, toRepoPath } from './lib/policy.mjs';

try {
  const event = await readEvent({ failClosed: true });
  const input = event.tool_input ?? {};
  const filePath = input.file_path ?? input.notebook_path;
  if (!filePath) process.exit(0);

  const root = projectDir(event);
  const repoPath = toRepoPath(filePath, root);

  // Merged work is protected; work on the branch is not.
  const onMain = ['main', 'origin/main'].some((ref) => {
    try {
      git(['cat-file', '-e', `${ref}:${repoPath}`], root);
      return true;
    } catch {
      return false;
    }
  });

  const lockedFile = join(root, '.claude', 'state', 'locked-tests.txt');
  const lockedTests = existsSync(lockedFile)
    ? readFileSync(lockedFile, 'utf8')
        .split('\n')
        .map((l) => l.trim())
        .filter((l) => l && !l.startsWith('#'))
        .map((l) => toRepoPath(l, root))
    : [];

  const reason = checkEdit(repoPath, { onMain, lockedTests });
  if (reason) block(reason);
} catch (err) {
  block(
    `the edit guard failed (${err instanceof Error ? err.message : String(err)}), so the call is refused.`,
  );
}
