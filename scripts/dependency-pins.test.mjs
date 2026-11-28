// One version of each external dependency across the workspace: two
// package.json files of the pnpm workspace, or two pubspec.yaml files of the
// Dart workspace, that pin the same dependency differently fail here, not at a
// merge conflict (two slices pinned libphonenumber-js at 1.13.15 and 1.13.17).
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { describe, it } from 'node:test';

import { tracked } from './outside-reads.mjs';

// Dependencies pinned differently on purpose, by name, with the reason.
const NODE_EXCEPTIONS = {};
const DART_EXCEPTIONS = {};

const NODE_SECTIONS = ['dependencies', 'devDependencies', 'optionalDependencies'];
const DART_SECTIONS = ['dependencies', 'dev_dependencies', 'dependency_overrides'];

/** The workspace's package.json files: the root's and each one pnpm-workspace.yaml names. */
function nodeManifests() {
  const globs = [...readFileSync('pnpm-workspace.yaml', 'utf8').matchAll(/^ {2}- (\S+)$/gm)].map(
    (match) => new RegExp(`^${match[1].replaceAll('*', '[^/]+')}/package\\.json$`),
  );
  return ['package.json', ...tracked.filter((file) => globs.some((glob) => glob.test(file)))];
}

/** Each external dependency of the package.json files: name -> [{ file, spec }]. */
function nodePins(files, read = (file) => readFileSync(file, 'utf8')) {
  const pins = new Map();
  for (const file of files) {
    const manifest = JSON.parse(read(file));
    for (const section of NODE_SECTIONS)
      for (const [name, spec] of Object.entries(manifest[section] ?? {})) {
        if (spec.startsWith('workspace:')) continue;
        pins.set(name, [...(pins.get(name) ?? []), { file, spec }]);
      }
  }
  return pins;
}

/** The Dart workspace's pubspec.yaml files: the root's and each member's. */
function dartManifests() {
  const members = [...readFileSync('pubspec.yaml', 'utf8').matchAll(/^ {2}- (\S+)$/gm)].map(
    (match) => match[1],
  );
  return ['pubspec.yaml', ...members.map((dir) => `${dir}/pubspec.yaml`)];
}

/**
 * Each external dependency of the pubspec files: name -> [{ file, spec }]. A
 * hosted dependency's spec is its version (written inline or under
 * `version:`); an SDK, path or git dependency and a workspace member
 * (`workspace`, by name) are left out.
 */
function dartPins(files, workspace, read = (file) => readFileSync(file, 'utf8')) {
  const pins = new Map();
  for (const file of files) {
    const entries = [];
    let section = null;
    let entry = null;
    for (const line of read(file).split(/\r?\n/)) {
      if (/^\s*(#|$)/.test(line)) continue;
      const top = /^([a-z_]+):/.exec(line);
      if (top) {
        section = DART_SECTIONS.includes(top[1]) ? top[1] : null;
        entry = null;
        continue;
      }
      if (!section) continue;
      const own = /^ {2}([a-z0-9_]+):\s*(.*?)\s*$/.exec(line);
      if (own) {
        entry = { name: own[1], spec: own[2].replace(/^['"]|['"]$/g, '') || null, source: null };
        entries.push(entry);
        continue;
      }
      const nested = /^ {4}([a-z_]+):\s*(.*?)\s*$/.exec(line);
      if (!entry || !nested) continue;
      if (nested[1] === 'version') entry.spec = nested[2].replace(/^['"]|['"]$/g, '');
      else if (['sdk', 'path', 'git'].includes(nested[1])) entry.source = nested[1];
    }
    for (const { name, spec, source } of entries) {
      if (source || spec === null || workspace.has(name)) continue;
      pins.set(name, [...(pins.get(name) ?? []), { file, spec }]);
    }
  }
  return pins;
}

/** The dependencies pinned more than one way, as lines, but for the exceptions. */
function conflicts(pins, exceptions = {}) {
  return [...pins]
    .filter(([name, uses]) => !exceptions[name] && new Set(uses.map((use) => use.spec)).size > 1)
    .map(([name, uses]) => `${name}: ${uses.map((use) => `${use.spec} in ${use.file}`).join(', ')}`)
    .sort();
}

describe('the dependency pins', () => {
  it('find a dependency pinned two ways, and nothing else', () => {
    const files = {
      'a/package.json': JSON.stringify({
        dependencies: { 'libphonenumber-js': '1.13.15', shared: 'workspace:*' },
        devDependencies: { vitest: '4.1.0' },
      }),
      'b/package.json': JSON.stringify({
        dependencies: { 'libphonenumber-js': '1.13.17', shared: 'workspace:^' },
        devDependencies: { vitest: '4.1.0' },
      }),
    };
    const pins = nodePins(Object.keys(files), (file) => files[file]);
    assert.deepEqual(conflicts(pins), [
      'libphonenumber-js: 1.13.15 in a/package.json, 1.13.17 in b/package.json',
    ]);
    assert.deepEqual(conflicts(pins, { 'libphonenumber-js': 'a reason' }), []);
  });

  it('read a pubspec: hosted versions, not the SDK, path, git or workspace ones', () => {
    const files = {
      'a/pubspec.yaml': [
        'name: a',
        'dependencies:',
        '  core_auth: any',
        '  dio: 5.11.1',
        '  flutter:',
        '    sdk: flutter',
        '  local:',
        '    path: ../local',
        '  hosted_one:',
        '    hosted: https://pub.example',
        '    version: 1.0.0',
        '# a comment',
        'dev_dependencies:',
        "  test: '1.31.1'",
        'flutter:',
        '  uses-material-design: true',
      ].join('\n'),
      'b/pubspec.yaml': [
        'name: b',
        'dependencies:',
        '  dio: 5.11.2',
        '  hosted_one:',
        '    hosted: https://pub.example',
        '    version: 1.0.0',
        'dev_dependencies:',
        '  test: 1.31.1',
      ].join('\r\n'),
    };
    const pins = dartPins(Object.keys(files), new Set(['core_auth']), (file) => files[file]);
    assert.deepEqual([...pins.keys()].sort(), ['dio', 'hosted_one', 'test']);
    assert.deepEqual(conflicts(pins), ['dio: 5.11.1 in a/pubspec.yaml, 5.11.2 in b/pubspec.yaml']);
  });

  it('are one version per dependency in the pnpm workspace', () => {
    const files = nodeManifests();
    assert.ok(files.length > 5, files.join(' '));
    const pins = nodePins(files);
    // It reads the real files: react is declared by several packages.
    assert.ok(pins.get('react')?.length > 1, [...pins.keys()].join(' '));
    assert.deepEqual(conflicts(pins, NODE_EXCEPTIONS), []);
  });

  it('are one version per dependency in the Dart workspace', () => {
    const files = dartManifests();
    assert.ok(files.length > 10, files.join(' '));
    const workspace = new Set(
      files.map((file) => /^name: (\S+)$/m.exec(readFileSync(file, 'utf8'))?.[1]),
    );
    const pins = dartPins(files, workspace);
    // It reads the real files: dio is declared by several packages.
    assert.ok(pins.get('dio')?.length > 1, [...pins.keys()].join(' '));
    assert.deepEqual(conflicts(pins, DART_EXCEPTIONS), []);
  });
});
