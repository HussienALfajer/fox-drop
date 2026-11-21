import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { describe, it } from 'node:test';

import { classify, READ_BY_SERVER_TESTS, SPEC_FILES_READ_BY_TESTS } from './classify-changes.mjs';

const plain = () => '';
const flags = (files, read = plain) => {
  const result = classify(files, read);
  return Object.keys(result)
    .filter((key) => result[key])
    .map((key) => (result[key] === true ? key : `${key}:${result[key]}`))
    .join(' ');
};

describe('the change classifier', () => {
  it('counts Markdown and docs as nothing but Prettier', () => {
    assert.equal(flags(['README.md', 'docs/roadmap.md', 'apps/customer/README.md']), '');
    assert.equal(flags(['TASKS.md', 'apps/server/CLAUDE.md']), '');
  });

  it('counts the specs as code for CI, and only those a test reads for local tests', () => {
    assert.equal(flags(['docs/product/v1/customer-app/01-intro.md']), 'code');
    assert.equal(flags([SPEC_FILES_READ_BY_TESTS[0]]), 'code typescript server');
  });

  it('sets the server tests and not Dart for a server change', () => {
    assert.equal(
      flags(['apps/server/src/modules/ledger/ledger.service.ts']),
      'code typescript server',
    );
    assert.equal(flags(['apps/admin/src/App.tsx']), 'code typescript');
  });

  it('sets the server tests for the files outside the server they read', () => {
    assert.equal(flags(['apps/admin/src/locales/ar.json']), 'code typescript server');
    assert.equal(flags(['compose.yaml']), 'code typescript server');
    assert.equal(flags(['infra/centrifugo/config.yaml']), 'code typescript server');
  });

  it('regenerates the contract only after a route or schema change', () => {
    const service = 'apps/server/src/modules/ordering/orders.service.ts';
    assert.doesNotMatch(flags([service]), /contract/);
    assert.match(
      flags([service], () => "import { z } from 'zod';"),
      /contract/,
    );
    assert.match(
      flags([service], () => null),
      /contract/,
    );
    assert.match(flags(['apps/server/src/modules/ordering/orders.controller.ts']), /contract/);
    assert.match(flags(['scripts/generate-api.mjs']), /contract/);
    assert.doesNotMatch(
      flags(['apps/server/src/modules/ordering/orders.test.ts'], () => "from 'zod'"),
      /contract/,
    );
  });

  it('sets Dart and Flutter for a Flutter change, and no TypeScript', () => {
    assert.equal(flags(['apps/customer/lib/main.dart']), 'code dart flutter dartScope:changed');
    assert.equal(
      flags(['packages/core_l10n/lib/l10n/app_ar.arb']),
      'code dart flutter dartScope:changed',
    );
    assert.equal(flags(['.fvmrc']), 'code dart flutter dartScope:all');
    assert.equal(
      flags(['pubspec.lock', 'apps/customer/lib/main.dart']),
      'code dart flutter dartScope:all',
    );
  });

  it('keeps what CI sets for its own workflow and verify.mjs, without local Dart checks', () => {
    assert.equal(flags(['.github/workflows/ci.yml']), 'code dart flutter typescript');
    assert.equal(flags(['scripts/verify.mjs']), 'code dart typescript');
  });

  it('is in step with the server tests that read files outside the server', () => {
    const config = readFileSync('apps/server/vitest.config.ts', 'utf8');
    for (const file of READ_BY_SERVER_TESTS) assert.ok(config.includes(`'**/${file}'`), file);
  });
});
