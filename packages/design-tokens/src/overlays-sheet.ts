// Draws «Overlays and navigation — batch 4» for the owner's review
// (architecture §9.9 step 1), the sixth artboard of the «Component proposals»
// canvas: every D.10 component on the surfaces that use it (customer, captain,
// restaurant, panel), RTL, from the real tokens. Where the owner has a real
// choice the sheet draws the options side by side; a value that is not a token
// yet comes from PROPOSED, with its contrast measured on the sheet.
import { contrast } from './color.ts';
import { cssValue } from './generate.ts';
import { card, esc, heading, label, page, v, type Board, type GuideConfig } from './guide.ts';
import type { Icon } from './icons.ts';
import type { Theme, Token } from './resolve.ts';

type Themes = Record<Theme, Map<string, Token>>;

const W = 1680;

/** Values that are not tokens yet: the owner approves them with the sheet. */
const PROPOSED = {
  /** `color.scrim`: neutral 900 at 48%, behind dialogs, sheets and drawers. */
  scrim: 'rgba(31, 28, 24, 0.48)',
  /** `color.caution` and `color.caution-subtle`: the yellow tone RA §6.3 and CA §6.3 name. */
  caution: '#5C4A00',
  cautionSubtle: '#FFF5BF',
  /** `layer.*`: the stacking order. */
  layers: [
    ['layer.sticky', '10', 'top bar, bottom navigation, rail, sticky table header'],
    ['layer.banner', '20', 'banners under the top bar'],
    ['layer.overlay', '30', 'scrim, dialog, bottom sheet, side drawer'],
    ['layer.menu', '40', 'menu and select list (they open from inside a dialog too)'],
    ['layer.toast', '50', 'toasts, above an open sheet'],
    ['layer.tooltip', '60', 'tooltips, always on top'],
    ['layer.blocking', '70', 'the blocking sound banner (AP §7.3), above everything'],
  ] as [string, string, string][],
};

const ratio = (a: string, b: string) => contrast(a, b).toFixed(1);

type Surface = 'phone' | 'panel' | 'captain';

interface Ctx {
  themes: Themes;
  theme: Theme;
  surface: Surface;
  scale: number;
  icon: (name: string) => Icon['paths'];
}

const tk = (c: Ctx, name: string) => cssValue(c.themes[c.theme].get(name)!);
const size = (c: Ctx, role: string) =>
  Math.round(Number.parseFloat(tk(c, `type.${c.surface}.${role}.size`)) * c.scale);
const type = (c: Ctx, role: string, weight?: number) =>
  `font-size: ${size(c, role)}px; line-height: 1.5; font-weight: ${weight ?? tk(c, `type.${c.surface}.${role}.weight`)};`;
const TNUM = "font-feature-settings: 'tnum';";

function svg(paths: string[], px: number, colour = 'currentColor', flip = false): string {
  const transform = flip ? '; transform: scaleX(-1)' : '';
  return `<svg aria-hidden="true" width="${px}" height="${px}" viewBox="0 0 24 24" fill="none" stroke="${colour}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="flex: none${transform}">${paths.map((d) => `<path d="${d}"/>`).join('')}</svg>`;
}

/** The proposed «menu» icon (three lines), for the sidebar's phone form: not in batch 1. */
const MENU_ICON = ['M4 6h16', 'M4 12h16', 'M4 18h16'];

const cell = (inner: string, caption = '') =>
  `<div style="width: min-content; display: flex; flex-direction: column; align-items: flex-start; justify-content: flex-end; gap: 8px">${inner}${caption}</div>`;
const h2 = (themes: Themes, text: string, note = '') =>
  `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">${esc(text)} ${note ? label(themes, note) : ''}</h2>`;
const row = (themes: Themes, items: string[], align = 'flex-end') =>
  `<div style="display: flex; flex-wrap: wrap; align-items: ${align}; gap: ${v(themes, 'space.xl')}">${items.join('')}</div>`;
const option = (themes: Themes, title: string, inner: string, note: string, ours = false) =>
  `<div style="flex: 1; min-width: 0; display: flex; flex-direction: column; gap: ${v(themes, 'space.sm')}; padding: ${v(themes, 'space.lg')}; border-radius: ${v(themes, 'radius.lg')}; background: ${v(themes, 'color.surface')}; ${ours ? `box-shadow: inset 0 0 0 2px ${v(themes, 'color.accent')}` : ''}"><div style="font-weight: 700">${esc(title)}${ours ? ` <span style="font-weight: 500; color: ${v(themes, 'color.accent')}">· توصيتنا</span>` : ''}</div>${inner}<div>${label(themes, note)}</div></div>`;
const options = (themes: Themes, items: string[]) =>
  `<div style="display: flex; gap: ${v(themes, 'space.lg')}; align-items: stretch">${items.join('')}</div>`;

// ---------- small parts ----------

function button(
  c: Ctx,
  text: string,
  kind: 'primary' | 'secondary' | 'danger' = 'primary',
  extra = '',
): string {
  const h = c.surface === 'panel' ? 40 : c.surface === 'captain' ? 56 : 50;
  return `<span style="display: inline-flex; align-items: center; justify-content: center; height: ${h}px; padding-inline: 20px; box-sizing: border-box; border-radius: 999px; background: ${tk(c, `button.${kind}.background`)}; color: ${tk(c, `button.${kind}.label`)}; ${kind === 'secondary' ? `box-shadow: inset 0 0 0 1px ${tk(c, 'button.secondary.border')};` : ''} ${type(c, 'body', 500)} white-space: nowrap; ${extra}">${esc(text)}</span>`;
}

const focusRing = (c: Ctx) =>
  `outline: 2px solid ${tk(c, 'color.focus-ring')}; outline-offset: 2px;`;

function countBadge(c: Ctx, text: string, extra = ''): string {
  return `<span dir="ltr" style="min-width: 20px; height: 20px; padding-inline: 5px; box-sizing: border-box; display: inline-flex; align-items: center; justify-content: center; border-radius: 999px; background: ${tk(c, 'color.danger')}; color: ${tk(c, 'color.on-danger')}; font-size: 12px; font-weight: 700; ${TNUM} ${extra}">${esc(text)}</span>`;
}

function iconButton(
  c: Ctx,
  name: string,
  opts: { px?: number; badge?: string; flip?: boolean } = {},
): string {
  const px = opts.px ?? 40;
  const badge = opts.badge
    ? `<span style="position: absolute; top: -4px; inset-inline-end: -6px">${countBadge(c, opts.badge, `box-shadow: 0 0 0 2px ${tk(c, 'color.surface-raised')}`)}</span>`
    : '';
  return `<span style="position: relative; display: inline-flex; align-items: center; justify-content: center; width: ${px}px; height: ${px}px; flex: none; border-radius: 50%; background: ${tk(c, 'color.surface-raised')}; box-shadow: inset 0 0 0 1px ${tk(c, 'color.border')}">${svg(c.icon(name), Math.round(px * 0.5), tk(c, 'color.on-surface'), opts.flip)}${badge}</span>`;
}

/** A device-sized frame on the sheet: what sits behind an overlay is drawn faint. */
function frame(c: Ctx, w: number, h: number, inner: string, caption: string, radius = 28): string {
  return cell(
    `<div style="position: relative; width: ${w}px; height: ${h}px; overflow: hidden; border-radius: ${radius}px; background: ${tk(c, 'color.surface')}; box-shadow: inset 0 0 0 1px ${tk(c, 'color.border')}; color: ${tk(c, 'color.on-surface')}">${inner}</div>`,
    caption,
  );
}

const scrim = `<div style="position: absolute; inset: 0; background: ${PROPOSED.scrim}"></div>`;

/** Faint stand-in rows for the content behind an overlay. */
function behind(c: Ctx, rows: number, top = 72): string {
  const line = (i: number) =>
    `<div style="height: 56px; border-radius: ${tk(c, 'radius.md')}; background: ${tk(c, 'color.surface-raised')}; box-shadow: inset 0 0 0 1px ${tk(c, 'color.border')}; opacity: ${1 - i * 0.08}"></div>`;
  return `<div style="position: absolute; inset: ${top}px 16px 0 16px; display: flex; flex-direction: column; gap: 12px">${Array.from({ length: rows }, (_, i) => line(i)).join('')}</div>`;
}

function field(c: Ctx, text: string, placeholder = false, error = ''): string {
  const h = c.surface === 'panel' ? 40 : 50;
  const border = error ? tk(c, 'color.danger') : tk(c, 'color.border-strong');
  return `<div style="display: flex; flex-direction: column; gap: 4px"><div style="height: ${h}px; display: flex; align-items: center; padding-inline: 14px; border-radius: ${tk(c, 'radius.md')}; background: ${tk(c, 'color.surface-raised')}; box-shadow: inset 0 0 0 ${error ? 2 : 1}px ${border}; ${type(c, 'body')} color: ${placeholder ? tk(c, 'color.on-surface-muted') : tk(c, 'color.on-surface')}">${esc(text)}</div>${error ? `<span style="display: inline-flex; align-items: center; gap: 4px; ${type(c, 'secondary')} color: ${tk(c, 'color.danger')}">${svg(c.icon('error'), 16)}${esc(error)}</span>` : ''}</div>`;
}

function money(c: Ctx, amount: string, sign = '', colour?: string): string {
  return `<bdi dir="rtl" style="unicode-bidi: isolate; white-space: nowrap; ${TNUM} ${type(c, 'body', 500)} color: ${colour ?? tk(c, 'color.on-surface')}">${sign}${esc(amount)} <span style="font-family: 'Noto Sans', sans-serif">₺</span></bdi>`;
}

