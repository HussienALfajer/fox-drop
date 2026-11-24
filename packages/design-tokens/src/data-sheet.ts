// Draws «Data display — batch 3» for the owner's review (architecture §9.9
// step 1), the fifth artboard of the «Component proposals» canvas: every D.9
// component in its states, phone, captain and panel, RTL and 130% text, from
// the real tokens. Where the owner has a real choice the sheet draws the
// options side by side; a colour that is not a token yet comes from a value
// marked "proposed", with its contrast measured on the sheet.
import { contrast } from './color.ts';
import { cssValue } from './generate.ts';
import { card, esc, heading, label, page, v, type Board, type GuideConfig } from './guide.ts';
import type { Icon } from './icons.ts';
import type { Theme, Token } from './resolve.ts';

type Themes = Record<Theme, Map<string, Token>>;

const W = 1680;

/** Proposed tints behind status text (new semantic tokens `*-subtle`), and two primitives. */
const PROPOSED = {
  successSubtle: '#E3F3EA',
  warningSubtle: '#FBEFD5',
  dangerSubtle: '#FBE9E9',
  infoSubtle: '#EEF4FC',
  primarySubtle: '#FFEDE3',
  neutralSubtle: '#EFE8DA',
  neutralText: '#4D473D',
};

const ratio = (a: string, b: string) => contrast(a, b).toFixed(1);

interface Ctx {
  themes: Themes;
  theme: Theme;
  surface: 'phone' | 'panel' | 'captain';
  scale: number;
  icon: (name: string) => Icon['paths'];
}

const tk = (c: Ctx, name: string) => cssValue(c.themes[c.theme].get(name)!);
const px = (c: Ctx, name: string) => Number.parseFloat(tk(c, name));
const size = (c: Ctx, role: string) =>
  Math.round(px(c, `type.${c.surface}.${role}.size`) * c.scale);
const type = (c: Ctx, role: string, weight?: number) =>
  `font-size: ${size(c, role)}px; line-height: 1.5; font-weight: ${weight ?? tk(c, `type.${c.surface}.${role}.weight`)};`;
const TNUM = "font-feature-settings: 'tnum';";

function svg(paths: string[], px: number, colour = 'currentColor', flip = false): string {
  const transform = flip ? '; transform: scaleX(-1)' : '';
  return `<svg aria-hidden="true" width="${px}" height="${px}" viewBox="0 0 24 24" fill="none" stroke="${colour}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="flex: none${transform}">${paths.map((d) => `<path d="${d}"/>`).join('')}</svg>`;
}

const cell = (inner: string, caption = '') =>
  `<div style="display: flex; flex-direction: column; align-items: flex-start; justify-content: flex-end; gap: 8px">${inner}${caption}</div>`;
const h2 = (themes: Themes, text: string, note = '') =>
  `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">${esc(text)} ${note ? label(themes, note) : ''}</h2>`;
const row = (themes: Themes, items: string[], align = 'flex-end') =>
  `<div style="display: flex; flex-wrap: wrap; align-items: ${align}; gap: ${v(themes, 'space.xl')}">${items.join('')}</div>`;
const option = (themes: Themes, title: string, inner: string, note: string, ours = false) =>
  `<div style="flex: 1; min-width: 0; display: flex; flex-direction: column; gap: ${v(themes, 'space.sm')}; padding: ${v(themes, 'space.lg')}; border-radius: ${v(themes, 'radius.lg')}; background: ${v(themes, 'color.surface')}; ${ours ? `box-shadow: inset 0 0 0 2px ${v(themes, 'color.accent')}` : ''}"><div style="font-weight: 700">${esc(title)}${ours ? ` <span style="font-weight: 500; color: ${v(themes, 'color.accent')}">· توصيتنا</span>` : ''}</div>${inner}<div>${label(themes, note)}</div></div>`;
const options = (themes: Themes, items: string[]) =>
  `<div style="display: flex; gap: ${v(themes, 'space.lg')}; align-items: stretch">${items.join('')}</div>`;

// ---------- money ----------

interface MoneyOpts {
  role?: string;
  weight?: number;
  colour?: string;
  sign?: '−' | '+';
  /** How the ₺ is drawn: the bundled subset glyph, the platform's fallback, or «TL». */
  lira?: 'subset' | 'system' | 'code';
}

/**
 * An amount as the apps show it (AP §4.7): Western tabular digits, then the
 * symbol, isolated as one run so a neighbouring Latin run or a sign never
 * moves it. In RTL the symbol sits to the amount's left, as the Figma file draws.
 */
function money(c: Ctx, amount: string, symbol: string, o: MoneyOpts = {}): string {
  const lira = o.lira ?? 'subset';
  let mark = esc(symbol);
  if (symbol === '₺' && lira === 'code') mark = 'TL';
  const font =
    symbol === '₺' && lira === 'subset'
      ? `font-family: 'Noto Sans', ${tk(c, 'font.family.sans').replaceAll('"', "'")};`
      : symbol === '₺' && lira === 'system'
        ? 'font-family: system-ui, sans-serif;'
        : '';
  const symbolSpan = `<span style="${font} font-weight: ${o.weight ?? 500}">${mark}</span>`;
  return `<bdi dir="rtl" style="unicode-bidi: isolate; white-space: nowrap; ${type(c, o.role ?? 'body', o.weight)} ${TNUM} color: ${o.colour ?? tk(c, 'color.on-surface')}">${o.sign ?? ''}${esc(amount)} ${symbolSpan}</bdi>`;
}

// ---------- status ----------

type Tone = 'warning' | 'info' | 'success' | 'primary' | 'danger' | 'neutral';

interface Status {
  key: string;
  panel: string;
  customer: string;
  tone: Tone;
  icon: string;
}

/** AP §8.1: the panel's label, what the customer sees, and the proposed tone and icon. */
const STATUSES: Status[] = [
  {
    key: 'placed',
    panel: 'بانتظار المطعم',
    customer: 'بانتظار تأكيد المطعم',
    tone: 'warning',
    icon: 'clock',
  },
  {
    key: 'accepted',
    panel: 'قيد التحضير',
    customer: 'المطعم يحضّر طلبك',
    tone: 'info',
    icon: 'restaurant',
  },
  { key: 'ready', panel: 'جاهز', customer: 'طلبك جاهز', tone: 'success', icon: 'plate' },
  {
    key: 'picked_up',
    panel: 'مع الكابتن',
    customer: 'في الطريق إليك',
    tone: 'primary',
    icon: 'motorcycle',
  },
  {
    key: 'arrived',
    panel: 'الكابتن وصل',
    customer: 'الكابتن عند الباب',
    tone: 'primary',
    icon: 'house',
  },
  {
    key: 'delivered',
    panel: 'تم التسليم',
    customer: 'تم التسليم',
    tone: 'success',
    icon: 'success',
  },
  { key: 'rejected', panel: 'مرفوض', customer: 'رفض المطعم الطلب', tone: 'danger', icon: 'close' },
  { key: 'cancelled', panel: 'ملغى', customer: 'أُلغي الطلب', tone: 'neutral', icon: 'close' },
  {
    key: 'failed',
    panel: 'فشل التسليم',
    customer: 'تعذّر التسليم',
    tone: 'danger',
    icon: 'warning',
  },
];

function tone(c: Ctx, t: Tone): { strong: string; on: string; subtle: string } {
  switch (t) {
    case 'warning':
      return {
        strong: tk(c, 'color.warning'),
        on: tk(c, 'color.on-warning'),
        subtle: PROPOSED.warningSubtle,
      };
    case 'info':
      return {
        strong: tk(c, 'color.info'),
        on: tk(c, 'color.on-info'),
        subtle: PROPOSED.infoSubtle,
      };
    case 'success':
      return {
        strong: tk(c, 'color.success'),
        on: tk(c, 'color.on-success'),
        subtle: PROPOSED.successSubtle,
      };
    case 'primary':
      return {
        strong: tk(c, 'color.primary'),
        on: tk(c, 'color.on-primary'),
        subtle: PROPOSED.primarySubtle,
      };
    case 'danger':
      return {
        strong: tk(c, 'color.danger'),
        on: tk(c, 'color.on-danger'),
        subtle: PROPOSED.dangerSubtle,
      };
    case 'neutral':
      return {
        strong: PROPOSED.neutralText,
        on: tk(c, 'color.on-primary'),
        subtle: PROPOSED.neutralSubtle,
      };
  }
}

