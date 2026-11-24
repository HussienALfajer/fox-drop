import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { ORDER_STATUSES, STATUS_LOOK, StatusChip } from './status-chip';

// AP §8.1's nine states and the tones and icons of the approved sheet
// (owner, 2026-11-24): an icon and a word with every colour (R4).
describe('StatusChip', () => {
  it('knows the nine order states', () => {
    expect(ORDER_STATUSES).toEqual([
      'placed',
      'accepted',
      'ready',
      'picked_up',
      'arrived',
      'delivered',
      'rejected',
      'cancelled',
      'failed',
    ]);
  });

  it('gives each state its approved tone and icon', () => {
    expect(STATUS_LOOK).toEqual({
      placed: { tone: 'warning', icon: 'clock' },
      accepted: { tone: 'info', icon: 'restaurant' },
      ready: { tone: 'success', icon: 'plate' },
      picked_up: { tone: 'primary', icon: 'motorcycle' },
      arrived: { tone: 'primary', icon: 'house' },
      delivered: { tone: 'success', icon: 'success' },
      rejected: { tone: 'danger', icon: 'close' },
      cancelled: { tone: 'neutral', icon: 'close' },
      failed: { tone: 'danger', icon: 'warning' },
    });
  });

  it('shows the label its app passes, with a decorative icon', () => {
    const { container } = render(<StatusChip status="picked_up" label="مع الكابتن" />);
    const chip = screen.getByText('مع الكابتن');
    expect(chip.closest('[data-tone]')).toHaveAttribute('data-tone', 'primary');
    expect(container.querySelector('svg')).toHaveAttribute('aria-hidden', 'true');
  });

  it('draws the tone on its tint', () => {
    render(<StatusChip status="delivered" label="تم التسليم" />);
    const chip = screen.getByText('تم التسليم').closest('[data-tone]')!;
    expect(chip.className).toContain('bg-success-subtle');
    expect(chip.className).toContain('text-success');
  });

  it('takes a tone and an icon without an order state (a restaurant badge)', () => {
    render(<StatusChip tone="warning" icon="clock" label="مشغول" />);
    expect(screen.getByText('مشغول').closest('[data-tone]')).toHaveAttribute(
      'data-tone',
      'warning',
    );
  });
});
