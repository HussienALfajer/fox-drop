import { readFileSync } from 'node:fs';
import { expect, test, type Locator, type Page } from '@playwright/test';
import { openStory } from './stories';

// The parity gate (D.P2, architecture §9.5 R9, §9.8): every state the
// component registry lists is opened as its story and measured, and each value
// must equal its component token. core_ui's test/parity_test.dart measures the
// same states in Flutter against the same tokens, so the two platforms agree
// without comparing pixels (Chromium and Flutter draw text and edges apart).

type Metric =
  | 'height'
  | 'width'
  | 'paddingInline'
  | 'radius'
  | 'borderWidth'
  | 'gap'
  | 'background'
  | 'border'
  | 'foreground';

interface State {
  state: string;
  story: string | null;
  only?: 'web' | 'flutter';
  act?: 'hover' | 'press' | 'focus';
  expect: Partial<Record<Metric, string>>;
}

interface Component {
  name: string;
  web: string | null;
  metrics?: { web: string; expect: Partial<Record<Metric, string>>; states: State[] };
}

const TOKENS = `${import.meta.dirname}/../../design-tokens`;
const registry = JSON.parse(readFileSync(`${TOKENS}/components.json`, 'utf8')) as {
  components: Component[];
};

type Surface = 'phone' | 'captain';

/**
 * A surface's light resolved tokens, by dotted path, from the generated CSS
 * both platforms are built from: `--fd-button-primary-background` is
 * `button.primary.background`, read back by its dashes. The captain's block
 * overrides some of `:root`.
 */
function lightTokens(surface: Surface): Map<string, string> {
  const css = readFileSync(`${TOKENS}/generated/tokens.css`, 'utf8');
  const block = (selector: string) => {
    const at = css.indexOf(`\n${selector} {`);
    if (at < 0) throw new Error(`No ${selector} block in tokens.css`);
    return css.slice(at, css.indexOf('}', at));
  };
  const blocks = [
    block(':root'),
    ...(surface === 'captain' ? [block('[data-surface="captain"]')] : []),
  ];
  const out = new Map<string, string>();
  for (const text of blocks)
    for (const [, name, value] of text.matchAll(/--fd-([\w-]+):\s*([^;]+);/g))
      out.set(name!, value!.trim());
  return out;
}
const TOKENS_BY_SURFACE: Record<Surface, Map<string, string>> = {
  phone: lightTokens('phone'),
  captain: lightTokens('captain'),
};

const DIMENSIONS = new Set<Metric>([
  'height',
  'width',
  'paddingInline',
  'radius',
  'borderWidth',
  'gap',
]);

/** A token's value as measured: a number of pixels, or an upper-case hex colour. */
function tokenValue(surface: Surface, metric: Metric, name: string): number | string {
  if (name === 'none') return 'none';
  const raw = TOKENS_BY_SURFACE[surface].get(name.replaceAll('.', '-'));
  if (raw === undefined) throw new Error(`No token ${name} in tokens.css`);
  if (DIMENSIONS.has(metric)) {
    const px = /^(-?[\d.]+)px$/.exec(raw);
    if (!px) throw new Error(`${name} is not in px: ${raw}`);
    return Number(px[1]);
  }
  return raw.toUpperCase();
}

/** `rgb(…)` or `rgba(…)` as `#RRGGBB` (with `AA` when not opaque), or `none` when transparent. */
function hex(css: string): string {
  const parts = /rgba?\(([^)]*)\)/
    .exec(css)?.[1]
    ?.split(/[,\s/]+/)
    .filter(Boolean);
  if (!parts) return css;
  const [r, g, b] = parts.slice(0, 3).map(Number);
  const a = parts[3] === undefined ? 1 : Number(parts[3]);
  if (a === 0) return 'none';
  const two = (n: number) => Math.round(n).toString(16).padStart(2, '0').toUpperCase();
  return `#${two(r!)}${two(g!)}${two(b!)}${a === 1 ? '' : two(a * 255)}`;
}

type Measured = Partial<Record<Metric, number | string>>;

