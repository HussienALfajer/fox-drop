import type { Meta, StoryObj } from '@storybook/react-vite';
import { AmountsSummary } from './amounts-summary';

const meta = {
  title: 'AmountsSummary',
  component: AmountsSummary,
  args: {
    lines: [
      { label: 'قيمة الأصناف', amount: '45200' },
      { label: 'رسوم التوصيل', amount: '4500' },
      { label: 'الخصم (FOX25)', amount: '-2500', tone: 'success' },
      { label: 'تقريب', amount: '-200' },
    ],
    total: { label: 'المجموع', amount: '47000' },
    symbol: '₺',
    equivalents: 'أو 11.50 $ · 3,300,000 ل.س',
  },
} satisfies Meta<typeof AmountsSummary>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
// The customer's cart and checkout (owner, 2026-11-24).
export const Prominent: Story = { args: { variant: 'prominent' } };
export const Free: Story = {
  args: {
    lines: [
      { label: 'قيمة الأصناف', amount: '45000' },
      { label: 'رسوم التوصيل', amount: '0', text: 'مجاني' },
    ],
    total: { label: 'المجموع', amount: '45000' },
  },
};
export const Compact: Story = { args: { density: 'compact', equivalents: undefined } };
