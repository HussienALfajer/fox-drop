// Draws «Inputs and forms — batch 2» for the owner's review (architecture
// §9.9 step 1), the fourth artboard of the «Component proposals» canvas: every
// D.8 control in its states, both densities, RTL, the three surfaces and 130%
// text, from the real tokens. Where the owner has a real choice the sheet draws
// the options side by side, measured; the colours of an option that is not a
// token yet come from the primitives and are marked "proposed".
import { contrast } from './color.ts';
import { card, esc, heading, label, page, v, type Board, type GuideConfig } from './guide.ts';
import { cssValue } from './generate.ts';
import type { Icon } from './icons.ts';
import type { Theme, Token } from './resolve.ts';

type Themes = Record<Theme, Map<string, Token>>;

const W = 1680;

/** Primitives the options draw on (tokens/primitive/color.json). */
const P = {
  orange400: '#FF6E31',
  orange550: '#DA531B',
  orange600: '#C2410C',
  orange700: '#9A3412',
  orange50: '#FFF4ED',
  blue500: '#03428E',
  blue600: '#033878',
  blue50: '#EEF4FC',
  ivory: '#FFFAED',
  raised: '#FEFEFE',
  ground: '#FBF2E7',
};

/** The two icons this batch needs that the set lacks, proposed on the 24 grid (R8). */
const NEW_ICONS: Record<string, string[]> = {
  'chevron-down': ['M6 9l6 6 6-6'],
  calendar: [
    'M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z',
    'M4 10h16',
    'M8 3v4',
    'M16 3v4',
  ],
};

export const STATES = ['default', 'hover', 'focus', 'filled', 'disabled', 'invalid'] as const;
type State = (typeof STATES)[number];
const STATE_AR: Record<State, string> = {
  default: 'عادي',
  hover: 'تمرير المؤشر',
  focus: 'تركيز',
  filled: 'مُعبّأ',
  disabled: 'معطّل',
  invalid: 'خطأ',
};

/** Which colour marks focus and selection: the owner picks one (questions 1 and 2). */
type Accent = 'brand' | 'deep' | 'blue';
const ACCENT: Record<Accent, { rest: string; hover: string; pressed: string; on: string }> = {
  brand: { rest: P.orange400, hover: P.orange550, pressed: P.orange600, on: P.ivory },
  deep: { rest: P.orange550, hover: P.orange600, pressed: P.orange700, on: P.ivory },
  blue: { rest: P.blue500, hover: P.blue600, pressed: '#032E62', on: P.raised },
};
const ACCENT_AR: Record<Accent, string> = {
  brand: 'أ — البرتقالي الأساسي',
  deep: 'ب — البرتقالي الأعمق',
  blue: 'ج — الأزرق',
};

const ratio = (a: string, b: string) => contrast(a, b).toFixed(2);

interface Ctx {
  themes: Themes;
  theme: Theme;
  /** 'phone' 50, 'panel' 40, 'captain' 50 with the captain type. */
  surface: 'phone' | 'panel' | 'captain';
  accent: Accent;
  scale: number;
  icon: (name: string) => Icon['paths'];
}

const tk = (c: Ctx, name: string) => cssValue(c.themes[c.theme].get(name)!);
const px = (c: Ctx, name: string) => Number.parseFloat(tk(c, name));
const typeRole = (c: Ctx, role: string) => {
  const s = c.surface;
  return `font-size: ${Math.round(px(c, `type.${s}.${role}.size`) * c.scale)}px; line-height: 1.5; font-weight: ${tk(c, `type.${s}.${role}.weight`)};`;
};
const height = (c: Ctx) => (c.surface === 'panel' ? 40 : 50);

function svg(paths: string[], size: number, colour = 'currentColor', flip = false): string {
  const transform = flip ? '; transform: scaleX(-1)' : '';
  return `<svg aria-hidden="true" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="${colour}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex: none${transform}">${paths.map((d) => `<path d="${d}"/>`).join('')}</svg>`;
}

const spinner = (size: number, colour: string) =>
  `<svg aria-hidden="true" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="${colour}" stroke-width="2.5" stroke-linecap="round" style="flex: none"><path d="M12 3a9 9 0 1 0 9 9" /></svg>`;

/** The outline of a field in a state: an inset shadow, so a 2 border never moves the text. */
function outline(c: Ctx, state: State | 'focus-invalid'): string {
  const focus = ACCENT[c.accent].rest;
  switch (state) {
    case 'hover':
      return `inset 0 0 0 1px ${tk(c, 'color.border-hover')}`;
    case 'focus':
      return `inset 0 0 0 2px ${focus}`;
    case 'invalid':
    case 'focus-invalid':
      return `inset 0 0 0 2px ${tk(c, 'color.danger')}`;
    case 'disabled':
      return 'none';
    default:
      return `inset 0 0 0 1px ${tk(c, 'color.border-strong')}`;
  }
}

interface FieldOpts {
  state?: State;
  shape?: 'pill' | 'box' | 'area';
  label?: string;
  optional?: boolean;
  hint?: string;
  error?: string;
  value?: string;
  placeholder?: string;
  start?: { paths: string[]; colour?: string };
  end?: string;
  width?: number;
  ltr?: boolean;
}

/** The control alone: the pill or the box with its icons and text. */
function control(c: Ctx, o: FieldOpts, inner?: string): string {
  const state = o.state ?? 'default';
  const disabled = state === 'disabled';
  const h = height(c);
  const iconSize = c.surface === 'panel' ? 16 : 24;
  const radius =
    o.shape === 'box'
      ? tk(c, 'radius.md')
      : o.shape === 'area'
        ? tk(c, 'radius.lg')
        : tk(c, 'radius.full');
  const text = disabled ? tk(c, 'color.on-disabled') : tk(c, 'color.on-surface');
  const value = o.value ?? (state === 'filled' || state === 'invalid' ? 'محمد الأحمد' : '');
  const shown = value
    ? `<span style="color: ${text}${o.ltr ? '; direction: ltr; unicode-bidi: isolate' : ''}">${esc(value)}</span>`
    : `<span style="color: ${disabled ? tk(c, 'color.on-disabled') : tk(c, 'color.on-surface-muted')}">${esc(o.placeholder ?? 'اكتب اسمك')}</span>`;
  const start = o.start
    ? svg(o.start.paths, iconSize, disabled ? tk(c, 'color.on-disabled') : (o.start.colour ?? text))
    : '';
  const end = o.end ?? '';
  const bg = disabled ? tk(c, 'color.disabled') : tk(c, 'color.surface-raised');
  return `<div style="display: flex; align-items: center; gap: ${tk(c, 'space.xs')}; box-sizing: border-box; min-height: ${h}px; width: ${o.width ?? 300}px; padding-inline: ${c.surface === 'panel' ? tk(c, 'space.sm') : tk(c, 'space.md')}; border-radius: ${radius}; background: ${bg}; box-shadow: ${outline(c, state)}; ${typeRole(c, 'body')}">${inner ?? `${start}<span style="flex: 1; min-width: 0; overflow: hidden; white-space: nowrap; text-overflow: ellipsis">${shown}</span>${end}`}</div>`;
}

