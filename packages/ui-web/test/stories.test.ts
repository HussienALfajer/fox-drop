import { existsSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import * as library from '../src/index';

// R3 (architecture §9.5): every component exported by src/index.ts has
// src/<dir>/<dir>.stories.tsx, and a story for each entry of the STATES list
// in src/<dir>/<dir>.tsx. The mapping: a component `FooBar` lives in the
// folder `foo-bar`; a state `hover` is covered by a story export named
// `Hover` or ending in `Hover`. A module that also exports VARIANTS needs the
// exact name <Variant><State> (`PrimaryHover`) for every pair. Components that
// share one folder and one Storybook title, as their Flutter file does, are
// listed in FOLDERS.
const FOLDERS: Record<string, string> = {};
const kebab = (name: string) => FOLDERS[name] ?? name.replace(/(?!^)([A-Z])/g, '-$1').toLowerCase();
const pascal = (state: string) => state.charAt(0).toUpperCase() + state.slice(1);

const components = Object.entries(library).filter(
  ([name, value]) => /^[A-Z]/.test(name) && typeof value === 'function',
);

describe('stories cover every state (R3)', () => {
  // None since D.R1 (2026-11-27): an approved component joins this list.
  it('finds the components', () => {
    expect(components.map(([name]) => name).sort()).toEqual([]);
  });

  it.each(components.map(([name]) => [name, kebab(name)]))('%s', async (_, dir) => {
    const source = `${import.meta.dirname}/../src/${dir}/${dir}`;
    expect(existsSync(`${source}.stories.tsx`), `${dir}.stories.tsx`).toBe(true);
    const { STATES, VARIANTS = [''] } = (await import(`../src/${dir}/${dir}.tsx`)) as {
      STATES: readonly string[];
      VARIANTS?: readonly string[];
    };
    expect(STATES.length, `${dir} STATES`).toBeGreaterThan(0);
    const stories = await import(`../src/${dir}/${dir}.stories.tsx`);
    const names = Object.keys(stories).filter((key) => key !== 'default');
    // A module that exports VARIANTS needs <Variant><State> for every pair.
    for (const variant of VARIANTS)
      for (const state of STATES) {
        const expected = pascal(variant) + pascal(state);
        const found = variant
          ? names.includes(expected)
          : names.some((name) => name.endsWith(expected));
        expect(found, `${dir} has a story ${expected}`).toBe(true);
      }
  });
});
