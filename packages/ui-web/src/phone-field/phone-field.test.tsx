import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { PhoneField, type PhoneFieldProps } from './phone-field';

const props: PhoneFieldProps = {
  label: 'رقم الهاتف',
  chipLabel: (name, code) => `الدولة: ${name}، ${code}. اضغط لتغييرها`,
  searchLabel: 'ابحث باسم الدولة أو رمزها',
  pinnedLabel: 'الأكثر استعمالاً',
  lastUsedLabel: 'آخر ما استعملته',
  allLabel: 'كل الدول',
  emptyLabel: 'لا دولة بهذا الاسم أو الرمز',
  validLabel: 'الرقم صحيح',
  clearLabel: 'مسح الرقم',
  messages: {
    empty: 'أدخل رقم هاتفك.',
    missingDigits: (n) => `ينقص ${n} أرقام.`,
    tooLong: 'الرقم أطول من المعتاد. تأكّد منه.',
    landline: 'هذا رقم أرضي. أدخل رقم جوال عليه واتساب.',
    notMobilePrefix: (prefix) => `أدخل رقم جوال يبدأ بـ ${prefix}.`,
    unknownCode: 'رمز الدولة غير معروف.',
    switched: (name) => `عرفنا الدولة من رمزها: ${name}.`,
  },
};

const number = () => screen.getByRole('textbox', { name: 'رقم الهاتف' });
// The chip opens the list: a button that names the country.
const chip = () => screen.getByRole('button', { name: /^الدولة:/ });

