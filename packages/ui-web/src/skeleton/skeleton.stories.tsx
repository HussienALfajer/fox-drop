import type { Meta, StoryObj } from '@storybook/react-vite';
import { Skeleton } from './skeleton';

const meta = {
  title: 'Skeleton',
  component: Skeleton,
  args: { label: 'جارٍ التحميل', children: null },
} satisfies Meta<typeof Skeleton>;
export default meta;
type Story = StoryObj<typeof meta>;

// A restaurant card's shape: cover, logo and name, a line.
export const Default: Story = {
  args: {
    children: (
      <>
        <Skeleton.Block shape="media" />
        <div className="flex items-center gap-sm">
          <Skeleton.Block shape="square" />
          <div className="flex flex-1 flex-col gap-xs">
            <Skeleton.Block shape="title" />
            <Skeleton.Block />
          </div>
        </div>
      </>
    ),
  },
};
export const ListRows: Story = {
  args: {
    children: (
      <>
        {[1, 2, 3].map((n) => (
          <div key={n} className="flex items-center gap-sm">
            <Skeleton.Block shape="circle" />
            <div className="flex flex-1 flex-col gap-xs">
              <Skeleton.Block shape="title" />
              <Skeleton.Block />
            </div>
          </div>
        ))}
      </>
    ),
  },
};
export const OrderCard: Story = {
  args: {
    children: (
      <>
        <Skeleton.Block shape="title" />
        <Skeleton.Block />
        <Skeleton.Block />
        <Skeleton.Block shape="pill" />
      </>
    ),
  },
};
