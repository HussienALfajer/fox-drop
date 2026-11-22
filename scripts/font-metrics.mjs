// The advance widths of CoFo's digits, with and without the `tnum` feature
// (brand expression §7: money, timers and tables use tabular digits). The
// fonts stay outside this repository (architecture §9.3); only these metrics
// are committed, keyed by each file's SHA-256 from the fonts manifest.
//
//   node scripts/font-metrics.mjs   reads .fonts/ (pnpm fonts:fetch first) and
//                                   writes packages/design-tokens/font-metrics.json
import { readFileSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import * as fontkit from 'fontkit';
import { readManifest, sha256 } from './fonts.mjs';

export const FONTS_DIR = new URL('../.fonts/', import.meta.url);
export const METRICS_URL = new URL('../packages/design-tokens/font-metrics.json', import.meta.url);

// The weights of the UI (brand expression §7) and their files.
export const WEIGHTS = {
  400: 'cofo-sans-pro-arabic/CoFoSansProArabic-Regular.ttf',
  500: 'cofo-sans-pro-arabic/CoFoSansProArabic-Medium.ttf',
  700: 'cofo-sans-pro-arabic/CoFoSansProArabic-Bold.ttf',
};

const DIGITS = '0123456789';

function advances(font, features) {
  return font.layout(DIGITS, features).positions.map((position) => position.xAdvance);
}

/** The metrics of one font file. */
export function measure(file) {
  const font = fontkit.create(readFileSync(file));
  return {
    unitsPerEm: font.unitsPerEm,
    proportional: advances(font, []),
    tabular: advances(font, ['tnum']),
  };
}

/** The metrics of every weight, read from `dir`. */
export function measureAll(dir = FONTS_DIR) {
  const manifest = readManifest();
  return Object.fromEntries(
    Object.entries(WEIGHTS).map(([weight, file]) => {
      const entry = manifest.files.find((each) => each.path === file);
      if (!entry) throw new Error(`${file} is not in the fonts manifest`);
      const bytes = fileURLToPath(new URL(file, dir));
      if (sha256(bytes) !== entry.sha256) throw new Error(`${file} differs from the manifest`);
      return [weight, { path: file, sha256: entry.sha256, ...measure(bytes) }];
    }),
  );
}

export function readMetrics(url = METRICS_URL) {
  return JSON.parse(readFileSync(url, 'utf8'));
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  writeFileSync(METRICS_URL, `${JSON.stringify(measureAll(), null, 2)}\n`);
  console.log(`wrote ${fileURLToPath(METRICS_URL)}`);
}
