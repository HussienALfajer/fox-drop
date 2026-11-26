// D.C3: the components canvas draws every popup open inside its board, beside
// the page: with `inline` (and `open`) each renders inside the element it is
// written in, never in the browser's top layer or at `document.body`, keeps its
// role and name, takes no focus, and leaves the page around it usable.
import { act, render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import type { ReactElement } from 'react';
import { describe, expect, it, vi } from 'vitest';
import { BlockingBanner } from '../blocking-banner/blocking-banner';
import { Button } from '../button/button';
import { ConfirmDialog } from '../confirm-dialog/confirm-dialog';
import { CountrySheet } from '../country-sheet/country-sheet';
import { DateField } from '../date-field/date-field';
import { Dialog } from '../dialog/dialog';
import { Drawer } from '../drawer/drawer';
import { Menu } from '../menu/menu';
import { PhoneField } from '../phone-field/phone-field';
import { Select } from '../select/select';
import { Sidebar } from '../sidebar/sidebar';
import { Toaster } from '../toaster/toaster';
import { Tooltip } from '../tooltip/tooltip';

/** Renders `popup` in a frame beside a button and a field of the page. */
function inFrame(popup: ReactElement) {
  const outsidePresses = vi.fn();
  render(
    <div>
      <button type="button" onClick={outsidePresses}>
        خارج النافذة
      </button>
      <input aria-label="حقل خارج النافذة" />
      <div data-testid="frame">{popup}</div>
    </div>,
  );
  return { frame: screen.getByTestId('frame'), outsidePresses };
}

/** Inside its frame, out of the top layer, and the page around it still usable. */
async function besideThePage(found: HTMLElement, outsidePresses: () => void) {
  expect(screen.getByTestId('frame')).toContainElement(found);
  expect(found.closest('[popover]')).toBeNull();
  const outside = screen.getByRole('button', { name: 'خارج النافذة' });
  expect(outside.closest('[inert], [aria-hidden="true"]')).toBeNull();
  expect(found).not.toContainElement(document.activeElement as HTMLElement | null);
  await userEvent.click(outside);
  expect(outsidePresses).toHaveBeenCalledTimes(1);
  const field = screen.getByRole('textbox', { name: 'حقل خارج النافذة' });
  await userEvent.click(field);
  await userEvent.keyboard('abc');
  expect(field).toHaveValue('abc');
  expect(document.documentElement.style.overflow).not.toBe('hidden');
}

const countryLabels = {
  searchLabel: 'ابحث باسم الدولة أو رمزها',
  pinnedLabel: 'الأكثر استعمالاً',
  lastUsedLabel: 'آخر ما استعملته',
  allLabel: 'كل الدول',
  emptyLabel: 'لا دولة بهذا الاسم أو الرمز',
};

describe('a popup drawn inline', () => {
  it('Menu: its list under its trigger, still open after a press outside', async () => {
    const { outsidePresses } = inFrame(
      <Menu
        open
        inline
        triggerLabel="سارة م."
        items={[{ label: 'الملف الشخصي', onSelect: () => undefined }]}
      />,
    );
    const menu = await screen.findByRole('menu');
    expect(within(menu).getByRole('menuitem', { name: 'الملف الشخصي' })).toBeInTheDocument();
    await besideThePage(menu, outsidePresses);
    expect(screen.getByRole('menu')).toBeInTheDocument();
  });

  it('Select: its listbox under the field', async () => {
    const { outsidePresses } = inFrame(
      <Select
        open
        inline
        label="الجنس"
        items={[
          { value: 'male', label: 'ذكر' },
          { value: 'female', label: 'أنثى' },
        ]}
      />,
    );
    const list = await screen.findByRole('listbox');
    expect(within(list).getByRole('option', { name: 'أنثى' })).toBeInTheDocument();
    await besideThePage(list, outsidePresses);
    expect(screen.getByRole('listbox')).toBeInTheDocument();
  });

  it('Tooltip: its words beside the trigger, describing it', async () => {
    const { outsidePresses } = inFrame(
      <Tooltip open inline content="التنبيهات المفتوحة: 4">
        <button type="button">التنبيهات</button>
      </Tooltip>,
    );
    const tip = await screen.findByRole('tooltip');
    expect(tip).toHaveTextContent('التنبيهات المفتوحة: 4');
    expect(screen.getByRole('button', { name: 'التنبيهات' })).toHaveAccessibleDescription(
      'التنبيهات المفتوحة: 4',
    );
    await besideThePage(tip, outsidePresses);
  });

  it('CountrySheet: its list and search beside the trigger, the search not focused', async () => {
    const { outsidePresses } = inFrame(
      <CountrySheet open inline value="SY" onValueChange={() => undefined} {...countryLabels}>
        <CountrySheet.Trigger>الدولة: سوريا</CountrySheet.Trigger>
      </CountrySheet>,
    );
    const list = await screen.findByRole('listbox');
    expect(within(list).getByRole('option', { name: /سوريا/ })).toBeInTheDocument();
    expect(screen.getByRole('combobox', { name: countryLabels.searchLabel })).not.toHaveFocus();
    await besideThePage(list, outsidePresses);
  });

  it('DateField: its calendar under the field', async () => {
    const { outsidePresses } = inFrame(
      <DateField
        open
        inline
        label="تاريخ الميلاد"
        previousLabel="الشهر السابق"
        nextLabel="الشهر التالي"
        today="2027-03-10"
        defaultValue="2027-03-05"
      />,
    );
    const grid = await screen.findByRole('grid');
    expect(screen.getByRole('button', { name: 'الشهر التالي' })).toBeInTheDocument();
    await besideThePage(grid, outsidePresses);
    expect(screen.getByRole('grid')).toBeInTheDocument();
  });

  it('PhoneField: the country list under the field, not inside its pill', async () => {
    const { outsidePresses } = inFrame(
      <PhoneField
        open
        inline
        label="رقم الهاتف"
        chipLabel={(name, code) => `الدولة: ${name}، ${code}`}
        validLabel="الرقم صحيح"
        clearLabel="مسح الرقم"
        messages={{
          empty: 'أدخل رقم هاتفك.',
          missingDigits: () => 'ينقص رقم.',
          tooLong: 'طويل.',
          landline: 'أرضي.',
          notMobilePrefix: () => 'ليس جوالاً.',
          unknownCode: 'رمز غير معروف.',
          switched: () => 'تبدّلت الدولة.',
        }}
        {...countryLabels}
      />,
    );
    const list = await screen.findByRole('listbox');
    const box = screen.getByRole('textbox', { name: 'رقم الهاتف' });
    expect(box.parentElement).not.toContainElement(list);
    await besideThePage(list, outsidePresses);
  });

  it('ConfirmDialog: a plain dialog with its scrim in its frame, the reason not focused', async () => {
    const { frame, outsidePresses } = inFrame(
      <ConfirmDialog
        open
        inline
        title="إلغاء الطلب #10423"
        reasonLabel="السبب"
        reasonError="السبب مطلوب"
        notifyTitle="سيُبلَّغ"
        notified={['الزبون']}
        confirmLabel="تأكيد الإلغاء"
        cancelLabel="تراجع"
        closeLabel="إغلاق"
        onConfirm={() => undefined}
      />,
    );
    const dialog = await screen.findByRole('dialog', { name: 'إلغاء الطلب #10423' });
    expect(frame.querySelector('[data-scrim]')).not.toBeNull();
    await besideThePage(dialog, outsidePresses);
    expect(screen.getByRole('dialog', { name: 'إلغاء الطلب #10423' })).toBeInTheDocument();
  });

  it('BlockingBanner: its bar and scrim over its frame only', async () => {
    const { frame, outsidePresses } = inFrame(
      <BlockingBanner
        open
        inline
        text="اضغط لتفعيل صوت التنبيهات"
        actionLabel="تفعيل الصوت"
        onEnable={() => undefined}
      />,
    );
    const bar = await screen.findByRole('dialog', { name: 'اضغط لتفعيل صوت التنبيهات' });
    expect(frame.querySelector('[data-scrim]')).not.toBeNull();
    await besideThePage(bar, outsidePresses);
  });

  it('Drawer: its panel at its side of the frame', async () => {
    const { frame, outsidePresses } = inFrame(
      <Drawer open inline title="الطلب #10421" closeLabel="إغلاق">
        <p>كنافة أعزاز</p>
      </Drawer>,
    );
    const drawer = await screen.findByRole('dialog', { name: 'الطلب #10421' });
    expect(frame.querySelector('[data-scrim]')).not.toBeNull();
    await besideThePage(drawer, outsidePresses);
    expect(screen.getByRole('dialog', { name: 'الطلب #10421' })).toBeInTheDocument();
  });

  it('Sidebar: its phone drawer, the navigation inside it', async () => {
    const { outsidePresses } = inFrame(
      <Sidebar
        form="drawer"
        open
        inline
        label="التنقل الرئيسي"
        items={[{ href: '#orders', label: 'سجل الطلبات', icon: 'receipt' }]}
        current="#orders"
        collapseLabel="طيّ القائمة"
        expandLabel="توسيع القائمة"
        closeLabel="إغلاق"
      />,
    );
    const nav = await screen.findByRole('navigation', { name: 'التنقل الرئيسي' });
    await besideThePage(nav, outsidePresses);
  });

  it('Toaster: its toasts where it is written, staying until closed', async () => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
    try {
      const { frame } = inFrame(
        <Toaster
          inline
          label="الإشعارات"
          closeLabel="إغلاق"
          toasts={[
            { tone: 'success', text: 'حُفظت التغييرات' },
            { tone: 'danger', text: 'تعذّر الحفظ' },
          ]}
        >
          {null}
        </Toaster>,
      );
      const region = screen.getByRole('region', { name: 'الإشعارات' });
      expect(frame).toContainElement(region);
      expect(within(region).getByText('حُفظت التغييرات')).toBeInTheDocument();
      expect(within(region).getByText('تعذّر الحفظ')).toBeInTheDocument();
      // In act, so React applies what the timers did.
      await act(async () => {
        await vi.advanceTimersByTimeAsync(10_000);
      });
      expect(within(region).getByText('حُفظت التغييرات')).toBeInTheDocument();
    } finally {
      vi.useRealTimers();
    }
  });

  it('Toaster: given toasts, it shows them from the start at its corner when not inline', async () => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
    try {
      render(
        <Toaster
          label="الإشعارات"
          closeLabel="إغلاق"
          toasts={[{ tone: 'info', text: 'نُسخ رقم الطلب' }]}
        >
          {null}
        </Toaster>,
      );
      expect(screen.getByText('نُسخ رقم الطلب')).toBeInTheDocument();
      // In act, so React applies what the timers did.
      await act(async () => {
        await vi.advanceTimersByTimeAsync(5_000);
      });
      expect(screen.queryByText('نُسخ رقم الطلب')).toBeNull();
    } finally {
      vi.useRealTimers();
    }
  });
});

