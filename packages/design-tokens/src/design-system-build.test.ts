import { existsSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { readRegistry } from './components.ts';
import {
  assets,
  fonts,
  FONTS,
  index,
  MAX_FONT,
  MAX_PNG,
  MAX_SVG,
  pendingCards,
  pngSize,
  systemFiles,
} from './design-system-build.ts';
import { designSystem, FONT_FILES } from './design-system.ts';
import { resolveAll } from './resolve.ts';

// The fonts are licensed and fetched only where the build runs: the test
// gives the build stand-in bytes (the SHA-256 check runs in `fonts()`).
const fake = new Map(Object.values(FONT_FILES).map((file) => [file, Buffer.from('font')]));
const files = systemFiles(designSystem(await resolveAll()), fake);
const uploads = assets();

describe("the Design System's files (architecture §9.8)", () => {
  it('stay under project/, relative, without .. or dot-files', () => {
    for (const file of files.keys()) {
      expect(file).toMatch(/^project\//);
      for (const segment of file.split('/')) {
        expect(segment, file).not.toBe('..');
        expect(segment, file).not.toMatch(/^\./);
      }
    }
  });

  it('carry the brand book, the tokens, the cover and the three fonts', () => {
    expect([...files.keys()]).toEqual(
      expect.arrayContaining([
        'project/README.md',
        'project/tokens.json',
        'project/components/Cover/preview.html',
        ...Object.values(FONT_FILES).map((file) => `project/fonts/${file}`),
      ]),
    );
  });

  it('opens the cover with its @dsCard marker and keeps its folder bare', () => {
    const cover = String(files.get('project/components/Cover/preview.html'));
    expect(cover.split('\n')[0]).toMatch(/^<!-- @dsCard height=(2[4-9]\d|3[0-5]\d|360) -->$/);
    expect([...files.keys()].filter((f) => f.startsWith('project/components/Cover/'))).toEqual([
      'project/components/Cover/preview.html',
    ]);
  });

  it('uploads the logo, app icon and line icon SVGs within the caps, the broken-edges icons left out', () => {
    expect([...uploads.keys()].filter((key) => key.startsWith('Icons/'))).toHaveLength(47);
    for (const [key, bytes] of uploads) {
      if (key.startsWith('Flutter/')) continue;
      expect(key).toMatch(/^(Logos|App icon|Icons)\/[\w.-]+\.svg$/);
      expect(key).not.toMatch(/broken-edges/);
      expect(bytes.length).toBeLessThanOrEqual(MAX_SVG);
    }
  });

  it('uploads every golden the registry names, as the store of the Flutter images', () => {
    const goldens = readRegistry().components.flatMap((c) => (c.golden ? [c.golden] : []));
    const images = [...uploads.keys()].filter((key) => key.startsWith('Flutter/'));
    expect(images.sort()).toEqual(goldens.map((file) => `Flutter/${file}`).sort());
    for (const key of images) {
      expect(key).toMatch(/^Flutter\/Fox\w+\.png$/);
      expect(uploads.get(key)!.length).toBeLessThanOrEqual(MAX_PNG);
      expect(pngSize(uploads.get(key)!).width).toBe(720);
    }
  });

  it('draws an image card only for a component whose web twin is pending, under its web name', () => {
    const registry = readRegistry();
    const images = [...uploads.keys()].filter((key) => key.startsWith('Flutter/'));
    const blobs = Object.fromEntries(images.map((key, i) => [key, { blob: `id${i}`, size: 1 }]));
    const drawn = pendingCards({ created: 'x', assets: blobs }, uploads);
    // A component with a web twin has one card, the live one ui-web writes.
    expect([...drawn.keys()].filter((f) => /^project\/components\/Fox/.test(f))).toEqual([]);
    const pending = registry.components.filter((c) => c.web === null);
    expect(pending.map((c) => c.name).sort()).toEqual([...registry.pendingWeb].sort());
    expect([...drawn.keys()].sort()).toEqual(
      pending
        .flatMap((c) => [
          `project/components/${c.name}/README.md`,
          `project/components/${c.name}/preview.html`,
        ])
        .sort(),
    );
    for (const c of pending) {
      const preview = String(drawn.get(`project/components/${c.name}/preview.html`));
      expect(preview.split('\n')[0]).toMatch(
        new RegExp(`^<!-- @dsCard group="${c.group}" height=\\d+ -->$`),
      );
      expect(preview).toContain('src="/_blob/id');
      expect(preview).toContain('Web twin pending');
      expect(preview).toMatch(/#root \{[^}]*background: var\(--fd-color-surface\)/);
      const readme = String(drawn.get(`project/components/${c.name}/README.md`));
      expect(readme.split('\n')[0]).toBe(`# ${c.name}`);
      expect(readme.split('\n')[2]).toMatch(/\.$/);
      expect(readme).toContain(`Flutter: \`${c.flutter}\``);
      expect(readme).toContain('Web twin pending');
    }
  });

  // The real fonts exist only where `pnpm fonts:fetch` ran (not in CI).
  it.runIf(existsSync(FONTS))('checks the fetched CoFo files: pinned and under 1 MB', () => {
    const real = fonts();
    expect([...real.keys()]).toEqual(Object.values(FONT_FILES));
    for (const bytes of real.values()) expect(bytes.length).toBeLessThanOrEqual(MAX_FONT);
  });

  it.runIf(!existsSync(FONTS))('asks for pnpm fonts:fetch when the fonts are absent', () => {
    expect(() => fonts()).toThrow(/run pnpm fonts:fetch/);
  });

  it('indexes every upload, synced from code', () => {
    const blobs = Object.fromEntries(
      [...uploads.keys()].map((key, i) => [key, { blob: `id${i}`, size: 1 }]),
    );
    const value = JSON.parse(
      index({ created: '2026-11-23T00:00:00Z', assets: blobs }, uploads, '2026-11-23T01:00:00Z'),
    ) as {
      editing: string;
      createdOnFiles: { at: string };
      groups: string[];
      assetGroups: Record<string, { order: string[]; files: Record<string, { blob: string }> }>;
    };
    expect(value.editing).toBe('code');
    expect(value.createdOnFiles.at).toBe('2026-11-23T00:00:00Z');
    expect(value.groups).toEqual(['Logos', 'App icon', 'Icons', 'Flutter']);
    const named = Object.entries(value.assetGroups).flatMap(([group, g]) =>
      g.order.map((file) => `${group}/${file}`),
    );
    expect(named.sort()).toEqual([...uploads.keys()].sort());
    expect(() => index({ created: 'x', assets: {} }, uploads, 'y')).toThrow(/No blob id/);
  });
});
