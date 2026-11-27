// Regenerates the API contract and its clients (architecture §5.3, E6):
// the OpenAPI document from the server's controllers, the TypeScript client
// in packages/api-schema and the Dart client in packages/core_api.
//
// The Dart client is a function of the document and of what generates, builds
// and formats it (DART_CLIENT_INPUTS). Outside CI, when they and the client are
// as the last full run here left them, its slow half (the Java generator,
// build_runner and dart format: 42 of the job's 59 s in CI, minutes on
// Windows) would write the same files, so it is skipped; `--force` and CI
// always run it.
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, readdirSync, readFileSync, rmSync, statSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

// Files and folders, from the repository root. A folder counts every file in
// it but the build caches.
export const DART_CLIENT_INPUTS = [
  'packages/api-schema/openapi.json',
  'openapitools.json',
  'scripts/generate-api.mjs',
  'packages/core_api',
  'pubspec.yaml',
  'pubspec.lock',
  // core_api's analysis options include it: dart format reads its settings.
  'analysis_options.yaml',
  '.fvmrc',
];
const CACHES = new Set(['.dart_tool', 'build']);

function filesUnder(root, entry) {
  const full = path.join(root, entry);
  if (!existsSync(full)) return [];
  if (!statSync(full).isDirectory()) return [entry];
  return readdirSync(full, { withFileTypes: true }).flatMap((each) =>
    each.isDirectory() && CACHES.has(each.name)
      ? []
      : filesUnder(root, path.posix.join(entry, each.name)),
  );
}

/** A hash of every Dart client input under `root`: their paths and bytes. */
export function dartClientKey(root = '.') {
  const hash = createHash('sha256');
  for (const file of DART_CLIENT_INPUTS.flatMap((entry) => filesUnder(root, entry)).sort()) {
    hash.update(`${file}\n`);
    hash.update(readFileSync(path.join(root, file)));
  }
  return hash.digest('hex');
}

function run(command, cwd = '.') {
  console.log(`> ${command}`);
  const result = spawnSync(command, { shell: true, stdio: 'inherit', cwd });
  if (result.status === 0) return;
  console.error(`\ngenerate-api: failed at "${command}"`);
  process.exit(1);
}

function main() {
  // The same Dart as pnpm verify: the Flutter pinned in .fvmrc, linked by
  // `fvm install` at .fvm/flutter_sdk, before any Flutter on PATH. Another
  // dart format could write other bytes and make the committed client look stale.
  const fvmFlutter = path.resolve('.fvm', 'flutter_sdk', 'bin');
  if (existsSync(fvmFlutter))
    process.env.PATH = `${fvmFlutter}${path.delimiter}${process.env.PATH}`;

  // The Dart generator runs on Java; without it the committed client must not be
  // deleted below.
  if (spawnSync('java -version', { shell: true, stdio: 'ignore' }).status !== 0) {
    console.error(
      'generate-api: Java 11 or later is needed to generate the Dart client (openapi-generator).',
    );
    process.exit(1);
  }

  run('pnpm --filter @fox-drop/server openapi');
  run('pnpm --filter @fox-drop/api-schema generate');

  // Per checkout: each worktree has its own git directory and its own client.
  const gitDir = spawnSync('git rev-parse --git-dir', { shell: true, encoding: 'utf8' });
  const record =
    gitDir.status === 0 ? path.join(gitDir.stdout.trim(), 'generate-api-dart-client') : null;
  const always = Boolean(process.env.CI) || process.argv.includes('--force');
  if (!always && record && existsSync(record) && readFileSync(record, 'utf8') === dartClientKey()) {
    console.log(
      'generate-api: the document and the Dart client are as the last run left them;' +
        ' the Dart client is not regenerated (--force regenerates it).',
    );
    return;
  }
  if (record) rmSync(record, { force: true });

  // The generator never deletes files, so a model removed from the document
  // would linger without this.
  rmSync('packages/core_api/lib', { recursive: true, force: true });
  // The generator version is pinned in openapitools.json.
  run(
    'pnpm exec openapi-generator-cli generate --generator-name dart-dio' +
      ' --input-spec packages/api-schema/openapi.json --output packages/core_api' +
      ' --additional-properties=pubName=core_api',
  );
  // Its run metadata, written with the line endings of the OS, is not needed.
  rmSync('packages/core_api/.openapi-generator', { recursive: true, force: true });
  run('dart run build_runner build', 'packages/core_api');
  run('dart format packages/core_api/lib');
  if (record) writeFileSync(record, dartClientKey());
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();
