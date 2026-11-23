import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Checkbox } from './checkbox';

describe('Checkbox', () => {
  it('toggles by a click on the label text, the whole row is the target', async () => {
    const onCheckedChange = vi.fn();
    render(<Checkbox label="أوافق" onCheckedChange={onCheckedChange} />);
    const box = screen.getByRole('checkbox', { name: 'أوافق' });
    expect(box).not.toBeChecked();
    await userEvent.click(screen.getByText('أوافق'));
    expect(box).toBeChecked();
    expect(onCheckedChange).toHaveBeenLastCalledWith(true);
  });

  it('toggles with Space', async () => {
    render(<Checkbox label="أوافق" />);
    await userEvent.tab();
    expect(screen.getByRole('checkbox')).toHaveFocus();
    await userEvent.keyboard(' ');
    expect(screen.getByRole('checkbox')).toBeChecked();
  });

  it('is mixed for a partly checked parent and a press checks it', async () => {
    render(<Checkbox label="الكل" defaultChecked="indeterminate" />);
    const box = screen.getByRole('checkbox');
    expect(box).toBePartiallyChecked();
    await userEvent.click(box);
    expect(box).toBeChecked();
  });

  it('is 24 in a 48 target with the radius 8 from the tokens', () => {
    const { container } = render(<Checkbox label="أوافق" />);
    expect(container.innerHTML).toContain('size-(--fd-input-check-size)');
    expect(container.innerHTML).toContain('size-(--fd-input-check-target)');
    expect(container.innerHTML).toContain('rounded-(--fd-input-check-radius)');
  });

  it('marks an invalid checkbox', () => {
    render(<Checkbox label="أوافق" invalid />);
    expect(screen.getByRole('checkbox')).toBeInvalid();
  });

  it('ignores a click when disabled', async () => {
    render(<Checkbox label="أوافق" disabled />);
    await userEvent.click(screen.getByText('أوافق'));
    expect(screen.getByRole('checkbox')).not.toBeChecked();
    expect(screen.getByRole('checkbox')).toHaveAttribute('aria-disabled', 'true');
  });
});
