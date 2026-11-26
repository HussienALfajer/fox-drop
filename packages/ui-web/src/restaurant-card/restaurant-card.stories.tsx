import type { Meta, StoryObj } from '@storybook/react-vite';
import { Money } from '../money/money';
import { RestaurantCard } from './restaurant-card';

// The Flutter twin's cases (D.9), review copy. Storybook serves no photos
// (no image asset, and the CSP forbids data URLs): every card shows the logo
// fallback of R7; the cover itself is in the tests.
const meta = {
  title: 'RestaurantCard',
  component: RestaurantCard,
  decorators: [(Story) => <div className="max-w-(--fd-size-toast)">{Story()}</div>],
  args: {
    name: 'كنافة أعزاز',
    categories: 'حلويات · مشروبات',
    eta: '20–30 د',
    fee: <Money amount="1000" symbol="₺" size="secondary" />,
    href: '#',
    favourite: false,
    favouriteLabel: 'المفضلة',
    onFavourite: () => undefined,
  },
} satisfies Meta<typeof RestaurantCard>;
export default meta;
type Story = StoryObj<typeof meta>;

const rated = { rating: '4.8' };

export const Default: Story = { args: rated };
export const Busy: Story = { args: { ...rated, state: { label: 'مشغول', tone: 'warning' } } };
// U6: faded, the state chip and the heart at full contrast.
export const Closed: Story = {
  args: {
    ...rated,
    closed: true,
    favourite: true,
    state: { label: 'مغلق — يفتح السبت 10:00 ص', tone: 'neutral' },
  },
};
// A restaurant at the edge of its coverage: a long estimate and a higher fee.
export const Far: Story = {
  args: { ...rated, eta: '50–60 د', fee: <Money amount="4500" symbol="₺" size="secondary" /> },
};
// A new restaurant with no photos yet: the first letter on the tint, «جديد».
export const NoCover: Story = {
  args: { name: 'برجر كبصو', categories: 'برجر', newLabel: 'جديد', fee: 'توصيل مجاني' },
};
export const Favourite: Story = { args: { ...rated, favourite: true } };
export const Hover: Story = { args: rated };
export const Focus: Story = { args: rated };
export const Pressed: Story = { args: rated };
