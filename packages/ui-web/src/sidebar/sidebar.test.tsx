import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Sidebar } from './sidebar';

// D.10, AP §7.1 and RA §17: one sidebar for the panel and the portal, on the
// start side; links with aria-current on the active page; a collapsed form
// that keeps the names; below the tablet width it is the drawer.

const items = [
  { href: '/dashboard', label: 'لوحة التحكم', icon: 'home' as const },
  {
    href: '/operations',
    label: 'غرفة العمليات',
    icon: 'orders' as const,
    count: 3,
    countLabel: '3 تنبيهات',
  },
  { href: '/zones', label: 'المناطق والتسعير' },
];

const labels = {
  label: 'التنقل الرئيسي',
  collapseLabel: 'طيّ القائمة',
  expandLabel: 'توسيع القائمة',
};

describe('Sidebar', () => {
  it('is a navigation of links with the current page marked', () => {
    render(<Sidebar {...labels} items={items} current="/operations" />);
    const nav = screen.getByRole('navigation', { name: 'التنقل الرئيسي' });
    const links = within(nav).getAllByRole('link');
    expect(links).toHaveLength(3);
    expect(links[1]).toHaveAttribute('aria-current', 'page');
    expect(links[0]).not.toHaveAttribute('aria-current');
    expect(links[1]).toHaveAccessibleName(/غرفة العمليات.*3 تنبيهات/);
  });

  it('keeps every name when collapsed', () => {
    render(<Sidebar {...labels} items={items} current="/dashboard" collapsed />);
    const links = screen.getAllByRole('link');
    expect(links.map((l) => l.getAttribute('aria-label') ?? l.textContent)).toEqual([
      expect.stringContaining('لوحة التحكم'),
      expect.stringContaining('غرفة العمليات'),
      expect.stringContaining('المناطق والتسعير'),
    ]);
    expect(screen.getByRole('navigation')).toHaveAttribute('data-collapsed');
  });

  it('toggles its collapsed form with a named button', async () => {
    const onCollapsedChange = vi.fn();
    render(
      <Sidebar
        {...labels}
        items={items}
        current="/dashboard"
        onCollapsedChange={onCollapsedChange}
      />,
    );
    await userEvent.click(screen.getByRole('button', { name: 'طيّ القائمة' }));
    expect(onCollapsedChange).toHaveBeenCalledWith(true);
  });

  it('opens as a drawer from the start side in its phone form', async () => {
    render(
      <Sidebar
        {...labels}
        items={items}
        current="/dashboard"
        form="drawer"
        open
        closeLabel="إغلاق"
      />,
    );
    const drawer = await screen.findByRole('dialog', { name: 'التنقل الرئيسي' });
    expect(drawer).toHaveAttribute('data-side', 'start');
    expect(within(drawer).getAllByRole('link')).toHaveLength(3);
  });
});
