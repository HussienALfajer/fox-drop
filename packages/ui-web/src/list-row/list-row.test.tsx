import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { ListRow } from './list-row';

describe('ListRow', () => {
  // D.W3b, the D.9 sheet: 56 on the phone, a 40 lead, on the raised surface.
  it('is the sheet’s height on the raised surface, with its lead', () => {
    const { container } = render(<ListRow title="المنزل" leading="house" />);
    const row = container.firstElementChild;
    expect(row).toHaveClass('min-h-(--fd-list-row-min-height)');
    expect(row).toHaveClass('bg-(--fd-list-row-color-background)');
    expect(row?.firstElementChild).toHaveClass('size-(--fd-list-row-lead-size)');
  });

  it('is static text with no action', () => {
    render(<ListRow title="رصيد العهدة" end={<span>1,250 ₺</span>} />);
    expect(screen.queryByRole('button')).toBeNull();
    expect(screen.getByText('1,250 ₺')).toBeInTheDocument();
  });

  it('is one button named by its title and described by its second line', async () => {
    const onPress = vi.fn();
    render(<ListRow title="المنزل" description="أعزاز — دوار الكفين" onPress={onPress} />);
    const row = screen.getByRole('button', { name: 'المنزل' });
    expect(row).toHaveAccessibleDescription('أعزاز — دوار الكفين');
    await userEvent.click(row);
    expect(onPress).toHaveBeenCalledOnce();
  });

  it('shows a mirrored chevron when it opens something', () => {
    const { container } = render(<ListRow title="المنزل" onPress={() => undefined} />);
    expect(container.querySelector('svg.rtl\\:-scale-x-100')).not.toBeNull();
  });

  it('does nothing when disabled', async () => {
    const onPress = vi.fn();
    render(<ListRow title="أكوادي" onPress={onPress} disabled />);
    const row = screen.getByRole('button', { name: 'أكوادي' });
    expect(row).toBeDisabled();
    await userEvent.click(row);
    expect(onPress).not.toHaveBeenCalled();
  });

  it('writes a destructive row in danger', () => {
    render(<ListRow title="حذف العنوان" tone="danger" onPress={() => undefined} />);
    expect(screen.getByRole('button', { name: 'حذف العنوان' }).className).toContain(
      'text-(color:--fd-list-row-danger-label)',
    );
  });
});
