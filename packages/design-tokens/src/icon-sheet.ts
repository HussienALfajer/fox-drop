// Draws the icon sheet for the owner's review (architecture §9.9 step 3) as
// the «Icons — batch 1» artboard of the «Component proposals» Design canvas
// (the component sheets beside it were deleted with the components in D.R1),
// into the ignored .design-system/icons/:
//   pnpm --filter @fox-drop/design-tokens icon-sheet --config <file>
// The config (kept outside the repository) holds the Design System's link and
// the canvas's creation time: {"system": "<url>", "created": "<RFC 3339>"}.
// Claude publishes the folder with the Artifact tool.
import { mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  canvas,
  card,
  DS_FOLDER,
  esc,
  heading,
  label,
  page,
  v,
  type Board,
  type GuideConfig,
} from './guide.ts';
import {
  bakeIcons,
  readIcons,
  STYLES,
  styleMarkup,
  type BakedIcon,
  type Icon,
  type IconStyle,
} from './icons.ts';
import { designSystem } from './design-system.ts';
import { PACKAGE_DIR, resolveAll, type Theme, type Token } from './resolve.ts';

type Themes = Record<Theme, Map<string, Token>>;

export const OUT = path.join(PACKAGE_DIR, '.design-system/icons');

/** The sheet's Arabic labels: review copy only, not app strings. */
export const ARABIC: Record<string, string> = {
  Navigation: 'التنقل',
  Actions: 'الإجراءات',
  States: 'الحالات',
  'Place and delivery': 'المكان والتوصيل',
  Money: 'المال',
  'Contact and rating': 'التواصل والتقييم',
  home: 'الرئيسية',
  search: 'البحث',
  cart: 'السلة',
  orders: 'طلباتي',
  account: 'الحساب',
  settings: 'الإعدادات',
  back: 'رجوع',
  close: 'إغلاق',
  'chevron-down': 'فتح القائمة',
  calendar: 'التاريخ',
  more: 'المزيد',
  menu: 'القائمة',
  filter: 'تصفية',
  add: 'إضافة',
  remove: 'إنقاص',
  delete: 'حذف',
  edit: 'تعديل',
  confirm: 'تأكيد',
  retry: 'إعادة المحاولة',
  share: 'مشاركة',
  camera: 'الكاميرا',
  image: 'صورة',
  info: 'معلومة',
  warning: 'تنبيه',
  error: 'خطأ',
  success: 'تم بنجاح',
  bell: 'الإشعارات',
  offline: 'غير متصل',
  clock: 'الوقت',
  'drop-pin': 'الموقع',
  map: 'الخريطة',
  route: 'المسار',
  motorcycle: 'دراجة نارية',
  car: 'سيارة',
  restaurant: 'مطعم',
  plate: 'طبق',
  house: 'عنوان التوصيل',
  cash: 'نقدًا',
  wallet: 'المحفظة',
  discount: 'قسيمة خصم',
  receipt: 'الفاتورة',
  gift: 'هدية',
  phone: 'اتصال',
  chat: 'المحادثة والدعم',
  star: 'التقييم',
  heart: 'المفضلة',
  language: 'اللغة',
};

const W = 1280;

function svg(icon: Icon, size: number, colour: string, flip = false): string {
  const transform = flip ? ' style="transform: scaleX(-1)"' : '';
  const paths = icon.paths.map((d) => `<path d="${d}"/>`).join('');
  return `<svg aria-hidden="true" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="${colour}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"${transform}>${paths}</svg>`;
}

