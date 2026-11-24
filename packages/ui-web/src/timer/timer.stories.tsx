import type { Meta, StoryObj } from '@storybook/react-vite';
import { Timer } from './timer';

const meta = {
  title: 'Timer',
  component: Timer,
  args: { seconds: 272, direction: 'down', minuteUnit: 'د' },
} satisfies Meta<typeof Timer>;
export default meta;
type Story = StoryObj<typeof meta>;

// The auto-cancel countdown of a new order.
export const Default: Story = {};
export const Soon: Story = { args: { seconds: 48 } };
export const Minutes: Story = { args: { seconds: 1080 } };
export const Late: Story = { args: { seconds: 180, direction: 'up', late: true, prefix: 'متأخر' } };
export const Waiting: Story = {
  args: { seconds: 240, direction: 'up', tone: 'soon', prefix: 'ينتظر منذ', icon: 'motorcycle' },
};
export const Compact: Story = { args: { seconds: 725, density: 'compact' } };
