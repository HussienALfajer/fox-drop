// Draws «Button and Icon — batch 1» for the owner's review (architecture
// §9.9 step 3), a second artboard of the «Component proposals» canvas. Every
// variant the owner may pick from, every §9.9 state, both densities, icons at
// the start and the end in RTL, and the three surfaces. Values come from the
// tokens; a value with no token yet is marked "proposed" on the sheet.
import { card, esc, heading, label, page, v, type Board, type GuideConfig } from './guide.ts';
import { cssValue } from './generate.ts';
import type { Icon } from './icons.ts';
import type { Theme, Token } from './resolve.ts';

type Themes = Record<Theme, Map<string, Token>>;

const W = 1680;

export const VARIANTS = ['primary', 'secondary', 'danger', 'ghost'] as const;
type Variant = (typeof VARIANTS)[number];
export const STATES = ['default', 'hover', 'focus', 'pressed', 'disabled', 'loading'] as const;
type State = (typeof STATES)[number];

const STATE_AR: Record<State, string> = {
  default: 'عادي',
  hover: 'تمرير المؤشر',
  focus: 'تركيز لوحة المفاتيح',
  pressed: 'مضغوط',
  disabled: 'معطّل',
  loading: 'قيد التحميل',
};
const VARIANT_AR: Record<Variant, string> = {
  primary: 'أساسي',
  secondary: 'ثانوي',
  danger: 'خطر',
  ghost: 'شفاف',
};
const SAMPLE: Record<Variant, string> = {
  primary: 'اطلب الآن',
  secondary: 'عرض القائمة',
  danger: 'إلغاء الطلب',
  ghost: 'تخطي',
};

interface Look {
  bg: string;
  bgPressed: string;
  fg: string;
  border?: string;
}

function look(themes: Themes, theme: Theme, variant: Variant): Look {
  const t = (name: string) => cssValue(themes[theme].get(name)!);
  switch (variant) {
    case 'primary':
      return {
        bg: t('button.primary.background'),
        bgPressed: t('button.primary.background-pressed'),
        fg: t('button.primary.label'),
      };
    case 'secondary':
      return {
        bg: t('button.secondary.background'),
        bgPressed: t('button.secondary.background-pressed'),
        fg: t('button.secondary.label'),
        border: t('button.secondary.border'),
      };
    case 'danger':
      return {
        bg: t('button.danger.background'),
        bgPressed: t('button.danger.background-pressed'),
        fg: t('button.danger.label'),
      };
    case 'ghost':
      return {
        bg: 'transparent',
        bgPressed: t('button.ghost.background-pressed'),
        fg: t('button.ghost.label'),
      };
  }
}

function svg(icon: Icon, size: number, flip: boolean): string {
  const transform = flip ? ' style="transform: scaleX(-1)"' : '';
  return `<svg aria-hidden="true" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"${transform}>${icon.paths.map((d) => `<path d="${d}"/>`).join('')}</svg>`;
}

interface Opts {
  theme?: Theme;
  variant: Variant;
  state?: State;
  height: number;
  text?: string;
  start?: Icon;
  end?: Icon;
  /** Icon-only circle. */
  only?: Icon;
  scale?: number;
}

