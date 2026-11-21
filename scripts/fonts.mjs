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

/** The files among `paths` that are font files, by extension. */
export function fontFiles(paths) {
  return paths.filter((file) => FONT_EXTENSION.test(file));
}

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
