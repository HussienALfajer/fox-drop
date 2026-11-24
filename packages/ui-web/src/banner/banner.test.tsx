import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Banner, BANNER_TONES } from './banner';

// D.10: the banners under the top bar (RA §6.3, CA §6.3, CU §6.2, AP §7.3).
// Every tone has an icon and words, never colour alone; red is solid.

describe('Banner', () => {
  it('has the five tones the specs name', () => {
    expect(BANNER_TONES).toEqual(['danger', 'caution', 'warning', 'info', 'neutral']);
  });

  it.each(BANNER_TONES)('the %s tone shows an icon beside its words', (tone) => {
    const { container } = render(<Banner tone={tone}>وضع التجربة</Banner>);
    expect(screen.getByText('وضع التجربة')).toBeVisible();
    expect(container.querySelector('svg')).not.toBeNull();
  });

  it('is an alert when red, a status otherwise', () => {
    render(
      <>
        <Banner tone="danger">لا يوجد اتصال بالإنترنت</Banner>
        <Banner tone="info">وضع التجربة</Banner>
      </>,
    );
    expect(screen.getByRole('alert')).toHaveTextContent('لا يوجد اتصال بالإنترنت');
    expect(screen.getByRole('status')).toHaveTextContent('وضع التجربة');
  });

  it('runs its action', async () => {
    const onAction = vi.fn();
    render(
      <Banner tone="neutral" action={{ label: 'تحديث', onAction }}>
        يتوفر تحديث للتطبيق
      </Banner>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'تحديث' }));
    expect(onAction).toHaveBeenCalledOnce();
  });

  // D.11 (owner, 2026-11-24): «يتوفر إصدار أحدث» closes (CU §4.2), and the
  // review stop offers a call and WhatsApp (CU §5.5).
  it('closes by its named close button', async () => {
    const onDismiss = vi.fn();
    render(
      <Banner tone="info" dismiss={{ label: 'إغلاق', onDismiss }}>
        يتوفر إصدار أحدث من التطبيق.
      </Banner>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'إغلاق' }));
    expect(onDismiss).toHaveBeenCalledOnce();
  });

  it('runs a second action beside the first, each with its icon', async () => {
    const call = vi.fn();
    const whatsapp = vi.fn();
    const { container } = render(
      <Banner
        tone="danger"
        action={{ label: 'اتصال', icon: 'phone', onAction: call }}
        secondaryAction={{ label: 'واتساب', icon: 'chat', onAction: whatsapp }}
      >
        حسابك موقوف حتى مراجعة فريق الدعم
      </Banner>,
    );
    await userEvent.click(screen.getByRole('button', { name: 'اتصال' }));
    await userEvent.click(screen.getByRole('button', { name: 'واتساب' }));
    expect(call).toHaveBeenCalledOnce();
    expect(whatsapp).toHaveBeenCalledOnce();
    // The tone's icon and one per action.
    expect(container.querySelectorAll('svg')).toHaveLength(3);
  });
});
