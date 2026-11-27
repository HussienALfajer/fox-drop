import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';

import {
  altersImages,
  changedImages,
  failedScreenshots,
  imageStatus,
  importsOf,
  orphans,
  selectStories,
  suiteKey,
  SUITES,
  suitesFor,
} from './baselines.mjs';
import { recordStepPass } from './verify-support.mjs';

const ROOT = path.resolve(import.meta.dirname, '..');
const git = (args, cwd = ROOT) => {
  const result = spawnSync('git', ['-c', 'core.quotePath=false', ...args], {
    cwd,
    encoding: 'utf8',
    maxBuffer: 64 * 1024 * 1024,
  });
  assert.equal(result.status, 0, result.stderr);
  return result.stdout;
};

describe('which suites a change can alter', () => {
  const cases = [
    ['packages/ui-web/src/button/button.tsx', { visual: true, golden: false }],
    [
      'packages/ui-web/e2e/__screenshots__/button--default-phone.png',
      { visual: true, golden: false },
    ],
    ['packages/ui-web/.storybook/preview.tsx', { visual: true, golden: false }],
    ['packages/ui-web/e2e/visual.spec.ts', { visual: true, golden: false }],
    ['packages/ui-web/scripts/visual-docker.mjs', { visual: true, golden: false }],
    // What no screenshot sees.
    ['packages/ui-web/src/button/button.test.tsx', { visual: false, golden: false }],
    ['packages/ui-web/test/stories.test.ts', { visual: false, golden: false }],
    ['packages/ui-web/e2e/rtl.spec.ts', { visual: false, golden: false }],
    ['packages/ui-web/scripts/bundle.ts', { visual: false, golden: false }],
    ['packages/ui-web/CLAUDE.md', { visual: false, golden: false }],
    // CI's own reasons.
    ['.github/workflows/ci.yml', { visual: false, golden: false }],
    ['scripts/classify-changes.mjs', { visual: false, golden: false }],
    ['packages/core_ui/lib/src/button.dart', { visual: false, golden: true }],
    ['apps/customer/pubspec.yaml', { visual: false, golden: true }],
    ['scripts/golden-docker.mjs', { visual: false, golden: true }],
    ['packages/design-tokens/tokens/color.json', { visual: true, golden: true }],
    ['pnpm-lock.yaml', { visual: true, golden: false }],
    ['.fvmrc', { visual: false, golden: true }],
    ['apps/server/src/main.ts', { visual: false, golden: false }],
    ['docs/roadmap.md', { visual: false, golden: false }],
  ];
  for (const [file, expected] of cases)
    it(file, () => {
      assert.deepEqual(
        { visual: altersImages('visual', file), golden: altersImages('golden', file) },
        expected,
      );
    });

  it('groups the files by suite', () => {
    const files = ['packages/ui-web/src/a/a.tsx', 'packages/core_ui/lib/b.dart', 'README.md'];
    assert.deepEqual(suitesFor(files), {
      visual: ['packages/ui-web/src/a/a.tsx'],
      golden: ['packages/core_ui/lib/b.dart'],
    });
  });

  // A file that can alter a suite's images but is missing from its recorded
  // inputs would leave a stale record "checked".
  it("records every tracked file that can alter a suite's images in its inputs", () => {
    const covered = (paths, file) =>
      paths.some((spec) => {
        const glob = /^:\(glob\)\*\*\/(.+)$/.exec(spec);
        if (glob) return file === glob[1] || file.endsWith(`/${glob[1]}`);
        return file === spec || file.startsWith(`${spec}/`);
      });
    const tracked = git(['ls-files', '-z']).split('\0').filter(Boolean);
    for (const suite of Object.keys(SUITES)) {
      const missing = tracked.filter(
        (file) => altersImages(suite, file) && !covered(SUITES[suite].paths, file),
      );
      assert.deepEqual(missing, [], `${suite} inputs miss these files`);
    }
  });
});

