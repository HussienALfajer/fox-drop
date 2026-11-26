import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { BottomSheet } from './bottom-sheet/bottom-sheet';
import { Button } from './button/button';
import { DishCard } from './dish-card/dish-card';
import { PullToRefresh } from './pull-to-refresh/pull-to-refresh';
import { RestaurantCard } from './restaurant-card/restaurant-card';

// The web versions of the Flutter-only restaurant and dish cards, bottom sheet
// and pull to refresh (D.W4c), against their approved twins (D.9, D.10, D.11b).

const restaurant = {
  name: 'برجر كبصو',
  categories: 'برجر · وجبات سريعة',
  eta: '20–30 د',
  fee: 'توصيل مجاني',
  href: '/restaurants/kabsu',
  favourite: false,
  favouriteLabel: 'المفضلة',
  onFavourite: () => undefined,
};

describe('RestaurantCard', () => {
  it('is one link named by the restaurant, with the heart its own button', () => {
    render(<RestaurantCard {...restaurant} rating="4.5" />);
    expect(screen.getAllByRole('link')).toHaveLength(1);
    expect(screen.getByRole('link', { name: 'برجر كبصو' })).toHaveAttribute(
      'href',
      '/restaurants/kabsu',
    );
    expect(screen.getByRole('button', { name: 'المفضلة' })).toHaveAttribute(
      'aria-pressed',
      'false',
    );
  });

  it('reads its state with its name when it is not open', () => {
    render(
      <RestaurantCard
        {...restaurant}
        closed
        state={{ label: 'مغلق — يفتح السبت 10:00 ص', tone: 'neutral' }}
      />,
    );
    expect(
      screen.getByRole('link', { name: 'برجر كبصو، مغلق — يفتح السبت 10:00 ص' }),
    ).toBeInTheDocument();
  });

  it('marks a favourite as pressed and calls onFavourite without following the link', async () => {
    const onFavourite = vi.fn();
    render(<RestaurantCard {...restaurant} favourite onFavourite={onFavourite} />);
    const heart = screen.getByRole('button', { name: 'المفضلة' });
    expect(heart).toHaveAttribute('aria-pressed', 'true');
    await userEvent.click(heart);
    expect(onFavourite).toHaveBeenCalledTimes(1);
  });

  it('shows the logo on a tint when the cover fails to load (R7)', () => {
    const { container } = render(<RestaurantCard {...restaurant} cover="/broken.jpg" />);
    const cover = container.querySelector('img');
    expect(cover).not.toBeNull();
    fireEvent.error(cover!);
    expect(container.querySelector('img')).toBeNull();
    expect(container.querySelector('[data-cover-fallback]')).toHaveTextContent('ب');
  });

  it('shows «جديد» without a rating', () => {
    render(<RestaurantCard {...restaurant} newLabel="جديد" />);
    expect(screen.getByText('جديد')).toBeInTheDocument();
  });
});

const dish = {
  name: 'شاورما دجاج',
  price: '25,000 ل.س',
  addLabel: 'أضف شاورما دجاج',
  onAdd: () => undefined,
  href: '/dishes/7',
};

describe('DishCard', () => {
  it('is one link named by the dish, with «+» its own button', async () => {
    const onAdd = vi.fn();
    render(<DishCard {...dish} onAdd={onAdd} description="بالثوم والمخلل" />);
    expect(screen.getAllByRole('link')).toHaveLength(1);
    expect(screen.getByRole('link', { name: 'شاورما دجاج' })).toHaveAttribute('href', '/dishes/7');
    await userEvent.click(screen.getByRole('button', { name: 'أضف شاورما دجاج' }));
    expect(onAdd).toHaveBeenCalledTimes(1);
  });

  it('reads the count in the cart on «+», in Western digits', () => {
    render(<DishCard {...dish} count={2} />);
    const add = screen.getByRole('button', { name: 'أضف شاورما دجاج، 2' });
    expect(add).toHaveTextContent('2');
    expect(add.textContent).not.toMatch(/[٠-٩]/);
  });

  it('is no link and has no «+» when unavailable, and reads its reason', () => {
    render(<DishCard {...dish} unavailableLabel="يتوفر غداً" />);
    expect(screen.queryByRole('link')).toBeNull();
    expect(screen.queryByRole('button')).toBeNull();
    expect(screen.getByRole('article', { name: 'شاورما دجاج، يتوفر غداً' })).toHaveTextContent(
      'يتوفر غداً',
    );
  });

  it('has no image slot without a photo, and drops a photo that fails', () => {
    const { container, rerender } = render(<DishCard {...dish} />);
    expect(container.querySelector('img')).toBeNull();
    rerender(<DishCard {...dish} photo="/broken.jpg" />);
    fireEvent.error(container.querySelector('img')!);
    expect(container.querySelector('img')).toBeNull();
  });
});

const sheet = { title: 'شاورما دجاج', closeLabel: 'إغلاق' };

