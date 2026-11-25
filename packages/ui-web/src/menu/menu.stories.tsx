import type { Meta, StoryObj } from '@storybook/react-vite';
import { Menu } from './menu';

// AP §7.2: the panel's user menu. «تسجيل الخروج» has no icon until the
// panel's icon batch (owner, 2026-11-24).
const meta = {
  title: 'Menu',
  component: Menu,
  args: {
    triggerLabel: 'سارة م.',
    items: [
      { label: 'الملف الشخصي', icon: 'account', onSelect: () => undefined },
      { label: 'الجلسات', icon: 'settings', onSelect: () => undefined },
      'separator',
      { label: 'تسجيل الخروج', destructive: true, onSelect: () => undefined },
    ],
  },
} satisfies Meta<typeof Menu>;
export default meta;
type Story = StoryObj<typeof meta>;

const open: Story['play'] = ({ canvasElement }) => {
  canvasElement.querySelector<HTMLButtonElement>('button')!.click();
};

export const Default: Story = {};
export const Open: Story = { play: open };
// A row's «⋯»: edit, share, then delete in danger after a separator.
export const Destructive: Story = {
  args: {
    triggerLabel: 'المزيد',
    triggerIcon: 'more',
    items: [
      { label: 'تعديل', icon: 'edit', onSelect: () => undefined },
      { label: 'مشاركة', icon: 'share', onSelect: () => undefined },
      'separator',
      { label: 'حذف من السلة', icon: 'delete', destructive: true, onSelect: () => undefined },
    ],
  },
  play: open,
};
export const Comfortable: Story = { args: { density: 'comfortable' }, play: open };