// ---------- tones ----------

type Tone = 'danger' | 'caution' | 'warning' | 'info' | 'neutral' | 'success';

interface ToneSet {
  strong: string;
  on: string;
  subtle: string;
  text: string;
  icon: string;
}

function tone(c: Ctx, t: Tone): ToneSet {
  if (t === 'caution')
    return {
      strong: PROPOSED.caution,
      on: '#FFFFFF',
      subtle: PROPOSED.cautionSubtle,
      text: PROPOSED.caution,
      icon: 'warning',
    };
  if (t === 'neutral')
    return {
      strong: tk(c, 'color.neutral'),
      on: '#FFFFFF',
      subtle: tk(c, 'color.neutral-subtle'),
      text: tk(c, 'color.neutral'),
      icon: 'info',
    };
  return {
    strong: tk(c, `color.${t}`),
    on: tk(c, `color.on-${t}`),
    subtle: tk(c, `color.${t}-subtle`),
    text: tk(c, `color.${t}`),
    icon: { danger: 'error', warning: 'warning', info: 'info', success: 'success' }[t],
  };
}

// ---------- banner ----------

interface BannerOpts {
  icon?: string;
  action?: string | undefined;
  solid?: boolean | undefined;
  w?: number | string;
}

function banner(c: Ctx, t: Tone, text: string, o: BannerOpts = {}): string {
  const s = tone(c, t);
  const solid = o.solid ?? t === 'danger';
  const bg = solid ? s.strong : s.subtle;
  const fg = solid ? s.on : s.text;
  const action = o.action
    ? `<span style="flex: none; ${type(c, 'secondary', 700)} text-decoration: underline; text-underline-offset: 3px">${esc(o.action)}</span>`
    : '';
  const width = typeof o.w === 'number' ? `${o.w}px` : (o.w ?? '100%');
  return `<div role="status" style="width: ${width}; box-sizing: border-box; display: flex; align-items: center; gap: 10px; min-height: ${c.surface === 'captain' ? 56 : 44}px; padding: 8px 16px; background: ${bg}; color: ${fg}; ${solid ? '' : `box-shadow: inset 0 -1px 0 ${tk(c, 'color.border')};`}">${svg(c.icon(o.icon ?? s.icon), c.surface === 'captain' ? 24 : 20, fg)}<span style="flex: 1; ${type(c, 'secondary', 500)}">${esc(text)}</span>${action}</div>`;
}

// ---------- toast ----------

function toast(
  c: Ctx,
  t: Tone,
  text: string,
  style: 'dark' | 'tint',
  action = '',
  w = 340,
): string {
  const s = tone(c, t);
  const dark = style === 'dark';
  const bg = dark ? tk(c, 'color.accent') : s.subtle;
  const fg = dark ? tk(c, 'color.on-accent') : s.text;
  const iconColour = dark
    ? {
        success: '#7FD3A6',
        info: '#ADC9EE',
        warning: '#F5C66B',
        danger: '#FF9C9C',
        caution: '#F5E08A',
        neutral: '#E8E1D2',
      }[t]
    : s.text;
  const act = action
    ? `<span style="flex: none; ${type(c, 'secondary', 700)} color: ${dark ? tk(c, 'color.on-accent') : tk(c, 'color.accent')}; text-decoration: underline; text-underline-offset: 3px">${esc(action)}</span>`
    : '';
  return `<div style="width: ${w}px; box-sizing: border-box; display: flex; align-items: center; gap: 10px; padding: 12px 14px; border-radius: ${tk(c, 'radius.md')}; background: ${bg}; color: ${fg}; box-shadow: ${tk(c, 'elevation.medium')}${dark ? '' : `, inset 0 0 0 1px ${tk(c, 'color.border')}`}">${svg(c.icon(s.icon), 20, iconColour)}<span style="flex: 1; ${type(c, 'secondary', 500)}">${esc(text)}</span>${act}${svg(c.icon('close'), 16, dark ? tk(c, 'color.on-accent') : s.text)}</div>`;
}

// ---------- dialog ----------

function dialogBox(
  c: Ctx,
  w: number,
  title: string,
  body: string,
  actions: string,
  extra = '',
): string {
  return `<div role="dialog" style="width: ${w}px; box-sizing: border-box; display: flex; flex-direction: column; gap: 16px; padding: ${c.surface === 'panel' ? 24 : 20}px; border-radius: ${tk(c, 'radius.lg')}; background: ${tk(c, 'color.surface-raised')}; box-shadow: ${tk(c, 'elevation.high')}; ${extra}"><div style="display: flex; align-items: flex-start; gap: 12px"><span style="flex: 1; ${type(c, 'title', 700)} color: ${tk(c, 'color.on-surface')}">${esc(title)}</span>${svg(c.icon('close'), 24, tk(c, 'color.on-surface-muted'))}</div>${body}<div style="display: flex; flex-wrap: wrap; gap: 12px">${actions}</div></div>`;
}

// ---------- tabs ----------

function underlineTabs(c: Ctx, items: [string, string?][], selected: number, focus = -1): string {
  const h = c.surface === 'panel' ? 40 : c.surface === 'captain' ? 56 : 48;
  return `<div role="tablist" style="display: flex; gap: 4px; box-shadow: inset 0 -1px 0 ${tk(c, 'color.border')}">${items
    .map(([t, n], i) => {
      const on = i === selected;
      return `<span role="tab" style="display: inline-flex; align-items: center; gap: 6px; height: ${h}px; padding-inline: 14px; ${type(c, 'body', on ? 700 : 500)} color: ${on ? tk(c, 'color.on-surface') : tk(c, 'color.on-surface-muted')}; box-shadow: ${on ? `inset 0 -3px 0 ${tk(c, 'color.primary')}` : 'none'}; white-space: nowrap; ${i === focus ? focusRing(c) : ''}">${esc(t)}${n ? countBadge(c, n, on ? '' : `background: ${tk(c, 'color.neutral-subtle')}; color: ${tk(c, 'color.neutral')}`) : ''}</span>`;
    })
    .join('')}</div>`;
}

function pillTabs(c: Ctx, items: string[], selected: number): string {
  return `<div role="tablist" style="display: flex; gap: 8px">${items
    .map((t, i) => {
      const on = i === selected;
      return `<span role="tab" style="display: inline-flex; align-items: center; height: 40px; padding-inline: 16px; border-radius: 999px; ${type(c, 'secondary', on ? 700 : 500)} background: ${on ? tk(c, 'color.primary') : tk(c, 'color.surface-raised')}; color: ${on ? tk(c, 'color.on-primary') : tk(c, 'color.on-surface')}; box-shadow: ${on ? tk(c, 'elevation.offset') : `inset 0 0 0 1px ${tk(c, 'color.border')}`}; white-space: nowrap">${esc(t)}</span>`;
    })
    .join('')}</div>`;
}

// ---------- navigation ----------

interface NavItem {
  icon: string;
  text: string;
  badge?: string;
  dot?: boolean;
}

/** The Figma file's floating bar: a blue pill, ivory circles, the active circle orange. */
function pillBar(c: Ctx, items: NavItem[], selected: number, labels: boolean): string {
  const circle = 48;
  return `<nav style="display: flex; justify-content: space-around; align-items: flex-start; gap: 4px; padding: ${labels ? '10px 12px 8px' : '10px 12px'}; border-radius: ${labels ? '32px' : '999px'}; background: ${tk(c, 'color.accent')}; box-shadow: ${tk(c, 'elevation.medium')}">${items
    .map((it, i) => {
      const on = i === selected;
      const b = it.badge
        ? `<span style="position: absolute; top: -4px; inset-inline-end: -6px">${countBadge(c, it.badge, `box-shadow: 0 0 0 2px ${tk(c, 'color.accent')}`)}</span>`
        : '';
      const circleEl = `<span style="position: relative; display: inline-flex; align-items: center; justify-content: center; width: ${circle}px; height: ${circle}px; border-radius: 50%; background: ${on ? tk(c, 'color.primary') : tk(c, 'color.surface')}; ${on ? `box-shadow: 0 4px 0 ${tk(c, 'color.primary-pressed')}` : ''}">${svg(c.icon(it.icon), 24, on ? tk(c, 'color.on-primary') : tk(c, 'color.accent'))}${b}</span>`;
      const text = labels
        ? `<span style="${type(c, 'caption', on ? 700 : 500)} color: ${tk(c, 'color.on-accent')}">${esc(it.text)}</span>`
        : '';
      return `<span style="display: inline-flex; flex-direction: column; align-items: center; gap: 4px; min-width: 56px">${circleEl}${text}</span>`;
    })
    .join('')}</nav>`;
}

