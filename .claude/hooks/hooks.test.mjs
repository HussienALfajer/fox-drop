import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';
import { fileURLToPath } from 'node:url';

import { recordGreen, treeState } from '../../scripts/green-tree.mjs';
import { checkBash, checkEdit, stripPayload, toRepoPath } from './lib/policy.mjs';
import {
  clearEdits,
  cut,
  editsFile,
  failingStep,
  recordEdit,
  shouldCheck,
  statusPaths,
} from './stop-verify.mjs';

const hooks = path.dirname(fileURLToPath(import.meta.url));
const scratch = mkdtempSync(path.join(os.tmpdir(), 'hooks-test-'));
after(() => rmSync(scratch, { recursive: true, force: true }));

const branchOnly = { onMain: false, lockedTests: [] };
const merged = { onMain: true, lockedTests: [] };

describe('toRepoPath', () => {
  it('strips the project root on Windows and POSIX, case-insensitively', () => {
    assert.equal(toRepoPath('D:\\fox-drop\\apps\\server\\x.ts', 'D:\\fox-drop'), 'apps/server/x.ts');
    assert.equal(toRepoPath('d:/Fox-Drop/apps/x.ts', 'D:\\fox-drop\\'), 'apps/x.ts');
    assert.equal(toRepoPath('/home/u/fox-drop/a.ts', '/home/u/fox-drop'), 'a.ts');
  });

  it('resolves .. and a leading ./', () => {
    assert.equal(
      toRepoPath('D:\\fox-drop\\apps\\..\\docs\\archive\\x.md', 'D:\\fox-drop'),
      'docs/archive/x.md',
    );
    assert.equal(toRepoPath('./apps/admin/a.test.ts', 'D:\\fox-drop'), 'apps/admin/a.test.ts');
  });

  it('leaves paths outside the project unchanged', () => {
    assert.equal(toRepoPath('/tmp/other.ts', '/home/u/fox-drop'), '/tmp/other.ts');
  });
});

describe('checkEdit', () => {
  it('allows secret files (owner decision 2026-11-23)', () => {
    for (const p of ['.env', '.env.local', 'apps/server/.env.production', 'infra/key.pem'])
      assert.equal(checkEdit(p, branchOnly), null);
  });

  it('allows ordinary source, new files and hand-written parts of generated packages', () => {
    assert.equal(checkEdit('apps/server/src/modules/ledger/ledger.ts', merged), null);
    assert.equal(checkEdit('apps/server/migrations/0152_new.sql', branchOnly), null);
    assert.equal(checkEdit('packages/core_api/pubspec.yaml', merged), null);
    assert.equal(checkEdit('packages/core_api/test/client_test.dart', merged), null);
    assert.equal(checkEdit('packages/api-schema/src/index.ts', merged), null);
    assert.equal(checkEdit('packages/design-tokens/tokens/color.json', merged), null);
    assert.equal(checkEdit('docs/slices/D.8-inputs-and-forms.md', merged), null);
    assert.equal(checkEdit('docs/backlog.md', merged), null);
  });

  it('refuses generated files and the lockfiles', () => {
    for (const p of [
      'packages/core_api/lib/core_api.dart',
      'packages/core_api/lib/src/model/order.dart',
      'packages/api-schema/openapi.json',
      'packages/api-schema/src/schema.ts',
      'packages/design-tokens/generated/tokens.css',
      'packages/core_l10n/lib/src/generated/app_localizations.dart',
      'packages/core_tokens/lib/src/tokens.g.dart',
      'apps/customer/lib/x.freezed.dart',
      'apps/customer/test/x.mocks.dart',
      'pnpm-lock.yaml',
      'pubspec.lock',
      'apps/server/migrations/meta/_journal.json',
      'apps/server/migrations/meta/0150_snapshot.json',
    ])
      assert.match(checkEdit(p, branchOnly) ?? '', /generated/, p);
  });

  it('refuses the read-only archives in any casing', () => {
    assert.match(checkEdit('docs/archive/claude-code-workflow.md', branchOnly), /read-only/);
    assert.match(checkEdit('docs/slice-notes.md', branchOnly), /read-only/);
    assert.match(checkEdit('Docs/Slice-Notes.md', branchOnly), /read-only/);
  });

  it('protects merged migrations but not ones still on the branch', () => {
    assert.match(checkEdit('apps/server/migrations/0001_audit_events.sql', merged), /merged/);
    assert.equal(checkEdit('apps/server/migrations/0001_audit_events.sql', branchOnly), null);
  });

  it('refuses locked tests only', () => {
    const ctx = { onMain: false, lockedTests: ['apps/server/src/a.test.ts'] };
    assert.match(checkEdit('apps/server/src/a.test.ts', ctx), /locked/);
    assert.match(checkEdit('Apps/Server/src/a.test.ts', ctx), /locked/);
    assert.equal(checkEdit('apps/server/src/b.test.ts', ctx), null);
  });
});

