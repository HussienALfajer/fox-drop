import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { TextField } from './text-field';

describe('TextField', () => {
  it('names the input by its label and reports typing', async () => {
    const onValueChange = vi.fn();
    render(<TextField label="الاسم" onValueChange={onValueChange} />);
    const input = screen.getByRole('textbox', { name: 'الاسم' });
    await userEvent.type(input, 'علي');
    expect(onValueChange).toHaveBeenLastCalledWith('علي');
  });

  it('shows the optional mark beside the label and no required star', () => {
    render(<TextField label="الكنية" optionalLabel="(اختياري)" />);
    expect(screen.getByText('(اختياري)')).toBeInTheDocument();
    expect(screen.getByRole('textbox', { name: /الكنية/ })).toBeInTheDocument();
    expect(document.body.textContent).not.toContain('*');
  });

  it('describes the input by the hint', () => {
    render(<TextField label="الاسم" hint="كما في الهوية" />);
    expect(screen.getByRole('textbox')).toHaveAccessibleDescription('كما في الهوية');
  });

  it('describes the input by the error, marks it invalid and drops the hint', () => {
    render(<TextField label="الاسم" hint="كما في الهوية" error="اكتب الاسم" />);
    const input = screen.getByRole('textbox');
    expect(input).toBeInvalid();
    expect(input).toHaveAccessibleDescription('اكتب الاسم');
    expect(screen.queryByText('كما في الهوية')).not.toBeInTheDocument();
  });

  it('is 50 high by default and 40 when compact, from the tokens', () => {
    const { container, rerender } = render(<TextField label="الاسم" />);
    expect(container.innerHTML).toContain('min-h-(--fd-input-height)');
    rerender(<TextField label="الاسم" density="compact" />);
    expect(container.innerHTML).toContain('min-h-(--fd-input-compact-height)');
  });

  it('cannot be edited or focused when disabled', async () => {
    render(<TextField label="الاسم" disabled />);
    const input = screen.getByRole('textbox');
    expect(input).toBeDisabled();
    await userEvent.tab();
    expect(input).not.toHaveFocus();
  });
});