function tile(themes: Themes, icon: Icon): string {
  const blue = v(themes, 'color.on-surface');
  const control = v(themes, 'size.control');
  const box = (inner: string, extra = '') =>
    `<span style="display: inline-flex; align-items: center; justify-content: center; ${extra}">${inner}</span>`;
  const sizes = ['size.icon-sm', 'size.icon-md', 'size.icon-lg'].map((name) =>
    box(svg(icon, Number.parseFloat(v(themes, name)), blue), 'width: 40px; height: 40px'),
  );
  const active = box(
    svg(icon, 24, v(themes, 'color.on-primary')),
    `width: ${control}; height: ${control}; border-radius: ${v(themes, 'radius.full')}; background: ${v(themes, 'color.primary')}`,
  );
  const names = `<div style="display: flex; justify-content: space-between; align-items: baseline; gap: ${v(themes, 'space.xs')}"><span style="font-size: ${v(themes, 'type.phone.secondary.size')}; font-weight: 500">«${esc(ARABIC[icon.name] ?? icon.name)}»</span>${label(themes, icon.name + (icon.mirror ? ' · mirrors' : ''))}</div>`;
  const row = `<div style="display: flex; align-items: center; gap: ${v(themes, 'space.sm')}">${box(svg(icon, 24, blue), `width: ${control}; height: ${control}; border-radius: ${v(themes, 'radius.full')}; background: ${v(themes, 'color.surface')}`)}${active}${sizes.join('')}</div>`;
  return `<div style="display: flex; flex-direction: column; gap: ${v(themes, 'space.sm')}; padding: ${v(themes, 'space.md')}; border-radius: ${v(themes, 'radius.md')}; border: 1px solid ${v(themes, 'color.border')}">${names}${row}</div>`;
}

function group(themes: Themes, name: string, icons: Icon[]): string {
  const title = `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">${esc(ARABIC[name] ?? name)} ${label(themes, `${name} · ${icons.length}`)}</h2>`;
  const grid = `<div style="display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: ${v(themes, 'space.md')}">${icons.map((icon) => tile(themes, icon)).join('')}</div>`;
  return card(themes, title + grid);
}

function mirrored(themes: Themes, icons: Icon[]): string {
  const blue = v(themes, 'color.on-surface');
  const pair = (icon: Icon) =>
    `<div style="display: flex; flex-direction: column; align-items: center; gap: ${v(themes, 'space.xs')}"><div style="display: flex; gap: ${v(themes, 'space.lg')}"><div style="display: flex; flex-direction: column; align-items: center; gap: ${v(themes, 'space.xs')}">${svg(icon, 32, blue, true)}${label(themes, 'RTL')}</div><div style="display: flex; flex-direction: column; align-items: center; gap: ${v(themes, 'space.xs')}">${svg(icon, 32, blue)}${label(themes, 'LTR (source)')}</div></div><span>«${esc(ARABIC[icon.name]!)}»</span></div>`;
  const title = `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">الأيقونات التي تنعكس في اتجاه اليمين إلى اليسار</h2>`;
  return card(
    themes,
    `${title}<div style="display: flex; gap: ${v(themes, 'space.2xl')}">${icons
      .filter((icon) => icon.mirror)
      .map(pair)
      .join('')}</div>`,
  );
}

function gridOverlay(themes: Themes, icons: Icon[]): string {
  const lines = Array.from({ length: 25 }, (_, i) => `M${i} 0V24M0 ${i}H24`).join('');
  const board = (icon: Icon) =>
    `<div style="display: flex; flex-direction: column; align-items: center; gap: ${v(themes, 'space.xs')}"><svg aria-hidden="true" width="192" height="192" viewBox="0 0 24 24" fill="none" stroke-linecap="round" stroke-linejoin="round" style="background: ${v(themes, 'color.surface')}"><path d="${lines}" stroke="${v(themes, 'color.border')}" stroke-width="0.04"/><rect x="2" y="2" width="20" height="20" stroke="${v(themes, 'color.primary')}" stroke-width="0.08" stroke-dasharray="0.4 0.3"/><g stroke="${v(themes, 'color.on-surface')}" stroke-width="1.5" opacity="0.85">${icon.paths.map((d) => `<path d="${d}"/>`).join('')}</g></svg>${label(themes, icon.name)}</div>`;
  const title = `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">الشبكة ${label(themes, '24 × 24 · live area 2..22 (dashed) · stroke 1.5 · round caps and joins')}</h2>`;
  const shown = ['home', 'drop-pin', 'motorcycle'].map((name) =>
    icons.find((icon) => icon.name === name)!,
  );
  return card(
    themes,
    `${title}<div style="display: flex; gap: ${v(themes, 'space.2xl')}">${shown.map(board).join('')}</div>`,
  );
}

