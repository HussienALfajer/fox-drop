import { act, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { Toaster, TOAST_DURATION, useToast, type ToastOptions } from './toaster';

// D.10: a short result of the user's own action, never the only signal of an
// AP §7.3 alert. Durations from the approved sheet: success and info 4 s,
// warning 6 s, with an action 8 s, danger until closed.

function Show(props: ToastOptions) {
  const toast = useToast();
  return (
    <button type="button" onClick={() => toast.show(props)}>
      أظهر
    </button>
  );
}

function setup(props: ToastOptions) {
  const user = userEvent.setup({ advanceTimers: vi.advanceTimersByTime.bind(vi) });
  render(
    <Toaster label="الإشعارات" closeLabel="إغلاق">
      <Show {...props} />
    </Toaster>,
  );
  return user;
}

describe('Toast', () => {
  beforeEach(() => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
  });
  afterEach(() => {
    vi.useRealTimers();
  });

  // Parity gap (D.W3c): on a screen narrower than a toast and its margins,
  // the toast kept its width and ran past the start edge.
  it('keeps md from both edges on a narrow screen', async () => {
    const user = setup({ tone: 'info', text: 'نُسخ رقم الطلب' });
    await user.click(screen.getByRole('button', { name: 'أظهر' }));
    const region = screen.getByRole('region', { name: 'الإشعارات' });
    expect(region.className).toContain('inset-x-md');
    expect(screen.getByText('نُسخ رقم الطلب').closest('li')?.className).toContain(
      'max-w-(--fd-toast-width)',
    );
  });

  it('keeps the documented durations', () => {
    expect(TOAST_DURATION).toEqual({ success: 4000, info: 4000, warning: 6000, action: 8000 });
  });

  it('is announced politely, and assertively for danger', async () => {
    const user = setup({ tone: 'success', text: 'حُفظت التغييرات' });
    await user.click(screen.getByRole('button', { name: 'أظهر' }));
    const toast = await screen.findByText('حُفظت التغييرات');
    expect(toast.closest('[aria-live]')).toHaveAttribute('aria-live', 'polite');
  });

  it('puts a danger toast in an assertive live region', async () => {
    const user = setup({ tone: 'danger', text: 'تعذّر الحفظ' });
    await user.click(screen.getByRole('button', { name: 'أظهر' }));
    const toast = await screen.findByText('تعذّر الحفظ');
    expect(toast.closest('[aria-live]')).toHaveAttribute('aria-live', 'assertive');
  });

  it('leaves after its duration, unless hovered', async () => {
    const user = setup({ tone: 'info', text: 'نُسخ رقم الطلب' });
    await user.click(screen.getByRole('button', { name: 'أظهر' }));
    const toast = await screen.findByText('نُسخ رقم الطلب');
    await user.hover(toast);
    await act(async () => {
      await vi.advanceTimersByTimeAsync(TOAST_DURATION.info + 1000);
    });
    expect(screen.queryByText('نُسخ رقم الطلب')).not.toBeNull();
    await user.unhover(toast);
    await act(async () => {
      await vi.advanceTimersByTimeAsync(TOAST_DURATION.info + 1000);
    });
    expect(screen.queryByText('نُسخ رقم الطلب')).toBeNull();
  });

  it('keeps a danger toast until it is closed', async () => {
    const user = setup({ tone: 'danger', text: 'تعذّر الحفظ' });
    await user.click(screen.getByRole('button', { name: 'أظهر' }));
    await screen.findByText('تعذّر الحفظ');
    await act(async () => {
      await vi.advanceTimersByTimeAsync(60_000);
    });
    expect(screen.queryByText('تعذّر الحفظ')).not.toBeNull();
    await user.click(screen.getByRole('button', { name: 'إغلاق' }));
    await act(async () => {
      await vi.advanceTimersByTimeAsync(1000);
    });
    expect(screen.queryByText('تعذّر الحفظ')).toBeNull();
  });

  it('runs its action from the keyboard', async () => {
    const onAction = vi.fn();
    const user = setup({
      tone: 'success',
      text: 'أُضيف إلى السلة',
      action: { label: 'عرض السلة', onAction },
    });
    await user.click(screen.getByRole('button', { name: 'أظهر' }));
    const action = await screen.findByRole('button', { name: 'عرض السلة' });
    action.focus();
    await user.keyboard('{Enter}');
    expect(onAction).toHaveBeenCalledOnce();
  });
});
