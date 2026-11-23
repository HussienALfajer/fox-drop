import type { Meta, StoryObj } from '@storybook/react-vite';
import { StatusChip } from './status-chip';

const meta = {
  title: 'StatusChip',
  component: StatusChip,
  args: { status: 'placed', label: 'بانتظار المطعم' },
} satisfies Meta<typeof StatusChip>;
export default meta;
type Story = StoryObj<typeof meta>;

// The panel's labels of AP §8.1.
export const Placed: Story = {};
export const Accepted: Story = { args: { status: 'accepted', label: 'قيد التحضير' } };
export const Ready: Story = { args: { status: 'ready', label: 'جاهز' } };
export const Picked_up: Story = { args: { status: 'picked_up', label: 'مع الكابتن' } };
export const Arrived: Story = { args: { status: 'arrived', label: 'الكابتن وصل' } };
export const Delivered: Story = { args: { status: 'delivered', label: 'تم التسليم' } };
export const Rejected: Story = { args: { status: 'rejected', label: 'مرفوض' } };
export const Cancelled: Story = { args: { status: 'cancelled', label: 'ملغى' } };
export const Failed: Story = { args: { status: 'failed', label: 'فشل التسليم' } };
// A restaurant's state badge (CU §8.2).
export const Tone: Story = {
  render: () => <StatusChip tone="warning" icon="clock" label="مشغول" />,
};
export const Compact: Story = {
  args: { status: 'accepted', label: 'قيد التحضير', density: 'compact' },
};
