import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Select } from './select';

const items = [
  { value: 'male', label: 'ذكر' },
  { value: 'female', label: 'أنثى' },
];

describe('Select', () => {
  it('is a combobox named by the label and shows the placeholder', () => {
    render(<Select label="الجنس" placeholder="اختر" items={items} />);
    const trigger = screen.getByRole('combobox', { name: /الجنس/ });
    expect(trigger).toHaveTextContent('اختر');
  });

  it('opens a listbox, picks an option and reports its value', async () => {
    const onValueChange = vi.fn();
    render(<Select label="الجنس" items={items} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('combobox'));
    // jsdom has no top layer, so the popover counts as hidden: ask for hidden roles.
    expect(screen.getAllByRole('option', { hidden: true })).toHaveLength(2);
    await userEvent.click(screen.getByRole('option', { name: 'أنثى', hidden: true }));
    expect(onValueChange).toHaveBeenCalledWith('female');
    expect(screen.getByRole('combobox')).toHaveTextContent('أنثى');
  });

  it('cannot choose a disabled option', async () => {
    const onValueChange = vi.fn();
    const withOff = [...items, { value: 'none', label: 'غير محدد', disabled: true }];
    render(<Select label="الجنس" items={withOff} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('combobox'));
    const option = screen.getByRole('option', { name: 'غير محدد', hidden: true });
    expect(option).toHaveAttribute('aria-disabled', 'true');
    await userEvent.click(option);
    expect(onValueChange).not.toHaveBeenCalled();
  });

  it('opens from the keyboard with the arrow key', async () => {
    render(<Select label="الجنس" items={items} />);
    await userEvent.tab();
    expect(screen.getByRole('combobox')).toHaveFocus();
    await userEvent.keyboard('{ArrowDown}');
    expect(screen.getByRole('combobox')).toHaveAttribute('aria-expanded', 'true');
  });

  it('selects by type-ahead on the trigger', async () => {
    const onValueChange = vi.fn();
    render(<Select label="الجنس" items={items} onValueChange={onValueChange} />);
    await userEvent.tab();
    await userEvent.keyboard('أ');
    expect(onValueChange).toHaveBeenCalledWith('female');
  });

  it('describes the trigger by the error and marks it invalid', () => {
    render(<Select label="الجنس" items={items} error="اختر الجنس" />);
    const trigger = screen.getByRole('combobox');
    expect(trigger).toHaveAccessibleDescription('اختر الجنس');
    expect(trigger).toBeInvalid();
  });

  it('does not open when disabled', async () => {
    render(<Select label="الجنس" items={items} disabled />);
    await userEvent.click(screen.getByRole('combobox'));
    expect(screen.getByRole('combobox')).toBeDisabled();
    expect(screen.getByRole('combobox')).toHaveAttribute('aria-expanded', 'false');
  });
});
