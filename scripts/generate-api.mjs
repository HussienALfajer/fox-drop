// Regenerates the API contract and its clients (architecture §5.3, E6):
// the OpenAPI document from the server's controllers, the TypeScript client
// in packages/api-schema and the Dart client in packages/core_api.
import { spawnSync } from 'node:child_process';
import { rmSync } from 'node:fs';

function run(command, cwd = '.') {
  console.log(`> ${command}`);
  const result = spawnSync(command, { shell: true, stdio: 'inherit', cwd });
  if (result.status === 0) return;
  console.error(`\ngenerate-api: failed at "${command}"`);
  process.exit(1);
}

run('pnpm --filter @fox-drop/server openapi');
run('pnpm --filter @fox-drop/api-schema generate');

// The generator never deletes files, so a model removed from the document
// would linger without this.
rmSync('packages/core_api/lib', { recursive: true, force: true });
// The generator version is pinned in openapitools.json; it needs Java 11 or later.
run(
  'pnpm exec openapi-generator-cli generate --generator-name dart-dio' +
    ' --input-spec packages/api-schema/openapi.json --output packages/core_api' +
    ' --additional-properties=pubName=core_api',
);
// Its run metadata, written with the line endings of the OS, is not needed.
rmSync('packages/core_api/.openapi-generator', { recursive: true, force: true });
run('dart run build_runner build', 'packages/core_api');
run('dart format packages/core_api/lib');
