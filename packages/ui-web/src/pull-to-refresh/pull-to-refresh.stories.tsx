import type { Meta, StoryObj } from '@storybook/react-vite';
import { PullToRefresh } from './pull-to-refresh';

// The Flutter twin's states (D.10, D.11b), review copy. The pull is driven by
// touch pointer events in `play`: half the threshold (the mark half full), and
// a whole pull let go with a refresh that never ends (the drop loader).
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

function touch(target: Element, type: string, y: number) {
  target.dispatchEvent(
    new PointerEvent(type, {
      bubbles: true,
      pointerId: 1,
      pointerType: 'touch',
      isPrimary: true,
      clientY: y,
    }),
  );
}

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
export const Pulling: Story = {
  play: ({ canvasElement }) => {
    const scroller = canvasElement.querySelector('[data-pull-scroller]')!;
    touch(scroller, 'pointerdown', 100);
    touch(scroller, 'pointermove', 140);
  },
};
export const Refreshing: Story = {
  play: ({ canvasElement }) => {
    const scroller = canvasElement.querySelector('[data-pull-scroller]')!;
    touch(scroller, 'pointerdown', 100);
    touch(scroller, 'pointermove', 200);
    touch(scroller, 'pointerup', 200);
  },
};