// The components canvas audit (2026-11-27): in Play the owner opens an inline
// copy by its trigger; it then takes focus, as it does off the canvas, so the
// keyboard reaches it and Escape closes it. Only a copy drawn open from the
// start (controlled `open`) keeps its hands off the focus.
describe('an inline popup opened by its trigger', () => {
  const opener = <Button>افتح</Button>;
  it.each([
    [
      'Dialog',
      <Dialog
        key="d"
        inline
        trigger={opener}
        title="حذف العنوان"
        confirmLabel="حذف"
        cancelLabel="إلغاء"
        closeLabel="إغلاق"
      />,
    ],
    [
      'ConfirmDialog',
      <ConfirmDialog
        key="c"
        inline
        trigger={opener}
        title="إلغاء الطلب"
        reasonLabel="السبب"
        reasonError="اكتب السبب"
        notifyTitle="سيُبلَّغ"
        notified={['الزبون']}
        confirmLabel="إلغاء الطلب"
        cancelLabel="رجوع"
        closeLabel="إغلاق"
        onConfirm={() => undefined}
      />,
    ],
    [
      'Drawer',
      <Drawer key="r" inline trigger={opener} title="القائمة" closeLabel="إغلاق">
        <p>المحتوى</p>
      </Drawer>,
    ],
  ])('%s takes focus and closes on Escape', async (_, popup) => {
    render(popup);
    await userEvent.click(screen.getByRole('button', { name: 'افتح' }));
    const dialog = await screen.findByRole('dialog');
    expect(dialog).toContainElement(document.activeElement as HTMLElement | null);
    await userEvent.keyboard('{Escape}');
    expect(screen.queryByRole('dialog')).toBeNull();
  });
});
