import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';
import { fileURLToPath } from 'node:url';

import { check, parse, summarized } from './bash.mjs';
import {
  clearEdits,
  editsFile,
  failingStep,
  recordEdit,
  shouldCheck,
  statusPaths,
} from './stop-verify.mjs';
import { cut } from './test-summary.mjs';

const scratch = mkdtempSync(path.join(os.tmpdir(), 'hooks-test-'));
after(() => rmSync(scratch, { recursive: true, force: true }));

describe('the fast check at the end of a turn', () => {
  it('checks only a session that edited files since its last pass', () => {
    const dir = path.join(scratch, 'edits');
    assert.equal(shouldCheck({ session_id: 'watcher' }, dir), false);
    recordEdit('builder', 'apps/server/src/app.ts', dir);
    assert.equal(shouldCheck({ session_id: 'builder' }, dir), true);
    assert.equal(shouldCheck({ session_id: 'watcher' }, dir), false);
    assert.equal(shouldCheck({ session_id: 'builder', stop_hook_active: true }, dir), false);
  });

  // Runs the hook in a new repository with one uncommitted code file, where a
  // stand-in scripts/verify.mjs exits with `status`; the hook's temp folder is
  // under the scratch folder.
  const runHook = (name, status, { edited = true } = {}) => {
    const repo = path.join(scratch, name);
    const tmp = path.join(repo, 'tmp');
    mkdirSync(path.join(repo, 'scripts'), { recursive: true });
    spawnSync('git', ['init', '--quiet'], { cwd: repo });
    writeFileSync(path.join(repo, '.gitignore'), 'tmp/\n');
    writeFileSync(
      path.join(repo, 'scripts', 'verify.mjs'),
      `console.log('=== Step');\nconsole.log('the output');\nprocess.exitCode = ${status};`,
    );
    const dir = path.join(tmp, 'claude-stop-verify');
    if (edited) recordEdit(name, 'scripts/verify.mjs', dir);
    const hook = path.join(path.dirname(fileURLToPath(import.meta.url)), 'stop-verify.mjs');
    const result = spawnSync(process.execPath, [hook], {
      input: JSON.stringify({ session_id: name, cwd: repo }),
      encoding: 'utf8',
      env: { ...process.env, CLAUDE_PROJECT_DIR: repo, TMP: tmp, TEMP: tmp, TMPDIR: tmp },
    });
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
    recordEdit('s', 'a.ts', dir);
    const seen = readFileSync(editsFile('s', dir), 'utf8');
    recordEdit('s', 'b.ts', dir);
    clearEdits('s', seen, dir);
    assert.equal(shouldCheck({ session_id: 's' }, dir), true);
    clearEdits('s', readFileSync(editsFile('s', dir), 'utf8'), dir);
    assert.equal(shouldCheck({ session_id: 's' }, dir), false);
  });

  it('reads the uncommitted paths, renames by their new name', () => {
    const porcelain = ' M apps/server/src/app.ts\0R  docs/new.md\0docs/old.md\0?? scripts/x.mjs\0';
    assert.deepEqual(statusPaths(porcelain), [
      'apps/server/src/app.ts',
      'docs/new.md',
      'scripts/x.mjs',
    ]);
  });

  it('reports the step that failed only', () => {
    const output = '\n=== Prettier\nok\n\n=== Server tests\n FAIL a.test.ts\n\nverify: failed';
    assert.equal(failingStep(output), '=== Server tests\n FAIL a.test.ts\n\nverify: failed');
  });
});

const TRACKED = new Set(['CLAUDE.md', 'apps/server/src/app.ts', 'docs/roadmap.md']);
const root = path.resolve('/repo');
// Like `git ls-files --error-unmatch`: a tracked file, or a folder holding one.
const isTracked = (file, cwd) => {
  const relative = path.relative(root, path.resolve(cwd, file)).replaceAll('\\', '/');
  return [...TRACKED].some((each) => each === relative || each.startsWith(`${relative}/`));
};
const rules = (command, cwd = root) =>
  check(command, cwd, isTracked).map((each) => `${each.rule} ${each.file ?? ''}`.trim());

