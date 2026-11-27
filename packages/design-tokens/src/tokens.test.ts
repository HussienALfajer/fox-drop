import { cpSync, mkdirSync, mkdtempSync, readFileSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
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
import { css, dart, OUTPUTS, render, tailwind } from './generate.ts';
import { colour, PACKAGE_DIR, resolveAll, THEMES } from './resolve.ts';

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

describe('the motion tokens (slice D.11b)', () => {
  it('give the pulse and the mark fill to CSS and Dart with their values', () => {
    const css = read(OUTPUTS.css);
    for (const [name, value] of [
      ['pulse-duration', '1200ms'],
      ['pulse-scale-from', '1'],
      ['pulse-scale-to', '1.7'],
      ['pulse-opacity-from', '0.7'],
      ['pulse-opacity-to', '0'],
      ['pulse-still-scale', '1.25'],
      ['pulse-still-opacity', '0.35'],
      ['mark-fill-duration', '1200ms'],
      ['mark-fill-rise', '0.7'],
      ['mark-fill-fade', '0.18'],
      ['mark-fill-wave-period', '700ms'],
      ['mark-fill-faint-opacity', '0.35'],
      ['mark-fill-still-level', '0.5'],
    ])
      expect(css).toContain(`--fd-motion-${name}: ${value};`);
    const dart = read(OUTPUTS.dart);
    for (const line of [
      'static const Duration pulseDuration = Duration(milliseconds: 1200);',
      'static const double pulseScaleTo = 1.7;',
      'static const double pulseOpacityFrom = 0.7;',
      'static const double pulseStillScale = 1.25;',
      'static const double pulseStillOpacity = 0.35;',
      'static const Duration markFillDuration = Duration(milliseconds: 1200);',
      'static const double markFillRise = 0.7;',
      'static const double markFillFade = 0.18;',
      'static const Duration markFillWavePeriod = Duration(milliseconds: 700);',
      'static const double markFillFaintOpacity = 0.35;',
      'static const double markFillStillLevel = 0.5;',
    ])
      expect(dart).toContain(line);
    expect(dart).toMatch(/abstract final class FoxMotion \{/);
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
      'primary-hover': '#DA531B',
      'primary-pressed': '#C2410C',
      'on-primary': '#FFFAED',
    };
    for (const theme of Object.keys(themes) as (keyof typeof themes)[])
      for (const [name, value] of Object.entries(orange))
        expect(colour(themes[theme], `color.${name}`), `${theme} ${name}`).toBe(value);
    expect(Object.keys(orange)).toEqual(expect.arrayContaining([...ORANGE]));
    // Headings are the brand blue, as the identity package V1.1 sets them (owner, 2026-11-25).
    for (const theme of Object.keys(themes) as (keyof typeof themes)[])
      expect(colour(themes[theme], 'color.heading'), `${theme} heading`).toBe('#03428E');
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

// A component file dropped into a copy of tokens/ comes out in both outputs
// with no change to the generator.
const withFixtureComponent = () => {
  const root = mkdtempSync(path.join(tmpdir(), 'fd-tokens-'));
  cpSync(path.join(PACKAGE_DIR, 'tokens'), path.join(root, 'tokens'), { recursive: true });
  // The folder is gone while no component exists (D.R1).
  mkdirSync(path.join(root, 'tokens/component'), { recursive: true });
  writeFileSync(
    path.join(root, 'tokens/component/fixture-card.json'),
    JSON.stringify({
      'fixture-card': {
        $extensions: { 'app.foxdrop': { web: ['card'], flutter: ['card'] } },
        padding: { $type: 'dimension', $value: '{space.md}' },
        'title-gap': { $type: 'dimension', $value: '{space.xs}' },
        background: { $type: 'color', $value: '{color.surface-raised}' },
      },
    }),
  );
  return resolveAll(root);
};
const fixture = await withFixtureComponent();

describe('the component layer (slice D.W1, architecture §9.2)', () => {
  it('writes any component file to CSS and to the Dart ComponentTokens of every theme', () => {
    const styles = css(fixture);
    expect(styles).toContain('--fd-fixture-card-padding: 16px;');
    expect(styles).toContain('--fd-fixture-card-title-gap: 8px;');
    expect(styles).toMatch(/--fd-fixture-card-background: #[0-9A-F]{6};/i);
    const code = dart(fixture);
    expect(code).toMatch(/final class FixtureCardTokens \{/);
    expect(code).toContain('final double titleGap;');
    expect(code).toMatch(/abstract final class FoxFixtureCard \{/);
    expect(code).toMatch(/final class ComponentTokens \{/);
    expect(code).toContain('final FixtureCardTokens fixtureCard;');
    expect(code).toMatch(/abstract final class FoxComponents \{/);
    for (const theme of THEMES) {
      expect(code).toContain(`static const ComponentTokens ${theme} = ComponentTokens(`);
      expect(code).toContain(`fixtureCard: FoxFixtureCard.${theme},`);
    }
  });

  it('keeps $extensions out of every output', () => {
    for (const output of [css(fixture), dart(fixture), tailwind(fixture.light)])
      expect(output).not.toMatch(/extensions|app\.foxdrop|flutter/i);
  });

  // No component file since D.R1 (2026-11-27): no component class either.
  it('writes no ComponentTokens while no component file exists', () => {
    expect(read(OUTPUTS.dart)).not.toContain('ComponentTokens');
  });
});
