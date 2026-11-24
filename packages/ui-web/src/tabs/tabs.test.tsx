import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Tabs } from './tabs';

// D.10: detail pages have tabs (AP §7.4). One tab stop, arrows follow the
// reading order in RTL, the selected tab announced with its count.

const items = [
  { value: 'details', label: 'التفاصيل', content: <p>تفاصيل الطلب</p> },
  { value: 'money', label: 'المالية', content: <p>المبالغ</p> },
  {
    value: 'notes',
    label: 'الملاحظات',
    count: 2,
    countLabel: 'ملاحظتان',
    content: <p>الملاحظات</p>,
  },
];

describe('Tabs', () => {
  it('is a tab list with one tab stop on the selected tab', () => {
    render(<Tabs label="تفاصيل الطلب" items={items} defaultValue="details" />);
    const tabs = screen.getAllByRole('tab');
    expect(screen.getByRole('tablist', { name: 'تفاصيل الطلب' })).toBeInTheDocument();
    expect(tabs[0]).toHaveAttribute('aria-selected', 'true');
    expect(tabs.filter((t) => t.tabIndex === 0)).toHaveLength(1);
    expect(screen.getByRole('tabpanel')).toHaveTextContent('تفاصيل الطلب');
  });

  it('names a tab with its count', () => {
    render(<Tabs label="تفاصيل الطلب" items={items} defaultValue="details" />);
    expect(screen.getByRole('tab', { name: /الملاحظات.*ملاحظتان/ })).toBeInTheDocument();
  });

  it('moves with the arrows in reading order: left is the next tab in RTL', async () => {
    const onValueChange = vi.fn();
    render(
      <div dir="rtl">
        <Tabs
          label="تفاصيل الطلب"
          items={items}
          defaultValue="details"
          onValueChange={onValueChange}
        />
      </div>,
    );
    screen.getAllByRole('tab')[0]!.focus();
    await userEvent.keyboard('{ArrowLeft}');
    expect(screen.getAllByRole('tab')[1]).toHaveFocus();
    expect(onValueChange).toHaveBeenLastCalledWith('money');
    await userEvent.keyboard('{ArrowRight}');
    expect(screen.getAllByRole('tab')[0]).toHaveFocus();
    await userEvent.keyboard('{End}');
    expect(screen.getAllByRole('tab')[2]).toHaveFocus();
    expect(screen.getByRole('tabpanel')).toHaveTextContent('الملاحظات');
  });

  it('draws the customer form as pills', () => {
    render(<Tabs label="الأقسام" items={items} defaultValue="details" variant="pill" />);
    expect(screen.getByRole('tablist')).toHaveAttribute('data-variant', 'pill');
  });
});