describe('which stories a change reaches', () => {
  const sources = new Map([
    ['packages/ui-web/src/button/button.tsx', "import { Icon } from '../icon/icon';"],
    ['packages/ui-web/src/button/button.stories.tsx', "import { Button } from './button';"],
    ['packages/ui-web/src/icon/icon.tsx', "import { paths } from './paths';"],
    ['packages/ui-web/src/icon/paths.ts', ''],
    ['packages/ui-web/src/icon/icon.stories.tsx', "import { Icon } from './icon';"],
    [
      'packages/ui-web/src/dialog/dialog.tsx',
      "import { Button } from '../button/button';\nimport '../theme.css';",
    ],
    ['packages/ui-web/src/dialog/dialog.stories.tsx', "import { Dialog } from './dialog.tsx';"],
    ['packages/ui-web/src/card/index.ts', ''],
    ['packages/ui-web/src/card/card.stories.tsx', "const lazy = import('../card');"],
    ['packages/ui-web/src/index.ts', "export * from './button/button';"],
  ]);
  const entries = [
    ['button--default', 'button'],
    ['button--hover', 'button'],
    ['icon--default', 'icon'],
    ['dialog--open', 'dialog'],
    ['card--default', 'card'],
  ].map(([id, dir]) => ({ id, importPath: `./src/${dir}/${dir}.stories.tsx` }));
  const select = (...files) => selectStories(files, { sources, entries });

  it('a component selects its own stories and those of every component that imports it', () => {
    assert.deepEqual(select('packages/ui-web/src/dialog/dialog.tsx').stories, ['dialog--open']);
    assert.deepEqual(select('packages/ui-web/src/button/button.tsx').stories, [
      'button--default',
      'button--hover',
      'dialog--open',
    ]);
    assert.deepEqual(select('packages/ui-web/src/icon/paths.ts').stories, [
      'button--default',
      'button--hover',
      'icon--default',
      'dialog--open',
    ]);
  });

  it('a stories file selects its stories; a folder import resolves to its index', () => {
    assert.deepEqual(select('packages/ui-web/src/icon/icon.stories.tsx').stories, [
      'icon--default',
    ]);
    assert.deepEqual(select('packages/ui-web/src/card/index.ts').stories, ['card--default']);
  });

  it('a changed baseline selects its story; one of no story selects nothing', () => {
    const shots = 'packages/ui-web/e2e/__screenshots__';
    assert.deepEqual(select(`${shots}/icon--default-captain.png`).stories, ['icon--default']);
    assert.deepEqual(select(`${shots}/gone--default-phone.png`).stories, []);
  });

  it('a module no story imports selects nothing', () => {
    assert.deepEqual(select('packages/ui-web/src/index.ts').stories, []);
  });

  it('anything else selects every story', () => {
    for (const file of [
      'packages/ui-web/src/theme.css',
      'packages/ui-web/src/styles.css',
      'packages/ui-web/.storybook/preview.tsx',
      'packages/ui-web/e2e/visual.spec.ts',
      'packages/ui-web/playwright.config.ts',
      'packages/ui-web/package.json',
      'packages/design-tokens/tokens/color.json',
      'pnpm-lock.yaml',
      // Deleted: what imported it changed too, but a story may be gone.
      'packages/ui-web/src/old/old.tsx',
    ])
      assert.equal(select('packages/ui-web/src/button/button.tsx', file).all, true, file);
  });

  it('resolves relative imports only, to known modules', () => {
    const known = new Set(['src/a/a.tsx', 'src/b/index.ts', 'src/c.json']);
    const text = [
      "import { A } from './a/a';",
      "import B from './b';",
      "import x from 'react';",
      "export * from './a/a.tsx';",
      "import './c.css';",
      "const raw = import('./a/a?raw');",
    ].join('\n');
    assert.deepEqual(importsOf('src/x.ts', text, known), [
      'src/a/a.tsx',
      'src/b/index.ts',
      'src/a/a.tsx',
      'src/a/a.tsx',
    ]);
  });
});

