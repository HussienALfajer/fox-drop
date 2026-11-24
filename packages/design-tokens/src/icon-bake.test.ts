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

/** Each contour of a path: its length and a sampler of points along it. */
function contours(d: string) {
  const iter = new ck.ContourMeasureIter(parse(d), false, 1);
  const out: {
    length: number;
    at: (s: number) => { x: number; y: number; nx: number; ny: number };
  }[] = [];
  for (let c = iter.next(); c; c = iter.next()) {
    const measure = c;
    out.push({
      length: measure.length(),
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
      expect(pieces).toHaveLength(1);
      expect(original!.length - pieces[0]!.length).toBeCloseTo(3.75, 1);
      // The point of the body nearest (22, 2) sits in the middle of the gap.
      let near = original!.at(0);
      for (let i = 0; i <= 4000; i++) {
        const p = original!.at((original!.length * i) / 4000);
        if (Math.hypot(p.x - 22, p.y - 2) < Math.hypot(near.x - 22, near.y - 2)) near = p;
      }
      const start = pieces[0]!.at(0);
      const end = pieces[0]!.at(pieces[0]!.length);
      const toStart = Math.hypot(start.x - near.x, start.y - near.y);
      const toEnd = Math.hypot(end.x - near.x, end.y - near.y);
      expect(toStart).toBeLessThanOrEqual(1.9);
      expect(toEnd).toBeLessThanOrEqual(1.9);
      expect(Math.abs(toStart - toEnd)).toBeLessThan(0.15);
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
