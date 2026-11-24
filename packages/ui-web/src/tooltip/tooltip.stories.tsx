import type { Meta, StoryObj } from '@storybook/react-vite';
import { CountBadge } from '../count-badge/count-badge';
import { Icon } from '../icon/icon';
import { Tooltip } from './tooltip';

const bell = (
  <button
    type="button"
    className="inline-flex size-(--fd-size-control-compact) items-center justify-center rounded-full bg-surface-raised text-on-surface inset-ring-1 inset-ring-border"
  >
    <span className="sr-only">التنبيهات</span>
    <CountBadge count={4} label="4 مفتوحة">
      <Icon name="bell" />
    </CountBadge>
  </button>
);

const meta = {
  title: 'Tooltip',
  component: Tooltip,
  args: { content: 'التنبيهات المفتوحة: 4', children: bell },
  decorators: [(Story) => <div className="p-2xl">{Story()}</div>],
} satisfies Meta<typeof Tooltip>;
export default meta;
type Story = StoryObj<typeof meta>;

const focus: Story['play'] = ({ canvasElement }) => {
  canvasElement.querySelector<HTMLElement>('button, a')?.focus();
};

export const Default: Story = {};
export const Open: Story = { play: focus };
// The collapsed sidebar keeps each name in its tooltip.
export const Sidebar: Story = {
  args: {
    content: 'غرفة العمليات',
    side: 'start',
    children: (
      <a
        href="#operations"
        aria-label="غرفة العمليات"
        className="inline-flex size-(--fd-size-touch-target) items-center justify-center rounded-md bg-primary-subtle text-on-primary-subtle"
      >
        <Icon name="orders" size="sm" />
      </a>
    ),
  },
  play: focus,
};
