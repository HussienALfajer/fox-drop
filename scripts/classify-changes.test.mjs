import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, it } from 'node:test';

import {
  classify,
  DART_PACKAGE_SOURCES,
  dartPackagesSourcedBy,
  handWritten,
  NATIVE_PACKAGES,
  NOT_HAND_WRITTEN,
  READ_BY_SERVER_TESTS,
  SPEC_FILES_READ_BY_TESTS,
  VISUAL_ROOT_SCRIPTS,
} from './classify-changes.mjs';

const tracked = () =>
  spawnSync('git', ['-c', 'core.quotePath=false', 'ls-files'], { encoding: 'utf8' })
    .stdout.split(/\r?\n/)
    .filter(Boolean);

const plain = () => '';
// The image jobs have their own tests below.
const IMAGE_JOBS = ['visual', 'golden'];
const flags = (files, read = plain) => {
  const result = classify(files, read);
  return Object.keys(result)
    .filter((key) => result[key] && !IMAGE_JOBS.includes(key))
    .map((key) => (result[key] === true ? key : `${key}:${result[key]}`))
    .join(' ');
};
const images = (files) => {
  const result = classify(files, plain);
  return IMAGE_JOBS.filter((key) => result[key]).join(' ');
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

  it('runs the TypeScript tests for the docs the design tokens read', () => {
    for (const file of [
      'docs/architecture/09-design-system.md',
      'docs/brand/logo/mark/mark-orange.svg',
      'docs/brand/app-icon/svg/app-icon-08.svg',
    ])
      assert.equal(flags([file]), 'code typescript tokenDocs', file);
    assert.equal(flags(['docs/brand/expression.md']), '');
  });

  it('runs every Dart check for the files outside Dart that core_ui’s tests read', () => {
    assert.equal(
      flags(['packages/ui-web/src/phone-field/phone-cases.json']),
      'code dart build typescript dartScope:all',
    );
    assert.equal(
      flags(['docs/brand/logo/mark/mark-orange-on-ivory-drop.svg']),
      'code dart typescript tokenDocs dartScope:all',
    );
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
    // core_tokens is generated from the token sources and its test reads
    // them: they count as a change to core_tokens (and its dependents).
    assert.equal(
      flags(['packages/design-tokens/tokens/semantic/light.json']),
      'code dart build typescript dartScope:changed',
    );
    assert.deepEqual(dartPackagesSourcedBy('packages/design-tokens/tokens/semantic/light.json'), [
      'packages/core_tokens',
    ]);
    assert.deepEqual(dartPackagesSourcedBy('packages/design-tokens/src/generate.ts'), []);
    // With a file every package shares, still all.
    assert.equal(
      flags(['packages/design-tokens/tokens/semantic/light.json', 'pubspec.yaml']),
      'code dart build typescript dartScope:all',
    );
    assert.equal(flags(['packages/design-tokens/src/generate.ts']), 'code dart build typescript');
  });

  it('runs both parity checks for the component registry and the generated CSS (D.P2)', () => {
    // core_ui's parity test reads the registry and the resolved tokens: they
    // count as a change to core_ui (and the apps on it), and ui-web's e2e
    // runs through Turborepo as a dependent of design-tokens.
    for (const file of [
      'packages/design-tokens/components.json',
      'packages/design-tokens/generated/tokens.css',
    ]) {
      assert.equal(flags([file]), 'code dart build typescript dartScope:changed', file);
      assert.deepEqual(dartPackagesSourcedBy(file), ['packages/core_ui'], file);
      assert.equal(images([file]), 'visual golden', file);
    }
    // A component token is a core_tokens source too.
    assert.deepEqual(dartPackagesSourcedBy('packages/design-tokens/tokens/component/button.json'), [
      'packages/core_tokens',
    ]);
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
    // A dependency changes the native builds only through the lock file.
    assert.equal(flags(['apps/customer/pubspec.yaml']), 'code dart build dartScope:changed');
    assert.equal(
      flags(['packages/core_ui/pubspec.yaml', 'pubspec.lock']),
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
      'scripts/baselines.mjs',
    ])
      assert.equal(flags([file]), 'code dart build typescript', file);
    assert.equal(flags(['scripts/verify-support.test.mjs']), 'code build typescript');
    // The golden job runs it.
    assert.equal(flags(['scripts/golden-docker.mjs']), 'code dart build typescript');
  });

  it('runs the goldens for the fonts and the scripts that fetch them', () => {
    assert.equal(flags(['docs/brand/fonts-manifest.json']), 'code dart typescript tokenDocs');
    for (const file of [
      'scripts/fonts.mjs',
      'scripts/fonts-fetch.mjs',
      'scripts/github-known-hosts.mjs',
    ]) {
      assert.equal(flags([file]), 'code dart build typescript', file);
    }
  });

  it('runs the ui-web screenshots only for what can change one', () => {
    for (const file of [
      'packages/ui-web/src/button/button.tsx',
      'packages/ui-web/src/button/button.stories.tsx',
      'packages/ui-web/.storybook/preview.tsx',
      'packages/ui-web/playwright.config.ts',
      'packages/ui-web/e2e/__screenshots__/button--default-phone.png',
      'packages/ui-web/package.json',
      // The Playwright and Storybook versions, pnpm and its workspace.
      'package.json',
      'pnpm-lock.yaml',
      'pnpm-workspace.yaml',
      // What Vite reads.
      'tsconfig.base.json',
      // The docs the design tokens read: in doubt, a screenshot can follow.
      'docs/architecture/09-design-system.md',
      'docs/brand/app-icon/svg/app-icon-08.svg',
    ])
      assert.equal(images([file]), 'visual', file);
    // Generated Markdown is read; a component's notes are not.
    assert.match(images(['packages/design-tokens/generated/contrast-report.md']), /visual/);
    assert.equal(images(['packages/ui-web/CLAUDE.md']), '');
    for (const file of [
      'apps/server/src/modules/ledger/ledger.service.ts',
      'apps/admin/src/App.tsx',
      'apps/admin/src/locales/ar.json',
      'apps/customer/lib/main.dart',
      'packages/core_l10n/lib/l10n/app_ar.arb',
      'scripts/verify.mjs',
      'turbo.json',
      'docs/roadmap.md',
    ])
      assert.equal(images([file]), '', file);
  });

  it('runs the core_ui goldens only for what can change one', () => {
    for (const file of [
      'packages/core_ui/lib/src/button/fox_button.dart',
      'packages/core_ui/test/golden/goldens/icons.png',
      'packages/core_ui/dart_test.yaml',
      'packages/core_tokens/lib/core_tokens.dart',
      // The job resolves the whole workspace.
      'pubspec.yaml',
      'pubspec.lock',
      'apps/customer/pubspec.yaml',
      '.fvmrc',
      'scripts/golden-docker.mjs',
    ])
      assert.match(images([file]), /golden/, file);
    for (const file of [
      'apps/customer/lib/main.dart',
      'apps/widgetbook/lib/catalogue.dart',
      'packages/core_l10n/lib/l10n/app_ar.arb',
      'packages/core_api/lib/api.dart',
      'analysis_options.yaml',
      'scripts/verify.mjs',
      'docs/architecture/09-design-system.md',
    ])
      assert.doesNotMatch(images([file]), /golden/, file);
  });

  it('runs both image jobs for the tokens, the fonts and what core_ui’s tests read', () => {
    for (const file of [
      'packages/design-tokens/tokens/semantic/light.json',
      'docs/brand/fonts-manifest.json',
      'scripts/fonts.mjs',
      'scripts/fonts-fetch.mjs',
      'scripts/github-known-hosts.mjs',
      // The Node both jobs run on, the line endings they check out with.
      '.node-version',
      '.gitattributes',
      'packages/ui-web/src/phone-field/phone-cases.json',
      'docs/brand/logo/mark/mark-orange-on-ivory-drop.svg',
    ])
      assert.equal(images([file]), 'visual golden', file);
  });

  it('runs the screenshots for the root package.json unless only scripts they do not run changed', () => {
    const manifest = (fields) =>
      JSON.stringify({
        name: 'fox-drop',
        packageManager: 'pnpm@10.0.0',
        scripts: {
          verify: 'node scripts/verify.mjs',
          'fonts:fetch': 'node scripts/fonts-fetch.mjs',
        },
        devDependencies: { prettier: '3.9.10' },
        ...fields,
      });
    const visual = (now, before) =>
      classify(['package.json'], () => now, before === undefined ? null : () => before).visual;
    const base = manifest({});
    // A new script, or another script changed: no screenshot can follow.
    assert.equal(
      visual(
        manifest({
          scripts: {
            verify: 'node scripts/verify.mjs --x',
            'fonts:fetch': 'node scripts/fonts-fetch.mjs',
            baselines: 'node scripts/baselines.mjs',
          },
        }),
        base,
      ),
      false,
    );
    // Keys in another order are the same manifest.
    assert.equal(
      visual(
        JSON.stringify({ devDependencies: { prettier: '3.9.10' }, ...JSON.parse(base) }),
        base,
      ),
      false,
    );
    for (const changed of [
      manifest({ devDependencies: { prettier: '3.9.11' } }),
      manifest({ packageManager: 'pnpm@10.0.1' }),
      manifest({ engines: { node: '24' } }),
      manifest({ pnpm: { overrides: { a: '1.0.0' } } }),
      manifest({ scripts: { 'fonts:fetch': 'node scripts/fonts-fetch.mjs --all' } }),
      manifest({ scripts: { 'fonts:fetch': 'node scripts/fonts-fetch.mjs', postinstall: 'x' } }),
      'not json',
    ])
      assert.equal(visual(changed, base), true, changed);
    // No base, or no file at the base or now: in doubt, it counts.
    assert.equal(visual(base), true);
    assert.equal(visual(base, null), true);
    assert.equal(visual(null, base), true);
    // Every other path is as before.
    assert.equal(
      classify(
        ['pnpm-lock.yaml'],
        () => '',
        () => '',
      ).visual,
      true,
    );
  });

  it('knows every root script the visual job runs', () => {
    const rootScripts = JSON.parse(readFileSync('package.json', 'utf8')).scripts;
    const run = [...job('visual').matchAll(/\bpnpm ([\w:-]+)/g)]
      .map((match) => match[1])
      .filter((script) => rootScripts[script]);
    assert.ok(run.includes('fonts:fetch'), run.join(' '));
    for (const script of run) assert.ok(VISUAL_ROOT_SCRIPTS.includes(script), script);
  });

  it('runs both image jobs for a change to CI itself', () => {
    assert.equal(images(['.github/workflows/ci.yml']), 'visual golden');
    assert.equal(images(['scripts/classify-changes.mjs']), 'visual golden');
    assert.equal(images(['scripts/classify-changes.test.mjs']), '');
  });

  it('sets an image job for every input its CI job and scripts name', () => {
    // Named by a script the job runs, but read only by another job.
    const NOT_READ = {
      visual: ['packages/core_ui/assets/fonts/fox-lira'], // fonts.mjs: the format job's font guard
      golden: ['packages/ui-web/fonts/fox-lira'], // the same
    };
    const files = tracked();
    const known = new Set(files);
    // Every tracked folder below the top level (`packages/ui-web`, not `packages`).
    const dirs = new Set();
    for (const file of files) {
      const parts = file.split('/');
      for (let end = 2; end < parts.length; end += 1) dirs.add(parts.slice(0, end).join('/'));
    }
    const isFile = (each) => known.has(each);
    const isDir = (each) => dirs.has(each);
    const rootScripts = JSON.parse(readFileSync('package.json', 'utf8')).scripts;
    const nodePackages = new Map(
      files
        .filter((file) => /^(apps|packages)\/[^/]+\/package\.json$/.test(file))
        .map((file) => [JSON.parse(readFileSync(file, 'utf8')).name, path.posix.dirname(file)]),
    );
    const dartMembers = [...readFileSync('pubspec.yaml', 'utf8').matchAll(/^ {2}- (\S+)$/gm)].map(
      (match) => match[1],
    );
    const dartPackages = new Map(
      dartMembers.map((dir) => [
        /^name: (\S+)$/m.exec(readFileSync(`${dir}/pubspec.yaml`, 'utf8'))[1],
        dir,
      ]),
    );
    // The repository paths a text names, read from the root or from `from`.
    const named = (text, from, { fromRoot }) =>
      text
        .split(/[\s'"`(),;=]+/)
        .flatMap((token) => [
          ...(fromRoot ? [path.posix.normalize(token)] : []),
          path.posix.join(from, token),
        ])
        .filter((each) => !each.startsWith('..') && (isFile(each) || isDir(each)));

    const inputsOf = (name) => {
      const inputs = new Set();
      const scanned = new Set();
      const add = (each) => {
        assert.ok(each, `${name}: an input outside the workspace`);
        if (inputs.has(each)) return;
        inputs.add(each);
        if (/\.(mjs|js|ts)$/.test(each) && !scanned.has(each)) {
          scanned.add(each);
          const text = readFileSync(each, 'utf8');
          named(text, path.posix.dirname(each), { fromRoot: true }).forEach(add);
        }
        if (isFile(`${each}/package.json`)) addNodePackage(each);
        if (isFile(`${each}/pubspec.yaml`)) addDartPackage(each);
      };
      const addNodePackage = (dir) => {
        const manifest = JSON.parse(readFileSync(`${dir}/package.json`, 'utf8'));
        const deps = { ...manifest.dependencies, ...manifest.devDependencies };
        for (const [dep, version] of Object.entries(deps))
          if (version.startsWith('workspace:')) add(nodePackages.get(dep));
        // What the package's own build and Playwright set-up read outside it
        // (not its unit tests, lint or scripts, which other jobs run).
        for (const file of files.filter((each) => each.startsWith(`${dir}/`))) {
          if (!/\.(ts|tsx|mjs|css)$/.test(file)) continue;
          if (/\.test\.|\/scripts\/|\/(eslint|vitest)\.config\./.test(file)) continue;
          const text = readFileSync(file, 'utf8');
          for (const each of named(text, path.posix.dirname(file), { fromRoot: false }))
            if (!each.startsWith(`${dir}/`)) add(each);
        }
        ['package.json', 'pnpm-lock.yaml', 'pnpm-workspace.yaml'].forEach(add);
      };
      const addDartPackage = (dir) => {
        const pubspec = readFileSync(`${dir}/pubspec.yaml`, 'utf8');
        for (const [, dep] of pubspec.matchAll(/^ {2}([a-z0-9_]+):/gm))
          if (dartPackages.has(dep)) add(dartPackages.get(dep));
        // What its tests read outside it, from the package (flutter test's
        // folder) or from the test file.
        for (const file of files.filter((each) => each.startsWith(`${dir}/`))) {
          if (!file.endsWith('.dart')) continue;
          const text = readFileSync(file, 'utf8');
          for (const each of [
            ...named(text, dir, { fromRoot: false }),
            ...named(text, path.posix.dirname(file), { fromRoot: false }),
          ])
            if (!each.startsWith(`${dir}/`)) add(each);
        }
        // `pub get` resolves the whole workspace.
        [
          'pubspec.yaml',
          'pubspec.lock',
          '.fvmrc',
          ...dartMembers.map((each) => `${each}/pubspec.yaml`),
        ].forEach(add);
      };
      const text = job(name);
      for (const [, script] of text.matchAll(/\bpnpm ([\w:-]+)/g))
        if (rootScripts[script]) named(rootScripts[script], '', { fromRoot: true }).forEach(add);
      for (const [, dep] of text.matchAll(/--filter (\S+)/g)) add(nodePackages.get(dep));
      named(text, '', { fromRoot: true }).forEach(add);
      return inputs;
    };

    for (const name of IMAGE_JOBS) {
      const inputs = inputsOf(name);
      assert.ok(inputs.size > 5, `${name}: found its inputs`);
      for (const input of inputs) {
        if (NOT_READ[name].includes(input)) continue;
        const covered = isDir(input)
          ? files.filter((file) => file.startsWith(`${input}/`) && !file.endsWith('.md'))
          : [input];
        for (const file of covered)
          assert.ok(classify([file], plain)[name], `${name} reads ${file} (through ${input})`);
      }
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

  it('counts sources outside a Dart package only for packages of the Dart workspace', () => {
    const members = [...readFileSync('pubspec.yaml', 'utf8').matchAll(/^ {2}- (\S+)$/gm)].map(
      (match) => match[1],
    );
    for (const [dir, sources] of Object.entries(DART_PACKAGE_SOURCES)) {
      assert.ok(members.includes(dir), dir);
      for (const source of sources)
        assert.ok(
          tracked().some((file) => file.startsWith(source.replace(/\*\*$/, ''))),
          `${dir}: ${source} names tracked files`,
        );
    }
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
    for (const file of engine) assert.ok(classify([file], plain).dart, file);
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
        'packages/design-tokens/generated/contrast-report.md',
        'packages/core_tokens/lib/src/tokens.g.dart',
        'apps/server/migrations/meta/0042_snapshot.json',
        'packages/design-tokens/icons/bell.svg',
        'packages/ui-web/e2e/__screenshots__/button--default-phone.png',
        'packages/core_ui/test/golden/goldens/icons.png',
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
    // The same condition as the jobs that need the TypeScript checks.
    const gate = job('verify');
    for (const name of ['lint', 'e2e']) {
      assert.match(job(name), /^ {4}if: needs\.changes\.outputs\.code == 'true'$/m, name);
      assert.match(gate, new RegExp(`^ +${name},$`, 'm'), `the gate needs ${name}`);
    }
  });
});
