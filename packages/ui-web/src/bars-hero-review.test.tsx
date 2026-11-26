import { fireEvent, render, screen, within } from '@testing-library/react';
import { describe, expect, it, vi } from 'vitest';
import { ShopSign, VersionTicket } from './blocking-heads/blocking-heads';
import { BottomNavigation } from './bottom-navigation/bottom-navigation';
import { RestaurantBar } from './restaurant-bar/restaurant-bar';
import { SignInHero } from './sign-in-hero/sign-in-hero';
import { StatusChip } from './status-chip/status-chip';

// The web versions of the Flutter-only restaurant bar, bottom navigation,
// sign-in hero and blocking heads (D.W4d), against their approved twins
// (D.10, D.11, D.11b).

const items = [
  { icon: 'home' as const, label: 'الرئيسية' },
  { icon: 'search' as const, label: 'البحث' },
  { icon: 'orders' as const, label: 'طلباتي', count: 1, countLabel: '1 جديد' },
  { icon: 'account' as const, label: 'حسابي' },
];

describe('BottomNavigation', () => {
  const bar = (selected = 0, onSelect = vi.fn()) =>
    render(
      <div dir="rtl">
        <BottomNavigation label="التنقل" items={items} selected={selected} onSelect={onSelect} />
      </div>,
    );

  it('is a named nav with one current item', () => {
    bar(2);
    const nav = screen.getByRole('navigation', { name: 'التنقل' });
    const current = within(nav)
      .getAllByRole('button')
      .filter((button) => button.getAttribute('aria-current') === 'page');
    expect(current).toHaveLength(1);
    expect(current[0]).toHaveAccessibleName(/طلباتي/);
  });

  it('names each icon-only item, its badge read with it', () => {
    bar();
    for (const name of ['الرئيسية', 'البحث', 'حسابي'])
      expect(screen.getByRole('button', { name })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /طلباتي.*1 جديد/ })).toBeInTheDocument();
  });

  it('a dot item is named by its words, never the dot alone', () => {
    render(
      <BottomNavigation
        label="التنقل"
        items={[
          { icon: 'home', label: 'الرئيسية' },
          { icon: 'cash', label: 'عهدتي', dot: true, countLabel: 'جديد' },
        ]}
        selected={0}
        onSelect={() => undefined}
      />,
    );
    expect(screen.getByRole('button', { name: /عهدتي.*جديد/ })).toBeInTheDocument();
  });

  it('picks an item on press', () => {
    const onSelect = vi.fn();
    bar(0, onSelect);
    fireEvent.click(screen.getByRole('button', { name: 'البحث' }));
    expect(onSelect).toHaveBeenCalledWith(1);
  });

  it('moves focus with the arrows in RTL: left is the next item', () => {
    bar();
    const buttons = screen.getAllByRole('button');
    buttons[0]!.focus();
    fireEvent.keyDown(buttons[0]!, { key: 'ArrowLeft' });
    expect(buttons[1]).toHaveFocus();
    fireEvent.keyDown(buttons[1]!, { key: 'ArrowRight' });
    expect(buttons[0]).toHaveFocus();
    fireEvent.keyDown(buttons[0]!, { key: 'End' });
    expect(buttons[3]).toHaveFocus();
    fireEvent.keyDown(buttons[3]!, { key: 'Home' });
    expect(buttons[0]).toHaveFocus();
  });
});

describe('RestaurantBar', () => {
  const restaurantBar = (connected: boolean) =>
    render(
      <RestaurantBar
        name="برجر كبصو"
        status={<StatusChip tone="success" label="مفتوح" />}
        connected={connected}
        connectionLabel={connected ? 'متصل' : 'غير متصل'}
        supportLabel="الدعم"
        onSupport={() => undefined}
      />,
    );

  it('names the restaurant as a heading and shows its status', () => {
    restaurantBar(true);
    expect(screen.getByRole('heading', { name: 'برجر كبصو' })).toBeInTheDocument();
    expect(screen.getByText('مفتوح')).toBeInTheDocument();
  });

  it('says the connection in words in a live status, never colour alone', () => {
    const { unmount } = restaurantBar(true);
    expect(screen.getByRole('status')).toHaveTextContent('متصل');
    unmount();
    restaurantBar(false);
    expect(screen.getByRole('status')).toHaveTextContent('غير متصل');
  });

  it('has a named support button', () => {
    restaurantBar(true);
    expect(screen.getByRole('button', { name: 'الدعم' })).toBeInTheDocument();
  });
});

