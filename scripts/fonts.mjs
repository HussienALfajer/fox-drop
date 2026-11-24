// The licensed fonts stay out of this public repository (architecture §9.3).
// docs/brand/fonts-manifest.json names each file, its SHA-256 and the commit
// of the private repository that holds them; `pnpm fonts:fetch` (fonts-fetch.mjs)
// puts them in .fonts/, which git ignores.
import { createHash } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';

const FONT_EXTENSION = /\.(ttf|otf|ttc|otc|woff2?|eot|dfont|pfb|pfa)$/i;

// The first four bytes of a TrueType, OpenType, collection, WOFF or WOFF2 file,
// so a font renamed to .bin or put among the assets is still caught.
const FONT_SIGNATURES = ['00010000', '4f54544f', '74727565', '74746366', '774f4646', '774f4632'];

/** True when `bytes` (a file's first bytes) start like a font file. */
export function hasFontSignature(bytes) {
  return bytes.length >= 4 && FONT_SIGNATURES.includes(bytes.subarray(0, 4).toString('hex'));
}

export const MANIFEST_URL = new URL('../docs/brand/fonts-manifest.json', import.meta.url);

// The one exception (owner, 2026-11-24, slice D.9): «Fox Lira», the ₺ that
// CoFo lacks, cut from Noto Sans under the SIL Open Font License (its OFL.txt
// sits beside it) by packages/design-tokens/scripts/lira-font.py, which writes
// the same bytes on every run. Each path is pinned to its SHA-256: any other
// font, or these with other bytes, still fails the guard.
const LIRA = {
  'FoxLira-Regular.ttf': 'ecc07028f37b6eb50c06b495ca100e89d68f5323e6c34f7c7c043a20fcaaf4fc',
  'FoxLira-Medium.ttf': '1dc432dea2c9f40d49361185ac2f5bf5b44af1d803ebaf2836042946073b249c',
  'FoxLira-Bold.ttf': '59e1a1a114a3afbfc374754880819f8f8b208a9f47b8a2653b7d3bf71488fb97',
};
export const ALLOWED_FONTS = Object.fromEntries(
  ['packages/ui-web/fonts/fox-lira', 'packages/core_ui/assets/fonts/fox-lira'].flatMap((dir) =>
    Object.entries(LIRA).map(([name, sha]) => [`${dir}/${name}`, sha]),
  ),
);

/** An allowed open-licence font with exactly its pinned bytes. */
function allowed(file) {
  const sha = ALLOWED_FONTS[file];
  return sha !== undefined && existsSync(file) && sha256(file) === sha;
}

/** The files among `paths` that are font files, by extension, less the allowed ones. */
export function fontFiles(paths) {
  return paths.filter((file) => FONT_EXTENSION.test(file) && !allowed(file));
}

/** Whether `file` is an allowed font (for the guard that reads first bytes). */
export const isAllowedFont = allowed;

export function readManifest(url = MANIFEST_URL) {
  return JSON.parse(readFileSync(url, 'utf8'));
}

export function sha256(file) {
  return createHash('sha256').update(readFileSync(file)).digest('hex');
}

/** The manifest paths that are absent from `dir` or whose bytes differ from their SHA-256. */
export function missingOrChanged(dir, files) {
  return files
    .filter((file) => {
      const full = path.join(dir, file.path);
      return !existsSync(full) || sha256(full) !== file.sha256;
    })
    .map((file) => file.path);
}
