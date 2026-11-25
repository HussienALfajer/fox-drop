import assert from 'node:assert/strict';
import { spawn, spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';
import { fileURLToPath } from 'node:url';

import {
  chromiumFolders,
  chromiumInstalled,
  cut,
  descendants,
  formatDuration,
  hasPassed,
  inputsFingerprint,
  killTree,
  passKey,
  pinnedFlutterBin,
  pinnedSdkPath,
  processAlive,
  pubspecDependencies,
  recordStepPass,
  releaseLock,
  stepTable,
  takeLock,
  turboNote,
  waitForLock,
  windowsProcessTable,
  withDependents,
} from './verify-support.mjs';

const scratch = mkdtempSync(path.join(os.tmpdir(), 'verify-support-test-'));
after(() => rmSync(scratch, { recursive: true, force: true }));
const verify = path.join(path.dirname(fileURLToPath(import.meta.url)), 'verify.mjs');

describe('waiting for the lock', () => {
  const clock = () => {
    let now = 0;
    return { now: () => now, sleep: async (ms) => void (now += ms) };
  };

  it('takes it once the holder releases it, telling each holder once', async () => {
    const answers = [
      { taken: false, holder: { pid: 1 } },
      { taken: false, holder: { pid: 1 } },
      { taken: false, holder: { pid: 2 } },
      { taken: true },
    ];
    const told = [];
    const lock = await waitForLock('x', {
      take: () => answers.shift(),
      onWait: (holder) => told.push(holder.pid),
      ...clock(),
    });
    assert.deepEqual(lock, { taken: true });
    assert.deepEqual(told, [1, 2]);
  });

  it('gives up after the limit, and at once without waiting', async () => {
    const busy = () => ({ taken: false, holder: { pid: 1 } });
    const time = clock();
    assert.equal((await waitForLock('x', { take: busy, limitMs: 10_000, ...time })).taken, false);
    assert.equal(time.now(), 10_000);
    let tries = 0;
    await waitForLock('x', { take: () => (tries++, busy()), wait: false, ...clock() });
    assert.equal(tries, 1);
  });
});

describe('the processes a dead run left', () => {
  it('finds what its steps started, through a parent that is gone, and nothing older', () => {
    const table = [
      { pid: 10, ppid: 1, created: 1000 }, // verify's step, still alive
      { pid: 11, ppid: 10, created: 1001 },
      { pid: 21, ppid: 20, created: 1002 }, // the step 20 is gone; its child is not
      { pid: 22, ppid: 21, created: 1003 },
      { pid: 30, ppid: 20, created: 500 }, // an older process that reuses a parent id
      { pid: 40, ppid: 1, created: 1004 }, // someone else's
    ];
    assert.deepEqual(descendants(table, [10, 20], 900).sort(), [10, 11, 21, 22]);
  });

  it('reads the Windows process table', { skip: process.platform !== 'win32' }, () => {
    const me = windowsProcessTable().find((each) => each.pid === process.pid);
    assert.equal(me.ppid, process.ppid);
    assert.ok(Math.abs(me.created - (Date.now() - process.uptime() * 1000)) < 5000);
  });
});

describe('ending a process tree', () => {
  it('ends a shell and the process it started', async () => {
    const file = path.join(scratch, 'grandchild.pid');
    const script = `require('fs').writeFileSync(${JSON.stringify(file)}, String(process.pid)); setInterval(() => {}, 1000);`;
    const shell = spawn(`"${process.execPath}" -e "${script.replaceAll('"', '\\"')}"`, {
      shell: true,
      detached: process.platform !== 'win32',
      stdio: 'ignore',
    });
    while (!existsSync(file)) await new Promise((resolve) => setTimeout(resolve, 50));
    await new Promise((resolve) => setTimeout(resolve, 100));
    const grandchild = Number(readFileSync(file, 'utf8'));
    assert.ok(processAlive(grandchild));
    killTree(shell.pid);
    for (let i = 0; i < 50 && processAlive(grandchild); i++)
      await new Promise((resolve) => setTimeout(resolve, 100));
    assert.ok(!processAlive(grandchild));
  });
});

describe('the record of the steps that passed', () => {
  const repo = path.join(scratch, 'inputs');
  const git = (...args) => assert.equal(spawnSync('git', args, { cwd: repo }).status, 0);
  mkdirSync(path.join(repo, 'a'), { recursive: true });
  git('init', '--quiet');
  writeFileSync(path.join(repo, 'a', 'one.ts'), 'one');
  writeFileSync(path.join(repo, 'b.ts'), 'b');
  writeFileSync(path.join(repo, '.gitignore'), 'ignored/\n');
  git('add', '.');
  const print = () => inputsFingerprint(repo, ['a'], { ignoredDirs: ['ignored'] });

  it('changes with a tracked, untracked or ignored input, not with a file outside', () => {
    const first = print();
    assert.equal(print(), first);
    writeFileSync(path.join(repo, 'b.ts'), 'b changed');
    assert.equal(print(), first, 'outside the inputs');
    writeFileSync(path.join(repo, 'a', 'one.ts'), 'one changed');
    const edited = print();
    assert.notEqual(edited, first, 'an edit, not staged');
    writeFileSync(path.join(repo, 'a', 'new.ts'), 'new');
    const added = print();
    assert.notEqual(added, edited, 'an untracked file');
    mkdirSync(path.join(repo, 'ignored'));
    writeFileSync(path.join(repo, 'ignored', 'font.ttf'), 'font');
    assert.notEqual(print(), added, 'an ignored folder the check reads');
    rmSync(path.join(repo, 'a', 'one.ts'));
    assert.notEqual(print(), added, 'a deleted file');
  });

  it('remembers a pass by its key', () => {
    const file = path.join(scratch, 'passes.json');
    const key = passKey({ name: 'Server tests', inputs: 'abc' });
    assert.equal(hasPassed(file, key), false);
    recordStepPass(file, key);
    assert.equal(hasPassed(file, key), true);
    assert.equal(hasPassed(file, passKey({ name: 'Server tests', inputs: 'abd' })), false);
  });
});

describe('the output of a run', () => {
  it('writes durations people read', () => {
    assert.equal(formatDuration(420), '0.4 s');
    assert.equal(formatDuration(42_000), '42 s');
    assert.equal(formatDuration(185_000), '3 min 05 s');
  });

  it('tables every step with its result and time', () => {
    const table = stepTable(
      [
        { name: 'Prettier', result: 'passed', ms: 1200 },
        { name: 'Server tests', result: 'unchanged', ms: 300 },
        { name: 'Dart: no change it can break', result: 'skipped' },
      ],
      61_000,
    ).split('\n');
    assert.equal(table.length, 5);
    assert.match(table[1], /passed\s+1\.2 s {2}Prettier$/);
    assert.match(table[2], /unchanged\s+0\.3 s {2}Server tests$/);
    assert.match(table[3], /skipped\s+ {2}Dart: no change it can break$/);
    assert.match(table[4], /1 min 01 s {2}wall time$/);
  });

  it('cuts a long failing output to its failures and its end', () => {
    const lines = Array.from({ length: 500 }, (_, i) => `line ${i}`);
    lines[100] = ' FAIL  src/geo.test.ts > the fee';
    lines[300] = 'Tests  0 failed';
    lines[200] = '  ok 27 [chromium] › refuses an image smaller than 1200×500';
    lines[220] = 'ui-web:test:e2e:   ok 234 [functional] › axe › emptystate--error (774ms)';
    lines[250] = ' × src/fee.test.ts > rounds down';
    const text = cut(lines.join('\n'), 'run/05.log');
    assert.match(text, /^\[… 97 lines …\]\nline 97\nline 98\nline 99\n FAIL {2}src\/geo\.test\.ts/);
    assert.match(text, /line 112\n\[… /);
    assert.doesNotMatch(text, /Tests {2}0 failed/);
    assert.doesNotMatch(text, /1200×500/);
    assert.doesNotMatch(text, /emptystate--error/);
    assert.match(text, / × src\/fee\.test\.ts > rounds down/);
    assert.match(text, /line 499\n\[cut from 500 lines; the whole output is in run\/05\.log\]$/);
    assert.equal(cut('short\noutput', 'x'), 'short\noutput');
  });
});

describe("the web apps' Chromium", () => {
  const browsers = {
    browsers: [
      { name: 'chromium', revision: '1248' },
      { name: 'chromium-headless-shell', revision: '1248' },
      { name: 'ffmpeg', revision: '1013' },
      { name: 'winldd', revision: '1007' },
    ],
  };

  it('names the folders the install fills', () => {
    assert.deepEqual(chromiumFolders(browsers, 'linux'), [
      'chromium-1248',
      'chromium_headless_shell-1248',
      'ffmpeg-1013',
    ]);
    assert.deepEqual(chromiumFolders(browsers, 'win32').at(-1), 'winldd-1007');
  });

  it('is installed only when every folder is complete', () => {
    const cache = path.join(scratch, 'ms-playwright');
    const env = { PLAYWRIGHT_BROWSERS_PATH: cache };
    const ui = path.join(process.cwd(), 'packages', 'ui-web');
    assert.equal(chromiumInstalled([ui], { env }), false);
    assert.equal(chromiumInstalled([path.join(scratch, 'no-package')], { env }), false);
  });
});

describe('the Dart workspace', () => {
  it("reads a pubspec's dependencies and dev dependencies, not its other sections", () => {
    const pubspec = [
      'name: core_ui',
      'environment:',
      '  sdk: ^3.9.0',
      'dependencies:',
      '  core_tokens:',
      '  flutter:',
      '    sdk: flutter',
      'dev_dependencies:',
      '  fox_lints: any',
      'flutter:',
      '  uses-material-design: true',
    ].join('\r\n');
    assert.deepEqual(pubspecDependencies(pubspec), ['core_tokens', 'flutter', 'fox_lints']);
  });

  it('adds every package that depends on a named one, directly or not', () => {
    const workspace = [
      { name: 'core_tokens', dependencies: [] },
      { name: 'core_ui', dependencies: ['core_tokens', 'flutter'] },
      { name: 'customer', dependencies: ['core_ui'] },
      { name: 'core_api', dependencies: [] },
    ];
    assert.deepEqual([...withDependents(workspace, ['core_tokens'])].sort(), [
      'core_tokens',
      'core_ui',
      'customer',
    ]);
    assert.deepEqual([...withDependents(workspace, ['core_api'])], ['core_api']);
  });
});

describe("Turborepo's summary", () => {
  it('says how many tasks came from the cache', () => {
    assert.equal(
      turboNote(' Tasks:    8 successful, 8 total\nCached:    6 cached, 8 total\n'),
      ' (6 of 8 tasks replayed from the cache)',
    );
    assert.equal(turboNote('no summary'), '');
  });
});

describe('the pinned Dart SDK', () => {
  it('comes before Flutter on PATH when it exists', () => {
    const bin = path.join(scratch, 'flutter', 'bin');
    mkdirSync(bin, { recursive: true });
    assert.deepEqual(pinnedSdkPath(bin), [bin]);
    const dart = path.join(bin, 'cache', 'dart-sdk', 'bin');
    mkdirSync(dart, { recursive: true });
    assert.deepEqual(pinnedSdkPath(bin), [dart, bin]);
    assert.deepEqual(pinnedSdkPath(null), []);
  });
});

describe('the lock of one check at a time', () => {
  it('lets one process hold it and tells the next who does', () => {
    const file = path.join(scratch, 'one.lock');
    assert.deepEqual(takeLock(file, { pid: 101, command: '--changed', isAlive: () => true }), {
      taken: true,
    });
    const second = takeLock(file, { pid: 202, isAlive: () => true });
    assert.equal(second.taken, false);
    assert.equal(second.holder.pid, 101);
    assert.equal(second.holder.command, '--changed');
  });

  it('takes over a lock whose process is gone', () => {
    const file = path.join(scratch, 'stale.lock');
    takeLock(file, { pid: 101, isAlive: () => true });
    assert.deepEqual(takeLock(file, { pid: 202, isAlive: (pid) => pid !== 101 }), { taken: true });
  });

  it('takes over a lock older than any check, whose process id may have been reused', () => {
    const file = path.join(scratch, 'old.lock');
    const start = Date.parse('2026-11-21T08:00:00Z');
    takeLock(file, { pid: 101, isAlive: () => true, now: start });
    const hour = 60 * 60 * 1000;
    assert.equal(takeLock(file, { pid: 202, isAlive: () => true, now: start + hour }).taken, false);
    assert.equal(
      takeLock(file, { pid: 202, isAlive: () => true, now: start + 4 * hour }).taken,
      true,
    );
  });

  it('is released only by the process that holds it', () => {
    const file = path.join(scratch, 'release.lock');
    takeLock(file, { pid: 101, isAlive: () => true });
    releaseLock(file, 202);
    assert.ok(existsSync(file));
    releaseLock(file, 101);
    assert.ok(!existsSync(file));
  });

  it('makes verify.mjs --no-wait say it is busy, exit 3 and leave the lock alone', () => {
    const repo = path.join(scratch, 'repo');
    mkdirSync(repo);
    assert.equal(spawnSync('git', ['init', '--quiet'], { cwd: repo }).status, 0);
    const lock = path.join(repo, '.git', 'verify.lock');
    takeLock(lock, { command: 'format' }); // held by this test, a live process
    const result = spawnSync(process.execPath, [verify, 'format', '--no-wait'], {
      cwd: repo,
      encoding: 'utf8',
    });
    assert.equal(result.status, 3);
    assert.match(result.stderr, /another check is running in this folder .*verify\.mjs format/);
    assert.ok(existsSync(lock));
    releaseLock(lock);
  });

  it('makes verify.mjs wait for the lock, saying who holds it, then run', async () => {
    const repo = path.join(scratch, 'waits');
    mkdirSync(repo);
    assert.equal(spawnSync('git', ['init', '--quiet'], { cwd: repo }).status, 0);
    const lock = path.join(repo, '.git', 'verify.lock');
    takeLock(lock, { command: 'format' });
    const child = spawn(process.execPath, [verify, 'contract'], { cwd: repo });
    let stderr = '';
    child.stderr.on('data', (data) => (stderr += data));
    await new Promise((resolve) => setTimeout(resolve, 1500));
    assert.match(
      stderr,
      /waiting for another check in this folder to end \(process \d+, `verify\.mjs format`/,
    );
    releaseLock(lock);
    const status = await new Promise((resolve) => child.on('close', resolve));
    // It took the lock and ran: the contract fails in an empty repository, it is not busy.
    assert.equal(status, 1);
    assert.ok(!existsSync(lock));
  });

  it('is released when verify.mjs exits, on a failure too', () => {
    const repo = path.join(scratch, 'released');
    mkdirSync(repo);
    assert.equal(spawnSync('git', ['init', '--quiet'], { cwd: repo }).status, 0);
    const result = spawnSync(process.execPath, [verify, 'nonsense'], {
      cwd: repo,
      encoding: 'utf8',
    });
    assert.equal(result.status, 1);
    assert.match(result.stderr, /unknown argument nonsense/);
    assert.ok(!existsSync(path.join(repo, '.git', 'verify.lock')));
  });
});

describe('the pinned Flutter', () => {
  const sdk = (root) => {
    const bin = path.join(root, '.fvm', 'flutter_sdk', 'bin');
    mkdirSync(bin, { recursive: true });
    writeFileSync(path.join(bin, 'flutter'), '');
    return bin;
  };

  it("uses this checkout's link, else the main checkout's in a worktree", () => {
    const main = path.join(scratch, 'main');
    const worktree = path.join(main, '.claude', 'worktrees', 'w');
    mkdirSync(worktree, { recursive: true });
    const commonDir = () => path.join(main, '.git');
    assert.equal(pinnedFlutterBin(worktree, commonDir), null);
    const mainBin = sdk(main);
    assert.equal(pinnedFlutterBin(worktree, commonDir), mainBin);
    assert.equal(
      pinnedFlutterBin(worktree, () => null),
      null,
    );
    const ownBin = sdk(worktree);
    assert.equal(
      pinnedFlutterBin(worktree, () => assert.fail('git is asked only without a link')),
      ownBin,
    );
  });
});
