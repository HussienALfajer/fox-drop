import type { Meta, StoryObj } from '@storybook/react-vite';
import { PullToRefresh } from './pull-to-refresh';

// The Flutter twin's states (D.10, D.11b), review copy: half the threshold
// pulled (the mark half full), and a refresh that never ends (the drop loader),
// both drawn from props so the components canvas shows them (the audit); the
// gesture itself is tested in pull-to-refresh.test.tsx.
const ROWS = [
  'كنافة أعزاز',
  'برجر كبصو',
  'فطائر الشام',
  'مشاوي حلب',
  'حلويات الشمال',
  'فلافل السوق',
  'بيتزا الريف',
  'عصائر الربيع',
];

const list = (
  <div className="flex flex-col text-phone-body text-on-surface">
    {/* More rows than the frame holds, so the list scrolls (REVIEW item 15). */}
    {ROWS.map((name) => (
      <p key={name} className="m-none p-md">
        {name}
      </p>
    ))}
  </div>
);

const meta = {
  title: 'PullToRefresh',
  component: PullToRefresh,
  decorators: [
    (Story) => (
      <div className="h-(--fd-size-menu-max-height) max-w-(--fd-size-toast)">{Story()}</div>
    ),
  ],
  args: { children: list, refreshLabel: 'تحديث', onRefresh: () => new Promise(() => undefined) },
} satisfies Meta<typeof PullToRefresh>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Pulling: Story = { args: { defaultPulled: 40 } };
export const Refreshing: Story = { args: { defaultRefreshing: true } };
