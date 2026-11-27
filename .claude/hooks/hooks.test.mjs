import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import {
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  symlinkSync,
  writeFileSync,
} from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';
import { fileURLToPath } from 'node:url';

import { recordGreen, treeState } from '../../scripts/green-tree.mjs';
import {
  checkBash,
  checkEdit,
  checkFvmInWorktree,
  checkPinnedSdk,
  stripPayload,
  toRepoPath,
} from './lib/policy.mjs';
import { bashPath, dartOf, pathExport } from './lib/sdk.mjs';
import {
  clearEdits,
  cut,
  editedFiles,
  editsFile,
  MAX_FILES,
  needsReminder,
  planChecks,
  recordEdit,
  shouldCheck,
  summary,
} from './stop-check.mjs';

const hooks = path.dirname(fileURLToPath(import.meta.url));
const scratch = mkdtempSync(path.join(os.tmpdir(), 'hooks-test-'));
after(() => rmSync(scratch, { recursive: true, force: true }));

const branchOnly = { onMain: false, lockedTests: [] };
const merged = { onMain: true, lockedTests: [] };

describe('toRepoPath', () => {
  it('strips the project root on Windows and POSIX, case-insensitively', () => {
    assert.equal(
      toRepoPath('D:\\fox-drop\\apps\\server\\x.ts', 'D:\\fox-drop'),
      'apps/server/x.ts',
    );
    assert.equal(toRepoPath('d:/Fox-Drop/apps/x.ts', 'D:\\fox-drop\\'), 'apps/x.ts');
    assert.equal(toRepoPath('/home/u/fox-drop/a.ts', '/home/u/fox-drop'), 'a.ts');
  });

  it('resolves .. and a leading ./', () => {
    assert.equal(
      toRepoPath('D:\\fox-drop\\apps\\..\\docs\\slices\\x.md', 'D:\\fox-drop'),
      'docs/slices/x.md',
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
    assert.equal(checkEdit('packages/core_l10n/lib/src/arb/app_ar.arb', merged), null);
    assert.equal(checkEdit('docs/slices/1.14-walking-skeleton.md', merged), null);
    assert.equal(checkEdit('docs/backlog.md', merged), null);
  });

  it('refuses generated files and the lockfiles', () => {
    for (const p of [
      'packages/core_api/lib/core_api.dart',
      'packages/core_api/lib/src/model/order.dart',
      'packages/api-schema/openapi.json',
      'packages/api-schema/src/schema.ts',
      'apps/server/src/generated/routes.ts',
      'packages/core_l10n/lib/src/generated/app_localizations.dart',
      'packages/core_api/lib/src/serializers.g.dart',
      'apps/customer/lib/x.freezed.dart',
      'apps/customer/test/x.mocks.dart',
      'pnpm-lock.yaml',
      'pubspec.lock',
      'apps/server/migrations/meta/_journal.json',
      'apps/server/migrations/meta/0150_snapshot.json',
    ])
      assert.match(checkEdit(p, branchOnly) ?? '', /generated/, p);
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
      stripPayload("gh pr create --body '> apps/admin' --title 'x'"),
      'gh pr create --body "" --title ""',
    );
  });
});

