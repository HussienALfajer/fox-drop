import type { Meta, StoryObj } from '@storybook/react-vite';
import { Button } from '../button/button';
import { Money } from '../money/money';
import { StatusChip } from '../status-chip/status-chip';
import { OrderRow } from './order-row';

const meta = {
  title: 'OrderRow',
  component: OrderRow,
  args: {
    restaurant: 'برجر كبصو',
    date: 'اليوم · 9:45 م',
    status: <StatusChip status="picked_up" label="في الطريق إليك" />,
    total: <Money amount="47000" symbol="₺" bold />,
    onPress: () => undefined,
  },
} satisfies Meta<typeof OrderRow>;
export default meta;
type Story = StoryObj<typeof meta>;

// The customer's «طلباتي» (CU §12.3): an order on its way.
export const Active: Story = {};
export const Past: Story = {
  args: {
    date: '21/11/2026',
    status: <StatusChip status="delivered" label="تم التسليم" />,
    trailing: (
      <Button variant="ghost" onClick={() => undefined}>
        اطلب مرة أخرى
      </Button>
    ),
  },
};
export const Cancelled: Story = {
  args: {
    date: '21/11/2026',
    status: <StatusChip status="cancelled" label="أُلغي الطلب" />,
  },
};