/** The wrapper: label above, the control, then the hint or the error with its icon. */
function field(c: Ctx, o: FieldOpts, inner?: string): string {
  const state = o.state ?? 'default';
  const invalid = state === 'invalid';
  const muted = tk(c, 'color.on-surface-muted');
  const lbl = o.label
    ? `<div style="${typeRole(c, 'secondary')} font-weight: 500; color: ${state === 'disabled' ? tk(c, 'color.on-disabled') : tk(c, 'color.on-surface')}">${esc(o.label)}${o.optional ? ` <span style="font-weight: 400; color: ${muted}">(اختياري)</span>` : ''}</div>`
    : '';
  const below = invalid
    ? `<div style="display: flex; align-items: center; gap: ${tk(c, 'space.2xs')}; ${typeRole(c, 'caption')} color: ${tk(c, 'color.danger')}">${svg(c.icon('error'), 16, tk(c, 'color.danger'))}<span>${esc(o.error ?? 'اكتب الاسم كما في الهوية')}</span></div>`
    : o.hint
      ? `<div style="${typeRole(c, 'caption')} color: ${muted}">${esc(o.hint)}</div>`
      : '';
  return `<div style="display: flex; flex-direction: column; gap: ${tk(c, 'space.2xs')}; width: ${o.width ?? 300}px">${lbl}${control(c, o, inner)}${below}</div>`;
}

const cell = (inner: string, caption = '') =>
  `<div style="display: flex; flex-direction: column; align-items: flex-start; justify-content: flex-end; gap: 8px">${inner}${caption}</div>`;

function h2(themes: Themes, text: string, note = ''): string {
  return `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">${esc(text)} ${note ? label(themes, note) : ''}</h2>`;
}
const row = (themes: Themes, items: string[]) =>
  `<div style="display: flex; flex-wrap: wrap; align-items: flex-end; gap: ${v(themes, 'space.xl')}">${items.join('')}</div>`;
const option = (themes: Themes, title: string, inner: string, note: string, picked = false) =>
  `<div style="flex: 1; min-width: 0; display: flex; flex-direction: column; gap: ${v(themes, 'space.sm')}; padding: ${v(themes, 'space.lg')}; border-radius: ${v(themes, 'radius.lg')}; background: ${v(themes, 'color.surface')}; ${picked ? `box-shadow: inset 0 0 0 2px ${v(themes, 'color.accent')}` : ''}"><div style="font-weight: 700">${esc(title)}${picked ? ` <span style="font-weight: 500; color: ${v(themes, 'color.accent')}">· اعتمده المالك</span>` : ''}</div>${inner}<div>${label(themes, note)}</div></div>`;
const options = (themes: Themes, items: string[]) =>
  `<div style="display: flex; gap: ${v(themes, 'space.lg')}; align-items: stretch">${items.join('')}</div>`;

// ---------- the controls ----------

type Check = 'off' | 'on' | 'mixed';
type ControlState = 'default' | 'hover' | 'focus' | 'pressed' | 'disabled' | 'invalid';

function focusRing(c: Ctx, inner: string, radius: string, on: boolean): string {
  if (!on) return inner;
  return `<span style="display: inline-flex; border-radius: ${radius}; box-shadow: 0 0 0 2px ${tk(c, 'color.surface')}, 0 0 0 4px ${tk(c, 'color.focus-ring')}">${inner}</span>`;
}

/** Checkbox (a soft square) or radio (a circle), 24 drawn inside a 48 target. */
function tick(c: Ctx, kind: 'checkbox' | 'radio', check: Check, state: ControlState): string {
  const a = ACCENT[c.accent];
  const disabled = state === 'disabled';
  const on = check !== 'off';
  const radius = kind === 'radio' ? '50%' : tk(c, 'radius.sm');
  let fill = tk(c, 'color.surface-raised');
  let border = tk(c, 'color.border-strong');
  if (state === 'hover') {
    border = tk(c, 'color.border-hover');
    fill = tk(c, 'color.surface-raised-hover');
  }
  if (state === 'pressed') {
    border = tk(c, 'color.border-hover');
    fill = tk(c, 'color.surface-raised-pressed');
  }
  if (state === 'invalid') border = tk(c, 'color.danger');
  let mark = '';
  if (on && kind === 'checkbox') {
    const colour = state === 'hover' ? a.hover : state === 'pressed' ? a.pressed : a.rest;
    fill = disabled ? tk(c, 'color.disabled') : colour;
    border = fill;
    mark = svg(
      check === 'mixed' ? c.icon('remove') : c.icon('confirm'),
      18,
      disabled ? tk(c, 'color.on-disabled') : a.on,
    );
  }
  if (on && kind === 'radio') {
    const colour = disabled
      ? tk(c, 'color.on-disabled')
      : state === 'hover'
        ? a.hover
        : state === 'pressed'
          ? a.pressed
          : a.rest;
    border = colour;
    mark = `<span style="width: 12px; height: 12px; border-radius: 50%; background: ${colour}"></span>`;
  }
  if (disabled && !on) {
    fill = tk(c, 'color.disabled');
    border = tk(c, 'color.on-disabled');
  }
  const box = `<span style="display: inline-flex; align-items: center; justify-content: center; width: 24px; height: 24px; box-sizing: border-box; border-radius: ${radius}; background: ${fill}; box-shadow: inset 0 0 0 2px ${border}">${mark}</span>`;
  return `<span style="display: inline-flex; align-items: center; justify-content: center; width: 48px; height: 48px; flex: none">${focusRing(c, box, radius, state === 'focus')}</span>`;
}

function choice(
  c: Ctx,
  kind: 'checkbox' | 'radio',
  check: Check,
  state: ControlState,
  text: string,
): string {
  const colour = state === 'disabled' ? tk(c, 'color.on-disabled') : tk(c, 'color.on-surface');
  return `<span style="display: inline-flex; align-items: center; gap: ${tk(c, 'space.2xs')}; ${typeRole(c, 'body')} color: ${colour}; margin-inline-start: -12px">${tick(c, kind, check, state)}<span>${esc(text)}</span></span>`;
}

