import type { Meta, StoryObj } from '@storybook/react-vite';
import { BannerStack, type StackedBanner } from './banner-stack';

// RA §6.3 in its priority order; review copy where the specs give none.
const all: StackedBanner[] = [
  {
    id: 'offline',
    tone: 'danger',
    icon: 'offline',
    text: 'لا يوجد اتصال بالإنترنت — لن تصلك الطلبات الجديدة حتى يعود الاتصال',
  },
  {
    id: 'stop',
    tone: 'danger',
    icon: 'warning',
    text: 'المنصة متوقفة مؤقتاً عن استقبال طلبات جديدة',
  },
  {
    id: 'device',
    tone: 'caution',
    text: 'فشل فحص الجهاز: الإشعارات متوقفة',
    action: { label: 'افتح الإعدادات', onAction: () => undefined },
  },
  { id: 'settlement', tone: 'warning', text: 'التسوية متأخرة 3 أيام' },
  { id: 'update', tone: 'neutral', text: 'يتوفر تحديث للتطبيق' },
];

const meta = {
  title: 'BannerStack',
  component: BannerStack,
  args: {
    banners: all,
    moreLabel: (hidden: number) => `+${hidden} تنبيهات أخرى`,
    lessLabel: 'إخفاء',
  },
} satisfies Meta<typeof BannerStack>;
export default meta;
type Story = StoryObj<typeof meta>;

export const One: Story = { args: { banners: all.slice(3, 4) } };
export const Two: Story = { args: { banners: all.slice(0, 2) } };
export const Folded: Story = {};
// Drawn opened from the start, so the components canvas shows it (the audit).
export const Opened: Story = { args: { defaultOpen: true } };
