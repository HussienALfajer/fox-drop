import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { CountdownRing } from './countdown-ring/countdown-ring';
import { Logo, logoInitial } from './logo/logo';
import { OrderRow } from './order-row/order-row';
import { TrackingSteps } from './tracking-steps/tracking-steps';

// Slice D.W4b: the web versions of the captain's ring, the customer's order
// row, the restaurant logo and the tracking steps (architecture §9.5 R4, R5).
describe('countdown ring', () => {
  it('reads the seconds left aloud, in Western digits', () => {
    render(<CountdownRing seconds={38} total={45} label="ثانية متبقية" />);
    const ring = screen.getByRole('timer', { name: '38 ثانية متبقية' });
    expect(ring).toHaveTextContent(/^38$/);
  });

  it('turns to its last seconds at 10 and stays full at the start', () => {
    const { rerender } = render(<CountdownRing seconds={45} total={45} label="ثانية متبقية" />);
    expect(screen.getByRole('timer')).not.toHaveAttribute('data-last');
    rerender(<CountdownRing seconds={10} total={45} label="ثانية متبقية" />);
    expect(screen.getByRole('timer')).toHaveAttribute('data-last', '');
  });

  it('empties its arc by the share left and keeps it still under reduced motion', () => {
    const { container } = render(<CountdownRing seconds={9} total={36} label="ثانية متبقية" />);
    const arc = container.querySelector('[data-part="arc"]')!;
    expect(arc).toHaveAttribute('stroke-dasharray', '25 100');
    // The sweep between two ticks is a transition only when motion is allowed.
    const classes = arc.getAttribute('class')!.split(/\s+/);
    expect(classes.some((name) => name.startsWith('motion-safe:transition'))).toBe(true);
    expect(classes.some((name) => name.startsWith('transition'))).toBe(false);
  });
});

describe('logo', () => {
  it('stands in with the first letter of an Arabic and a Latin name', () => {
    expect(logoInitial('برجر كبصو')).toBe('ب');
    expect(logoInitial(' pizza roma')).toBe('P');
    expect(logoInitial('')).toBe('');
    const { container } = render(<Logo name="شاورما الشام" />);
    expect(container).toHaveTextContent('ش');
  });

  it('is decoration beside the name: an empty alternative text, hidden letters', () => {
    const { container, rerender } = render(<Logo name="برجر كبصو" src="/logo.png" />);
    expect(container.querySelector('img')).toHaveAttribute('alt', '');
    rerender(<Logo name="برجر كبصو" />);
    expect(container.firstElementChild).toHaveAttribute('aria-hidden', 'true');
  });
});

describe('order row', () => {
  const row = {
    restaurant: 'برجر كبصو',
    date: 'اليوم · 9:45 م',
    status: <span>مع الكابتن</span>,
    total: <span>470 ₺</span>,
  };

  it('is named by its restaurant and date for assistive technology', () => {
    render(<OrderRow {...row} />);
    const article = screen.getByRole('article', { name: 'برجر كبصو، اليوم · 9:45 م' });
    expect(within(article).getByText('مع الكابتن')).toBeInTheDocument();
    expect(within(article).getByText('470 ₺')).toBeInTheDocument();
  });

  it('opens by its restaurant, and its reorder action stays apart', async () => {
    const onPress = vi.fn();
    const reorder = vi.fn();
    render(
      <OrderRow
        {...row}
        onPress={onPress}
        trailing={
          <button type="button" onClick={reorder}>
            اطلب مرة أخرى
          </button>
        }
      />,
    );
    await userEvent.click(screen.getByRole('button', { name: 'اطلب مرة أخرى' }));
    expect(reorder).toHaveBeenCalledOnce();
    expect(onPress).not.toHaveBeenCalled();
    await userEvent.click(screen.getByRole('button', { name: 'برجر كبصو، اليوم · 9:45 م' }));
    expect(onPress).toHaveBeenCalledOnce();
  });
});

describe('tracking steps', () => {
  const steps = [
    { icon: 'receipt', label: 'تم الطلب' },
    { icon: 'restaurant', label: 'قيد التحضير' },
    { icon: 'motorcycle', label: 'في الطريق' },
    { icon: 'house', label: 'وصل' },
  ] as const;

  it('is a named list whose current step is marked, in words too', () => {
    render(
      <TrackingSteps label="حالة الطلب" steps={steps} current={2} doneLabel="تم" nowLabel="الآن" />,
    );
    const list = screen.getByRole('list', { name: 'حالة الطلب' });
    const items = within(list).getAllByRole('listitem');
    expect(items).toHaveLength(4);
    expect(items[2]).toHaveAttribute('aria-current', 'step');
    expect(items.filter((item) => item.hasAttribute('aria-current'))).toHaveLength(1);
    // Never colour alone: a done step and the current one say so in words.
    expect(items[0]).toHaveTextContent('تم الطلب، تم');
    expect(items[2]).toHaveTextContent('في الطريق، الآن');
    expect(items[3]).toHaveTextContent(/^وصل$/);
  });

  it('marks every step done when current is past the last', () => {
    render(
      <TrackingSteps label="حالة الطلب" steps={steps} current={4} doneLabel="تم" nowLabel="الآن" />,
    );
    const items = screen.getAllByRole('listitem');
    expect(items.every((item) => !item.hasAttribute('aria-current'))).toBe(true);
    expect(items[3]).toHaveTextContent('وصل، تم');
  });

  // The still ring is the first ring's own look, so a shot with animations
  // cancelled (the screenshots, the parity sheet) shows it as reduced motion does.
  it('pulses only when motion is allowed, one still ring otherwise', () => {
    const { container } = render(
      <TrackingSteps label="حالة الطلب" steps={steps} current={1} doneLabel="تم" nowLabel="الآن" />,
    );
    const rings = [...container.querySelectorAll('[data-part="pulse"]')];
    expect(rings).toHaveLength(2);
    for (const ring of rings) expect(ring.getAttribute('class')).toMatch(/motion-safe:animate-/);
    expect(rings[0]!.getAttribute('class')).toMatch(
      /(^|\s)scale-\(--fd-motion-pulse-still-scale\)/,
    );
    expect(rings[0]!.getAttribute('class')).toMatch(
      /(^|\s)opacity-\(--fd-motion-pulse-still-opacity\)/,
    );
    expect(rings[1]!.getAttribute('class')).toMatch(/motion-reduce:hidden/);
  });
});
