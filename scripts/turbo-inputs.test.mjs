// Turborepo replays a cached task when the files it hashed are unchanged. It
// hashes a package's own files (and those of the packages it depends on,
// through `^transit`), never a file outside the package that a test, a build
// or a smoke test reads from disk. Such a file must be a declared input of the
// task in turbo.json (`$TURBO_ROOT$/...`), or a change to it would replay an
// old pass. This test finds the paths each package's code names outside the
// package and fails when one is not declared.
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, it } from 'node:test';

const turbo = JSON.parse(readFileSync('turbo.json', 'utf8'));
const CACHED_TASKS = ['test', 'build', 'test:e2e'];

const tracked = spawnSync('git', ['-c', 'core.quotePath=false', 'ls-files'], { encoding: 'utf8' })
  .stdout.split(/\r?\n/)
  .filter(Boolean);
const trackedSet = new Set(tracked);
const trackedDirs = new Set(
  tracked.flatMap((file) =>
    file
      .split('/')
      .slice(0, -1)
      .map((_, i, all) => all.slice(0, i + 1).join('/')),
  ),
);
// The licensed fonts are git-ignored and fetched only where they are needed:
// a path under .fonts/ counts as existing everywhere, so the test is the same
// with and without them.
const exists = (file) =>
  trackedSet.has(file) || trackedDirs.has(file) || /^\.fonts(\/|$)/.test(file);

const packages = tracked
  .filter((file) => /^(apps\/[^/]+|packages\/[^/]+|infra)\/package\.json$/.test(file))
  .map((file) => {
    const dir = path.posix.dirname(file);
    const json = JSON.parse(readFileSync(file, 'utf8'));
    const workspace = (deps = {}) =>
      Object.entries(deps)
        .filter(([, version]) => String(version).startsWith('workspace:'))
        .map(([name]) => name);
    return {
      dir,
      name: json.name,
      scripts: json.scripts ?? {},
      dependsOn: [...workspace(json.dependencies), ...workspace(json.devDependencies)],
    };
  });
const byName = new Map(packages.map((each) => [each.name, each]));

/** The task's configuration: the package's own entry over the generic one. */
const taskConfig = (pkg, task) => ({
  ...turbo.tasks[task],
  ...turbo.tasks[`${pkg.name}#${task}`],
});

// A quoted string without interpolation, a comment, and a code file. A build
// reads its package's code but not its tests.
const LITERAL = /'([^'\\\n]+)'|"([^"\\\n]+)"|`([^`$\\\n]+)`/g;
const COMMENT = /\/\*[\s\S]*?\*\/|(^|\s)\/\/.*$/gm;
const CODE = /\.(ts|tsx|mts|cts|js|mjs|cjs)$/;
const TEST_CODE = /\.(test|spec)\.[cm]?[jt]sx?$|(^|\/)(e2e|test|tests)\//;

/**
 * The outside paths the strings of `file` name, and those named by the outside
 * code files among them (a test that runs scripts/countries.mjs reads what
 * that script reads), each once.
 */
function readsOf(file, dir, seen = new Set()) {
  const out = new Set();
  const text = readFileSync(file, 'utf8').replace(COMMENT, '$1');
  for (const match of text.matchAll(LITERAL))
    for (const outside of outsidePaths(file, match[1] ?? match[2] ?? match[3], dir)) {
      out.add(outside);
      if (CODE.test(outside) && trackedSet.has(outside) && !seen.has(outside)) {
        seen.add(outside);
        for (const each of readsOf(outside, dir, seen)) out.add(each);
      }
    }
  return out;
}

/**
 * The repository paths outside `dir` (the package) that a string in `file` may
 * name, and that exist and are not one of the package's parent folders: a
 * relative string (`../x`) taken from the file's folder and from each folder
 * above it up to the package's (`path.join(PACKAGE_DIR, '../x')`), any other
 * string that looks like a path (a slash or a dot in it) taken from the root
 * (`path.join(ROOT, 'docs/x')`). Over-approximated on purpose.
 */
