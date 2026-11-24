import { render, screen, within } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { AmountsSummary } from './amounts-summary';

// CU §10.2 step 7 and §12.3: the money lines, the total, its equivalents.
const lines = [
  { label: 'قيمة الأصناف', amount: '45200' },
  { label: 'رسوم التوصيل', amount: '4500' },
  { label: 'الخصم (FOX25)', amount: '-2500', tone: 'success' as const },
  { label: 'تقريب', amount: '-200' },
];

describe('AmountsSummary', () => {
  it('lists each line with its amount as a term and its value', () => {
    render(
      <AmountsSummary lines={lines} total={{ label: 'المجموع', amount: '47000' }} symbol="₺" />,
    );
    const list = screen.getByRole('list');
    expect(within(list).getAllByRole('listitem')).toHaveLength(4);
    expect(within(list).getByText('452 ₺')).toBeInTheDocument();
    expect(within(list).getByText('−25 ₺').className).toContain('text-success');
  });

  it('shows the total after the lines', () => {
    render(
      <AmountsSummary lines={lines} total={{ label: 'المجموع', amount: '47000' }} symbol="₺" />,
    );
    const total = screen.getByText('470 ₺');
    expect(total.closest('[data-total]')).toHaveTextContent('المجموع');
  });

  it('shows the free fee in words', () => {
    render(
      <AmountsSummary
        lines={[{ label: 'رسوم التوصيل', amount: '0', text: 'مجاني' }]}
        total={{ label: 'المجموع', amount: '0' }}
        symbol="₺"
      />,
    );
    expect(screen.getByText('مجاني')).toBeInTheDocument();
  });

  it('draws the prominent total on the orange bar (the customer cart)', () => {
    render(
      <AmountsSummary
        variant="prominent"
        lines={lines}
        total={{ label: 'المجموع', amount: '47000' }}
        symbol="₺"
        equivalents="أو 11.50 $ · 3,300,000 ل.س"
      />,
    );
    expect(screen.getByText('470 ₺').closest('[data-total]')!.className).toContain('bg-primary');
    expect(screen.getByText('أو 11.50 $ · 3,300,000 ل.س')).toBeInTheDocument();
  });
});
