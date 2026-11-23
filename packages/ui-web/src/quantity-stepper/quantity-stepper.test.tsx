import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { bridgePath, QuantityStepper, STEPPER_SIZE, STEPPER_TARGET } from './quantity-stepper';

const labels = {
  label: 'الكمية',
  increaseLabel: 'زيادة',
  decreaseLabel: 'تقليل',
  removeLabel: 'حذف',
};

describe('QuantityStepper', () => {
  it('is a group named by the noun, with the count as its description', async () => {
    render(<QuantityStepper {...labels} defaultValue={2} />);
    const group = screen.getByRole('group', { name: 'الكمية' });
    expect(group).toHaveAccessibleDescription('2');
    expect(screen.getByRole('status')).toHaveTextContent('2');
    await userEvent.click(screen.getByRole('button', { name: 'زيادة' }));
    expect(group).toHaveAccessibleDescription('3');
  });

  it('draws the bridge from the stepper tokens', () => {
    const { container } = render(<QuantityStepper {...labels} defaultValue={2} />);
    // size 32 and target 48 (`--fd-input-stepper-size`, `-target`): the strip between the two circles.
    expect(container.querySelector('path')).toHaveAttribute('d', bridgePath(32, 48));
    expect(bridgePath(32, 48)).toBe(
      'M34.25 8H109.75A19 19 0 0 0 109.75 40H34.25A19 19 0 0 0 34.25 8Z',
    );
  });

  it('keeps the bridge constants equal to the tokens', () => {
    const css = readFileSync(
      resolve(import.meta.dirname, '../../../design-tokens/generated/tokens.css'),
      'utf8',
    );
    expect(css).toContain(`--fd-input-stepper-size: ${STEPPER_SIZE}px;`);
    expect(css).toContain(`--fd-input-stepper-target: ${STEPPER_TARGET}px;`);
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
