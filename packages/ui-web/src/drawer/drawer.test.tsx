import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it } from 'vitest';
import { Button } from '../button/button';
import { Drawer } from './drawer';

// D.10: the panel's quick view from a table (AP §7.4) opens from the end side,
// away from the sidebar; the sidebar's phone form (AP §7.5) from the start.

describe('Drawer', () => {
  it('opens from its trigger as a dialog named by its title, at the end side by default', async () => {
    render(
      <Drawer trigger={<Button>عرض</Button>} title="الطلب #10421" closeLabel="إغلاق">
        <p>كنافة أعزاز</p>
      </Drawer>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'عرض' }));
    const drawer = await screen.findByRole('dialog', { name: 'الطلب #10421' });
    expect(drawer).toHaveAttribute('data-side', 'end');
    expect(drawer).toHaveTextContent('كنافة أعزاز');
  });

  it('opens from the start side when asked', async () => {
    render(
      <Drawer trigger={<Button>القائمة</Button>} title="التنقل" closeLabel="إغلاق" side="start">
        <p>لوحة التحكم</p>
      </Drawer>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'القائمة' }));
    expect(await screen.findByRole('dialog', { name: 'التنقل' })).toHaveAttribute(
      'data-side',
      'start',
    );
  });

  it('closes with Escape and with its × button', async () => {
    render(
      <Drawer trigger={<Button>عرض</Button>} title="الطلب #10421" closeLabel="إغلاق">
        <p>تفاصيل</p>
      </Drawer>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'عرض' }));
    await screen.findByRole('dialog');
    await userEvent.keyboard('{Escape}');
    await waitFor(() => expect(screen.queryByRole('dialog')).toBeNull());

    await userEvent.click(screen.getByRole('button', { name: 'عرض' }));
    await userEvent.click(await screen.findByRole('button', { name: 'إغلاق' }));
    await waitFor(() => expect(screen.queryByRole('dialog')).toBeNull());
  });

  it('moves focus inside when it opens', async () => {
    render(
      <Drawer trigger={<Button>عرض</Button>} title="الطلب #10421" closeLabel="إغلاق">
        <p>تفاصيل</p>
      </Drawer>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'عرض' }));
    const drawer = await screen.findByRole('dialog');
    await waitFor(() => expect(drawer.contains(document.activeElement)).toBe(true));
  });
});
