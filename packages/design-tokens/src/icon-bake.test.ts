import { beforeAll, describe, expect, it } from 'vitest';
import {
  bakeIcon,
  bold,
  boldDuo,
  broken,
  loadSkia,
  primaryBody,
  strokeWeight,
  WEIGHTS,
  type Element,
  type Skia,
} from './icon-bake.ts';
import { readIcons } from './icons.ts';
import { resolveTheme } from './resolve.ts';

// The bake of set v4 "Madar" (architecture §9.4; owner, 2026-11-24): Broken,
// Bold and Bold Duo turned into plain path data, so Flutter and the web draw
// them without masks or dash offsets.
const icons = readIcons();
const byName = (name: string) => icons.find((icon) => icon.name === name)!.elements;

let ck: Skia;
beforeAll(async () => {
  ck = await loadSkia();
});

const parse = (d: string) => {
  const path = ck.Path.MakeFromSVGString(d);
  if (!path) throw new Error(`cannot read ${d}`);
  return path;
};

/**
 * Each contour of a path: its length and a sampler of points along it. At
 * resScale 1 Skia measures curves only to about 0.3 on the 24 grid; 100 is
 * exact enough for the 0.05 of the gap (owner, 2026-11-24).
 */
function contours(d: string) {
  const iter = new ck.ContourMeasureIter(parse(d), false, 100);
  const out: {
    length: number;
    closed: boolean;
    at: (s: number) => { x: number; y: number; nx: number; ny: number };
  }[] = [];
  for (let c = iter.next(); c; c = iter.next()) {
    const measure = c;
    out.push({
      length: measure.length(),
      closed: measure.isClosed(),
      at: (s) => {
        const [x, y, tx, ty] = measure.getPosTan(s);
        const n = Math.hypot(tx!, ty!) || 1;
        return { x: x!, y: y!, nx: -ty! / n, ny: tx! / n };
      },
    });
  }
  return out;
}

const filled = (layers: { d: string }[], x: number, y: number) =>
  layers.some((layer) => parse(layer.d).contains(x, y));

describe('Broken: the bite (§9.4)', () => {
  const withBody = icons.filter((icon) => icon.elements.some((e) => e.role === 'body'));

  it.each(withBody)(
    '$name cuts one 3.75 gap in its primary body, nearest (22, 2)',
    ({ elements }) => {
      const index = elements.indexOf(primaryBody(elements)!);
      const cut = broken(ck, elements);
      expect(cut).toHaveLength(elements.length);
      cut.forEach((d, i) => {
        if (i !== index) expect(d).toBe(elements[i]!.d);
      });
      const [original] = contours(elements[index]!.d);
      const pieces = contours(cut[index]!);
      // A closed body opens into one line; an open one splits in two, each
      // stub at least 1.5 long (owner, 2026-11-24).
      expect(pieces).toHaveLength(original!.closed ? 1 : 2);
      const kept = pieces.reduce((sum, piece) => sum + piece.length, 0);
      expect(original!.length - kept).toBeCloseTo(3.75, 1);
      for (const piece of pieces) expect(piece.length).toBeGreaterThanOrEqual(1.45);
      // The gap is centred on the point of the body nearest (22, 2) where a
      // whole gap fits: anywhere on a closed body, on an open one at least
      // 1.875 + 1.5 from either end.
      // Centred along the line, by arc length: chords around a corner (the
      // star's tip) are not symmetric.
      const L = original!.length;
      const margin = original!.closed ? 0 : 3.75 / 2 + 1.5;
      const samples = Array.from({ length: 8001 }, (_, i) => {
        const s = (L * i) / 8000;
        return { s, ...original!.at(s) };
      });
      const dist = (p: { x: number; y: number }, x: number, y: number) =>
        Math.hypot(p.x - x, p.y - y);
      const near = samples
        .filter((p) => p.s >= margin && p.s <= L - margin)
        .reduce((a, p) => (dist(p, 22, 2) < dist(a, 22, 2) ? p : a));
      /** Where a point of the cut line sits along the original body. */
      const arc = (q: { x: number; y: number }) =>
        samples.reduce((a, p) => (dist(p, q.x, q.y) < dist(a, q.x, q.y) ? p : a)).s;
      const first = pieces[0]!;
      const last = pieces[pieces.length - 1]!;
      // The gap runs from the end of the first piece to the start of the last.
      const from = arc(first.at(first.length));
      const to = arc(original!.closed ? first.at(0) : last.at(0));
      const wrap = (s: number) => ((s % L) + L) % L;
      expect(wrap(to - from)).toBeCloseTo(3.75, 1);
      const middle = wrap(from + wrap(to - from) / 2);
      const off = Math.abs(middle - near.s);
      expect(Math.min(off, L - off)).toBeLessThan(0.05);
    },
  );

  it('leaves the bare glyphs whole', () => {
    const back = byName('back');
    expect(broken(ck, back)).toEqual(back.map((e) => e.d));
  });
});

