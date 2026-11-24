import type { Meta, StoryObj } from '@storybook/react-vite';
import { BlockingBanner } from './blocking-banner';

// AP §7.3: after sign-in, until the panel may play sound.
const meta = {
  title: 'BlockingBanner',
  component: BlockingBanner,
  args: {
    open: true,
    text: 'اضغط لتفعيل صوت التنبيهات',
    actionLabel: 'تفعيل الصوت',
    onEnable: () => undefined,
  },
  // The page it blocks: the banner itself sits in the top layer.
  decorators: [
    (Story) => (
      <div className="p-lg pt-3xl text-panel-body text-on-surface">
        <p className="m-none">غرفة العمليات</p>
        {Story()}
      </div>
    ),
  ],
} satisfies Meta<typeof BlockingBanner>;
export default meta;
type Story = StoryObj<typeof meta>;

// It opens with the page by design: it blocks the page until sound plays.
export const Default: Story = {};
