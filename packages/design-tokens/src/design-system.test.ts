import { readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import { DS_THEMES, designSystem } from './design-system.ts';
import { PACKAGE_DIR, resolveAll } from './resolve.ts';

interface Entry {
  name: string;
  value: unknown;
  usage: string;
}
interface DesignTokens {
  color: { themes: { id: string }[]; tokens: Entry[] };
  type: {
    fonts: { file: string; weight: string }[];
    groups: { name: string; styles: { name: string; fontSize: string }[] }[];
  };
  [family: string]: unknown;
}

const tokens = JSON.parse(designSystem(await resolveAll())) as DesignTokens;
const lists = Object.entries(tokens).filter(
  ([key, value]) =>
    key !== 'type' && typeof value === 'object' && value !== null && 'tokens' in value,
);
const entries = lists.flatMap(([, value]) => (value as { tokens: Entry[] }).tokens);
const NAME = /^[A-Za-z0-9][A-Za-z0-9_.-]{0,63}$/;

describe('the Design System tokens (architecture §9.8)', () => {
  it('uses list families the page can read: colour, spacing, radius, shadow, size', () => {
    expect(lists.map(([key]) => key)).toEqual(['color', 'spacing', 'radius', 'shadow', 'size']);
  });

  it('names every token once, in the allowed characters', () => {
    const names = entries.map((entry) => entry.name);
    for (const name of names) expect(name).toMatch(NAME);
    expect(new Set(names).size).toBe(names.length);
    const styles = tokens.type.groups.flatMap((group) => group.styles.map((style) => style.name));
    for (const name of styles) expect(name).toMatch(NAME);
    expect(new Set(styles).size).toBe(styles.length);
  });

  it('gives every token a usage', () => {
    for (const entry of entries) expect(entry.usage, entry.name).toMatch(/\S/);
  });

  it('writes plain values: no var(), color-mix() or named colours', () => {
    for (const entry of entries) {
      const text = JSON.stringify(entry.value);
      expect(text, entry.name).not.toMatch(/var\(|color-mix\(|\b(transparent|currentColor)\b/i);
    }
    for (const entry of tokens.color.tokens)
      for (const value of Object.values(entry.value as Record<string, string>))
        expect(value, entry.name).toMatch(/^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$/);
  });

  it('has every semantic colour in every theme, light first', () => {
    expect(tokens.color.themes.map((theme) => theme.id)).toEqual(DS_THEMES.map((t) => t.id));
    const light = JSON.parse(
      readFileSync(path.join(PACKAGE_DIR, 'tokens/semantic/light.json'), 'utf8'),
    ) as { color: Record<string, unknown> };
    const keys: string[] = [];
    const walk = (node: Record<string, unknown>, at: string[]) => {
      if ('$value' in node) return void keys.push(at.join('-'));
      for (const [key, child] of Object.entries(node))
        if (!key.startsWith('$')) walk(child as Record<string, unknown>, [...at, key]);
    };
    walk(light.color, []);
    const byName = new Map(tokens.color.tokens.map((entry) => [entry.name, entry]));
    for (const key of keys) {
      const value = byName.get(key)?.value as Record<string, string> | undefined;
      expect(Object.keys(value ?? {}), key).toEqual(DS_THEMES.map((t) => t.id));
    }
    expect(byName.size).toBe(keys.length);
  });

  it('carries the three CoFo weights as files and the three type scales', () => {
    expect(tokens.type.fonts.map((font) => font.weight)).toEqual(['400', '500', '700']);
    for (const font of tokens.type.fonts) expect(font.file).toMatch(/^fonts\/CoFo[\w-]+\.ttf$/);
    expect(tokens.type.groups.map((group) => group.name)).toEqual(['Phone', 'Panel', 'Captain']);
    for (const group of tokens.type.groups)
      for (const style of group.styles) expect(style.fontSize).toMatch(/^\d+px$/);
  });
});
