import assert from 'node:assert/strict';
import path from 'node:path';
import { describe, it } from 'node:test';

import { check, parse, summarized } from './bash.mjs';
import { failingStep, statusPaths } from './stop-verify.mjs';
import { cut } from './test-summary.mjs';

describe('the fast check at the end of a turn', () => {
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

describe('the test output filter', () => {
  const rewrite = (command) =>
    summarized(command, 'C:\\hooks\\test-summary.mjs', 'C:\\node\\node.exe');

  it('wraps test commands and keeps their exit status', () => {
    assert.equal(
      rewrite('pnpm --filter @fox-drop/server test'),
      '{ pnpm --filter @fox-drop/server test\n} 2>&1 | "C:/node/node.exe" "C:/hooks/test-summary.mjs"; (exit ${PIPESTATUS[0]})',
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
});
