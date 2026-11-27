// «التشريح والمقاسات» of a board: the component tokens a component reads
// (packages/design-tokens/tokens/component/, slice D.W1), each part with its
// size or colour in every state, the token's name, what it points at and its
// light value. A file names its readers in `$extensions["app.foxdrop"]`; a
// component shows a file's tokens only where its own sources (its folder and
// the shared style modules it imports) read the token's CSS variable, since one
// file (input.json) serves eleven components.
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { PACKAGE_DIR } from '../bundle.ts';

const TOKENS_DIR = path.join(PACKAGE_DIR, '../design-tokens/tokens/component');
const TOKENS_CSS = path.join(PACKAGE_DIR, '../design-tokens/generated/tokens.css');
const SRC = path.join(PACKAGE_DIR, 'src');

/** Path segments that name a state or density, not a part: they become columns. */
export const STATE_WORDS = [
  'hover',
  'pressed',
  'focus',
  'disabled',
  'invalid',
  'selected',
  'checked',
  'active',
  'compact',
] as const;

export interface Cell {
  /** The CSS variable, `--fd-button-primary-background-hover`. */
  variable: string;
  /** What it points at in the token file, `{color.primary-hover}`. */
  ref: string;
  /** Its value in the light theme, as tokens.css writes it. */
  value: string;
  type: string;
}

export interface Part {
  name: string;
  /** By column: `rest` or one of STATE_WORDS. */
  cells: Record<string, Cell>;
}

export interface TokenFile {
  file: string;
  readers: { web: string[]; flutter: string[] };
  columns: string[];
  parts: Part[];
}

interface Node {
  $value?: unknown;
  $type?: string;
  $extensions?: { 'app.foxdrop'?: { web?: string[]; flutter?: string[] } };
  [key: string]: unknown;
}

/** The light theme's variables (`:root`, before any `[data-theme]` block). */
export function lightValues(css = readFileSync(TOKENS_CSS, 'utf8')): Map<string, string> {
  const root = css.slice(css.indexOf(':root'), css.indexOf('[data-theme="dark"]'));
  const out = new Map<string, string>();
  for (const m of root.matchAll(/(--fd-[\w-]+):\s*([^;]+);/g)) out.set(m[1] ?? '', m[2] ?? '');
  return out;
}

/** The text of a component's sources and of the src modules they import, tests and stories apart. */
export function sourcesOf(folder: string): string {
  const seen = new Set<string>();
  const read = (file: string): string => {
    if (seen.has(file) || !existsSync(file)) return '';
    seen.add(file);
    const text = readFileSync(file, 'utf8');
    const imports = [...text.matchAll(/from '(\.\.?\/[^']+)'/g)].map((m) => m[1] ?? '');
    return [
      text,
      ...imports.map((spec) => {
        const base = path.resolve(path.dirname(file), spec);
        return read(existsSync(`${base}.tsx`) ? `${base}.tsx` : `${base}.ts`);
      }),
    ].join('\n');
  };
  const dir = path.join(SRC, folder);
  return readdirSync(dir)
    .filter((f) => /\.tsx?$/.test(f) && !/\.(test|stories)\.tsx?$/.test(f))
    .map((f) => read(path.join(dir, f)))
    .join('\n');
}

/** Every token file a component's folder reads, with only the tokens its sources use. */
export function anatomy(folder: string, values = lightValues()): TokenFile[] {
  const sources = sourcesOf(folder);
  const out: TokenFile[] = [];
  // The folder is gone while no component file exists (D.R1).
  for (const file of (existsSync(TOKENS_DIR) ? readdirSync(TOKENS_DIR) : [])
    .filter((f) => f.endsWith('.json'))
    .sort()) {
    const json = JSON.parse(readFileSync(path.join(TOKENS_DIR, file), 'utf8')) as Record<
      string,
      Node
    >;
    const [top, node] = Object.entries(json)[0] ?? [];
    if (!top || !node) continue;
    const readers = node.$extensions?.['app.foxdrop'] ?? {};
    if (!(readers.web ?? []).includes(folder)) continue;
    const parts = new Map<string, Part>();
    const columns = new Set<string>(['rest']);
    const walk = (at: Node, trail: string[], type: string | undefined) => {
      const own = at.$type ?? type;
      if (at.$value !== undefined) {
        const variable = `--fd-${[top, ...trail].join('-')}`;
        if (!new RegExp(`${variable}(?![\\w-])`).test(sources)) return;
        const words = trail.flatMap((s) => s.split('-'));
        const state = STATE_WORDS.find((w) => words.includes(w)) ?? 'rest';
        const name = trail
          .map((s) =>
            s
              .split('-')
              .filter((w) => w !== state)
              .join('-'),
          )
          .filter(Boolean)
          .join(' · ');
        const part = parts.get(name) ?? { name: name || top, cells: {} };
        part.cells[state] = {
          variable,
          ref: String(at.$value),
          value: values.get(variable) ?? '',
          type: own ?? '',
        };
        parts.set(name, part);
        columns.add(state);
        return;
      }
      for (const [key, child] of Object.entries(at)) {
        if (key.startsWith('$') || typeof child !== 'object' || child === null) continue;
        walk(child as Node, [...trail, key], own);
      }
    };
    walk(node, [], undefined);
    if (parts.size === 0) continue;
    out.push({
      file,
      readers: { web: readers.web ?? [], flutter: readers.flutter ?? [] },
      columns: ['rest', ...STATE_WORDS.filter((w) => columns.has(w))],
      parts: [...parts.values()],
    });
  }
  return out;
}
