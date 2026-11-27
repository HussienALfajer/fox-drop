import assert from 'node:assert/strict';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { describe, it } from 'node:test';

import { DART_CLIENT_INPUTS, dartClientKey } from './generate-api.mjs';

describe('the Dart client key', () => {
  it('covers the document and what generates, builds and formats the client', () => {
    for (const input of [
      'packages/api-schema/openapi.json',
      'openapitools.json',
      'scripts/generate-api.mjs',
      'packages/core_api',
      'pubspec.lock',
      'analysis_options.yaml',
      '.fvmrc',
    ])
      assert.ok(DART_CLIENT_INPUTS.includes(input), input);
  });

  it('changes with any input, the client included, and with nothing else', () => {
    const root = mkdtempSync(path.join(tmpdir(), 'generate-api-'));
    try {
      for (const input of DART_CLIENT_INPUTS) {
        const file = input === 'packages/core_api' ? `${input}/lib/api.dart` : input;
        mkdirSync(path.join(root, path.dirname(file)), { recursive: true });
        writeFileSync(path.join(root, file), `${input}\n`);
      }
      const key = dartClientKey(root);
      assert.equal(dartClientKey(root), key);
      writeFileSync(path.join(root, 'README.md'), 'not an input\n');
      assert.equal(dartClientKey(root), key);
      for (const file of [
        'packages/api-schema/openapi.json',
        'packages/core_api/lib/api.dart',
        'packages/core_api/lib/src/model/new.dart',
        '.fvmrc',
      ]) {
        const before = dartClientKey(root);
        mkdirSync(path.join(root, path.dirname(file)), { recursive: true });
        writeFileSync(path.join(root, file), 'changed\n');
        assert.notEqual(dartClientKey(root), before, file);
      }
      const before = dartClientKey(root);
      rmSync(path.join(root, 'packages/core_api/lib/src/model/new.dart'));
      assert.notEqual(dartClientKey(root), before, 'a deleted file');
    } finally {
      rmSync(root, { recursive: true, force: true });
    }
  });
});
