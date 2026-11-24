import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { TopBar } from './top-bar';

// D.10, AP §7.2: slots, not fixed content; each slot has a name, a count is
// read with its label, and on a phone the menu button opens the sidebar.

describe('TopBar', () => {
  it('is the page banner, named, holding the slots the app fills', () => {
    render(
      <TopBar
        label="الشريط العلوي"
        start={<span>أعزاز</span>}
        end={<button type="button">سارة م.</button>}
      >
        <input aria-label="بحث" />
      </TopBar>,
    );
    const bar = screen.getByRole('banner', { name: 'الشريط العلوي' });
    expect(bar).toHaveTextContent('أعزاز');
    expect(screen.getByRole('textbox', { name: 'بحث' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'سارة م.' })).toBeInTheDocument();
  });

  it('shows the named menu button when given one, and runs it', async () => {
    const onMenu = vi.fn();
    render(
      <TopBar label="الشريط العلوي" title="غرفة العمليات" menu={{ label: 'القائمة', onMenu }} />,
    );
    await userEvent.click(screen.getByRole('button', { name: 'القائمة' }));
    expect(onMenu).toHaveBeenCalledOnce();
    expect(screen.getByRole('heading', { name: 'غرفة العمليات' })).toBeInTheDocument();
  });

  it('reads an icon action with its count', () => {
    render(
      <TopBar
        label="الشريط العلوي"
        actions={[
          { icon: 'bell', label: 'التنبيهات', count: 4, countLabel: '4 مفتوحة', onAction: vi.fn() },
        ]}
      />,
    );
    expect(screen.getByRole('button', { name: /التنبيهات.*4 مفتوحة/ })).toBeInTheDocument();
  });
});