function button(themes: Themes, o: Opts): string {
  const theme = o.theme ?? 'light';
  const t = (name: string) => cssValue(themes[theme].get(name)!);
  const l = look(themes, theme, o.variant);
  const state = o.state ?? 'default';
  const disabled = state === 'disabled';
  const scale = o.scale ?? 1;
  const iconSize = Number.parseFloat(t(o.height >= 50 ? 'size.icon-md' : 'size.icon-sm'));
  let bg = l.bg;
  if (state === 'hover')
    bg =
      o.variant === 'ghost'
        ? `color-mix(in srgb, ${l.bgPressed} 60%, transparent)`
        : `color-mix(in srgb, ${l.bg} 88%, ${l.bgPressed})`;
  if (state === 'pressed') bg = l.bgPressed;
  if (disabled) bg = o.variant === 'ghost' ? 'transparent' : t('button.disabled.background');
  const fg = disabled ? t('button.disabled.label') : l.fg;
  const shadows: string[] = [];
  if (l.border && !disabled) shadows.push(`inset 0 0 0 1px ${l.border}`);
  if (state === 'focus')
    shadows.push(`0 0 0 2px ${t('color.surface')}`, `0 0 0 4px ${t('button.focus-ring')}`);
  const size = o.only
    ? `width: ${o.height}px; padding: 0;`
    : `padding-inline: ${t('button.padding-inline')};`;
  const weight = 500;
  const font = `font-size: ${Math.round(Number.parseFloat(t(o.height >= 50 ? 'type.phone.subtitle.size' : 'type.panel.subtitle.size')) * scale)}px; font-weight: ${weight}; line-height: 1.3;`;
  const inner = o.only
    ? svg(o.only, iconSize, o.only.mirror)
    : [
        o.start ? svg(o.start, iconSize, o.start.mirror) : '',
        `<span>${esc(o.text ?? SAMPLE[o.variant])}</span>`,
        o.end ? svg(o.end, iconSize, o.end.mirror) : '',
      ].join('');
  const spinner = `<span style="position: absolute; inset: 0; display: flex; align-items: center; justify-content: center"><svg aria-hidden="true" width="${iconSize}" height="${iconSize}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><path d="M12 3a9 9 0 1 0 9 9" /></svg></span>`;
  const content =
    state === 'loading'
      ? `<span style="display: inline-flex; align-items: center; gap: ${t('button.gap')}; visibility: hidden">${inner}</span>${spinner}`
      : inner;
  return `<span style="position: relative; display: inline-flex; align-items: center; justify-content: center; gap: ${t('button.gap')}; box-sizing: border-box; min-height: ${o.height}px; ${size} border-radius: ${t('button.radius')}; background: ${bg}; color: ${fg}; ${font} white-space: nowrap; box-shadow: ${shadows.join(', ') || 'none'}">${content}</span>`;
}

const cell = (inner: string, caption?: string) =>
  `<div style="display: flex; flex-direction: column; align-items: center; justify-content: flex-end; gap: 10px; min-height: 92px">${inner}${caption ?? ''}</div>`;

function matrix(themes: Themes, height: number, title: string, note: string): string {
  const head = `<div></div>${STATES.map((s) => `<div style="text-align: center; font-weight: 500">${STATE_AR[s]} ${label(themes, s)}</div>`).join('')}`;
  const rows = VARIANTS.map(
    (variant) =>
      `<div style="font-weight: 700; align-self: center">${VARIANT_AR[variant]}<br>${label(themes, variant)}</div>${STATES.map((state) => cell(button(themes, { variant, state, height }))).join('')}`,
  ).join('');
  return card(
    themes,
    `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">${esc(title)} ${label(themes, note)}</h2><div style="display: grid; grid-template-columns: 120px repeat(${STATES.length}, minmax(0, 1fr)); gap: ${v(themes, 'space.md')}; align-items: end">${head}${rows}</div>`,
  );
}

