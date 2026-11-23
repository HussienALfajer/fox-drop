import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';

import { isGreen, recordGreen, treeState } from './green-tree.mjs';

const repo = mkdtempSync(path.join(os.tmpdir(), 'green-tree-'));
after(() => rmSync(repo, { recursive: true, force: true }));
const git = (...args) => spawnSync('git', args, { cwd: repo, encoding: 'utf8' });

describe('green tree', () => {
  it('has no state outside a repository with a commit', () => {
    git('init', '--quiet');
    assert.equal(treeState(repo), null);
  });

  it('changes with an edit, an untracked file and a commit, never with an ignored file', () => {
    writeFileSync(path.join(repo, '.gitignore'), '.claude/state/\nignored.txt\n');
    writeFileSync(path.join(repo, 'a.ts'), 'one');
    git('add', '.');
    git('-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '--quiet', '-m', 'init');
    const clean = treeState(repo).fingerprint;

    writeFileSync(path.join(repo, 'ignored.txt'), 'x');
    assert.equal(treeState(repo).fingerprint, clean);

    writeFileSync(path.join(repo, 'a.ts'), 'two');
    const edited = treeState(repo).fingerprint;
    assert.notEqual(edited, clean);

    writeFileSync(path.join(repo, 'b.ts'), 'new');
    const untracked = treeState(repo).fingerprint;
    assert.notEqual(untracked, edited);
    writeFileSync(path.join(repo, 'b.ts'), 'newer');
    assert.notEqual(treeState(repo).fingerprint, untracked);

    git('add', '.');
    git('-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '--quiet', '-m', 'two');
    assert.notEqual(treeState(repo).fingerprint, clean);
  });

  it('records the green tree and recognises only that one', () => {
    const { fingerprint } = treeState(repo);
    assert.equal(isGreen(repo, fingerprint), false);
    recordGreen(repo, fingerprint);
    assert.equal(isGreen(repo, fingerprint), true);
    assert.equal(treeState(repo).fingerprint, fingerprint, 'the record is ignored');
    assert.equal(isGreen(repo, ''), false);
    writeFileSync(path.join(repo, 'a.ts'), 'three');
    assert.equal(isGreen(repo, treeState(repo).fingerprint), false);
  });
});
