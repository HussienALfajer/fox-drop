import { icons } from '@fox-drop/design-tokens/icons';
import { render } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { Icon } from './icon';

const svg = (container: HTMLElement) => container.querySelector('svg')!;

describe('Icon', () => {
  it('draws the paths of the named icon on the 24 grid', () => {
    const { container } = render(<Icon name="search" />);
    const paths = [...container.querySelectorAll('path')].map((p) => p.getAttribute('d'));
    expect(paths).toEqual(icons.search.d);
    expect(svg(container).getAttribute('viewBox')).toBe('0 0 24 24');
    expect(svg(container).getAttribute('stroke')).toBe('currentColor');
    expect(svg(container).getAttribute('stroke-width')).toBe('2');
    expect(svg(container).getAttribute('fill')).toBe('none');
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

  it('flips under RTL only the icons that mirror', () => {
    const mirrored = (name: keyof typeof icons) =>
      svg(render(<Icon name={name} />).container).getAttribute('class')!;
    for (const name of ['back', 'motorcycle', 'car'] as const)
      expect(mirrored(name)).toContain('rtl:-scale-x-100');
    expect(mirrored('cart')).not.toContain('rtl:-scale-x-100');
  });
});
