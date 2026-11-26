import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { Skeleton, SkeletonBlock } from './skeleton';

describe('Skeleton', () => {
  it('is one busy region with its label, its blocks hidden', () => {
    const { container } = render(
      <Skeleton label="جارٍ التحميل">
        <SkeletonBlock shape="line" />
        <SkeletonBlock shape="circle" />
      </Skeleton>,
    );
    const region = screen.getByRole('status', { name: 'جارٍ التحميل' });
    expect(region).toHaveAttribute('aria-busy', 'true');
    for (const block of container.querySelectorAll('[data-skeleton-block]'))
      expect(block).toHaveAttribute('aria-hidden', 'true');
  });

  it('pulses calmly, and stands still under reduced motion', () => {
    const { container } = render(
      <Skeleton label="جارٍ التحميل">
        <SkeletonBlock shape="line" />
      </Skeleton>,
    );
    const block = container.querySelector('[data-skeleton-block]')!;
    expect(block.className).toContain('motion-safe:animate-');
    expect(block.className).toContain('bg-(--fd-skeleton-background)');
  });
});