describe('stripPayload', () => {
  it('drops heredoc bodies but keeps the first line', () => {
    const cmd = "cat <<'EOF' > /tmp/x\nsee > apps/admin\nEOF";
    assert.equal(stripPayload(cmd).includes('apps/admin'), false);
    assert.match(stripPayload('cat <<EOF > packages/x.ts\nbody\nEOF'), /> packages\/x\.ts/);
  });

  it('empties message, body and title values', () => {
    assert.equal(stripPayload('git commit -m "move -> apps/admin"'), 'git commit -m ""');
    assert.equal(
      stripPayload("gh pr create --body '> packages/ui-web' --title 'x'"),
      'gh pr create --body "" --title ""',
    );
  });
});

describe('checkBash', () => {
  const refused = [
    // shell writes into source folders
    'echo x > packages/core_ui/lib/a.dart',
    'cat <<EOF >> scripts/verify.mjs',
    'printf x | tee apps/server/src/x.ts',
    "sed -i 's/a/b/' packages/core_time/lib/clock.dart",
    "perl -pi -e 's/a/b/' infra/nginx/headers.conf",
    'Set-Content -Path packages/x/a.ts -Value 1',
    'echo hi > ./.claude/settings.json',
    'echo x > D:/fox-drop/apps/admin/x.ts',
    'echo x > /d/fox-drop/apps/admin/x.ts',
    'echo x > "$CLAUDE_PROJECT_DIR/apps/admin/x.ts"',
    'Set-Content -Path apps\\admin\\x.ts -Value 1',
    'Set-Content -Path D:\\fox-drop\\apps\\admin\\x.ts -Value 1',
    '"x" | Out-File apps\\admin\\x.ts',
    '"x" > apps\\admin\\x.ts',
    'sc apps/admin/x.ts 1',
    'Add-Content scripts/x.mjs 1',
    // git and permissions
    'git commit --no-verify -m x',
    'git push --force origin feature',
    'git push --force-with-lease',
    'git push -f',
    'git push origin +feature',
    'git push origin main',
    'git push origin HEAD:main',
    'git push origin refs/heads/main',
    'claude --dangerously-skip-permissions',
    'claude --permission-mode bypassPermissions',
    'claude --permission-mode=bypassPermissions',
    // run-time fetches
    'npx skills@latest add vercel-labs/ui --skill ui-sdk',
    'npx -y skills add x',
    'npx --yes skills@1.2.3 add x',
    'npx shadcn@latest add button',
    'npx --package=skills skills add x',
    'npx -p skills skills add x',
    'npx.cmd skills',
    'npm exec skills add x',
    'npm x -- skills',
    'pnpm dlx skills add x',
    'yarn dlx skills',
    'bunx skills add x',
    'pnpx skills add x',
    'pnpm exec npx -y skills',
    'yarn exec npx skills@latest',
    'pnpm --filter ui exec npx -y x',
    'pnpm -r exec npx --yes x',
    'bun x npx -y skills',
    'corepack pnpm dlx skills',
    // installs outside pnpm
    'npm i -D vitest',
    'npm install',
    'npm add react',
    'npm ci',
    'cd packages/ui-web && npm install left-pad',
    'npm --prefix packages/ui-web install left-pad',
    'npm.cmd install',
    '/usr/bin/npm install',
    'sudo npm install -g x',
    'yarn',
    'yarn add react',
    'bun add react',
    'bun install',
    'corepack npm install x',
    'corepack yarn add react',
  ];
  for (const cmd of refused) it(`refuses: ${cmd}`, () => assert.notEqual(checkBash(cmd), null));

  const allowed = [
    'pnpm verify',
    'node scripts/verify.mjs --changed',
    'git push -u origin chore/shifa-workflow',
    'git push',
    'git status --short',
    'git log --oneline main',
    // reading is allowed again, secrets included
    'cat CLAUDE.md',
    "sed -n '1,40p' scripts/verify.mjs",
    'head -n 3 apps/server/.env',
    'cat .env',
    'Get-Content apps/server/.env.local',
    // writes outside source folders
    'node scripts/verify.mjs > /dev/null 2>&1',
    'echo done > /tmp/out.txt',
    "sed -i 's/a/b/' docs/myapps/x.md",
    'echo x > docs/notes.md',
    'touch .claude/state/red-phase',
    'rm .claude/state/red-phase',
    // payload text is not a command
    'git commit -m "refactor: move helpers -> apps/admin"',
    'git commit -m "docs: explain --no-verify is refused"',
    "gh pr create --title 'x' --body '> packages/core_ui changed'",
    "cat <<'EOF' > /tmp/notes.md\nwrites go > apps/admin via Edit\nEOF",
    'git commit -m "docs: never run npx skills add or npm install"',
    'grep -rn bypassPermissions .claude/',
    "grep -rn 'npm install' docs",
    "grep -rn 'mainly' docs",
    'echo use npm ci',
    // pnpm and local bins
    'pnpm install --frozen-lockfile',
    'pnpm --filter @fox-drop/server add -D vitest',
    'pnpm exec playwright install chromium',
    'pnpm exec tsc',
    'pnpm exec npx tsc -p tsconfig.json',
    'npx tsc -p tsconfig.json',
    'npx vitest run',
    'npm view prettier version',
    'npm run build',
    'corepack enable',
    'corepack pnpm install',
    `npx ${'--- '.repeat(40)}tsc`,
  ];
  for (const cmd of allowed) it(`allows: ${cmd}`, () => assert.equal(checkBash(cmd), null));
});