describe('the Bash guard', () => {
  it('flags reading a tracked file', () => {
    assert.deepEqual(rules('cat CLAUDE.md'), ['read CLAUDE.md']);
    assert.deepEqual(rules("sed -n '10,40p' apps/server/src/app.ts"), [
      'read apps/server/src/app.ts',
    ]);
    assert.deepEqual(rules('head -n 20 docs/roadmap.md'), ['read docs/roadmap.md']);
    assert.deepEqual(rules('tail -30 CLAUDE.md'), ['read CLAUDE.md']);
    assert.deepEqual(rules('cat CLAUDE.md | grep -n Money'), ['read CLAUDE.md']);
  });

  it('follows cd before the read', () => {
    assert.deepEqual(rules('cd apps/server && sed -n 1,5p src/app.ts'), ['read src/app.ts']);
    assert.deepEqual(rules('cd /elsewhere; cat CLAUDE.md'), []);
  });

  it('allows filtering a command output and reading untracked files', () => {
    assert.deepEqual(rules('git log --oneline | head -20'), []);
    assert.deepEqual(rules('pnpm test 2>&1 | tail -n 50'), []);
    assert.deepEqual(rules('git diff | sed -n 1,80p'), []);
    assert.deepEqual(rules('cat .env.example.local'), []);
    assert.deepEqual(rules('tail -f server.log'), []);
    assert.deepEqual(rules('cat > notes.txt <<EOF\nsee CLAUDE.md\nEOF'), []);
  });

  it('flags in-place edits of a tracked file', () => {
    assert.deepEqual(rules("sed -i 's/a/b/' CLAUDE.md"), ['edit CLAUDE.md']);
    assert.deepEqual(rules("sed -i.bak -e 's/a/b/' docs/roadmap.md"), ['edit docs/roadmap.md']);
    assert.deepEqual(rules("perl -pi -e 's/a/b/' CLAUDE.md"), ['edit CLAUDE.md']);
    assert.deepEqual(rules("sed -i 's/a/b/' /tmp/scratch.txt"), []);
  });

  it('flags inline scripts that write files, but not scratchpad ones', () => {
    const python =
      "python - <<'PY'\nfrom pathlib import Path\nPath('CLAUDE.md').write_text('x')\nPY";
    assert.deepEqual(rules(python), ['edit']);
    assert.deepEqual(rules(`node -e "require('fs').writeFileSync('CLAUDE.md', '')"`), ['edit']);
    assert.deepEqual(rules(`node -e "require('fs').writeFileSync('apps/server/src/new.ts', '')"`), [
      'edit',
    ]);
    assert.deepEqual(rules("python -c \"open('C:/Users/x/AppData/Local/Temp/out.txt','w')\""), []);
    assert.deepEqual(rules("python - <<'PY'\nprint(sum(range(10)))\nPY"), []);
    assert.deepEqual(rules('python scripts/tool.py'), []);
  });

  it('allows inline scripts that write only outside the repository', () => {
    const settings = [
      "node - <<'JS'",
      "const fs = require('fs'), os = require('os'), path = require('path');",
      "const file = path.join(os.homedir(), '.claude.json');",
      'fs.writeFileSync(file, JSON.stringify({}));',
      'JS',
    ].join('\n');
    assert.deepEqual(rules(settings), []);
    assert.deepEqual(
      rules(`node -e "require('fs').writeFileSync('~/.claude/settings.json', '')"`),
      [],
    );
    assert.deepEqual(rules("python -c \"open('C:/Users/x/.claude.json','w').write('{}')\""), []);
    assert.deepEqual(rules("python - <<'PY'\nimport sys\nopen(sys.argv[1],'w')\nPY"), []);
  });

  it('allows inline scripts that only print, and a file redirected into a command', () => {
    assert.deepEqual(rules(`node -e "process.stdout.write(String(1 + 1))"`), []);
    assert.deepEqual(rules('python -c "import sys; sys.stderr.write(\'x\')"'), []);
    assert.deepEqual(rules(`node -e "f = open('docs/roadmap.md'); f.write('x')"`), ['edit']);
    assert.deepEqual(rules('docker compose exec -T postgres psql < docs/roadmap.md'), []);
  });

  it('splits on operators but not inside quotes', () => {
    const [first, second] = parse("grep -n 'a|b; c' x && echo ok");
    assert.deepEqual(first[0].words, ['grep', '-n', 'a|b; c', 'x']);
    assert.deepEqual(second[0].words, ['echo', 'ok']);
    const redirected = parse('cat CLAUDE.md 2>&1 >&2');
    assert.equal(redirected.length, 1);
    assert.deepEqual(rules('cat CLAUDE.md 2>&1'), ['read CLAUDE.md']);
  });
});

// The bash that Claude Code's Bash tool runs: Git for Windows' on Windows
// (`bash` there may be WSL's), else the one on PATH.
function findBash() {
  if (process.platform !== 'win32') return 'bash';
  const exec = spawnSync('git', ['--exec-path'], { encoding: 'utf8' }).stdout.trim();
  const gitBash = path.resolve(exec, '..', '..', '..', 'bin', 'bash.exe');
  assert.ok(existsSync(gitBash), 'no bash on PATH and none next to git');
  return gitBash;
}

