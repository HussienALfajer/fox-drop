import type { Meta, StoryObj } from '@storybook/react-vite';
import { PhoneField, type PhoneFieldProps } from './phone-field';

const meta = {
  title: 'PhoneField',
  component: PhoneField,
  args: {
    label: 'رقم الهاتف',
    chipLabel: (name, code) => `الدولة: ${name}، ${code}. اضغط لتغييرها`,
    searchLabel: 'ابحث باسم الدولة أو رمزها',
    pinnedLabel: 'الأكثر استعمالاً',
    lastUsedLabel: 'آخر ما استعملته',
    allLabel: 'كل الدول',
    emptyLabel: 'لا دولة بهذا الاسم أو الرمز',
    validLabel: 'الرقم صحيح',
    clearLabel: 'مسح الرقم',
    placeholder: '9xx xxx xxx',
    messages: {
      empty: 'أدخل رقم هاتفك.',
      missingDigits: (n) =>
        n === 1 ? 'ينقص رقم واحد.' : n === 2 ? 'ينقص رقمان.' : `ينقص ${n} أرقام.`,
      tooLong: 'الرقم أطول من المعتاد. تأكّد منه.',
      landline: 'هذا رقم أرضي. أدخل رقم جوال عليه واتساب.',
      notMobilePrefix: (prefix) => `أدخل رقم جوال يبدأ بـ ${prefix}.`,
      unknownCode: 'رمز الدولة غير معروف.',
      switched: (name) => `عرفنا الدولة من رمزها: ${name}.`,
    },
  },
} satisfies Meta<typeof PhoneField>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<PhoneFieldProps> = {}): Story => ({ args });

export const Default = make({ hint: 'سنرسل الرمز إلى واتساب' });
export const Hover = make();
export const Focus = make();
// Types `text` into the box as a paste would, then optionally leaves it.
const typeIn =
  (text: string, leave = false): NonNullable<Story['play']> =>
  ({ canvasElement }) => {
    const box = canvasElement.querySelector<HTMLInputElement>('input[type="tel"]')!;
    box.focus();
    Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value')!.set!.call(box, text);
    box.dispatchEvent(new Event('input', { bubbles: true }));
    if (leave) box.blur();
  };

// The country list, open (a popup never starts open: `play` opens it).
export const Open: Story = {
  args: { lastUsedCountry: 'DE' },
  play: ({ canvasElement }) => {
    canvasElement.querySelector<HTMLButtonElement>('button')!.click();
  },
};
export const Filled = make({ defaultValue: '+963944123456' });
export const Valid = make({ defaultValue: '+905321234567' });
// A problem shows on leaving the field.
export const Invalid: Story = { play: typeIn('094412345', true) };
// A pasted German mobile switched the chip by itself.
export const Switched: Story = { play: typeIn('+49 151 23456789') };
export const Busy = make({ busy: true, defaultValue: '+963944123456' });
export const Disabled = make({ disabled: true });