// Runs a hook script with an event on stdin.
const runScript = (name, event, env = {}) =>
  spawnSync(process.execPath, [path.join(hooks, name)], {
    input: typeof event === 'string' ? event : JSON.stringify(event),
    encoding: 'utf8',
    env: { ...process.env, ...env },
  });

describe('the guard scripts', () => {
  it('refuse an unreadable event (fail closed)', () => {
    assert.equal(runScript('guard-bash.mjs', '{not json').status, 2);
    assert.equal(runScript('guard-edits.mjs', '{not json').status, 2);
  });

  it('pass the policy through with exit 2 and the reason', () => {
    const bash = runScript('guard-bash.mjs', { tool_input: { command: 'git push -f' } });
    assert.equal(bash.status, 2);
    assert.match(bash.stderr, /Force-pushing/);
    assert.equal(runScript('guard-bash.mjs', { tool_input: { command: 'ls' } }).status, 0);
    const edit = runScript(
      'guard-edits.mjs',
      { tool_input: { file_path: path.join(scratch, 'pnpm-lock.yaml') } },
      { CLAUDE_PROJECT_DIR: scratch },
    );
    assert.equal(edit.status, 2);
    assert.match(edit.stderr, /generated/);
  });

  it('read the locked tests from .claude/state', () => {
    const root = path.join(scratch, 'locked');
    mkdirSync(path.join(root, '.claude', 'state'), { recursive: true });
    writeFileSync(
      path.join(root, '.claude', 'state', 'locked-tests.txt'),
      '# slice D.8\napps/x/a.test.ts\n',
    );
    const edit = (file) =>
      runScript(
        'guard-edits.mjs',
        { tool_name: 'Edit', tool_input: { file_path: path.join(root, file) } },
        { CLAUDE_PROJECT_DIR: root },
      );
    assert.equal(edit('apps/x/a.test.ts').status, 2);
    assert.equal(edit('apps/x/b.test.ts').status, 0);
  });
});

