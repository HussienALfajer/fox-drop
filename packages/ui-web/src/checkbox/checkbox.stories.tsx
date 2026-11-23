import type { Meta, StoryObj } from '@storybook/react-vite';
import { Checkbox, type CheckboxProps } from './checkbox';

const meta = {
  title: 'Checkbox',
  component: Checkbox,
  args: { label: 'أوافق على الشروط' },
} satisfies Meta<typeof Checkbox>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<CheckboxProps> = {}): Story => ({ args });

export const Default = make();
export const Hover = make();
export const Focus = make();
export const Pressed = make();
export const Checked = make({ defaultChecked: true });
export const Mixed = make({ defaultChecked: 'indeterminate', label: 'كل الإضافات' });
export const Invalid = make({ invalid: true });
export const Disabled = make({ disabled: true });
export const DisabledChecked = make({ disabled: true, defaultChecked: true });
