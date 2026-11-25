// Adds the components to the Design System files:
//   pnpm --filter @fox-drop/ui-web design-system [--blobs <file>]
// Run it after `pnpm --filter @fox-drop/design-tokens design-system` (that one
// empties .design-system/system first); this one only adds files under
// project/components/. With the design-tokens `--blobs` file, each card ends
// with its Flutter golden from the asset store. Publishing is in
// packages/design-tokens/CLAUDE.md «Sync».
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { buildBundle, COMPONENTS, PACKAGE_DIR } from './bundle.ts';
import { type FlutterImage, preview, readme, registry, typesDoc } from './docs.ts';

const OUT = path.join(PACKAGE_DIR, '../design-tokens/.design-system/system/project/components');
const GOLDENS = path.join(PACKAGE_DIR, '../core_ui/test/golden/goldens/design-system');

function write(file: string, text: string): void {
  const target = path.join(OUT, file);
  mkdirSync(path.dirname(target), { recursive: true });
  writeFileSync(target, text);
  console.log(`wrote ${target} (${Buffer.byteLength(text)} bytes)`);
}

/** The golden of a component's Flutter twin, given the upload replies. */
function image(name: string, blobs: Record<string, { blob: string }>): FlutterImage | undefined {
  const golden = registry().find((e) => e.name === name)?.golden;
  if (!golden) return undefined;
  const upload = blobs[`Flutter/${golden}`];
  if (!upload) throw new Error(`No blob id for Flutter/${golden} in the --blobs file`);
  const png = readFileSync(path.join(GOLDENS, golden));
  return { blob: upload.blob, width: png.readUInt32BE(16), height: png.readUInt32BE(20) };
}

const blobsAt = process.argv.indexOf('--blobs');
const blobs =
  blobsAt === -1
    ? undefined
    : (
        JSON.parse(readFileSync(process.argv[blobsAt + 1]!, 'utf8')) as {
          assets: Record<string, { blob: string }>;
        }
      ).assets;

const { js, css } = await buildBundle();
write('bundle.js', js);
write('bundle.css', css);
write('index.d.ts', typesDoc());
for (const name of COMPONENTS) {
  write(`${name}/README.md`, readme(name));
  write(`${name}/preview.html`, preview(name, blobs && image(name, blobs)));
}
