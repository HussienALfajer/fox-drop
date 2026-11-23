import { render, screen } from '@testing-library/react';
import { Input } from '@ui-sdk/react/input';
import { describe, expect, it } from 'vitest';
import { Field } from './field';

describe('Field', () => {
  it('ties the label, the hint and the error to the control', () => {
    const { rerender } = render(
      <Field label="الاسم" hint="تلميح">
        <Input />
      </Field>,
    );
    const input = screen.getByRole('textbox', { name: 'الاسم' });
    expect(input).toHaveAccessibleDescription('تلميح');
    rerender(
      <Field label="الاسم" hint="تلميح" error="خطأ">
        <Input />
      </Field>,
    );
    expect(screen.getByRole('textbox')).toHaveAccessibleDescription('خطأ');
    expect(screen.getByRole('textbox')).toBeInvalid();
  });

  it('draws the error icon at 16 before the error text', () => {
    const { container } = render(
      <Field label="الاسم" error="خطأ">
        <Input />
      </Field>,
    );
    const error = screen.getByText('خطأ');
    expect(error.querySelector('svg')).not.toBeNull();
    expect(container.querySelector('svg')?.getAttribute('class')).toContain('--fd-size-icon-sm');
  });

  it('shows what is passed to the end of the line below', () => {
    render(
      <Field label="الاسم" aside={<span>٣/٥٠</span>}>
        <Input />
      </Field>,
    );
    expect(screen.getByText('٣/٥٠')).toBeInTheDocument();
  });
});
