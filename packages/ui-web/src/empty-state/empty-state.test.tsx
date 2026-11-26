import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { EmptyState } from './empty-state';

// R6 and brand expression §2, §5: an icon in the logo's drop, a title, one
// line, at most one action.
describe('EmptyState', () => {
  // D.W3b, the D.9 sheet: a 120 drop, never cut at its round top.
  it('frames the icon in the sheet’s drop, drawn whole', () => {
    const { container } = render(<EmptyState icon="orders" title="لا طلبات" />);
    const drop = container.querySelector('[data-drop]');
    expect(drop).toHaveClass('size-(--fd-empty-state-art-size)');
    expect(drop?.querySelector('svg')).toHaveClass('overflow-visible');
  });

  it('shows its title as a heading and its line', () => {
    render(<EmptyState icon="orders" title="لا طلبات بهذه الفلاتر" description="غيّر الفترة" />);
    expect(screen.getByRole('heading', { name: 'لا طلبات بهذه الفلاتر' })).toBeInTheDocument();
    expect(screen.getByText('غيّر الفترة')).toBeInTheDocument();
  });

  it('draws the icon inside the drop, hidden from screen readers', () => {
    const { container } = render(<EmptyState icon="orders" title="لا طلبات" />);
    const drop = container.querySelector('[data-drop]')!;
    expect(drop).toHaveAttribute('aria-hidden', 'true');
    expect(drop.querySelectorAll('svg').length).toBeGreaterThan(0);
  });

  it('has at most one action', async () => {
    const onPress = vi.fn();
    render(<EmptyState icon="error" title="حدث خطأ" action={{ label: 'أعد المحاولة', onPress }} />);
    await userEvent.click(screen.getByRole('button', { name: 'أعد المحاولة' }));
    expect(onPress).toHaveBeenCalledOnce();
  });

  it('writes an error title in danger', () => {
    render(<EmptyState icon="error" title="حدث خطأ" tone="error" />);
    expect(screen.getByRole('heading', { name: 'حدث خطأ' }).className).toContain(
      'text-(color:--fd-empty-state-color-error-title)',
    );
  });
});
