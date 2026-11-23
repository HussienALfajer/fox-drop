import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { describe, it } from 'node:test';

import {
  classify,
  NATIVE_PACKAGES,
  READ_BY_SERVER_TESTS,
  SPEC_FILES_READ_BY_TESTS,
} from './classify-changes.mjs';

const tracked = () =>
  spawnSync('git', ['-c', 'core.quotePath=false', 'ls-files'], { encoding: 'utf8' })
    .stdout.split(/\r?\n/)
    .filter(Boolean);

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
    assert.equal(flags(['docs/slices/D.8-inputs-and-forms.md', 'apps/server/CLAUDE.md']), '');
  });

  it('counts as code only the spec files a test reads, and builds nothing for them', () => {
    assert.equal(flags(['docs/product/v1/customer-app/01-intro.md']), '');
    assert.equal(flags(['docs/domain/03-timers.md']), '');
    assert.equal(flags([SPEC_FILES_READ_BY_TESTS[0]]), 'code typescript server');
  });

  it('runs the TypeScript tests for the docs the design tokens read', () => {
    for (const file of [
      'docs/architecture/09-design-system.md',
      'docs/brand/logo/mark/mark-orange.svg',
      'docs/brand/app-icon/svg/app-icon-08.svg',
    ])
      assert.equal(flags([file]), 'code typescript', file);
    assert.equal(flags(['docs/brand/expression.md']), '');
  });

  it('sets the server tests and not Dart for a server change', () => {
    assert.equal(
      flags(['apps/server/src/modules/ledger/ledger.service.ts']),
      'code build typescript server',
    );
    assert.equal(flags(['apps/admin/src/App.tsx']), 'code build typescript');
  });

  it('sets the server tests for the files outside the server they read', () => {
    assert.equal(flags(['apps/admin/src/locales/ar.json']), 'code build typescript server');
    assert.equal(flags(['compose.yaml']), 'code build typescript server');
    assert.equal(flags(['infra/centrifugo/config.yaml']), 'code build typescript server');
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

  it('sets Dart for a Flutter change, and no TypeScript or native builds', () => {
    assert.equal(flags(['apps/customer/lib/main.dart']), 'code dart build dartScope:changed');
    assert.equal(
      flags(['packages/core_l10n/lib/l10n/app_ar.arb']),
      'code dart build dartScope:changed',
    );
    // The component catalogue, the lint plugin and the goldens (D.7).
    for (const file of [
      'apps/widgetbook/lib/catalogue.dart',
      'packages/fox_lints/lib/src/rules.dart',
      'packages/core_ui/dart_test.yaml',
      'packages/core_ui/test/golden/goldens/icons.png',
    ]) {
      assert.equal(flags([file]), 'code dart build dartScope:changed', file);
    }
  });

  it('sets TypeScript and Dart for the design tokens, which generate both outputs', () => {
    assert.equal(
      flags(['packages/design-tokens/tokens/semantic/light.json']),
      'code dart build typescript',
    );
    // Generated Markdown and the font metrics are read by tests: they are code.
    assert.equal(
      flags(['packages/design-tokens/generated/contrast-report.md']),
      'code dart build typescript',
    );
    assert.equal(flags(['packages/design-tokens/font-metrics.json']), 'code dart build typescript');
  });

  it('sets the native builds for what can break them', () => {
    assert.equal(flags(['.fvmrc']), 'code dart native build dartScope:all');
    assert.equal(
      flags(['pubspec.lock', 'apps/customer/lib/main.dart']),
      'code dart native build dartScope:all',
    );
    assert.equal(flags(['apps/customer/pubspec.yaml']), 'code dart native build dartScope:changed');
    assert.equal(
      flags(['apps/captain/ios/Runner/Info.plist']),
      'code dart native build dartScope:changed',
    );
    assert.equal(
      flags(['apps/merchant/windows/runner/main.cpp']),
      'code dart native build dartScope:changed',
    );
    assert.equal(
      flags(['packages/core_alerts/lib/core_alerts.dart']),
      'code dart native build dartScope:changed',
    );
    assert.equal(flags(['apps/customer/android/README.md']), '');
  });

  it('keeps what CI sets for its own workflow and verify.mjs, without local Dart checks', () => {
    assert.equal(flags(['.github/workflows/ci.yml']), 'code dart native build typescript');
    assert.equal(flags(['scripts/verify.mjs']), 'code dart build typescript');
    assert.equal(flags(['scripts/verify-support.mjs']), 'code dart build typescript');
    // The golden job runs it.
    assert.equal(flags(['scripts/golden-docker.mjs']), 'code dart build typescript');
  });

  it('runs the goldens for the fonts and the scripts that fetch them', () => {
    assert.equal(flags(['docs/brand/fonts-manifest.json']), 'code dart typescript');
    for (const file of [
      'scripts/fonts.mjs',
      'scripts/fonts-fetch.mjs',
      'scripts/github-known-hosts.mjs',
    ]) {
      assert.equal(flags([file]), 'code dart build typescript', file);
    }
  });

  it('lists every spec file a test reads', () => {
    // A test, its helpers and fixtures: a path to a spec file in a string.
    const testFile =
      /(\.(test|spec)\.[cm]?[jt]sx?$|_test\.dart$|(^|\/)(test|e2e|integration_test)\/.*\.([cm]?[jt]sx?|dart)$)/;
    const quotedSpec = /['"`][^'"`\n]*?(docs\/(product|domain)\/[^'"`\n]+\.md)['"`]/g;
    const joinedPath = /['"`]docs['"`]\s*,\s*['"`](product|domain)['"`]/;
    const read = new Set();
    for (const file of tracked()) {
      if (!testFile.test(file) || file === 'scripts/classify-changes.test.mjs') continue;
      const text = readFileSync(file, 'utf8');
      assert.doesNotMatch(text, joinedPath, `${file}: write a spec file's path whole`);
      for (const match of text.matchAll(quotedSpec)) read.add(match[1]);
    }
    assert.deepEqual([...read].sort(), [...SPEC_FILES_READ_BY_TESTS].sort());
  });

  it('lists every Dart package with native code', () => {
    const native = new Set();
    for (const file of tracked()) {
      const match = /^(packages\/[^/]+)\/(android|ios|windows|macos|linux)\//.exec(file);
      if (match) native.add(match[1]);
    }
    assert.deepEqual([...native].sort(), [...NATIVE_PACKAGES].sort());
  });

  it('is in step with the server tests that read files outside the server', () => {
    const config = readFileSync('apps/server/vitest.config.ts', 'utf8');
    for (const file of READ_BY_SERVER_TESTS) assert.ok(config.includes(`'**/${file}'`), file);
  });
});
