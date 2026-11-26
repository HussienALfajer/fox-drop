import { fireEvent, render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { CodePreview } from './code-preview/code-preview';
import { CountrySheet, CountrySheetTrigger } from './country-sheet/country-sheet';
import { DateField } from './date-field/date-field';
import { TimeField } from './time-field/time-field';

// The web versions of the Flutter-only date, time, country list and code
// preview (D.W4a), against their approved twins (D.8, D.11, D.11b).

const date = {
  label: 'تاريخ الميلاد',
  placeholder: 'اختر التاريخ',
  previousLabel: 'الشهر السابق',
  nextLabel: 'الشهر التالي',
  today: '2027-03-10',
};

const trigger = () => screen.getByRole('button', { name: /تاريخ الميلاد/ });

describe('DateField', () => {
  it('shows the date as dd/mm/yyyy in Western digits, named by its label', () => {
    render(<DateField {...date} defaultValue="2027-03-05" />);
    expect(trigger()).toHaveTextContent('05/03/2027');
    expect(trigger().textContent).not.toMatch(/[٠-٩]/);
  });

  it('shows the placeholder while empty', () => {
    render(<DateField {...date} />);
    expect(trigger()).toHaveTextContent('اختر التاريخ');
  });

  it('reads the error with the field', () => {
    render(<DateField {...date} error="اختر تاريخاً صحيحاً" />);
    expect(trigger()).toHaveAccessibleDescription(/اختر تاريخاً صحيحاً/);
    expect(trigger()).toHaveAttribute('aria-invalid', 'true');
  });

  it('is disabled', () => {
    render(<DateField {...date} disabled />);
    expect(trigger()).toBeDisabled();
  });

  it('opens a calendar with the Syriac month, the week from Saturday and Western digits', async () => {
    render(<DateField {...date} defaultValue="2027-03-05" />);
    await userEvent.click(trigger());
    const grid = await screen.findByRole('grid');
    expect(screen.getByRole('heading', { name: 'آذار 2027' })).toBeInTheDocument();
    const weekdays = within(grid).getAllByRole('columnheader');
    expect(weekdays).toHaveLength(7);
    expect(weekdays[0]).toHaveAccessibleName(/السبت/);
    expect(grid.textContent).not.toMatch(/[٠-٩]/);
    expect(screen.getByRole('button', { name: 'الشهر السابق' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'الشهر التالي' })).toBeInTheDocument();
  });

  it('moves by day with the arrows in RTL (left is the next day), picks with Enter', async () => {
    const onValueChange = vi.fn();
    render(<DateField {...date} defaultValue="2027-03-05" onValueChange={onValueChange} />);
    await userEvent.click(trigger());
    await screen.findByRole('grid');
    await userEvent.keyboard('{ArrowLeft}{Enter}');
    expect(onValueChange).toHaveBeenLastCalledWith('2027-03-06');
    expect(trigger()).toHaveTextContent('06/03/2027');
  });

  it('closes on Escape without a change', async () => {
    const onValueChange = vi.fn();
    render(<DateField {...date} defaultValue="2027-03-05" onValueChange={onValueChange} />);
    await userEvent.click(trigger());
    await screen.findByRole('grid');
    await userEvent.keyboard('{Escape}');
    expect(screen.queryByRole('grid')).toBeNull();
    expect(onValueChange).not.toHaveBeenCalled();
  });
});

const time = { label: 'وقت الاستلام' };
const timeGroup = () => screen.getByRole('group', { name: 'وقت الاستلام' });
// Each box is an input: what it shows is its value.
const boxes = () =>
  within(timeGroup())
    .getAllByRole('spinbutton')
    .map((box) => (box as HTMLInputElement).value);

describe('TimeField', () => {
  it('shows 12-hour time with «م», Western digits, named by its label', () => {
    render(<TimeField {...time} defaultValue="15:05" />);
    expect(boxes()).toEqual(['03', '05', 'م']);
    expect(boxes().join('')).not.toMatch(/[٠-٩]/);
  });

  it('shows «ص» in the morning', () => {
    render(<TimeField {...time} defaultValue="09:30" />);
    expect(boxes()).toEqual(['09', '30', 'ص']);
  });

  it('steps the minute with the arrow keys', async () => {
    const onValueChange = vi.fn();
    render(<TimeField {...time} defaultValue="15:05" onValueChange={onValueChange} />);
    const minute = within(timeGroup()).getAllByRole('spinbutton')[1]!;
    minute.focus();
    fireEvent.keyDown(minute, { key: 'ArrowUp' });
    expect(onValueChange).toHaveBeenLastCalledWith('15:06');
  });

  it('reads the error with the field, and is disabled', () => {
    // The group, which every box sits in, carries the description.
    const { unmount } = render(<TimeField {...time} error="اختر وقتاً" />);
    expect(timeGroup()).toHaveAccessibleDescription(/اختر وقتاً/);
    expect(timeGroup()).toHaveAttribute('aria-invalid', 'true');
    unmount();
    render(<TimeField {...time} disabled />);
    for (const segment of within(timeGroup()).getAllByRole('spinbutton'))
      expect(segment).toBeDisabled();
  });
});

const sheet = {
  searchLabel: 'ابحث باسم الدولة أو رمزها',
  pinnedLabel: 'الأكثر استعمالاً',
  lastUsedLabel: 'آخر ما استعملته',
  allLabel: 'كل الدول',
  emptyLabel: 'لا دولة بهذا الاسم أو الرمز',
};

function Sheet(props: { onValueChange?: (iso: string) => void; lastUsed?: string }) {
  return (
    <CountrySheet
      {...sheet}
      value="SY"
      onValueChange={props.onValueChange ?? (() => undefined)}
      {...(props.lastUsed && { lastUsed: props.lastUsed })}
    >
      <CountrySheetTrigger>الدولة</CountrySheetTrigger>
    </CountrySheet>
  );
}

const open = async () => {
  // The trigger is a button; the search field inside the list is the combobox.
  await userEvent.click(screen.getByRole('button', { name: 'الدولة' }));
  return screen.findByRole('combobox', { name: sheet.searchLabel });
};

describe('CountrySheet', () => {
  it('lists Syria and Turkey first, then the last used, then every country', async () => {
    render(<Sheet lastUsed="DE" />);
    await open();
    const groups = screen.getAllByRole('group');
    expect(groups.map((group) => within(group).getAllByRole('option')[0]!.textContent)).toEqual([
      expect.stringContaining('سوريا'),
      expect.stringContaining('ألمانيا'),
      expect.anything(),
    ]);
    expect(screen.getByRole('group', { name: sheet.pinnedLabel })).toBeInTheDocument();
    expect(screen.getByRole('group', { name: sheet.lastUsedLabel })).toBeInTheDocument();
    expect(screen.getByRole('group', { name: sheet.allLabel })).toBeInTheDocument();
  });

  it.each([
    ['the Arabic name', 'ألمان'],
    ['the English name', 'germ'],
    ['the calling code', '+49'],
  ])('finds a country by %s', async (_, query) => {
    render(<Sheet />);
    await userEvent.type(await open(), query);
    expect(screen.getByRole('option', { name: /ألمانيا/ })).toBeInTheDocument();
    expect(screen.queryByRole('option', { name: /سوريا/ })).toBeNull();
  });

  it('shows the calling code left to right, in Western digits', async () => {
    render(<Sheet />);
    await open();
    const code = screen.getByRole('option', { name: /سوريا/ }).querySelector('bdi[dir="ltr"]');
    expect(code).toHaveTextContent('+963');
  });

  it('says so when nothing matches', async () => {
    render(<Sheet />);
    await userEvent.type(await open(), 'zzzz');
    expect(screen.getByText(sheet.emptyLabel)).toBeInTheDocument();
  });

  it('picks with Enter and closes on Escape', async () => {
    const onValueChange = vi.fn();
    render(<Sheet onValueChange={onValueChange} />);
    await userEvent.type(await open(), 'germ');
    await userEvent.keyboard('{ArrowDown}{Enter}');
    expect(onValueChange).toHaveBeenLastCalledWith('DE');
    await open();
    await userEvent.keyboard('{Escape}');
    expect(screen.queryByRole('listbox')).toBeNull();
  });
});

describe('CodePreview', () => {
  const preview = {
    sender: 'FOX DROP',
    message: 'رمز الدخول إلى FOX DROP:',
    time: 'الآن · واتساب',
    label: 'ستصلك رسالة على واتساب من FOX DROP فيها رمز الدخول',
  };

  it('is read once, by its label', () => {
    render(<CodePreview {...preview} />);
    const figure = screen.getByRole('img', { name: preview.label });
    expect(figure.querySelector('[aria-hidden="true"]')).not.toBeNull();
  });

  it('never shows a code: six dots in its place', () => {
    render(<CodePreview {...preview} />);
    const figure = screen.getByRole('img', { name: preview.label });
    expect(figure).toHaveTextContent('••••••');
    expect(figure.textContent).not.toMatch(/\d/);
  });

  it('drops the sender when compact', () => {
    const { rerender } = render(<CodePreview {...preview} />);
    expect(screen.getByRole('img', { name: preview.label })).toHaveTextContent('FOX DROP:');
    expect(screen.getAllByText('FOX DROP')).toHaveLength(1);
    rerender(<CodePreview {...preview} compact />);
    expect(screen.queryByText('FOX DROP')).toBeNull();
  });
});
