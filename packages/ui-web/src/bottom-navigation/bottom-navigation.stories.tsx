import type { Meta, StoryObj } from '@storybook/react-vite';
import { useState } from 'react';
import { BottomNavigation, type BottomNavigationItem } from './bottom-navigation';

// The customer's four tabs (D.10), as the Flutter twin's use cases.
const customer: BottomNavigationItem[] = [
  { icon: 'home', label: 'الرئيسية' },
  { icon: 'search', label: 'البحث' },
  { icon: 'orders', label: 'طلباتي' },
  { icon: 'account', label: 'حسابي' },
];

const badge: BottomNavigationItem[] = [
  { icon: 'home', label: 'الرئيسية' },
  { icon: 'search', label: 'البحث' },
  { icon: 'orders', label: 'طلباتي', count: 1, countLabel: '1 جديد' },
  { icon: 'account', label: 'حسابي' },
];

// The captain's tabs: a dot on «عهدتي».
const dot: BottomNavigationItem[] = [
  { icon: 'home', label: 'الرئيسية' },
  { icon: 'wallet', label: 'أرباحي' },
  { icon: 'cash', label: 'عهدتي', dot: true, countLabel: 'جديد' },
  { icon: 'more', label: 'المزيد' },
];

function Demo({ items }: { items: readonly BottomNavigationItem[] }) {
  const [selected, setSelected] = useState(0);
  return (
    <BottomNavigation
      label="التنقل الرئيسي"
      items={items}
      selected={selected}
      onSelect={setSelected}
    />
  );
}

const meta = {
  title: 'BottomNavigation',
  component: BottomNavigation,
  args: { label: 'التنقل الرئيسي', items: customer, selected: 0, onSelect: () => undefined },
  render: (args) => <Demo items={args.items} />,
} satisfies Meta<typeof BottomNavigation>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Badge: Story = { args: { items: badge } };
export const Dot: Story = { args: { items: dot } };
// The first tab, the current one, under the pointer and with keyboard focus.
export const Hover: Story = {};
export const Focus: Story = {};
