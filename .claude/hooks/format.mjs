// PostToolUse hook: formats the file Claude just wrote, with `dart format`
// for Dart and Prettier for everything Prettier knows.
import { spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';

const input = JSON.parse(readFileSync(0, 'utf8'));
const file = input.tool_input?.file_path;
const root = process.env.CLAUDE_PROJECT_DIR ?? input.cwd;
if (!file || !existsSync(file)) process.exit(0);
const relative = path.relative(root, path.resolve(file));
if (!relative || relative.startsWith('..') || path.isAbsolute(relative)) process.exit(0);

// The same Dart as `pnpm verify`: the FVM-pinned Flutter when it is installed.
const fvmFlutter = path.join(root, '.fvm', 'flutter_sdk', 'bin');
if (existsSync(fvmFlutter)) process.env.PATH = `${fvmFlutter}${path.delimiter}${process.env.PATH}`;

const prettier = path.join(root, 'node_modules', 'prettier', 'bin', 'prettier.cjs');
const options = { cwd: root, encoding: 'utf8' };
let result;
if (file.endsWith('.dart')) {
  // On Windows `dart` is a .bat file and needs a shell; refuse paths the shell would interpret.
  if (process.platform !== 'win32') result = spawnSync('dart', ['format', file], options);
  else if (/[%"^&|<>!]/.test(file)) process.exit(0);
  else result = spawnSync(`dart format "${file}"`, { ...options, shell: true });
} else if (existsSync(prettier)) {
  const args = [prettier, '--write', '--ignore-unknown', '--log-level', 'warn', file];
  result = spawnSync(process.execPath, args, options);
} else {
  process.exit(0);
}

if (result.status !== 0) {
  process.stderr.write(`Formatting ${file} failed:\n${result.stdout}${result.stderr}`);
  process.exit(2);
}
