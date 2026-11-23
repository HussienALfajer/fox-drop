import type { Meta, StoryObj } from '@storybook/react-vite';
import { StatusChip } from '../status-chip/status-chip';
import { Timer } from '../timer/timer';
import { OrderCard } from './order-card';

const meta = {
  title: 'OrderCard',
  component: OrderCard,
  args: {
    label: 'طلب #10423',
    number: '10423',
    since: 'منذ 1 د',
    items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
    captain: 'بانتظار كابتن',
    timer: <Timer seconds={272} direction="down" minuteUnit="د" />,
  },
} satisfies Meta<typeof OrderCard>;
export default meta;
type Story = StoryObj<typeof meta>;

// A new order with its auto-cancel countdown.
export const Default: Story = { args: { action: { label: 'قبول', onPress: () => undefined } } };
export const Preparing: Story = {
  args: {
    label: 'طلب #10419',
    number: '10419',
    since: 'منذ 9 د',
    items: '2 أصناف · برجر كبصو، كوب عيران',
    captain: 'الكابتن أحمد في الطريق — يصل خلال 4 د',
    timer: <Timer seconds={360} direction="down" minuteUnit="د" />,
    badges: <StatusChip tone="warning" icon="warning" label="صنف نفد — بانتظار العمليات" />,
    action: { label: 'الطلب جاهز', onPress: () => undefined },
  },
};
export const Late: Story = {
  args: {
    label: 'طلب #10412',
    number: '10412',
    since: 'منذ 24 د',
    items: '5 أصناف · وجبة عائلية…',
    captain: 'وصل الكابتن — ينتظر منذ 3 د',
    timer: <Timer seconds={240} direction="up" late prefix="متأخر" minuteUnit="د" />,
    late: true,
    lateLabel: 'متأخر',
    action: { label: 'الطلب جاهز', onPress: () => undefined },
  },
};
// The owner's portal shows live orders read-only (RA R15).
export const ReadOnly: Story = {};