export function buttonSheet(themes: Themes, config: GuideConfig, icons: Icon[]): Board {
  const icon = (name: string) => icons.find((i) => i.name === name)!;
  const h2 = (text: string, note = '') =>
    `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">${esc(text)} ${note ? label(themes, note) : ''}</h2>`;
  const row = (items: string[]) =>
    `<div style="display: flex; flex-wrap: wrap; align-items: flex-end; gap: ${v(themes, 'space.xl')}">${items.join('')}</div>`;

  const withIcons = card(
    themes,
    h2(
      'مع الأيقونات، من اليمين إلى اليسار',
      'icon = start (right in RTL) · iconEnd = end (left in RTL) · back mirrors',
    ) +
      row([
        cell(
          button(themes, {
            variant: 'primary',
            height: 50,
            start: icon('cart'),
            text: 'أضف إلى السلة',
          }),
          label(themes, 'icon="cart"'),
        ),
        cell(
          button(themes, { variant: 'secondary', height: 50, start: icon('back'), text: 'رجوع' }),
          label(themes, 'icon="back" (mirrored: points right, to the start)'),
        ),
        cell(
          button(themes, {
            variant: 'primary',
            height: 50,
            end: icon('confirm'),
            text: 'تأكيد الطلب',
          }),
          label(themes, 'iconEnd="confirm"'),
        ),
        cell(
          button(themes, {
            variant: 'secondary',
            height: 50,
            start: icon('phone'),
            text: 'اتصل بالمطعم',
          }),
          label(themes, 'icon="phone"'),
        ),
        cell(
          button(themes, { variant: 'danger', height: 50, start: icon('delete'), text: 'حذف' }),
          label(themes, 'icon="delete"'),
        ),
        cell(
          button(themes, {
            variant: 'ghost',
            height: 50,
            start: icon('retry'),
            text: 'إعادة المحاولة',
          }),
          label(themes, 'icon="retry"'),
        ),
        cell(
          button(themes, {
            variant: 'secondary',
            height: 40,
            start: icon('filter'),
            text: 'تصفية',
          }),
          label(themes, 'compact · icon="filter"'),
        ),
      ]),
  );

  const circles = card(
    themes,
    h2('أزرار الأيقونة وحدها', 'circle · label required (read by screen readers) · 50 and 40') +
      row(
        [50, 40].flatMap((height) =>
          (
            [
              ['primary', 'add'],
              ['secondary', 'back'],
              ['secondary', 'close'],
              ['ghost', 'more'],
              ['danger', 'delete'],
            ] as const
          ).map(([variant, name]) =>
            cell(
              button(themes, { variant, height, only: icon(name) }),
              label(themes, `${variant} · ${name} · ${height}`),
            ),
          ),
        ),
      ) +
      row(
        (['default', 'focus', 'pressed', 'disabled'] as const).map((state) =>
          cell(
            button(themes, { variant: 'secondary', height: 50, only: icon('close'), state }),
            label(themes, state),
          ),
        ),
      ),
  );

  const surface = (theme: Theme, name: string, height: number, note: string) =>
    `<div style="flex: 1; display: flex; flex-direction: column; gap: ${v(themes, 'space.md')}; padding: ${v(themes, 'space.lg')}; border-radius: ${v(themes, 'radius.lg')}; background: ${cssValue(themes[theme].get('color.surface')!)}; border: 1px solid ${v(themes, 'color.border')}"><div style="font-weight: 700">${esc(name)} ${label(themes, note)}</div><div style="display: flex; flex-wrap: wrap; gap: ${v(themes, 'space.md')}">${VARIANTS.map((variant) => button(themes, { theme, variant, height })).join('')}</div></div>`;
  const surfaces = card(
    themes,
    h2('الأسطح الثلاثة', 'phone · captain (danger at 7:1: red.800) · panel (compact 40)') +
      `<div style="display: flex; gap: ${v(themes, 'space.lg')}">${[
        surface('light', 'تطبيق الزبون', 50, 'phone · comfortable 50'),
        surface('captainLight', 'تطبيق الكابتن', 50, 'captain · comfortable 50'),
        surface('light', 'لوحة الإدارة وبوابة المطعم', 40, 'panel · compact 40'),
      ].join('')}</div>`,
  );

  const large = card(
    themes,
    h2('النص المكبّر 130٪', 'the label wraps or grows, never clips; the pill grows in height') +
      row(
        VARIANTS.map((variant) =>
          cell(
            button(themes, {
              variant,
              height: 50,
              scale: 1.3,
              ...(variant === 'primary' ? { start: icon('cart') } : {}),
            }),
          ),
        ),
      ),
  );

  const questions = card(
    themes,
    h2('ما اعتمده المالك', '2026-11-23') +
      `<ol style="margin: 0; padding-inline-start: 24px; display: flex; flex-direction: column; gap: ${v(themes, 'space.xs')}; line-height: 1.7">
<li>الأنواع الأربعة: أساسي، ثانوي، خطر، شفاف، ومن كل نوع زر أيقونة دائري.</li>
<li>بلا ظل تحت الزر: الظل البرتقالي المزاح للبانرات فقط.</li>
<li>الحجم المضغوط 40 للوحة الإدارة وبوابة المطعم فقط؛ تطبيقات الهاتف والكابتن 50.</li>
<li>الضغط للخطر بالأحمر الداكن «alert»، والتمرير مزيج خفيف بين العادي والمضغوط.</li>
<li>التحميل: دائرة دوّارة مكان النص، وعرض الزر ثابت، ولا يُضغط.</li>
</ol>`,
  );

  const body = [
    heading(
      themes,
      'الأزرار والأيقونات — الدفعة الأولى',
      'Button and Icon — batch 1 (architecture §9.9; brand directions «Measurements»: pills 50). Every variant and state at 50 and 40, icons in RTL, the three surfaces, 130% text. Sample labels are review copy only.',
    ),
    matrix(themes, 50, 'الحالات — الحجم العادي 50', 'comfortable · phone and captain'),
    matrix(themes, 40, 'الحالات — الحجم المضغوط 40', 'compact · panel, pointer only (proposed)'),
    withIcons,
    circles,
    surfaces,
    large,
    questions,
  ].join('\n');
  return page(
    themes,
    config,
    { file: 'Buttons.dc.html', title: 'Button and Icon — batch 1', w: W, h: 2180 },
    body,
  );
}
