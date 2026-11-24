import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { OrderCard } from './order-card';
import { Timer } from '../timer/timer';

// RA §8.2: the compact card of the restaurant board.
const base = {
  label: 'طلب #10423',
  number: '10423',
  since: 'منذ 1 د',
  items: '3 أصناف · وجبة كريسبي، لفة شاورما…',
  captain: 'بانتظار كابتن',
  timer: <Timer seconds={272} direction="down" minuteUnit="د" />,
};

describe('OrderCard', () => {
  it('shows the number, time since placed, items, captain line and timer', () => {
    render(<OrderCard {...base} />);
    const card = screen.getByRole('article', { name: 'طلب #10423' });
    expect(within(card).getByText('#10423')).toBeInTheDocument();
    expect(within(card).getByText('منذ 1 د')).toBeInTheDocument();
    expect(within(card).getByText(base.items)).toBeInTheDocument();
    expect(within(card).getByText('بانتظار كابتن')).toBeInTheDocument();
    expect(within(card).getByRole('timer')).toHaveTextContent('4:32');
  });

  it('has one main button when the board can act (the app; the portal is read-only)', async () => {
    const onPress = vi.fn();
    render(<OrderCard {...base} action={{ label: 'قبول', onPress }} />);
    await userEvent.click(screen.getByRole('button', { name: 'قبول' }));
    expect(onPress).toHaveBeenCalledOnce();
  });

  it('has no button in the read-only portal', () => {
    render(<OrderCard {...base} />);
    expect(screen.queryByRole('button')).toBeNull();
  });

  it('turns red when late and says so in words', () => {
    render(<OrderCard {...base} late lateLabel="متأخر" />);
    const card = screen.getByRole('article', { name: 'طلب #10423، متأخر' });
    expect(card.className).toContain('bg-danger-subtle');
  });

  it('shows the badges it is given', () => {
    render(<OrderCard {...base} badges={<span>صنف نفد — بانتظار العمليات</span>} />);
    expect(screen.getByText('صنف نفد — بانتظار العمليات')).toBeInTheDocument();
  });
});
