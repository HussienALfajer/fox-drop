// Turborepo replays a cached task when the files it hashed are unchanged. It
// hashes a package's own files (and those of the packages it depends on,
// through `^transit`), never a file outside the package that a test, a build
// or a smoke test reads from disk. Such a file must be a declared input of the
// task in turbo.json (`$TURBO_ROOT$/...`), or a change to it would replay an
// old pass. This test finds the paths each package's code names outside the
// package and fails when one is not declared. A package's own entry
// (`<name>#<task>`) replaces the shared task's settings, it does not add to
// them: the test reads it alone, as Turborepo does.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, it } from 'node:test';

import { readsOf, tracked, trackedSet } from './outside-reads.mjs';

const turbo = JSON.parse(readFileSync('turbo.json', 'utf8'));
const CACHED_TASKS = ['test', 'build', 'test:e2e'];
// What a test needs from the environment under Turborepo's strict mode: the
// database tests reach Docker through Testcontainers.
const TEST_ENV = ['DOCKER_HOST', 'TESTCONTAINERS_*'];

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

/** The task's configuration: the package's own entry when there is one, else the shared one. */
const taskConfig = (pkg, task) => turbo.tasks[`${pkg.name}#${task}`] ?? turbo.tasks[task] ?? {};

// A build reads its package's code but not its tests.
const CODE = /\.(ts|tsx|mts|cts|js|mjs|cjs)$/;
const TEST_CODE = /\.(test|spec)\.[cm]?[jt]sx?$|(^|\/)(e2e|test|tests)\//;

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

const cachedTasks = () =>
  packages.flatMap((pkg) =>
    CACHED_TASKS.filter((task) => pkg.scripts[task] && taskConfig(pkg, task).cache !== false).map(
      (task) => ({ pkg, task, config: taskConfig(pkg, task) }),
    ),
  );

describe("Turborepo's cache", () => {
  it("keeps the server's tests out of it: verify.mjs records their passes itself", () => {
    assert.equal(turbo.tasks['@fox-drop/server#test']?.cache, false);
  });

  it("hashes each cached task with its package's files and its dependencies'", () => {
    for (const { pkg, task, config } of cachedTasks()) {
      const name = `${pkg.name}#${task}`;
      assert.ok(config.inputs?.includes('$TURBO_DEFAULT$'), `${name}: $TURBO_DEFAULT$`);
      assert.ok(config.dependsOn?.includes('^transit'), `${name}: ^transit`);
      if (task === 'test:e2e') assert.ok(config.dependsOn.includes('build'), `${name}: build`);
      assert.ok(Array.isArray(config.outputs), `${name}: outputs`);
    }
  });

  it('passes Docker through to every test, the uncached server tests too', () => {
    for (const pkg of packages) {
      if (!pkg.scripts.test) continue;
      const passed = taskConfig(pkg, 'test').passThroughEnv ?? [];
      for (const name of TEST_ENV) assert.ok(passed.includes(name), `${pkg.name}#test: ${name}`);
    }
  });

  it('reads a package entry alone, as Turborepo does', () => {
    const pkg = { name: '@fox-drop/x' };
    const saved = { ...turbo.tasks };
    turbo.tasks.test = { dependsOn: ['^transit'], passThroughEnv: TEST_ENV };
    turbo.tasks['@fox-drop/x#test'] = { inputs: ['$TURBO_DEFAULT$'] };
    try {
      assert.deepEqual(taskConfig(pkg, 'test'), { inputs: ['$TURBO_DEFAULT$'] });
    } finally {
      turbo.tasks = saved;
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