type ChipStyle = 'tint' | 'solid' | 'dot';

function chip(c: Ctx, s: Status, style: ChipStyle, text = s.panel): string {
  const t = tone(c, s.tone);
  const h = c.surface === 'panel' ? 24 : c.surface === 'captain' ? 36 : 30;
  const icon = c.surface === 'panel' ? 14 : c.surface === 'captain' ? 20 : 16;
  const role =
    c.surface === 'captain' ? 'secondary' : c.surface === 'panel' ? 'caption' : 'secondary';
  const base = `display: inline-flex; align-items: center; gap: 6px; height: ${h}px; padding-inline: ${c.surface === 'panel' ? 8 : 12}px; border-radius: 999px; white-space: nowrap; ${type(c, role, 500)}`;
  if (style === 'solid')
    return `<span style="${base} background: ${t.strong}; color: ${t.on}">${svg(c.icon(s.icon), icon, t.on, s.icon === 'motorcycle')}${esc(text)}</span>`;
  if (style === 'dot')
    return `<span style="${base} box-shadow: inset 0 0 0 1px ${tk(c, 'color.border')}; color: ${tk(c, 'color.on-surface')}"><span style="width: 8px; height: 8px; border-radius: 50%; background: ${t.strong}"></span>${esc(text)}</span>`;
  return `<span style="${base} background: ${t.subtle}; color: ${t.strong === tk(c, 'color.primary') ? tk(c, 'color.primary-pressed') : t.strong}">${svg(c.icon(s.icon), icon, 'currentColor', s.icon === 'motorcycle')}${esc(text)}</span>`;
}

const status = (key: string) => STATUSES.find((s) => s.key === key)!;

// ---------- small parts ----------

function badge(c: Ctx, text: string, kind: 'count' | 'dot' = 'count', colour?: string): string {
  const bg = colour ?? tk(c, 'color.danger');
  if (kind === 'dot')
    return `<span style="position: absolute; top: 2px; inset-inline-end: 2px; width: 10px; height: 10px; border-radius: 50%; background: ${bg}; box-shadow: 0 0 0 2px ${tk(c, 'color.surface-raised')}"></span>`;
  return `<span dir="ltr" style="position: absolute; top: -4px; inset-inline-end: -6px; min-width: 20px; height: 20px; padding-inline: 5px; box-sizing: border-box; display: inline-flex; align-items: center; justify-content: center; border-radius: 999px; background: ${bg}; color: ${tk(c, 'color.on-danger')}; font-size: 12px; font-weight: 700; ${TNUM} box-shadow: 0 0 0 2px ${tk(c, 'color.surface-raised')}">${esc(text)}</span>`;
}

function iconWithBadge(c: Ctx, name: string, b: string): string {
  return `<span style="position: relative; display: inline-flex; align-items: center; justify-content: center; width: 48px; height: 48px; border-radius: 50%; background: ${tk(c, 'color.surface-raised')}">${svg(c.icon(name), 24, tk(c, 'color.on-surface'))}${b}</span>`;
}

function button(
  c: Ctx,
  text: string,
  kind: 'primary' | 'secondary' | 'danger' = 'primary',
  width = '',
): string {
  const h = c.surface === 'panel' ? 40 : 50;
  const bg = tk(c, `button.${kind}.background`);
  const fg = tk(c, `button.${kind}.label`);
  return `<span style="display: inline-flex; align-items: center; justify-content: center; height: ${h}px; padding-inline: 24px; ${width} box-sizing: border-box; border-radius: 999px; background: ${bg}; color: ${fg}; ${type(c, 'body', 500)}">${esc(text)}</span>`;
}

/** A stand-in for a photo on the sheet: never drawn in the product (brand expression §5). */
function photo(c: Ctx, w: number, h: number, text: string, radius = tk(c, 'radius.md')): string {
  return `<span style="display: inline-flex; flex-direction: column; align-items: center; justify-content: center; gap: 4px; width: ${w}px; height: ${h}px; flex: none; border-radius: ${radius}; background: linear-gradient(135deg, #F6C9A8, #E89B6C); color: #7A3A12; font-size: 12px">${svg(c.icon('image'), 24, '#7A3A12')}${esc(text)}</span>`;
}

type Shell = 'outline' | 'soft' | 'offset';

function shell(c: Ctx, inner: string, s: Shell, extra = ''): string {
  const shadow =
    s === 'outline'
      ? `inset 0 0 0 1px ${tk(c, 'color.border')}`
      : s === 'soft'
        ? tk(c, 'elevation.medium')
        : tk(c, 'elevation.offset');
  return `<div style="display: flex; flex-direction: column; gap: ${tk(c, 'space.sm')}; padding: ${c.surface === 'panel' ? tk(c, 'space.sm') : tk(c, 'space.md')}; border-radius: ${tk(c, 'radius.lg')}; background: ${tk(c, 'color.surface-raised')}; box-shadow: ${shadow}; ${extra}">${inner}</div>`;
}

/** The logo's drop as a frame (brand expression §2: empty states may use it). */
const DROP = 'M12 23s9-8.4 9-14.5a9 9 0 0 0-18 0C3 14.6 12 23 12 23Z';
function dropFrame(c: Ctx, iconName: string, px: number): string {
  return `<span style="position: relative; display: inline-flex; width: ${px}px; height: ${px}px"><svg aria-hidden="true" width="${px}" height="${px}" viewBox="0 0 24 24"><path d="${DROP}" fill="${PROPOSED.primarySubtle}" stroke="${tk(c, 'color.primary')}" stroke-width="0.6"/></svg><span style="position: absolute; inset: 0 0 ${px * 0.25}px 0; display: flex; align-items: center; justify-content: center">${svg(c.icon(iconName), px * 0.36, tk(c, 'color.primary-pressed'))}</span></span>`;
}

const skel = (w: number | string, h: number, r = '6px', tone = '#EFE6D6') =>
  `<span style="display: block; width: ${typeof w === 'number' ? `${w}px` : w}; height: ${h}px; border-radius: ${r}; background: ${tone}"></span>`;

// ---------- the sheet ----------