describe('checkBash', () => {
  const refused = [
    // shell writes into source folders
    'echo x > packages/core_auth/lib/a.dart',
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
    'claude --permission-mode "bypassPermissions"',
    'git commit -n -m x',
    'git commit -nm x',
    'git push -fu origin feat/x',
    'git push -uf origin feat/x',
    'git push --force=feat/x origin feat/x',
    'git -C . push --force origin feat/x',
    'git -c a=b push -f origin feat/x',
    'git push origin "main"',
    "git push origin HEAD:'main'",
    'git push origin :main',
    'git push --mirror origin',
    'git push --all origin',
    'git -C D:/fox-drop push origin main',
    // a shell started with a command string
    'bash -c "npx -y foo"',
    "sh -c 'git push -f'",
    'powershell -Command "npm install x"',
    'pwsh -NoProfile -c "Set-Content apps/admin/x.ts 1"',
    'cmd /c npx -y foo',
    // more fetches and install aliases
    'npm create vite@latest',
    'pnpm create vite',
    'yarn create react-app x',
    'npm init react-app x',
    'npx create-react-app x',
    'npx @scope/pkg',
    'npx github:user/repo',
    'npx https://example.com/x.tgz',
    'npx -pfoo foo',
    'npm it',
    'npm install-test',
    'npm install-ci-test',
    // a worktree's own source folders still count
    'echo x > D:/fox-drop/.claude/worktrees/w/apps/admin/x.ts',
    'echo x > .claude/settings.json',
    // run-time fetches
    'npx skills@latest add vercel-labs/ui --skill react',
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
    'cd apps/admin && npm install left-pad',
    'npm --prefix apps/admin install left-pad',
    'npm.cmd install',
    '/usr/bin/npm install',
    'sudo npm install -g x',
    'yarn',
    'yarn add react',
    'bun add react',
    'bun install',
    'corepack npm install x',
    'corepack yarn add react',
    // the unpinned Flutter, named explicitly
    'C:\\flutter\\bin\\flutter.bat test',
    'c:/flutter/bin/dart analyze',
    '/c/flutter/bin/dart format x.dart',
    'export PATH=/c/flutter/bin:$PATH && dart --version',
    'export PATH="$PATH:/c/flutter/bin"',
    '& "C:\\flutter\\bin\\dart.bat" --version',
    // a worktree removed before its SDK link (2026-11-25: it emptied the shared SDK)
    'git worktree remove .claude/worktrees/agent-x',
    'git worktree remove --force D:/fox-drop/.claude/worktrees/agent-x',
    'git -C D:/fox-drop worktree remove .claude/worktrees/agent-x',
    'rm -rf .claude/worktrees/agent-x',
    'rm -fr "D:/fox-drop/.claude/worktrees/agent-x/"',
    'rm -r --force /d/fox-drop/.claude/worktrees',
    'Remove-Item -Recurse -Force D:\\fox-drop\\.claude\\worktrees\\agent-x',
    'cmd /c rd /s /q D:\\fox-drop\\.claude\\worktrees\\agent-x',
    'git worktree remove .claude/worktrees/a && rm -f .claude/worktrees/a/.fvm/flutter_sdk',
    'rm -rf .claude/worktrees/a/.fvm/flutter_sdk/ && git worktree remove .claude/worktrees/a',
    'Remove-Item .claude\\worktrees\\a\\.fvm\\flutter_sdk; git worktree remove .claude/worktrees/a',
  ];
  for (const cmd of refused) it(`refuses: ${cmd}`, () => assert.notEqual(checkBash(cmd), null));

  const allowed = [
    'pnpm verify',
    'node scripts/verify.mjs --changed',
    'git push -u origin chore/shifa-workflow',
    'git push',
    'git status --short',
    'git log --oneline main',
    'git push --follow-tags origin feat/x',
    'git -C . push -u origin feat/x',
    'git commit --amend --no-edit',
    'git fetch origin main',
    'npm init',
    'bash -c "pnpm verify"',
    "sh -c 'echo x > /tmp/y'",
    'bash scripts/x.sh',
    'rg -n sc apps/server',
    "Set-Content x.txt 'a' && ls apps/",
    'git push origin feat/x\ngit switch main',
    'node x.mjs > D:/fox-drop/.claude/worktrees/w/out.log',
    'echo 1 > .claude/state/red-phase',
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
    "gh pr create --title 'x' --body '> packages/core_auth changed'",
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
    // the pinned Flutter, and folders that only look like the unpinned one
    'D:/fox-drop/.fvm/flutter_sdk/bin/flutter test',
    'dart format x.dart',
    'ls C:/flutter-old',
    'ls D:/flutter',
    // a worktree's SDK link removed first, and deletes inside a worktree
    'rm -f .claude/worktrees/a/.fvm/flutter_sdk && git worktree remove .claude/worktrees/a',
    'rm -f "D:/fox-drop/.claude/worktrees/a/.fvm/flutter_sdk"; git worktree remove --force D:/fox-drop/.claude/worktrees/a',
    'unlink .claude/worktrees/a/.fvm/flutter_sdk && rm -rf .claude/worktrees/a',
    'cmd /c rmdir "D:\\fox-drop\\.claude\\worktrees\\a\\.fvm\\flutter_sdk"; git worktree remove D:/fox-drop/.claude/worktrees/a',
    'rm -rf .claude/worktrees/a/node_modules/.cache',
    'git worktree list',
    'git worktree prune',
    'git worktree add .claude/worktrees/b -b feat/b',
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

  it('take the root from the checkout the file is in, a worktree included', () => {
    const main = path.join(scratch, 'main-checkout');
    const tree = path.join(main, '.claude', 'worktrees', 'w');
    mkdirSync(tree, { recursive: true });
    spawnSync('git', ['init', '-q', main]);
    spawnSync('git', ['init', '-q', tree]);
    const edit = runScript(
      'guard-edits.mjs',
      {
        tool_name: 'Write',
        cwd: tree,
        tool_input: { file_path: path.join(tree, 'packages/core_api/lib/x.dart') },
      },
      { CLAUDE_PROJECT_DIR: main },
    );
    assert.equal(edit.status, 2);
    assert.match(edit.stderr, /is generated/);
  });
});

describe('the pinned Flutter', () => {
  it('finds dart.exe on Windows and dart elsewhere, never dart.bat', () => {
    assert.equal(
      dartOf('D:\\fox-drop\\.fvm\\flutter_sdk\\bin', 'win32'),
      'D:\\fox-drop\\.fvm\\flutter_sdk\\bin\\cache\\dart-sdk\\bin\\dart.exe',
    );
    assert.equal(
      dartOf('/r/.fvm/flutter_sdk/bin', 'linux'),
      '/r/.fvm/flutter_sdk/bin/cache/dart-sdk/bin/dart',
    );
  });

  it('puts the pinned Dart and Flutter first on PATH, in Git Bash paths', () => {
    assert.equal(bashPath('D:\\fox-drop\\.fvm', 'win32'), '/d/fox-drop/.fvm');
    assert.equal(bashPath('/home/u/x', 'linux'), '/home/u/x');
    assert.equal(
      pathExport('D:\\fox-drop\\.fvm\\flutter_sdk\\bin', 'win32'),
      'export PATH="/d/fox-drop/.fvm/flutter_sdk/bin/cache/dart-sdk/bin:/d/fox-drop/.fvm/flutter_sdk/bin:$PATH"\n',
    );
    assert.equal(
      pathExport('/a $b/bin', 'linux'),
      'export PATH="/a \\$b/bin/cache/dart-sdk/bin:/a \\$b/bin:$PATH"\n',
    );
  });

  it('asks PowerShell for the prefix before a bare dart or flutter', () => {
    const ctx = { tool: 'PowerShell', prefix: '$env:PATH = "x;$env:PATH"; ' };
    for (const cmd of [
      'flutter test',
      'cd apps/customer; flutter test',
      'dart run melos run analyze',
      'dart.bat format x.dart',
      'pnpm install; dart pub get',
    ])
      assert.match(checkPinnedSdk(cmd, ctx) ?? '', /Start the command with: \$env:PATH/, cmd);
    for (const cmd of [
      '$env:PATH = "D:\\fox-drop\\.fvm\\flutter_sdk\\bin;$env:PATH"; flutter test',
      '& D:\\fox-drop\\.fvm\\flutter_sdk\\bin\\flutter.bat test',
      'fvm flutter test',
      'rg dart apps/customer',
      'git commit -m "flutter test passes"',
      'pnpm verify',
    ])
      assert.equal(checkPinnedSdk(cmd, ctx), null, cmd);
    assert.equal(checkPinnedSdk('flutter test', { ...ctx, tool: 'Bash' }), null);
  });

  it('writes the PATH line at session start, or tells Claude the pinned Flutter is missing', () => {
    const repo = path.join(scratch, 'session-start');
    mkdirSync(path.join(repo, '.fvm', 'flutter_sdk', 'bin'), { recursive: true });
    spawnSync('git', ['init', '--quiet'], { cwd: repo });
    const envFile = path.join(scratch, 'session-start.env');
    const started = runScript(
      'session-start.mjs',
      { cwd: repo, source: 'startup' },
      { CLAUDE_PROJECT_DIR: repo, CLAUDE_ENV_FILE: envFile },
    );
    assert.equal(started.status, 0, started.stderr);
    assert.match(
      readFileSync(envFile, 'utf8'),
      /^export PATH=".*\.fvm\/flutter_sdk\/bin\/cache\/dart-sdk\/bin:.*\.fvm\/flutter_sdk\/bin:\$PATH"\n$/,
    );
    const bare = path.join(scratch, 'session-start-bare');
    mkdirSync(bare, { recursive: true });
    spawnSync('git', ['init', '--quiet'], { cwd: bare });
    const missing = runScript(
      'session-start.mjs',
      { cwd: bare, source: 'startup' },
      { CLAUDE_PROJECT_DIR: bare, CLAUDE_ENV_FILE: path.join(scratch, 'bare.env') },
    );
    assert.equal(missing.status, 0);
    assert.match(JSON.parse(missing.stdout).hookSpecificOutput.additionalContext, /missing/);
    assert.ok(!existsSync(path.join(scratch, 'bare.env')));
  });

  it('refuses fvm install and fvm use inside a worktree only', () => {
    const tree = 'D:\\fox-drop\\.claude\\worktrees\\agent-x';
    assert.match(checkFvmInWorktree('fvm install', tree) ?? '', /main checkout/);
    assert.match(checkFvmInWorktree('cd apps; fvm use 3.47.9', `${tree}\\apps`) ?? '', /main/);
    assert.equal(checkFvmInWorktree('fvm install', 'D:\\fox-drop'), null);
    assert.equal(checkFvmInWorktree('fvm list', tree), null);
    assert.equal(checkFvmInWorktree('fvm install', undefined), null);
  });
});

describe('the light check at the end of a turn', () => {
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

  // Runs the hook in a new repository whose node_modules links to this checkout's (Prettier and
  // ESLint), with a one-rule ESLint config; `files` are written uncommitted, `edited` of them
  // recorded as this session's edits. The hook's temp folder is under the scratch folder.
  const modules = path.resolve(hooks, '..', '..', 'node_modules');
  const runHook = (
    name,
    { files = {}, edited = Object.keys(files), green = false, event } = {},
  ) => {
    const repo = path.join(scratch, name);
    const tmp = path.join(repo, 'tmp');
    mkdirSync(repo, { recursive: true });
    const git = (...args) => spawnSync('git', args, { cwd: repo });
    git('init', '--quiet');
    writeFileSync(path.join(repo, '.gitignore'), 'tmp/\nnode_modules\n.claude/state/\n');
    writeFileSync(
      path.join(repo, 'eslint.config.mjs'),
      "export default [{ rules: { 'no-unused-vars': 'error' } }];\n",
    );
    git('add', '.');
    git('-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '--quiet', '-m', 'init');
    if (!existsSync(path.join(repo, 'node_modules')))
      symlinkSync(modules, path.join(repo, 'node_modules'), 'junction');
    for (const [file, text] of Object.entries(files)) {
      mkdirSync(path.dirname(path.join(repo, file)), { recursive: true });
      writeFileSync(path.join(repo, file), text);
    }
    if (green) recordGreen(repo, treeState(repo).fingerprint);
    const dir = path.join(tmp, 'claude-stop-check');
    for (const file of edited) recordEdit(name, path.join(repo, file), dir);
    const result = runScript('stop-check.mjs', event ?? { session_id: name, cwd: repo }, {
      CLAUDE_PROJECT_DIR: repo,
      TMP: tmp,
      TEMP: tmp,
      TMPDIR: tmp,
    });
    const message = result.stdout ? JSON.parse(result.stdout).systemMessage : '';
    return { ...result, message, edits: editsFile(name, dir), repo, dir };
  };
  const clean = { 'src/a.mjs': 'export const a = 1;\n', 'notes.md': '# Notes\n' };

  it('passes clean edits in one line, forgets them and reminds once per tree', () => {
    const result = runHook('clean', { files: clean });
    assert.equal(result.status, 0, result.stderr);
    assert.match(
      result.message,
      /^Light check of 2 edited files \(Prettier 2, ESLint 1\): passed in \d+\.\d s\.\nThe full check has not run on this tree: node scripts\/verify\.mjs --changed/,
    );
    assert.ok(!existsSync(result.edits));
    recordEdit('clean', path.join(result.repo, 'src/a.mjs'), result.dir);
    const tmp = path.join(result.repo, 'tmp');
    const again = runScript(
      'stop-check.mjs',
      { session_id: 'clean', cwd: result.repo },
      { CLAUDE_PROJECT_DIR: result.repo, TMP: tmp, TEMP: tmp, TMPDIR: tmp },
    );
    assert.doesNotMatch(JSON.parse(again.stdout).systemMessage, /full check/);
  });

  it('does not remind on a tree the last passing verify recorded', () => {
    const result = runHook('green', { files: clean, green: true });
    assert.equal(result.status, 0, result.stderr);
    assert.match(result.message, /passed/);
    assert.doesNotMatch(result.message, /full check/);
  });

  it('hands a mis-formatted file back to Claude and keeps the edits', () => {
    const result = runHook('format', { files: { 'src/a.mjs': 'export const   a=1\n' } });
    assert.equal(result.status, 2);
    assert.match(result.stderr, /Light check of 1 edited file .*failed \(Prettier\)/);
    assert.match(result.stderr, /=== Prettier[\s\S]*src\/a\.mjs/);
    assert.ok(existsSync(result.edits));
  });

  it('hands an ESLint error back, linted from the folder of its config', () => {
    const files = { 'src/b.mjs': 'const unused = 1;\n' };
    const result = runHook('lint', { files });
    assert.equal(result.status, 2);
    assert.match(result.stderr, /failed \(ESLint \.\)[\s\S]*no-unused-vars/);
  });

  it('never starts for an untracked file the session did not edit', () => {
    const files = { '.claude/launch.json': '{  "x":1}\n' };
    const result = runHook('untracked', { files, edited: [] });
    assert.equal(result.status, 0);
    assert.equal(result.stdout + result.stderr, '');
  });

  it('is off in the red phase and on its own retry, and says so in the red phase', () => {
    const files = { 'src/a.mjs': 'export const   a=1\n', '.claude/state/red-phase': '' };
    const red = runHook('red', { files });
    assert.equal(red.status, 0);
    assert.match(red.message, /light check is off: \.claude\/state\/red-phase/);
    const retry = runHook('retry', {
      files: { 'src/a.mjs': 'export const   a=1\n' },
      event: { session_id: 'retry', cwd: path.join(scratch, 'retry'), stop_hook_active: true },
    });
    assert.equal(retry.status, 0);
    assert.equal(retry.stdout + retry.stderr, '');
  });

  it('keeps only existing files of this checkout, once each, outside worktrees', () => {
    const root = path.resolve('/repo');
    const exists = (full) => !full.includes('gone');
    const recorded = [
      path.join(root, 'apps/a.ts'),
      path.join(root, 'apps/a.ts'),
      'docs/b.md',
      path.join(root, 'gone.ts'),
      path.join(root, '.claude/worktrees/w/apps/c.ts'),
      path.resolve('/elsewhere/d.ts'),
      '',
    ].join('\n');
    assert.deepEqual(editedFiles(recorded, root, exists), ['apps/a.ts', 'docs/b.md']);
  });

  it('plans Prettier, the pinned dart format and ESLint per package config', () => {
    const configs = new Set(['', 'apps/server', 'apps/admin']);
    const plan = planChecks(
      [
        'apps/server/src/a.ts',
        'apps/server/test/b.test.ts',
        'apps/admin/src/c.tsx',
        'scripts/d.mjs',
        'packages/core_auth/lib/e.dart',
        'docs/f.md',
      ],
      (dir) => configs.has(dir),
    );
    assert.deepEqual(plan.dart, ['packages/core_auth/lib/e.dart']);
    assert.equal(plan.prettier.length, 5);
    assert.deepEqual(Object.fromEntries(plan.eslint), {
      'apps/server': ['src/a.ts', 'test/b.test.ts'],
      'apps/admin': ['src/c.tsx'],
      '': ['scripts/d.mjs'],
    });
    assert.equal(planChecks(['a.ts'], () => false).eslint.size, 0);
  });

  it('says in one line what it checked, and reminds once per unverified code tree', () => {
    const counts = { Prettier: 3, 'dart format': 0, ESLint: 1 };
    assert.equal(
      summary({ files: 3, counts, failed: [], seconds: 2.345 }),
      'Light check of 3 edited files (Prettier 3, ESLint 1): passed in 2.3 s.',
    );
    assert.equal(
      summary({ files: 1, counts: {}, failed: ['Prettier'], seconds: 1, notes: ['x.'] }),
      'Light check of 1 edited file (nothing to check): failed (Prettier) in 1.0 s. x.',
    );
    const tree = { code: true, green: false, fingerprint: 'f', reminded: '' };
    assert.equal(needsReminder(tree), true);
    assert.equal(needsReminder({ ...tree, reminded: 'f' }), false);
    assert.equal(needsReminder({ ...tree, green: true }), false);
    assert.equal(needsReminder({ ...tree, code: false }), false);
    assert.equal(needsReminder({ ...tree, fingerprint: undefined }), false);
    assert.ok(MAX_FILES >= 10);
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
