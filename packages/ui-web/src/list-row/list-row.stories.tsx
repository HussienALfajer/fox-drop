import type { Meta, StoryObj } from '@storybook/react-vite';
import { Money } from '../money/money';
import { StatusChip } from '../status-chip/status-chip';
import { ListRow } from './list-row';

const meta = {
  title: 'ListRow',
  component: ListRow,
  args: { title: 'المنزل' },
} satisfies Meta<typeof ListRow>;
export default meta;
type Story = StoryObj<typeof meta>;

const address = {
  description: 'أعزاز — دوار الكفين، بناء 4',
  leading: 'house',
  onPress: () => undefined,
} as const;

export const Default: Story = { args: address };
export const Value: Story = {
  args: {
    title: 'رصيد العهدة',
    leading: 'wallet',
    end: <Money amount="125000" symbol="₺" bold />,
  },
};
export const Hover: Story = { args: address };
export const Focus: Story = { args: address };
export const Pressed: Story = { args: address };
export const Danger: Story = {
  args: { title: 'حذف العنوان', leading: 'delete', tone: 'danger', onPress: () => undefined },
};
export const Disabled: Story = {
  args: {
    title: 'أكوادي',
    description: 'لا أكواد الآن',
    leading: 'gift',
    disabled: true,
    onPress: () => undefined,
  },
};
export const Compact: Story = {
  args: {
    title: 'شاورما الشام',
    leading: 'restaurant',
    density: 'compact',
    end: <StatusChip status="ready" label="جاهز" density="compact" />,
  },
};
