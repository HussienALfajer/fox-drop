// Builds the Design System's component bundle (architecture §9.8): one classic
// script with React inside, and the CSS the components need. Used by
// scripts/design-system.ts and by test/design-system.test.ts.
import { icons } from '@fox-drop/design-tokens/icons';
import tailwindcss from '@tailwindcss/vite';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { build } from 'vite';

export const PACKAGE_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

/** The components the bundle exposes, in the index's order. */
export const COMPONENTS = [
  'Button',
  'DropLoader',
  'TextLink',
  'Icon',
  'Field',
  'TextField',
  'TextArea',
  'SearchField',
  'PhoneField',
  'CodeField',
  'CountrySheet',
  'DateField',
  'TimeField',
  'CodePreview',
  'Select',
  'Checkbox',
  'RadioGroup',
  'Switch',
  'QuantityStepper',
  'Money',
  'StatusChip',
  'CountBadge',
  'Card',
  'ListRow',
  'Timer',
  'CountdownRing',
  'OrderCard',
  'OrderRow',
  'Logo',
  'TrackingSteps',
  'AmountsSummary',
  'Skeleton',
  'EmptyState',
  'DataTable',
  'Dialog',
  'ConfirmDialog',
  'Drawer',
  'Toaster',
  'Banner',
  'BannerStack',
  'BlockingBanner',
  'Menu',
  'Tooltip',
  'Tabs',
  'TopBar',
  'Sidebar',
  'RestaurantBar',
  'BottomNavigation',
  'SignInHero',
  'BlockingHeads',
] as const;

export const MAX_JS = 6 * 1024 * 1024;
export const MAX_CSS = 2 * 1024 * 1024;

// `</script` and `<!--` would end or confuse an inline script in the page that
// hosts the bundle; a backslash makes each a harmless string escape.
const FORBIDDEN_JS = ['</script', '<!--'];
const FORBIDDEN_CSS = ['</style', '@font-face', '.fonts'];

export function header(): string {
  const components = COMPONENTS.map((name) => ({ name }));
  const index = { format: 4, namespace: 'FoxDrop', components };
  return `/* @ds-bundle: ${JSON.stringify(index)} */\n`;
}

/** Escapes what a host page could misread and fails when any of it is left. */
export function checkJs(js: string): string {
  const safe = js.replaceAll('</script', '<\\/script').replaceAll('<!--', '<\\!--');
  for (const text of FORBIDDEN_JS) {
    if (safe.toLowerCase().includes(text)) throw new Error(`bundle.js contains ${text}`);
  }
  if (Buffer.byteLength(safe) > MAX_JS) throw new Error('bundle.js is over 6 MB');
  return safe;
}

export function checkCss(css: string): string {
  for (const text of FORBIDDEN_CSS) {
    if (css.toLowerCase().includes(text)) throw new Error(`bundle.css contains ${text}`);
  }
  if (Buffer.byteLength(css) > MAX_CSS) throw new Error('bundle.css is over 2 MB');
  return css;
}

/** The names of every icon, for the Icon preview and the type docs. */
export const ICON_NAMES = Object.keys(icons);

export async function buildBundle(): Promise<{ js: string; css: string }> {
  const result = await build({
    root: PACKAGE_DIR,
    configFile: false,
    // The production JSX runtime: under Vitest (NODE_ENV test) the transform
    // would compile jsxDEV calls that the bundled production React lacks.
    mode: 'production',
    oxc: { jsx: { development: false } },
    logLevel: 'silent',
    plugins: [tailwindcss()],
    define: { 'process.env.NODE_ENV': '"production"' },
    build: {
      write: false,
      minify: true,
      cssCodeSplit: false,
      lib: {
        entry: path.join(PACKAGE_DIR, 'scripts/bundle-entry.ts'),
        name: 'FoxDrop',
        formats: ['iife'],
      },
      rolldownOptions: { output: { exports: 'default' } },
    },
  });
  const outputs = (Array.isArray(result) ? result : [result]).flatMap((one) =>
    'output' in one ? one.output : [],
  );
  let js = '';
  let css = '';
  for (const file of outputs) {
    if (file.type === 'chunk') js += file.code;
    else if (file.fileName.endsWith('.css')) css += String(file.source);
  }
  if (!js || !css) throw new Error('the bundle build produced no script or no stylesheet');
  return { js: header() + checkJs(js), css: checkCss(css) };
}
