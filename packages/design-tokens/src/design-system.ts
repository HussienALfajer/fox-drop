// The tokens of the Fox Drop Design System artifact (architecture §9.8), in
// the Design System type's tokens.json shape: every family a list of
// {name, value, usage}, colours per theme as hex. Committed as
// generated/design-system.json and covered by the drift test of generate.ts.
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { cssValue, exported } from './generate.ts';
import { PACKAGE_DIR, type Theme, type Token } from './resolve.ts';

type Tokens = Map<string, Token>;

/** The four themes, light first: a value a later theme lacks inherits the first one's. */
export const DS_THEMES: { id: string; name: string; theme: Theme }[] = [
  { id: 'light', name: 'Light', theme: 'light' },
  { id: 'dark', name: 'Dark', theme: 'dark' },
  { id: 'captain-light', name: 'Captain light', theme: 'captainLight' },
  { id: 'captain-dark', name: 'Captain dark', theme: 'captainDark' },
];

/** The CoFo files the system carries (owner, 2026-11-23): 400, 500 and 700. */
export const FONT_FILES: Record<string, string> = {
  regular: 'CoFoSansProArabic-Regular.ttf',
  medium: 'CoFoSansProArabic-Medium.ttf',
  bold: 'CoFoSansProArabic-Bold.ttf',
};

const SURFACES: Record<string, string> = { phone: 'Phone', panel: 'Panel', captain: 'Captain' };

interface Entry {
  name: string;
  value: unknown;
  usage: string;
}

function usage(token: Token): string {
  if (!token.description) throw new Error(`${token.path.join('.')} has no $description`);
  return token.description;
}

const group = (tokens: Tokens, name: string) =>
  exported(tokens).filter((token) => token.path[0] === name);

/** A list family: `{prefix}-{rest of the path}`, the value as CSS. */
const family = (tokens: Tokens, name: string, prefix: string): { tokens: Entry[] } => ({
  tokens: group(tokens, name).map((token) => ({
    name: [prefix, ...token.path.slice(1)].join('-'),
    value: cssValue(token),
    usage: usage(token),
  })),
});

const version = () =>
  (JSON.parse(readFileSync(path.join(PACKAGE_DIR, 'package.json'), 'utf8')) as { version: string })
    .version;

export function designSystem(themes: Record<Theme, Tokens>): string {
  const light = themes.light;
  const colours = group(light, 'color').map((token) => {
    const key = token.path.join('.');
    return {
      name: token.path.slice(1).join('-'),
      value: Object.fromEntries(
        DS_THEMES.map(({ id, theme }) => [id, String(themes[theme].get(key)!.value)]),
      ),
      usage: usage(token),
    };
  });

  const type = group(light, 'type');
  const scales = [...new Set(type.map((token) => token.path[1]!))];
  const roles = [...new Set(type.map((token) => token.path[2]!))];
  const get = (scale: string, role: string, property: string) =>
    light.get(`type.${scale}.${role}.${property}`)!.value;

  const tokens = {
    name: 'Fox Drop',
    version: 1,
    color: {
      themes: DS_THEMES.map(({ id, name }) => ({ id, name })),
      tokens: colours,
    },
    type: {
      fonts: Object.entries(FONT_FILES).map(([weight, file]) => ({
        family: (light.get('font.family.sans')!.value as string[])[0],
        file: `fonts/${file}`,
        weight: String(light.get(`font.weight.${weight}`)!.value),
        style: 'normal',
      })),
      families: { sans: cssValue(light.get('font.family.sans')!) },
      groups: scales.map((scale) => ({
        name: SURFACES[scale] ?? scale,
        family: 'sans',
        styles: roles.map((role) => ({
          name: `${scale}-${role}`,
          fontSize: String(get(scale, role, 'size')),
          lineHeight: Number(get(scale, role, 'line-height')),
          fontWeight: Number(get(scale, role, 'weight')),
        })),
      })),
    },
    spacing: family(light, 'space', 'space'),
    radius: family(light, 'radius', 'radius'),
    shadow: family(light, 'elevation', 'elevation'),
    size: family(light, 'size', 'size'),
    meta: {
      source: 'github',
      repo: 'HussienALfajer/fox-drop',
      package: 'packages/design-tokens',
      version: version(),
      paths: { tokens: ['packages/design-tokens/tokens'], fonts: ['.fonts/cofo-sans-pro-arabic'] },
    },
  };
  return `${JSON.stringify(tokens, null, 2)}\n`;
}
