import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { RadioGroup } from './radio-group';

const options = [
  { value: 'cash', label: 'نقداً' },
  { value: 'wallet', label: 'المحفظة' },
  { value: 'card', label: 'بطاقة', disabled: true },
];

describe('RadioGroup', () => {
  it('is a radio group named by its label with one radio per option', () => {
    render(<RadioGroup label="الدفع" options={options} />);
    expect(screen.getByRole('radiogroup', { name: 'الدفع' })).toBeInTheDocument();
    expect(screen.getAllByRole('radio')).toHaveLength(3);
  });

  it('selects by a click on the label text and reports the value', async () => {
    const onValueChange = vi.fn();
    render(<RadioGroup label="الدفع" options={options} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByText('المحفظة'));
    expect(screen.getByRole('radio', { name: 'المحفظة' })).toBeChecked();
    expect(onValueChange).toHaveBeenCalledWith('wallet');
  });

  it('has one tab stop and moves with the arrow keys, skipping a disabled option', async () => {
    render(<RadioGroup label="الدفع" options={options} defaultValue="cash" />);
    await userEvent.tab();
    expect(screen.getByRole('radio', { name: 'نقداً' })).toHaveFocus();
    await userEvent.keyboard('{ArrowDown}');
    expect(screen.getByRole('radio', { name: 'المحفظة' })).toBeChecked();
    await userEvent.keyboard('{ArrowDown}');
    expect(screen.getByRole('radio', { name: 'نقداً' })).toBeChecked();
  });

  it('describes the group by the error', () => {
    render(<RadioGroup label="الدفع" options={options} error="اختر طريقة" />);
    expect(screen.getByRole('radiogroup')).toHaveAccessibleDescription('اختر طريقة');
  });

  it('ignores a click when the whole group is disabled', async () => {
    render(<RadioGroup label="الدفع" options={options} disabled />);
    await userEvent.click(screen.getByText('نقداً'));
    expect(screen.getByRole('radio', { name: 'نقداً' })).not.toBeChecked();
  });
});
