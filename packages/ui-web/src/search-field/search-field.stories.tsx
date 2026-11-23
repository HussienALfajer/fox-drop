import type { Meta, StoryObj } from '@storybook/react-vite';
import { SearchField, type SearchFieldProps } from './search-field';

const meta = {
  title: 'SearchField',
  component: SearchField,
  args: { label: 'ابحث عن مطعم', clearLabel: 'مسح', placeholder: 'ابحث عن مطعم أو وجبة' },
} satisfies Meta<typeof SearchField>;
export default meta;
type Story = StoryObj<typeof meta>;

const make = (args: Partial<SearchFieldProps> = {}): Story => ({ args });

export const Default = make();
export const Hover = make();
export const Focus = make();
export const Filled = make({ defaultValue: 'شاورما' });
export const Loading = make({ defaultValue: 'شاورما', loading: true });
export const Disabled = make({ disabled: true });
export const Compact = make({ density: 'compact', defaultValue: 'شاورما' });
