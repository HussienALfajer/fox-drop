import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { badgeText, CountBadge } from './count-badge';

describe('CountBadge', () => {
  it.each([
    [1, 99, '1'],
    [99, 99, '99'],
    [100, 99, '99+'],
    [12, 9, '9+'],
  ])('%i with a maximum of %i shows %s', (count, max, text) => {
    expect(badgeText(count, max)).toBe(text);
  });

  it('shows the count left to right, so 99+ keeps its plus at the end', () => {
    render(<CountBadge count={120} label="120 إشعاراً" />);
    const badge = screen.getByText('99+');
    expect(badge).toHaveAttribute('dir', 'ltr');
    expect(badge).toHaveAttribute('aria-hidden', 'true');
  });

  it('is named by its label, which the app words with the full count', () => {
    render(<CountBadge count={3} label="3 إشعارات" />);
    expect(screen.getByText('3 إشعارات')).toHaveClass('sr-only');
  });

  it('is a dot without a count', () => {
    const { container } = render(<CountBadge label="إشعارات جديدة" />);
    expect(container.querySelector('[data-dot]')).not.toBeNull();
  });

  it('sits on the corner of what it wraps', () => {
    render(
      <CountBadge count={2} label="طلبان">
        <span>السلة</span>
      </CountBadge>,
    );
    expect(screen.getByText('السلة').parentElement).toHaveClass('relative');
  });

  it('renders nothing for zero', () => {
    const { container } = render(<CountBadge count={0} label="لا شيء" />);
    expect(container).toBeEmptyDOMElement();
  });
});