function outsidePaths(file, literal, dir) {
  const bases = [];
  if (/^\.\.?\//.test(literal)) {
    for (let from = path.posix.dirname(file); ; from = path.posix.dirname(from)) {
      bases.push(from);
      if (from === dir || from === '.') break;
    }
  } else if (/[/.]/.test(literal) && !/^[a-z]+:/i.test(literal)) {
    // A bare file name the package has itself (its package.json) is its own.
    if (
      literal.includes('/') ||
      !tracked.some((each) => each.startsWith(`${dir}/`) && each.endsWith(`/${literal}`))
    )
      bases.push('.');
  }
  const out = new Set();
  for (const from of bases) {
    const joined = path.posix
      .normalize(from === '.' ? literal : `${from}/${literal}`)
      .replace(/\/$/, '');
    const inside = joined === dir || joined.startsWith(`${dir}/`);
    const parent = joined === '.' || `${dir}/`.startsWith(`${joined}/`);
    if (!joined.startsWith('..') && !inside && !parent && exists(joined)) out.add(joined);
  }
  return out;
}

/** The packages `pkg` depends on, directly or not: `^transit` hashes their files. */
function dependencies(pkg, seen = new Set()) {
  for (const name of pkg.dependsOn) {
    if (seen.has(name) || !byName.has(name)) continue;
    seen.add(name);
    dependencies(byName.get(name), seen);
  }
  return [...seen].map((name) => byName.get(name).dir);
}

/** Whether the task's hash covers `file` (a repository path, a file or a folder). */
function covered(pkg, task, file) {
  const config = taskConfig(pkg, task);
  if ((turbo.globalDependencies ?? []).includes(file)) return true;
  const viaTransit = (config.dependsOn ?? []).includes('^transit');
  if (viaTransit && dependencies(pkg).some((dir) => file === dir || file.startsWith(`${dir}/`)))
    return true;
  const globs = (config.inputs ?? [])
    .filter((input) => input.startsWith('$TURBO_ROOT$/'))
    .map((input) => input.slice('$TURBO_ROOT$/'.length));
  const files =
    trackedSet.has(file) || /^\.fonts\/.+\.\w+$/.test(file)
      ? [file]
      : [...tracked.filter((each) => each.startsWith(`${file}/`)), `${file}/any`];
  return files.every((each) => globs.some((glob) => path.posix.matchesGlob(each, glob)));
}

describe("Turborepo's cache", () => {
  it("keeps the server's tests out of it: verify.mjs records their passes itself", () => {
    assert.equal(turbo.tasks['@fox-drop/server#test']?.cache, false);
  });

  it('hashes each cached task with its package’s own files', () => {
    for (const pkg of packages)
      for (const task of CACHED_TASKS) {
        if (!pkg.scripts[task]) continue;
        const config = taskConfig(pkg, task);
        if (config.cache === false) continue;
        assert.ok(
          config.inputs?.includes('$TURBO_DEFAULT$'),
          `${pkg.name}#${task}: $TURBO_DEFAULT$`,
        );
        assert.ok(
          config.dependsOn?.includes('^transit') || config.dependsOn?.includes('build'),
          `${pkg.name}#${task}: ^transit`,
        );
      }
  });

  it('declares every file outside a package that its code reads as an input of its cached tasks', () => {
    const missing = [];
    for (const pkg of packages) {
      const tasks = CACHED_TASKS.filter(
        (task) => pkg.scripts[task] && taskConfig(pkg, task).cache !== false,
      );
      if (tasks.length === 0) continue;
      for (const file of tracked.filter(
        (each) =>
          each.startsWith(`${pkg.dir}/`) && CODE.test(each) && !each.includes('/node_modules/'),
      )) {
        const test = TEST_CODE.test(file.slice(pkg.dir.length + 1));
        for (const outside of readsOf(file, pkg.dir))
          for (const task of tasks)
            if (!(task === 'build' && test) && !covered(pkg, task, outside))
              missing.push(`${pkg.name}#${task}: ${outside} (${file})`);
      }
    }
    assert.deepEqual([...new Set(missing)].sort(), []);
  });
});
