import type { Meta, StoryObj } from '@storybook/react-vite';
import { Select, type SelectProps } from './select';

const meta = {
  title: 'Select',
  component: Select,
  args: {
    label: 'الجنس',
    placeholder: 'اختر',
    items: [
      { value: 'male', label: 'ذكر' },
      { value: 'female', label: 'أنثى' },
    ],
  },
} satisfies Meta<typeof Select>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<SelectProps> = {}): Story => ({ args });

export const Default = make({ hint: 'يظهر في ملفك الشخصي' });
export const Hover = make();
export const Focus = make();
// The list opens by a click, as a person opens it: the popup is placed from the
// open trigger, and a list that starts open is placed before its size is known.
export const Open: Story = {
  play: ({ canvasElement }) => {
    canvasElement.querySelector<HTMLButtonElement>('button[role="combobox"]')?.click();
  },
};
export const Filled = make({ defaultValue: 'female' });
export const Invalid = make({ error: 'اختر الجنس' });
export const Disabled = make({ disabled: true });
export const Compact = make({ density: 'compact', defaultValue: 'male' });