describe('BottomSheet', () => {
  it('opens as a dialog named by its title, traps focus, closes on Escape and gives focus back', async () => {
    render(
      <BottomSheet {...sheet} trigger={<Button>اختر</Button>}>
        <Button>أضف إلى السلة</Button>
      </BottomSheet>,
    );
    const trigger = screen.getByRole('button', { name: 'اختر' });
    await userEvent.click(trigger);
    const dialog = await screen.findByRole('dialog', { name: 'شاورما دجاج' });
    await waitFor(() => expect(dialog.contains(document.activeElement)).toBe(true));
    for (let i = 0; i < 4; i++) {
      await userEvent.tab();
      expect(dialog.contains(document.activeElement)).toBe(true);
    }
    await userEvent.keyboard('{Escape}');
    await waitFor(() => expect(screen.queryByRole('dialog')).toBeNull());
    await waitFor(() => expect(trigger).toHaveFocus());
  });

  it('closes with its ×', async () => {
    render(
      <BottomSheet {...sheet} trigger={<Button>اختر</Button>}>
        <p>بالثوم</p>
      </BottomSheet>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'اختر' }));
    const dialog = await screen.findByRole('dialog');
    await userEvent.click(within(dialog).getByRole('button', { name: 'إغلاق' }));
    await waitFor(() => expect(screen.queryByRole('dialog')).toBeNull());
  });

  it('draws the S-curve tab with the title and a handle, and no ×', async () => {
    render(
      <BottomSheet {...sheet} sCurve trigger={<Button>اختر</Button>}>
        <p>بالثوم</p>
      </BottomSheet>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'اختر' }));
    const dialog = await screen.findByRole('dialog', { name: 'شاورما دجاج' });
    expect(dialog.querySelector('[data-s-curve]')).not.toBeNull();
    expect(dialog.querySelector('[data-handle]')).not.toBeNull();
    expect(within(dialog).queryByRole('button', { name: 'إغلاق' })).toBeNull();
  });
});

function list() {
  return (
    <ul>
      <li>برجر كبصو</li>
      <li>كنافة أعزاز</li>
    </ul>
  );
}

function pull(target: Element, pointerType: string, distance: number) {
  fireEvent.pointerDown(target, { pointerId: 1, pointerType, clientY: 100, isPrimary: true });
  fireEvent.pointerMove(target, {
    pointerId: 1,
    pointerType,
    clientY: 100 + distance,
    isPrimary: true,
  });
  fireEvent.pointerUp(target, {
    pointerId: 1,
    pointerType,
    clientY: 100 + distance,
    isPrimary: true,
  });
}

describe('PullToRefresh', () => {
  it('calls its action once per pull past the threshold on touch', async () => {
    const onRefresh = vi.fn(() => Promise.resolve());
    render(
      <PullToRefresh onRefresh={onRefresh} refreshLabel="تحديث">
        {list()}
      </PullToRefresh>,
    );
    const scroller = screen.getByText('برجر كبصو').closest('[data-pull-scroller]')!;
    await act(async () => pull(scroller, 'touch', 200));
    expect(onRefresh).toHaveBeenCalledTimes(1);
    await act(async () => pull(scroller, 'touch', 20));
    expect(onRefresh).toHaveBeenCalledTimes(1);
    await act(async () => pull(scroller, 'touch', 200));
    expect(onRefresh).toHaveBeenCalledTimes(2);
  });

  it('never refreshes on a mouse drag', async () => {
    const onRefresh = vi.fn();
    render(
      <PullToRefresh onRefresh={onRefresh} refreshLabel="تحديث">
        {list()}
      </PullToRefresh>,
    );
    const scroller = screen.getByText('برجر كبصو').closest('[data-pull-scroller]')!;
    await act(async () => pull(scroller, 'mouse', 300));
    expect(onRefresh).not.toHaveBeenCalled();
  });

  it('ignores a second pull while a refresh runs', async () => {
    let finish = () => undefined as void;
    const onRefresh = vi.fn(
      () =>
        new Promise<void>((resolve) => {
          finish = resolve;
        }),
    );
    render(
      <PullToRefresh onRefresh={onRefresh} refreshLabel="تحديث">
        {list()}
      </PullToRefresh>,
    );
    const scroller = screen.getByText('برجر كبصو').closest('[data-pull-scroller]')!;
    await act(async () => pull(scroller, 'touch', 200));
    await act(async () => pull(scroller, 'touch', 200));
    expect(onRefresh).toHaveBeenCalledTimes(1);
    await act(async () => finish());
  });

  it('shows the drop loader while refreshing, still under reduced motion', async () => {
    const onRefresh = () => new Promise<void>(() => undefined);
    const { container } = render(
      <PullToRefresh onRefresh={onRefresh} refreshLabel="تحديث">
        {list()}
      </PullToRefresh>,
    );
    const scroller = screen.getByText('برجر كبصو').closest('[data-pull-scroller]')!;
    await act(async () => pull(scroller, 'touch', 200));
    const loader = container.querySelector('[data-drop-loader]');
    expect(loader).not.toBeNull();
    // Every moving part of the loader animates only when motion is allowed.
    const animated = [...loader!.querySelectorAll('[class*="animate-"]')];
    expect(animated.length).toBeGreaterThan(0);
    for (const part of animated)
      for (const name of part.getAttribute('class')!.split(/\s+/))
        if (name.includes('animate-')) expect(name).toMatch(/^motion-safe:/);
  });

  it('gives screen readers and keyboards a refresh button', async () => {
    const onRefresh = vi.fn();
    render(
      <PullToRefresh onRefresh={onRefresh} refreshLabel="تحديث">
        {list()}
      </PullToRefresh>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'تحديث' }));
    expect(onRefresh).toHaveBeenCalledTimes(1);
  });
});
