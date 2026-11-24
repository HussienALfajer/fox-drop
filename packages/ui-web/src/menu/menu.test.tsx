import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Menu } from './menu';

// D.10: the user menu of AP §7.2 as the example. Arrow keys, Home and End,
// type-ahead, Escape returns focus.

function UserMenu({ onSignOut = vi.fn() }: { onSignOut?: () => void }) {
  return (
    <Menu
      triggerLabel="سارة م."
      items={[
        { label: 'الملف الشخصي', icon: 'account', onSelect: vi.fn() },
        { label: 'الجلسات', icon: 'settings', onSelect: vi.fn() },
        'separator',
        { label: 'تسجيل الخروج', destructive: true, onSelect: onSignOut },
      ]}
    />
  );
}

const items = () => screen.getAllByRole('menuitem', { hidden: true });

describe('Menu', () => {
  it('opens a menu of items from its trigger, with a separator', async () => {
    render(<UserMenu />);
    const trigger = screen.getByRole('button', { name: 'سارة م.' });
    expect(trigger).toHaveAttribute('aria-haspopup', 'menu');
    await userEvent.click(trigger);
    expect(await screen.findByRole('menu', { hidden: true })).toBeInTheDocument();
    expect(items().map((i) => i.textContent)).toEqual(['الملف الشخصي', 'الجلسات', 'تسجيل الخروج']);
    expect(screen.getByRole('separator', { hidden: true })).toBeInTheDocument();
  });

  it('marks the destructive item', async () => {
    render(<UserMenu />);
    await userEvent.click(screen.getByRole('button', { name: 'سارة م.' }));
    const signOut = (await screen.findAllByRole('menuitem', { hidden: true }))[2]!;
    expect(signOut).toHaveAttribute('data-destructive');
  });

  it('moves with the arrow keys, Home and End, and selects with Enter', async () => {
    const onSignOut = vi.fn();
    render(<UserMenu onSignOut={onSignOut} />);
    screen.getByRole('button', { name: 'سارة م.' }).focus();
    await userEvent.keyboard('{ArrowDown}');
    await waitFor(() => expect(items()[0]).toHaveFocus());
    await userEvent.keyboard('{End}');
    expect(items()[2]).toHaveFocus();
    await userEvent.keyboard('{Home}');
    expect(items()[0]).toHaveFocus();
    await userEvent.keyboard('{ArrowDown}');
    expect(items()[1]).toHaveFocus();
    await userEvent.keyboard('{End}{Enter}');
    expect(onSignOut).toHaveBeenCalledOnce();
  });

  it('jumps by typing, and Escape returns focus to the trigger', async () => {
    render(<UserMenu />);
    const trigger = screen.getByRole('button', { name: 'سارة م.' });
    trigger.focus();
    await userEvent.keyboard('{ArrowDown}');
    await waitFor(() => expect(items()[0]).toHaveFocus());
    await userEvent.keyboard('ت');
    await waitFor(() => expect(items()[2]).toHaveFocus());
    await userEvent.keyboard('{Escape}');
    await waitFor(() => expect(trigger).toHaveFocus());
  });
});
