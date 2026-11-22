import { readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import { parseIcon, pathPoints, shapePoints } from './icon-geometry.ts';
import { ARABIC } from './icon-sheet.ts';
import { readIcons } from './icons.ts';
import { PACKAGE_DIR } from './resolve.ts';

// The icon grid (architecture §9.4, §9.5 R8; owner, 2026-11-23) and the first
// set (brand expression §10).
const ICONS_DIR = path.join(PACKAGE_DIR, 'icons');

interface Entry {
  name: string;
  group: string;
  mirror: boolean;
  description: string;
}

const manifest = JSON.parse(readFileSync(path.join(ICONS_DIR, 'icons.json'), 'utf8')) as Entry[];
const files = readdirSync(ICONS_DIR)
  .filter((file) => file.endsWith('.svg'))
  .map((file) => file.slice(0, -4));
const icons = files.map((name) => ({
  name,
  source: readFileSync(path.join(ICONS_DIR, `${name}.svg`), 'utf8'),
}));

const ROOT = {
  xmlns: 'http://www.w3.org/2000/svg',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  'stroke-width': '2',
  'stroke-linecap': 'round',
  'stroke-linejoin': 'round',
};

const GEOMETRY: Record<string, string[]> = {
  path: ['d'],
  circle: ['cx', 'cy', 'r'],
  ellipse: ['cx', 'cy', 'rx', 'ry'],
  line: ['x1', 'y1', 'x2', 'y2'],
  polyline: ['points'],
  polygon: ['points'],
  rect: ['x', 'y', 'width', 'height', 'rx', 'ry'],
};

const LIVE = { min: 2, max: 22 };
const EPSILON = 1e-9;

describe('the icon grid (architecture §9.5 R8)', () => {
  it.each(icons)('$name.svg has the grid root, no size of its own', ({ source }) => {
    expect(parseIcon(source).root).toEqual(ROOT);
  });

  it.each(icons)('$name.svg draws with geometry only', ({ source }) => {
    const { shapes } = parseIcon(source);
    expect(shapes.length).toBeGreaterThan(0);
    for (const shape of shapes) {
      const allowed = GEOMETRY[shape.name];
      expect(allowed, `<${shape.name}> is not a shape element`).toBeDefined();
      for (const key of Object.keys(shape.attributes))
        expect(allowed, `<${shape.name}> may not carry ${key}`).toContain(key);
    }
  });

  it.each(icons)('$name.svg writes numbers with at most 2 decimals', ({ source }) => {
    for (const { attributes } of parseIcon(source).shapes)
      for (const value of Object.values(attributes))
        for (const number of value.match(/\d*\.\d+/g) ?? [])
          expect(number.split('.')[1]!.length, number).toBeLessThanOrEqual(2);
  });

  it.each(icons)('$name.svg stays inside the live area 2..22', ({ source }) => {
    for (const shape of parseIcon(source).shapes)
      for (const { x, y } of shapePoints(shape)) {
        const where = `<${shape.name}> at ${x.toFixed(2)},${y.toFixed(2)}`;
        expect(x, where).toBeGreaterThanOrEqual(LIVE.min - EPSILON);
        expect(x, where).toBeLessThanOrEqual(LIVE.max + EPSILON);
        expect(y, where).toBeGreaterThanOrEqual(LIVE.min - EPSILON);
        expect(y, where).toBeLessThanOrEqual(LIVE.max + EPSILON);
      }
  });
});

describe('the icon manifest', () => {
  it('lists every SVG once, and only those', () => {
    const names = manifest.map((entry) => entry.name);
    expect(new Set(names).size).toBe(names.length);
    expect([...names].sort()).toEqual([...files].sort());
  });

  it('names icons in kebab-case and describes each', () => {
    for (const entry of manifest) {
      expect(entry.name).toMatch(/^[a-z]+(-[a-z]+)*$/);
      expect(entry.description.length, entry.name).toBeGreaterThan(10);
    }
  });

  it('mirrors exactly back, motorcycle and car in RTL (owner, 2026-11-23)', () => {
    const mirrored = manifest.filter((entry) => entry.mirror).map((entry) => entry.name);
    expect(mirrored.sort()).toEqual(['back', 'car', 'motorcycle']);
  });

  it('holds the 44 icons of the first set in its six groups (brand expression §10)', () => {
    const counts: Record<string, number> = {};
    for (const entry of manifest) counts[entry.group] = (counts[entry.group] ?? 0) + 1;
    expect(counts).toEqual({
      Navigation: 10,
      Actions: 9,
      States: 7,
      'Place and delivery': 8,
      Money: 5,
      'Contact and rating': 5,
    });
  });
});

describe('the icon sheet (architecture §9.9)', () => {
  it('labels every icon and group in Arabic', () => {
    for (const entry of manifest) {
      expect(ARABIC[entry.name], entry.name).toBeTruthy();
      expect(ARABIC[entry.group], entry.group).toBeTruthy();
    }
  });

  it('draws every icon, normalised to paths that stay on the grid', () => {
    for (const icon of readIcons())
      for (const d of icon.paths)
        for (const { x, y } of pathPoints(d)) {
          expect(Math.min(x, y), icon.name).toBeGreaterThanOrEqual(LIVE.min - EPSILON);
          expect(Math.max(x, y), icon.name).toBeLessThanOrEqual(LIVE.max + EPSILON);
        }
  });
});

describe('the path reader', () => {
  it('expands relative, H, V, S and T commands', () => {
    expect(pathPoints('M2 2h4v4H2z')).toEqual([
      { x: 2, y: 2 },
      { x: 6, y: 2 },
      { x: 6, y: 6 },
      { x: 2, y: 6 },
      { x: 2, y: 2 },
    ]);
    const smooth = pathPoints('M2 12C2 2 12 2 12 12s10 10 10 0');
    expect(Math.max(...smooth.map((p) => p.y))).toBeCloseTo(19.5, 1);
  });

  it('samples an arc through its extreme', () => {
    const half = pathPoints('M4 12a8 8 0 0 1 16 0');
    expect(Math.min(...half.map((p) => p.y))).toBeCloseTo(4, 6);
    const other = pathPoints('M4 12A8 8 0 0 0 20 12');
    expect(Math.max(...other.map((p) => p.y))).toBeCloseTo(20, 6);
  });

  it('rejects what it cannot read', () => {
    expect(() => pathPoints('M2 2L')).toThrow(/needs 2 numbers/);
    expect(() => pathPoints('M4 12a8 8 0 0116 0 0 0')).toThrow(/arc flags/);
    expect(() => parseIcon('<svg><g/></svg>')).not.toThrow();
    expect(() => parseIcon('<svg><g><path d="M0 0"/></g></svg>')).toThrow(/unexpected/);
  });
});
