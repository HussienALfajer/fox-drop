import { act, render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Button } from './button/button';
import { ConfirmDialog } from './confirm-dialog/confirm-dialog';
import { Toaster, useToast, type ToastOptions } from './toaster/toaster';

// The review of D.10: a failed confirmation keeps its dialog, and trimming the
// toasts never drops a danger toast that waits to be closed.

describe('ConfirmDialog after a failed command', () => {
  it('stays open with the reason kept, and reports nothing unhandled', async () => {
    const onConfirm = vi.fn(() => Promise.reject(new Error('offline')));
    const onOpenChange = vi.fn();
    render(
      <ConfirmDialog
        trigger={<Button>إلغاء الطلب</Button>}
        title="إلغاء الطلب #10423"
        reasonLabel="السبب"
        reasonError="السبب مطلوب"
        notifyTitle="سيُبلَّغ"
        notified={['الزبون']}
        confirmLabel="تأكيد الإلغاء"
        cancelLabel="تراجع"
        closeLabel="إغلاق"
        onConfirm={onConfirm}
        onOpenChange={onOpenChange}
      />,
    );
    await userEvent.click(screen.getByRole('button', { name: 'إلغاء الطلب' }));
    await userEvent.type(await screen.findByRole('textbox', { name: /السبب/ }), 'طلب الزبون');
    await userEvent.click(screen.getByRole('button', { name: 'تأكيد الإلغاء' }));
    await waitFor(() => expect(onConfirm).toHaveBeenCalledOnce());
    expect(screen.getByRole('alertdialog')).toBeInTheDocument();
    expect(screen.getByRole('textbox', { name: /السبب/ })).toHaveValue('طلب الزبون');
    expect(onOpenChange).not.toHaveBeenCalledWith(false);
  });
});

function ShowAll({ toasts }: { toasts: ToastOptions[] }) {
  const toast = useToast();
  return (
    <button type="button" onClick={() => toasts.forEach((options) => toast.show(options))}>
      أظهر
    </button>
  );
}

describe('Toaster over its limit', () => {
  it('drops the oldest toast that leaves by itself, never a danger one', async () => {
    render(
      <Toaster label="الإشعارات" closeLabel="إغلاق" max={3}>
        <ShowAll
          toasts={[
            { tone: 'danger', text: 'تعذّر الحفظ' },
            { tone: 'success', text: 'أ' },
            { tone: 'success', text: 'ب' },
            { tone: 'success', text: 'ج' },
          ]}
        />
      </Toaster>,
    );
    await act(async () => {
      screen.getByRole('button', { name: 'أظهر' }).click();
    });
    expect(screen.getByText('تعذّر الحفظ')).toBeInTheDocument();
    expect(screen.queryByText('أ')).toBeNull();
    expect(screen.getByText('ج')).toBeInTheDocument();
  });
});
