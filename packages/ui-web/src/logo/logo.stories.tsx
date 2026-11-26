import type { Meta, StoryObj } from '@storybook/react-vite';
import { Logo } from './logo';

const meta = {
  title: 'Logo',
  component: Logo,
  args: { name: 'فطائر الريف' },
} satisfies Meta<typeof Logo>;
export default meta;
type Story = StoryObj<typeof meta>;

// No logo yet: the name's first letter on the tint.
export const Letter: Story = {};
export const LatinLetter: Story = { args: { name: 'pizza roma' } };