describe('PhoneField', () => {
  it('names the chip by the country, never doubling the code, and isolates the code ltr', () => {
    render(<PhoneField {...props} />);
    expect(chip()).toHaveAccessibleName('الدولة: سوريا، +963. اضغط لتغييرها');
    expect(chip()).toHaveTextContent('SY');
    // What the eye sees carries the code once (the doubled-code bug).
    const shown = chip().querySelector('[aria-hidden="true"]')!;
    expect(shown.textContent?.match(/\+963/g)).toHaveLength(1);
    expect(chip().querySelector('bdi[dir="ltr"]')).toHaveTextContent('+963');
    expect(number()).toHaveAttribute('type', 'tel');
    expect(number()).toHaveAttribute('autocomplete', 'tel');
  });

  it('reports the E.164 of a complete mobile, and the grouped digits in the box on blur', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.type(number(), '0944123456');
    expect(onValueChange).toHaveBeenLastCalledWith(
      '+963944123456',
      expect.objectContaining({ country: 'SY' }),
    );
    await userEvent.tab();
    expect(number()).toHaveValue('944 123 456');
  });

  it('shows the valid mark only when the number is complete', async () => {
    render(<PhoneField {...props} />);
    await userEvent.type(number(), '094412345');
    expect(screen.queryByRole('img', { name: 'الرقم صحيح' })).toBeNull();
    await userEvent.type(number(), '6');
    expect(screen.getByRole('img', { name: 'الرقم صحيح' })).toBeInTheDocument();
  });

  it('shows no problem while typing, then on blur, then live until fixed', async () => {
    render(<PhoneField {...props} />);
    await userEvent.type(number(), '094412345');
    expect(screen.queryByText('ينقص 1 أرقام.')).toBeNull();
    await userEvent.tab();
    expect(screen.getByText('ينقص 1 أرقام.')).toBeInTheDocument();
    expect(number()).toHaveAttribute('aria-invalid', 'true');
    await userEvent.click(number());
    await userEvent.type(number(), '6');
    // The SDK's live announcer may still hold what it last read; the field
    // itself no longer shows the problem.
    expect(
      screen.queryByText('ينقص 1 أرقام.', { ignore: '[data-ui-sdk-announcer], script, style' }),
    ).toBeNull();
    expect(number()).not.toHaveAttribute('aria-invalid', 'true');
  });

  it('shows the problem on submit with the send key, and submits only a complete number', async () => {
    const onSubmit = vi.fn();
    render(<PhoneField {...props} onSubmit={onSubmit} />);
    await userEvent.type(number(), '0112345678{Enter}');
    expect(screen.getByText('هذا رقم أرضي. أدخل رقم جوال عليه واتساب.')).toBeInTheDocument();
    expect(onSubmit).not.toHaveBeenCalled();
    await userEvent.clear(number());
    await userEvent.type(number(), '0944123456{Enter}');
    expect(onSubmit).toHaveBeenCalledWith('+963944123456');
  });

  it('switches the country by itself for a pasted number of another country, and says so', async () => {
    const onCountryChange = vi.fn();
    render(<PhoneField {...props} onCountryChange={onCountryChange} />);
    await userEvent.click(number());
    await userEvent.paste('+4915123456789');
    expect(onCountryChange).toHaveBeenCalledWith('DE');
    expect(chip()).toHaveTextContent('DE');
    expect(number()).toHaveValue('151 234 567 89');
    expect(screen.getByText('عرفنا الدولة من رمزها: ألمانيا.')).toBeInTheDocument();
  });

  it('empties with the clear button', async () => {
    const onValueChange = vi.fn();
    render(<PhoneField {...props} onValueChange={onValueChange} />);
    await userEvent.type(number(), '0944');
    await userEvent.click(screen.getByRole('button', { name: 'مسح الرقم' }));
    expect(number()).toHaveValue('');
    expect(onValueChange).toHaveBeenLastCalledWith('', expect.objectContaining({ country: 'SY' }));
  });

  it('is locked while busy', () => {
    render(<PhoneField {...props} busy defaultValue="+963944123456" />);
    expect(number()).toBeDisabled();
    expect(chip()).toBeDisabled();
  });

  it('shows a stored number in its country, grouped', () => {
    render(<PhoneField {...props} defaultValue="+905321234567" />);
    expect(number()).toHaveValue('532 123 4567');
    expect(chip()).toHaveTextContent('TR');
  });

  describe('the country list', () => {
    it('lists Syria and Turkey first, then the last used, then every country in Arabic order', async () => {
      render(<PhoneField {...props} lastUsedCountry="DE" />);
      await userEvent.click(chip());
      for (const title of ['الأكثر استعمالاً', 'آخر ما استعملته', 'كل الدول'])
        expect(screen.getByText(title)).toBeInTheDocument();
      const options = screen.getAllByRole('option').map((o) => o.getAttribute('data-value'));
      expect(options.slice(0, 3)).toEqual(['SY', 'TR', 'DE']);
      expect(options.length).toBe(245);
      // CLDR's Arabic order: «آيسلندا» before «إثيوبيا» before «أذربيجان».
      expect(options.slice(3, 6)).toEqual(['IS', 'ET', 'AZ']);
      expect(
        within(screen.getAllByRole('option')[0]!).getByText('+963').closest('bdi'),
      ).toHaveAttribute('dir', 'ltr');
    });

    it('searches by the Arabic name, the English name and the calling code', async () => {
      render(<PhoneField {...props} />);
      await userEvent.click(chip());
      const search = screen.getByRole('combobox', { name: 'ابحث باسم الدولة أو رمزها' });
      for (const [query, iso] of [
        ['ألمان', 'DE'],
        ['germ', 'DE'],
        ['+49', 'DE'],
        ['٤٩', 'DE'],
      ] as const) {
        await userEvent.clear(search);
        await userEvent.type(search, query);
        expect(screen.getAllByRole('option').map((o) => o.getAttribute('data-value'))).toContain(
          iso,
        );
      }
      await userEvent.clear(search);
      await userEvent.type(search, 'zzzz');
      expect(screen.getByText('لا دولة بهذا الاسم أو الرمز')).toBeInTheDocument();
    });

    it('picks with the keyboard, switches the chip and closes, giving focus back', async () => {
      const onCountryChange = vi.fn();
      render(<PhoneField {...props} onCountryChange={onCountryChange} />);
      await userEvent.click(chip());
      await userEvent.keyboard('{ArrowDown}{ArrowDown}{Enter}');
      expect(onCountryChange).toHaveBeenCalledWith('TR');
      expect(chip()).toHaveTextContent('TR');
      expect(screen.queryByRole('listbox')).toBeNull();
      await userEvent.click(chip());
      await userEvent.keyboard('{Escape}');
      expect(chip()).toHaveFocus();
    });

    it('draws no flags: names and codes only', async () => {
      render(<PhoneField {...props} />);
      await userEvent.click(chip());
      for (const option of screen.getAllByRole('option').slice(0, 5))
        expect(option.textContent).toMatch(/^[^\u{1F1E6}-\u{1F1FF}]+$/u);
    });
  });
});
