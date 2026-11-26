import type { Meta, StoryObj } from '@storybook/react-vite';
import { CountdownRing } from './countdown-ring';

const meta = {
  title: 'CountdownRing',
  component: CountdownRing,
  args: { seconds: 38, total: 45, label: 'ثانية متبقية' },
} satisfies Meta<typeof CountdownRing>;
export default meta;
type Story = StoryObj<typeof meta>;

// The captain's offer, 45 seconds: just offered, then emptying.
export const Full: Story = { args: { seconds: 45 } };
export const Default: Story = {};
export const Half: Story = { args: { seconds: 23 } };
// The last ten seconds turn red.
export const Last: Story = { args: { seconds: 8 } };
