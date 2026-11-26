import type { Meta, StoryObj } from '@storybook/react-vite';
import { StatusChip } from '../status-chip/status-chip';
import { RestaurantBar } from './restaurant-bar';

const meta = {
  title: 'RestaurantBar',
  component: RestaurantBar,
  args: {
    name: 'برجر كبصو',
    status: <StatusChip tone="success" label="مفتوح" />,
    connected: true,
    connectionLabel: 'متصل',
    supportLabel: 'الدعم',
    onSupport: () => undefined,
  },
} satisfies Meta<typeof RestaurantBar>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Connected: Story = {};
// The connection dropped: the dot and its words turn red.
export const Offline: Story = { args: { connected: false, connectionLabel: 'غير متصل' } };
