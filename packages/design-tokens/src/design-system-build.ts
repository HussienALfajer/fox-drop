// Builds the files of the Fox Drop Design System artifact (architecture §9.8)
// into the ignored .design-system/system/:
//   pnpm --filter @fox-drop/design-tokens design-system [--blobs <file>]
// Without --blobs it writes every file but the index: upload the assets
// first, save the asset-to-blob map, then rerun with --blobs to write the
// index (`project/design-system.json`). Claude publishes the folder with the
// Artifact tool (packages/design-tokens/CLAUDE.md «Sync»).
import { createHash } from 'node:crypto';
import { mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { designSystem, FONT_FILES } from './design-system.ts';
import { PACKAGE_DIR, resolveAll } from './resolve.ts';

const ROOT = path.resolve(PACKAGE_DIR, '../..');
const SOURCE = path.join(PACKAGE_DIR, 'design-system');
export const OUT = path.join(PACKAGE_DIR, '.design-system/system');
export const FONTS = path.join(ROOT, '.fonts/cofo-sans-pro-arabic');
const FLUTTER_IMAGES = 'packages/core_ui/test/golden/goldens/design-system';
const FLUTTER_CARDS = path.join(ROOT, 'packages/core_ui/design-system/cards.json');

export const MAX_FONT = 1024 * 1024;
export const MAX_PNG = 15 * 1024 * 1024;
export const MAX_SVG = 2 * 1024 * 1024;

/** The asset groups in tile order: each file is an upload the index names. */
export const ASSET_GROUPS: { name: string; tile: string; dir: string; files: RegExp }[] = [
  { name: 'Logos', tile: 'l', dir: 'docs/brand/logo/lockups', files: /\.svg$/ },
  { name: 'Logos', tile: 'l', dir: 'docs/brand/logo/mark', files: /\.svg$/ },
  // The broken-edges icons wait for the owner to name their purpose.
  { name: 'App icon', tile: 'm', dir: 'docs/brand/app-icon/svg', files: /^app-icon-\d+\.svg$/ },
  { name: 'Icons', tile: 'm', dir: 'packages/design-tokens/icons', files: /\.svg$/ },
  // One image per Flutter component, drawn by core_ui's design-system goldens.
  { name: 'Flutter', tile: 'l', dir: FLUTTER_IMAGES, files: /\.png$/ },
];

const GROUP_README: Record<string, string> = {
  Logos:
    '# Logos\n\nThe fox mark and the four lockups, as drawn in the brand pack. The file name says the colours: `mark-ivory-on-orange-square` is an ivory fox on an orange square, `-drop` files carry the drop backing, plain `mark-orange`, `mark-ivory` and `mark-blue` are the fox alone on a transparent ground. Never recolour, rotate, stretch or shadow a mark; use an Arabic lockup on Arabic screens.\n',
  'App icon':
    '# App icon\n\nThe app icon artwork. The ivory fox on orange is the official icon; the others are alternatives the owner has not named.\n',
  Flutter:
    "# Flutter\n\nOne image per component of `core_ui`, the Flutter design system of the customer, captain and restaurant apps, drawn by its golden tests (`packages/core_ui/test/golden/design_system_cards_test.dart`) in the phone theme on the apps' ground, the captain theme where it differs. The cards in the Flutter group show them; the web components beside them are live.\n",
  Icons:
    '# Icons\n\nThe first 44 line icons (brand expression §10), drawn after the Figma file\'s icons. Each file is the source: `viewBox="0 0 24 24"`, `stroke="currentColor"`, stroke 2, round caps and joins, no fill, every point inside the live area 2..22. Colour it with the text colour: `on-surface` by default, `on-primary` inside the orange active circle. Sizes: `size-icon-sm` 16, `size-icon-md` 24, `size-icon-lg` 32; the stroke scales with the size. `back`, `motorcycle` and `car` are drawn left to right and flip in RTL. In code, use `@fox-drop/design-tokens/icons` (web) or `FoxIcons` (Flutter), never these files.\n',
};

export type Files = Map<string, Buffer | string>;

/** The assets as `<Group>/<file>` to the bytes. */
export function assets(): Map<string, Buffer> {
  const out = new Map<string, Buffer>();
  for (const group of ASSET_GROUPS)
    for (const file of readdirSync(path.join(ROOT, group.dir)).sort())
      if (group.files.test(file))
        out.set(`${group.name}/${file}`, readFileSync(path.join(ROOT, group.dir, file)));
  return out;
}

/** The three CoFo files, each checked against the pinned SHA-256. */
export function fonts(): Map<string, Buffer> {
  const manifest = JSON.parse(
    readFileSync(path.join(ROOT, 'docs/brand/fonts-manifest.json'), 'utf8'),
  ) as { files: { path: string; sha256: string }[] };
  const out = new Map<string, Buffer>();
  for (const file of Object.values(FONT_FILES)) {
    let bytes: Buffer;
    try {
      bytes = readFileSync(path.join(FONTS, file));
    } catch {
      throw new Error(`${file} is missing from .fonts/: run pnpm fonts:fetch`);
    }
    const pinned = manifest.files.find((f) => f.path === `cofo-sans-pro-arabic/${file}`);
    const sha = createHash('sha256').update(bytes).digest('hex');
    if (sha !== pinned?.sha256) throw new Error(`${file} does not match fonts-manifest.json`);
    if (bytes.length > MAX_FONT) throw new Error(`${file} is over the 1 MB font cap`);
    out.set(file, bytes);
  }
  return out;
}

const read = (file: string) => readFileSync(path.join(SOURCE, file), 'utf8');

/** Every file under project/ but the index. */
export function systemFiles(tokens: string, fontFiles: Map<string, Buffer>): Files {
  const files: Files = new Map();
  files.set('project/tokens.json', tokens);
  files.set('project/README.md', read('README.md'));
  files.set('project/components/Cover/preview.html', read('Cover/preview.html'));
  for (const [file, bytes] of fontFiles) files.set(`project/fonts/${file}`, bytes);
  for (const [name, text] of Object.entries(GROUP_README))
    files.set(`project/assets/${name}/README.md`, text);
  return files;
}

export interface Blobs {
  /** When the system was first indexed; kept on every later sync. */
  created: string;
  /** `<Group>/<file>` to the blob id and the size the upload reply gave. */
  assets: Record<string, { blob: string; size: number }>;
}

/** The index (the type's «A system kept in files»), written last. */
export function index(blobs: Blobs, uploads: Map<string, Buffer>, now: string): string {
  const groups = [...new Set(ASSET_GROUPS.map((g) => g.name))];
  const assetGroups = Object.fromEntries(
    groups.map((name) => {
      const names = [...uploads.keys()]
        .filter((key) => key.startsWith(`${name}/`))
        .map((key) => key.slice(name.length + 1));
      const files = Object.fromEntries(
        names.map((file) => {
          const upload = blobs.assets[`${name}/${file}`];
          if (!upload) throw new Error(`No blob id for ${name}/${file} in the --blobs file`);
          return [
            file,
            {
              name: file,
              blob: upload.blob,
              size: upload.size,
              type: file.endsWith('.png') ? 'image/png' : 'image/svg+xml',
            },
          ];
        }),
      );
      const tile = ASSET_GROUPS.find((g) => g.name === name)!.tile;
      return [name, { name, tile, order: names, files }];
    }),
  );
  const version = (
    JSON.parse(readFileSync(path.join(PACKAGE_DIR, 'package.json'), 'utf8')) as { version: string }
  ).version;
  const value = {
    v: 3,
    layout: 'files',
    createdOnFiles: { v: 1, at: blobs.created },
    title: 'Fox Drop Design System',
    namespace: 'FoxDrop',
    editing: 'code',
    libraries: [],
    sections: {},
    groups,
    assetGroups,
    blobs: {},
    docs: { readme: 'project/README.md', sections: [] },
    lastChange: {
      by: 'Claude',
      at: now,
      via: 'Claude Code · HussienALfajer/fox-drop packages/design-tokens',
      note: `Synced from the design tokens ${version}.`,
    },
  };
  return `${JSON.stringify(value, null, 2)}\n`;
}

interface FlutterCard {
  name: string;
  file: string;
  /** «Flutter · Forms»: the Flutter group the card sits in. */
  group: string;
  summary: string;
  web: string | null;
}

/** A PNG's width and height, from its header. */
export function pngSize(bytes: Buffer): { width: number; height: number } {
  if (bytes.toString('latin1', 1, 4) !== 'PNG') throw new Error('not a PNG');
  return { width: bytes.readUInt32BE(16), height: bytes.readUInt32BE(20) };
}

/**
 * One card per Flutter component: its README and a preview that shows the
 * golden image from the asset store, so it needs the blob ids.
 */
export function flutterCards(blobs: Blobs, uploads: Map<string, Buffer>): Files {
  const cards = JSON.parse(readFileSync(FLUTTER_CARDS, 'utf8')) as FlutterCard[];
  const files: Files = new Map();
  for (const card of cards) {
    const key = `Flutter/${card.file}`;
    const bytes = uploads.get(key);
    const upload = blobs.assets[key];
    if (!bytes) throw new Error(`${card.file} is missing from ${FLUTTER_IMAGES}`);
    if (!upload) throw new Error(`No blob id for ${key} in the --blobs file`);
    const { width, height } = pngSize(bytes);
    // The image fills the card's width; the card is as tall as it then is.
    const cardHeight = Math.ceil((height * 720) / width) + 32;
    const mirror = card.web ? ` The web twin is the live \`${card.web}\` card.` : ' Flutter only.';
    files.set(
      `project/components/${card.name}/README.md`,
      `# ${card.name}

${card.summary}

Flutter (\`core_ui\`): an image from its golden test, in the phone theme on the apps' ground.${mirror}
`,
    );
    files.set(
      `project/components/${card.name}/preview.html`,
      `<!-- @dsCard group="${card.group}" height=${cardHeight} -->
<style>
  :root {
    color-scheme: light;
  }
  html,
  body {
    margin: 0;
  }
  #root {
    min-height: 100vh;
    box-sizing: border-box;
    padding: 16px;
    background: var(--fd-color-surface);
  }
  img {
    display: block;
    width: 100%;
    height: auto;
  }
</style>
<div id="root" dir="rtl" lang="ar">
  <img src="/_blob/${upload.blob}" alt="${card.name} in core_ui, its states side by side" />
</div>
`,
    );
  }
  return files;
}

function write(files: Files) {
  for (const [file, body] of files) {
    const target = path.join(OUT, file);
    mkdirSync(path.dirname(target), { recursive: true });
    writeFileSync(target, body);
  }
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const blobsAt = process.argv.indexOf('--blobs');
  const uploads = assets();
  if (blobsAt === -1) {
    rmSync(OUT, { recursive: true, force: true });
    write(systemFiles(designSystem(await resolveAll()), fonts()));
    // The uploads sit beside project/, not in it: they go to the asset store.
    for (const [key, bytes] of uploads) {
      const target = path.join(OUT, 'uploads', key);
      mkdirSync(path.dirname(target), { recursive: true });
      writeFileSync(target, bytes);
    }
    console.log(`wrote ${OUT}: upload uploads/*, then rerun with --blobs <file>`);
  } else {
    const blobs = JSON.parse(readFileSync(process.argv[blobsAt + 1]!, 'utf8')) as Blobs;
    write(flutterCards(blobs, uploads));
    write(
      new Map([['project/design-system.json', index(blobs, uploads, new Date().toISOString())]]),
    );
    console.log(`wrote ${path.join(OUT, 'project/design-system.json')}`);
  }
}
