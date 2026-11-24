import type { Meta, StoryObj } from '@storybook/react-vite';
import { Sidebar, type SidebarItem } from './sidebar';

// AP §7.1: the panel's sixteen modules; a module without an icon in batch 1
// shows a dot until the panel's icon batch (owner, 2026-11-24).
const modules: SidebarItem[] = [
  { href: '#dashboard', label: 'لوحة التحكم', icon: 'home' },
  {
    href: '#operations',
    label: 'غرفة العمليات',
    icon: 'orders',
    count: 3,
    countLabel: '3 تنبيهات',
  },
  { href: '#map', label: 'الخريطة الحية', icon: 'map' },
  { href: '#orders', label: 'سجل الطلبات', icon: 'receipt' },
  { href: '#restaurants', label: 'المطاعم', icon: 'restaurant' },
  { href: '#captains', label: 'الكباتن', icon: 'motorcycle' },
  { href: '#customers', label: 'الزبائن', icon: 'account' },
  { href: '#support', label: 'الدعم', icon: 'chat', count: 12, countLabel: '12 تذكرة' },
  { href: '#finance', label: 'المالية', icon: 'wallet' },
  { href: '#marketing', label: 'التسويق', icon: 'discount' },
  { href: '#zones', label: 'المناطق والتسعير' },
  { href: '#content', label: 'المحتوى', icon: 'image' },
  { href: '#settings', label: 'الإعدادات', icon: 'settings' },
  { href: '#team', label: 'فريق الإدارة' },
  { href: '#audit', label: 'سجل التدقيق' },
  { href: '#reports', label: 'التقارير' },
];

// RA §17: the owner portal.
const portal: SidebarItem[] = [
  { href: '#orders', label: 'الطلبات', icon: 'orders' },
  { href: '#history', label: 'السجل', icon: 'clock' },
  { href: '#menu', label: 'القائمة', icon: 'plate' },
  { href: '#status', label: 'الحالة والأوقات', icon: 'restaurant' },
  { href: '#reports', label: 'التقارير' },
  { href: '#account', label: 'الحساب', icon: 'wallet' },
  { href: '#ratings', label: 'التقييمات', icon: 'star' },
  { href: '#staff', label: 'الموظفون والأجهزة' },
  { href: '#settings', label: 'الإعدادات', icon: 'settings' },
  { href: '#support', label: 'الدعم', icon: 'chat' },
];

const meta = {
  title: 'Sidebar',
  component: Sidebar,
  args: {
    label: 'التنقل الرئيسي',
    items: modules,
    current: '#operations',
    collapseLabel: 'طيّ القائمة',
    expandLabel: 'توسيع القائمة',
    onCollapsedChange: () => undefined,
  },
  decorators: [(Story) => <div className="flex h-dvh">{Story()}</div>],
} satisfies Meta<typeof Sidebar>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Collapsed: Story = { args: { collapsed: true } };
export const Portal: Story = { args: { items: portal, current: '#menu' } };
export const Drawer: Story = {
  args: { form: 'drawer', open: true, closeLabel: 'إغلاق', items: modules.slice(0, 8) },
};
