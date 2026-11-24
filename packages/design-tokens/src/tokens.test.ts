import { readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import { DEFICIENCIES, contrast, deltaE2000, distance } from './color.ts';
import {
  BACKGROUNDS,
  check,
  failing,
  MIN_HOVER,
  MIN_PRESS,
  ORANGE,
  PAIRS,
  POINTER_THEMES,
  STATE_TRIPLES,
} from './contrast.ts';
import { OUTPUTS, render } from './generate.ts';
import { colour, PACKAGE_DIR, resolveAll } from './resolve.ts';

const read = (file: string) =>
  readFileSync(path.join(PACKAGE_DIR, file), 'utf8').replaceAll('\r\n', '\n');

const themes = await resolveAll();

describe('the generated outputs', () => {
  it('match the token sources (run `pnpm --filter @fox-drop/design-tokens generate`)', async () => {
    const outputs = await render();
    for (const [key, file] of Object.entries(OUTPUTS))
      expect(read(file), file).toBe(outputs[key as keyof typeof OUTPUTS]);
  });

  it('never export a primitive (architecture §9.5 R1)', () => {
    expect(read(OUTPUTS.css)).not.toMatch(/--fd-primitive/);
    expect(read(OUTPUTS.dart)).not.toMatch(/primitive/i);
  });

  it('give Tailwind semantic names only, every default removed (R1)', () => {
    const theme = read(OUTPUTS.tailwind);
    expect(theme).toMatch(/@theme inline \{\n {2}--\*: initial;/);
    expect(theme).not.toMatch(/primitive|#[0-9a-f]{3,8}\b/i);
    // `--*: initial` also removes the defaults Preflight and `transition` read.
    for (const variable of ['font-family', 'transition-duration', 'transition-timing-function'])
      expect(theme).toMatch(new RegExp(`--default-${variable}: var\\(--fd-`));
  });
});

describe('the dark slot (architecture §9.2)', () => {
  const leaves = (file: string) => {
    const paths: string[] = [];
    const walk = (node: Record<string, unknown>, at: string[]) => {
      if ('$value' in node) return void paths.push(at.join('.'));
      for (const [key, child] of Object.entries(node))
        if (!key.startsWith('$')) walk(child as Record<string, unknown>, [...at, key]);
    };
    walk(JSON.parse(read(file)) as Record<string, unknown>, []);
    return paths.sort();
  };

  it('has exactly the keys of the light theme', () => {
    expect(leaves('tokens/semantic/dark.json')).toEqual(leaves('tokens/semantic/light.json'));
  });

  it('overrides only keys that exist, for the captain', () => {
    const light = new Set(leaves('tokens/semantic/light.json'));
    expect(leaves('tokens/semantic/captain.json').filter((key) => !light.has(key))).toEqual([]);
    expect(leaves('tokens/semantic/captain-dark.json')).toEqual(
      leaves('tokens/semantic/captain.json'),
    );
  });
});

describe('contrast (R4, brand expression §6)', () => {
  const results = check(themes);

  it('passes every required pair', () => {
    const failed = results
      .filter(failing)
      .map(
        (r) =>
          `${r.surface}/${r.theme} ${r.foreground} on ${r.background}: ${r.ratio.toFixed(2)} < ${r.target}`,
      );
    expect(failed).toEqual([]);
  });

  it("keeps the owner's exception to the brand orange (R4, 2026-11-23)", () => {
    const excepted = Object.values(PAIRS)
      .flat()
      .filter((p) => p.exception);
    // Each excepted pair has a floor, and its non-orange side is the ivory label.
    for (const p of excepted) {
      expect(p.floor, `${p.foreground} on ${p.background}`).toBeGreaterThan(0);
      if (!ORANGE.has(p.foreground)) expect(p.foreground).toBe('on-primary');
      // The grounds, and the empty state's drop under a Brand Duo icon (D.5b).
      if (!ORANGE.has(p.background))
        expect([...BACKGROUNDS, 'primary-subtle']).toContain(p.background);
    }
    const orange = {
      brand: '#FF6E31',
      primary: '#FF6E31',
      heading: '#FF6E31',
      'primary-hover': '#DA531B',
      'primary-pressed': '#C2410C',
      'on-primary': '#FFFAED',
    };
    for (const theme of Object.keys(themes) as (keyof typeof themes)[])
      for (const [name, value] of Object.entries(orange))
        expect(colour(themes[theme], `color.${name}`), `${theme} ${name}`).toBe(value);
    expect(Object.keys(orange)).toEqual(expect.arrayContaining([...ORANGE]));
  });

  it('makes every hover and press visible (R10, owner 2026-11-24)', () => {
    const weak: string[] = [];
    for (const theme of Object.keys(themes) as (keyof typeof themes)[])
      for (const [rest, hover, pressed] of STATE_TRIPLES) {
        const [r, h, p] = [rest, hover, pressed].map((n) => colour(themes[theme], `color.${n}`));
        const steps: [string, number, number][] = POINTER_THEMES.includes(theme)
          ? [
              [`${rest} → ${hover}`, distance(r!, h!), MIN_HOVER],
              [`${hover} → ${pressed}`, distance(h!, p!), MIN_PRESS],
            ]
          : [[`${rest} → ${pressed}`, distance(r!, p!), MIN_HOVER]];
        for (const [step, value, min] of steps)
          if (value < min) weak.push(`${theme} ${step}: ΔE ${value.toFixed(1)} < ${min}`);
      }
    expect(weak).toEqual([]);
  });

  it('checks the stricter surfaces: captain text at 7:1, alerts at 7:1', () => {
    expect(
      PAIRS.captain.filter((p) => p.foreground === 'on-surface').every((p) => p.target === 7),
    ).toBe(true);
    expect(
      PAIRS.phone
        .filter((p) => p.background === 'alert' || p.foreground === 'alert')
        .every((p) => p.target === 7),
    ).toBe(true);
  });

  it('writes captain text in near-black, blue or a dark status shade only', () => {
    const primitives = themes.captainLight;
    const allowed = new Set(
      [...primitives.values()]
        .filter((t) =>
          /^primitive\.color\.(neutral\.[789]00|blue\.\d+|(green|amber|red|yellow)\.800)$/.test(
            t.path.join('.'),
          ),
        )
        .map((t) => String(t.value)),
    );
    for (const theme of ['captainLight', 'captainDark'] as const) {
      const text = PAIRS.captain
        .filter((p) => p.use !== 'filled control label' && p.target === 7)
        .map((p) => `color.${p.foreground}`);
      expect(text.length).toBeGreaterThan(0);
      for (const name of text)
        expect(allowed, `${theme} ${name}`).toContain(colour(themes[theme], name));
    }
  });

  it('computes WCAG ratios', () => {
    expect(contrast('#000000', '#FFFFFF')).toBeCloseTo(21, 5);
    expect(contrast('#C2410C', '#FFFAED')).toBeCloseTo(4.97, 2);
  });
});

describe('the chart palette (brand expression §6)', () => {
  const chart = [1, 2, 3, 4, 5, 6].map((n) => colour(themes.light, `color.chart.${n}`));
  // CIEDE2000 of 11 or more (brand expression §6); the closest pair is 11.97.
  const MIN_DISTANCE = 11;

  it('has six colours, each at 3:1 on the surfaces', () => {
    expect(new Set(chart).size).toBe(6);
    for (const background of ['color.surface', 'color.surface-raised'])
      for (const each of chart)
        expect(contrast(each, colour(themes.light, background)), each).toBeGreaterThanOrEqual(3);
  });

  it.each([null, ...DEFICIENCIES])('keeps the colours apart with %s vision', (deficiency) => {
    for (let i = 0; i < chart.length; i++)
      for (let j = i + 1; j < chart.length; j++)
        expect(
          distance(chart[i]!, chart[j]!, deficiency),
          `${chart[i]} ${chart[j]}`,
        ).toBeGreaterThanOrEqual(MIN_DISTANCE);
  });

  it('computes CIEDE2000 as Sharma, Wu and Dalal (2005)', () => {
    expect(deltaE2000([50, 2.6772, -79.7751], [50, 0, -82.7485])).toBeCloseTo(2.0425, 4);
    expect(deltaE2000([50, 2.5, 0], [73, 25, -18])).toBeCloseTo(27.1492, 4);
  });
});
