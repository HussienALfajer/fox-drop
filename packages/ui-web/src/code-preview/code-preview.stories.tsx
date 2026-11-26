import type { Meta, StoryObj } from '@storybook/react-vite';
import { CodePreview } from './code-preview';

const meta = {
  title: 'CodePreview',
  component: CodePreview,
  args: {
    sender: 'FOX DROP',
    message: 'رمز الدخول إلى FOX DROP:',
    time: 'الآن · واتساب',
    label: 'ستصلك رسالة على واتساب من FOX DROP فيها رمز الدخول',
  },
} satisfies Meta<typeof CodePreview>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Full: Story = {};
// The keyboard is up: the sender line goes.
export const Compact: Story = { args: { compact: true } };
