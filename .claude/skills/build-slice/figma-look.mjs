// Renders the owner's Figma file "Fox Drop" to PNG files outside the repository, for the
// planning session's look at the design (SKILL.md, "Look at the Figma file").
//
//   node .claude/skills/build-slice/figma-look.mjs <out dir> [node id ...]
//
// The token comes from FIGMA_TOKEN or ~/.figma-token, and the file's key from FIGMA_FILE_KEY or
// ~/.figma-file-key: neither enters the repository (architecture §9.8).
// Figma's own render endpoint is rate limited for days on the owner's plan, so this
// draws the vector paths itself: fills, strokes, masks and image fills, then rasterises
// the SVG with the Chromium that ui-web's Playwright tests already use.
// With no node id it draws every top-level node of the page "03 — Components".

import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { homedir } from 'node:os';
import { join, resolve } from 'node:path';

const COMPONENTS_PAGE = '1:3';

/** A value from the environment, else from a file in the home folder. */
const local = (variable, file) =>
  (process.env[variable] ?? readFileSync(join(homedir(), file), 'utf8')).trim();

const [outArg, ...wanted] = process.argv.slice(2);
if (!outArg) {
  console.error('Usage: node figma-look.mjs <out dir outside the repository> [node id ...]');
  process.exit(1);
}
const outDir = resolve(outArg);
mkdirSync(outDir, { recursive: true });

const token = local('FIGMA_TOKEN', '.figma-token');
const FILE_KEY = local('FIGMA_FILE_KEY', '.figma-file-key');

async function api(path) {
  const response = await fetch(`https://api.figma.com/v1/files/${FILE_KEY}${path}`, {
    headers: { 'X-Figma-Token': token },
  });
  if (!response.ok) throw new Error(`Figma ${path}: ${response.status} ${await response.text()}`);
  return response.json();
}

const nodes = await api(`/nodes?ids=${COMPONENTS_PAGE}&geometry=paths`);
const imageUrls = (await api('/images')).meta.images;
const page = nodes.nodes[COMPONENTS_PAGE].document;
const byId = new Map();
(function index(node) {
  byId.set(node.id, node);
  (node.children ?? []).forEach(index);
})(page);

const multiply = (a, b) => [
  [
    a[0][0] * b[0][0] + a[0][1] * b[1][0],
    a[0][0] * b[0][1] + a[0][1] * b[1][1],
    a[0][0] * b[0][2] + a[0][1] * b[1][2] + a[0][2],
  ],
  [
    a[1][0] * b[0][0] + a[1][1] * b[1][0],
    a[1][0] * b[0][1] + a[1][1] * b[1][1],
    a[1][0] * b[0][2] + a[1][1] * b[1][2] + a[1][2],
  ],
];
const matrix = (t) => `matrix(${t[0][0]} ${t[1][0]} ${t[0][1]} ${t[1][1]} ${t[0][2]} ${t[1][2]})`;
const rgba = (c, opacity = 1) =>
  `rgba(${Math.round(c.r * 255)},${Math.round(c.g * 255)},${Math.round(c.b * 255)},${+(c.a * opacity).toFixed(3)})`;
const escapeText = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;');
let uid = 0;

function paint(p, defs, node) {
  if (p.type === 'SOLID') return rgba(p.color, p.opacity ?? 1);
  if (p.type !== 'IMAGE') return 'none';
  const id = `p${uid++}`;
  const w = node.size.x;
  const h = node.size.y;
  const fit = { FIT: 'xMidYMid meet', FILL: 'xMidYMid slice' }[p.scaleMode] ?? 'none';
  defs.push(
    `<pattern id="${id}" patternUnits="userSpaceOnUse" width="${w}" height="${h}"><image href="${imageUrls[p.imageRef]}" width="${w}" height="${h}" preserveAspectRatio="${fit}"/></pattern>`,
  );
  return `url(#${id})`;
}

