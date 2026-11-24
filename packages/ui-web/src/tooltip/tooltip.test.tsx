import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it } from 'vitest';
import { Tooltip, TOOLTIP_DELAY } from './tooltip';

// D.10: shown on keyboard focus as on hover (after 500 ms); it describes, and
// its trigger keeps its own accessible name.

describe('Tooltip', () => {
  it('waits the approved delay on hover', () => {
    expect(TOOLTIP_DELAY).toBe(500);
  });

  it('shows on keyboard focus and describes its trigger, which keeps its name', async () => {
    render(
      <Tooltip content="الإشعارات المفتوحة: 4">
        <button type="button" aria-label="الإشعارات">
          !
        </button>
      </Tooltip>,
    );
    await userEvent.tab();
    const trigger = screen.getByRole('button', { name: 'الإشعارات' });
    expect(trigger).toHaveFocus();
    const tip = await screen.findByRole('tooltip', { hidden: true });
    expect(tip).toHaveTextContent('الإشعارات المفتوحة: 4');
    await waitFor(() => expect(trigger).toHaveAccessibleDescription('الإشعارات المفتوحة: 4'));
    expect(trigger).toHaveAccessibleName('الإشعارات');
  });

  it('hides on Escape', async () => {
    render(
      <Tooltip content="غرفة العمليات">
        <button type="button" aria-label="غرفة العمليات">
          !
        </button>
      </Tooltip>,
    );
    await userEvent.tab();
    await screen.findByRole('tooltip', { hidden: true });
    await userEvent.keyboard('{Escape}');
    await waitFor(() => expect(screen.queryByRole('tooltip', { hidden: true })).toBeNull());
  });
});
