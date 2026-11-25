// The parity report (D.P2, architecture §9.8): for each component a change
// touches, one PNG with its web stories' screenshots beside its Flutter golden,
// for people to look at. The gate is the measuring tests (ui-web's
// e2e/parity.spec.ts, core_ui's test/parity_test.dart); this only shows.
//
//   node scripts/parity-report.mjs <out dir> [<base>]
//
// It composes the committed images (the `visual` screenshots and the design
// system goldens), so it needs no build and no fonts; Chromium comes from
// ui-web's Playwright. Without a base every component is shown. CI's
// `parity-report` job uploads the folder.
import { mkdirSync, readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { changedFiles } from './classify-changes.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const REGISTRY = 'packages/design-tokens/components.json';
const SHOTS = 'packages/ui-web/e2e/__screenshots__';
const GOLDENS = 'packages/core_ui/test/golden/goldens/design-system';
// A change to any of these can move every component.
const EVERYTHING = [
  /^packages\/design-tokens\/(tokens\/|generated\/tokens\.css$|components\.json$)/,
  /^packages\/ui-web\/src\/(theme|styles)\.css$/,
  /^packages\/core_ui\/lib\/src\/(theme|internal)\//,
];

const kebab = (name) => name.replace(/([a-z0-9])([A-Z])/g, '$1-$2').toLowerCase();

/**
 * The registry's components that the changed `files` touch: their web folder,
 * the folder of the file declaring their Flutter widget (`flutterDirs`), their
 * screenshots or their golden; all of them after a token or theme change.
 */
export function touchedComponents(components, files, flutterDirs) {
  if (files.some((file) => EVERYTHING.some((pattern) => pattern.test(file)))) return components;
  return components.filter((c) => {
    const owned = [`${SHOTS}/${c.name.toLowerCase()}--`];
    if (c.web) owned.push(`packages/ui-web/src/${kebab(c.web)}/`);
    if (c.flutter && flutterDirs[c.flutter]) owned.push(`${flutterDirs[c.flutter]}/`);
    if (c.golden) owned.push(`${GOLDENS}/${c.golden}`);
    return files.some((file) => owned.some((prefix) => file.startsWith(prefix)));
  });
}

/** Each public Fox widget's folder under core_ui's lib/src, from its declaration. */
function flutterFolders() {
  const out = {};
  const visit = (dir) => {
    for (const entry of readdirSync(path.join(ROOT, dir), { withFileTypes: true })) {
      const file = `${dir}/${entry.name}`;
      if (entry.isDirectory()) visit(file);
      else if (entry.name.endsWith('.dart'))
        for (const [, name] of readFileSync(path.join(ROOT, file), 'utf8').matchAll(
          /^class (Fox\w+)/gm,
        ))
          out[name] = dir;
    }
  };
  visit('packages/core_ui/lib/src');
  return out;
}

/** The phone screenshots to show: the measured states' stories, else every story. */
function webShots(c) {
  if (!c.web) return [];
  const all = readdirSync(path.join(ROOT, SHOTS)).filter(
    (file) => file.startsWith(`${c.name.toLowerCase()}--`) && file.endsWith('-phone.png'),
  );
  const stories = c.metrics?.states.flatMap((s) => (s.story ? [`${s.story}-phone.png`] : []));
  return stories ? stories.filter((file) => all.includes(file)) : all;
}

const esc = (text) => text.replace(/[&<>"]/g, (ch) => `&#${ch.charCodeAt(0)};`);

function page(c) {
  const url = (file) => pathToFileURL(path.join(ROOT, file)).href;
  const shots = webShots(c)
    .map(
      (file) =>
        `<figure><img src="${url(`${SHOTS}/${file}`)}"><figcaption>${esc(file.replace(/-phone\.png$/, ''))}</figcaption></figure>`,
    )
    .join('');
  const golden = c.golden
    ? `<img src="${url(`${GOLDENS}/${c.golden}`)}">`
    : '<p>No Flutter widget.</p>';
  return `<!doctype html><meta charset="utf-8"><style>
body { margin: 0; padding: 24px; font: 14px sans-serif; background: #fff; color: #222; display: flex; gap: 32px; align-items: flex-start; width: max-content; }
section { display: flex; flex-direction: column; gap: 12px; }
.shots { display: grid; grid-template-columns: repeat(4, auto); gap: 12px; align-items: end; }
h1 { font-size: 18px; margin: 0 0 8px; }
figure { margin: 0; } figcaption { color: #666; font-size: 12px; }
img, canvas { display: block; max-width: 900px; border: 1px solid #ddd; }
</style><section><h1>${esc(c.name)}: web (${esc(c.web ?? 'pending')})</h1><div class="shots">${shots || '<p>No web twin yet.</p>'}</div></section>
<section><h1>Flutter (${esc(c.flutter ?? 'none')})</h1>${golden}</section>`;
}

/**
 * Crops each story screenshot to what differs from its corner pixel (the
 * story's ground), with a margin: a story frame is mostly empty.
 */
function cropShots() {
  // Runs in the page (Playwright's evaluate), where the document is global.
  const { document } = globalThis;
  return Promise.all(
    [...document.querySelectorAll('.shots img')].map(async (img) => {
      await img.decode();
      const canvas = document.createElement('canvas');
      canvas.width = img.naturalWidth;
      canvas.height = img.naturalHeight;
      const context = canvas.getContext('2d');
      context.drawImage(img, 0, 0);
      const { data, width, height } = context.getImageData(0, 0, canvas.width, canvas.height);
      const ground = data.slice(0, 4).join();
      let [top, left, bottom, right] = [height, width, -1, -1];
      for (let y = 0; y < height; y++)
        for (let x = 0; x < width; x++) {
          const i = (y * width + x) * 4;
          if (data.slice(i, i + 4).join() === ground) continue;
          top = Math.min(top, y);
          bottom = Math.max(bottom, y);
          left = Math.min(left, x);
          right = Math.max(right, x);
        }
      if (bottom < 0) return;
      const pad = 12;
      [top, left] = [Math.max(0, top - pad), Math.max(0, left - pad)];
      [bottom, right] = [Math.min(height - 1, bottom + pad), Math.min(width - 1, right + pad)];
      const crop = document.createElement('canvas');
      crop.width = right - left + 1;
      crop.height = bottom - top + 1;
      crop
        .getContext('2d')
        .drawImage(canvas, left, top, crop.width, crop.height, 0, 0, crop.width, crop.height);
      img.replaceWith(crop);
    }),
  );
}

async function main() {
  const [out, base] = process.argv.slice(2);
  if (!out) throw new Error('usage: node scripts/parity-report.mjs <out dir> [<base>]');
  const { components } = JSON.parse(readFileSync(path.join(ROOT, REGISTRY), 'utf8'));
  const files = base ? changedFiles(base) : null;
  const chosen = files ? touchedComponents(components, files, flutterFolders()) : components;
  mkdirSync(out, { recursive: true });
  if (chosen.length === 0) {
    console.log('No component touched: no parity report.');
    return;
  }
  const require = createRequire(path.join(ROOT, 'packages/ui-web/package.json'));
  const { chromium } = require('@playwright/test');
  // A file page may read its file images into a canvas (cropShots).
  const browser = await chromium.launch({ args: ['--allow-file-access-from-files'] });
  try {
    const tab = await browser.newPage();
    for (const c of chosen) {
      const html = path.join(out, `${c.name}.html`);
      writeFileSync(html, page(c));
      await tab.goto(pathToFileURL(path.resolve(html)).href);
      await tab.evaluate(cropShots);
      await tab.screenshot({ path: path.join(out, `${c.name}.png`), fullPage: true });
      console.log(`${c.name}.png`);
    }
  } finally {
    await browser.close();
  }
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url))
  await main();