function shapes(node, t, defs) {
  let out = '';
  for (const p of (node.fills ?? []).filter((x) => x.visible !== false))
    for (const g of node.fillGeometry ?? [])
      out += `<path d="${g.path}" fill-rule="${g.windingRule === 'EVENODD' ? 'evenodd' : 'nonzero'}" fill="${paint(p, defs, node)}" transform="${matrix(t)}"/>`;
  for (const p of (node.strokes ?? []).filter((x) => x.visible !== false))
    for (const g of node.strokeGeometry ?? [])
      out += `<path d="${g.path}" fill="${paint(p, defs, node)}" transform="${matrix(t)}"/>`;
  if (node.type === 'TEXT') {
    const s = node.style;
    const fill = (node.fills ?? []).find((x) => x.type === 'SOLID');
    out += `<text transform="${matrix(t)}" y="${s.fontSize}" font-family="${s.fontFamily}" font-size="${s.fontSize}" font-weight="${s.fontWeight}" fill="${fill ? rgba(fill.color, fill.opacity ?? 1) : '#000'}">${escapeText(node.characters)}</text>`;
  }
  return out;
}

// Every child's relativeTransform is relative to its parent, groups included.
function draw(node, parentT, defs) {
  if (node.visible === false) return '';
  const t = node.relativeTransform ? multiply(parentT, node.relativeTransform) : parentT;
  let body = shapes(node, t, defs);
  const kids = node.children ?? [];
  for (let i = 0; i < kids.length;) {
    const kid = kids[i];
    if (!kid.isMask) {
      body += draw(kid, t, defs);
      i++;
      continue;
    }
    // A mask clips the siblings that follow it.
    const clip = `c${uid++}`;
    const paths = [];
    (function gather(n, nt) {
      (n.fillGeometry ?? []).forEach((g) =>
        paths.push(`<path d="${g.path}" transform="${matrix(nt)}"/>`),
      );
      (n.children ?? []).forEach((c) =>
        gather(c, c.relativeTransform ? multiply(nt, c.relativeTransform) : nt),
      );
    })(kid, kid.relativeTransform ? multiply(t, kid.relativeTransform) : t);
    defs.push(`<clipPath id="${clip}">${paths.join('')}</clipPath>`);
    let inner = '';
    for (i++; i < kids.length; i++) inner += draw(kids[i], t, defs);
    body += `<g clip-path="url(#${clip})">${inner}</g>`;
  }
  if (node.clipsContent && node.size) {
    const clip = `c${uid++}`;
    defs.push(
      `<clipPath id="${clip}"><rect width="${node.size.x}" height="${node.size.y}" transform="${matrix(t)}"/></clipPath>`,
    );
    body = `<g clip-path="url(#${clip})">${body}</g>`;
  }
  const opacity =
    node.opacity !== undefined && node.opacity < 1 ? ` opacity="${node.opacity}"` : '';
  const blend = node.blendMode === 'MULTIPLY' ? ' style="mix-blend-mode:multiply"' : '';
  return opacity || blend ? `<g${opacity}${blend}>${body}</g>` : body;
}

const require = createRequire(new URL('../../../packages/ui-web/package.json', import.meta.url));
const { chromium } = require('@playwright/test');
const browser = await chromium.launch();
const ids = wanted.length ? wanted : page.children.map((c) => c.id);
for (const id of ids) {
  const node = byId.get(id);
  if (!node) throw new Error(`No node ${id} on the components page`);
  const { width, height } = node.absoluteBoundingBox;
  const origin = [
    [1, 0, -node.relativeTransform[0][2]],
    [0, 1, -node.relativeTransform[1][2]],
  ];
  const defs = [];
  const body = draw(node, origin, defs);
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}"><defs>${defs.join('')}</defs>${body}</svg>`;
  const name = `${id.replace(':', '-')} ${node.name.replace(/[\\/:*?"<>|]/g, '_')}`;
  writeFileSync(join(outDir, `${name}.svg`), svg);
  const tab = await browser.newPage({
    deviceScaleFactor: 1.5,
    viewport: { width: Math.ceil(width), height: Math.ceil(height) },
  });
  await tab.setContent(`<html><body style="margin:0">${svg}</body></html>`, {
    waitUntil: 'networkidle',
  });
  await tab.screenshot({ path: join(outDir, `${name}.png`) });
  await tab.close();
  console.log(join(outDir, `${name}.png`));
}
await browser.close();
