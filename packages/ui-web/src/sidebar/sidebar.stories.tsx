import type { Meta, StoryObj } from '@storybook/react-vite';
import { useState, type ReactNode } from 'react';
import { Button } from '../button/button';
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

const base = {
  label: 'التنقل الرئيسي',
  items: modules,
  current: '#operations',
  collapseLabel: 'طيّ القائمة',
  expandLabel: 'توسيع القائمة',
  onCollapsedChange: () => undefined,
};

const frame = (children: ReactNode) => <div className="flex h-dvh">{children}</div>;

// The props are a union (the drawer form needs its ×), so each story renders.
const meta = { title: 'Sidebar', component: Sidebar } satisfies Meta<typeof Sidebar>;
export default meta;
type Story = StoryObj;

export const Default: Story = { render: () => frame(<Sidebar {...base} />) };
export const Collapsed: Story = { render: () => frame(<Sidebar {...base} collapsed />) };
export const Portal: Story = {
  render: () => frame(<Sidebar {...base} items={portal} current="#menu" />),
};

function PhoneDrawer() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button
        variant="secondary"
        density="compact"
        icon="menu"
        label="القائمة"
        onClick={() => setOpen(true)}
      />
      <Sidebar
        {...base}
        items={modules.slice(0, 8)}
        form="drawer"
        open={open}
        onOpenChange={setOpen}
        closeLabel="إغلاق"
      />
    </>
  );
}

// Below the tablet width: a popup never starts open, so the story presses the menu button.
export const Drawer: Story = {
  render: () => <PhoneDrawer />,
  play: ({ canvasElement }) => {
    canvasElement.querySelector<HTMLButtonElement>('button')?.click();
  },
};
