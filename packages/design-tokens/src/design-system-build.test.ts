import { existsSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import {
  assets,
  fonts,
  FONTS,
  index,
  MAX_FONT,
  MAX_SVG,
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
      expect(key).toMatch(/^(Logos|App icon|Icons)\/[\w.-]+\.svg$/);
      expect(key).not.toMatch(/broken-edges/);
      expect(bytes.length).toBeLessThanOrEqual(MAX_SVG);
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
    expect(value.groups).toEqual(['Logos', 'App icon', 'Icons']);
    const named = Object.entries(value.assetGroups).flatMap(([group, g]) =>
      g.order.map((file) => `${group}/${file}`),
    );
    expect(named.sort()).toEqual([...uploads.keys()].sort());
    expect(() => index({ created: 'x', assets: {} }, uploads, 'y')).toThrow(/No blob id/);
  });
});
