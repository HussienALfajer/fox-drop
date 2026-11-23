#!/usr/bin/env node
// SessionEnd: warns when the session leaves uncommitted work behind, or a red-phase marker or a
// locked-test list that would carry over into the next session.
import { existsSync } from 'node:fs';
import { join } from 'node:path';
import { git, projectDir, readEvent } from './lib/io.mjs';

const event = await readEvent();
const root = projectDir(event);
for (const name of ['red-phase', 'locked-tests.txt']) {
  if (existsSync(join(root, '.claude', 'state', name))) {
    process.stderr.write(
      `Warning: .claude/state/${name} is still there; remove it when its slice no longer needs it.\n`,
    );
  }
}
try {
  const status = git(['status', '--porcelain'], root).trim();
  if (status) {
    const count = status.split('\n').length;
    process.stderr.write(
      `Warning: ${count} uncommitted change(s) left in the working tree. Commit them at a green checkpoint or note them in the slice file's "Stopped at" line.\n`,
    );
  }
} catch {
  // not a git checkout; nothing to report
}
process.exit(0);
