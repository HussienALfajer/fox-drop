import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { formatAmount, Money } from './money';

// AP §4.7 and the approved sheet (owner, 2026-11-24): Western digits, a
// Western comma between thousands, a whole amount drops its fraction, any
// other shows every minor digit; the minus is U+2212 and reads first.
describe('formatAmount', () => {
  it.each([
    ['41000', 2, '410'],
    ['1050', 2, '10.50'],
    ['5', 2, '0.05'],
    ['0', 2, '0'],
    ['125000', 2, '1,250'],
    ['330000000', 2, '3,300,000'],
    ['1248050', 2, '12,480.50'],
    ['2500000', 0, '2,500,000'],
    ['-2500', 2, '−25'],
    ['-30005', 2, '−300.05'],
  ])('%s minor units with %i decimals is %s', (minor, decimals, text) => {
    expect(formatAmount(minor, decimals)).toBe(text);
  });

  it('accepts a bigint and never passes through a float', () => {
    expect(formatAmount(900719925474099312n, 2)).toBe('9,007,199,254,740,993.12');
  });

  it('puts a plus on a gain only when asked', () => {
    expect(formatAmount('20000', 2, { signed: true })).toBe('+200');
    expect(formatAmount('-20000', 2, { signed: true })).toBe('−200');
    expect(formatAmount('0', 2, { signed: true })).toBe('0');
  });

  it('refuses a value that is not an integer of minor units', () => {
    expect(() => formatAmount('10.5', 2)).toThrow();
  });
});

describe('Money', () => {
  it('is one isolated RTL run: the amount, a space, the symbol', () => {
    render(<Money amount="41000" symbol="₺" />);
    const run = screen.getByText('410 ₺');
    expect(run.tagName).toBe('BDI');
    expect(run).toHaveAttribute('dir', 'rtl');
    expect(run.className).toContain('tabular-nums');
  });

  it('takes the decimals of its currency', () => {
    render(<Money amount="330000000" symbol="ل.س" decimals={2} />);
    expect(screen.getByText('3,300,000 ل.س')).toBeInTheDocument();
  });

  it('colours a tone and keeps the symbol in the run', () => {
    render(<Money amount="-2500" symbol="₺" tone="success" />);
    const run = screen.getByText('−25 ₺');
    expect(run.className).toContain('text-(color:--fd-money-color-success)');
  });
});
