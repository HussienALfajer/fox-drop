// Adds the components to the Design System files:
//   pnpm --filter @fox-drop/ui-web design-system
// Run it after `pnpm --filter @fox-drop/design-tokens design-system` (that one
// empties .design-system/system first); this one only adds files under
// project/components/. Publishing is in packages/design-tokens/CLAUDE.md «Sync».
import { mkdirSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { buildBundle, COMPONENTS, PACKAGE_DIR } from './bundle.ts';
import { preview, readme, typesDoc } from './docs.ts';

const OUT = path.join(PACKAGE_DIR, '../design-tokens/.design-system/system/project/components');

function write(file: string, text: string): void {
  const target = path.join(OUT, file);
  mkdirSync(path.dirname(target), { recursive: true });
  writeFileSync(target, text);
  console.log(`wrote ${target} (${Buffer.byteLength(text)} bytes)`);
}

const { js, css } = await buildBundle();
write('bundle.js', js);
write('bundle.css', css);
write('index.d.ts', typesDoc());
for (const name of COMPONENTS) {
  write(`${name}/README.md`, readme(name));
  write(`${name}/preview.html`, preview(name));
}
