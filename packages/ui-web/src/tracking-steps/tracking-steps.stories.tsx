import type { Meta, StoryObj } from '@storybook/react-vite';
import { TrackingSteps } from './tracking-steps';

const meta = {
  title: 'TrackingSteps',
  component: TrackingSteps,
  args: {
    label: 'حالة الطلب',
    steps: [
      { icon: 'receipt', label: 'استلام' },
      { icon: 'restaurant', label: 'تحضير' },
      { icon: 'motorcycle', label: 'في الطريق' },
      { icon: 'house', label: 'وصل' },
    ],
    current: 2,
    doneLabel: 'تم',
    nowLabel: 'الآن',
  },
} satisfies Meta<typeof TrackingSteps>;
export default meta;
type Story = StoryObj<typeof meta>;

// An order's way (D.11b: the sign-in hero's «طلباتي», the blocking screen's order).
export const First: Story = { args: { current: 0 } };
export const Middle: Story = {};
export const Last: Story = { args: { current: 3 } };
// Every step done.
export const Done: Story = { args: { current: 4 } };