describe('the test output filter', () => {
  const rewrite = (command) =>
    summarized(command, 'C:\\hooks\\test-summary.mjs', 'C:\\node\\node.exe', 'C:\\out\\x.log');
  const filter = path.join(path.dirname(fileURLToPath(import.meta.url)), 'test-summary.mjs');
  // Runs, through the rewritten command, a stand-in scripts/verify.mjs with this body.
  const runRewritten = (name, body, filterPath, savedTo) => {
    const project = path.join(scratch, name);
    mkdirSync(path.join(project, 'scripts'), { recursive: true });
    writeFileSync(path.join(project, 'scripts', 'verify.mjs'), body);
    const command = `cd "${project.replaceAll('\\', '/')}" && node scripts/verify.mjs`;
    const rewritten = summarized(command, filterPath, process.execPath, savedTo);
    assert.ok(rewritten);
    return spawnSync(findBash(), ['-c', rewritten], { encoding: 'utf8' });
  };

  it('wraps test commands: the shell saves the whole output, the filter reads the file', () => {
    assert.equal(
      rewrite('pnpm --filter @fox-drop/server test'),
      '{ pnpm --filter @fox-drop/server test\n} > "C:/out/x.log" 2>&1; __status=$?; "C:/node/node.exe" "C:/hooks/test-summary.mjs" "C:/out/x.log" ||' +
        ' { echo "[The output filter failed; the last 60 lines follow, the whole output is in C:/out/x.log]"; tail -n 60 "C:/out/x.log"; }; (exit $__status)',
    );
    assert.ok(rewrite('cd /d/fox-drop && pnpm verify'));
    assert.ok(rewrite('node scripts/verify.mjs format'));
    assert.ok(rewrite('dart run melos run test:flutter --no-select'));
    assert.ok(rewrite('cd apps/customer; flutter test test/cart_test.dart'));
  });

  it('leaves alone anything that is not only tests, or already filters its output', () => {
    assert.equal(rewrite('pnpm test | tail -50'), null);
    assert.equal(rewrite('pnpm test > out.txt'), null);
    assert.equal(rewrite('git status && pnpm test'), null);
    assert.equal(rewrite('pnpm install'), null);
    assert.equal(rewrite('cd apps/server'), null);
    assert.equal(rewrite('export PATH="$(evil):$PATH"; pnpm verify'), null);
    assert.equal(rewrite('pnpm test; `evil`'), null);
  });

  it('allows cd, export, echo and node -v around the tests', () => {
    assert.ok(rewrite('export CI=1; node -v; pnpm verify; echo "exit $?"'));
    assert.equal(rewrite('echo start; rm -r build; pnpm test'), null);
  });

  it('keeps short output whole', () => {
    const text = Array.from({ length: 50 }, (_, i) => `line ${i}`).join('\n');
    assert.equal(cut(text, 'saved.log'), text);
  });

  it('cuts long output to headers, failures and the summary', () => {
    const lines = Array.from({ length: 1000 }, (_, i) => `ok test ${i}`);
    lines[0] = '=== Prettier';
    lines[500] = ' FAIL  src/order.test.ts > accepts an order';
    lines[501] = 'AssertionError: expected 1 to be 2';
    lines[999] = 'Tests  1 failed | 998 passed';
    const out = cut(lines.join('\n'), 'saved.log').split('\n');
    assert.ok(out.includes('=== Prettier'));
    assert.ok(out.includes(' FAIL  src/order.test.ts > accepts an order'));
    assert.ok(out.includes('AssertionError: expected 1 to be 2'));
    assert.ok(out.includes('Tests  1 failed | 998 passed'));
    assert.ok(out.includes('ok test 960'));
    assert.ok(!out.includes('ok test 300'));
    assert.match(out.at(-1), /cut from 1000 lines; the whole output is in saved\.log/);
    assert.ok(out.length < 120);
  });

  it("does not take the Playwright web server's log for failures", () => {
    const proxy =
      '@fox-drop/admin:test:e2e: [WebServer] 10:01:02 [vite] http proxy error: /api/v1/me\n' +
      '@fox-drop/admin:test:e2e: [WebServer] AggregateError [ECONNREFUSED]: connect error';
    const lines = [...Array(961).fill(proxy), ...Array(200).fill('ok')];
    lines[1000] =
      'apps/admin/src/main.ts:12:3  error  Unexpected any  @typescript-eslint/no-explicit-any';
    lines.push('Tasks: 1 failed');
    const out = cut(lines.join('\n'), 'saved.log');
    assert.ok(out.includes('@typescript-eslint/no-explicit-any'));
    assert.ok(!out.includes('over the limit'));
    assert.ok(out.split('\n').length < 120);
  });

  it('keeps the exit status and the whole output of a long run', () => {
    const savedTo = path.join(scratch, 'long.log');
    const result = runRewritten(
      'long',
      "for (let i = 0; i < 200000; i++) console.log('line ' + i);\nprocess.exitCode = 3;",
      filter,
      savedTo,
    );
    assert.equal(result.status, 3);
    assert.match(result.stdout, /cut from 200001 lines; the whole output is in/);
    assert.equal(readFileSync(savedTo, 'utf8').split('\n').length, 200001);
  });

  it('prints the last lines and the path when the filter itself fails', () => {
    const savedTo = path.join(scratch, 'fallback.log');
    const result = runRewritten(
      'fallback',
      "console.log('first');\nconsole.error('the real error');\nprocess.exitCode = 1;",
      path.join(scratch, 'missing-filter.mjs'),
      savedTo,
    );
    assert.equal(result.status, 1);
    assert.match(result.stdout, /The output filter failed;.*whole output is in/);
    assert.match(result.stdout, /the real error/);
    assert.match(readFileSync(savedTo, 'utf8'), /first\n.*the real error/s);
  });
});