/** The switch: A the classic track, B two fused circles (the Figma nav bar's waist). */
function toggle(c: Ctx, style: 'track' | 'bubble', on: boolean, state: ControlState): string {
  const a = ACCENT[c.accent];
  const disabled = state === 'disabled';
  const colour = disabled
    ? tk(c, 'color.disabled')
    : state === 'hover'
      ? a.hover
      : state === 'pressed'
        ? a.pressed
        : a.rest;
  const offTrack = disabled
    ? tk(c, 'color.disabled')
    : state === 'hover'
      ? tk(c, 'color.border-hover')
      : tk(c, 'color.border-strong');
  // RTL: off rests at the start (right), on moves to the end (left).
  if (style === 'track') {
    const thumbX = on ? 4 : 24;
    const s = `<svg aria-hidden="true" width="52" height="32" viewBox="0 0 52 32"><rect x="0" y="0" width="52" height="32" rx="16" fill="${on ? colour : offTrack}"/><circle cx="${thumbX + 12}" cy="16" r="12" fill="${disabled ? tk(c, 'color.on-disabled') : P.raised}"/></svg>`;
    return `<span style="display: inline-flex; align-items: center; justify-content: center; height: 48px; padding-inline: 4px">${focusRing(c, `<span style="display: inline-flex">${s}</span>`, '16px', state === 'focus')}</span>`;
  }
  // Two circles r 15 at 16 and 44, joined by a waist 7 deep.
  const body = `M16 1C21 1 24 4 30 4C36 4 39 1 44 1A15 15 0 0 1 44 31C39 31 36 28 30 28C24 28 21 31 16 31A15 15 0 0 1 16 1Z`;
  const thumbCx = on ? 16 : 44;
  const s = `<svg aria-hidden="true" width="60" height="32" viewBox="0 0 60 32"><path d="${body}" fill="${on ? colour : offTrack}"/><circle cx="${thumbCx}" cy="16" r="11" fill="${disabled ? tk(c, 'color.on-disabled') : P.raised}"/></svg>`;
  return `<span style="display: inline-flex; align-items: center; justify-content: center; height: 48px; padding-inline: 4px">${focusRing(c, `<span style="display: inline-flex">${s}</span>`, '16px', state === 'focus')}</span>`;
}

/** The quantity stepper: two circles 32 bridged by a concave strip (the Figma cart). */
function stepper(
  c: Ctx,
  count: number,
  opts: { min?: boolean; max?: boolean; disabled?: boolean; pressed?: 'add' | 'remove' } = {},
): string {
  const a = ACCENT[c.accent];
  const off = tk(c, 'color.on-disabled');
  const raised = tk(c, 'color.surface-raised');
  const circle = (cx: number, paths: string[], dim: boolean, pressed: boolean) =>
    `<circle cx="${cx}" cy="24" r="16" fill="${pressed ? tk(c, 'color.surface-raised-pressed') : raised}" stroke="${dim ? off : a.rest}" stroke-width="1.5"/><g transform="translate(${cx - 8} 16) scale(0.6667)" fill="none" stroke="${dim ? off : a.rest}" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round">${paths.map((d) => `<path d="${d}"/>`).join('')}</g>`;
  // In RTL «+» sits at the start (right) and «−» at the end (left), as in the Figma cart.
  const minus = opts.min ? c.icon('delete') : c.icon('remove');
  const bridge = `<path d="M34.25 8H105.75A19 19 0 0 0 105.75 40H34.25A19 19 0 0 0 34.25 8Z" fill="${raised}"/>`;
  const number = `<text x="70" y="30" text-anchor="middle" font-size="${Math.round(18 * c.scale)}" font-weight="700" fill="${opts.disabled ? off : tk(c, 'color.on-surface')}" style="font-feature-settings: 'tnum'">${count}</text>`;
  const targets = `<circle cx="24" cy="24" r="23.5" fill="none" stroke="${tk(c, 'color.border-strong')}" stroke-dasharray="2 3" stroke-width="1"/><circle cx="116" cy="24" r="23.5" fill="none" stroke="${tk(c, 'color.border-strong')}" stroke-dasharray="2 3" stroke-width="1"/>`;
  return `<svg aria-hidden="true" width="140" height="48" viewBox="0 0 140 48">${targets}${bridge}${circle(24, minus, !!opts.disabled, opts.pressed === 'remove')}${circle(116, c.icon('add'), !!opts.disabled || !!opts.max, opts.pressed === 'add')}${number}</svg>`;
}

/** The sign-in code: six cells, A circles, B soft squares. */
function code(
  c: Ctx,
  shape: 'circle' | 'box',
  digits: string,
  state: 'typing' | 'invalid' | 'done',
): string {
  const a = ACCENT[c.accent];
  const cells = Array.from({ length: 6 }, (_, i) => {
    const d = digits[i] ?? '';
    const current = state === 'typing' && i === digits.length;
    const border =
      state === 'invalid'
        ? `inset 0 0 0 2px ${tk(c, 'color.danger')}`
        : current
          ? `inset 0 0 0 2px ${a.rest}`
          : `inset 0 0 0 1px ${tk(c, 'color.border-strong')}`;
    const fill = state === 'done' ? a.rest : tk(c, 'color.surface-raised');
    const fg = state === 'done' ? a.on : tk(c, 'color.on-surface');
    const caret = current
      ? `<span style="width: 2px; height: 24px; background: ${a.rest}"></span>`
      : '';
    return `<span style="display: inline-flex; align-items: center; justify-content: center; width: 48px; height: ${shape === 'circle' ? 48 : 56}px; box-sizing: border-box; border-radius: ${shape === 'circle' ? '50%' : tk(c, 'radius.md')}; background: ${fill}; box-shadow: ${state === 'done' ? 'none' : border}; ${typeRole(c, 'title')} color: ${fg}; font-feature-settings: 'tnum'">${esc(d)}${caret}</span>`;
  }).join('');
  return `<div dir="ltr" style="display: inline-flex; gap: ${state === 'done' && shape === 'circle' ? '0' : tk(c, 'space.xs')}">${cells}</div>`;
}

// ---------- the sheet ----------

