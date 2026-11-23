import type { Meta, StoryObj } from '@storybook/react-vite';
import { Money } from './money';

const meta = {
  title: 'Money',
  component: Money,
  args: { amount: '45000', symbol: '₺' },
} satisfies Meta<typeof Money>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Fraction: Story = { args: { amount: '1050', symbol: '$' } };
// SYP's large amounts with the Western comma (owner, 2026-11-24).
export const Large: Story = { args: { amount: '330000000', symbol: 'ل.س' } };
// A discount: the minus reads first, at the right in Arabic.
export const Negative: Story = { args: { amount: '-2500', tone: 'success' } };
export const Gain: Story = { args: { amount: '20000', signed: true, tone: 'success' } };
export const Total: Story = { args: { amount: '47000', size: 'number' } };
export const Compact: Story = { args: { amount: '1248050', symbol: '$', size: 'compact' } };
