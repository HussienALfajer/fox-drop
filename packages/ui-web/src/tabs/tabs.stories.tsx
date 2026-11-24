import type { Meta, StoryObj } from '@storybook/react-vite';
import { Tabs, type TabItem } from './tabs';

const panel = (text: string) => <p className="m-none text-panel-body">{text}</p>;

// AP §7.4: a detail page's tabs; review copy.
const details: TabItem[] = [
  { value: 'details', label: 'التفاصيل', content: panel('تفاصيل الطلب') },
  { value: 'money', label: 'المالية', content: panel('المبالغ') },
  { value: 'log', label: 'السجل', content: panel('سجل الحالات') },
  {
    value: 'notes',
    label: 'الملاحظات',
    count: 2,
    countLabel: 'ملاحظتان',
    content: panel('بلا بصل'),
  },
];

const meta = {
  title: 'Tabs',
  component: Tabs,
  args: { label: 'تفاصيل الطلب', items: details, defaultValue: 'details' },
} satisfies Meta<typeof Tabs>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
// The restaurant's board on a phone (RA §8): the columns as tabs with counts.
export const Count: Story = {
  args: {
    label: 'الطلبات',
    defaultValue: 'new',
    density: 'comfortable',
    items: [
      {
        value: 'new',
        label: 'جديدة',
        count: 3,
        countLabel: '3 طلبات',
        content: panel('3 طلبات جديدة'),
      },
      {
        value: 'preparing',
        label: 'قيد التحضير',
        count: 5,
        countLabel: '5 طلبات',
        content: panel('قيد التحضير'),
      },
      { value: 'ready', label: 'جاهزة', content: panel('جاهزة') },
      { value: 'captain', label: 'مع الكابتن', content: panel('مع الكابتن') },
    ],
  },
};
// More tabs than the width: the selected one, the last, stays in view.
export const Overflow: Story = {
  args: {
    label: 'الأقسام',
    defaultValue: 'desserts',
    density: 'comfortable',
    items: ['الكل', 'برجر', 'شاورما', 'بيتزا', 'مشاوي', 'سلطات', 'مشروبات', 'حلويات'].map(
      (label, index) => ({
        value: index === 7 ? 'desserts' : `s${index}`,
        label,
        content: panel(label),
      }),
    ),
  },
  decorators: [(Story) => <div className="max-w-(--fd-size-dialog)">{Story()}</div>],
};
// The customer's menu sections (CU §9): pills, the selected one orange.
export const Pill: Story = {
  args: {
    label: 'الأقسام',
    variant: 'pill',
    density: 'comfortable',
    defaultValue: 'burger',
    items: [
      { value: 'all', label: 'الكل', content: panel('الكل') },
      { value: 'burger', label: 'برجر', content: panel('برجر') },
      { value: 'shawarma', label: 'شاورما', content: panel('شاورما') },
      { value: 'sweets', label: 'حلويات', content: panel('حلويات') },
    ],
  },
};
export const Compact: Story = { args: { density: 'compact' } };
