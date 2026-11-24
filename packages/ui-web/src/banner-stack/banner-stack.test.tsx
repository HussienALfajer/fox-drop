import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it } from 'vitest';
import { BannerStack } from './banner-stack';

// D.10, RA §6.3: when several banners apply, up to two show and the rest are
// behind a counter, in the priority order the app gives.

const banners = [
  { id: 'offline', tone: 'danger', text: 'لا يوجد اتصال بالإنترنت' },
  { id: 'stop', tone: 'danger', text: 'المنصة متوقفة مؤقتاً' },
  { id: 'device', tone: 'caution', text: 'فشل فحص الجهاز' },
  { id: 'settlement', tone: 'warning', text: 'التسوية متأخرة' },
  { id: 'update', tone: 'neutral', text: 'يتوفر تحديث للتطبيق' },
] as const;

const more = (count: number) => `+${count} تنبيهات أخرى`;

describe('BannerStack', () => {
  it('shows the first two in the given order and counts the rest', () => {
    render(<BannerStack banners={banners} moreLabel={more} lessLabel="إخفاء" />);
    const texts = screen.getAllByText(/./, { selector: '[data-banner-text]' });
    expect(texts.map((t) => t.textContent)).toEqual([
      'لا يوجد اتصال بالإنترنت',
      'المنصة متوقفة مؤقتاً',
    ]);
    expect(screen.getByRole('button', { name: '+3 تنبيهات أخرى' })).toHaveAttribute(
      'aria-expanded',
      'false',
    );
  });

  it('opens the rest in place, and folds them again', async () => {
    render(<BannerStack banners={banners} moreLabel={more} lessLabel="إخفاء" />);
    await userEvent.click(screen.getByRole('button', { name: '+3 تنبيهات أخرى' }));
    expect(screen.getAllByText(/./, { selector: '[data-banner-text]' })).toHaveLength(5);
    const less = screen.getByRole('button', { name: 'إخفاء' });
    expect(less).toHaveAttribute('aria-expanded', 'true');
    await userEvent.click(less);
    expect(screen.getAllByText(/./, { selector: '[data-banner-text]' })).toHaveLength(2);
  });

  it('has no counter with two banners or fewer, and nothing with none', () => {
    const { container, rerender } = render(
      <BannerStack banners={banners.slice(0, 2)} moreLabel={more} lessLabel="إخفاء" />,
    );
    expect(screen.queryByRole('button')).toBeNull();
    rerender(<BannerStack banners={[]} moreLabel={more} lessLabel="إخفاء" />);
    expect(container).toBeEmptyDOMElement();
  });
});
