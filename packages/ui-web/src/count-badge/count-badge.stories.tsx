import type { Meta, StoryObj } from '@storybook/react-vite';
import { Icon } from '../icon/icon';
import { CountBadge } from './count-badge';

const meta = {
  title: 'CountBadge',
  component: CountBadge,
  args: { count: 3, label: '3 إشعارات', children: <Icon name="bell" /> },
} satisfies Meta<typeof CountBadge>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Dot: Story = { args: { count: undefined, label: 'إشعارات جديدة' } };
export const Capped: Story = { args: { count: 120, label: '120 إشعاراً' } };
// The cart's count in the brand orange (R4 exception).
export const Primary: Story = {
  args: { count: 12, label: '12 صنفاً في السلة', tone: 'primary', children: <Icon name="cart" /> },
};
// In a tab of the restaurant's board: no child, inline.
export const Inline: Story = {
  args: { count: 4, label: '4 طلبات جديدة', tone: 'accent', children: undefined },
};
