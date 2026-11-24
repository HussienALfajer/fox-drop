import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import {
  closeSync,
  mkdirSync,
  mkdtempSync,
  openSync,
  readFileSync,
  readSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { after, describe, it } from 'node:test';

import {
  ALLOWED_FONTS,
  fontFiles,
  hasFontSignature,
  isAllowedFont,
  missingOrChanged,
  readManifest,
} from './fonts.mjs';

const scratch = mkdtempSync(path.join(os.tmpdir(), 'fonts-test-'));
after(() => rmSync(scratch, { recursive: true, force: true }));

describe('the font guard (architecture §9.3: the licensed fonts stay out of this repository)', () => {
  it('finds a font file by its extension, in any case and any folder', () => {
    assert.deepEqual(
      fontFiles(['a/b/Font.TTF', 'x.otf', 'y.woff', 'z.woff2', 'w.eot', 'README.md', 'logo.svg']),
      ['a/b/Font.TTF', 'x.otf', 'y.woff', 'z.woff2', 'w.eot'],
    );
  });

  it('finds no font file among the files git tracks', () => {
    const listed = spawnSync('git', ['ls-files', '-z'], { encoding: 'utf8' });
    assert.equal(listed.status, 0, listed.stderr);
    const tracked = listed.stdout.split('\0').filter(Boolean);
    assert.deepEqual(fontFiles(tracked), []);
  });

  it('recognises a font by its first bytes, whatever the file is called', () => {
    assert.equal(hasFontSignature(Buffer.from('00010000aabb', 'hex')), true);
    assert.equal(hasFontSignature(Buffer.from('OTTO....')), true);
    assert.equal(hasFontSignature(Buffer.from('wOF2....')), true);
    assert.equal(hasFontSignature(Buffer.from('<svg')), false);
    assert.equal(hasFontSignature(Buffer.from('ab')), false);
  });

  it('finds no tracked file that starts like a font, even renamed', () => {
    const listed = spawnSync('git', ['ls-files', '-z'], { encoding: 'utf8' });
    const found = listed.stdout
      .split('\0')
      .filter(Boolean)
      // Source, text and common image files cannot be a renamed font in practice,
      // and opening every tracked file takes most of a minute.
      .filter(
        (file) =>
          !/\.(ts|tsx|js|mjs|cjs|dart|md|json|ya?ml|css|sql|arb|svg|png|jpe?g|gif|webp|lock|txt|html|kt|swift|gradle|plist|xml)$/i.test(
            file,
          ),
      )
      .filter((file) => !isAllowedFont(file))
      .filter((file) => {
        let fd;
        try {
          fd = openSync(file, 'r');
          const head = Buffer.alloc(4);
          return readSync(fd, head, 0, 4, 0) === 4 && hasFontSignature(head);
        } catch {
          return false; // a deleted or unreadable path is not a font
        } finally {
          if (fd !== undefined) closeSync(fd);
        }
      });
    assert.deepEqual(found, []);
  });

  it('finds no font among the files any commit of the branch added', () => {
    const base = spawnSync('git', ['merge-base', 'origin/main', 'HEAD'], { encoding: 'utf8' });
    if (base.status !== 0) return; // no origin/main here (a shallow clone); CI fetches the history
    const added = spawnSync(
      'git',
      ['log', '--diff-filter=A', '--name-only', '--format=', `${base.stdout.trim()}..HEAD`],
      { encoding: 'utf8' },
    );
    assert.equal(added.status, 0, added.stderr);
    assert.deepEqual(fontFiles(added.stdout.split('\n').filter(Boolean)), []);
  });

  it('allows only Fox Lira, under its open licence, with its pinned bytes', () => {
    const paths = Object.keys(ALLOWED_FONTS);
    assert.equal(paths.length, 6);
    for (const file of paths) {
      assert.match(file, /\/fox-lira\/FoxLira-(Regular|Medium|Bold)\.ttf$/);
      assert.ok(isAllowedFont(file), `${file} is missing or its bytes changed`);
      const licence = readFileSync(path.join(path.dirname(file), 'OFL.txt'), 'utf8');
      assert.match(licence, /SIL Open Font License/);
    }
    // The same name elsewhere, or another font beside it, is still a font.
    assert.deepEqual(fontFiles(['packages/ui-web/fonts/FoxLira-Regular.ttf']), [
      'packages/ui-web/fonts/FoxLira-Regular.ttf',
    ]);
    assert.deepEqual(fontFiles(['packages/ui-web/fonts/fox-lira/CoFo.ttf']), [
      'packages/ui-web/fonts/fox-lira/CoFo.ttf',
    ]);
  });

  it('finds no other bytes ever committed under an allowed font path', () => {
    // The working tree is not enough: one commit could add a licensed font at
    // an allowed path and a later one overwrite it with the pinned bytes.
    const base = spawnSync('git', ['merge-base', 'origin/main', 'HEAD'], { encoding: 'utf8' });
    if (base.status !== 0) return; // no origin/main here (a shallow clone); CI fetches the history
    const log = spawnSync(
      'git',
      [
        'log',
        '--diff-filter=AM',
        '--raw',
        '--no-abbrev',
        '--format=',
        `${base.stdout.trim()}..HEAD`,
        '--',
        ...Object.keys(ALLOWED_FONTS),
      ],
      { encoding: 'utf8' },
    );
    assert.equal(log.status, 0, log.stderr);
    const wrong = log.stdout
      .split('\n')
      .filter(Boolean)
      .map((line) => {
        const [meta, file] = line.split('\t');
        return { blob: meta.split(' ')[3], file };
      })
      .filter(({ blob, file }) => {
        const bytes = spawnSync('git', ['cat-file', 'blob', blob], { encoding: 'buffer' }).stdout;
        return createHash('sha256').update(bytes).digest('hex') !== ALLOWED_FONTS[file];
      })
      .map(({ blob, file }) => `${file} ${blob}`);
    assert.deepEqual(wrong, []);
  });

  it('ignores the folder the fetch writes to', () => {
    const ignored = spawnSync('git', ['check-ignore', '--quiet', '.fonts/probe.ttf']);
    assert.equal(ignored.status, 0, '.fonts/ must be in .gitignore');
  });
});

describe('the manifest of the fetched fonts', () => {
  it('lists every font with a name, a file and a SHA-256, and pins the private repository commit', () => {
    const manifest = readManifest();
    assert.match(manifest.repository, /^[\w.-]+\/[\w.-]+$/);
    assert.match(manifest.ref, /^[0-9a-f]{40}$/);
    assert.ok(manifest.files.length > 0);
    for (const file of manifest.files) {
      assert.match(file.path, /^[\w.-]+(\/[\w.-]+)*\.(ttf|otf)$/);
      assert.match(file.sha256, /^[0-9a-f]{64}$/);
    }
    const paths = manifest.files.map((file) => file.path);
    assert.equal(new Set(paths).size, paths.length, 'a path is listed twice');
  });

  it('reports a font that is missing or whose bytes changed', () => {
    const dir = path.join(scratch, 'fonts');
    mkdirSync(dir);
    const bytes = Buffer.from('not a real font');
    writeFileSync(path.join(dir, 'ok.ttf'), bytes);
    writeFileSync(path.join(dir, 'changed.ttf'), 'other bytes');
    const sha = createHash('sha256').update(bytes).digest('hex');
    const files = [
      { path: 'ok.ttf', sha256: sha },
      { path: 'changed.ttf', sha256: sha },
      { path: 'gone.ttf', sha256: sha },
    ];
    assert.deepEqual(missingOrChanged(dir, files), ['changed.ttf', 'gone.ttf']);
  });
});
