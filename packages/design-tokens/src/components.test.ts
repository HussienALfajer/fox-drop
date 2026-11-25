// The component registry (architecture §9.6, §9.7): every component once,
// with its web and Flutter names, the surfaces that use it and its group.
import { readdirSync, readFileSync } from 'node:fs';
import path from 'node:path';
import { describe, expect, it } from 'vitest';
import {
  ACTS,
  COLOUR_METRICS,
  COMPONENT_GROUPS,
  DIMENSION_METRICS,
  readRegistry,
  SURFACES,
} from './components.ts';
import { PACKAGE_DIR, resolveTheme } from './resolve.ts';

const ROOT = path.resolve(PACKAGE_DIR, '../..');
const registry = readRegistry();
const PHONE = ['customer', 'captain', 'restaurant'];

/** The names in ui-web's COMPONENTS, read from its source (ui-web depends on this package). */
function webComponents(): string[] {
  const source = readFileSync(path.join(ROOT, 'packages/ui-web/scripts/bundle.ts'), 'utf8');
  const list = /export const COMPONENTS = \[([^\]]*)\]/.exec(source)?.[1];
  if (!list) throw new Error('COMPONENTS not found in ui-web/scripts/bundle.ts');
  return [...list.matchAll(/'(\w+)'/g)].map((m) => m[1]!);
}

/** The widgets core_ui's library exports: the public Fox* widgets outside `internal/`. */
function flutterWidgets(): string[] {
  const lib = path.join(ROOT, 'packages/core_ui/lib');
  const library = readFileSync(path.join(lib, 'core_ui.dart'), 'utf8');
  const out: string[] = [];
  for (const m of library.matchAll(/^export '(src\/[^']+)'([^;]*);/gm)) {
    const source = readFileSync(path.join(lib, m[1]!), 'utf8');
    const filter = m[2]!.replace(/\s+/g, ' ').trim();
    const names = (rest: string) => rest.split(',').map((s) => s.trim());
    const shown = filter.startsWith('show ') ? names(filter.slice(5)) : null;
    const hidden = filter.startsWith('hide ') ? names(filter.slice(5)) : [];
    for (const c of source.matchAll(
      /^class (Fox\w+)(?:<[^>]*>)? extends (?:StatelessWidget|StatefulWidget)\b/gm,
    )) {
      const name = c[1]!;
      if (shown && !shown.includes(name)) continue;
      if (hidden.includes(name)) continue;
      out.push(name);
    }
  }
  return out;
}

const GOLDENS = path.join(ROOT, 'packages/core_ui/test/golden/goldens/design-system');

describe('the component registry (packages/design-tokens/components.json)', () => {
  it('names each component once, by its web name', () => {
    const names = registry.components.map((c) => c.name);
    expect(new Set(names).size).toBe(names.length);
    for (const c of registry.components) {
      expect(c.name, c.name).toMatch(/^[A-Z]\w+$/);
      if (c.web !== null) expect(c.web, c.name).toBe(c.name);
    }
  });

  it('has one entry per ui-web component and names none it lacks', () => {
    const web = webComponents();
    expect(web.length).toBeGreaterThan(30);
    const named = registry.components.flatMap((c) => (c.web ? [c.web] : []));
    expect(named.sort()).toEqual([...web].sort());
  });

  it('has one entry per public core_ui widget, a part named once with its component', () => {
    const widgets = flutterWidgets();
    expect(widgets).toEqual(expect.arrayContaining(['FoxButton', 'FoxRadio', 'FoxRadioGroup']));
    const named = registry.components.flatMap((c) =>
      c.flutter ? [c.flutter, ...(c.flutterParts ?? [])] : [],
    );
    expect(new Set(named).size, 'a widget named twice').toBe(named.length);
    expect(named.sort()).toEqual([...widgets].sort());
    for (const c of registry.components)
      if (!c.flutter) expect(c.flutterParts, c.name).toBeUndefined();
  });

  it('lists in pendingWeb exactly the components without a web twin yet', () => {
    const missing = registry.components.filter((c) => c.web === null).map((c) => c.name);
    // A twin built leaves the list in the same change; one still missing stays on it.
    expect([...registry.pendingWeb].sort()).toEqual(missing.sort());
    for (const c of registry.components)
      if (c.web === null) expect(c.flutter, `${c.name} has neither side`).not.toBeNull();
  });

  it('gives each component a known group, known surfaces and a one-sentence summary', () => {
    for (const c of registry.components) {
      expect(COMPONENT_GROUPS, c.name).toContain(c.group);
      expect(c.surfaces.length, c.name).toBeGreaterThan(0);
      expect(new Set(c.surfaces).size, c.name).toBe(c.surfaces.length);
      for (const s of c.surfaces) expect(SURFACES, `${c.name}: ${s}`).toContain(s);
      expect(c.summary, c.name).toMatch(/^[A-Z].*\.$/);
    }
  });

  it('marks phoneOnly exactly the components neither the portal nor the panel uses', () => {
    for (const c of registry.components) {
      const web = c.surfaces.some((s) => s === 'portal' || s === 'panel');
      expect(c.phoneOnly, c.name).toBe(!web);
    }
  });

  it('keeps a component without a Flutter widget off the three apps', () => {
    for (const c of registry.components)
      if (c.flutter === null)
        for (const s of c.surfaces) expect(PHONE, `${c.name}: ${s}`).not.toContain(s);
  });

  it('names one golden per Flutter component, each image used once', () => {
    const images = readdirSync(GOLDENS).filter((f) => f.endsWith('.png'));
    const named: string[] = [];
    for (const c of registry.components) {
      if (c.flutter === null) expect(c.golden, c.name).toBeNull();
      else {
        expect(c.golden, c.name).toMatch(/^Fox\w+\.png$/);
        named.push(c.golden!);
      }
    }
    expect(named.sort()).toEqual(images.sort());
  });
});

