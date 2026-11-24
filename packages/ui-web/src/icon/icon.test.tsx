import { icons } from '@fox-drop/design-tokens/icons';
import { render } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { EmptyState } from '../empty-state/empty-state';
import { Icon, ICON_STYLES } from './icon';

const svg = (container: HTMLElement) => container.querySelector('svg')!;
const paths = (container: HTMLElement) => [...container.querySelectorAll('path')];

describe('Icon', () => {
  it('draws the elements of the named icon on the 24 grid, stroked at 1.5', () => {
    const { container } = render(<Icon name="search" />);
    expect(paths(container).map((p) => p.getAttribute('d'))).toEqual(
      icons.search.elements.map((e) => e.d),
    );
    expect(svg(container).getAttribute('viewBox')).toBe('0 0 24 24');
    expect(svg(container).getAttribute('stroke')).toBe('currentColor');
    expect(svg(container).getAttribute('stroke-width')).toBe('1.5');
    expect(svg(container).getAttribute('fill')).toBe('none');
  });

  it('offers the six styles of set v4 Madar, Linear by default', () => {
    expect(ICON_STYLES).toEqual(['linear', 'duotone', 'brand-duo', 'broken', 'bold', 'bold-duo']);
    const linear = render(<Icon name="bell" />).container.innerHTML;
    expect(render(<Icon name="bell" variant="linear" />).container.innerHTML).toBe(linear);
  });

  it('fades the non-accent elements in Duotone', () => {
    const { container } = render(<Icon name="bell" variant="duotone" />);
    paths(container).forEach((p, i) => {
      const accent = icons.bell.elements[i]!.accent;
      expect(p.getAttribute('opacity'), String(i)).toBe(accent ? null : '0.5');
    });
  });

  it('strokes the accent in the brand colour in Brand Duo', () => {
    const { container } = render(<Icon name="bell" variant="brand-duo" />);
    paths(container).forEach((p, i) => {
      const accent = icons.bell.elements[i]!.accent;
      expect(p.getAttribute('stroke'), String(i)).toBe(accent ? 'var(--fd-color-brand)' : null);
    });
  });

  it('draws the bitten body in Broken', () => {
    const { container } = render(<Icon name="bell" variant="broken" />);
    expect(paths(container).map((p) => p.getAttribute('d'))).toEqual(icons.bell.broken);
  });

  it('draws Bold as fills in currentColor, no stroke', () => {
    const { container } = render(<Icon name="bell" variant="bold" />);
    expect(svg(container).getAttribute('stroke')).toBe('none');
    expect(svg(container).getAttribute('fill')).toBe('currentColor');
    expect(paths(container).map((p) => p.getAttribute('d'))).toEqual(
      icons.bell.bold.map((layer) => layer.d),
    );
    expect(container.querySelector('mask, [stroke-dasharray]')).toBeNull();
  });

  it('fades the faded layers of Bold Duo with fill-opacity', () => {
    const { container } = render(<Icon name="wallet" variant="bold-duo" />);
    const layers = icons.wallet.boldDuo;
    expect(layers.some((layer) => layer.faded)).toBe(true);
    paths(container).forEach((p, i) => {
      expect(p.getAttribute('d')).toBe(layers[i]!.d);
      expect(p.getAttribute('fill-opacity')).toBe(layers[i]!.faded ? '0.5' : null);
    });
  });

  it('draws Brand Duo in the empty state, as on the Madar sheet', () => {
    const { container } = render(<EmptyState icon="cart" title="لا شيء هنا" />);
    expect(container.querySelector('path[stroke="var(--fd-color-brand)"]')).not.toBeNull();
  });

  it('is hidden from screen readers without a label', () => {
    const { container, queryByRole } = render(<Icon name="cart" />);
    expect(svg(container).getAttribute('aria-hidden')).toBe('true');
    expect(queryByRole('img')).toBeNull();
  });

  it('is an image named by its label', () => {
    const { getByRole, container } = render(<Icon name="cart" label="السلة" />);
    expect(getByRole('img', { name: 'السلة' })).toBeTruthy();
    expect(svg(container).hasAttribute('aria-hidden')).toBe(false);
  });

  it('takes its size from the size tokens, medium by default', () => {
    const sizes = (['sm', 'md', 'lg'] as const).map((size) =>
      svg(render(<Icon name="cart" size={size} />).container).getAttribute('class')!,
    );
    expect(sizes[0]).toContain('size-(--fd-size-icon-sm)');
    expect(sizes[1]).toContain('size-(--fd-size-icon-md)');
    expect(sizes[2]).toContain('size-(--fd-size-icon-lg)');
    expect(svg(render(<Icon name="cart" />).container).getAttribute('class')).toContain(
      'size-(--fd-size-icon-md)',
    );
  });

  it('flips under RTL only the icons that mirror, in every style', () => {
    const mirrored = (name: keyof typeof icons, style = ICON_STYLES[0]) =>
      svg(render(<Icon name={name} variant={style} />).container).getAttribute('class')!;
    for (const name of ['back', 'motorcycle', 'car'] as const)
      for (const style of ICON_STYLES) expect(mirrored(name, style)).toContain('rtl:-scale-x-100');
    expect(mirrored('cart')).not.toContain('rtl:-scale-x-100');
  });
});
