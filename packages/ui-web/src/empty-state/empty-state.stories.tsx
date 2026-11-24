import type { Meta, StoryObj } from '@storybook/react-vite';
import { EmptyState } from './empty-state';

const meta = {
  title: 'EmptyState',
  component: EmptyState,
  args: { icon: 'orders', title: 'لا طلبات بهذه الفلاتر', description: 'غيّر الفترة أو الحالة' },
} satisfies Meta<typeof EmptyState>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Action: Story = {
  args: { action: { label: 'مسح الفلاتر', onPress: () => undefined } },
};
export const Error: Story = {
  args: {
    icon: 'error',
    title: 'حدث خطأ',
    description: 'لم نتمكن من تحميل الطلبات',
    tone: 'error',
    action: { label: 'أعد المحاولة', onPress: () => undefined },
  },
};
export const Compact: Story = { args: { density: 'compact' } };