/** The six styles' names on the sheet (§9.4), review copy only. */
const STYLE_NAMES: Record<IconStyle, string> = {
  linear: 'خطي · Linear',
  duotone: 'ثنائي اللون · Duotone',
  'brand-duo': 'ثنائي العلامة · Brand Duo',
  broken: 'مقطوع · Broken',
  bold: 'عريض · Bold',
  'bold-duo': 'عريض ثنائي · Bold Duo',
};

/** Every icon in the six styles of set v4 Madar: one row per icon. */
function styles(themes: Themes, icons: BakedIcon[]): string {
  const ink = v(themes, 'color.on-surface');
  const brand = v(themes, 'color.brand');
  const cell = (inner: string) =>
    `<span style="display: inline-flex; justify-content: center">${inner}</span>`;
  const columns = `display: grid; grid-template-columns: 160px repeat(${STYLES.length}, minmax(0, 1fr)); align-items: center; gap: ${v(themes, 'space.sm')}`;
  const head = `<div style="${columns}"><span></span>${STYLES.map((s) => cell(label(themes, STYLE_NAMES[s]))).join('')}</div>`;
  const rows = icons.map(
    (icon) =>
      `<div style="${columns}">${label(themes, `«${esc(ARABIC[icon.name] ?? icon.name)}» ${icon.name}`)}${STYLES.map(
        (s) =>
          cell(
            `<svg aria-hidden="true" width="32" height="32" viewBox="0 0 24 24">${styleMarkup(icon, s, ink, brand)}</svg>`,
          ),
      ).join('')}</div>`,
  );
  const title = `<h2 style="margin: 0; font-size: ${v(themes, 'type.phone.title.size')}; color: ${v(themes, 'color.heading')}">الأنماط الستة ${label(themes, 'set v4 Madar · stroke 1.5 · Bold and Broken baked into plain paths')}</h2>`;
  return card(themes, `${title}${head}${rows.join('')}`);
}

export function sheet(themes: Themes, config: GuideConfig, icons: BakedIcon[]): Board {
  const groups = [...new Set(icons.map((icon) => icon.group))];
  const rows = groups.reduce(
    (sum, name) => sum + Math.ceil(icons.filter((icon) => icon.group === name).length / 4),
    0,
  );
  const h = 200 + groups.length * 150 + rows * 150 + 330 + 380 + 120 + icons.length * 48;
  const body = [
    heading(
      themes,
      'الأيقونات — الدفعة الأولى',
      'Icons — batch 1 (brand expression §10, architecture §9.4). Each tile: at 24 on the ground, active (ivory in the orange circle), then at 16, 24 and 32. Arabic labels are review copy only.',
    ),
    ...groups.map((name) =>
      group(
        themes,
        name,
        icons.filter((icon) => icon.group === name),
      ),
    ),
    mirrored(themes, icons),
    gridOverlay(themes, icons),
    styles(themes, icons),
  ].join('\n');
  return page(themes, config, { file: 'Main.dc.html', title: 'Icons — batch 1', w: W, h }, body);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const at = process.argv.indexOf('--config');
  if (at === -1) throw new Error('Usage: icon-sheet --config <file>');
  const config = JSON.parse(readFileSync(process.argv[at + 1]!, 'utf8')) as GuideConfig;
  const themes = await resolveAll();
  const icons = await bakeIcons(readIcons());
  const list = [sheet(themes, config, icons)];
  rmSync(OUT, { recursive: true, force: true });
  const files = new Map<string, string>([
    ['project/canvas.json', canvas(list, config, new Date().toISOString(), 'Component proposals')],
    ...list.map((board) => [`project/${board.file}`, board.html] as [string, string]),
    [`project/ds/${DS_FOLDER}/tokens.json`, designSystem(themes)],
  ]);
  for (const [file, body] of files) {
    const target = path.join(OUT, file);
    mkdirSync(path.dirname(target), { recursive: true });
    writeFileSync(target, body);
  }
  console.log(`wrote ${OUT}`);
}