describe('SignInHero', () => {
  const checkout = {
    kind: 'checkout' as const,
    restaurant: 'مطعم الشام',
    details: '3 أصناف · إلى حي الجلاء',
    amount: '18500',
    symbol: '₺',
    savedLabel: 'سلّتك محفوظة كما هي',
  };

  it.each([
    ['checkout', checkout, 'سجّل دخولك لتكمل طلبك'],
    [
      'orders',
      {
        kind: 'orders' as const,
        title: 'هكذا تتابع طلبك',
        statusLabel: 'في الطريق إليك',
        steps: null,
      },
      'تابع طلبك لحظة بلحظة',
    ],
    [
      'account',
      {
        kind: 'account' as const,
        perks: [
          { icon: 'drop-pin' as const, label: 'عناوينك' },
          { icon: 'discount' as const, label: 'أكوادك' },
        ],
      },
      'حسابك يحفظ لك كل شيء',
    ],
  ])('shows the title of the %s origin as the heading', (_, origin, title) => {
    render(<SignInHero origin={origin} title={title} lead="أدخل رقمك." />);
    expect(screen.getByRole('heading', { level: 1, name: title })).toBeInTheDocument();
    expect(screen.getByText('أدخل رقمك.')).toBeInTheDocument();
  });

  it('keeps the illustration from screen readers: the words say it', () => {
    render(<SignInHero origin={checkout} title="سجّل دخولك" />);
    expect(screen.queryByText('مطعم الشام')).not.toBeNull();
    expect(screen.getByText('مطعم الشام').closest('[aria-hidden="true"]')).not.toBeNull();
  });

  it('is the title alone while the keyboard is up', () => {
    render(<SignInHero origin={checkout} title="سجّل دخولك" lead="أدخل رقمك." keyboard />);
    expect(screen.getByRole('heading', { name: 'سجّل دخولك' })).toBeInTheDocument();
    expect(screen.queryByText('أدخل رقمك.')).toBeNull();
    expect(screen.queryByText('مطعم الشام')).toBeNull();
  });

  it('shows the cart total in Western digits', () => {
    render(<SignInHero origin={checkout} title="سجّل دخولك" />);
    expect(screen.getByText(/185/)).toBeInTheDocument();
    expect(document.body.textContent).not.toMatch(/[٠-٩]/);
  });
});

describe('the blocking heads', () => {
  it('the version ticket is one image named by its words, versions left to right', () => {
    render(
      <VersionTicket
        installedLabel="إصدارك"
        installed="1.0.3"
        requiredLabel="الإصدار الجديد"
        required="1.1.0"
        label="إصدارك 1.0.3، والمطلوب 1.1.0 أو أحدث"
      />,
    );
    const image = screen.getByRole('img', { name: 'إصدارك 1.0.3، والمطلوب 1.1.0 أو أحدث' });
    expect(within(image).getByText('1.1.0')).toHaveAttribute('dir', 'ltr');
    expect(within(image).getByText('1.0.3')).toHaveAttribute('dir', 'ltr');
  });

  it('the shop sign reads its message and the return time in Western digits', () => {
    render(
      <ShopSign
        title="نعود قريباً"
        subtitle="صيانة قصيرة"
        returnTime="نعود الساعة 3:00 م"
        label="لافتة: نعود قريباً، الساعة 3:00 م"
      />,
    );
    const image = screen.getByRole('img', { name: 'لافتة: نعود قريباً، الساعة 3:00 م' });
    expect(within(image).getByText('نعود الساعة 3:00 م')).toBeInTheDocument();
    expect(image.textContent).not.toMatch(/[٠-٩]/);
  });

  it('the shop sign shows no return time when none was given', () => {
    render(<ShopSign title="نعود قريباً" subtitle="صيانة قصيرة" label="لافتة: نعود قريباً" />);
    expect(screen.queryByText(/الساعة/)).toBeNull();
  });
});
