import { readFileSync } from 'node:fs';
import path from 'node:path';
import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { DropLoader } from './drop-loader';
import { DROP, PIECES } from './mark';

const root = path.resolve(import.meta.dirname, '../../../..');
const read = (file: string) => readFileSync(path.join(root, file), 'utf8');

describe('DropLoader', () => {
  it('draws the brand mark from the brand file, never redrawn by hand', () => {
    const svg = read('docs/brand/logo/mark/mark-orange-on-ivory-drop.svg');
    const paths = [...svg.matchAll(/<path d="([^"]*)"/g)].map((match) => match[1]);
    expect(paths).toEqual([DROP, ...PIECES]);
  });

  it('names itself by its label in a polite live region', () => {
    render(<DropLoader label="جارٍ التحميل" />);
    const status = screen.getByRole('status', { name: 'جارٍ التحميل' });
    expect(status).toHaveAttribute('aria-live', 'polite');
    expect(status).toHaveTextContent('جارٍ التحميل');
  });

  it('is hidden from assistive technology without a label (inside a busy control)', () => {
    const { container } = render(<DropLoader />);
    expect(screen.queryByRole('status')).toBeNull();
    expect(container.querySelector('[data-drop-loader]')).toHaveAttribute('aria-hidden', 'true');
  });

  it('draws the faint mark and the rising liquid with the fox at the default size', () => {
    const { container } = render(<DropLoader />);
    expect(container.querySelectorAll('[data-part="piece"]')).toHaveLength(PIECES.length * 2);
    expect(container.querySelector('[data-part="faint"]')).not.toBeNull();
    expect(container.querySelector('[data-part="wave"]')).not.toBeNull();
  });

  it('draws the drop alone with a flat surface at size sm', () => {
    const { container } = render(<DropLoader size="sm" />);
    expect(container.querySelectorAll('[data-part="piece"]')).toHaveLength(0);
    expect(container.querySelector('[data-part="wave"]')).toBeNull();
    expect(container.querySelector('[data-part="flat"]')).not.toBeNull();
  });

  it('moves only when motion is allowed, and stands still half full otherwise', () => {
    const { container } = render(<DropLoader />);
    const level = container.querySelector('[data-part="level"]')!;
    expect(level.getAttribute('class')).toMatch(/(^| )motion-safe:animate-mark-rise( |$)/);
    expect(level.getAttribute('class')).not.toMatch(/(^| )animate-/);
    // The resting position, with no animation, is half full.
    expect(level).toHaveAttribute('data-still-level', '0.5');
  });

  it('swaps its colours on orange', () => {
    const { container } = render(<DropLoader onPrimary />);
    expect(container.querySelector('[data-drop-loader]')).toHaveAttribute('data-on-primary', '');
  });

  it('keeps its keyframes on the motion tokens', () => {
    const css = read('packages/ui-web/src/theme.css');
    const tokens = read('packages/design-tokens/generated/tokens.css');
    const value = (name: string) =>
      Number(new RegExp(`--fd-motion-mark-fill-${name}: ([0-9.]+);`).exec(tokens)![1]);
    const percent = (share: number) => `${Math.round(share * 100)}%`;
    const rise = /@keyframes mark-rise \{[^@]*\}\s*\}/s.exec(css)![0];
    expect(rise).toContain(percent(value('rise')));
    const fade = /@keyframes mark-fade \{[^@]*\}\s*\}/s.exec(css)![0];
    expect(fade).toContain(percent(1 - value('fade')));
    expect(css).toMatch(/--animate-mark-rise: mark-rise var\(--fd-motion-mark-fill-duration\)/);
    expect(css).toMatch(/--animate-mark-wave: mark-wave var\(--fd-motion-mark-fill-wave-period\)/);
  });
});
