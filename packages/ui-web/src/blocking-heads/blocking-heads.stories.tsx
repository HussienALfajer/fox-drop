import type { Meta, StoryObj } from '@storybook/react-vite';
import { ShopSign as Sign, VersionTicket as Ticket } from './blocking-heads';

// The two heads of the blocking screens share one title, as their Flutter file
// and Design System card do; the args are the Flutter twins' use cases.
const meta = {
  title: 'BlockingHeads',
  component: Ticket,
  args: {
    installedLabel: 'إصدارك',
    installed: '1.0.3',
    requiredLabel: 'الإصدار الجديد',
    required: '1.1.0',
    label: 'إصدارك 1.0.3، والمطلوب 1.1.0 أو أحدث',
  },
} satisfies Meta<typeof Ticket>;
export default meta;
type Story = StoryObj<typeof meta>;

// The forced update (CU §4.2).
export const VersionTicket: Story = {};
// Maintenance (CU §4.7), without and with the return time the panel gave.
export const ShopSign: Story = {
  render: () => <Sign title="نعود قريباً" subtitle="صيانة قصيرة" label="لافتة: نعود قريباً" />,
};
export const ShopSignReturnTime: Story = {
  render: () => (
    <Sign
      title="نعود قريباً"
      subtitle="صيانة قصيرة"
      returnTime="نعود الساعة 3:00 م"
      label="لافتة: نعود قريباً، الساعة 3:00 م"
    />
  ),
};