export function formsSheet(themes: Themes, config: GuideConfig, icons: Icon[]): Board {
  const icon = (name: string) => NEW_ICONS[name] ?? icons.find((i) => i.name === name)!.paths;
  const base: Ctx = { themes, theme: 'light', surface: 'phone', accent: 'brand', scale: 1, icon };
  const phone = base;
  const panel: Ctx = { ...base, surface: 'panel' };
  const captain: Ctx = { ...base, theme: 'captainLight', surface: 'captain' };
  const muted = v(themes, 'color.on-surface-muted');
  const chevron = (c: Ctx, open = false) =>
    `<span style="display: inline-flex; ${open ? 'transform: rotate(180deg)' : ''}">${svg(icon('chevron-down'), c.surface === 'panel' ? 16 : 24, tk(c, 'color.on-surface'))}</span>`;

  // 1. The text field and its wrapper, every state, both densities.
  const matrix = (c: Ctx, title: string, note: string) =>
    card(
      themes,
      h2(themes, title, note) +
        `<div style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: ${v(themes, 'space.xl')} ${v(themes, 'space.lg')}">${STATES.map(
          (state) =>
            cell(
              field(c, {
                state,
                label: 'الاسم الكامل',
                hint: 'كما يظهر للمطعم والكابتن',
                width: c.surface === 'panel' ? 280 : 340,
              }),
              `<div style="font-weight: 500">${STATE_AR[state]} ${label(themes, state)}</div>`,
            ),
        ).join('')}</div>`,
    );

  const wrapper = card(
    themes,
    h2(
      themes,
      'غلاف الحقل',
      'label above · (optional) marked, not required · hint, or the error with its icon (never colour alone) · counter on long text',
    ) +
      row(themes, [
        cell(
          field(phone, { label: 'اسم الشارع', optional: true, placeholder: 'مثال: شارع الكفين' }),
          label(themes, 'optional'),
        ),
        cell(
          field(phone, {
            label: 'ملاحظة للكابتن',
            optional: true,
            start: { paths: icon('chat'), colour: muted },
            placeholder: 'بجانب الصيدلية',
          }),
          label(themes, 'start icon, muted'),
        ),
        cell(
          field(phone, {
            state: 'invalid',
            label: 'الاسم الكامل',
            value: 'م',
            error: 'الاسم قصير جدًا',
          }),
          label(themes, 'invalid: red 2 + icon + text, announced'),
        ),
      ]),
  );

  // 2. Long text.
  const area = (state: State, value: string) =>
    field(
      phone,
      {
        state,
        shape: 'area',
        label: 'ملاحظات الطلب',
        optional: true,
        width: 340,
      },
      `<div style="display: flex; flex-direction: column; width: 100%; padding-block: ${v(themes, 'space.sm')}; gap: ${v(themes, 'space.xs')}"><span style="min-height: 72px; color: ${value ? v(themes, 'color.on-surface') : muted}">${esc(value || 'مثلًا: بدون بصل، والصلصة جانبًا')}</span><span style="align-self: flex-end; ${typeRole(phone, 'caption')} color: ${muted}; font-feature-settings: 'tnum'" dir="ltr">${value.length}/200</span></div>`,
    );
  const longText = card(
    themes,
    h2(
      themes,
      'النص الطويل',
      'radius 15 · 3 lines then grows to 6, then scrolls · counter at the end, digits Western',
    ) +
      row(themes, [
        cell(area('default', '')),
        cell(area('focus', 'بدون بصل، والصلصة جانبًا')),
        cell(area('invalid', 'نص أطول من الحد المسموح…')),
      ]),
  );

  // 3. Search.
  const searchIcon = () => ({ paths: icon('search'), colour: ACCENT.brand.rest });
  const clear = (c: Ctx) =>
    `<span style="display: inline-flex; align-items: center; justify-content: center; width: 32px; height: 32px; border-radius: 50%; background: ${tk(c, 'color.surface')}">${svg(icon('close'), 16, tk(c, 'color.on-surface'))}</span>`;
  const search = card(
    themes,
    h2(
      themes,
      'البحث',
      'the Figma home pill · orange lens at the start (decorative: the placeholder names it) · clear at the end once typed · spinner while results load',
    ) +
      row(themes, [
        cell(
          control(phone, {
            start: searchIcon(),
            placeholder: 'ابحث عن طبق أو مطعم',
            width: 340,
          }),
          label(themes, 'default'),
        ),
        cell(
          control(phone, {
            state: 'focus',
            start: searchIcon(),
            value: 'شاورما',
            end: clear(phone),
            width: 340,
          }),
          label(themes, 'focus, typed · clear'),
        ),
        cell(
          control(phone, {
            state: 'focus',
            start: searchIcon(),
            value: 'شاورما عربي',
            end: spinner(20, ACCENT.brand.rest),
            width: 340,
          }),
          label(themes, 'loading'),
        ),
        cell(
          control(panel, {
            start: { paths: icon('search'), colour: muted },
            placeholder: 'ابحث برقم الطلب أو الهاتف',
            width: 300,
          }),
          label(themes, 'panel 40 · muted lens'),
        ),
      ]),
  );

  // 4. Phone: the country and the number.
  const country = (c: Ctx, text: string) =>
    `<span style="display: inline-flex; align-items: center; gap: 4px; padding-inline: 10px; height: 34px; border-radius: ${tk(c, 'radius.full')}; background: ${tk(c, 'color.surface')}; ${typeRole(c, 'secondary')} font-weight: 500; color: ${tk(c, 'color.on-surface')}"><span dir="ltr">${esc(text)}</span>${svg(icon('chevron-down'), 16, tk(c, 'color.on-surface'))}</span>`;
  /** Option C's inside: an LTR island, the country at the left, then the digits. */
  const phoneInner = (c: Ctx, digits = '94412') =>
    `<span dir="ltr" style="display: flex; align-items: center; gap: 8px; width: 100%">${country(c, '+963')}<span style="flex: 1; text-align: left; color: ${tk(c, 'color.on-surface')}; font-feature-settings: 'tnum'">${digits}</span></span>`;
  const phoneA = control(
    phone,
    { state: 'focus', width: 340 },
    `${country(phone, '+963')}<span dir="ltr" style="flex: 1; text-align: start; unicode-bidi: isolate; color: ${v(themes, 'color.on-surface')}; font-feature-settings: 'tnum'">9xx xxx xxx</span>`,
  );
  const phoneB = `<div dir="ltr" style="display: inline-flex; align-items: center; gap: 6px">${control(
    phone,
    { width: 96 },
    `<span style="flex: 1; text-align: center; font-weight: 500; font-feature-settings: 'tnum'">+963</span>${svg(icon('chevron-down'), 16, v(themes, 'color.on-surface'))}`,
  )}${control(phone, { state: 'focus', width: 238 }, `<span style="flex: 1; text-align: left; font-feature-settings: 'tnum'">944 123 456</span>`)}</div>`;
  const phoneC = `<div dir="ltr">${control(
    phone,
    { state: 'focus', width: 340 },
    `${country(phone, '+963')}<span style="flex: 1; text-align: left; font-feature-settings: 'tnum'">944 123 456</span>`,
  )}</div>`;
  const phoneCard = card(
    themes,
    h2(
      themes,
      'رقم الهاتف',
      'CU §5.2: «سوريا +963» or «تركيا +90», default from settings; 09… and 9… both accepted, stored E.164; the digits are an LTR island',
    ) +
      options(themes, [
        option(
          themes,
          'أ — الدولة في البداية (يمين)',
          phoneA,
          'the field follows RTL; the number itself is LTR, aligned to the start',
        ),
        option(
          themes,
          'ب — دائرة الدولة والرقم منفصلان (فكرة الجسر)',
          phoneB,
          'two controls in an LTR row: +963 reads before the number as it is written',
          false,
        ),
        option(
          themes,
          'ج — حقل واحد يُقرأ كما يُكتب الرقم',
          phoneC,
          'one pill, LTR inside: +963 at the left, then the number; the label and errors stay RTL',
          true,
        ),
      ]) +
      row(themes, [
        cell(
          field(
            phone,
            {
              state: 'invalid',
              label: 'رقم الموبايل',
              width: 340,
              error: 'رقم سوري يبدأ بـ 9 ويتكون من 9 أرقام',
            },
            phoneInner(phone),
          ),
          label(themes, 'invalid (C)'),
        ),
        cell(
          `<div style="display: flex; flex-direction: column; width: 220px; padding: ${v(themes, 'space.2xs')}; border-radius: ${v(themes, 'radius.lg')}; background: ${v(themes, 'color.surface-raised')}; box-shadow: ${v(themes, 'elevation.medium')}">${[
            ['سوريا', '+963', true],
            ['تركيا', '+90', false],
          ]
            .map(
              ([name, dial, on]) =>
                `<div style="display: flex; align-items: center; gap: 8px; min-height: 48px; padding-inline: ${v(themes, 'space.sm')}; border-radius: ${v(themes, 'radius.md')}; background: ${on ? v(themes, 'color.surface-hover') : 'transparent'}"><span style="flex: 1">${name}</span><span dir="ltr" style="color: ${muted}">${dial}</span>${on ? svg(icon('confirm'), 18, ACCENT.brand.rest) : '<span style="width: 18px"></span>'}</div>`,
            )
            .join('')}</div>`,
          label(themes, 'the country menu (the select’s list)'),
        ),
      ]),
  );

  // 5. The sign-in code.
  const codeCard = card(
    themes,
    h2(
      themes,
      'رمز الدخول',
      'architecture §8.3.4: 6 digits, paste accepted, Android offers a code found on the clipboard · LTR, digits Western · one input under the cells (autofill, paste, screen readers)',
    ) +
      options(themes, [
        option(
          themes,
          'أ — دوائر (لغة الدائرة في الملف)',
          `<div style="display: flex; flex-direction: column; gap: 14px">${code(phone, 'circle', '48', 'typing')}${code(phone, 'circle', '481', 'invalid')}${code(phone, 'circle', '481920', 'done')}</div>`,
          'typing · wrong code (red, message below, cleared on the next digit) · accepted: the circles fill and fuse for one moment (duration.moment), then the next screen',
          true,
        ),
        option(
          themes,
          'ب — مربعات ناعمة 48×56',
          `<div style="display: flex; flex-direction: column; gap: 14px">${code(phone, 'box', '48', 'typing')}${code(phone, 'box', '481', 'invalid')}${code(phone, 'box', '481920', 'done')}</div>`,
          'the common pattern; no fuse, the cells fill',
        ),
      ]) +
      `<div style="${typeRole(phone, 'caption')} color: ${muted}">الرسالة: «أرسلنا الرمز إلى واتساب على الرقم <span dir="ltr">+963 944 123 456</span>» ثم «إعادة الإرسال» بعد المهلة و«تعديل الرقم» (نصوص الشاشات من المواصفات، لا من المكوّن).</div>`,
  );

  // 6. Select.
  const listbox = (c: Ctx, w: number) =>
    `<div style="display: flex; flex-direction: column; width: ${w}px; padding: ${tk(c, 'space.2xs')}; border-radius: ${tk(c, 'radius.lg')}; background: ${tk(c, 'color.surface-raised')}; box-shadow: ${tk(c, 'elevation.medium')}; ${typeRole(c, 'body')}">${[
      ['كبير', false, false],
      ['وسط', true, false],
      ['صغير', false, true],
      ['عائلي (نفد)', false, false, true],
    ]
      .map(
        ([text, on, hover, off]) =>
          `<div style="display: flex; align-items: center; gap: 8px; min-height: ${c.surface === 'panel' ? 36 : 48}px; padding-inline: ${tk(c, 'space.sm')}; border-radius: ${tk(c, 'radius.md')}; background: ${hover ? tk(c, 'color.surface-hover') : 'transparent'}; color: ${off ? tk(c, 'color.on-disabled') : tk(c, 'color.on-surface')}; font-weight: ${on ? 500 : 400}"><span style="flex: 1">${text}</span>${on ? svg(icon('confirm'), 18, ACCENT.brand.rest) : ''}</div>`,
      )
      .join('')}</div>`;
  const select = card(
    themes,
    h2(
      themes,
      'القائمة المنسدلة',
      'a pill with the new chevron-down at the end · web: a listbox under the field (keyboard, type-ahead) · Flutter: a menu under the field now, the bottom sheet once D.10 builds it',
    ) +
      row(themes, [
        cell(
          field(phone, {
            label: 'الحجم',
            placeholder: 'اختر الحجم',
            end: chevron(phone),
            width: 260,
          }),
          label(themes, 'default'),
        ),
        cell(
          field(phone, {
            state: 'hover',
            label: 'الحجم',
            value: 'وسط',
            end: chevron(phone),
            width: 260,
          }),
          label(themes, 'hover'),
        ),
        cell(
          `<div style="display: flex; flex-direction: column; gap: 6px">${field(phone, { state: 'focus', label: 'الحجم', value: 'وسط', end: chevron(phone, true), width: 260 })}${listbox(phone, 260)}</div>`,
          label(themes, 'open · selected ticked · sold out disabled'),
        ),
        cell(
          field(phone, {
            state: 'disabled',
            label: 'الحجم',
            value: 'وسط',
            end: chevron(phone),
            width: 260,
          }),
          label(themes, 'disabled'),
        ),
        cell(
          field(phone, {
            state: 'invalid',
            label: 'الحجم',
            placeholder: 'اختر الحجم',
            error: 'اختر الحجم للمتابعة',
            end: chevron(phone),
            width: 260,
          }),
          label(themes, 'invalid'),
        ),
        cell(
          `<div style="display: flex; flex-direction: column; gap: 6px">${field(panel, { state: 'focus', label: 'المدينة', value: 'اعزاز', end: chevron(panel, true), width: 220 })}${listbox(panel, 220)}</div>`,
          label(themes, 'panel 40'),
        ),
      ]),
  );

  // 7. Colour of focus and selection: three options, measured.
  const swatch = (accent: Accent) => {
    const c: Ctx = { ...base, accent };
    const a = ACCENT[accent];
    return option(
      themes,
      ACCENT_AR[accent],
      `<div style="display: flex; flex-direction: column; gap: 10px">${control(c, { state: 'focus', value: 'محمد', width: 300 })}<div style="display: flex; align-items: center; gap: 4px">${tick(c, 'checkbox', 'on', 'default')}${tick(c, 'radio', 'on', 'default')}${toggle(c, 'track', true, 'default')}${stepper(c, 2)}</div></div>`,
      `${a.rest} · on raised ${ratio(a.rest, P.raised)}:1 · on ground ${ratio(a.rest, P.ground)}:1 · needs 3:1 (focus, boundaries) ${contrast(a.rest, P.ground) >= 3 ? '— passes' : '— below: only under an extended R4 exception'}`,
      accent === 'brand',
    );
  };
  const accentCard = card(
    themes,
    h2(
      themes,
      'لون التركيز والاختيار',
      'one colour for the focused outline, the current code cell, and checked controls; the keyboard ring stays the blue focus-ring of the Button (R10)',
    ) + options(themes, (['brand', 'deep', 'blue'] as const).map(swatch)),
  );

  // 8. Checkbox and radio.
  const CTRL: ControlState[] = ['default', 'hover', 'focus', 'pressed', 'disabled', 'invalid'];
  const ctrlHead = `<div></div>${CTRL.map((s) => `<div style="font-weight: 500; text-align: center">${label(themes, s)}</div>`).join('')}`;
  const ctrlRow = (title: string, make: (s: ControlState) => string) =>
    `<div style="font-weight: 700; align-self: center">${esc(title)}</div>${CTRL.map((s) => `<div style="display: flex; justify-content: center">${make(s)}</div>`).join('')}`;
  const ticks = card(
    themes,
    h2(
      themes,
      'مربع الاختيار والزر الدائري',
      '24 drawn in a 48 target · checkbox a soft square (radius 8), radio a circle: the shape tells them apart · hover and pressed by R10 · the whole row is the target',
    ) +
      `<div style="display: grid; grid-template-columns: 160px repeat(${CTRL.length}, minmax(0, 1fr)); gap: ${v(themes, 'space.sm')}; align-items: center">${ctrlHead}${ctrlRow('اختيار — فارغ', (s) => tick(phone, 'checkbox', 'off', s))}${ctrlRow('اختيار — محدد', (s) => tick(phone, 'checkbox', 'on', s))}${ctrlRow('اختيار — جزئي', (s) => tick(phone, 'checkbox', 'mixed', s))}${ctrlRow('دائري — فارغ', (s) => tick(phone, 'radio', 'off', s))}${ctrlRow('دائري — محدد', (s) => tick(phone, 'radio', 'on', s))}</div>` +
      row(themes, [
        cell(
          `<div style="display: flex; flex-direction: column">${choice(phone, 'radio', 'on', 'default', 'وسط')}${choice(phone, 'radio', 'off', 'default', 'كبير')}${choice(phone, 'radio', 'off', 'disabled', 'عائلي (نفد)')}</div>`,
          label(themes, 'radio group: the dish size (CU)'),
        ),
        cell(
          `<div style="display: flex; flex-direction: column">${choice(phone, 'checkbox', 'on', 'default', 'جبنة إضافية')}${choice(phone, 'checkbox', 'off', 'default', 'بدون بصل')}${choice(phone, 'checkbox', 'off', 'invalid', 'أوافق على الشروط')}</div>`,
          label(themes, 'checkboxes: options and the terms'),
        ),
        cell(
          `<div style="display: flex; flex-direction: column">${choice(panel, 'checkbox', 'mixed', 'default', 'تحديد الكل')}${choice(panel, 'checkbox', 'on', 'default', 'طلب #10423')}</div>`,
          label(themes, 'panel: mixed for select-all'),
        ),
      ]),
  );

  // 9. Switch.
  const SW: ControlState[] = ['default', 'hover', 'focus', 'pressed', 'disabled'];
  const switchRows = (style: 'track' | 'bubble') =>
    `<div style="display: grid; grid-template-columns: 70px repeat(${SW.length}, minmax(0, 1fr)); gap: 6px; align-items: center"><div></div>${SW.map((s) => `<div style="text-align: center">${label(themes, s)}</div>`).join('')}<div>${label(themes, 'off')}</div>${SW.map((s) => `<div style="display: flex; justify-content: center">${toggle(phone, style, false, s)}</div>`).join('')}<div>${label(themes, 'on')}</div>${SW.map((s) => `<div style="display: flex; justify-content: center">${toggle(phone, style, true, s)}</div>`).join('')}</div>`;
  const switchLine = (c: Ctx, style: 'track' | 'bubble', on: boolean, text: string, sub: string) =>
    `<div style="display: flex; align-items: center; gap: ${tk(c, 'space.md')}; width: 380px; padding: ${tk(c, 'space.sm')} ${tk(c, 'space.md')}; border-radius: ${tk(c, 'radius.lg')}; background: ${tk(c, 'color.surface-raised')}"><div style="flex: 1; display: flex; flex-direction: column"><span style="${typeRole(c, 'subtitle')} color: ${tk(c, 'color.on-surface')}">${esc(text)}</span><span style="${typeRole(c, 'caption')} color: ${tk(c, 'color.on-surface-muted')}">${esc(sub)}</span></div>${toggle(c, style, on, 'default')}</div>`;
  const switches = card(
    themes,
    h2(
      themes,
      'المفتاح',
      'RTL: off rests at the start (right), on slides to the end (left) over duration.base · the state is in words beside it, not colour alone',
    ) +
      options(themes, [
        option(
          themes,
          'أ — المسار الكلاسيكي 52×32',
          switchRows('track'),
          'the shape every phone user knows',
          true,
        ),
        option(
          themes,
          'ب — الدائرتان المتلاحمتان (خصر الشريط الفقاعي)',
          switchRows('bubble'),
          'the Figma nav bar’s waist, 60×32: more FOX DROP, less familiar',
        ),
      ]) +
      row(themes, [
        switchLine(phone, 'track', true, 'المطعم مفتوح', 'يستقبل الطلبات الآن'),
        switchLine(captain, 'track', false, 'غير متصل', 'لن تصلك عروض'),
      ]),
  );

  // 10. Quantity stepper.
  const stepperCard = card(
    themes,
    h2(
      themes,
      'عدّاد الكمية',
      'the Figma cart’s concave bridge · circles 32 drawn, 48 targets (dashed) · «+» at the start in RTL as in the file · at 1 the «−» becomes delete · Western digits, announced as «الكمية 2»',
    ) +
      row(themes, [
        cell(stepper(phone, 2), label(themes, 'default')),
        cell(stepper(phone, 2, { pressed: 'add' }), label(themes, 'pressed +')),
        cell(stepper(phone, 1, { min: true }), label(themes, 'at 1: − is delete')),
        cell(stepper(phone, 10, { max: true }), label(themes, 'at the maximum')),
        cell(stepper(phone, 2, { disabled: true }), label(themes, 'disabled')),
        cell(stepper(captain, 3), label(themes, 'captain')),
      ]),
  );

  // 11. Date and time pickers (Flutter: material_ui themed from the tokens).
  const days = (() => {
    // November 2026 starts on a Sunday; the week starts on Saturday (Syria).
    const lead = 1;
    const cells = [
      ...Array.from({ length: lead }, () => ''),
      ...Array.from({ length: 30 }, (_, i) => String(i + 1)),
    ];
    return cells
      .map((d) => {
        const selected = d === '27';
        const today = d === '23';
        return `<span style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; background: ${selected ? ACCENT.brand.rest : 'transparent'}; color: ${selected ? ACCENT.brand.on : d === '' ? 'transparent' : v(themes, 'color.on-surface')}; box-shadow: ${today ? `inset 0 0 0 1px ${v(themes, 'color.border-hover')}` : 'none'}; font-feature-settings: 'tnum'; font-weight: ${selected ? 700 : 400}">${d}</span>`;
      })
      .join('');
  })();
  const navBtn = (name: string, flip: boolean) =>
    `<span style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; background: ${v(themes, 'color.surface')}">${svg(icon(name), 20, v(themes, 'color.on-surface'), flip)}</span>`;
  const dialog = (title: string, inner: string, w: number) =>
    `<div style="display: flex; flex-direction: column; gap: ${v(themes, 'space.md')}; width: ${w}px; padding: ${v(themes, 'space.lg')}; border-radius: ${v(themes, 'radius.xl')}; background: ${v(themes, 'color.surface-raised')}; box-shadow: ${v(themes, 'elevation.high')}"><div style="${typeRole(phone, 'secondary')} color: ${muted}">${esc(title)}</div>${inner}<div style="display: flex; justify-content: flex-end; gap: 8px"><span style="padding: 10px 18px; border-radius: 999px; color: ${v(themes, 'button.ghost.label')}; font-weight: 500">إلغاء</span><span style="padding: 10px 22px; border-radius: 999px; background: ${v(themes, 'button.primary.background')}; color: ${v(themes, 'button.primary.label')}; font-weight: 500">تم</span></div></div>`;
  const calendar = (months: string) =>
    dialog(
      'اختر التاريخ',
      `<div style="display: flex; align-items: center; gap: 8px">${navBtn('back', true)}<span style="flex: 1; text-align: center; ${typeRole(phone, 'subtitle')} color: ${v(themes, 'color.on-surface')}">${months} <span style="font-feature-settings: 'tnum'">2026</span></span>${navBtn('back', false)}</div><div style="display: grid; grid-template-columns: repeat(7, 40px); gap: 4px; justify-content: center; ${typeRole(phone, 'secondary')}">${['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'].map((d) => `<span style="text-align: center; color: ${muted}">${d}</span>`).join('')}${days}</div>`,
      360,
    );
  const box = (text: string, on: boolean) =>
    `<span style="display: inline-flex; align-items: center; justify-content: center; width: 88px; height: 72px; border-radius: ${v(themes, 'radius.lg')}; background: ${on ? P.orange50 : v(themes, 'color.surface')}; box-shadow: ${on ? `inset 0 0 0 2px ${ACCENT.brand.rest}` : 'none'}; font-size: 40px; font-weight: 700; color: ${v(themes, 'color.on-surface')}; font-feature-settings: 'tnum'">${text}</span>`;
  const seg = (text: string, on: boolean) =>
    `<span style="display: inline-flex; align-items: center; justify-content: center; width: 52px; height: 34px; border-radius: ${v(themes, 'radius.md')}; background: ${on ? ACCENT.brand.rest : 'transparent'}; color: ${on ? ACCENT.brand.on : v(themes, 'color.on-surface')}; font-weight: 500">${text}</span>`;
  const clock = dialog(
    'اختر الوقت',
    `<div dir="ltr" style="display: flex; align-items: center; justify-content: center; gap: 8px">${box('07', true)}<span style="font-size: 36px; font-weight: 700">:</span>${box('30', false)}<span style="display: inline-flex; flex-direction: column; gap: 4px; padding: 4px; border-radius: ${v(themes, 'radius.md')}; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border-strong')}">${seg('ص', false)}${seg('م', true)}</span></div><div style="${typeRole(phone, 'caption')} color: ${muted}">لوحة الساعة الدائرية من material_ui متاحة أيضًا؛ نقترح الإدخال بالأرقام لأنه أسرع في مطبخ مزدحم.</div>`,
    340,
  );
  const pickers = card(
    themes,
    h2(
      themes,
      'التاريخ والوقت (Flutter)',
      'material_ui pickers inside core_ui, themed wholly from the tokens (§9.7) · dates dd/mm/yyyy, 12-hour «ص/م» (AP §4.7) · the week starts on Saturday · the field opens the picker; new calendar icon',
    ) +
      row(themes, [
        cell(
          field(phone, {
            label: 'تاريخ البداية',
            value: '27/11/2026',
            ltr: true,
            end: svg(icon('calendar'), 24, v(themes, 'color.on-surface')),
            width: 300,
          }),
          label(themes, 'date field'),
        ),
        cell(
          field(phone, {
            label: 'يفتح المطعم',
            value: '7:30 م',
            end: svg(icon('clock'), 24, v(themes, 'color.on-surface')),
            width: 300,
          }),
          label(themes, 'time field'),
        ),
      ]) +
      options(themes, [
        option(
          themes,
          'أسماء الأشهر: السريانية (الشام)',
          calendar('تشرين الثاني'),
          'كانون الثاني، شباط، آذار، نيسان، أيار، حزيران، تموز، آب، أيلول، تشرين الأول، تشرين الثاني، كانون الأول',
          true,
        ),
        option(
          themes,
          'أسماء الأشهر: المعرّبة',
          calendar('نوفمبر'),
          'يناير، فبراير، مارس… — what Flutter’s Arabic locale gives by default',
        ),
        option(themes, 'الوقت', clock, 'hour and minute typed, «ص/م» beside them; Western digits'),
      ]),
  );

  // 12. The three surfaces.
  const surface = (c: Ctx, name: string, note: string) =>
    `<div style="flex: 1; display: flex; flex-direction: column; gap: ${tk(c, 'space.md')}; padding: ${tk(c, 'space.lg')}; border-radius: ${tk(c, 'radius.lg')}; background: ${tk(c, 'color.surface')}; border: 1px solid ${v(themes, 'color.border')}"><div style="font-weight: 700">${esc(name)} ${label(themes, note)}</div>${field(c, { label: 'الاسم الكامل', value: 'محمد الأحمد', width: c.surface === 'panel' ? 260 : 320 })}${field(c, { state: 'invalid', label: 'رقم الموبايل', error: 'الرقم ناقص', width: c.surface === 'panel' ? 260 : 320 }, phoneInner(c))}<div style="display: flex; align-items: center; flex-wrap: wrap">${choice(c, 'checkbox', 'on', 'default', 'تذكّرني')}${toggle(c, 'track', true, 'default')}</div></div>`;
  const surfaces = card(
    themes,
    h2(
      themes,
      'الأسطح الثلاثة',
      'phone 50 · captain 50 with its larger type and 7:1 text · panel and portal compact 40 (web only)',
    ) +
      `<div style="display: flex; gap: ${v(themes, 'space.lg')}">${[
        surface(phone, 'تطبيق الزبون والمطعم', 'phone · 50'),
        surface(captain, 'تطبيق الكابتن', 'captain · 50'),
        surface(panel, 'لوحة الإدارة وبوابة المطعم', 'panel · 40'),
      ].join('')}</div>`,
  );

  // 13. 130% text.
  const big: Ctx = { ...phone, scale: 1.3 };
  const large = card(
    themes,
    h2(
      themes,
      'النص المكبّر 130٪',
      'the field grows in height, the label and the error wrap, nothing clips',
    ) +
      row(themes, [
        field(big, {
          label: 'الاسم الكامل',
          value: 'محمد الأحمد',
          hint: 'كما يظهر للمطعم والكابتن',
          width: 340,
        }),
        field(
          big,
          {
            state: 'invalid',
            label: 'رقم الموبايل',
            error: 'رقم سوري يبدأ بـ 9 ويتكون من 9 أرقام',
            width: 340,
          },
          phoneInner(big),
        ),
        `<div style="display: flex; flex-direction: column">${choice(big, 'checkbox', 'on', 'default', 'جبنة إضافية')}${stepper(big, 2)}</div>`,
      ]),
  );

  // 14. The new icons.
  const newIcons = card(
    themes,
    h2(
      themes,
      'أيقونتان جديدتان',
      'R8 grid: 24, stroke 2, round caps, inside 2..22 · neither mirrors',
    ) +
      row(
        themes,
        Object.entries(NEW_ICONS).map(([name, paths]) =>
          cell(
            `<div style="display: flex; gap: 16px; align-items: center; color: ${v(themes, 'color.on-surface')}">${svg(paths, 16)}${svg(paths, 24)}${svg(paths, 32)}</div>`,
            label(themes, name),
          ),
        ),
      ),
  );

  const questions = card(
    themes,
    h2(themes, 'ما اعتمده المالك', '2026-11-23 · the picked options are framed in blue') +
      `<ol style="margin: 0; padding-inline-start: 24px; display: flex; flex-direction: column; gap: ${v(themes, 'space.xs')}; line-height: 1.7">
<li>لون التركيز والاختيار: البرتقالي الأساسي #FF6E31، باستثناء R4 موسّع ليشمل حدود عناصر التحكم.</li>
<li>حقل الهاتف: حقل واحد يُقرأ كما يُكتب الرقم (+963 على اليسار ثم الرقم).</li>
<li>خانات الرمز: دوائر تمتلئ وتتلاحم لحظة القبول.</li>
<li>المفتاح: المسار الكلاسيكي 52×32.</li>
<li>أسماء الأشهر: السريانية (تشرين الثاني).</li>
<li>القائمة المنسدلة في الهاتف: قائمة تحت الحقل الآن، واللوح السفلي بعد D.10.</li>
<li>الحقول كبسولات، والنص الطويل بزاوية 15، و«(اختياري)» بدل نجمة الإلزام، وأيقونتا chevron-down وcalendar، و«−» تصير حذفًا عند الكمية 1.</li>
</ol>`,
  );

  const body = [
    heading(
      themes,
      'الإدخال والنماذج — الدفعة الثانية (مُستبدَلة)',
      'Superseded (architecture §9.9 step 4): the record of the approval only; the form components live in the Design System (ui-web) and core_ui (Flutter), slice D.8. Inputs and forms — batch 2 (architecture §9.9 step 1, slice D.8). Every control in its states, phone 50 and panel 40, RTL, the three surfaces, 130% text; real tokens, options side by side where you decide. Sample text is review copy only.',
    ),
    matrix(phone, 'الحقل — الحجم العادي 50', 'comfortable · phone and captain'),
    matrix(panel, 'الحقل — الحجم المضغوط 40', 'compact · panel and portal'),
    wrapper,
    longText,
    search,
    accentCard,
    phoneCard,
    codeCard,
    select,
    ticks,
    switches,
    stepperCard,
    pickers,
    surfaces,
    large,
    newIcons,
    questions,
  ].join('\n');
  return page(
    themes,
    config,
    { file: 'Forms.dc.html', title: 'Inputs and forms — batch 2', w: W, h: 7000 },
    body,
  );
}
