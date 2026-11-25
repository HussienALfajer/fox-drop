// PostToolUse hook: formats the file Claude just wrote, with `dart format` for Dart and Prettier
// for everything Prettier knows, and records the edit for the Stop hook.
import { spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';

import { projectDir } from './lib/io.mjs';
import { pinnedDart } from './lib/sdk.mjs';
import { recordEdit } from './stop-check.mjs';

const input = JSON.parse(readFileSync(0, 'utf8'));
const file = input.tool_input?.file_path;
if (!file || !existsSync(file)) process.exit(0);
const full = path.resolve(file);
// The checkout the file is in, a worktree included.
const root = projectDir(input, path.dirname(full));
const relative = path.relative(root, full);
if (!relative || relative.startsWith('..') || path.isAbsolute(relative)) process.exit(0);
// The Stop hook checks only the files the session edited itself.
recordEdit(input.session_id, full);

const options = { cwd: root, encoding: 'utf8' };
let result;
if (file.endsWith('.dart')) {
  // The same Dart as `pnpm verify`, called directly: no shell, no `dart.bat`.
  const dart = pinnedDart(root);
  if (!dart) {
    process.stderr.write(
      `${file} was not formatted: the pinned Flutter (.fvmrc, linked at .fvm/flutter_sdk) is missing. Tell the owner; \`fvm install\` in the main checkout installs it.\n`,
    );
    process.exit(2);
  }
  result = spawnSync(dart, ['format', full], options);
} else {
  const prettier = path.join(root, 'node_modules', 'prettier', 'bin', 'prettier.cjs');
  if (!existsSync(prettier)) process.exit(0);
  const args = [prettier, '--write', '--ignore-unknown', '--log-level', 'warn', full];
  result = spawnSync(process.execPath, args, options);
}

if (result.status !== 0) {
  process.stderr.write(
    `Formatting ${file} failed:\n${result.stdout ?? ''}${result.stderr ?? ''}${result.error?.message ?? ''}\n`,
  );
  process.exit(2);
}
