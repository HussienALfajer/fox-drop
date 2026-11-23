import type { Meta, StoryObj } from '@storybook/react-vite';
import { RadioGroup, type RadioGroupProps } from './radio-group';

const meta = {
  title: 'RadioGroup',
  component: RadioGroup,
  args: {
    label: 'طريقة الدفع',
    options: [
      { value: 'cash', label: 'نقداً عند الاستلام' },
      { value: 'wallet', label: 'المحفظة' },
    ],
  },
} satisfies Meta<typeof RadioGroup>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<RadioGroupProps> = {}): Story => ({ args });

export const Default = make();
export const Hover = make();
export const Focus = make();
export const Pressed = make();
export const Selected = make({ defaultValue: 'cash' });
export const Invalid = make({ error: 'اختر طريقة الدفع' });
export const Disabled = make({ disabled: true, defaultValue: 'cash' });
