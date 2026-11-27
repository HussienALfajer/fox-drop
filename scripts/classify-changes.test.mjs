import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { describe, it } from 'node:test';

import {
  CHECK_ENGINE,
  ciJobs,
  classify,
  handWritten,
  NATIVE_PACKAGES,
  NOT_HAND_WRITTEN,
  READ_BY_SERVER_TESTS,
  SPEC_FILES_READ_BY_TESTS,
  TURBO_ROOT_INPUTS,
  turboScope,
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
// A job of ci.yml, as text: its key, then every line indented deeper.
const job = (name) => {
  const lines = readFileSync('.github/workflows/ci.yml', 'utf8').split(/\r?\n/);
  const start = lines.indexOf(`  ${name}:`);
  assert.ok(start >= 0, `ci.yml has the ${name} job`);
  const end = lines.findIndex((line, index) => index > start && /^ {0,2}\S/.test(line));
  return lines.slice(start, end).join('\n');
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
  });

  it('sets the server tests for the Node and pnpm settings they run on', () => {
    assert.equal(flags(['.node-version']), 'code build typescript server');
    assert.equal(flags(['.npmrc']), 'code build typescript server');
  });

  it('sets the native builds for what can break them', () => {
    assert.equal(flags(['.fvmrc']), 'code dart native build dartScope:all');
    assert.equal(
      flags(['pubspec.lock', 'apps/customer/lib/main.dart']),
      'code dart native build dartScope:all',
    );
    // A dependency changes the native builds only through the lock file.
    assert.equal(flags(['apps/customer/pubspec.yaml']), 'code dart build dartScope:changed');
    assert.equal(
      flags(['packages/core_auth/pubspec.yaml', 'pubspec.lock']),
      'code dart native build dartScope:all',
    );
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

  it('keeps what CI sets for its own workflow and the check engine, without local Dart checks', () => {
    // A change to the native jobs takes the native-builds label.
    assert.equal(flags(['.github/workflows/ci.yml']), 'code dart build typescript');
    // verify.mjs and every script it runs or imports.
    for (const file of [
      'scripts/verify.mjs',
      'scripts/verify-support.mjs',
      'scripts/verify-watchdog.mjs',
      'scripts/classify-changes.mjs',
      'scripts/green-tree.mjs',
      'scripts/server-test-readers.mjs',
      'scripts/outside-reads.mjs',
    ])
      assert.equal(flags([file]), 'code dart build typescript', file);
    assert.equal(flags(['scripts/verify-support.test.mjs']), 'code build typescript');
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

  it('runs the Dart jobs for every script the check engine imports or starts', () => {
    const known = new Set(tracked());
    const engine = new Set();
    const visit = (file) => {
      if (engine.has(file)) return;
      engine.add(file);
      for (const [, name] of readFileSync(file, 'utf8').matchAll(
        /['"`](?:\.\/)?([\w-]+\.mjs)['"`]/g,
      ))
        if (known.has(`scripts/${name}`)) visit(`scripts/${name}`);
    };
    visit('scripts/verify.mjs');
    assert.ok(engine.size > 4, [...engine].join(' '));
    for (const file of engine) {
      assert.ok(classify([file], plain).dart, file);
      assert.ok(CHECK_ENGINE.test(file), `CHECK_ENGINE has ${file}`);
    }
  });
});

describe('the pull request size notice', () => {
  it('counts only the files written by hand', () => {
    assert.deepEqual(
      handWritten([
        'apps/admin/src/App.tsx',
        'docs/slices/D.11b-sign-in.md',
        'pnpm-lock.yaml',
        'pubspec.lock',
        'packages/core_api/lib/api.dart',
        'packages/api-schema/openapi.json',
        'packages/api-schema/src/schema.ts',
        'packages/core_l10n/lib/src/generated/app_localizations.dart',
        'packages/core_api/lib/src/model/order.g.dart',
        'apps/server/migrations/meta/0042_snapshot.json',
        'docs/brand/logo/mark/mark-orange.svg',
        'apps/admin/src/__snapshots__/app.test.tsx.snap',
      ]),
      ['apps/admin/src/App.tsx', 'docs/slices/D.11b-sign-in.md'],
    );
  });

  it('leaves out every generated file the edit guard refuses', () => {
    // Read, not imported: CI's scripts do not depend on .claude/.
    const policy = readFileSync('.claude/hooks/lib/policy.mjs', 'utf8');
    const list = /^const GENERATED = \[([\s\S]*?)^\];/m.exec(policy);
    assert.ok(list, 'policy.mjs has its GENERATED list');
    const guarded = [
      ...list[1].replace(/^\s*\/\/.*$/gm, '').matchAll(/^\s*(\/.+\/[a-z]*),$/gm),
    ].map((match) => match[1]);
    assert.ok(guarded.length > 5, guarded.join(' '));
    const mine = NOT_HAND_WRITTEN.map(String);
    for (const each of guarded) assert.ok(mine.includes(each), each);
  });
});

describe('the TypeScript jobs of ci.yml', () => {
  it('build and smoke test every package with a build or smoke tests, and the gate needs them', () => {
    const e2e = job('e2e');
    assert.match(
      e2e,
      /node scripts\/verify\.mjs e2e --package=@fox-drop\/\$\{\{ matrix\.package \}\}/,
    );
    const matrix = /^ +package: \[([^\]]+)\]$/m.exec(e2e);
    assert.ok(matrix, 'the e2e job has a package matrix');
    const inMatrix = matrix[1].split(',').map((each) => `@fox-drop/${each.trim()}`);
    const globs = [...readFileSync('pnpm-workspace.yaml', 'utf8').matchAll(/^ {2}- (\S+)$/gm)].map(
      (match) => new RegExp(`^${match[1].replace('*', '[^/]+')}/package\\.json$`),
    );
    const withE2e = tracked()
      .filter((file) => globs.some((glob) => glob.test(file)))
      .map((file) => JSON.parse(readFileSync(file, 'utf8')))
      .filter(({ scripts = {} }) => scripts.build || scripts['test:e2e'])
      .map(({ name }) => name);
    assert.ok(withE2e.length >= 3, withE2e.join(' '));
    assert.deepEqual(inMatrix.sort(), withE2e.sort());
    // Each job runs on its own output of the classifier (ciJobs), and the gate needs it.
    const gate = job('verify');
    for (const [name, output] of [
      ['lint', 'typescript'],
      ['e2e', 'typescript'],
      ['server', 'server'],
      ['contract', 'contract'],
    ]) {
      assert.match(
        job(name),
        new RegExp(`^ {4}if: needs\\.changes\\.outputs\\.${output} == 'true'$`, 'm'),
        name,
      );
      assert.match(gate, new RegExp(`^ +${name},$`, 'm'), `the gate needs ${name}`);
    }
    // On a pull request lint and e2e check the packages its change affects;
    // main (a push) checks every package.
    for (const name of ['lint', 'e2e']) {
      assert.match(
        job(name),
        /\$\{\{ github\.event_name == 'pull_request' && format\('--affected=\{0\}', github\.event\.pull_request\.base\.sha\) \|\| '' \}\}/,
        `${name} passes the base to verify`,
      );
      assert.match(job(name), /fetch-depth: 0/, `${name} fetches the base commit`);
    }
    const changes = job('changes');
    for (const output of ['typescript', 'server', 'contract'])
      assert.match(
        changes,
        new RegExp(`^ {6}${output}: \\$\\{\\{ steps\\.paths\\.outputs\\.${output} \\}\\}$`, 'm'),
      );
    assert.match(
      changes,
      /classify-changes\.mjs "\$BASE" \$\{\{ github\.event_name == 'push' && '--push' \|\| '' \}\}/,
    );
  });
});

describe('the jobs CI runs for a change (ciJobs)', () => {
  const jobs = (files, options = {}) => {
    const result = ciJobs(files, classify(files, plain), options);
    return Object.keys(result)
      .filter((key) => result[key])
      .join(' ');
  };

  it('runs neither TypeScript, the server nor the contract for a Flutter change', () => {
    assert.equal(jobs(['apps/customer/lib/main.dart']), '');
    assert.equal(jobs(['packages/core_l10n/lib/l10n/app_ar.arb']), '');
  });

  it('runs the TypeScript jobs alone for a web change', () => {
    assert.equal(jobs(['apps/admin/src/App.tsx']), 'typescript');
    assert.equal(jobs(['apps/merchant-portal/src/App.tsx']), 'typescript');
  });

  it('regenerates the contract for every server change, schema or not', () => {
    // A constant a schema reads need not import zod.
    assert.equal(
      jobs(['apps/server/src/modules/ordering/order-states.ts']),
      'typescript server contract',
    );
    // What the Dart client is formatted and built with.
    assert.equal(jobs(['.fvmrc']), 'contract');
    assert.equal(jobs(['pubspec.lock']), 'contract');
    assert.match(jobs(['packages/core_api/pubspec.yaml']), /contract/);
  });

  it('knows every file the server builds from: it has no workspace dependency', () => {
    // The `server` flag counts apps/server and READ_BY_SERVER_TESTS only. A
    // workspace package the server imports would need its folder there, or a
    // change to it alone would skip the server's tests on a pull request.
    const manifest = JSON.parse(readFileSync('apps/server/package.json', 'utf8'));
    const workspace = Object.entries({
      ...manifest.dependencies,
      ...manifest.devDependencies,
    }).filter(([, version]) => String(version).startsWith('workspace:'));
    assert.deepEqual(workspace, []);
  });

  it('runs everything for the check engine, and on main', () => {
    for (const file of [
      '.github/workflows/ci.yml',
      'turbo.json',
      'scripts/verify.mjs',
      'scripts/classify-changes.mjs',
    ]) {
      assert.ok(CHECK_ENGINE.test(file), file);
      assert.equal(jobs([file]), 'typescript server contract', file);
    }
    assert.equal(
      jobs(['apps/customer/lib/main.dart'], { push: true }),
      'typescript server contract',
    );
    // Markdown is nothing, even on main.
    assert.equal(jobs(['docs/roadmap.md'], { push: true }), '');
  });
});

describe('the packages Turborepo checks for a change (turboScope)', () => {
  const DIRS = [
    'apps/admin',
    'apps/merchant-portal',
    'apps/server',
    'infra',
    'packages/api-schema',
  ];
  const scope = (files) => turboScope(files, DIRS);

  it('counts turbo.json’s global dependencies for every package', () => {
    const turbo = JSON.parse(readFileSync('turbo.json', 'utf8'));
    for (const glob of turbo.globalDependencies)
      assert.ok(
        TURBO_ROOT_INPUTS.some((each) => each.name === null && each.glob === glob),
        glob,
      );
  });

  it('reads every input outside a package from turbo.json', () => {
    assert.ok(TURBO_ROOT_INPUTS.length > 10, String(TURBO_ROOT_INPUTS.length));
    assert.ok(
      TURBO_ROOT_INPUTS.some(
        (each) => each.name === '@fox-drop/infra' && each.glob === 'apps/admin/src/media.ts',
      ),
    );
  });

  it('adds nothing for a package file: Turborepo sees it', () => {
    assert.deepEqual(scope(['apps/admin/src/App.tsx']), []);
    assert.deepEqual(scope(['docs/roadmap.md', 'apps/customer/lib/main.dart']), []);
  });

  it('adds the packages whose tasks read a changed file outside them', () => {
    assert.deepEqual(scope(['apps/admin/src/media.ts']), ['@fox-drop/infra']);
    assert.deepEqual(scope(['compose.yaml']).sort(), ['@fox-drop/infra', '@fox-drop/server']);
  });

  it('checks every package for a change outside them it cannot place', () => {
    for (const file of [
      'package.json',
      'pnpm-lock.yaml',
      'pnpm-workspace.yaml',
      'turbo.json',
      'tsconfig.base.json',
      'eslint.config.mjs',
      '.node-version',
      'scripts/verify.mjs',
      'scripts/generate-api.mjs',
    ])
      assert.equal(scope([file]), 'all', file);
  });
});
