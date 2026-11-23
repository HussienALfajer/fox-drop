import type { Meta, StoryObj } from '@storybook/react-vite';
import { Card } from './card';

const content = (
  <>
    <span className="text-phone-subtitle font-medium">برجر كبصو</span>
    <span className="text-phone-secondary text-on-surface-muted">برجر · وجبات سريعة</span>
  </>
);

const meta = {
  title: 'Card',
  component: Card,
  args: { children: content },
} satisfies Meta<typeof Card>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
// The customer app's cards (owner, 2026-11-24).
export const Offset: Story = { args: { elevation: 'offset' } };
export const Hover: Story = { args: { onPress: () => undefined, label: 'برجر كبصو' } };
export const Focus: Story = { args: { onPress: () => undefined, label: 'برجر كبصو' } };
export const Pressed: Story = { args: { onPress: () => undefined, label: 'برجر كبصو' } };
export const Danger: Story = { args: { tone: 'danger' } };