// The parity check (D.P2, architecture §9.8): ui-web's e2e/parity.spec.ts and
// core_ui's test/parity_test.dart measure these states against these tokens.
describe("the registry's parity metrics", () => {
  const FIRST = ['Button', 'TextField', 'TextArea', 'SearchField', 'Checkbox', 'Switch'];
  const measured = registry.components.filter((c) => c.metrics);

  it('measures the Button and the form components with their own tokens', () => {
    expect(measured.map((c) => c.name)).toEqual(expect.arrayContaining(FIRST));
  });

  it('names known metrics, acts and platforms, each state once', () => {
    const metrics: string[] = [...DIMENSION_METRICS, ...COLOUR_METRICS];
    for (const c of measured) {
      const m = c.metrics!;
      expect(m.web, c.name).not.toBe('');
      expect(c.web ?? c.flutter, c.name).not.toBeNull();
      const states = m.states.map((s) => s.state);
      expect(new Set(states).size, `${c.name}: a state named twice`).toBe(states.length);
      expect(states.length, c.name).toBeGreaterThan(0);
      for (const s of m.states) {
        const where = `${c.name}/${s.state}`;
        expect(s.state, where).toMatch(/^[a-z][a-z0-9-]*$/);
        for (const key of [...Object.keys(m.expect), ...Object.keys(s.expect)])
          expect(metrics, `${where}: ${key}`).toContain(key);
        if (s.act !== undefined) expect(ACTS, where).toContain(s.act);
        if (s.only === 'web') expect(c.web, where).not.toBeNull();
        if (s.only === 'flutter') expect(c.flutter, where).not.toBeNull();
        const onWeb = s.only !== 'flutter' && c.web !== null;
        if (onWeb)
          expect(s.story, where).toMatch(new RegExp(`^${c.name.toLowerCase()}--[a-z0-9-]+$`));
        else expect(s.story, where).toBeNull();
      }
    }
  });

  it('points every metric at a token of its kind, or `none` for a colour', async () => {
    const tokens = await resolveTheme('light');
    const dimensions: readonly string[] = DIMENSION_METRICS;
    for (const c of measured)
      for (const s of c.metrics!.states)
        for (const [key, name] of Object.entries({ ...c.metrics!.expect, ...s.expect })) {
          const where = `${c.name}/${s.state}: ${key}`;
          if (name === 'none' && !dimensions.includes(key)) continue;
          const token = tokens.get(name);
          expect(token, `${where} names ${name}`).toBeDefined();
          expect(token!.path[0], `${where}: a component token`).toBe(name.split('.')[0]);
          expect(token!.type, where).toBe(dimensions.includes(key) ? 'dimension' : 'color');
        }
  });
});
