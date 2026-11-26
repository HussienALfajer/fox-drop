import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { Button } from '../button/button';
import { ConfirmDialog } from '../confirm-dialog/confirm-dialog';
import { Dialog } from './dialog';

// D.10, architecture §9.9: the dialog of the approved sheet «Overlays and
// navigation — batch 4», and the confirmation form of AP §7.4.

function DeleteAddress(props: { onConfirm?: () => void; onOpenChange?: (open: boolean) => void }) {
  return (
    <Dialog
      trigger={<Button>حذف العنوان</Button>}
      title="حذف هذا العنوان؟"
      description="«البيت» يُحذف من عناوينك."
      confirmLabel="حذف"
      cancelLabel="إلغاء"
      closeLabel="إغلاق"
      tone="danger"
      {...(props.onConfirm && { onConfirm: props.onConfirm })}
      {...(props.onOpenChange && { onOpenChange: props.onOpenChange })}
    />
  );
}

describe('Dialog', () => {
  it('opens from its trigger as a dialog named by its title and described by its text', async () => {
    render(<DeleteAddress />);
    await userEvent.click(screen.getByRole('button', { name: 'حذف العنوان' }));
    const dialog = await screen.findByRole('alertdialog', { name: 'حذف هذا العنوان؟' });
    expect(dialog).toHaveAccessibleDescription('«البيت» يُحذف من عناوينك.');
  });

  it('starts on the safe action, never the destructive one', async () => {
    render(<DeleteAddress />);
    await userEvent.click(screen.getByRole('button', { name: 'حذف العنوان' }));
    await screen.findByRole('alertdialog');
    await waitFor(() => expect(screen.getByRole('button', { name: 'إلغاء' })).toHaveFocus());
    expect(screen.getByRole('button', { name: 'حذف' })).not.toHaveFocus();
  });

  it('runs the action and closes; Escape closes without it', async () => {
    const onConfirm = vi.fn();
    render(<DeleteAddress onConfirm={onConfirm} />);
    await userEvent.click(screen.getByRole('button', { name: 'حذف العنوان' }));
    await screen.findByRole('alertdialog');
    await userEvent.keyboard('{Escape}');
    await waitFor(() => expect(screen.queryByRole('alertdialog')).toBeNull());
    expect(onConfirm).not.toHaveBeenCalled();

    await userEvent.click(screen.getByRole('button', { name: 'حذف العنوان' }));
    await userEvent.click(await screen.findByRole('button', { name: 'حذف' }));
    expect(onConfirm).toHaveBeenCalledOnce();
    await waitFor(() => expect(screen.queryByRole('alertdialog')).toBeNull());
  });

  it('closes from its × button, named for screen readers', async () => {
    const onOpenChange = vi.fn();
    render(<DeleteAddress onOpenChange={onOpenChange} />);
    await userEvent.click(screen.getByRole('button', { name: 'حذف العنوان' }));
    await userEvent.click(await screen.findByRole('button', { name: 'إغلاق' }));
    await waitFor(() => expect(screen.queryByRole('alertdialog')).toBeNull());
    expect(onOpenChange).toHaveBeenLastCalledWith(false);
  });

  // D.C1: the components canvas draws it open inside its board, scrim included.
  it('stays in its frame when inline, its scrim with it, and the page around stays usable', async () => {
    const outsidePresses = vi.fn();
    render(
      <div>
        <button type="button" onClick={outsidePresses}>
          خارج النافذة
        </button>
        <input aria-label="حقل خارج النافذة" />
        <div data-testid="frame">
          <Dialog
            open
            inline
            title="حذف هذا العنوان؟"
            confirmLabel="حذف"
            cancelLabel="إلغاء"
            closeLabel="إغلاق"
          />
        </div>
      </div>,
    );
    // Beside the page, not modal: a plain dialog (an alert dialog is modal by definition).
    const dialog = await screen.findByRole('dialog', { name: 'حذف هذا العنوان؟' });
    const frame = screen.getByTestId('frame');
    expect(frame).toContainElement(dialog);
    expect(frame.querySelector('[data-scrim]')).not.toBeNull();
    const outside = screen.getByRole('button', { name: 'خارج النافذة' });
    expect(outside.closest('[inert], [aria-hidden="true"]')).toBeNull();
    // After it has settled: presses and typing outside work, the page still scrolls, it stays open.
    await new Promise((done) => setTimeout(done, 300));
    await userEvent.click(outside);
    expect(outsidePresses).toHaveBeenCalledTimes(1);
    const field = screen.getByRole('textbox', { name: 'حقل خارج النافذة' });
    await userEvent.click(field);
    await userEvent.keyboard('abc');
    expect(field).toHaveValue('abc');
    expect(document.documentElement.style.overflow).not.toBe('hidden');
    expect(screen.getByRole('dialog', { name: 'حذف هذا العنوان؟' })).toBeInTheDocument();
  });
});

