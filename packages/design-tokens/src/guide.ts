// Draws the Fox Drop Guide canvas (architecture §9.8) from the resolved
// tokens into the ignored .design-system/guide/:
//   pnpm --filter @fox-drop/design-tokens guide --config <file>
// The config (kept outside the repository) holds the Design System's link,
// the canvas's creation time and the uploaded CoFo urls:
//   {"system": "<url>", "created": "<RFC 3339>", "fonts": {"400": "/_blob/<id>", ...}}
// A token change redraws the guide with this one command; Claude publishes
// the folder with the Artifact tool (packages/design-tokens/CLAUDE.md «Sync»).
import { mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { check, ORANGE } from './contrast.ts';
import { DS_THEMES, designSystem, group as groupOf } from './design-system.ts';
import { cssValue, exported } from './generate.ts';
import { PACKAGE_DIR, resolveAll, type Theme, type Token } from './resolve.ts';

type Tokens = Map<string, Token>;
type Themes = Record<Theme, Tokens>;

export const OUT = path.join(PACKAGE_DIR, '.design-system/guide');
const ROOT = path.resolve(PACKAGE_DIR, '../..');
export const DS_FOLDER = 'fox-drop';

export interface GuideConfig {
  system: string;
  created: string;
  fonts?: Record<string, string>;
}

export interface Board {
  file: string;
  title: string;
  w: number;
  h: number;
  /** Working controls on the canvas (hover and press them). */
  interactive?: boolean;
  html: string;
}

const W = 1280;
export const esc = (text: string) =>
  text.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

/** A value of the light theme, as CSS. */
export const v = (themes: Themes, name: string) => cssValue(themes.light.get(name)!);

export function page(
  themes: Themes,
  config: GuideConfig,
  board: Omit<Board, 'html'>,
  body: string,
): Board {
  const faces = Object.entries(config.fonts ?? {})
    .map(
      ([weight, url]) =>
        `@font-face{font-family:"CoFo Sans Pro Arabic";src:url("${url}");font-weight:${weight};font-style:normal}`,
    )
    .join('\n');
  const root = [
    `width: ${board.w}px`,
    `min-height: ${board.h}px`,
    'box-sizing: border-box',
    `padding: ${v(themes, 'space.2xl')}`,
    'display: flex',
    'flex-direction: column',
    `gap: ${v(themes, 'space.xl')}`,
    `background: ${v(themes, 'color.surface')}`,
    `color: ${v(themes, 'color.on-surface')}`,
    `font-family: ${v(themes, 'font.family.sans').replaceAll('"', "'")}`,
  ].join('; ');
  const props = JSON.stringify({ $preview: { width: board.w, height: board.h } });
  const html = `<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<title>${esc(board.title)}</title>
<script src="./support.js"></script>
</head>
<body>
<x-dc>
<helmet>
<style>
body{margin:0}
${faces}
</style>
</helmet>
<div style="${root}">
${body}
</div>
</x-dc>
<script type="text/x-dc" data-dc-script data-props='${props}'>
class Component extends DCLogic {
renderVals() {
return {};
}
}
</script>
</body>
</html>
`;
  return { ...board, html };
}

export const heading = (themes: Themes, text: string, sub?: string) =>
  `<div style="display: flex; flex-direction: column; gap: ${v(themes, 'space.xs')}">
<h1 style="margin: 0; font-size: ${v(themes, 'type.phone.large-title.size')}; line-height: 1.3; font-weight: 700; color: ${v(themes, 'color.heading')}">${esc(text)}</h1>
${sub ? `<p style="margin: 0; font-size: ${v(themes, 'type.phone.secondary.size')}; line-height: 1.6; color: ${v(themes, 'color.on-surface-muted')}">${esc(sub)}</p>` : ''}
</div>`;

export const card = (themes: Themes, inner: string, extra = '') =>
  `<div style="background: ${v(themes, 'color.surface-raised')}; border-radius: ${v(themes, 'radius.lg')}; padding: ${v(themes, 'space.lg')}; display: flex; flex-direction: column; gap: ${v(themes, 'space.md')}; ${extra}">${inner}</div>`;

export const label = (themes: Themes, text: string) =>
  `<span dir="ltr" style="font-size: ${v(themes, 'type.panel.caption.size')}; line-height: 1.6; color: ${v(themes, 'color.on-surface-muted')}; font-feature-settings: 'tnum'">${esc(text)}</span>`;

const colours = (tokens: Tokens) => exported(tokens).filter((token) => token.path[0] === 'color');

// Main: the layer flow of §9.1 and §9.2 --------------------------------------

function main(themes: Themes, config: GuideConfig, version: string): Board {
  const box = (
    title: string,
    text: string,
    fill = 'color.surface-raised',
    ink = 'color.on-surface',
  ) =>
    `<div style="flex: 1 1 0; background: ${v(themes, fill)}; color: ${v(themes, ink)}; border-radius: ${v(themes, 'radius.lg')}; padding: ${v(themes, 'space.md')}; display: flex; flex-direction: column; gap: ${v(themes, 'space.2xs')}">
<strong style="font-size: ${v(themes, 'type.panel.subtitle.size')}; font-weight: 700">${esc(title)}</strong>
<span style="font-size: ${v(themes, 'type.panel.secondary.size')}; line-height: 1.6">${esc(text)}</span>
</div>`;
  const arrow = `<span aria-hidden="true" style="align-self: center; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.on-surface-muted')}">←</span>`;
  const row = (...items: string[]) =>
    `<div style="display: flex; gap: ${v(themes, 'space.sm')}; align-items: stretch">${items.join(arrow)}</div>`;
  const body = [
    heading(
      themes,
      'Fox Drop Guide',
      `Drawn from packages/design-tokens ${version}. Code is the source; this canvas is redrawn after every token change.`,
    ),
    card(
      themes,
      `<strong style="font-size: ${v(themes, 'type.phone.subtitle.size')}">The token layers (§9.2)</strong>
${row(
  box(
    'Primitive',
    'Raw values: the orange, blue and ivory scales, spacing steps, radii, shadows, durations, type sizes. Never used by a screen.',
  ),
  box(
    'Semantic',
    'Meanings with a dark slot: surface, on-surface, primary, heading, border, success, danger. Screens use these only.',
    'color.accent',
    'color.on-accent',
  ),
  box(
    'Component',
    'One component’s height, padding, radius and colours per state, from semantic tokens.',
  ),
)}`,
    ),
    card(
      themes,
      `<strong style="font-size: ${v(themes, 'type.phone.subtitle.size')}">The flow (§9.1)</strong>
${row(
  box('packages/design-tokens', 'W3C tokens, edited in code.', 'color.primary', 'color.on-primary'),
  box(
    'generate',
    'CSS variables and the Tailwind theme (web), core_tokens (Dart), tokens.json (Design System).',
  ),
  box(
    'Fox Drop Design System',
    'Brand book, tokens, fonts, logos; components after they are built and tested.',
  ),
  box('Drawings', 'Component sheets and screens, approved by the owner before they are coded.'),
)}`,
    ),
    card(
      themes,
      `<strong style="font-size: ${v(themes, 'type.phone.subtitle.size')}">Pages</strong>
<span style="font-size: ${v(themes, 'type.phone.body.size')}; line-height: 1.6">Colour · Type · Foundations · Shapes · Rules</span>`,
    ),
  ].join('\n');
  return page(themes, config, { file: 'Main.dc.html', title: 'Main', w: W, h: 1000 }, body);
}

// Colour: semantic per theme, with the ratios of contrast.ts ----------------

function colour(themes: Themes, config: GuideConfig): Board {
  const light = colours(themes.light);
  const swatch = (hex: string) =>
    `<span style="display: flex; align-items: center; gap: ${v(themes, 'space.xs')}"><span style="width: 32px; height: 32px; border-radius: ${v(themes, 'radius.sm')}; background: ${hex}; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}"></span>${label(themes, hex)}</span>`;
  const grid = `display: grid; grid-template-columns: 220px repeat(${DS_THEMES.length}, minmax(0, 1fr)); gap: ${v(themes, 'space.xs')} ${v(themes, 'space.md')}; align-items: center`;
  const head = `<div style="${grid}"><strong>Token</strong>${DS_THEMES.map((t) => `<strong>${esc(t.name)}</strong>`).join('')}</div>`;
  const rows = light
    .map((token) => {
      const name = token.path.slice(1).join('-');
      const key = token.path.join('.');
      const mark = ORANGE.has(name) ? ' · owner exception' : '';
      return `<div style="${grid}"><span style="display: flex; flex-direction: column"><strong style="font-size: ${v(themes, 'type.panel.body.size')}" dir="ltr">${esc(name)}</strong>${mark ? label(themes, mark.slice(3)) : ''}</span>${DS_THEMES.map((t) => swatch(String(themes[t.theme].get(key)!.value))).join('')}</div>`;
    })
    .join('\n');

  const results = check(themes).filter((r) => r.theme === 'light' || r.theme === 'captainLight');
  const pairs = results
    .map((r) => {
      const status = r.exception ? 'owner exception' : r.pass ? 'pass' : 'fail';
      // The exception is named in blue, whatever the pair.
      const ink = r.exception ? 'color.on-surface' : r.pass ? 'color.success' : 'color.danger';
      return `<div style="display: grid; grid-template-columns: 96px minmax(0, 2fr) 72px 72px minmax(0, 1fr); gap: ${v(themes, 'space.md')}; align-items: center">
<span style="padding: ${v(themes, 'space.2xs')} ${v(themes, 'space.xs')}; border-radius: ${v(themes, 'radius.sm')}; background: ${r.bg}; color: ${r.fg}; font-weight: 700; text-align: center">طلبك</span>
<span dir="ltr" style="font-size: ${v(themes, 'type.panel.secondary.size')}">${esc(`${r.surface}: ${r.foreground} on ${r.background}`)}</span>
${label(themes, `${r.ratio.toFixed(2)}:1`)}${label(themes, `≥ ${r.target}`)}
<span style="font-size: ${v(themes, 'type.panel.secondary.size')}; font-weight: 700; color: ${v(themes, ink)}">${status}</span>
</div>`;
    })
    .join('\n');
  const body = [
    heading(
      themes,
      'Colour',
      'The semantic colours per theme. Dark copies Light until dark mode is designed; the captain themes raise text to 7:1. The brand orange sits below 4.5:1 under the owner’s exception (R4), allowed anywhere, text and numbers included.',
    ),
    card(themes, `${head}\n${rows}`),
    card(
      themes,
      `<strong style="font-size: ${v(themes, 'type.phone.subtitle.size')}">Contrast pairs (light and captain light)</strong>\n${pairs}`,
    ),
  ].join('\n');
  const h = 400 + light.length * 48 + results.length * 44;
  return page(themes, config, { file: 'Colour.dc.html', title: 'Colour', w: W, h }, body);
}

// Type: the three surfaces' scales -------------------------------------------

const SAMPLES: Record<string, string> = {
  caption: 'آخر تحديث قبل دقيقتين',
  secondary: 'المطعم يحضّر طلبك، نحو 15 دقيقة',
  body: 'طلبك في الطريق، والكابتن سيصل قريباً',
  subtitle: 'تفاصيل الطلب',
  title: 'المطاعم القريبة',
  'large-title': 'جوعان؟ الثعلب جاهز',
  number: '450 ₺',
};

function type(themes: Themes, config: GuideConfig): Board {
  const tokens = exported(themes.light).filter((t) => t.path[0] === 'type');
  const scales = [...new Set(tokens.map((t) => t.path[1]!))];
  const roles = [...new Set(tokens.map((t) => t.path[2]!))];
  const column = (scale: string) => {
    const items = roles.map((role) => {
      const get = (p: string) => v(themes, `type.${scale}.${role}.${p}`);
      const tnum = role === 'number' ? "; font-feature-settings: 'tnum'" : '';
      return `<div style="display: flex; flex-direction: column; gap: ${v(themes, 'space.2xs')}">
${label(themes, `${scale}-${role} · ${get('size')} / ${get('line-height')} / ${get('weight')}`)}
<span style="font-size: ${get('size')}; line-height: ${get('line-height')}; font-weight: ${get('weight')}${tnum}">${esc(SAMPLES[role] ?? role)}</span>
</div>`;
    });
    return card(
      themes,
      `<strong style="font-size: ${v(themes, 'type.phone.subtitle.size')}; color: ${v(themes, 'color.heading')}">${esc(scale[0]!.toUpperCase() + scale.slice(1))}</strong>\n${items.join('\n')}`,
      'flex: 1 1 0',
    );
  };
  const weights = exported(themes.light)
    .filter((t) => t.path[0] === 'font' && t.path[1] === 'weight')
    .map(
      (t) =>
        `<span style="font-size: ${v(themes, 'type.phone.title.size')}; font-weight: ${String(t.value)}">${esc(`${t.path[2]} ${String(t.value)}`)} · الجار الشاطر</span>`,
    )
    .join('\n');
  const body = [
    heading(
      themes,
      'Type',
      'CoFo Sans Pro Arabic alone, at 400, 500 and 700. Never below 12; no letter spacing, italics or kashida on Arabic; tabular digits for money and timers.',
    ),
    card(themes, weights),
    `<div style="display: flex; gap: ${v(themes, 'space.md')}; align-items: flex-start">${scales.map(column).join('\n')}</div>`,
  ].join('\n');
  return page(themes, config, { file: 'Type.dc.html', title: 'Type', w: W, h: 1200 }, body);
}

// Foundations: space, radius, size, elevation, motion -------------------------

function foundations(themes: Themes, config: GuideConfig): Board {
  const group = (name: string) => groupOf(themes.light, name);
  const name = (t: Token) => t.path.join('.');
  const space = group('space')
    .map(
      (t) =>
        `<div style="display: flex; align-items: center; gap: ${v(themes, 'space.md')}"><span style="width: 120px">${label(themes, `${name(t)} ${cssValue(t)}`)}</span><span style="height: 16px; width: ${cssValue(t)}; background: ${v(themes, 'color.accent')}; border-radius: ${v(themes, 'radius.full')}"></span></div>`,
    )
    .join('\n');
  const radius = group('radius')
    .map(
      (t) =>
        `<div style="display: flex; flex-direction: column; align-items: center; gap: ${v(themes, 'space.xs')}"><span style="width: 96px; height: 64px; background: ${v(themes, 'color.primary')}; border-radius: ${cssValue(t)}"></span>${label(themes, `${name(t)} ${cssValue(t)}`)}</div>`,
    )
    .join('\n');
  const size = group('size')
    .map(
      (t) =>
        `<div style="display: flex; align-items: center; gap: ${v(themes, 'space.md')}"><span style="width: ${cssValue(t)}; height: ${cssValue(t)}; border-radius: ${v(themes, 'radius.full')}; box-shadow: inset 0 0 0 2px ${v(themes, 'color.border-strong')}"></span>${label(themes, `${name(t)} ${cssValue(t)} · ${t.description ?? ''}`)}</div>`,
    )
    .join('\n');
  const elevation = group('elevation')
    .map(
      (t) =>
        `<div style="display: flex; flex-direction: column; gap: ${v(themes, 'space.sm')}; align-items: center"><span style="width: 160px; height: 80px; background: ${t.path[1] === 'offset' ? v(themes, 'color.primary') : v(themes, 'color.surface-raised')}; border-radius: ${v(themes, 'radius.lg')}; box-shadow: ${cssValue(t)}"></span>${label(themes, name(t))}</div>`,
    )
    .join('\n');
  const motion = [...group('duration'), ...group('easing')]
    .map((t) => label(themes, `${name(t)} ${cssValue(t)} · ${t.description ?? ''}`))
    .join('\n');
  const section = (title: string, inner: string, layout = 'column') =>
    card(
      themes,
      `<strong style="font-size: ${v(themes, 'type.phone.subtitle.size')}">${esc(title)}</strong><div dir="ltr" style="display: flex; flex-direction: ${layout}; flex-wrap: wrap; gap: ${v(themes, 'space.lg')}">${inner}</div>`,
    );
  const body = [
    heading(
      themes,
      'Foundations',
      'The 4-point grid, the Figma file’s radii, the control sizes, the elevations and the motion tokens.',
    ),
    section('Space', space),
    section('Radius', radius, 'row'),
    section('Size', size),
    section('Elevation', elevation, 'row'),
    section('Motion', motion),
  ].join('\n');
  return page(
    themes,
    config,
    { file: 'Foundations.dc.html', title: 'Foundations', w: W, h: 1500 },
    body,
  );
}

// Shapes: pill, circle, offset shadow, S-curve tab, the drop ------------------

function shapes(themes: Themes, config: GuideConfig): Board {
  const control = v(themes, 'size.control');
  const orange = v(themes, 'color.primary');
  const ivory = v(themes, 'color.on-primary');
  const blue = v(themes, 'color.accent');
  const raised = v(themes, 'color.surface-raised');
  const caption = (text: string) =>
    `<span style="font-size: ${v(themes, 'type.phone.secondary.size')}; line-height: 1.6; color: ${v(themes, 'color.on-surface-muted')}">${esc(text)}</span>`;
  const tile = (inner: string, text: string) =>
    card(
      themes,
      `<div style="height: 160px; display: flex; align-items: center; justify-content: center">${inner}</div>${caption(text)}`,
      'flex: 1 1 0',
    );
  const pill = `<span style="height: ${control}; padding: 0 ${v(themes, 'space.xl')}; display: inline-flex; align-items: center; border-radius: ${v(themes, 'radius.full')}; background: ${orange}; color: ${ivory}; font-weight: 700; font-size: ${v(themes, 'type.phone.subtitle.size')}; box-shadow: ${v(themes, 'elevation.offset')}">اطلب الآن</span>`;
  const circle = `<span aria-hidden="true" style="width: ${control}; height: ${control}; border-radius: ${v(themes, 'radius.full')}; background: ${blue}; display: inline-flex; align-items: center; justify-content: center"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="${ivory}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5v14"/></svg></span>`;
  const tab = `<svg aria-hidden="true" width="320" height="120" viewBox="0 0 320 120"><path d="M0 40 H100 C125 40 125 8 160 8 C195 8 195 40 220 40 H320 V120 H0 Z" fill="${orange}"/><text x="160" y="32" text-anchor="middle" font-size="14" font-weight="700" fill="${ivory}">العروض</text></svg>`;
  const drop = `<svg aria-hidden="true" width="64" height="88" viewBox="0 0 64 88"><path d="M32 86 C32 86 4 52 4 32 A28 28 0 0 1 60 32 C60 52 32 86 32 86 Z" fill="${orange}"/><circle cx="32" cy="32" r="12" fill="${ivory}"/></svg>`;
  const dish = `<div style="position: relative; width: 220px; height: 110px; background: ${raised}; border-radius: ${v(themes, 'radius.lg')}; box-shadow: ${v(themes, 'elevation.low')}"><span style="position: absolute; top: -36px; inset-inline-end: 16px; width: 96px; height: 96px; border-radius: ${v(themes, 'radius.full')}; border: 2px dashed ${v(themes, 'color.border-strong')}; display: flex; align-items: center; justify-content: center; font-size: ${v(themes, 'type.phone.caption.size')}; color: ${v(themes, 'color.on-surface-muted')}">صورة الطبق</span></div>`;
  const body = [
    heading(
      themes,
      'Shapes',
      'The Figma file’s shape language beside the logo’s drop (brand expression §2).',
    ),
    `<div style="display: flex; gap: ${v(themes, 'space.md')}">${tile(pill, 'The pill with the offset shadow: buttons, tags, the total bar’s action. On press it drops onto its shadow.')}${tile(circle, 'The circle: icon buttons and the floating bar’s items, at the control size.')}${tile(tab, 'The S-curve tab: a soft bump on the top edge of the home banner and the dish sheet, holding its title.')}</div>`,
    `<div style="display: flex; gap: ${v(themes, 'space.md')}">${tile(dish, 'The cut-out dish overlaps its card’s edge, only in images the platform prepares.')}${tile(drop, 'The drop means a place or “on its way to you”: map pins, loading, the confirmed moment. Never on cards, buttons or inputs.')}</div>`,
  ].join('\n');
  return page(themes, config, { file: 'Shapes.dc.html', title: 'Shapes', w: W, h: 900 }, body);
}

// Rules: every rule of §9.5, read from the architecture document --------------

export function rules(): { id: string; rule: string; enforced: string; slice: string }[] {
  const doc = readFileSync(path.join(ROOT, 'docs/architecture/09-design-system.md'), 'utf8');
  return doc
    .split(/\r?\n/)
    .filter((line) => /^\| R\d/.test(line))
    .map((line) => {
      const [id, rule, enforced, slice] = line
        .split('|')
        .slice(1, 5)
        .map((cell) => cell.trim().replaceAll('**', '').replaceAll('`', ''));
      return { id: id!, rule: rule!, enforced: enforced!, slice: slice! };
    });
}

function rulesBoard(themes: Themes, config: GuideConfig): Board {
  const list = rules();
  const rows = list
    .map(
      (r) =>
        `<div dir="ltr" style="display: grid; grid-template-columns: 56px minmax(0, 3fr) minmax(0, 2fr) 120px; gap: ${v(themes, 'space.md')}; padding-block: ${v(themes, 'space.sm')}; border-top: 1px solid ${v(themes, 'color.border')}; font-size: ${v(themes, 'type.panel.body.size')}; line-height: 1.6">
<strong>${esc(r.id)}</strong><span>${esc(r.rule)}</span><span style="color: ${v(themes, 'color.on-surface-muted')}">${esc(r.enforced)}</span><span>${esc(r.slice)}</span>
</div>`,
    )
    .join('\n');
  const body = [
    heading(themes, 'Rules', 'Architecture §9.5: every rule names the slice that enforces it.'),
    card(themes, rows),
  ].join('\n');
  return page(
    themes,
    config,
    { file: 'Rules.dc.html', title: 'Rules', w: W, h: 400 + list.length * 130 },
    body,
  );
}

// The canvas ------------------------------------------------------------------

export function boards(themes: Themes, config: GuideConfig, version: string): Board[] {
  return [
    main(themes, config, version),
    colour(themes, config),
    type(themes, config),
    foundations(themes, config),
    shapes(themes, config),
    rulesBoard(themes, config),
  ];
}

export function canvas(
  list: Board[],
  config: GuideConfig,
  now: string,
  title = 'Fox Drop Guide',
): string {
  let x = 0;
  const entries = list.map((b) => {
    const entry = [
      b.file,
      { x, y: 0, w: b.w, h: b.h, title: b.title, ...(b.interactive && { is_interactive: true }) },
    ] as const;
    x += b.w + 80;
    return entry;
  });
  const value = {
    v: 3,
    createdOnFiles: { v: 1, at: config.created },
    title,
    launch: { view: 'canvas' },
    pages: [],
    boards: Object.fromEntries(entries),
    order: list.map((b) => b.file),
    notes: {},
    designSystems: [
      {
        title: 'Fox Drop Design System',
        namespace: DS_FOLDER,
        artifact: config.system,
        version: null,
        copiedAt: now,
      },
    ],
  };
  return `${JSON.stringify(value, null, 2)}\n`;
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const at = process.argv.indexOf('--config');
  if (at === -1) throw new Error('Usage: guide --config <file>');
  const config = JSON.parse(readFileSync(process.argv[at + 1]!, 'utf8')) as GuideConfig;
  const themes = await resolveAll();
  const version = (
    JSON.parse(readFileSync(path.join(PACKAGE_DIR, 'package.json'), 'utf8')) as { version: string }
  ).version;
  const list = boards(themes, config, version);
  rmSync(OUT, { recursive: true, force: true });
  const files = new Map<string, string>([
    ['project/canvas.json', canvas(list, config, new Date().toISOString())],
    ...list.map((b) => [`project/${b.file}`, b.html] as [string, string]),
    [`project/ds/${DS_FOLDER}/tokens.json`, designSystem(themes)],
  ]);
  for (const [file, body] of files) {
    const target = path.join(OUT, file);
    mkdirSync(path.dirname(target), { recursive: true });
    writeFileSync(target, body);
  }
  console.log(`wrote ${OUT}`);
}
