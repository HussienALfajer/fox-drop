import type { Meta, StoryObj } from '@storybook/react-vite';
import { Banner } from './banner';

const meta = {
  title: 'Banner',
  component: Banner,
  args: {
    tone: 'danger',
    children: 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال',
  },
} satisfies Meta<typeof Banner>;
export default meta;
type Story = StoryObj<typeof meta>;

// The texts of RA §6.3 and RA §4.7; review copy where the specs give none.
export const Danger: Story = { args: { icon: 'offline' } };
export const Caution: Story = {
  args: {
    tone: 'caution',
    children: 'فشل فحص الجهاز: الإشعارات متوقفة',
    action: { label: 'افتح الإعدادات', onAction: () => undefined },
  },
};
export const Warning: Story = {
  args: { tone: 'warning', children: 'وضع الضغط مفعّل: +10 د على وقت التحضير' },
};
export const Info: Story = {
  args: { tone: 'info', children: 'وضع التجربة: الطلبات لا تصل للزبائن' },
};
export const Neutral: Story = { args: { tone: 'neutral', children: 'يتوفر تحديث للتطبيق' } };
export const Action: Story = {
  args: {
    tone: 'neutral',
    children: 'يتوفر تحديث للتطبيق',
    action: { label: 'تحديث', onAction: () => undefined },
  },
};
export const Compact: Story = {
  args: { tone: 'warning', children: 'التسوية متأخرة 3 أيام', density: 'compact' },
};
