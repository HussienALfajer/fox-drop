import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import {
  ASSET_GROUPS,
  assetHash,
  assets,
  fonts,
  FONTS,
  index,
  inlineStyles,
  MAX_FONT,
  MAX_SVG,
  mergeBlobs,
  systemFiles,
  toUpload,
} from './design-system-build.ts';
import { designSystem, FONT_FILES } from './design-system.ts';
import { PACKAGE_DIR, resolveAll } from './resolve.ts';

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

  it('uploads every logo and app icon of the brand pack and the line icons, within the caps', () => {
    expect([...uploads.keys()].filter((key) => key.startsWith('Icons/'))).toHaveLength(47);
    // Owner, 2026-11-26: every logo and app icon SVG in docs/brand shows, no PNG.
    expect([...uploads.keys()].filter((key) => key.startsWith('Logos/'))).toHaveLength(14);
    expect([...uploads.keys()].filter((key) => key.startsWith('App icon/')).sort()).toEqual(
      [
        'app-icon-black-fox-on-ivory-rounded.svg',
        'app-icon-black-fox-on-ivory-square.svg',
        'app-icon-ivory-fox-on-black-rounded.svg',
        'app-icon-ivory-fox-on-black-square.svg',
        'app-icon-white-fox-on-orange-rounded.svg',
        'app-icon-white-fox-on-orange-square.svg',
      ].map((file) => `App icon/${file}`),
    );
    for (const [key, bytes] of uploads) {
      expect(key).toMatch(/^(Logos|App icon|Icons)\/[\w.-]+\.svg$/);
      expect(bytes.length).toBeLessThanOrEqual(MAX_SVG);
    }
  });

  // The asset store strips <style> from an SVG, which left the lockups
  // without their colours: the build writes each class rule as attributes.
  it('uploads SVGs without <style> or classes, the lockups keeping their colours', () => {
    for (const [key, bytes] of uploads) {
      if (!key.endsWith('.svg')) continue;
      const svg = bytes.toString('utf8');
      expect(svg, key).not.toMatch(/<style|class="/);
    }
    for (const key of [...uploads.keys()].filter((k) => /^Logos\/lockup-.*\.svg$/.test(k))) {
      const svg = uploads.get(key)!.toString('utf8');
      expect(svg, key).toMatch(/fill="#ff6e31"/);
      expect(svg, key).toMatch(/fill="#03428e"/);
    }
  });

  it('inlines class rules and refuses a style it cannot inline', () => {
    expect(
      inlineStyles(
        '<svg><defs><style>.a{fill:#fff;}.b{fill:#000;stroke:red}</style></defs><path class="a" d="M0"/><path class="b"/></svg>',
      ),
    ).toBe('<svg><path fill="#fff" d="M0"/><path fill="#000" stroke="red"/></svg>');
    expect(() => inlineStyles('<svg><style>path{fill:red}</style></svg>')).toThrow(/class rule/);
    expect(() => inlineStyles('<svg><path class="x"/></svg>')).toThrow(/class "x"/);
  });

  // Web first (architecture T14, §9.8): the system shows the live web
  // components only; a Flutter twin is checked on its parity sheet.
  it('holds no Flutter group, image or card', () => {
    expect(ASSET_GROUPS.map((group) => group.name)).not.toContain('Flutter');
    expect([...uploads.keys()].filter((key) => key.startsWith('Flutter/'))).toEqual([]);
    for (const file of files.keys()) expect(file, file).not.toMatch(/Flutter|\/Fox[A-Z]/);
    expect([...files.keys()].filter((file) => file.startsWith('project/components/'))).toEqual([
      'project/components/Cover/preview.html',
    ]);
    expect(existsSync(path.join(PACKAGE_DIR, '../core_ui/design-system'))).toBe(false);
  });

  it('leaves project/components/ to ui-web, whose every component has its card', () => {
    const bundle = readFileSync(path.join(PACKAGE_DIR, '../ui-web/scripts/bundle.ts'), 'utf8');
    const list = /export const COMPONENTS(?::[^=]*)? = \[([^\]]*)\]/.exec(bundle)![1]!;
    const components = [...list.matchAll(/'(\w+)'/g)].map((match) => match[1]!);
    // None since D.R1 (2026-11-27): each returns with its approved screen.
    expect(new Set(components).size).toBe(components.length);
    for (const name of components) {
      expect(name).not.toBe('Cover');
      const card = path.join(PACKAGE_DIR, '../ui-web/design-system', name);
      expect(existsSync(path.join(card, 'README.md')), name).toBe(true);
      expect(existsSync(path.join(card, 'preview.html')), name).toBe(true);
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
      assetGroups: Record<
        string,
        { order: string[]; files: Record<string, { blob: string; type: string }> }
      >;
    };
    for (const group of Object.values(value.assetGroups))
      for (const [file, record] of Object.entries(group.files))
        expect(record.type, file).toBe('image/svg+xml');
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

describe('the uploads a sync reuses', () => {
  const now = new Map([
    ['Icons/home.svg', Buffer.from('<svg>home</svg>')],
    ['Icons/cart.svg', Buffer.from('<svg>cart v2</svg>')],
    ['Logos/mark.svg', Buffer.from('<svg>mark</svg>')],
  ]);
  const record = {
    created: '2026-11-23T00:00:00Z',
    assets: {
      'Icons/home.svg': {
        blob: 'b-home',
        size: 15,
        sha256: assetHash(Buffer.from('<svg>home</svg>')),
      },
      'Icons/cart.svg': {
        blob: 'b-cart',
        size: 15,
        sha256: assetHash(Buffer.from('<svg>cart</svg>')),
      },
      // Uploaded before the content hashes were recorded: sent again.
      'Logos/mark.svg': { blob: 'b-mark', size: 15 },
      'Icons/gone.svg': { blob: 'b-gone', size: 1, sha256: 'x' },
    },
  };

  it('uploads only what is new or changed since the record', () => {
    expect([...toUpload(now, record).keys()].sort()).toEqual(['Icons/cart.svg', 'Logos/mark.svg']);
    expect([...toUpload(now, null).keys()].sort()).toEqual([...now.keys()].sort());
  });

  it('merges the replies into the record, with each asset’s hash, and drops the removed', () => {
    const replies = {
      created: '2026-11-27T00:00:00Z',
      assets: {
        'Icons/cart.svg': { blob: 'b-cart2', size: 18 },
        'Logos/mark.svg': { blob: 'b-mark2', size: 15 },
      },
    };
    const merged = mergeBlobs(record, replies, now);
    expect(merged.created).toBe('2026-11-23T00:00:00Z');
    expect(Object.keys(merged.assets).sort()).toEqual([...now.keys()].sort());
    expect(merged.assets['Icons/home.svg']!.blob).toBe('b-home');
    expect(merged.assets['Icons/cart.svg']!.blob).toBe('b-cart2');
    for (const [key, bytes] of now) expect(merged.assets[key]!.sha256).toBe(assetHash(bytes));
    // Nothing to upload: the record alone.
    expect(mergeBlobs(mergeBlobs(record, replies, now), null, now)).toEqual(merged);
  });

  it('refuses a reply for bytes that changed after uploads/ was written', () => {
    const replies = {
      created: 'x',
      assets: {
        'Icons/cart.svg': { blob: 'b-cart2', size: 18 },
        'Logos/mark.svg': { blob: 'b-mark2', size: 15 },
      },
    };
    const uploaded = {
      'Icons/cart.svg': assetHash(Buffer.from('<svg>cart v1.5</svg>')),
      'Logos/mark.svg': assetHash(now.get('Logos/mark.svg')!),
    };
    expect(() => mergeBlobs(record, replies, now, uploaded)).toThrow(/Icons\/cart\.svg changed/);
    uploaded['Icons/cart.svg'] = assetHash(now.get('Icons/cart.svg')!);
    expect(mergeBlobs(record, replies, now, uploaded).assets['Icons/cart.svg']!.blob).toBe(
      'b-cart2',
    );
  });

  it('refuses a changed asset whose new upload is missing', () => {
    expect(() => mergeBlobs(record, null, now)).toThrow(/Icons\/cart\.svg/);
    expect(() => mergeBlobs(null, null, now)).toThrow(/No blob id/);
  });
});
