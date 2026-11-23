import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { CodeField } from './code-field';

describe('CodeField', () => {
  it('is one input named by the label, for one-time codes, with six cells', () => {
    const { container } = render(<CodeField label="رمز التحقق" />);
    const input = screen.getByRole('textbox', { name: 'رمز التحقق' });
    expect(input).toHaveAttribute('autocomplete', 'one-time-code');
    expect(input).toHaveAttribute('maxlength', '6');
    expect(container.querySelectorAll('[data-slot="otp-input-slot"]')).toHaveLength(6);
  });

  it('keeps the cells left to right', () => {
    const { container } = render(<CodeField label="رمز التحقق" />);
    expect(container.querySelector('[data-slot="otp-input"]')).toHaveAttribute('dir', 'ltr');
  });

  it('reports the digits and the complete code once', async () => {
    const onComplete = vi.fn();
    const onValueChange = vi.fn();
    render(<CodeField label="رمز" onValueChange={onValueChange} onComplete={onComplete} />);
    await userEvent.type(screen.getByRole('textbox'), '48291');
    expect(onComplete).not.toHaveBeenCalled();
    await userEvent.type(screen.getByRole('textbox'), '3');
    expect(onComplete).toHaveBeenCalledExactlyOnceWith('482913');
    expect(onValueChange).toHaveBeenLastCalledWith('482913');
  });

  it('takes a pasted code and ignores what is not a digit', async () => {
    const onComplete = vi.fn();
    render(<CodeField label="رمز" onComplete={onComplete} />);
    await userEvent.click(screen.getByRole('textbox'));
    await userEvent.paste('482-913');
    expect(screen.getByRole('textbox')).toHaveValue('482913');
    expect(onComplete).toHaveBeenCalledOnce();
  });

  it('fills the cells in the brand colour when done, and marks an error invalid', () => {
    const { container, rerender } = render(<CodeField label="رمز" defaultValue="482913" done />);
    expect(container.innerHTML).toContain('bg-(--fd-input-code-color-done)');
    rerender(<CodeField label="رمز" defaultValue="482913" error="غير صحيح" />);
    expect(screen.getByRole('textbox')).toHaveAccessibleDescription('غير صحيح');
  });
});
