import { readFileSync } from 'node:fs';
import path from 'node:path';
import { beforeAll, describe, expect, it } from 'vitest';
import { buildBundle, checkJs, ICON_NAMES, PACKAGE_DIR } from '../scripts/bundle.ts';
import { preview, typesDoc } from '../scripts/docs.ts';
import type { ButtonProps } from '../src/button/button';
import type { IconProps } from '../src/icon/icon';

describe('the Design System bundle', () => {
  let bundle: { js: string; css: string };
  beforeAll(async () => {
    bundle = await buildBundle();
  }, 60_000);

  it('is a classic script that names the components and hides nothing risky', () => {
    expect(bundle.js.split('\n')[0]).toMatch(/^\/\* @ds-bundle: .*"Button".*"Icon".* \*\/$/);
    expect(bundle.js.toLowerCase()).not.toContain('</script');
    expect(bundle.js).not.toContain('<!--');
    expect(bundle.js).not.toMatch(/^\s*(import|export)\s/m);
  });

  it('defines window.FoxDrop with the components and React', () => {
    delete (window as unknown as Record<string, unknown>)['React'];
    window.eval(bundle.js);
    const api = (window as unknown as { FoxDrop: Record<string, unknown> }).FoxDrop;
    expect(Object.keys(api)).toEqual(
      expect.arrayContaining(['Button', 'Icon', 'React', 'ReactDOM']),
    );
    expect(typeof api['Button']).toBe('function');
    expect((window as unknown as { React: unknown }).React).toBe(api['React']);
  });

  it('carries the --fd-* variables and the component classes, with no font and no style end', () => {
    expect(bundle.css).toContain('--fd-button-primary-background');
    expect(bundle.css).toContain('min-h-');
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
  it('declares the props types with every icon name inline', () => {
    const types = typesDoc();
    expect(types).toContain('interface IconProps');
    expect(types).toContain('type ButtonProps');
    expect(types).not.toMatch(/^import /m);
    for (const name of ICON_NAMES) expect(types).toContain(`'${name}'`);
  });

  // The doc's types are written by hand: these lists are checked against the
  // real prop types at compile time (`satisfies` fails on a missing or extra
  // key) and against the generated text at run time, so they cannot drift.
  type Keys<T> = T extends unknown ? keyof T : never;
  const buttonProps = {
    variant: true,
    density: true,
    loading: true,
    disabled: true,
    type: true,
    onClick: true,
    children: true,
    icon: true,
    iconEnd: true,
    label: true,
  } satisfies Record<Keys<ButtonProps>, true>;
  const iconProps = { name: true, label: true, size: true } satisfies Record<Keys<IconProps>, true>;

  /** The property names declared in the doc's interfaces of that name, sorted. */
  const documented = (types: string, interfaces: string[]) =>
    [
      ...new Set(
        interfaces.flatMap((name) => {
          const body = new RegExp(`interface ${name}\\b[^{]*\\{([^}]*)\\}`).exec(types)?.[1] ?? '';
          return [...body.matchAll(/^ {2}(\w+)\??:/gm)].map((match) => match[1]!);
        }),
      ),
    ].sort();

  it('documents exactly the props of the real components', () => {
    const types = typesDoc();
    expect(documented(types, ['ButtonBase', 'TextButtonProps', 'IconOnlyButtonProps'])).toEqual(
      Object.keys(buttonProps).sort(),
    );
    expect(documented(types, ['IconProps'])).toEqual(Object.keys(iconProps).sort());
  });

  it.each(['Button', 'Icon'])('gives %s a card first line and a summary', (name) => {
    const html = preview(name);
    expect(html.split('\n')[0]).toMatch(/^<!-- @dsCard group="\w+" height=\d+ -->$/);
    expect(html).toContain('dir="rtl" lang="ar"');
    expect(html).not.toContain('<iframe');
    expect(html).not.toContain('__ICON_NAMES__');
    const readme = readFileSync(path.join(PACKAGE_DIR, 'design-system', name, 'README.md'), 'utf8');
    expect(readme.split('\n')[2]).toMatch(/\.$/);
  });
});
