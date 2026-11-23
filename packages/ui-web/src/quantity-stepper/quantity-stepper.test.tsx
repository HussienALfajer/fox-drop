import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { QuantityStepper } from './quantity-stepper';

const labels = {
  label: 'الكمية 2',
  increaseLabel: 'زيادة',
  decreaseLabel: 'تقليل',
  removeLabel: 'حذف',
};

describe('QuantityStepper', () => {
  it('is a group announced with the label the app passes', () => {
    render(<QuantityStepper {...labels} defaultValue={2} />);
    expect(screen.getByRole('group', { name: 'الكمية 2' })).toBeInTheDocument();
    expect(screen.getByRole('status')).toHaveTextContent('2');
  });

  it('adds and removes one and reports the count', async () => {
    const onValueChange = vi.fn();
    render(<QuantityStepper {...labels} defaultValue={2} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('button', { name: 'زيادة' }));
    expect(onValueChange).toHaveBeenLastCalledWith(3);
    await userEvent.click(screen.getByRole('button', { name: 'تقليل' }));
    expect(onValueChange).toHaveBeenLastCalledWith(2);
  });

  it('puts «+» at the start of the line and «−» at its end', () => {
    render(<QuantityStepper {...labels} defaultValue={2} />);
    const [first, last] = screen.getAllByRole('button');
    expect(first).toHaveAccessibleName('زيادة');
    expect(last).toHaveAccessibleName('تقليل');
  });

  it('turns «−» into delete at the minimum and removes the line', async () => {
    const onRemove = vi.fn();
    const onValueChange = vi.fn();
    render(
      <QuantityStepper
        {...labels}
        defaultValue={1}
        onRemove={onRemove}
        onValueChange={onValueChange}
      />,
    );
    expect(screen.queryByRole('button', { name: 'تقليل' })).not.toBeInTheDocument();
    await userEvent.click(screen.getByRole('button', { name: 'حذف' }));
    expect(onRemove).toHaveBeenCalledOnce();
    expect(onValueChange).not.toHaveBeenCalled();
  });

  it('is off at the minimum when nothing can remove the line', async () => {
    const onValueChange = vi.fn();
    render(<QuantityStepper {...labels} defaultValue={1} onValueChange={onValueChange} />);
    const button = screen.getByRole('button', { name: 'تقليل' });
    expect(button).toHaveAttribute('aria-disabled', 'true');
    await userEvent.click(button);
    expect(onValueChange).not.toHaveBeenCalled();
  });

  it('stops «+» at the maximum and keeps focus on it', async () => {
    const onValueChange = vi.fn();
    render(<QuantityStepper {...labels} defaultValue={4} max={5} onValueChange={onValueChange} />);
    const add = screen.getByRole('button', { name: 'زيادة' });
    await userEvent.click(add);
    expect(onValueChange).toHaveBeenLastCalledWith(5);
    expect(add).toHaveAttribute('aria-disabled', 'true');
    await userEvent.click(add);
    expect(onValueChange).toHaveBeenCalledOnce();
  });

  it('works by keyboard', async () => {
    const onValueChange = vi.fn();
    render(<QuantityStepper {...labels} defaultValue={2} onValueChange={onValueChange} />);
    await userEvent.tab();
    expect(screen.getByRole('button', { name: 'زيادة' })).toHaveFocus();
    await userEvent.keyboard('{Enter}');
    expect(onValueChange).toHaveBeenLastCalledWith(3);
  });

  it('is off as a whole when disabled', async () => {
    const onValueChange = vi.fn();
    render(<QuantityStepper {...labels} defaultValue={2} disabled onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('button', { name: 'زيادة' }));
    expect(onValueChange).not.toHaveBeenCalled();
  });
});
