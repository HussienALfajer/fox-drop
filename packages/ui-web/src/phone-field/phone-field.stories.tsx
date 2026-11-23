import type { Meta, StoryObj } from '@storybook/react-vite';
import { PhoneField, type PhoneFieldProps } from './phone-field';

const meta = {
  title: 'PhoneField',
  component: PhoneField,
  args: {
    label: 'رقم الهاتف',
    countryLabel: 'الدولة',
    countryLabels: { sy: 'سوريا', tr: 'تركيا' },
    placeholder: '9xx xxx xxx',
  },
} satisfies Meta<typeof PhoneField>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<PhoneFieldProps> = {}): Story => ({ args });

export const Default = make({ hint: 'سنرسل الرمز إلى واتساب' });
export const Hover = make();
export const Focus = make();
export const Filled = make({ defaultValue: '+963912345678' });
export const Invalid = make({ error: 'رقم غير صحيح', defaultValue: '+963912345678' });
export const Disabled = make({ disabled: true });
export const Turkey = make({ defaultValue: '+905321234567', placeholder: '5xx xxx xx xx' });