/** A flat bar on the raised surface, labels always: the captain and the restaurant. */
function flatBar(c: Ctx, items: NavItem[], selected: number): string {
  const h = c.surface === 'captain' ? 72 : 64;
  return `<nav style="display: flex; justify-content: space-around; height: ${h}px; background: ${tk(c, 'color.surface-raised')}; box-shadow: inset 0 1px 0 ${tk(c, 'color.border')}">${items
    .map((it, i) => {
      const on = i === selected;
      const b = it.badge
        ? `<span style="position: absolute; top: -6px; inset-inline-end: -14px">${countBadge(c, it.badge)}</span>`
        : it.dot
          ? `<span style="position: absolute; top: -2px; inset-inline-end: -4px; width: 10px; height: 10px; border-radius: 50%; background: ${tk(c, 'color.danger')}"></span>`
          : '';
      return `<span style="flex: 1; display: inline-flex; flex-direction: column; align-items: center; justify-content: center; gap: 4px; color: ${on ? tk(c, 'color.on-primary-subtle') : tk(c, 'color.on-surface-muted')}"><span style="position: relative; display: inline-flex; align-items: center; justify-content: center; width: 64px; height: 32px; border-radius: 999px; background: ${on ? tk(c, 'color.primary-subtle') : 'transparent'}">${svg(c.icon(it.icon), c.surface === 'captain' ? 26 : 24)}${b}</span><span style="${type(c, 'caption', on ? 700 : 500)}">${esc(it.text)}</span></span>`;
    })
    .join('')}</nav>`;
}

function rail(c: Ctx, items: NavItem[], selected: number, h: number): string {
  return `<nav style="display: flex; flex-direction: column; align-items: center; gap: 12px; width: 88px; height: ${h}px; padding-top: 16px; box-sizing: border-box; background: ${tk(c, 'color.surface-raised')}; box-shadow: inset -1px 0 0 ${tk(c, 'color.border')}">${items
    .map((it, i) => {
      const on = i === selected;
      const b = it.badge
        ? `<span style="position: absolute; top: -6px; inset-inline-end: -10px">${countBadge(c, it.badge)}</span>`
        : '';
      return `<span style="display: inline-flex; flex-direction: column; align-items: center; gap: 4px; color: ${on ? tk(c, 'color.on-primary-subtle') : tk(c, 'color.on-surface-muted')}"><span style="position: relative; display: inline-flex; align-items: center; justify-content: center; width: 56px; height: 32px; border-radius: 999px; background: ${on ? tk(c, 'color.primary-subtle') : 'transparent'}">${svg(c.icon(it.icon), 24)}${b}</span><span style="${type(c, 'caption', on ? 700 : 500)}">${esc(it.text)}</span></span>`;
    })
    .join('')}</nav>`;
}

interface SideItem {
  icon?: string;
  text: string;
  count?: string;
}

function sidebar(
  c: Ctx,
  items: SideItem[],
  selected: number,
  collapsed: boolean,
  h: number,
): string {
  const w = collapsed ? 72 : 248;
  const logo = `<div style="display: flex; align-items: center; gap: 10px; height: 56px; padding-inline: ${collapsed ? 0 : 16}px; ${collapsed ? 'justify-content: center;' : ''} ${type(c, 'subtitle', 700)} color: ${tk(c, 'color.heading')}"><span style="width: 32px; height: 32px; border-radius: 50%; background: ${tk(c, 'color.primary')}"></span>${collapsed ? '' : 'FOX DROP'}</div>`;
  const list = items
    .map((it, i) => {
      const on = i === selected;
      const ic = it.icon
        ? svg(c.icon(it.icon), 20)
        : `<span style="width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center"><span style="width: 6px; height: 6px; border-radius: 50%; background: currentColor"></span></span>`;
      const count = it.count
        ? collapsed
          ? `<span style="position: absolute; top: 2px; inset-inline-end: 6px">${countBadge(c, it.count)}</span>`
          : `<span style="margin-inline-start: auto">${countBadge(c, it.count)}</span>`
        : '';
      return `<span style="position: relative; display: flex; align-items: center; gap: 12px; height: 40px; ${collapsed ? 'justify-content: center; width: 48px; margin-inline: auto;' : 'margin-inline: 8px; padding-inline: 12px;'} border-radius: ${tk(c, 'radius.md')}; ${type(c, 'body', on ? 700 : 500)} background: ${on ? tk(c, 'color.primary-subtle') : 'transparent'}; color: ${on ? tk(c, 'color.on-primary-subtle') : tk(c, 'color.on-surface')}; ${on ? `box-shadow: inset -3px 0 0 ${tk(c, 'color.primary')}` : ''}">${ic}${collapsed ? '' : esc(it.text)}${count}</span>`;
    })
    .join('');
  const toggle = `<div style="margin-top: auto; display: flex; ${collapsed ? 'justify-content: center;' : 'padding-inline: 20px;'} align-items: center; gap: 8px; height: 48px; ${type(c, 'secondary')} color: ${tk(c, 'color.on-surface-muted')}">${svg(c.icon('back'), 18, 'currentColor', !collapsed)}${collapsed ? '' : 'طيّ القائمة'}</div>`;
  return `<nav style="display: flex; flex-direction: column; gap: 2px; width: ${w}px; height: ${h}px; flex: none; box-sizing: border-box; background: ${tk(c, 'color.surface-raised')}; box-shadow: inset 1px 0 0 ${tk(c, 'color.border')}">${logo}${list}${toggle}</nav>`;
}

// ---------- menu ----------

function menu(
  c: Ctx,
  items: (
    { icon?: string; text: string; danger?: boolean; focus?: boolean; hint?: string } | '-'
  )[],
  w = 240,
): string {
  const h = c.surface === 'panel' ? 40 : 48;
  return `<div role="menu" style="width: ${w}px; box-sizing: border-box; padding: 6px; border-radius: ${tk(c, 'radius.md')}; background: ${tk(c, 'color.surface-raised')}; box-shadow: ${tk(c, 'elevation.medium')}, inset 0 0 0 1px ${tk(c, 'color.border')}">${items
    .map((it) =>
      it === '-'
        ? `<div role="separator" style="height: 1px; margin: 6px 8px; background: ${tk(c, 'color.border')}"></div>`
        : `<div role="menuitem" style="display: flex; align-items: center; gap: 10px; height: ${h}px; padding-inline: 10px; border-radius: ${tk(c, 'radius.sm')}; ${type(c, 'body', 500)} color: ${it.danger ? tk(c, 'color.danger') : tk(c, 'color.on-surface')}; background: ${it.focus ? tk(c, 'color.surface-raised-hover') : 'transparent'}">${it.icon ? svg(c.icon(it.icon), 20) : '<span style="width: 20px"></span>'}<span style="flex: 1">${esc(it.text)}</span>${it.hint ? `<span style="${type(c, 'secondary')} color: ${tk(c, 'color.on-surface-muted')}">${esc(it.hint)}</span>` : ''}</div>`,
    )
    .join('')}</div>`;
}

// ---------- the sheet ----------

