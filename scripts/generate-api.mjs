// Regenerates the API contract and its clients (architecture §5.3, E6):
// the OpenAPI document from the server's controllers, the TypeScript client
// in packages/api-schema and the Dart client in packages/core_api.
import { spawnSync } from 'node:child_process';
import { existsSync, rmSync } from 'node:fs';
import path from 'node:path';

// The same Dart as pnpm verify: the Flutter pinned in .fvmrc, linked by
// `fvm install` at .fvm/flutter_sdk, before any Flutter on PATH. Another
// dart format could write other bytes and make the committed client look stale.
const fvmFlutter = path.resolve('.fvm', 'flutter_sdk', 'bin');
if (existsSync(fvmFlutter)) process.env.PATH = `${fvmFlutter}${path.delimiter}${process.env.PATH}`;

function run(command, cwd = '.') {
  console.log(`> ${command}`);
  const result = spawnSync(command, { shell: true, stdio: 'inherit', cwd });
  if (result.status === 0) return;
  console.error(`\ngenerate-api: failed at "${command}"`);
  process.exit(1);
}

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
