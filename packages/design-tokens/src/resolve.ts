// Style Dictionary reads the DTCG sources and resolves every reference; the
// formats in generate.ts write the outputs from these resolved tokens.
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import StyleDictionary from 'style-dictionary';

export const PACKAGE_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

export const THEMES = ['light', 'dark', 'captainLight', 'captainDark'] as const;
export type Theme = (typeof THEMES)[number];

export interface Token {
  /** The path without its layer, such as ['color', 'surface']. */
  path: string[];
  type: string;
  value: unknown;
  description?: string;
}

const SOURCES: Record<Theme, { include: string[]; source: string[] }> = {
  light: { include: [], source: ['tokens/semantic/light.json'] },
  dark: { include: [], source: ['tokens/semantic/dark.json'] },
  // The captain override replaces some keys of a theme: a source token
  // overrides an included one without a collision warning.
  captainLight: {
    include: ['tokens/semantic/light.json'],
    source: ['tokens/semantic/captain.json'],
  },
  captainDark: {
    include: ['tokens/semantic/dark.json'],
    source: ['tokens/semantic/captain-dark.json'],
  },
};

// Style Dictionary's globs take forward slashes, on Windows too.
const inPackage = (file: string) => `${PACKAGE_DIR.replaceAll('\\', '/')}/${file}`;

const COMMON = ['tokens/primitive/*.json', 'tokens/semantic/base.json', 'tokens/component/*.json'];

/** Every resolved token of a theme, primitives included, keyed by its dotted path. */
export async function resolveTheme(theme: Theme): Promise<Map<string, Token>> {
  const { include, source } = SOURCES[theme];
  const sd = new StyleDictionary({
    include: [...COMMON, ...include].map(inPackage),
    source: source.map(inPackage),
    platforms: { resolved: {} },
    log: { verbosity: 'silent', warnings: 'error' },
  });
  const { allTokens } = await sd.getPlatformTokens('resolved');
  const tokens = new Map<string, Token>();
  for (const token of allTokens) {
    const tokenPath = token.path;
    tokens.set(tokenPath.join('.'), {
      path: tokenPath,
      type: String(token.$type ?? token.type),
      value: token.$value ?? token.value,
      ...(token.$description ? { description: String(token.$description) } : {}),
    });
  }
  return tokens;
}

export async function resolveAll(): Promise<Record<Theme, Map<string, Token>>> {
  const entries = await Promise.all(
    THEMES.map(async (theme) => [theme, await resolveTheme(theme)] as const),
  );
  return Object.fromEntries(entries) as Record<Theme, Map<string, Token>>;
}

/** Primitives are for semantic tokens only (architecture §9.5 R1): never exported. */
export const isPrimitive = (token: Token) => token.path[0] === 'primitive';

/** The hex value of a colour token, or an error naming it. */
export function colour(tokens: Map<string, Token>, name: string): string {
  const token = tokens.get(name);
  if (!token || token.type !== 'color' || typeof token.value !== 'string')
    throw new Error(`No colour token ${name}`);
  return token.value;
}