describe('images', () => {
  it('finds baselines of no story', () => {
    const entries = [{ id: 'button--default' }];
    assert.deepEqual(
      orphans(
        [
          'button--default-phone.png',
          'button--default-captain.png',
          'gone--x-phone.png',
          'notes.txt',
        ],
        entries,
      ),
      ['gone--x-phone.png'],
    );
  });

  it('lists the images an update added, changed and removed', () => {
    const before = new Map([
      ['a.png', '1'],
      ['b.png', '2'],
      ['c.png', '3'],
    ]);
    const after = new Map([
      ['a.png', '1'],
      ['b.png', '9'],
      ['d.png', '4'],
    ]);
    assert.deepEqual(changedImages(before, after), [
      { file: 'b.png', change: 'changed' },
      { file: 'c.png', change: 'removed' },
      { file: 'd.png', change: 'added' },
    ]);
  });

  it("names a failed comparison's story and its diff image", () => {
    const report = {
      suites: [
        {
          specs: [{ ok: true, title: 'button--default on phone', tests: [] }],
          suites: [
            {
              specs: [
                {
                  ok: false,
                  title: 'confirmdialog--invalid on captain',
                  tests: [
                    {
                      results: [
                        {
                          error: {
                            message:
                              '\u001b[31mError: expect(page).toHaveScreenshot(expected) failed\u001b[39m\n\n  58163 pixels (ratio 0.07 of all image pixels) are different.\n\n  Snapshot: x.png',
                          },
                          attachments: [
                            { name: 'x-expected.png', path: '/work/packages/ui-web/e2e/x.png' },
                            {
                              name: 'x-diff.png',
                              path: '/work/packages/ui-web/test-results/v/x-diff.png',
                            },
                          ],
                        },
                      ],
                    },
                  ],
                },
              ],
            },
          ],
        },
      ],
    };
    assert.deepEqual(failedScreenshots(report), [
      {
        title: 'confirmdialog--invalid on captain',
        error:
          'Error: expect(page).toHaveScreenshot(expected) failed 58163 pixels (ratio 0.07 of all image pixels) are different. Snapshot: x.png',
        diff: 'packages/ui-web/test-results/v/x-diff.png',
      },
    ]);
  });
});

describe('the record and --status', () => {
  const repo = mkdtempSync(path.join(os.tmpdir(), 'baselines-'));
  after(() => rmSync(repo, { recursive: true, force: true }));
  const record = path.join(repo, 'record.json');
  const component = 'packages/ui-web/src/a/a.tsx';
  const write = (file, text) => {
    mkdirSync(path.dirname(path.join(repo, file)), { recursive: true });
    writeFileSync(path.join(repo, file), text);
  };

  it('says what to run until the tree is recorded, and again after an edit', () => {
    git(['init', '--quiet'], repo);
    write('.gitignore', 'record.json\n.fonts/\n');
    write(component, 'one');
    write('packages/core_ui/lib/b.dart', 'one');
    git(['add', '.'], repo);
    git(['-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '--quiet', '-m', 'init'], repo);

    const status = () => imageStatus([component], { root: repo, record });
    assert.equal(status().ok, false);
    assert.deepEqual(status().unchecked, ['visual']);
    assert.match(status().line, /ui-web screenshots .* not checked: run `pnpm baselines`/);

    recordStepPass(record, suiteKey('visual', repo));
    assert.equal(status().ok, true);
    assert.match(status().line, /checked/);

    // The fonts count, though git ignores them.
    write('.fonts/cofo/a.ttf', 'x');
    assert.equal(status().ok, false);
    recordStepPass(record, suiteKey('visual', repo));
    write(component, 'two');
    assert.equal(status().ok, false);

    // Committing the checked tree keeps it checked: an update, a new image
    // and a removed one.
    write('packages/ui-web/e2e/__screenshots__/a--b-phone.png', 'png');
    rmSync(path.join(repo, 'packages/core_ui/lib/b.dart'));
    recordStepPass(record, suiteKey('visual', repo));
    assert.equal(status().ok, true);
    git(['add', '--all'], repo);
    assert.equal(status().ok, true);
    git(['-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '--quiet', '-m', 'next'], repo);
    assert.equal(status().ok, true);
  });

  it('needs nothing when no change can alter an image, everything without a base', () => {
    assert.deepEqual(imageStatus(['docs/a.md', 'apps/server/src/x.ts'], { root: repo, record }), {
      ok: true,
      unchecked: [],
      line: 'no change since origin/main can alter an image',
    });
    // `--changed=<ref>` names its own base.
    assert.equal(
      imageStatus(['docs/a.md'], { root: repo, record, since: 'HEAD~3' }).line,
      'no change since HEAD~3 can alter an image',
    );
    // Without a base both suites count; the screenshots are recorded above.
    assert.deepEqual(imageStatus(null, { root: repo, record }).unchecked, ['golden']);
    rmSync(record);
    assert.deepEqual(imageStatus(null, { root: repo, record }).unchecked, ['visual', 'golden']);
  });

  it('answers --status in one line with exit 0 or 1', () => {
    const result = spawnSync(process.execPath, ['scripts/baselines.mjs', '--status'], {
      cwd: ROOT,
      encoding: 'utf8',
    });
    assert.ok([0, 1].includes(result.status), result.stderr);
    assert.match(result.stdout, /^baselines: [^\n]+\n$/);
  });
});