function CancelOrder({ onConfirm = vi.fn() }: { onConfirm?: (reason: string) => void }) {
  return (
    <ConfirmDialog
      trigger={<Button>إلغاء الطلب</Button>}
      title="إلغاء الطلب #10423"
      reasonLabel="السبب"
      reasonPlaceholder="اكتب سبب الإلغاء"
      reasonError="السبب مطلوب"
      effectTitle="أثره على الأرصدة"
      effect={<p>يُعاد للزبون 470 ₺</p>}
      notifyTitle="سيُبلَّغ"
      notified={['الزبون', 'المطعم', 'الكابتن']}
      confirmLabel="تأكيد الإلغاء"
      cancelLabel="تراجع"
      closeLabel="إغلاق"
      onConfirm={onConfirm}
    />
  );
}

describe('ConfirmDialog (AP §7.4)', () => {
  it('shows the reason field, the money effect and who is notified', async () => {
    render(<CancelOrder />);
    await userEvent.click(screen.getByRole('button', { name: 'إلغاء الطلب' }));
    const dialog = await screen.findByRole('alertdialog', { name: 'إلغاء الطلب #10423' });
    expect(screen.getByRole('textbox', { name: /السبب/ })).toBeRequired();
    expect(dialog).toHaveTextContent('أثره على الأرصدة');
    expect(dialog).toHaveTextContent('يُعاد للزبون 470 ₺');
    const list = screen.getByRole('list', { name: 'سيُبلَّغ' });
    expect(list.querySelectorAll('li')).toHaveLength(3);
  });

  it('will not confirm without a reason, and says why next to the field', async () => {
    const onConfirm = vi.fn();
    render(<CancelOrder onConfirm={onConfirm} />);
    await userEvent.click(screen.getByRole('button', { name: 'إلغاء الطلب' }));
    const confirm = await screen.findByRole('button', { name: 'تأكيد الإلغاء' });
    expect(confirm).toHaveAttribute('aria-disabled', 'true');
    await userEvent.click(confirm);
    expect(onConfirm).not.toHaveBeenCalled();
    expect(screen.getByRole('textbox', { name: /السبب/ })).toHaveAccessibleDescription(
      'السبب مطلوب',
    );

    await userEvent.type(screen.getByRole('textbox', { name: /السبب/ }), '   ');
    await userEvent.click(confirm);
    expect(onConfirm).not.toHaveBeenCalled();
  });

  it('confirms with the written reason, trimmed', async () => {
    const onConfirm = vi.fn();
    render(<CancelOrder onConfirm={onConfirm} />);
    await userEvent.click(screen.getByRole('button', { name: 'إلغاء الطلب' }));
    await userEvent.type(
      await screen.findByRole('textbox', { name: /السبب/ }),
      ' الزبون طلب الإلغاء ',
    );
    const confirm = screen.getByRole('button', { name: 'تأكيد الإلغاء' });
    expect(confirm).not.toHaveAttribute('aria-disabled', 'true');
    await userEvent.click(confirm);
    expect(onConfirm).toHaveBeenCalledWith('الزبون طلب الإلغاء');
  });

  it('starts on the reason field, not on the destructive action', async () => {
    render(<CancelOrder />);
    await userEvent.click(screen.getByRole('button', { name: 'إلغاء الطلب' }));
    const field = await screen.findByRole('textbox', { name: /السبب/ });
    await waitFor(() => expect(field).toHaveFocus());
  });
});