/** Measures the box: its size, start padding, corner, fill, outline, text colour and icon gap. */
async function measure(box: Locator, wanted: Metric[]): Promise<Measured> {
  const raw = await box.evaluate((element) => {
    const style = getComputedStyle(element);
    const rect = element.getBoundingClientRect();
    // The outline is a border, or an inset ring (a box-shadow with a spread):
    // the web's fields and selection boxes draw theirs as a ring.
    let border = { colour: 'rgba(0, 0, 0, 0)', width: 0 };
    const borderWidth = parseFloat(style.borderTopWidth);
    if (style.borderTopStyle !== 'none' && borderWidth > 0)
      border = { colour: style.borderTopColor, width: borderWidth };
    else
      for (const shadow of style.boxShadow.split(/,(?![^(]*\))/)) {
        if (!shadow.includes('inset')) continue;
        const colour = /rgba?\([^)]*\)/.exec(shadow)?.[0];
        const lengths = shadow
          .replace(/rgba?\([^)]*\)/, '')
          .match(/-?[\d.]+px/g)
          ?.map(parseFloat);
        const spread = lengths?.[3] ?? 0;
        if (colour && spread > 0 && !/,\s*0\)$/.test(colour)) border = { colour, width: spread };
      }
    // An outline in the fill's own colour draws nothing.
    if (border.colour === style.backgroundColor) border = { colour: 'rgba(0, 0, 0, 0)', width: 0 };
    // The gap between an icon and its label, as drawn.
    let gap: number | null = null;
    const icon = element.querySelector('svg');
    const label = [...element.querySelectorAll('*')]
      .flatMap((each) => [...each.childNodes])
      .find((node) => node.nodeType === Node.TEXT_NODE && node.textContent!.trim() !== '');
    if (icon && label) {
      const range = document.createRange();
      range.selectNodeContents(label);
      const a = icon.getBoundingClientRect();
      const b = range.getBoundingClientRect();
      gap = a.left >= b.right ? a.left - b.right : b.left - a.right;
    }
    return {
      height: rect.height,
      width: rect.width,
      paddingInline: parseFloat(style.paddingInlineStart),
      radius: parseFloat(style.borderStartStartRadius),
      background: style.backgroundColor,
      border: border.colour,
      borderWidth: border.width,
      foreground: style.color,
      gap,
    };
  });
  const out: Measured = {};
  for (const metric of wanted) {
    const value = raw[metric];
    if (value === null) throw new Error(`No icon beside a label to measure ${metric}`);
    if (metric === 'radius')
      out.radius = round(Math.min(raw.radius, raw.height / 2, raw.width / 2));
    else if (typeof value === 'number') out[metric] = round(value);
    else out[metric] = hex(value);
  }
  return out;
}

const round = (n: number) => Math.round(n * 100) / 100;

/** The expected values, with a corner as drawn: no larger than half the box. */
function expected(
  surface: Surface,
  wanted: Partial<Record<Metric, string>>,
  size: Measured,
): Measured {
  const out: Measured = {};
  for (const [metric, name] of Object.entries(wanted) as [Metric, string][])
    out[metric] = tokenValue(surface, metric, name);
  if (typeof out.radius === 'number') {
    const height = Number(size.height ?? Infinity);
    const width = Number(size.width ?? Infinity);
    out.radius = round(Math.min(out.radius, height / 2, width / 2));
  }
  return out;
}

async function act(page: Page, box: Locator, how: State['act']) {
  if (how === 'hover') await box.hover();
  if (how === 'press') {
    await box.hover();
    await page.mouse.down();
  }
  if (how === 'focus') {
    const control = box.locator('input, textarea').first();
    await ((await control.count()) ? control : box).focus();
  }
}

for (const component of registry.components) {
  const metrics = component.metrics;
  if (!metrics || component.web === null) continue;
  test.describe(`${component.name} parity (R9)`, () => {
    for (const state of metrics.states) {
      if (state.only === 'flutter' || state.story === null) continue;
      for (const surface of ['phone', 'captain'] as const)
        test(`${state.state} on ${surface} equals its tokens`, async ({ page }) => {
          await openStory(page, state.story!, surface);
          const box = page.locator('#storybook-root').locator(metrics.web).first();
          await act(page, box, state.act);
          // The colours fade over duration.base: measure once the box's
          // transitions have finished, so a fade cannot pass on its first frame.
          // An endless one (a loader) is not waited for, and a cancelled one
          // is not an error: the poll below stays the judge.
          await box.evaluate((element) =>
            Promise.all(
              element
                .getAnimations({ subtree: true })
                .filter((each) => each.effect?.getTiming().iterations !== Infinity)
                .map((each) => each.finished.catch(() => undefined)),
            ),
          );
          const wanted = { ...metrics.expect, ...state.expect };
          const keys = Object.keys(wanted) as Metric[];
          // Each value that differs is reported as `measured ≠ token (name)`.
          await expect
            .poll(async () => {
              const measured = await measure(box, [
                ...new Set<Metric>([...keys, 'height', 'width']),
              ]);
              const want = expected(surface, wanted, measured);
              const off: Record<string, string> = {};
              for (const key of keys)
                if (measured[key] !== want[key])
                  off[key] = `${measured[key]} ≠ ${want[key]} (${wanted[key]})`;
              return off;
            })
            .toEqual({});
          if (state.act === 'press') await page.mouse.up();
        });
    }
  });
}
