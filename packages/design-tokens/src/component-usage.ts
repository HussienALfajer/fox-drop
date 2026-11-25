// The component layer's folders (architecture §9.2, slice D.W1): a file of
// tokens/component/ declares the ui-web and core_ui folders that read it in
// `$extensions["app.foxdrop"]`, and every token it holds is read in them: on
// the web as its CSS variable, in Flutter as `<component>.<field>`
// (`theme.button.gap`, `components.button.gap`). A token only one
// side needs says so with `"sides": ["web"]` (or `["flutter"]`). A text scan
// of the sources, no build; src/component-usage.test.ts runs it.
import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import path from 'node:path';
import { camel } from './generate.ts';
import { PACKAGE_DIR } from './resolve.ts';

export const COMPONENT_DIR = path.join(PACKAGE_DIR, 'tokens/component');
export const ROOTS = {
  web: path.join(PACKAGE_DIR, '../ui-web/src'),
  flutter: path.join(PACKAGE_DIR, '../core_ui/lib/src'),
};

type Side = keyof typeof ROOTS;
const SIDES: Side[] = ['web', 'flutter'];
const LABEL: Record<Side, string> = { web: 'web', flutter: 'Flutter' };
const EXTENSIONS: Record<Side, RegExp> = { web: /\.(tsx?|css)$/, flutter: /\.dart$/ };

interface Node {
  $value?: unknown;
  $extensions?: { 'app.foxdrop'?: Partial<Record<Side, string[]>> & { sides?: Side[] } };
  [key: string]: unknown;
}

/** A token's leaf paths and the sides that must read it. */
function leaves(node: Node, at: string[], out: { path: string[]; sides: Side[] }[]) {
  if ('$value' in node) {
    out.push({ path: at, sides: node.$extensions?.['app.foxdrop']?.sides ?? SIDES });
    return out;
  }
  for (const [key, child] of Object.entries(node))
    if (!key.startsWith('$')) leaves(child as Node, [...at, key], out);
  return out;
}

/** Every source file under a folder, stories and tests left out. */
function sources(folder: string, side: Side): string[] {
  return readdirSync(folder, { recursive: true, encoding: 'utf8' })
    .map((file) => path.join(folder, file))
    .filter(
      (file) =>
        EXTENSIONS[side].test(file) &&
        !/\.(stories|test)\.tsx?$/.test(file) &&
        statSync(file).isFile(),
    );
}

const escape = (text: string) => text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

/** How each side names a token: `--fd-button-gap`, `.gap`. */
const reads: Record<Side, (tokenPath: string[]) => { name: string; pattern: RegExp }> = {
  web: (tokenPath) => {
    const name = `--fd-${tokenPath.join('-')}`;
    return { name, pattern: new RegExp(`${escape(name)}(?![\\w-])`) };
  },
  // With its component, as `theme.button.gap` and `components.button.gap`
  // read it: a bare `.gap` would also match `this.gap`.
  flutter: (tokenPath) => {
    const name = `${camel(tokenPath.slice(0, 1))}.${camel(tokenPath.slice(1))}`;
    return { name, pattern: new RegExp(`\\b${escape(name)}\\b`) };
  },
};

export function componentUsage(
  file: string,
  roots: Record<Side, string>,
): { declared: boolean; problems: string[] } {
  const json = JSON.parse(readFileSync(file, 'utf8')) as Record<string, Node>;
  const problems: string[] = [];
  let declared = false;
  for (const [name, node] of Object.entries(json)) {
    const folders = node.$extensions?.['app.foxdrop'];
    if (!folders) continue;
    declared = true;
    const tokens = leaves(node, [name], []);
    for (const side of SIDES) {
      const texts: string[] = [];
      for (const folder of folders[side] ?? []) {
        const dir = path.join(roots[side], folder);
        if (!existsSync(dir)) {
          problems.push(`${name}: the ${side} folder ${folder} (${dir}) does not exist`);
          continue;
        }
        texts.push(...sources(dir, side).map((source) => readFileSync(source, 'utf8')));
      }
      for (const token of tokens) {
        if (!token.sides.includes(side)) continue;
        const { name: read, pattern } = reads[side](token.path);
        if (!texts.some((text) => pattern.test(text)))
          problems.push(
            `${token.path.join('.')}: no ${LABEL[side]} file in ${(folders[side] ?? []).join(', ') || '(none declared)'} reads ${read}`,
          );
      }
    }
  }
  return { declared, problems };
}
