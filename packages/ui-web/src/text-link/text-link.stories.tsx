import type { Meta, StoryObj } from '@storybook/react-vite';
import { TextLink } from './text-link';

// One story per state (R3). Hover, Focus and Pressed are the plain link: the
// Playwright gate drives them with the pointer and the keyboard (e2e/).
const meta = {
  title: 'TextLink',
  component: TextLink,
  args: { children: 'تعديل الرقم', onClick: () => {} },
} satisfies Meta<typeof TextLink>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Hover: Story = {};
export const Focus: Story = {};
export const Pressed: Story = {};