describe('the fast check at the end of a turn', () => {
  it('checks only a session that edited files, never in the red phase or on its retry', () => {
    const dir = path.join(scratch, 'edits');
    const root = path.join(scratch, 'root');
    assert.equal(shouldCheck({ session_id: 'watcher' }, root, dir), false);
    recordEdit('author', 'apps/server/src/app.ts', dir);
    assert.equal(shouldCheck({ session_id: 'author' }, root, dir), true);
    assert.equal(shouldCheck({ session_id: 'watcher' }, root, dir), false);
    assert.equal(shouldCheck({ session_id: 'author', stop_hook_active: true }, root, dir), false);
    mkdirSync(path.join(root, '.claude', 'state'), { recursive: true });
    writeFileSync(path.join(root, '.claude', 'state', 'red-phase'), '');
    assert.equal(shouldCheck({ session_id: 'author' }, root, dir), false);
  });

  // Runs the hook in a new repository with one uncommitted code file, where a stand-in
  // scripts/verify.mjs exits with `status`; the hook's temp folder is under the scratch folder.
  const runHook = (name, status, { edited = true, green = false } = {}) => {
    const repo = path.join(scratch, name);
    const tmp = path.join(repo, 'tmp');
    mkdirSync(path.join(repo, 'scripts'), { recursive: true });
    const git = (...args) => spawnSync('git', args, { cwd: repo });
    git('init', '--quiet');
    writeFileSync(path.join(repo, '.gitignore'), 'tmp/\n.claude/state/\n');
    git('add', '.gitignore');
    git('-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '--quiet', '-m', 'init');
    writeFileSync(
      path.join(repo, 'scripts', 'verify.mjs'),
      `console.log('=== Step');\nconsole.log('the output');\nprocess.exitCode = ${status};`,
    );
    if (green) recordGreen(repo, treeState(repo).fingerprint);
    const dir = path.join(tmp, 'claude-stop-verify');
    if (edited) recordEdit(name, 'scripts/verify.mjs', dir);
    const result = runScript(
      'stop-verify.mjs',
      { session_id: name, cwd: repo },
      { CLAUDE_PROJECT_DIR: repo, TMP: tmp, TEMP: tmp, TMPDIR: tmp },
    );
    return { ...result, edits: editsFile(name, dir) };
  };

  it('runs the check after an edit, and forgets the edits once it passes', () => {
    const result = runHook('passes', 0);
    assert.equal(result.status, 0);
    assert.equal(result.stdout + result.stderr, '');
    assert.ok(!existsSync(result.edits));
  });

  it('hands a failure back to Claude and keeps the edits', () => {
    const result = runHook('fails', 1);
    assert.equal(result.status, 2);
    assert.match(result.stderr, /fast check of the uncommitted changes failed[\s\S]*=== Step/);
    assert.ok(existsSync(result.edits));
  });

  it('skips a tree the last passing verify recorded', () => {
    const result = runHook('green', 1, { green: true });
    assert.equal(result.status, 0);
    assert.equal(result.stdout + result.stderr, '');
    assert.ok(!existsSync(result.edits));
  });

  it('lets the turn end with a notice while another check runs, and keeps the edits', () => {
    const result = runHook('busy', 3);
    assert.equal(result.status, 0);
    assert.match(JSON.parse(result.stdout).systemMessage, /fast check was skipped/);
    assert.ok(existsSync(result.edits));
  });

  it('does not check a session that edited nothing', () => {
    const result = runHook('watcher', 1, { edited: false });
    assert.equal(result.status, 0);
    assert.equal(result.stdout + result.stderr, '');
  });

  it('keeps edits recorded while the check ran for the next turn', () => {
    const dir = path.join(scratch, 'clear');
    const root = path.join(scratch, 'clear-root');
    recordEdit('s', 'a.ts', dir);
    const seen = readFileSync(editsFile('s', dir), 'utf8');
    recordEdit('s', 'b.ts', dir);
    clearEdits('s', seen, dir);
    assert.equal(shouldCheck({ session_id: 's' }, root, dir), true);
    clearEdits('s', readFileSync(editsFile('s', dir), 'utf8'), dir);
    assert.equal(shouldCheck({ session_id: 's' }, root, dir), false);
  });

  it('reads the uncommitted paths, renames by their new name', () => {
    const porcelain = ' M apps/server/src/app.ts\nR  docs/old.md -> docs/new.md\n?? "scripts/a b.mjs"\n';
    assert.deepEqual(statusPaths(porcelain), [
      'apps/server/src/app.ts',
      'docs/new.md',
      'scripts/a b.mjs',
    ]);
  });

  it('reports the step that failed only', () => {
    const output = '\n=== Prettier\nok\n\n=== Server tests\n FAIL a.test.ts\n\nverify: failed';
    assert.equal(failingStep(output), '=== Server tests\n FAIL a.test.ts\n\nverify: failed');
  });

  it('cuts a long step to its failures and its end, never the server log', () => {
    const lines = Array.from({ length: 400 }, (_, i) => `line ${i}`);
    lines[50] = ' FAIL src/a.test.ts > adds';
    lines[100] = '[WebServer] http proxy error: ECONNREFUSED';
    const out = cut(lines.join('\n'), 'C:/out.log');
    assert.match(out, /FAIL src\/a\.test\.ts/);
    assert.match(out, /line 399/);
    assert.doesNotMatch(out, /line 200\n/);
    assert.doesNotMatch(out, /WebServer/);
    assert.match(out, /whole output is in C:\/out\.log/);
    assert.equal(cut('short\noutput', 'x'), 'short\noutput');
  });
});

describe('session end', () => {
  it('warns about uncommitted work and never blocks', () => {
    const repo = path.join(scratch, 'end');
    mkdirSync(repo, { recursive: true });
    spawnSync('git', ['init', '--quiet'], { cwd: repo });
    writeFileSync(path.join(repo, 'a.txt'), 'x');
    const result = runScript('session-end.mjs', { cwd: repo }, { CLAUDE_PROJECT_DIR: repo });
    assert.equal(result.status, 0);
    assert.match(result.stderr, /1 uncommitted change/);
  });
});
