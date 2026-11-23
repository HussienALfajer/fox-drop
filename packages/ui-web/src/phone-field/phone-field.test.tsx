import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { PhoneField } from './phone-field';

const props = {
  label: 'رقم الهاتف',
  countryLabel: 'الدولة',
  countryLabels: { sy: 'سوريا', tr: 'تركيا' },
};

describe('PhoneField', () => {
  it('names the digits by the label and the chip by its own label', () => {
    render(<PhoneField {...props} />);
    expect(screen.getByRole('textbox', { name: 'رقم الهاتف' })).toHaveAttribute('type', 'tel');
    const chip = screen.getByRole('combobox', { name: 'الدولة' });
    expect(chip).toHaveTextContent('+963');
  });

  it('is one pill holding an ltr island', () => {
    const { container } = render(<PhoneField {...props} />);
    const island = container.querySelector('[data-slot="input-group"]');
    expect(island).toHaveAttribute('dir', 'ltr');
    expect(island?.contains(screen.getByRole('combobox'))).toBe(true);
    expect(island?.contains(screen.getByRole('textbox'))).toBe(true);
  });

  it.each(['0912345678', '912345678'])('reports E.164 for the Syrian number %s', async (typed) => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.type(screen.getByRole('textbox'), typed);
    expect(onValueChange).toHaveBeenLastCalledWith('+963912345678', { country: 'sy' });
  });

  it('reports an empty value while the number is not complete', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.type(screen.getByRole('textbox'), '09123');
    expect(onValueChange).toHaveBeenLastCalledWith('', { country: 'sy' });
  });

  it.each(['05321234567', '5321234567'])(
    'reports E.164 for the Turkish number %s',
    async (typed) => {
      const onValueChange = vi.fn();
      render(<PhoneField {...props} defaultCountry="tr" onValueChange={onValueChange} />);
      expect(screen.getByRole('combobox')).toHaveTextContent('+90');
      await userEvent.type(screen.getByRole('textbox'), typed);
      expect(onValueChange).toHaveBeenLastCalledWith('+905321234567', { country: 'tr' });
    },
  );

  it('shows the national digits of a stored number and its country', () => {
    render(<PhoneField {...props} defaultValue="+905321234567" />);
    expect(screen.getByRole('textbox')).toHaveValue('5321234567');
    expect(screen.getByRole('combobox')).toHaveTextContent('+90');
  });

  it('takes a pasted number with its calling code and shows Western digits', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('textbox'));
    await userEvent.paste('+963 ٩١٢ ٣٤٥ ٦٧٨');
    expect(screen.getByRole('textbox')).toHaveValue('912345678');
    expect(onValueChange).toHaveBeenLastCalledWith('+963912345678', { country: 'sy' });
  });

  it('stops typing at the length of the country and never cuts digits', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.type(screen.getByRole('textbox'), '09123456789');
    expect(screen.getByRole('textbox')).toHaveValue('0912345678');
    expect(onValueChange).toHaveBeenLastCalledWith('+963912345678', { country: 'sy' });
  });

  it('shows a pasted number that is too long and reports no number', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('textbox'));
    await userEvent.paste('09123456789');
    expect(screen.getByRole('textbox')).toHaveValue('09123456789');
    expect(onValueChange).toHaveBeenLastCalledWith('', { country: 'sy' });
  });

  it('lets a too-long pasted number be deleted one digit at a time until valid', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('textbox'));
    await userEvent.paste('09123456789');
    await userEvent.keyboard('{Backspace}');
    expect(screen.getByRole('textbox')).toHaveValue('0912345678');
    expect(onValueChange).toHaveBeenLastCalledWith('+963912345678', { country: 'sy' });
  });

  it('keeps the plus of a refused pasted number, so the next edit is read with its code', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.click(screen.getByRole('textbox'));
    await userEvent.paste('+90912345678');
    expect(screen.getByRole('textbox')).toHaveValue('+90912345678');
    expect(onValueChange).toHaveBeenLastCalledWith('', { country: 'sy' });
  });

  it('switches the country to the one a pasted number names', async () => {
    const onValueChange = vi.fn();
    const onCountryChange = vi.fn();
    render(
      <PhoneField {...props} onValueChange={onValueChange} onCountryChange={onCountryChange} />,
    );
    await userEvent.click(screen.getByRole('textbox'));
    await userEvent.paste('+905321234567');
    expect(onCountryChange).toHaveBeenCalledWith('tr');
    expect(screen.getByRole('combobox')).toHaveTextContent('+90');
    expect(screen.getByRole('textbox')).toHaveValue('5321234567');
    expect(onValueChange).toHaveBeenLastCalledWith('+905321234567', { country: 'tr' });
  });

  it('offers Syria and Turkey with their codes and switches country', async () => {
    const onCountryChange = vi.fn();
    render(<PhoneField {...props} onCountryChange={onCountryChange} />);
    await userEvent.click(screen.getByRole('combobox', { name: 'الدولة' }));
    expect(screen.getByRole('option', { name: 'سوريا +963', hidden: true })).toBeInTheDocument();
    await userEvent.click(screen.getByRole('option', { name: 'تركيا +90', hidden: true }));
    expect(onCountryChange).toHaveBeenCalledWith('tr');
    expect(screen.getByRole('combobox')).toHaveTextContent('+90');
  });

  it('describes the digits by the error', () => {
    render(<PhoneField {...props} error="رقم غير صحيح" />);
    expect(screen.getByRole('textbox')).toHaveAccessibleDescription('رقم غير صحيح');
  });
});
