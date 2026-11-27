import { readFileSync } from 'node:fs';
import path from 'node:path';
import { beforeAll, describe, expect, it } from 'vitest';
import { buildBundle, checkJs, COMPONENTS, ICON_NAMES, PACKAGE_DIR } from '../scripts/bundle.ts';
import { preview, typesDoc } from '../scripts/docs.ts';

// No component since D.R1 (2026-11-27): the bundle still builds, with React,
// ReactDOM and the tokens, so the first approved component only joins
// COMPONENTS. Its props doc, its bridge test under a page React 18 and its
// card come back with it (git history: the tests of D.W5 and D.C3).
describe('the Design System bundle', () => {
  let bundle: { js: string; css: string };
  beforeAll(async () => {
    bundle = await buildBundle();
  }, 60_000);

  it('is a classic script that names the components and hides nothing risky', () => {
    const index = JSON.parse(
      /^\/\* @ds-bundle: (.*) \*\/$/.exec(bundle.js.split('\n')[0] ?? '')?.[1] ?? 'null',
    ) as { namespace: string; components: { name: string }[] };
    expect(index.namespace).toBe('FoxDrop');
    expect(index.components.map((c) => c.name)).toEqual([...COMPONENTS]);
    expect(bundle.js.toLowerCase()).not.toContain('</script');
    expect(bundle.js).not.toContain('<!--');
    expect(bundle.js).not.toMatch(/^\s*(import|export)\s/m);
  });

  it('defines window.FoxDrop with the components and React', () => {
    delete (window as unknown as Record<string, unknown>)['React'];
    window.eval(bundle.js);
    const api = (window as unknown as { FoxDrop: Record<string, unknown> }).FoxDrop;
    expect(Object.keys(api).sort()).toEqual([...COMPONENTS, 'React', 'ReactDOM'].sort());
    for (const name of COMPONENTS) expect(typeof api[name], name).toBe('function');
    expect((window as unknown as { React: unknown }).React).toBe(api['React']);
  });

  it('carries the --fd-* variables, with no font and no style end', () => {
    expect(bundle.css).toContain('--fd-color-surface');
    expect(bundle.css).toContain('--fd-space-md');
    expect(bundle.css.toLowerCase()).not.toContain('</style');
    expect(bundle.css).not.toContain('@font-face');
    expect(bundle.css).not.toContain('.fonts');
  });
});

describe('the escape of the bundle', () => {
  it('escapes a script end and a comment start', () => {
    expect(checkJs('a="</script>"+"<!--"')).toBe('a="<\\/script>"+"<\\!--"');
  });
});

describe('the component docs', () => {
  it('declares the types with every icon name inline and no import', () => {
    const types = typesDoc();
    expect(types).toContain('type IconName');
    expect(types).not.toMatch(/^import /m);
    for (const name of ICON_NAMES) expect(types).toContain(`'${name}'`);
  });

  it.each(COMPONENTS)('gives %s a card first line and a summary', (name) => {
    const html = preview(name);
    expect(html.split('\n')[0]).toMatch(/^<!-- @dsCard group="\w+" height=\d+ -->$/);
    expect(html).toContain('dir="rtl" lang="ar"');
    // The card paints the apps' ground and text itself: the system page may be dark.
    expect(html).toMatch(
      /#root \{[^}]*background: var\(--fd-color-surface\);[^}]*color: var\(--fd-color-on-surface\)/,
    );
    expect(html).not.toContain('<iframe');
    expect(html).not.toContain('__ICON_NAMES__');
    const readme = readFileSync(path.join(PACKAGE_DIR, `design-system/${name}/README.md`), 'utf8');
    expect(readme.split('\n')[2]).toMatch(/\.$/);
  });
});
