import type { Meta, StoryObj } from '@storybook/react-vite';
import { TimeField, type TimeFieldProps } from './time-field';

const meta = {
  title: 'TimeField',
  component: TimeField,
  args: { label: 'وقت الاستلام' },
} satisfies Meta<typeof TimeField>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<TimeFieldProps> = {}): Story => ({ args });

export const Default = make({ hint: 'بين 9 ص و11 م' });
export const Hover = make();
export const Focus = make();
export const Filled = make({ defaultValue: '15:05' });
export const Invalid = make({ defaultValue: '03:00', error: 'المطعم مغلق في هذا الوقت' });
export const Disabled = make({ disabled: true, defaultValue: '15:05' });
