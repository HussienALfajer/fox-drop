#!/usr/bin/env node
// SessionStart: puts the pinned Dart and Flutter (`.fvm/flutter_sdk`, the main checkout's in a
// worktree) first on PATH for every later Bash command of the session, through the file Claude
// Code names in CLAUDE_ENV_FILE (it runs that file before each Bash command). PowerShell commands
// never get it: Claude Code passes no PATH-like value to them on Windows, so the shell guard
// asks them for the prefix instead (lib/policy.mjs, checkPinnedSdk). Never blocks.
import { appendFileSync } from 'node:fs';

import { pinnedFlutterBin } from '../../scripts/verify-support.mjs';
import { projectDir, readEvent } from './lib/io.mjs';
import { pathExport } from './lib/sdk.mjs';

const event = await readEvent();
const root = projectDir(event);
const bin = pinnedFlutterBin(root);
if (!bin) {
  process.stdout.write(
    JSON.stringify({
      hookSpecificOutput: {
        hookEventName: 'SessionStart',
        additionalContext:
          'The pinned Flutter (.fvmrc, linked at .fvm/flutter_sdk) is missing: dart and flutter commands would use the PATH one, another version. Tell the owner; `fvm install` in the main checkout installs it.',
      },
    }),
  );
} else if (process.env.CLAUDE_ENV_FILE) {
  appendFileSync(process.env.CLAUDE_ENV_FILE, pathExport(bin));
}
