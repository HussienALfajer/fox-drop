import type { Meta, StoryObj } from '@storybook/react-vite';
import { Icon } from '../icon/icon';
import { Menu } from '../menu/menu';
import { SearchField } from '../search-field/search-field';
import { TopBar } from './top-bar';

// AP §7.2: the panel's slots, filled with review copy.
const pill = (text: string, className: string) => (
  <span
    className={`inline-flex min-h-(--fd-size-control-compact) items-center gap-xs rounded-full px-sm text-panel-body font-medium ${className}`}
  >
    {text}
  </span>
);

const userMenu = (
  <Menu
    triggerLabel="سارة م."
    triggerStart={
      <span className="inline-flex size-xl items-center justify-center rounded-full bg-info-subtle">
        <Icon name="account" size="sm" />
      </span>
    }
    items={[
      { label: 'الملف الشخصي', icon: 'account', onSelect: () => undefined },
      { label: 'الجلسات', icon: 'settings', onSelect: () => undefined },
      'separator',
      { label: 'تسجيل الخروج', destructive: true, onSelect: () => undefined },
    ]}
  />
);

const meta = {
  title: 'TopBar',
  component: TopBar,
  args: {
    label: 'الشريط العلوي',
    start: (
      <>
        {pill('أعزاز', 'inset-ring-1 inset-ring-border-strong')}
        {pill('المنصة تعمل', 'bg-success-subtle text-success font-bold')}
        {pill('التوزيع: مختلط', 'bg-surface')}
      </>
    ),
    children: (
      <SearchField
        label="بحث"
        clearLabel="مسح"
        placeholder="رقم طلب، مطعم، كابتن، تذكرة…"
        density="compact"
      />
    ),
    actions: [
      {
        icon: 'bell',
        label: 'التنبيهات',
        count: 4,
        countLabel: '4 مفتوحة',
        onAction: () => undefined,
      },
      {
        icon: 'success',
        label: 'الموافقات',
        count: 2,
        countLabel: '2 بانتظارك',
        onAction: () => undefined,
      },
    ],
    end: userMenu,
  },
} satisfies Meta<typeof TopBar>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
// Below the tablet width: the menu button opens the sidebar drawer.
export const Phone: Story = {
  args: {
    title: 'غرفة العمليات',
    menu: { label: 'القائمة', onMenu: () => undefined },
    start: undefined,
    children: undefined,
    end: undefined,
    actions: [
      {
        icon: 'bell',
        label: 'التنبيهات',
        count: 4,
        countLabel: '4 مفتوحة',
        onAction: () => undefined,
      },
    ],
  },
};
// AP §7.2: «إيقاف طارئ» in red.
export const Emergency: Story = {
  args: {
    start: (
      <span className="inline-flex min-h-(--fd-size-control-compact) items-center gap-xs rounded-full bg-danger px-sm text-panel-body font-bold text-on-danger">
        <Icon name="warning" size="sm" />
        إيقاف طارئ
      </span>
    ),
  },
};
