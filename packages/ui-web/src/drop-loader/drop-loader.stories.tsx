import type { Meta, StoryObj } from '@storybook/react-vite';
import { DropLoader } from './drop-loader';

const meta = {
  title: 'DropLoader',
  component: DropLoader,
} satisfies Meta<typeof DropLoader>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
// On the orange ground, as inside the primary button.
export const OnPrimary: Story = {
  args: { onPrimary: true },
  decorators: [
    (Story) => (
      <div className="inline-flex rounded-md bg-primary p-sm">
        <Story />
      </div>
    ),
  ],
};
export const Small: Story = { args: { size: 'sm' } };
export const Large: Story = { args: { size: 'lg' } };
export const Labelled: Story = { args: { size: 'lg', label: 'جارٍ التحميل' } };
