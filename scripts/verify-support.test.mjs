import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';
import { fileURLToPath } from 'node:url';

import { pinnedFlutterBin, releaseLock, takeLock } from './verify-support.mjs';

const scratch = mkdtempSync(path.join(os.tmpdir(), 'verify-support-test-'));
after(() => rmSync(scratch, { recursive: true, force: true }));

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

  it('makes verify.mjs say it is busy, exit 3 and leave the lock alone', () => {
    const repo = path.join(scratch, 'repo');
    mkdirSync(repo);
    assert.equal(spawnSync('git', ['init', '--quiet'], { cwd: repo }).status, 0);
    const lock = path.join(repo, '.git', 'verify.lock');
    takeLock(lock, { command: 'format' }); // held by this test, a live process
    const verify = path.join(path.dirname(fileURLToPath(import.meta.url)), 'verify.mjs');
    const result = spawnSync(process.execPath, [verify, 'format'], { cwd: repo, encoding: 'utf8' });
    assert.equal(result.status, 3);
    assert.match(result.stderr, /another check is running in this folder .*verify\.mjs format/);
    assert.ok(existsSync(lock));
    releaseLock(lock);
  });

  it('is released when verify.mjs exits, on a failure too', () => {
    const repo = path.join(scratch, 'released');
    mkdirSync(repo);
    assert.equal(spawnSync('git', ['init', '--quiet'], { cwd: repo }).status, 0);
    const verify = path.join(path.dirname(fileURLToPath(import.meta.url)), 'verify.mjs');
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