describe('Bold and Bold Duo: fills only (§9.4)', () => {
  const cases = icons.flatMap((icon) => WEIGHTS.map((weight) => ({ ...icon, weight })));

  it.each(cases)(
    '$name at $weight is plain path data inside the live area',
    ({ elements, weight }) => {
      const w = strokeWeight(elements, weight);
      for (const layers of [bold(ck, elements, weight), boldDuo(ck, elements, weight)]) {
        expect(layers.length).toBeGreaterThan(0);
        for (const { d } of layers) {
          expect(d).toMatch(/^M[\d.\sMLQCZ-]+$/);
          const [left, top, right, bottom] = parse(d).computeTightBounds();
          expect(Math.min(left!, top!)).toBeGreaterThanOrEqual(2 - w / 2 - 0.02);
          expect(Math.max(right!, bottom!)).toBeLessThanOrEqual(22 + w / 2 + 0.02);
        }
      }
    },
  );

  it('draws Bold as one opaque layer', () => {
    for (const icon of icons) {
      const layers = bold(ck, icon.elements, 1.5);
      expect(
        layers.map((layer) => layer.faded),
        icon.name,
      ).toEqual([false]);
    }
  });

  it('knocks the in details out of Bold: home’s door, info’s dot', () => {
    const home = bold(ck, byName('home'), 1.5);
    expect(filled(home, 6, 12)).toBe(true);
    expect(filled(home, 12, 15.25)).toBe(false);
    const info = bold(ck, byName('info'), 1.5);
    expect(filled(info, 7, 12)).toBe(true);
    expect(filled(info, 12, 7.75)).toBe(false);
    expect(filled(info, 12, 14)).toBe(false);
  });

  it('keeps 1.25 clear between a halo and the body: car’s wheels, offline’s line', () => {
    for (const [name, weight] of [
      ['car', 1.5],
      ['car', 1.75],
      ['offline', 1.5],
    ] as const) {
      const elements = byName(name);
      const halos = elements.filter((e) => e.halo);
      const subset: Element[] = [...elements.filter((e) => e.role === 'body' && !e.halo), ...halos];
      const layers = bold(ck, subset, weight);
      let checked = 0;
      for (const halo of halos) {
        const own = parse(halo.d);
        for (const contour of contours(halo.d))
          for (let i = 0; i <= 200; i++) {
            const p = contour.at((contour.length * i) / 200);
            // Between the element's own edge (w/2) and the end of its halo (w/2 + 1.25).
            const off = weight / 2 + 0.9;
            for (const side of [1, -1]) {
              const x = p.x + side * p.nx * off;
              const y = p.y + side * p.ny * off;
              if (halo.fill && own.contains(x, y)) continue;
              expect(
                filled(layers, x, y),
                `${name} ${weight} at ${x.toFixed(2)},${y.toFixed(2)}`,
              ).toBe(false);
              checked++;
            }
          }
      }
      expect(checked).toBeGreaterThan(100);
    }
  });

  it('fades the non-accent bodies of Bold Duo, and nothing else', () => {
    for (const icon of icons) {
      const layers = boldDuo(ck, icon.elements, 1.5);
      const faded = icon.elements.filter((e) => e.role === 'body' && !e.accent && !e.halo);
      expect(
        layers.filter((layer) => layer.faded),
        icon.name,
      ).toHaveLength(faded.length);
      expect(layers.filter((layer) => !layer.faded).length, icon.name).toBeGreaterThan(0);
    }
  });

  it('bakes the same output twice', () => {
    for (const icon of icons)
      expect(bakeIcon(ck, icon.elements), icon.name).toEqual(bakeIcon(ck, icon.elements));
  });

  it('bakes at the weights of the icon-stroke tokens, phone and captain', async () => {
    const light = await resolveTheme('light');
    const stroke = (surface: string) => Number(light.get(`icon-stroke.${surface}`)?.value);
    expect([stroke('phone'), stroke('captain')]).toEqual([...WEIGHTS]);
  });

  it('strokes the bare glyphs at 1.4 times the weight', () => {
    expect(strokeWeight(byName('back'), 1.5)).toBeCloseTo(2.1, 6);
    expect(strokeWeight(byName('home'), 1.75)).toBe(1.75);
  });
});
