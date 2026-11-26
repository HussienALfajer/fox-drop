import type { Meta, StoryObj } from '@storybook/react-vite';
import type { ReactNode } from 'react';
import { TrackingSteps } from '../tracking-steps/tracking-steps';
import { SignInHero, type SignInOrigin } from './sign-in-hero';

// The tracking steps on the sample order, as the Flutter twin's use case.
const steps = (
  <TrackingSteps
    label="مراحل الطلب"
    steps={[
      { icon: 'receipt', label: 'استلام' },
      { icon: 'restaurant', label: 'تحضير' },
      { icon: 'motorcycle', label: 'في الطريق' },
      { icon: 'house', label: 'وصل' },
    ]}
    current={2}
    doneLabel="تم"
    nowLabel="الآن"
  />
);

// The three origins, as the sign-in screen passes them (the Flutter twin's use cases).
const origins: Record<'checkout' | 'orders' | 'account', SignInOrigin> = {
  checkout: {
    kind: 'checkout',
    restaurant: 'مطعم الشام',
    details: '3 أصناف · إلى حي الجلاء',
    amount: '18500',
    symbol: '₺',
    savedLabel: 'سلّتك محفوظة كما هي',
  },
  orders: { kind: 'orders', title: 'هكذا تتابع طلبك', statusLabel: 'في الطريق إليك', steps },
  account: {
    kind: 'account',
    perks: [
      { icon: 'drop-pin', label: 'عناوينك' },
      { icon: 'discount', label: 'أكوادك' },
      { icon: 'heart', label: 'مفضّلتك' },
    ],
  },
};

const words = {
  checkout: ['سجّل دخولك لتكمل طلبك', 'سلّتك محفوظة. أدخل رقمك لنرسل لك رمز الدخول على واتساب.'],
  orders: ['تابع طلبك لحظة بلحظة', 'أدخل رقمك لترى طلباتك الجارية والسابقة.'],
  account: ['حسابك يحفظ لك كل شيء', 'أدخل رقمك لتحفظ عناوينك وأكوادك ومفضّلتك.'],
} as const;

// The height the sign-in screen gives the hero; `short` is what is left on a
// small phone.
const frame = (children: ReactNode, short = false) => (
  <div className={short ? 'h-(--fd-size-tooltip)' : 'h-(--fd-size-dialog)'}>{children}</div>
);

const meta = {
  title: 'SignInHero',
  component: SignInHero,
  args: { origin: origins.checkout, title: words.checkout[0], lead: words.checkout[1] },
  render: (args) => frame(<SignInHero {...args} />),
} satisfies Meta<typeof SignInHero>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Checkout: Story = {};
export const Orders: Story = {
  args: { origin: origins.orders, title: words.orders[0], lead: words.orders[1] },
};
export const Account: Story = {
  args: { origin: origins.account, title: words.account[0], lead: words.account[1] },
};
// A small phone: the lead gives way, then the illustration.
export const Short: Story = { render: (args) => frame(<SignInHero {...args} />, true) };
// The keyboard is up: the title alone.
export const Keyboard: Story = {
  args: { keyboard: true },
  render: (args) => frame(<SignInHero {...args} />, true),
};
