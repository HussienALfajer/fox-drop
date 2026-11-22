import { readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import { DEFICIENCIES, contrast, deltaE2000, distance } from './color.ts';
import { check, PAIRS } from './contrast.ts';
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
  });
});

describe('contrast (R4, brand expression §6)', () => {
  const results = check(themes);

  it('passes every required pair', () => {
    const failing = results
      .filter((each) => !each.pass)
      .map(
        (r) =>
          `${r.surface}/${r.theme} ${r.foreground} on ${r.background}: ${r.ratio.toFixed(2)} < ${r.target}`,
      );
    expect(failing).toEqual([]);
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

  it('has no orange text in the captain app', () => {
    const orange = ['color.primary', 'color.brand'].map((name) =>
      colour(themes.captainLight, name),
    );
    const text = PAIRS.captain
      .filter((p) => p.target === 7)
      .map((p) => colour(themes.captainLight, `color.${p.foreground}`));
    expect(text.filter((each) => orange.includes(each))).toEqual([]);
  });

  it('computes WCAG ratios', () => {
    expect(contrast('#000000', '#FFFFFF')).toBeCloseTo(21, 5);
    expect(contrast('#C2410C', '#FFFAED')).toBeCloseTo(4.97, 2);
  });
});

describe('the chart palette (brand expression §6)', () => {
  const chart = [1, 2, 3, 4, 5, 6].map((n) => colour(themes.light, `color.chart.${n}`));
  // CIEDE2000 of 10 or more: two colours that read as different at a glance.
  const MIN_DISTANCE = 10;

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