export function dataSheet(themes: Themes, config: GuideConfig, icons: Icon[]): Board {
  const icon = (name: string) => icons.find((i) => i.name === name)!.paths;
  const phone: Ctx = { themes, theme: 'light', surface: 'phone', scale: 1, icon };
  const panel: Ctx = { ...phone, surface: 'panel' };
  const captain: Ctx = { ...phone, theme: 'captainLight', surface: 'captain' };
  const muted = v(themes, 'color.on-surface-muted');
  const ink = v(themes, 'color.on-surface');
  const forward = (c: Ctx, px = 20) => svg(icon('back'), px, tk(c, 'color.on-surface-muted'));

  // 1. Money.
  const sizes = row(themes, [
    cell(money(phone, '450', '₺', { role: 'secondary' }), label(themes, 'secondary 14 · in a row')),
    cell(money(phone, '450', '₺'), label(themes, 'body 16 · a price')),
    cell(
      money(phone, '10.50', '$', { role: 'subtitle', weight: 700 }),
      label(themes, 'subtitle 18 bold · a line total'),
    ),
    cell(money(phone, '470', '₺', { role: 'number' }), label(themes, 'number 30 · the total')),
    cell(
      money(captain, '1,250', '₺', { role: 'number' }),
      label(themes, 'captain number 36 · custody'),
    ),
    cell(
      money(panel, '12,480.50', '$', { role: 'body' }),
      label(themes, 'panel 14 · a table cell'),
    ),
  ]);
  const signs = row(themes, [
    cell(
      money(phone, '25', '₺', { sign: '−', colour: v(themes, 'color.success') }),
      label(themes, 'discount: − reads first, so it sits at the right in RTL'),
    ),
    cell(
      money(phone, '200', '₺', { sign: '+', colour: v(themes, 'color.success') }),
      label(themes, 'a gain: + (panel dashboard)'),
    ),
    cell(
      money(phone, '300', '₺', { sign: '−', colour: v(themes, 'color.danger') }),
      label(themes, 'owed: − and danger red'),
    ),
    cell(
      `<span style="${type(phone, 'body', 500)} color: ${v(themes, 'color.success')}">مجاني</span>`,
      label(themes, 'a zero fee: the word, not «0 ₺»'),
    ),
    cell(
      `<span style="${type(phone, 'body')}">ستدفع حوالي ${money(phone, '11.50', '$')} أو ${money(phone, '3,300,000', 'ل.س')}</span>`,
      label(themes, 'bidi: each amount is one isolated run inside Arabic text'),
    ),
  ]);
  const liraOptions = options(themes, [
    option(
      themes,
      'أ — حرف ₺ مضمَّن مع الخط',
      row(themes, [money(phone, '450', '₺', { role: 'number' }), money(phone, '470', '₺')]),
      'a 1 KB subset of Noto Sans holding U+20BA only, bundled beside CoFo on web and Flutter: the same ₺ on every device',
      true,
    ),
    option(
      themes,
      'ب — خط النظام',
      row(themes, [
        money(phone, '450', '₺', { role: 'number', lira: 'system' }),
        money(phone, '470', '₺', { lira: 'system' }),
      ]),
      'no file to ship; the ₺ comes from Roboto, SF or Segoe and differs per device in weight and width',
    ),
    option(
      themes,
      'ج — «TL» كما في Figma',
      row(themes, [
        money(phone, '450', '₺', { role: 'number', lira: 'code' }),
        money(phone, '470', '₺', { lira: 'code' }),
      ]),
      'no glyph needed, but breaks AP §4.7 («410 ₺») and every string the server already sends',
    ),
  ]);
  const grouping = options(themes, [
    option(
      themes,
      'فاصل الآلاف: فاصلة غربية',
      row(themes, [money(phone, '3,300,000', 'ل.س'), money(phone, '1,250', '₺')]),
      'readable for SYP’s large amounts; Western digits and comma as on the receipts',
      true,
    ),
    option(
      themes,
      'بلا فاصل',
      row(themes, [money(phone, '3300000', 'ل.س'), money(phone, '1250', '₺')]),
      'what core_l10n and the server’s pushes print today',
    ),
  ]);
  const moneyCard = card(
    themes,
    h2(
      themes,
      'المبلغ',
      'integer minor units in, Western tabular digits out (AP §4.7) · a whole amount drops its fraction («450 ₺», «10.50 $») · the amount and symbol are one isolated run',
    ) +
      sizes +
      signs +
      `<div style="font-weight: 700">رمز الليرة التركية ₺ — ليس في CoFo</div>` +
      liraOptions +
      grouping,
  );

  // 2. Status chip.
  const chipRow = (c: Ctx, style: ChipStyle, customer = false) =>
    `<div style="display: flex; flex-wrap: wrap; gap: 8px">${STATUSES.map((s) => chip(c, s, style, customer ? s.customer : s.panel)).join('')}</div>`;
  const toneRatios = (['warning', 'info', 'success', 'primary', 'danger', 'neutral'] as Tone[])
    .map((t) => {
      const x = tone(phone, t);
      const fg = t === 'primary' ? v(themes, 'color.primary-pressed') : x.strong;
      return `${t} ${ratio(fg, x.subtle)}:1`;
    })
    .join(' · ');
  const chipCard = card(
    themes,
    h2(
      themes,
      'شارة حالة الطلب',
      'the nine states of AP §8.1 · an icon and a word with every colour, never colour alone · the caller passes the label of its app',
    ) +
      options(themes, [
        option(
          themes,
          'أ — خلفية فاتحة ونص داكن',
          chipRow(phone, 'tint'),
          `proposed *-subtle tints · text contrast ${toneRatios}`,
          true,
        ),
        option(
          themes,
          'ب — مصمتة',
          chipRow(phone, 'solid'),
          'strongest, but a board of solid chips shouts; orange under the R4 exception',
        ),
        option(
          themes,
          'ج — نقطة ملوّنة',
          chipRow(phone, 'dot'),
          'calmest; the dot alone carries the colour, so the word must always show',
        ),
      ]) +
      row(themes, [
        cell(
          chipRow(phone, 'tint', true),
          label(themes, 'customer wording (AP §8.1 column 3), phone 30'),
        ),
      ]) +
      row(themes, [
        cell(chipRow(panel, 'tint'), label(themes, 'panel 24, compact')),
        cell(
          `<div style="display: flex; gap: 8px">${chip(captain, status('picked_up'), 'tint')}${chip(captain, status('arrived'), 'tint')}</div>`,
          label(themes, 'captain 36'),
        ),
      ]),
  );

  // 3. Count badge.
  const badgeCard = card(
    themes,
    h2(
      themes,
      'شارة العدد',
      'red dot or count on an icon, 99+ at most · a count in a tab · announced as «3 إشعارات»',
    ) +
      row(themes, [
        cell(
          iconWithBadge(phone, 'bell', badge(phone, '', 'dot')),
          label(themes, 'dot: something new'),
        ),
        cell(iconWithBadge(phone, 'bell', badge(phone, '3')), label(themes, '3')),
        cell(
          iconWithBadge(phone, 'cart', badge(phone, '12', 'count', v(themes, 'color.primary'))),
          label(themes, 'cart: orange (R4 exception)'),
        ),
        cell(iconWithBadge(phone, 'orders', badge(phone, '99+')), label(themes, '99+')),
        cell(
          `<div style="display: flex; gap: 4px; padding: 4px; border-radius: 999px; background: ${v(themes, 'color.surface-raised')}">${[
            ['جديدة', '4', true, '2'],
            ['قيد التحضير', '7', false, ''],
            ['جاهزة', '1', false, ''],
            ['مع الكابتن', '3', false, ''],
          ]
            .map(
              ([t, n, on, late]) =>
                `<span style="display: inline-flex; align-items: center; gap: 6px; height: 40px; padding-inline: 14px; border-radius: 999px; background: ${on ? v(themes, 'color.accent') : 'transparent'}; color: ${on ? v(themes, 'color.on-accent') : ink}; font-weight: 500">${t}<span style="min-width: 22px; height: 22px; padding-inline: 6px; box-sizing: border-box; display: inline-flex; align-items: center; justify-content: center; border-radius: 999px; background: ${on ? v(themes, 'color.on-accent') : PROPOSED.infoSubtle}; color: ${v(themes, 'color.accent')}; font-size: 12px; font-weight: 700; ${TNUM}">${n}</span>${late ? `<span style="display: inline-flex; align-items: center; height: 22px; padding-inline: 6px; border-radius: 999px; background: ${v(themes, 'color.danger')}; color: ${v(themes, 'color.on-danger')}; font-size: 12px; font-weight: 700; ${TNUM}">${late} متأخرة</span>` : ''}</span>`,
            )
            .join('')}</div>`,
          label(themes, 'the restaurant’s column tabs: count, and how many are late (RA §8.2)'),
        ),
      ]),
  );

  // 4. Card shell.
  const sampleCard = (c: Ctx, s: Shell, state = '') => {
    const hover =
      state === 'hover'
        ? `background: ${tk(c, 'color.surface-raised-hover')};`
        : state === 'pressed'
          ? `background: ${tk(c, 'color.surface-raised-pressed')};`
          : '';
    const focus =
      state === 'focus'
        ? `outline: 2px solid ${tk(c, 'color.focus-ring')}; outline-offset: 2px;`
        : '';
    return shell(
      c,
      `<div style="${type(c, 'subtitle')}">عنوان البطاقة</div><div style="${type(c, 'secondary')} color: ${muted}">سطر ثانوي يشرح المحتوى</div>`,
      s,
      `width: 220px; ${hover} ${focus}`,
    );
  };
  const shellCard = card(
    themes,
    h2(
      themes,
      'البطاقة',
      'the container of every card below · radius 15 · raised white on the ground · a tappable card takes the R10 states',
    ) +
      options(themes, [
        option(
          themes,
          'أ — حدّ رفيع',
          sampleCard(phone, 'outline'),
          'border token, flat: dense lists, the restaurant, captain and panel',
        ),
        option(
          themes,
          'ب — ظل ناعم',
          sampleCard(phone, 'soft'),
          'elevation.medium: floats the card; heavy in long lists',
        ),
        option(
          themes,
          'ج — الظل المُزاح (Figma)',
          sampleCard(phone, 'offset'),
          'the file’s flat offset shadow: the customer app’s language (R7)',
        ),
      ]) +
      `<div>${label(themes, 'our proposal: customer cards C, every other surface A')}</div>` +
      row(themes, [
        cell(sampleCard(phone, 'outline', 'hover'), label(themes, 'hover')),
        cell(sampleCard(phone, 'outline', 'pressed'), label(themes, 'pressed')),
        cell(sampleCard(phone, 'outline', 'focus'), label(themes, 'focus')),
      ]),
  );

  // 5. List row.
  const listRow = (
    c: Ctx,
    o: {
      lead?: string;
      title: string;
      sub?: string;
      end?: string;
      state?: string;
      danger?: boolean;
      disabled?: boolean;
    },
  ) => {
    const h = c.surface === 'panel' ? 40 : 56;
    const bg =
      o.state === 'hover'
        ? tk(c, 'color.surface-raised-hover')
        : o.state === 'pressed'
          ? tk(c, 'color.surface-raised-pressed')
          : tk(c, 'color.surface-raised');
    const colour = o.disabled
      ? tk(c, 'color.on-disabled')
      : o.danger
        ? tk(c, 'color.danger')
        : tk(c, 'color.on-surface');
    const focus =
      o.state === 'focus' ? `box-shadow: inset 0 0 0 2px ${tk(c, 'color.focus-ring')};` : '';
    const lead = o.lead
      ? `<span style="display: inline-flex; align-items: center; justify-content: center; width: ${c.surface === 'panel' ? 24 : 40}px; height: ${c.surface === 'panel' ? 24 : 40}px; border-radius: 50%; background: ${o.danger ? PROPOSED.dangerSubtle : PROPOSED.infoSubtle}; flex: none">${svg(icon(o.lead), c.surface === 'panel' ? 16 : 20, colour)}</span>`
      : '';
    return `<div style="display: flex; align-items: center; gap: ${tk(c, 'space.sm')}; min-height: ${h}px; padding: 8px ${tk(c, 'space.md')}; box-sizing: border-box; width: 380px; background: ${bg}; ${focus} color: ${colour}">${lead}<div style="flex: 1; min-width: 0; display: flex; flex-direction: column"><span style="${type(c, 'body', 500)}">${esc(o.title)}</span>${o.sub ? `<span style="${type(c, 'secondary')} color: ${o.disabled ? colour : muted}">${esc(o.sub)}</span>` : ''}</div>${o.end ?? ''}</div>`;
  };
  const divider = `<div style="height: 1px; background: ${v(themes, 'color.border')}; margin-inline-start: 68px"></div>`;
  const listCard = card(
    themes,
    h2(
      themes,
      'سطر القائمة',
      'lead icon or avatar, title, secondary line, an end slot (value, chevron, switch, chip) · 56 phone, 40 panel · the chevron mirrors in RTL',
    ) +
      row(
        themes,
        [
          cell(
            shell(
              phone,
              [
                listRow(phone, {
                  lead: 'house',
                  title: 'المنزل',
                  sub: 'أعزاز — دوار الكفين، بناء 4',
                  end: forward(phone),
                }),
                divider,
                listRow(phone, {
                  lead: 'wallet',
                  title: 'رصيد العهدة',
                  end: money(phone, '1,250', '₺', { weight: 700 }),
                }),
                divider,
                listRow(phone, {
                  lead: 'receipt',
                  title: 'طلب #10423',
                  sub: 'اليوم 9:45 م',
                  end: chip(phone, status('delivered'), 'tint'),
                }),
                divider,
                listRow(phone, { lead: 'delete', title: 'حذف العنوان', danger: true }),
                divider,
                listRow(phone, {
                  lead: 'gift',
                  title: 'أكوادي',
                  sub: 'لا أكواد الآن',
                  disabled: true,
                }),
              ].join(''),
              'outline',
              'padding: 0; overflow: hidden; gap: 0',
            ),
            label(themes, 'phone: navigation, value, chip, danger, disabled'),
          ),
          cell(
            `<div style="display: flex; flex-direction: column; gap: 8px">${listRow(phone, { lead: 'house', title: 'تمرير المؤشر', end: forward(phone), state: 'hover' })}${listRow(phone, { lead: 'house', title: 'مضغوط', end: forward(phone), state: 'pressed' })}${listRow(phone, { lead: 'house', title: 'تركيز', end: forward(phone), state: 'focus' })}</div>`,
            label(themes, 'R10 states'),
          ),
          cell(
            shell(
              panel,
              [
                listRow(panel, {
                  lead: 'restaurant',
                  title: 'برجر كبصو',
                  end: chip(panel, status('accepted'), 'tint'),
                }),
                listRow(panel, {
                  lead: 'restaurant',
                  title: 'شاورما الشام',
                  end: chip(panel, status('ready'), 'tint'),
                }),
              ].join(''),
              'outline',
              'padding: 0; overflow: hidden; gap: 0',
            ),
            label(themes, 'panel 40'),
          ),
        ],
        'flex-start',
      ),
  );

  // 6. Timer and countdown.
  const timer = (c: Ctx, text: string, t: 'calm' | 'soon' | 'late', iconName = 'clock') => {
    const colour =
      t === 'late'
        ? tk(c, 'color.danger')
        : t === 'soon'
          ? tk(c, 'color.warning')
          : tk(c, 'color.on-surface');
    const bg =
      t === 'late'
        ? PROPOSED.dangerSubtle
        : t === 'soon'
          ? PROPOSED.warningSubtle
          : PROPOSED.infoSubtle;
    const role = c.surface === 'captain' ? 'title' : c.surface === 'panel' ? 'body' : 'subtitle';
    return `<span style="display: inline-flex; align-items: center; gap: 6px; height: ${c.surface === 'captain' ? 44 : c.surface === 'panel' ? 28 : 36}px; padding-inline: 12px; border-radius: 999px; background: ${bg}; color: ${colour}; ${type(c, role, 700)} ${TNUM}">${svg(icon(iconName), c.surface === 'panel' ? 16 : 20, colour)}<bdi>${esc(text)}</bdi></span>`;
  };
  const ring = (c: Ctx, left: number, total: number, px: number) => {
    const r = 15.9155;
    const share = (left / total) * 100;
    const colour = left <= 10 ? tk(c, 'color.danger') : tk(c, 'color.primary');
    return `<span style="position: relative; display: inline-flex; width: ${px}px; height: ${px}px"><svg width="${px}" height="${px}" viewBox="0 0 36 36" aria-hidden="true" style="transform: scaleX(-1) rotate(-90deg)"><circle cx="18" cy="18" r="${r}" fill="none" stroke="${PROPOSED.neutralSubtle}" stroke-width="3"/><circle cx="18" cy="18" r="${r}" fill="none" stroke="${colour}" stroke-width="3" stroke-linecap="round" stroke-dasharray="${share} 100"/></svg><span style="position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; font-size: ${px * 0.3}px; font-weight: 700; color: ${colour}; ${TNUM}">${left}</span></span>`;
  };
  const timerCard = card(
    themes,
    h2(
      themes,
      'المؤقت والعدّ التنازلي',
      'mm:ss under 10 minutes, «12 د» above (AP §4.7) · calm, soon (warning) and late (danger, counting up) · digits tabular so they never jitter · announced every minute, not every second',
    ) +
      row(themes, [
        cell(timer(phone, '4:32', 'calm'), label(themes, 'auto-cancel countdown')),
        cell(timer(phone, '0:48', 'soon'), label(themes, 'under 1 minute: warning')),
        cell(timer(phone, '18 د', 'calm'), label(themes, 'prep time left')),
        cell(timer(phone, 'متأخر 3 د', 'late'), label(themes, 'late: counts up, red')),
        cell(timer(phone, 'ينتظر منذ 4 د', 'soon', 'motorcycle'), label(themes, 'captain waiting')),
        cell(timer(panel, '12:05', 'calm'), label(themes, 'panel 28')),
        cell(timer(captain, '2:10', 'calm'), label(themes, 'captain 44')),
      ]) +
      row(themes, [
        cell(
          `<div style="display: flex; gap: 24px; align-items: center">${ring(captain, 38, 45, 96)}${ring(captain, 8, 45, 96)}</div>`,
          label(
            themes,
            'the captain’s offer: a countdown ring of 45 s (brand expression §3), red in the last 10 s; reduced motion: the number only',
          ),
        ),
      ]),
  );

  // 7. Order card.
  const rOrder = (o: {
    state: string;
    number: string;
    since: string;
    items: string;
    captain: string;
    t: string;
    tt: 'calm' | 'soon' | 'late';
    action: string;
    badge?: string;
  }) => {
    const late = o.tt === 'late';
    const top = `<div style="display: flex; align-items: center; gap: 8px"><span style="${type(phone, 'title')} ${TNUM}">#${o.number}</span><span style="${type(phone, 'secondary')} color: ${muted}">${esc(o.since)}</span><span style="flex: 1"></span>${timer(phone, o.t, o.tt)}</div>`;
    const lines = `<div style="${type(phone, 'body')}">${esc(o.items)}</div><div style="display: flex; align-items: center; gap: 6px; ${type(phone, 'secondary')} color: ${muted}">${svg(icon('motorcycle'), 16, muted, true)}${esc(o.captain)}</div>`;
    const b = o.badge
      ? `<span style="align-self: flex-start; display: inline-flex; align-items: center; gap: 6px; height: 26px; padding-inline: 10px; border-radius: 999px; background: ${PROPOSED.warningSubtle}; color: ${v(themes, 'color.warning')}; font-size: 13px; font-weight: 500">${svg(icon('warning'), 14, v(themes, 'color.warning'))}${esc(o.badge)}</span>`
      : '';
    return shell(
      phone,
      top + lines + b + button(phone, o.action, 'primary', 'width: 100%;'),
      'outline',
      `width: 340px; ${late ? `box-shadow: inset 0 0 0 2px ${v(themes, 'color.danger')}; background: ${PROPOSED.dangerSubtle};` : ''}`,
    );
  };
  const cOrder = (s: Status, when: string, total: string, extra = '') =>
    shell(
      phone,
      `<div style="display: flex; align-items: center; gap: 12px"><span style="display: inline-flex; align-items: center; justify-content: center; width: 48px; height: 48px; border-radius: ${v(themes, 'radius.md')}; background: ${PROPOSED.primarySubtle}; color: ${v(themes, 'color.primary-pressed')}; font-size: 22px; font-weight: 700">ب</span><div style="flex: 1"><div style="${type(phone, 'subtitle')}">برجر كبصو</div><div style="${type(phone, 'secondary')} color: ${muted}">${esc(when)}</div></div>${money(phone, total, '₺', { weight: 700 })}</div><div style="display: flex; align-items: center; justify-content: space-between">${chip(phone, s, 'tint', s.customer)}${extra}</div>`,
      'offset',
      'width: 360px',
    );
  const orderCard = card(
    themes,
    h2(
      themes,
      'بطاقة الطلب',
      'the restaurant board’s compact card (RA §8.2: number, time since placed, items, captain line, the column’s timer, badges, one main button; late turns red) · the customer’s «طلباتي» row (CU §12.3: restaurant, date, status, total)',
    ) +
      row(
        themes,
        [
          cell(
            rOrder({
              state: 'placed',
              number: '10423',
              since: 'منذ 1 د',
              items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
              captain: 'بانتظار كابتن',
              t: '4:32',
              tt: 'calm',
              action: 'قبول',
            }),
            label(themes, 'new: auto-cancel countdown'),
          ),
          cell(
            rOrder({
              state: 'accepted',
              number: '10419',
              since: 'منذ 9 د',
              items: '2 أصناف · برجر كبصو، كوب عيران',
              captain: 'الكابتن أحمد في الطريق — يصل خلال 4 د',
              t: '6 د',
              tt: 'calm',
              action: 'الطلب جاهز',
              badge: 'صنف نفد — بانتظار العمليات',
            }),
            label(themes, 'preparing, with a badge'),
          ),
          cell(
            rOrder({
              state: 'accepted',
              number: '10412',
              since: 'منذ 24 د',
              items: '5 أصناف · وجبة عائلية…',
              captain: 'وصل الكابتن — ينتظر منذ 3 د',
              t: 'متأخر 4 د',
              tt: 'late',
              action: 'الطلب جاهز',
            }),
            label(themes, 'late: red outline and tint'),
          ),
        ],
        'flex-start',
      ) +
      row(
        themes,
        [
          cell(
            cOrder(status('picked_up'), 'اليوم · 9:45 م', '470'),
            label(themes, 'customer: active'),
          ),
          cell(
            cOrder(
              status('delivered'),
              '21/11/2026',
              '235',
              `<span style="${type(phone, 'secondary', 500)} color: ${v(themes, 'color.accent')}">اطلب مرة أخرى</span>`,
            ),
            label(themes, 'customer: past, reorder'),
          ),
          cell(
            cOrder(status('cancelled'), '20/11/2026', '120'),
            label(themes, 'customer: cancelled'),
          ),
        ],
        'flex-start',
      ),
  );

  // 8. Amounts summary.
  const lines: [string, string, MoneyOpts?, string?][] = [
    ['قيمة الأصناف', '452'],
    ['رسوم التوصيل', '45'],
    ['الخصم (FOX25)', '25', { sign: '−', colour: v(themes, 'color.success') }],
    ['تقريب', '2', { sign: '−' }],
  ];
  const summaryLines = (dashed: boolean) =>
    lines
      .map(
        ([t, a, o], i) =>
          `<div style="display: flex; align-items: center; justify-content: space-between; padding-block: 10px; ${i < lines.length - 1 ? `border-bottom: 1px ${dashed ? 'dashed' : 'solid'} ${v(themes, 'color.border')}` : ''}"><span style="${type(phone, 'body')}">${esc(t)}</span>${money(phone, a, '₺', o)}</div>`,
      )
      .join('');
  const equivalents = `<div style="${type(phone, 'secondary')} color: ${muted}">أو ${money(phone, '11.50', '$', { role: 'secondary' })} · ${money(phone, '3,300,000', 'ل.س', { role: 'secondary' })}</div>`;
  const summaryA = `<div style="display: flex; flex-direction: column; gap: 12px; width: 380px">${shell(phone, summaryLines(true), 'outline', 'gap: 0; padding-block: 4px')}<div style="display: flex; align-items: center; justify-content: space-between; padding: 12px 20px; border-radius: ${v(themes, 'radius.lg')}; background: ${v(themes, 'color.primary')}; color: ${v(themes, 'color.on-primary')}"><span style="${type(phone, 'subtitle', 700)}">المجموع</span>${money(phone, '470', '₺', { role: 'title', colour: v(themes, 'color.on-primary') })}</div>${equivalents}</div>`;
  const summaryB = `<div style="display: flex; flex-direction: column; gap: 8px; width: 380px">${shell(phone, `${summaryLines(false)}<div style="display: flex; align-items: center; justify-content: space-between; padding-top: 12px; border-top: 2px solid ${ink}"><span style="${type(phone, 'subtitle', 700)}">المجموع</span>${money(phone, '470', '₺', { role: 'number' })}</div>${equivalents}`, 'outline', 'gap: 0')}</div>`;
  const summaryCard = card(
    themes,
    h2(
      themes,
      'ملخص المبالغ',
      'CU §10.3 step 7: items value, delivery fee or «مجاني», discount with its code, rounding only when not 0, the total in the base currency and one equivalent per accepted currency under it',
    ) +
      options(themes, [
        option(
          themes,
          'أ — شريط المجموع البرتقالي (Figma)',
          summaryA,
          'the cart screen of the file: the total reads first; ivory on orange under the R4 exception',
          true,
        ),
        option(
          themes,
          'ب — مجموع عريض تحت خط',
          summaryB,
          'quieter; fits the panel and the restaurant’s order detail',
        ),
      ]) +
      `<div>${label(themes, 'our proposal: one component with a prominent (A) and a plain (B) variant: A in the customer’s cart and checkout, B everywhere else')}</div>`,
  );

  // 9. Restaurant card.
  const heart = (on: boolean) =>
    `<span style="position: absolute; top: 10px; inset-inline-start: 10px; display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; background: ${v(themes, 'color.surface-raised')}">${svg(icon('heart'), 22, on ? v(themes, 'color.danger') : ink)}</span>`;
  const rCard = (o: {
    name: string;
    cats: string;
    rating?: string;
    eta: string;
    fee?: string;
    state?: string;
    faded?: boolean;
    noCover?: boolean;
    noLogo?: boolean;
    fav?: boolean;
  }) => {
    const cover = o.noCover
      ? `<span style="display: flex; align-items: center; justify-content: center; width: 100%; height: 180px; border-radius: ${v(themes, 'radius.lg')}; background: ${PROPOSED.primarySubtle}"><span style="display: inline-flex; align-items: center; justify-content: center; width: 72px; height: 72px; border-radius: ${v(themes, 'radius.lg')}; background: ${v(themes, 'color.surface-raised')}; box-shadow: ${v(themes, 'elevation.low')}; font-size: 30px; font-weight: 700; color: ${v(themes, 'color.primary-pressed')}">ك</span></span>`
      : photo(phone, 328, 180, 'صورة الغلاف 16:9', v(themes, 'radius.lg'));
    const logo = o.noLogo
      ? `<span style="display: inline-flex; align-items: center; justify-content: center; width: 48px; height: 48px; border-radius: ${v(themes, 'radius.md')}; background: ${v(themes, 'color.accent')}; color: ${v(themes, 'color.on-accent')}; font-size: 22px; font-weight: 700; flex: none">${esc(o.name.slice(0, 1))}</span>`
      : `<span style="display: inline-flex; align-items: center; justify-content: center; width: 48px; height: 48px; border-radius: ${v(themes, 'radius.md')}; background: ${v(themes, 'color.surface-raised')}; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}; flex: none">${svg(icon('restaurant'), 26, v(themes, 'color.primary'))}</span>`;
    const stateBadge = o.state
      ? `<span style="position: absolute; top: 10px; inset-inline-end: 10px; height: 28px; display: inline-flex; align-items: center; padding-inline: 10px; border-radius: 999px; background: ${o.state.startsWith('مغلق') ? PROPOSED.neutralText : v(themes, 'color.warning')}; color: #fff; font-size: 13px; font-weight: 500">${esc(o.state)}</span>`
      : '';
    const rating = o.rating
      ? `<span style="display: inline-flex; align-items: center; gap: 4px; ${TNUM}">${svg(icon('star'), 16, v(themes, 'color.primary'))}${o.rating}</span>`
      : `<span style="color: ${v(themes, 'color.success')}; font-weight: 500">جديد</span>`;
    const fee = o.fee
      ? money(phone, o.fee, '₺', { role: 'secondary' })
      : `<span style="color: ${v(themes, 'color.success')}; font-weight: 500">توصيل مجاني</span>`;
    return shell(
      phone,
      `<div style="position: relative">${cover}${heart(o.fav ?? false)}${stateBadge}</div><div style="display: flex; gap: 12px; align-items: center">${logo}<div style="flex: 1; min-width: 0"><div style="${type(phone, 'subtitle', 700)}">${esc(o.name)}</div><div style="${type(phone, 'secondary')} color: ${muted}">${esc(o.cats)}</div></div></div><div style="display: flex; align-items: center; gap: 14px; ${type(phone, 'secondary')}">${rating}<span style="display: inline-flex; align-items: center; gap: 4px; ${TNUM}">${svg(icon('clock'), 16, muted)}${esc(o.eta)}</span><span style="display: inline-flex; align-items: center; gap: 4px">${svg(icon('motorcycle'), 16, muted, true)}${fee}</span></div>`,
      'offset',
      `width: 360px; ${o.faded ? 'opacity: 0.55; filter: grayscale(0.6);' : ''}`,
    );
  };
  const restaurantCard = card(
    themes,
    h2(
      themes,
      'بطاقة المطعم',
      'CU §8.2: cover 16:9, logo and name, categories, rating or «جديد», the estimate as a range, the fee or «توصيل مجاني», the state badge, the heart · closed cards fade · missing cover: logo on a tint; missing logo: the first letter in a rounded square (brand expression §5)',
    ) +
      row(
        themes,
        [
          cell(
            rCard({
              name: 'برجر كبصو',
              cats: 'برجر · وجبات سريعة',
              rating: '4.5',
              eta: '20–30 د',
              fee: '15',
              fav: true,
            }),
            label(themes, 'open'),
          ),
          cell(
            rCard({ name: 'شاورما الشام', cats: 'شاورما · مشاوي', eta: '25–35 د', state: 'مشغول' }),
            label(themes, 'busy, new, free delivery'),
          ),
          cell(
            rCard({
              name: 'كنافة أعزاز',
              cats: 'حلويات',
              rating: '4.8',
              eta: '30–40 د',
              fee: '10',
              state: 'مغلق — يفتح السبت 10:00 ص',
              faded: true,
              noCover: true,
            }),
            label(themes, 'closed, faded; no cover'),
          ),
          cell(
            rCard({
              name: 'فطائر الريف',
              cats: 'معجنات',
              rating: '4.2',
              eta: '15–25 د',
              fee: '10',
              noLogo: true,
            }),
            label(themes, 'no logo: first letter'),
          ),
        ],
        'flex-start',
      ),
  );

  // 10. Dish card.
  const add = (count = 0) =>
    count
      ? `<span style="display: inline-flex; align-items: center; justify-content: center; min-width: 40px; height: 40px; padding-inline: 10px; box-sizing: border-box; border-radius: 999px; background: ${v(themes, 'color.accent')}; color: ${v(themes, 'color.on-accent')}; font-weight: 700; ${TNUM}">${count}</span>`
      : `<span style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; background: ${v(themes, 'color.primary')}">${svg(icon('add'), 22, v(themes, 'color.on-primary'))}</span>`;
  const dishRow = (o: {
    name: string;
    desc: string;
    price: string;
    from?: boolean;
    photo?: boolean;
    off?: string;
    count?: number;
  }) =>
    shell(
      phone,
      `<div style="display: flex; gap: 12px; align-items: stretch"><div style="flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 4px"><div style="${type(phone, 'subtitle', 700)} color: ${v(themes, 'color.heading')}">${esc(o.name)}</div><div style="${type(phone, 'secondary')} color: ${muted}">${esc(o.desc)}</div><div style="flex: 1"></div><div style="display: flex; align-items: center; gap: 8px">${o.from ? `<span style="${type(phone, 'secondary')}">من</span>` : ''}${money(phone, o.price, '₺', { weight: 700 })}${o.off ? `<span style="${type(phone, 'secondary', 500)} color: ${muted}">· ${esc(o.off)}</span>` : ''}</div></div>${o.photo === false ? '' : `<div style="position: relative">${photo(phone, 104, 104, '1:1')}</div>`}${o.off ? '' : `<div style="display: flex; align-items: flex-end">${add(o.count)}</div>`}</div>`,
      'outline',
      `width: 400px; ${o.off ? 'opacity: 0.55;' : ''}`,
    );
  const dishBlock = shell(
    phone,
    `<div style="display: flex; align-items: stretch; gap: 0; margin: -16px; border-radius: ${v(themes, 'radius.lg')}; overflow: hidden; box-shadow: inset 0 0 0 2px ${v(themes, 'color.primary')}"><div style="flex: 1; padding: 12px 16px"><div style="${type(phone, 'subtitle', 700)} color: ${v(themes, 'color.heading')}">وجبة كريسبي</div><div style="${type(phone, 'secondary')}">وجبة مخصصة لشخصين مع بطاطس</div>${money(phone, '120', '₺', { weight: 700 })}</div><div style="display: flex; align-items: center; justify-content: center; width: 120px; background: ${v(themes, 'color.primary')}">${svg(icon('plate'), 48, v(themes, 'color.on-primary'))}</div></div>`,
    'outline',
    'width: 400px; padding: 16px',
  );
  const dishCard = card(
    themes,
    h2(
      themes,
      'بطاقة الطبق',
      'CU §9.3: price, or «من {أقل سعر}» when a required group changes it · unavailable items stay in place, faded, with «يتوفر غداً» or «غير متوفر حالياً» · photo 1:1; no photo: a text row without an image slot (brand expression §5)',
    ) +
      options(themes, [
        option(
          themes,
          'أ — سطر القائمة مع صورة مربعة',
          `<div style="display: flex; flex-direction: column; gap: 12px">${dishRow({ name: 'برجر كبصو', desc: 'لحم بقري مشوي، جبن شيدر، خس، طماطم', price: '180' })}${dishRow({ name: 'وجبة كريسبي', desc: 'قطعتان مع بطاطس ومشروب', price: '120', from: true, count: 2 })}${dishRow({ name: 'كوب عيران', desc: 'مقاس كبير', price: '25', photo: false })}${dishRow({ name: 'فطور شامي', desc: 'فول، حمص، بيض', price: '90', off: 'يتوفر غداً' })}</div>`,
          'the photo sells (CU: appetite and trust); the «+» sits in the thumb’s reach; the count replaces «+» once in the cart',
          true,
        ),
        option(
          themes,
          'ب — كتلة Figma بلوح أيقونة',
          dishBlock,
          'the file’s «المزيد من» block: striking, but an icon instead of the photo hides the food; fits a short «more from this restaurant» strip only',
        ),
      ]),
  );

  // 11. Skeleton.
  const skeletonCard = (anim: string) =>
    shell(
      phone,
      `${skel('100%', 150, v(themes, 'radius.lg'))}<div style="display: flex; gap: 12px; align-items: center">${skel(48, 48, v(themes, 'radius.md'))}<div style="flex: 1; display: flex; flex-direction: column; gap: 8px">${skel('70%', 16)}${skel('45%', 12)}</div></div>${skel('60%', 12)}<div>${label(themes, anim)}</div>`,
      'outline',
      'width: 300px',
    );
  const skeletonSection = card(
    themes,
    h2(
      themes,
      'الهيكل أثناء التحميل',
      'the loading state of R6 · drawn in the shape of what will come · never a spinner over content · reduced motion: still blocks',
    ) +
      options(themes, [
        option(
          themes,
          'أ — نبض هادئ',
          skeletonCard('opacity 1 → 0.55 → 1 over 1.2 s (duration.moment), calm easing'),
          'calm, cheap on low-end phones (brand expression: device budgets)',
          true,
        ),
        option(
          themes,
          'ب — وميض متحرك',
          skeletonCard('a light band sweeps from the start (right) to the end'),
          'livelier; a moving gradient costs more frames on weak devices',
        ),
      ]) +
      row(themes, [
        cell(
          shell(
            phone,
            [1, 2, 3]
              .map(
                () =>
                  `<div style="display: flex; gap: 12px; align-items: center">${skel(40, 40, '50%')}<div style="flex: 1; display: flex; flex-direction: column; gap: 6px">${skel('60%', 14)}${skel('35%', 10)}</div>${skel(56, 14)}</div>`,
              )
              .join(''),
            'outline',
            'width: 380px',
          ),
          label(themes, 'list rows'),
        ),
        cell(
          shell(
            phone,
            `<div style="display: flex; justify-content: space-between">${skel(80, 18)}${skel(70, 30, '999px')}</div>${skel('90%', 14)}${skel('60%', 12)}${skel('100%', 50, '999px')}`,
            'outline',
            'width: 340px',
          ),
          label(themes, 'order card'),
        ),
      ]),
  );

  // 12. Empty and error states.
  const state = (
    c: Ctx,
    o: { icon: string; title: string; body: string; action?: string; kind?: 'error' },
  ) =>
    `<div style="display: flex; flex-direction: column; align-items: center; text-align: center; gap: ${tk(c, 'space.sm')}; width: ${c.surface === 'panel' ? 320 : 300}px; padding: ${tk(c, 'space.lg')}">${dropFrame(c, o.icon, c.surface === 'panel' ? 72 : 120)}<div style="${type(c, 'title')} color: ${o.kind === 'error' ? tk(c, 'color.danger') : tk(c, 'color.heading')}">${esc(o.title)}</div><div style="${type(c, 'secondary')} color: ${muted}">${esc(o.body)}</div>${o.action ? button(c, o.action, o.kind === 'error' ? 'primary' : 'secondary') : ''}</div>`;
  const statesCard = card(
    themes,
    h2(
      themes,
      'الحالات الفارغة والخطأ',
      'R6 · inside the logo’s drop frame (brand expression §2, §5) · apps: the fox scenes go in this frame once drawn and approved (8 scenes); until then, a large icon · panel and portal: an icon in a drop, no scenes · a title, one line, at most one action',
    ) +
      row(
        themes,
        [
          state(phone, {
            icon: 'cart',
            title: 'سلتك فارغة',
            body: 'أضف أطباقك المفضلة وستجدها هنا',
            action: 'تصفّح المطاعم',
          }),
          state(phone, {
            icon: 'search',
            title: 'لم نجد نتائج',
            body: 'جرّب كلمة أخرى، أو أخبرنا بما تبحث عنه',
            action: 'لم تجده؟ أخبرنا',
          }),
          state(phone, {
            icon: 'offline',
            title: 'لا يوجد اتصال',
            body: 'تحقّق من الإنترنت وسنحاول مجدداً تلقائياً',
          }),
          state(phone, {
            icon: 'error',
            title: 'حدث خطأ',
            body: 'لم نتمكن من تحميل الطلبات',
            action: 'أعد المحاولة',
            kind: 'error',
          }),
          state(panel, {
            icon: 'orders',
            title: 'لا طلبات بهذه الفلاتر',
            body: 'غيّر الفترة أو الحالة',
            action: 'مسح الفلاتر',
          }),
        ],
        'flex-start',
      ),
  );

  // 13. Data table (web).
  const th = (t: string, o: { end?: boolean; sort?: 'asc' | 'desc'; w?: number } = {}) =>
    `<th style="text-align: ${o.end ? 'end' : 'start'}; padding: 0 12px; height: 40px; ${type(panel, 'secondary', 500)} color: ${muted}; white-space: nowrap; ${o.w ? `width: ${o.w}px;` : ''}"><span style="display: inline-flex; align-items: center; gap: 4px; ${o.sort ? `color: ${ink}` : ''}">${esc(t)}${o.sort ? `<span style="display: inline-flex; ${o.sort === 'asc' ? 'transform: rotate(180deg)' : ''}">${svg(icon('chevron-down'), 14, ink)}</span>` : ''}</span></th>`;
  const td = (inner: string, end = false) =>
    `<td style="padding: 0 12px; height: 40px; text-align: ${end ? 'end' : 'start'}; ${type(panel, 'body')} border-top: 1px solid ${v(themes, 'color.border')}; white-space: nowrap">${inner}</td>`;
  const check = (on: boolean) =>
    `<span style="display: inline-flex; align-items: center; justify-content: center; width: 18px; height: 18px; border-radius: 4px; background: ${on ? v(themes, 'color.primary') : v(themes, 'color.surface-raised')}; box-shadow: inset 0 0 0 ${on ? 0 : 2}px ${v(themes, 'color.border-strong')}">${on ? svg(icon('confirm'), 14, v(themes, 'color.on-primary')) : ''}</span>`;
  const tableRows: [string, string, string, string, string, string, string?][] = [
    ['10423', '9:45 م', 'برجر كبصو', 'placed', '470', '4:32'],
    ['10422', '9:41 م', 'شاورما الشام', 'accepted', '235', '12 د', 'hover'],
    ['10421', '9:38 م', 'كنافة أعزاز', 'picked_up', '1,120', '—', 'selected'],
    ['10420', '9:30 م', 'فطائر الريف', 'failed', '90', '—'],
  ];
  const table = `<table style="border-collapse: collapse; width: 100%; background: ${v(themes, 'color.surface-raised')}; border-radius: ${v(themes, 'radius.md')}; overflow: hidden; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}"><thead style="background: ${v(themes, 'color.surface')}"><tr>${th('', { w: 40 })}${th('الطلب')}${th('الوقت', { sort: 'desc' })}${th('المطعم')}${th('الحالة')}${th('المؤقت')}${th('المجموع', { end: true })}</tr></thead><tbody>${tableRows
    .map(
      ([n, t, r, s, total, clock, st]) =>
        `<tr style="background: ${st === 'hover' ? v(themes, 'color.surface-raised-hover') : st === 'selected' ? PROPOSED.primarySubtle : 'transparent'}">${td(check(st === 'selected'))}${td(`<span style="${TNUM} font-weight: 500; color: ${v(themes, 'color.accent')}">#${n}</span>`)}${td(`<span style="${TNUM}">${t}</span>`)}${td(esc(r))}${td(chip(panel, status(s), 'tint'))}${td(clock === '—' ? `<span style="color: ${muted}">—</span>` : `<span style="${TNUM} font-weight: 700">${clock}</span>`)}${td(money(panel, total, '₺', { role: 'body' }), true)}</tr>`,
    )
    .join(
      '',
    )}<tr>${td(skel(18, 18, '4px'))}${td(skel(60, 12))}${td(skel(50, 12))}${td(skel(110, 12))}${td(skel(90, 22, '999px'))}${td(skel(40, 12))}${td(`<span style="display: inline-flex">${skel(60, 12)}</span>`, true)}</tr></tbody></table><div style="display: flex; align-items: center; justify-content: space-between; padding-top: 8px; ${type(panel, 'secondary')} color: ${muted}"><span>تم تحديد 1 · <span style="color: ${v(themes, 'color.accent')}; font-weight: 500">إلغاء التحديد</span></span><span style="${TNUM}">1–20 من 312</span><span style="display: inline-flex; gap: 4px">${svg(icon('back'), 20, ink, true)}${svg(icon('back'), 20, ink)}</span></div>`;
  const tableCard = card(
    themes,
    h2(
      themes,
      'جدول البيانات (الويب)',
      'panel and portal, compact 40 · sticky header; the sorted column says so in words to screen readers · numbers and money aligned to the end, tabular · row hover (R10), selection with a checkbox, keyboard: arrows move, Enter opens · loading rows are skeletons; the empty state sits inside the table',
    ) + `<div>${table}</div>`,
  );

  // 14. Surfaces and 130% text.
  const big: Ctx = { ...phone, scale: 1.3 };
  const capCard = shell(
    captain,
    `<div style="display: flex; align-items: center; justify-content: space-between"><span style="${type(captain, 'title')} ${TNUM}">#10423</span>${chip(captain, status('picked_up'), 'tint')}</div><div style="display: flex; align-items: center; justify-content: space-between"><span style="${type(captain, 'body')}">تحصّل من الزبون</span>${money(captain, '470', '₺', { role: 'number' })}</div>${timer(captain, '6 د', 'calm')}`,
    'outline',
    'width: 360px',
  );
  const surfacesCard = card(
    themes,
    h2(
      themes,
      'الأسطح والنص المكبّر 130٪',
      'captain: larger type and 7:1 text, the amount to collect read at a glance · 130%: the order card grows, the chip and the amount wrap to the next line, nothing clips',
    ) +
      row(
        themes,
        [
          cell(capCard, label(themes, 'captain')),
          cell(
            shell(
              big,
              `<div style="display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 8px"><span style="${type(big, 'subtitle', 700)}">برجر كبصو</span>${chip(big, status('accepted'), 'tint', 'المطعم يحضّر طلبك')}</div><div style="display: flex; flex-wrap: wrap; justify-content: space-between; gap: 8px"><span style="${type(big, 'secondary')} color: ${muted}">اليوم · 9:45 م</span>${money(big, '470', '₺', { weight: 700 })}</div>`,
              'offset',
              'width: 360px',
            ),
            label(themes, '130% text'),
          ),
        ],
        'flex-start',
      ),
  );

  // 15. Questions.
  const questions = card(
    themes,
    h2(themes, 'ما اعتمده المالك', '2026-11-24 · every framed proposal') +
      `<ol style="margin: 0; padding-inline-start: 24px; display: flex; flex-direction: column; gap: ${v(themes, 'space.xs')}; line-height: 1.7">
<li>رمز ₺: (أ) حرف مضمَّن من Noto Sans باسم Fox Lira.</li>
<li>فاصل الآلاف: فاصلة غربية «3,300,000».</li>
<li>شارة الحالة: (أ) خلفية فاتحة ونص داكن، بالألوان المقترحة (في تطبيق الكابتن يُقرأ البرتقالي بالأزرق).</li>
<li>حاوية البطاقة: الظل المُزاح في تطبيق الزبون والحدّ الرفيع في البقية.</li>
<li>ملخص المبالغ: شريط برتقالي للمجموع في سلة الزبون، ومجموع عريض تحت خط في البقية.</li>
<li>بطاقة الطبق: (أ) سطر مع صورة مربعة.</li>
<li>الهيكل: (أ) نبض هادئ.</li>
<li>خلفيات الحالات الفاتحة صارت رموزاً دلالية (*-subtle)، الإصدار 0.7.0.</li>
</ol>`,
  );

  const body = [
    heading(
      themes,
      'عرض البيانات — الدفعة الثالثة (مُستبدَلة)',
      'Superseded (architecture §9.9 step 4): the record of the approval only; the components live in the Design System (ui-web) and core_ui (Flutter), slice D.9. Data display — batch 3 (architecture §9.9 step 1, slice D.9). Money, the order status chip, count badge, card, list row, timer and countdown, order card, amounts summary, restaurant and dish cards, skeleton, empty and error states, and the web data table; phone, captain and panel, RTL, 130% text; real tokens, options side by side where you decide. Photos are stand-ins and every sample is review copy only.',
    ),
    moneyCard,
    chipCard,
    badgeCard,
    shellCard,
    listCard,
    timerCard,
    orderCard,
    summaryCard,
    restaurantCard,
    dishCard,
    skeletonSection,
    statesCard,
    tableCard,
    surfacesCard,
    questions,
  ].join('\n');
  return page(
    themes,
    config,
    { file: 'Data.dc.html', title: 'Data display — batch 3', w: W, h: 8400 },
    body,
  );
}
