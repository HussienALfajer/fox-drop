import type { Meta, StoryObj } from '@storybook/react-vite';
import { Money } from '../money/money';
import { DishCard } from './dish-card';

// The Flutter twin's cases (D.9, option A), review copy. Storybook serves no
// photos (see the restaurant card's stories): the photo is in the tests.
const meta = {
  title: 'DishCard',
  component: DishCard,
  decorators: [(Story) => <div className="max-w-(--fd-size-toast)">{Story()}</div>],
  args: {
    name: 'وجبة كريسبي',
    price: <Money amount="12000" symbol="₺" bold />,
    addLabel: 'أضف وجبة كريسبي',
    onAdd: () => undefined,
    href: '#',
  },
} satisfies Meta<typeof DishCard>;
export default meta;
type Story = StoryObj<typeof meta>;

const described = { description: 'قطعتان مع بطاطس ومشروب' };

export const Default: Story = { args: described };
// A required group changes the price: «من» before the lowest.
export const From: Story = { args: { ...described, fromLabel: 'من' } };
export const InCart: Story = { args: { ...described, fromLabel: 'من', count: 2 } };
export const NoPhoto: Story = {
  args: {
    name: 'كوب عيران',
    description: 'مقاس كبير',
    price: <Money amount="2500" symbol="₺" bold />,
    addLabel: 'أضف كوب عيران',
  },
};
export const Unavailable: Story = {
  args: {
    name: 'فطور شامي',
    price: <Money amount="9000" symbol="₺" bold />,
    unavailableLabel: 'يتوفر غداً',
  },
};
export const Hover: Story = { args: described };
export const Focus: Story = { args: described };
export const Pressed: Story = { args: described };