export function overlaysSheet(themes: Themes, config: GuideConfig, icons: Icon[]): Board {
  const icon = (name: string) => icons.find((i) => i.name === name)?.paths ?? MENU_ICON;
  const phone: Ctx = { themes, theme: 'light', surface: 'phone', scale: 1, icon };
  const panel: Ctx = { ...phone, surface: 'panel' };
  const captain: Ctx = { ...phone, theme: 'captainLight', surface: 'captain' };
  const resto: Ctx = phone;
  const muted = v(themes, 'color.on-surface-muted');
  const ink = v(themes, 'color.on-surface');

  // 1. Dialog.
  const simple = frame(
    phone,
    360,
    520,
    `${behind(phone, 7)}${scrim}<div style="position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; padding: 20px">${dialogBox(
      phone,
      320,
      'حذف هذا العنوان؟',
      `<p style="margin: 0; ${type(phone, 'body')} color: ${muted}">«البيت — حي الشهداء» يُحذف من عناوينك. طلباتك السابقة لا تتغيّر.</p>`,
      `${button(phone, 'حذف', 'danger', 'flex: 1')}${button(phone, 'إلغاء', 'secondary', `flex: 1; ${focusRing(phone)}`)}`,
    )}</div>`,
    'customer · centred · focus starts on «إلغاء», never on the destructive action',
  );
  const capDialog = frame(
    captain,
    360,
    520,
    `${behind(captain, 7)}${scrim}<div style="position: absolute; inset: 0; display: flex; align-items: flex-end; padding: 16px">${dialogBox(
      captain,
      328,
      'تعذّر التسليم؟',
      `<p style="margin: 0; ${type(captain, 'body')} color: ${tk(captain, 'color.on-surface-muted')}">اختر السبب في الخطوة التالية. العمليات تتصل بك.</p>`,
      `${button(captain, 'متابعة', 'danger', 'flex: 1')}${button(captain, 'رجوع', 'secondary', `flex: 1; ${focusRing(captain)}`)}`,
    )}</div>`,
    'captain · in the thumb zone, 56 tall actions',
  );
  const effectRow = (t: string, m: string) =>
    `<div style="display: flex; justify-content: space-between; gap: 12px; ${type(panel, 'body')}"><span>${esc(t)}</span>${m}</div>`;
  const who = (t: string) =>
    `<span style="display: inline-flex; align-items: center; gap: 6px; height: 28px; padding-inline: 10px; border-radius: 999px; background: ${v(themes, 'color.info-subtle')}; ${type(panel, 'secondary', 500)} color: ${v(themes, 'color.info')}">${svg(icon('bell'), 14)}${esc(t)}</span>`;
  const confirmBody = (filled: boolean) =>
    `<div style="display: flex; flex-direction: column; gap: 6px"><span style="${type(panel, 'secondary', 500)}">السبب <span style="color: ${v(themes, 'color.danger')}">*</span></span>${filled ? field(panel, 'الزبون طلب الإلغاء عبر الدعم') : field(panel, 'اكتب سبب الإلغاء', true, 'السبب مطلوب')}</div>
<div style="display: flex; flex-direction: column; gap: 8px; padding: 12px 14px; border-radius: ${v(themes, 'radius.md')}; background: ${v(themes, 'color.surface')}"><span style="${type(panel, 'secondary', 700)}">أثره على الأرصدة</span>${effectRow('يُعاد للزبون', money(panel, '470', '+', v(themes, 'color.success')))}${effectRow('يُخصم من المطعم', money(panel, '420', '−', v(themes, 'color.danger')))}${effectRow('عمولة المنصة', money(panel, '50', '−', v(themes, 'color.danger')))}<span style="${type(panel, 'caption')} color: ${muted}">من ملخص المبالغ (D.9) · قيود دفتر الحسابات تُكتب بعد التأكيد</span></div>
<div style="display: flex; flex-direction: column; gap: 6px"><span style="${type(panel, 'secondary', 700)}">سيُبلَّغ</span><div style="display: flex; flex-wrap: wrap; gap: 6px">${who('الزبون')}${who('المطعم')}${who('الكابتن')}</div></div>`;
  const confirmForm = (filled: boolean) =>
    dialogBox(
      panel,
      460,
      'إلغاء الطلب #10423',
      confirmBody(filled),
      `${button(panel, 'تأكيد الإلغاء', 'danger', filled ? '' : `background: ${v(themes, 'color.disabled')}; color: ${v(themes, 'color.on-disabled')}`)}${button(panel, 'تراجع', 'secondary', filled ? '' : focusRing(panel))}`,
    );
  const dialogCard = card(
    themes,
    h2(
      themes,
      'مربع الحوار',
      'title, body, one or two actions (destructive in danger, the safe one first in focus) · scrim · Escape, Android back and the × close it · focus trapped inside and returned to its trigger · enters with a fade and a 0.96→1 scale in duration.base, a fade only under reduced motion',
    ) +
      row(themes, [simple, capDialog]) +
      h2(
        themes,
        'نموذج التأكيد (AP §7.4)',
        'every destructive or financial action in the panel: the reason field (required, its error under it), the money-effect preview when ledgers move, and who is notified · the confirm button stays disabled until a reason is written',
      ) +
      row(
        themes,
        [
          cell(
            confirmForm(false),
            label(themes, 'empty: «تأكيد» disabled, the error shown after a try'),
          ),
          cell(confirmForm(true), label(themes, 'filled: ready')),
        ],
        'flex-start',
      ),
  );

  // 2. Bottom sheet (Flutter).
  const sTab = (w: number, title: string) => {
    const tabW = 210;
    const x0 = w - tabW;
    const path = `M0 64 Q0 40 24 40 L${x0 - 40} 40 C${x0 - 12} 40 ${x0 - 14} 0 ${x0 + 18} 0 L${w - 24} 0 Q${w} 0 ${w} 24 L${w} 64 Z`;
    return `<div style="position: relative; height: 64px"><svg aria-hidden="true" width="${w}" height="64" viewBox="0 0 ${w} 64" style="position: absolute; inset: 0; display: block"><path d="${path}" fill="${v(themes, 'color.surface')}"/></svg><span style="position: absolute; top: 8px; inset-inline-start: 22px; ${type(phone, 'subtitle', 700)} color: ${v(themes, 'color.heading')}">${esc(title)}</span><span style="position: absolute; top: 48px; inset-inline-end: 0; inset-inline-start: 0; margin: auto; width: 40px; height: 4px; border-radius: 2px; background: ${v(themes, 'color.border-strong')}"></span></div>`;
  };
  const itemSheet = frame(
    phone,
    360,
    640,
    `${behind(phone, 9)}${scrim}<div style="position: absolute; inset-inline: 0; bottom: 0; height: 480px; display: flex; flex-direction: column">${sTab(360, 'شاورما عربي')}<div style="flex: 1; display: flex; flex-direction: column; gap: 12px; padding: 4px 20px 0; background: ${v(themes, 'color.surface')}"><span style="${type(phone, 'secondary')} color: ${muted}">لحم، بطاطا، مخلل وثوم</span><div style="height: 150px; border-radius: ${v(themes, 'radius.lg')}; background: linear-gradient(135deg, #F6C9A8, #E89B6C); display: flex; align-items: center; justify-content: center; color: #7A3A12; font-size: 12px">${svg(icon('image'), 24, '#7A3A12')}</div><div style="display: flex; gap: 8px">${pillTabs(phone, ['وسط', 'كبير'], 0)}</div><div style="margin-top: auto; padding-bottom: 34px">${button(phone, 'أضف إلى السلة · 120 ₺', 'primary', `width: 100%; box-shadow: ${v(themes, 'elevation.offset')}`)}</div></div></div>`,
    'customer item sheet (CU §9): the S-curve tab holds the title (brand expression §2) · max 90% of the screen, the rest scrolls · the action above the home indicator (safe area)',
  );
  const statusBtn = (t: string, kind: 'primary' | 'secondary' = 'secondary') =>
    button(resto, t, kind, 'height: 48px; flex: 1');
  const statusSheet = frame(
    resto,
    420,
    640,
    `${behind(resto, 9)}${scrim}<div style="position: absolute; inset-inline: 0; bottom: 0; display: flex; flex-direction: column; gap: 14px; padding: 12px 20px 24px; border-radius: ${v(themes, 'radius.xl')} ${v(themes, 'radius.xl')} 0 0; background: ${v(themes, 'color.surface-raised')}"><span style="align-self: center; width: 40px; height: 4px; border-radius: 2px; background: ${v(themes, 'color.border-strong')}"></span><div style="display: flex; align-items: center; justify-content: space-between"><span style="${type(resto, 'title', 700)}">حالة المطعم</span>${svg(icon('close'), 24, muted)}</div><div style="display: flex; align-items: center; gap: 8px; ${type(resto, 'body', 500)} color: ${v(themes, 'color.success')}"><span style="width: 10px; height: 10px; border-radius: 50%; background: currentColor"></span>مفتوح · يغلق اليوم 11:30 م</div><span style="${type(resto, 'secondary', 700)}">إيقاف مؤقت</span><div style="display: flex; gap: 8px">${statusBtn('15 د')}${statusBtn('30 د')}${statusBtn('60 د')}</div>${statusBtn('حتى أعيد الفتح')}<span style="${type(resto, 'secondary', 700)}">وضع الضغط</span><div style="display: flex; gap: 8px">${statusBtn('+10 د')}${statusBtn('+20 د')}</div></div>`,
    'restaurant status sheet (RA §7.2): a plain top with the handle, radius xl · drag down or the scrim closes it · slides in duration.slow, a fade under reduced motion',
  );
  const selectAsMenu = `<div style="display: flex; flex-direction: column; gap: 6px; width: 260px">${field(phone, 'سوريا +963')}${menu(phone, [{ text: 'سوريا +963', focus: true }, { text: 'تركيا +90' }, { text: 'لبنان +961' }], 260)}</div>`;
  const selectAsSheet = `<div style="position: relative; width: 260px; height: 280px; overflow: hidden; border-radius: 20px; background: ${v(themes, 'color.surface')}">${scrim}<div style="position: absolute; inset-inline: 0; bottom: 0; padding: 10px 12px 16px; border-radius: ${v(themes, 'radius.xl')} ${v(themes, 'radius.xl')} 0 0; background: ${v(themes, 'color.surface-raised')}; display: flex; flex-direction: column; gap: 4px"><span style="align-self: center; width: 40px; height: 4px; border-radius: 2px; background: ${v(themes, 'color.border-strong')}"></span><span style="${type(phone, 'subtitle', 700)} padding: 6px 8px">رمز الدولة</span>${[
    'سوريا +963',
    'تركيا +90',
    'لبنان +961',
  ]
    .map(
      (t, i) =>
        `<span style="display: flex; align-items: center; justify-content: space-between; height: 48px; padding-inline: 8px; ${type(phone, 'body', i === 0 ? 700 : 400)}">${esc(t)}${i === 0 ? svg(icon('confirm'), 20, v(themes, 'color.primary')) : ''}</span>`,
    )
    .join('')}</div></div>`;
  const sheetCard = card(
    themes,
    h2(
      themes,
      'الورقة السفلية (Flutter)',
      'handle · drag down, the scrim, back and Escape close it · semantics name it by its title · keyboard pushes it up · never under the status bar',
    ) +
      row(themes, [itemSheet, statusSheet], 'flex-start') +
      h2(
        themes,
        'القائمة المنسدلة (D.8) على الهاتف',
        'question 3: the same FoxSelect API either way',
      ) +
      options(themes, [
        option(
          themes,
          'أ. ورقة سفلية على الهاتف',
          selectAsSheet,
          'phone widths (< 600 dp): the select opens as a sheet with 48 dp rows, in the thumb zone; tablets and Windows keep the menu · D.8 tests still pass',
          true,
        ),
        option(themes, 'ب. القائمة تحت الحقل في كل مكان', selectAsMenu, 'as D.8 built it'),
      ]),
  );

  // 3. Side drawer (web).
  const tableBehind = `<div style="position: absolute; inset: 0; display: flex"><div style="width: 248px; background: ${v(themes, 'color.surface-raised')}; box-shadow: inset 1px 0 0 ${v(themes, 'color.border')}"></div><div style="flex: 1; padding: 72px 24px 0; display: flex; flex-direction: column; gap: 2px">${Array.from({ length: 10 }, (_, i) => `<div style="height: 40px; background: ${i === 3 ? v(themes, 'color.primary-subtle') : v(themes, 'color.surface-raised')}; box-shadow: inset 0 -1px 0 ${v(themes, 'color.border')}"></div>`).join('')}</div></div>`;
  const drawer = `<aside role="dialog" style="position: absolute; top: 0; bottom: 0; inset-inline-end: 0; width: 440px; display: flex; flex-direction: column; background: ${v(themes, 'color.surface-raised')}; box-shadow: ${v(themes, 'elevation.high')}"><div style="display: flex; align-items: center; gap: 12px; height: 64px; padding-inline: 20px; box-shadow: inset 0 -1px 0 ${v(themes, 'color.border')}"><span style="flex: 1; ${type(panel, 'title', 700)} ${TNUM}">الطلب #10421</span><span style="${type(panel, 'secondary', 500)} color: ${v(themes, 'color.accent')}">فتح الصفحة</span>${svg(icon('close'), 20, muted)}</div><div style="padding: 0 20px">${underlineTabs(panel, [['التفاصيل'], ['السجل'], ['الملاحظات', '2']], 0)}</div><div style="padding: 16px 20px; display: flex; flex-direction: column; gap: 10px; ${type(panel, 'body')}">${[
    ['المطعم', 'كنافة أعزاز'],
    ['الكابتن', 'أحمد ع.'],
    ['الزبون', '0944 ••• •12'],
  ]
    .map(
      ([k, val]) =>
        `<div style="display: flex; justify-content: space-between"><span style="color: ${muted}">${esc(k!)}</span><span style="font-weight: 500">${esc(val!)}</span></div>`,
    )
    .join(
      '',
    )}<div style="display: flex; justify-content: space-between"><span style="color: ${muted}">المجموع</span>${money(panel, '1,120')}</div></div></aside>`;
  const drawerFrame = frame(
    panel,
    1040,
    520,
    `${tableBehind}${scrim}${drawer}`,
    'panel quick view (AP §7.4): opens from the end side (left in RTL), away from the sidebar on the start side · 440 wide, full height below 600 · Escape, × and the scrim close it · focus trapped, back to the row · slides in duration.slow, a fade under reduced motion',
    12,
  );
  const phoneSidebar = frame(
    panel,
    360,
    520,
    `<div style="position: absolute; inset: 0; padding: 64px 16px 0">${behind(panel, 6, 64)}</div>${scrim}<div style="position: absolute; top: 0; bottom: 0; inset-inline-start: 0">${sidebar(
      panel,
      [
        { icon: 'home', text: 'لوحة التحكم' },
        { icon: 'orders', text: 'غرفة العمليات', count: '3' },
        { icon: 'map', text: 'الخريطة الحية' },
        { icon: 'receipt', text: 'سجل الطلبات' },
        { icon: 'chat', text: 'الدعم', count: '12' },
      ],
      1,
      false,
      520,
    )}</div>`,
    'the sidebar below the tablet width (AP §7.5): the same component as a drawer from the start side, opened by the proposed «menu» icon in the top bar',
  );
  const drawerCard = card(
    themes,
    h2(
      themes,
      'الدرج الجانبي (الويب)',
      'one component, two sides: end for a quick view, start for the sidebar on a phone',
    ) + row(themes, [drawerFrame, phoneSidebar], 'flex-start'),
  );

  // 4. Toast.
  const tones: [Tone, string, string?][] = [
    ['success', 'حُفظت التغييرات'],
    ['info', 'نُسخ رقم الطلب'],
    ['warning', 'الصورة كبيرة، ضغطناها قبل الرفع'],
    ['danger', 'تعذّر الحفظ', 'أعد المحاولة'],
  ];
  const toastPlaces = (() => {
    const phoneFrame = frame(
      phone,
      300,
      420,
      `${behind(phone, 6, 24)}<div style="position: absolute; inset-inline: 12px; bottom: 96px">${toast(phone, 'success', 'أُضيف إلى السلة', 'dark', 'عرض السلة', 276)}</div><div style="position: absolute; inset-inline: 12px; bottom: 12px">${pillBar(
        phone,
        [
          { icon: 'home', text: 'الرئيسية' },
          { icon: 'search', text: 'البحث' },
          { icon: 'orders', text: 'طلباتي' },
          { icon: 'account', text: 'حسابي' },
        ],
        0,
        false,
      )}</div>`,
      'phones: above the bottom navigation, one at a time; a new one replaces the old',
    );
    const webFrame = frame(
      panel,
      520,
      420,
      `<div style="position: absolute; inset: 0; display: flex"><div style="width: 160px; background: ${v(themes, 'color.surface-raised')}"></div><div style="flex: 1"></div></div><div style="position: absolute; inset-inline-end: 16px; bottom: 16px; display: flex; flex-direction: column; gap: 8px">${toast(panel, 'info', 'نُسخ رقم الطلب', 'dark', '', 300)}${toast(panel, 'danger', 'تعذّر الحفظ', 'dark', 'أعد المحاولة', 300)}</div>`,
      'web: the bottom end corner (left in RTL), away from the sidebar, up to three stacked',
      12,
    );
    return row(themes, [phoneFrame, webFrame], 'flex-start');
  })();
  const toastCard = card(
    themes,
    h2(
      themes,
      'الإشعار المؤقت (Toast)',
      'a short result of the user’s own action, never the only signal of an alert (AP §7.3 alerts are banners with sound) · polite live region, assertive for danger · success and info 4 s, warning 6 s, with an action 8 s, danger stays until closed · hover and focus pause the timer · its action and × reachable by keyboard · fades and rises 8 px in duration.base; a fade only under reduced motion',
    ) +
      options(themes, [
        option(
          themes,
          'أ. داكن (أزرق العلامة)',
          `<div style="display: flex; flex-direction: column; gap: 8px">${tones.map(([t, s, a]) => toast(phone, t, s, 'dark', a)).join('')}</div>`,
          `stands out over any screen, ivory text ${ratio('#FFFFFF', '#03428E')}:1 · the tone is in the icon and its word, never colour alone`,
          true,
        ),
        option(
          themes,
          'ب. فاتح بلون الحالة',
          `<div style="display: flex; flex-direction: column; gap: 8px">${tones.map(([t, s, a]) => toast(phone, t, s, 'tint', a)).join('')}</div>`,
          'the same tints as the status chip; quieter, but it can be lost over a light card',
        ),
      ]) +
      toastPlaces,
  );

  // 5. Alert banner and stack.
  const toneRow = (t: Tone, name: string, text: string, action?: string, solid?: boolean) =>
    `<div style="display: flex; align-items: center; gap: 16px"><span style="width: 120px; flex: none">${label(themes, name)}</span>${banner(resto, t, text, { action, solid, w: 620 })}</div>`;
  const bannerTones = `<div style="display: flex; flex-direction: column; gap: 8px">
${toneRow('danger', 'red · solid', 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال', undefined)}
${toneRow('caution', 'yellow · new', 'فشل فحص الجهاز: الإشعارات متوقفة', 'افتح الإعدادات')}
${toneRow('warning', 'amber', 'وضع الضغط مفعّل: +10 د على وقت التحضير', 'إلغاء')}
${toneRow('info', 'blue', 'وضع التجربة: الطلبات لا تصل للزبائن')}
${toneRow('neutral', 'grey', 'يتوفر تحديث للتطبيق', 'تحديث')}
</div>`;
  const solidOrTint = options(themes, [
    option(
      themes,
      'أ. الأحمر مصمت، والبقية فاتحة',
      `<div style="display: flex; flex-direction: column; gap: 6px">${banner(resto, 'danger', 'لا يوجد اتصال بالإنترنت', { w: '100%' })}${banner(resto, 'warning', 'وضع الضغط مفعّل', { w: '100%' })}</div>`,
      `red means work stops (no connection, emergency stop, suspended): the solid bar reads first · white on red ${ratio('#FFFFFF', '#BF2929')}:1`,
      true,
    ),
    option(
      themes,
      'ب. كلها فاتحة',
      `<div style="display: flex; flex-direction: column; gap: 6px">${banner(resto, 'danger', 'لا يوجد اتصال بالإنترنت', { w: '100%', solid: false })}${banner(resto, 'warning', 'وضع الضغط مفعّل', { w: '100%' })}</div>`,
      'calmer; red and amber differ less at a glance',
    ),
    option(
      themes,
      'ج. كلها مصمتة',
      `<div style="display: flex; flex-direction: column; gap: 6px">${banner(resto, 'danger', 'لا يوجد اتصال بالإنترنت', { w: '100%' })}${banner(resto, 'warning', 'وضع الضغط مفعّل', { w: '100%', solid: true })}</div>`,
      'loud: every banner shouts',
    ),
  ]);
  const yellowNote = label(
    themes,
    `question 5 · yellow is a new tone (RA §6.3 and CA §6.3 name yellow beside amber): color.caution ${PROPOSED.caution} on color.caution-subtle ${PROPOSED.cautionSubtle}, ${ratio(PROPOSED.caution, PROPOSED.cautionSubtle)}:1 · amber is warning on warning-subtle, ${ratio('#8A5A00', '#FBEFD5')}:1 · grey is neutral on neutral-subtle, ${ratio('#4D473D', '#EFE8DA')}:1`,
  );
  const topBarResto = (c: Ctx, w: number) =>
    `<div style="display: flex; align-items: center; gap: 12px; height: 64px; padding-inline: 16px; background: ${tk(c, 'color.surface-raised')}; box-shadow: inset 0 -1px 0 ${tk(c, 'color.border')}; width: ${w}px; box-sizing: border-box"><span style="${type(c, 'subtitle', 700)}">برجر كبصو</span><span style="display: inline-flex; align-items: center; gap: 6px; height: 36px; padding-inline: 12px; border-radius: 999px; background: ${tk(c, 'color.success-subtle')}; color: ${tk(c, 'color.success')}; ${type(c, 'secondary', 700)}">مفتوح ${svg(icon('chevron-down'), 16)}</span><span style="display: inline-flex; align-items: center; gap: 6px; ${type(c, 'caption', 500)} color: ${tk(c, 'color.danger')}"><span style="width: 10px; height: 10px; border-radius: 50%; background: currentColor"></span>غير متصل</span><span style="margin-inline-start: auto">${iconButton(c, 'chat', { px: 48 })}</span></div>`;
  const stackCollapsed = `<div style="width: 620px">${topBarResto(resto, 620)}${banner(resto, 'danger', 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال')}${banner(resto, 'danger', 'المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة', { icon: 'warning' })}<div style="display: flex; justify-content: flex-end; padding: 6px 12px; background: ${v(themes, 'color.surface')}"><span style="display: inline-flex; align-items: center; gap: 6px; height: 32px; padding-inline: 12px; border-radius: 999px; background: ${v(themes, 'color.surface-raised')}; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}; ${type(resto, 'secondary', 700)}">+3 تنبيهات أخرى ${svg(icon('chevron-down'), 16)}</span></div></div>`;
  const stackOpen = `<div style="width: 620px">${topBarResto(resto, 620)}${banner(resto, 'danger', 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال')}${banner(resto, 'danger', 'المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة', { icon: 'warning' })}${banner(resto, 'caution', 'فشل فحص الجهاز: الإشعارات متوقفة', { action: 'افتح الإعدادات' })}${banner(resto, 'warning', 'التسوية متأخرة 3 أيام', { action: 'التفاصيل' })}${banner(resto, 'neutral', 'يتوفر تحديث للتطبيق', { action: 'تحديث' })}<div style="display: flex; justify-content: flex-end; padding: 6px 12px; background: ${v(themes, 'color.surface')}"><span style="display: inline-flex; align-items: center; gap: 6px; height: 32px; padding-inline: 12px; border-radius: 999px; ${type(resto, 'secondary', 700)}">إخفاء ${svg(icon('chevron-down'), 16, 'currentColor')}</span></div></div>`;
  const captainOffline = `<div style="width: 360px">${banner(captain, 'danger', 'لا يوجد اتصال بالإنترنت — لن تصلك العروض حتى يعود الاتصال', { icon: 'offline' })}</div>`;
  const customerOffline = `<div style="width: 360px">${banner(phone, 'neutral', 'لا يوجد اتصال بالإنترنت. نعرض آخر ما حُفظ.', { icon: 'offline', action: 'أعد المحاولة' })}</div>`;
  const blocking = frame(
    panel,
    720,
    300,
    `<div style="position: absolute; inset: 0; display: flex"><div style="width: 200px; background: ${v(themes, 'color.surface-raised')}"></div><div style="flex: 1; padding: 64px 16px 0">${behind(panel, 4, 72)}</div></div>${scrim}<div style="position: absolute; inset-inline: 0; top: 0; display: flex; align-items: center; gap: 12px; padding: 14px 20px; background: ${v(themes, 'color.alert')}; color: ${v(themes, 'color.on-alert')}">${svg(icon('bell'), 24)}<span style="flex: 1; ${type(panel, 'body', 700)}">اضغط لتفعيل صوت التنبيهات</span><span style="display: inline-flex; align-items: center; height: 40px; padding-inline: 18px; border-radius: 999px; background: ${v(themes, 'color.on-alert')}; color: ${v(themes, 'color.alert')}; ${type(panel, 'body', 700)} ${focusRing(panel)}">تفعيل الصوت</span></div>`,
    `AP §7.3: after sign-in, a scrim over the page and this bar on top (layer.blocking) until sound plays · the whole bar is the button, focus starts on it · white on color.alert ${ratio('#FFFFFF', '#8C1530')}:1`,
    12,
  );
  const bannerCard = card(
    themes,
    h2(
      themes,
      'شريط التنبيه وكومة الشرائط',
      'under the top bar, full width · icon + words in every tone, never colour alone · optional action at the end · role status (alert for red) · no motion beyond a fade in duration.base',
    ) +
      bannerTones +
      yellowNote +
      h2(themes, 'لون الأحمر', 'question 4') +
      solidOrTint +
      h2(
        themes,
        'الكومة (RA §6.3، CA §6.3، CU §6.2)',
        'the app passes its banners in its priority order; the first two show, the rest behind a counter that opens them in place · a banner that clears leaves at once and the next moves up',
      ) +
      row(
        themes,
        [
          cell(stackCollapsed, label(themes, 'restaurant: two and «+3»')),
          cell(stackOpen, label(themes, 'opened: all five, «إخفاء» folds them')),
        ],
        'flex-start',
      ) +
      row(
        themes,
        [
          cell(captainOffline, label(themes, 'captain offline (CA §4.6), 56 tall')),
          cell(
            customerOffline,
            label(themes, 'customer offline (R6): grey, cached content stays usable'),
          ),
        ],
        'flex-start',
      ) +
      h2(themes, 'شريط الصوت الحاجب (الويب)') +
      blocking,
  );

  // 6. Menu and 7. Tooltip.
  const userMenuWeb = `<div style="display: flex; flex-direction: column; align-items: flex-start; gap: 8px"><span style="display: inline-flex; align-items: center; gap: 8px; height: 40px; padding-inline: 4px 12px; border-radius: 999px; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}; ${type(panel, 'body', 500)}"><span style="width: 32px; height: 32px; border-radius: 50%; background: ${v(themes, 'color.info-subtle')}; display: inline-flex; align-items: center; justify-content: center">${svg(icon('account'), 18, ink)}</span>سارة م. ${svg(icon('chevron-down'), 16)}</span>${menu(
    panel,
    [
      { icon: 'account', text: 'الملف الشخصي', focus: true },
      { icon: 'settings', text: 'الجلسات' },
      '-',
      { icon: 'back', text: 'تسجيل الخروج', danger: true },
    ],
  )}</div>`;
  const orderMenu = menu(phone, [
    { icon: 'edit', text: 'تعديل' },
    { icon: 'share', text: 'مشاركة' },
    '-',
    { icon: 'delete', text: 'حذف من السلة', danger: true },
  ]);
  const tip = (text: string, under: string) =>
    `<div style="display: flex; flex-direction: column; align-items: center; gap: 6px">${under}<span style="position: relative; display: inline-block; white-space: nowrap; padding: 6px 10px; border-radius: ${v(themes, 'radius.sm')}; background: ${ink}; color: ${v(themes, 'color.on-accent')}; ${type(panel, 'secondary', 500)}"><span style="position: absolute; top: -4px; inset-inline-start: calc(50% - 4px); width: 8px; height: 8px; background: ${ink}; transform: rotate(45deg)"></span>${esc(text)}</span></div>`;
  const menuCard = card(
    themes,
    h2(
      themes,
      'القائمة',
      'raised surface, elevation.medium · rows 40 on the web, 48 in Flutter · icon, text, an optional hint · a destructive item in danger, after a separator · arrows, Home, End and type-ahead; Escape returns focus · opens under its trigger, aligned to its start (right in RTL), flips when there is no room · fade in duration.fast',
    ) +
      row(
        themes,
        [
          cell(
            userMenuWeb,
            label(
              themes,
              'panel user menu (AP §7.2): profile, sessions, sign out (no sign-out icon yet: back stands in, question 7)',
            ),
          ),
          cell(orderMenu, label(themes, 'phone: «⋯» on a cart line')),
        ],
        'flex-start',
      ) +
      h2(
        themes,
        'التلميح (الويب)',
        'navy (on-surface) with ivory text · shows on hover after 500 ms and at once on keyboard focus, hides on leave, blur and Escape · it describes; the trigger keeps its own name (aria-describedby) · touch: no tooltip, the label is visible',
      ) +
      row(themes, [
        cell(
          tip('الإشعارات المفتوحة: 4', iconButton(panel, 'bell', { badge: '4' })),
          label(themes, 'an icon button'),
        ),
        cell(
          tip(
            'غرفة العمليات',
            `<span style="display: inline-flex; width: 48px; height: 40px; align-items: center; justify-content: center; border-radius: ${v(themes, 'radius.md')}; background: ${v(themes, 'color.primary-subtle')}; color: ${v(themes, 'color.on-primary-subtle')}">${svg(icon('orders'), 20)}</span>`,
          ),
          label(themes, 'the collapsed sidebar'),
        ),
      ]),
  );

  // 8. Tabs.
  const tabsCard = card(
    themes,
    h2(
      themes,
      'التبويبات',
      'one tab stop; arrows follow reading order (→ moves to the previous in RTL), Home and End · the selected tab is announced with its count · overflow scrolls sideways and keeps the selected tab in view, faded edges show there is more',
    ) +
      row(
        themes,
        [
          cell(
            underlineTabs(panel, [['التفاصيل'], ['المالية'], ['السجل'], ['الملاحظات', '2']], 0, 2),
            label(
              themes,
              'panel detail page (AP §7.4): underline, 40 tall · focus ring on «السجل»',
            ),
          ),
          cell(
            `<div style="width: 360px">${underlineTabs(resto, [['جديدة', '3'], ['قيد التحضير', '5'], ['جاهزة'], ['مع الكابتن']], 0)}</div>`,
            label(
              themes,
              'restaurant board on a phone (RA §8): the four columns as tabs with counts, overflow',
            ),
          ),
        ],
        'flex-start',
      ) +
      row(
        themes,
        [
          cell(
            pillTabs(phone, ['الكل', 'برجر', 'شاورما', 'حلويات'], 1),
            label(
              themes,
              'customer: pill tabs, the active one orange with the offset shadow (menu sections, CU §9)',
            ),
          ),
          cell(
            `<div style="width: 360px">${underlineTabs(captain, [['اليوم'], ['الأسبوع'], ['الشهر']], 0)}</div>`,
            label(themes, 'captain: underline, 56 tall'),
          ),
        ],
        'flex-start',
      ),
  );

  // 9. Top bar.
  const slot = (inner: string, name: string) =>
    `<span style="display: inline-flex; flex-direction: column; align-items: center; gap: 4px">${inner}${label(themes, name)}</span>`;
  const panelTop = `<div style="display: flex; align-items: flex-start; gap: 16px; padding: 12px 20px; width: 1300px; box-sizing: border-box; background: ${v(themes, 'color.surface-raised')}; box-shadow: inset 0 -1px 0 ${v(themes, 'color.border')}">${slot(`<span style="display: inline-flex; align-items: center; gap: 6px; height: 40px; padding-inline: 12px; border-radius: 999px; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border-strong')}; ${type(panel, 'body', 500)}">${svg(icon('drop-pin'), 18)}أعزاز ${svg(icon('chevron-down'), 16)}</span>`, 'city')}${slot(`<span style="display: inline-flex; align-items: center; gap: 6px; height: 40px; padding-inline: 12px; border-radius: 999px; background: ${v(themes, 'color.success-subtle')}; color: ${v(themes, 'color.success')}; ${type(panel, 'body', 700)}"><span style="width: 8px; height: 8px; border-radius: 50%; background: currentColor"></span>المنصة تعمل</span>`, 'platform status')}${slot(`<span style="display: inline-flex; align-items: center; gap: 6px; height: 40px; padding-inline: 12px; border-radius: 999px; background: ${v(themes, 'color.surface')}; ${type(panel, 'body', 500)}">التوزيع: مختلط</span>`, 'dispatch mode')}${slot(`<span style="display: inline-flex; align-items: center; gap: 8px; width: 360px; height: 40px; padding-inline: 14px; border-radius: 999px; background: ${v(themes, 'color.surface')}; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}; ${type(panel, 'body')} color: ${muted}">${svg(icon('search'), 18)}رقم طلب، مطعم، كابتن، تذكرة…</span>`, 'global search')}<span style="flex: 1"></span>${slot(iconButton(panel, 'bell', { badge: '4' }), 'alerts, read «التنبيهات، 4 مفتوحة»')}${slot(iconButton(panel, 'success', { badge: '2' }), 'approvals (OWN)')}${slot(`<span style="display: inline-flex; align-items: center; gap: 8px; height: 40px; padding-inline: 4px 12px; border-radius: 999px; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}; ${type(panel, 'body', 500)}"><span style="width: 32px; height: 32px; border-radius: 50%; background: ${v(themes, 'color.info-subtle')}; display: inline-flex; align-items: center; justify-content: center">${svg(icon('account'), 18, ink)}</span>سارة م. ${svg(icon('chevron-down'), 16)}</span>`, 'user menu')}</div>`;
  const emergency = `<span style="display: inline-flex; align-items: center; gap: 6px; height: 40px; padding-inline: 12px; white-space: nowrap; border-radius: 999px; background: ${v(themes, 'color.danger')}; color: ${v(themes, 'color.on-danger')}; ${type(panel, 'body', 700)}">${svg(icon('warning'), 18)}إيقاف طارئ</span>`;
  const phoneBack = (c: Ctx, title: string, end: string) =>
    `<div style="display: flex; align-items: center; gap: 12px; width: 360px; height: 64px; padding-inline: 16px; box-sizing: border-box; background: ${tk(c, 'color.surface')}">${iconButton(c, 'back', { px: 44 })}<span style="flex: 1; ${type(c, 'title', 700)} color: ${tk(c, 'color.heading')}">${esc(title)}</span>${end}</div>`;
  const topCard = card(
    themes,
    h2(
      themes,
      'الشريط العلوي',
      'slots, not fixed content: each app fills its own · every slot has a name; a count is read with its label; the connection dot has a word beside it · sticky (layer.sticky), banners sit under it',
    ) +
      `<div style="overflow: hidden">${panelTop}</div>` +
      row(themes, [
        cell(
          emergency,
          label(
            themes,
            'emergency stop: red; it flashes twice a second, still under reduced motion (AP §7.2)',
          ),
        ),
      ]) +
      row(
        themes,
        [
          cell(
            topBarResto(resto, 620),
            label(
              themes,
              'restaurant (RA §6.2): name, status pill (opens the status sheet), connection dot with its word, support button',
            ),
          ),
        ],
        'flex-start',
      ) +
      row(
        themes,
        [
          cell(
            phoneBack(phone, 'سلة المشتريات', iconButton(phone, 'delete', { px: 44 })),
            label(
              themes,
              'customer: the Figma file’s round back button and orange title, an optional end action',
            ),
          ),
          cell(
            phoneBack(captain, 'عهدتي', ''),
            label(themes, 'captain: the same bar, captain theme'),
          ),
          cell(
            `<div style="display: flex; align-items: center; gap: 12px; width: 360px; height: 64px; padding-inline: 16px; box-sizing: border-box; background: ${v(themes, 'color.surface-raised')}; box-shadow: inset 0 -1px 0 ${v(themes, 'color.border')}">${iconButton(panel, 'menu', { px: 40 })}<span style="flex: 1; ${type(panel, 'subtitle', 700)}">غرفة العمليات</span>${iconButton(panel, 'bell', { badge: '4' })}</div>`,
            label(themes, 'panel on a phone: the «menu» icon opens the sidebar drawer'),
          ),
        ],
        'flex-start',
      ),
  );

  // 10. Sidebar (web).
  const modules: SideItem[] = [
    { icon: 'home', text: 'لوحة التحكم' },
    { icon: 'orders', text: 'غرفة العمليات', count: '3' },
    { icon: 'map', text: 'الخريطة الحية' },
    { icon: 'receipt', text: 'سجل الطلبات' },
    { icon: 'restaurant', text: 'المطاعم' },
    { icon: 'motorcycle', text: 'الكباتن' },
    { icon: 'account', text: 'الزبائن' },
    { icon: 'chat', text: 'الدعم', count: '12' },
    { icon: 'wallet', text: 'المالية' },
    { icon: 'discount', text: 'التسويق' },
    { text: 'المناطق والتسعير' },
    { icon: 'image', text: 'المحتوى' },
    { icon: 'settings', text: 'الإعدادات' },
    { text: 'فريق الإدارة' },
    { text: 'سجل التدقيق' },
    { text: 'التقارير' },
  ];
  const portal: SideItem[] = [
    { icon: 'orders', text: 'الطلبات' },
    { icon: 'clock', text: 'السجل' },
    { icon: 'plate', text: 'القائمة' },
    { icon: 'restaurant', text: 'الحالة والأوقات' },
    { text: 'التقارير' },
    { icon: 'wallet', text: 'الحساب' },
    { icon: 'star', text: 'التقييمات' },
    { text: 'الموظفون والأجهزة' },
    { icon: 'settings', text: 'الإعدادات' },
    { icon: 'chat', text: 'الدعم' },
  ];
  const sidebarCard = card(
    themes,
    h2(
      themes,
      'الشريط الجانبي (الويب)',
      'one component for the panel (AP §7.1) and the portal (RA §17): on the start side (right in RTL) · links with aria-current on the active page · the active item tinted with an orange start edge · counts at the end · collapsed to 72: icons with tooltips that keep the names · below 1024 it becomes the drawer',
    ) +
      row(
        themes,
        [
          cell(
            sidebar(panel, modules, 1, false, 860),
            label(themes, 'panel, 16 modules (each user sees only theirs)'),
          ),
          cell(sidebar(panel, modules, 1, true, 860), label(themes, 'collapsed')),
          cell(sidebar(panel, portal, 2, false, 560), label(themes, 'owner portal')),
          cell(
            `<div style="width: 420px; display: flex; flex-direction: column; gap: 8px; ${type(panel, 'body')} line-height: 1.7"><b>question 6 · missing icons</b><span>Five panel modules (zones, team, audit, reports, and staff in the portal) have no icon in batch 1; brand expression §10 puts them in the panel's second batch. Until it lands they show a dot, as drawn, and the collapsed form waits: the panel opens expanded.</span><span>Also missing: «menu» (three lines, drawn here) for the phone form, and a sign-out icon.</span></div>`,
          ),
        ],
        'flex-start',
      ),
  );

  // 11. Bottom navigation (Flutter).
  const cuItems: NavItem[] = [
    { icon: 'home', text: 'الرئيسية' },
    { icon: 'search', text: 'البحث' },
    { icon: 'orders', text: 'طلباتي', badge: '1' },
    { icon: 'account', text: 'حسابي' },
  ];
  const caItems: NavItem[] = [
    { icon: 'home', text: 'الرئيسية' },
    { icon: 'wallet', text: 'أرباحي' },
    { icon: 'cash', text: 'عهدتي', dot: true },
    { icon: 'more', text: 'المزيد' },
  ];
  const raItems: NavItem[] = [
    { icon: 'orders', text: 'الطلبات', badge: '3' },
    { icon: 'plate', text: 'القائمة' },
    { icon: 'restaurant', text: 'الحالة' },
    { icon: 'more', text: 'المزيد' },
  ];
  const navCard = card(
    themes,
    h2(
      themes,
      'شريط التنقل السفلي (Flutter)',
      'four items (CU §6.1, CA §6.2, RA §6.2) · each a 48 dp target at least, the selected one announced as selected, a badge read with its item («طلباتي، 1 جديد») · sits above the home indicator (safe area), in the thumb zone · the active-order bar and the floating cart (CU §6.1) sit above it in the screen slices',
    ) +
      h2(themes, 'الزبون', 'question 1') +
      options(themes, [
        option(
          themes,
          'أ. شريط الملف العائم مع أسماء',
          `<div style="width: 360px">${pillBar(phone, cuItems, 0, true)}</div>`,
          'the Figma file’s blue pill and circles, the active circle orange with a pressed edge · the names under the circles, for first-time users',
          true,
        ),
        option(
          themes,
          'ب. كما في الملف: أيقونات فقط',
          `<div style="width: 360px">${pillBar(phone, cuItems, 0, false)}</div>`,
          'faithful to the file; the names live only in semantics and a long-press tip',
        ),
      ]) +
      h2(
        themes,
        'الكابتن والمطعم',
        'a flat bar on the raised surface, names always: short, direct, readable in sunlight',
      ) +
      row(
        themes,
        [
          cell(
            `<div style="width: 360px">${flatBar(captain, caItems, 0)}</div>`,
            label(themes, 'captain, 72 tall, the custody dot'),
          ),
          cell(
            `<div style="width: 360px">${flatBar(resto, raItems, 0)}</div>`,
            label(themes, 'restaurant phone, 64 tall, new orders counted'),
          ),
        ],
        'flex-start',
      ),
  );

  // 12. Rail and 13. Pull to refresh.
  const railFrame = frame(
    resto,
    760,
    420,
    `<div style="position: absolute; inset: 0; display: flex"><div style="display: flex; flex-direction: column">${rail(
      resto,
      [
        { icon: 'orders', text: 'الطلبات', badge: '3' },
        { icon: 'clock', text: 'السجل' },
        { icon: 'plate', text: 'القائمة' },
        { icon: 'restaurant', text: 'الحالة' },
        { icon: 'star', text: 'التقييمات' },
        { icon: 'settings', text: 'الإعدادات' },
      ],
      0,
      420,
    )}</div><div style="flex: 1; display: flex; flex-direction: column">${topBarResto(resto, 672)}<div style="flex: 1; display: flex; gap: 8px; padding: 12px">${['جديدة', 'قيد التحضير', 'جاهزة', 'مع الكابتن'].map((t) => `<div style="flex: 1; border-radius: ${v(themes, 'radius.md')}; background: ${v(themes, 'color.surface-raised')}; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}; padding: 8px; ${type(resto, 'secondary', 700)}">${esc(t)}</div>`).join('')}</div></div></div>`,
    'restaurant tablet (840 dp or wider) and Windows (RA §6.2): the rail on the start side, the board in four columns · Tab and arrows move along it on Windows',
    16,
  );
  const ptr = (variant: 'ring' | 'drop') => {
    const ind =
      variant === 'ring'
        ? `<span style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; background: ${v(themes, 'color.surface-raised')}; box-shadow: ${v(themes, 'elevation.medium')}"><svg width="24" height="24" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9" fill="none" stroke="${v(themes, 'color.primary')}" stroke-width="3" stroke-linecap="round" stroke-dasharray="40 100"/></svg></span>`
        : `<span style="display: inline-flex; width: 40px; height: 40px"><svg width="40" height="40" viewBox="0 0 24 24" aria-hidden="true"><defs><linearGradient id="fill" x1="0" y1="1" x2="0" y2="0"><stop offset="0.55" stop-color="${v(themes, 'color.primary')}"/><stop offset="0.55" stop-color="${v(themes, 'color.primary-subtle')}"/></linearGradient></defs><path d="M12 23s9-8.4 9-14.5a9 9 0 0 0-18 0C3 14.6 12 23 12 23Z" fill="url(#fill)" stroke="${v(themes, 'color.primary')}" stroke-width="0.8"/></svg></span>`;
    return `<div style="position: relative; width: 280px; height: 240px; overflow: hidden; border-radius: 20px; background: ${v(themes, 'color.surface')}; box-shadow: inset 0 0 0 1px ${v(themes, 'color.border')}"><div style="display: flex; justify-content: center; padding-top: 16px">${ind}</div>${behind(phone, 3, 76)}</div>`;
  };
  const railCard = card(
    themes,
    h2(
      themes,
      'شريط التنقل الجانبي للمطعم (Flutter)',
      'the same items as «المزيد» opens on a phone, all of them shown',
    ) +
      railFrame +
      h2(
        themes,
        'السحب للتحديث (Flutter)',
        'question 2 · the callback runs once per pull, the indicator holds until it completes · a semantics action «تحديث» refreshes without the gesture · still under reduced motion: the indicator shows without spinning',
      ) +
      options(themes, [
        option(
          themes,
          'أ. حلقة برتقالية',
          ptr('ring'),
          'the platform indicator (Material) themed from the tokens: familiar, nothing new to maintain',
          true,
        ),
        option(
          themes,
          'ب. القطرة تمتلئ',
          ptr('drop'),
          'the logo’s drop fills as you pull, then pulses while loading: drawn in code, more to build and test',
        ),
      ]),
  );

  // 14. Motion and layers.
  const tr = (cells: string[]) =>
    `<tr>${cells.map((t, i) => `<td style="padding: 6px 12px; ${i === 0 ? 'font-weight: 500;' : ''} box-shadow: inset 0 -1px 0 ${v(themes, 'color.border')}">${esc(t)}</td>`).join('')}</tr>`;
  const motion = `<table style="border-collapse: collapse; ${type(panel, 'body')}">${[
    [
      'dialog, menu',
      'duration.base / duration.fast, easing.standard',
      'fade + scale 0.96→1',
      'fade only',
    ],
    [
      'bottom sheet, side drawer',
      'duration.slow, easing.standard',
      'slide from its edge',
      'fade only',
    ],
    ['toast', 'duration.base', 'fade + rise 8 px', 'fade only'],
    ['banner', 'duration.base', 'fade', 'instant'],
    ['tooltip', 'duration.fast after a 500 ms delay', 'fade', 'fade'],
    ['tabs, bottom navigation, rail', 'duration.fast', 'the indicator slides', 'instant'],
  ]
    .map(tr)
    .join('')}</table>`;
  const layers = `<table style="border-collapse: collapse; ${type(panel, 'body')}">${PROPOSED.layers.map((l) => tr(l)).join('')}${tr(['color.scrim', 'neutral 900 at 48%', 'behind dialogs, sheets and drawers'])}</table>`;
  const motionCard = card(
    themes,
    h2(themes, 'الحركة', 'existing tokens only; reduced motion is the system setting') +
      motion +
      h2(themes, 'رموز جديدة مقترحة', 'question 5 · tokens 0.8.0') +
      layers,
  );

  // 15. What the owner approved.
  const questions = card(
    themes,
    h2(themes, 'ما اعتمده المالك', '2026-11-24') +
      `<ol style="margin: 0; padding-inline-start: 24px; display: flex; flex-direction: column; gap: ${v(themes, 'space.xs')}; line-height: 1.7">
<li>الشريط السفلي: شريط الملف العائم كما هو تماماً، أيقونات فقط، في التطبيقات الثلاثة؛ عناصر الزبون الأربعة من المواصفة مع زر السلة العائم.</li>
<li>السحب للتحديث: (ب) قطرة الشعار تمتلئ.</li>
<li>القائمة المنسدلة على الهاتف: (ب) تبقى قائمة تحت الحقل.</li>
<li>الشرائط: (أ) الأحمر مصمت والبقية فاتحة.</li>
<li>الرموز 0.8.0: الأصفر (caution)، التعتيم (scrim)، ترتيب الطبقات (layer.*) ومقاسات الطبقات والأشرطة.</li>
<li>الأيقونات الناقصة: نقطة حتى دفعة أيقونات اللوحة؛ أُضيفت أيقونة «القائمة».</li>
<li>الإشعار المؤقت: (أ) داكن أزرق.</li>
</ol>`,
  );

  const body = [
    heading(
      themes,
      'الطبقات والتنقل — الدفعة الرابعة (مُستبدَلة)',
      'Superseded (architecture §9.9 step 4): the record of the approval only; the components live in the Design System (ui-web) and core_ui (Flutter), slice D.10. Overlays and navigation — batch 4 (architecture §9.9 step 1, slice D.10). Dialog and the AP §7.4 confirmation form, bottom sheet, side drawer, toast, alert banner and the banner stack, menu, tooltip, tabs, top bar, sidebar, bottom navigation, the restaurant rail and pull to refresh; customer, captain, restaurant and panel, RTL, from the real tokens; options side by side where you decide. Every sample is review copy only. Ideas from the Figma file: the floating blue bar with the orange active circle, the S-curve tab on the item sheet, the round back button and orange title, the bell in a round chip.',
    ),
    dialogCard,
    sheetCard,
    drawerCard,
    toastCard,
    bannerCard,
    menuCard,
    tabsCard,
    topCard,
    sidebarCard,
    navCard,
    railCard,
    motionCard,
    questions,
  ].join('\n');
  return page(
    themes,
    config,
    { file: 'Overlays.dc.html', title: 'Overlays and navigation — batch 4', w: W, h: 11300 },
    body,
  );
}
