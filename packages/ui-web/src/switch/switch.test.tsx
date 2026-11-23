import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Switch } from './switch';

describe('Switch', () => {
  it('is a switch named by its label, off at first', () => {
    render(<Switch label="الإشعارات" />);
    expect(screen.getByRole('switch', { name: 'الإشعارات' })).not.toBeChecked();
  });

  it('turns on by a click on the label and by Space, and reports it', async () => {
    const onCheckedChange = vi.fn();
    render(<Switch label="الإشعارات" onCheckedChange={onCheckedChange} />);
    await userEvent.click(screen.getByText('الإشعارات'));
    expect(screen.getByRole('switch')).toBeChecked();
    expect(onCheckedChange).toHaveBeenLastCalledWith(true);
    screen.getByRole('switch').focus();
    await userEvent.keyboard(' ');
    expect(screen.getByRole('switch')).not.toBeChecked();
  });

  it('is a 52 by 32 track whose thumb is pushed to the end by logical layout only', () => {
    const { container } = render(<Switch label="الإشعارات" defaultChecked />);
    const html = container.innerHTML;
    expect(html).toContain('h-(--fd-input-switch-height)');
    expect(html).toContain('w-(--fd-input-switch-width)');
    expect(html).toContain('in-data-checked:grow');
    expect(html).not.toMatch(/translate-x|\bleft-|\bright-/);
  });

  it('paints off+pressed with the pressed track, not the hover one', () => {
    const { container } = render(<Switch label="الإشعارات" />);
    expect(container.innerHTML).toContain(
      'group-active/row:data-unchecked:bg-(--fd-input-switch-color-track-pressed)',
    );
  });

  it('ignores a click when disabled', async () => {
    render(<Switch label="الإشعارات" disabled />);
    await userEvent.click(screen.getByText('الإشعارات'));
    expect(screen.getByRole('switch')).not.toBeChecked();
  });
});
