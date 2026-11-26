import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { BannerStack } from './banner-stack/banner-stack';
import { Button } from './button/button';
import { ConfirmDialog } from './confirm-dialog/confirm-dialog';
import { Dialog } from './dialog/dialog';
import { PullToRefresh } from './pull-to-refresh/pull-to-refresh';

// The components canvas audit (2026-11-27, owner's choices): every state is
// drawn on its board, so a state a gesture reaches has a prop that shows it
// from the start, and a confirm button that waits shows Button's own loader.
const loader = (el: HTMLElement) => el.querySelector('[data-drop-loader]');

describe('states the canvas draws from props', () => {
  it('a banner stack opened from the start shows every banner', () => {
    render(
      <BannerStack
        defaultOpen
        banners={[
          { id: 'a', tone: 'danger', text: 'أول' },
          { id: 'b', tone: 'danger', text: 'ثانٍ' },
          { id: 'c', tone: 'warning', text: 'ثالث' },
        ]}
        moreLabel={(n) => `+${String(n)}`}
        lessLabel="إخفاء"
      />,
    );
    expect(screen.getByText('ثالث')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'إخفاء' })).toHaveAttribute('aria-expanded', 'true');
  });

  it('pull to refresh pulled from the start fills its mark that far', () => {
    const { container } = render(
      <PullToRefresh defaultPulled={40} refreshLabel="تحديث" onRefresh={() => undefined}>
        <p>القائمة</p>
      </PullToRefresh>,
    );
    expect(container.querySelector('[data-pull-drop]')).not.toBeNull();
  });

  it('pull to refresh refreshing from the start shows the drop loader', () => {
    const { container } = render(
      <PullToRefresh defaultRefreshing refreshLabel="تحديث" onRefresh={() => undefined}>
        <p>القائمة</p>
      </PullToRefresh>,
    );
    expect(container.querySelector('[data-drop-loader]')).not.toBeNull();
  });
});

describe('a confirm button that waits shows the loader', () => {
  it('a soft-disabled Button says so and still takes presses', async () => {
    const onClick = vi.fn();
    render(
      <Button softDisabled onClick={onClick}>
        تأكيد
      </Button>,
    );
    const button = screen.getByRole('button', { name: 'تأكيد' });
    expect(button).toHaveAttribute('aria-disabled', 'true');
    expect(button).not.toBeDisabled();
    await userEvent.click(button);
    expect(onClick).toHaveBeenCalledTimes(1);
  });

  it("ConfirmDialog's confirm is the system Button and shows its loader while pending", () => {
    render(
      <ConfirmDialog
        open
        pending
        title="إلغاء الطلب"
        reasonLabel="السبب"
        reasonError="اكتب السبب"
        notifyTitle="سيُبلَّغ"
        notified={['الزبون']}
        confirmLabel="إلغاء الطلب"
        cancelLabel="رجوع"
        closeLabel="إغلاق"
        onConfirm={() => undefined}
      />,
    );
    const confirm = screen.getByRole('button', { name: 'إلغاء الطلب' });
    expect(confirm).toHaveAttribute('aria-busy', 'true');
    expect(loader(confirm)).not.toBeNull();
  });

  it("an unready ConfirmDialog's confirm still says why when pressed", async () => {
    render(
      <ConfirmDialog
        open
        title="إلغاء الطلب"
        reasonLabel="السبب"
        reasonError="اكتب السبب"
        notifyTitle="سيُبلَّغ"
        notified={['الزبون']}
        confirmLabel="إلغاء الطلب"
        cancelLabel="رجوع"
        closeLabel="إغلاق"
        onConfirm={() => undefined}
      />,
    );
    const confirm = screen.getByRole('button', { name: 'إلغاء الطلب' });
    expect(confirm).toHaveAttribute('aria-disabled', 'true');
    await userEvent.click(confirm);
    expect(screen.getByText('اكتب السبب')).toBeInTheDocument();
  });

  it("Dialog's confirm shows the loader while its command runs", async () => {
    render(
      <Dialog
        open
        title="حذف الصنف"
        confirmLabel="حذف"
        cancelLabel="إلغاء"
        closeLabel="إغلاق"
        onConfirm={() => new Promise(() => undefined)}
      />,
    );
    await userEvent.click(screen.getByRole('button', { name: 'حذف' }));
    expect(loader(screen.getByRole('button', { name: 'حذف' }))).not.toBeNull();
  });

  it('a Dialog drawn pending shows the loader', () => {
    render(
      <Dialog
        open
        pending
        title="حذف الصنف"
        confirmLabel="حذف"
        cancelLabel="إلغاء"
        closeLabel="إغلاق"
      />,
    );
    expect(loader(screen.getByRole('button', { name: 'حذف' }))).not.toBeNull();
  });
});
