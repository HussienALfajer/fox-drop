import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { DataTable } from './data-table/data-table';
import { Dialog } from './dialog/dialog';
import { PullToRefresh } from './pull-to-refresh/pull-to-refresh';

// The components canvas audit (2026-11-27): a composite draws the system's own
// component, never a copy of its markup. Button wraps its label in its content
// span, so a button that is ours has one; Skeleton's block carries its mark.
const ours = (button: HTMLElement) =>
  button.firstElementChild?.tagName === 'SPAN' && button.firstElementChild.textContent !== '';

describe('composites use the system components', () => {
  it("a loading table's lines are Skeleton blocks", () => {
    const { container } = render(
      <DataTable
        label="الطلبات"
        columns={[{ key: 'n', header: 'الرقم', cell: (r: { n: string }) => r.n }]}
        rows={[]}
        rowKey={(r) => r.n}
        loading
      />,
    );
    expect(container.querySelectorAll('td [data-skeleton-block]').length).toBeGreaterThan(0);
  });

  it("a dialog's actions are the system Button", () => {
    render(
      <Dialog
        open
        title="حذف الصنف"
        confirmLabel="حذف"
        cancelLabel="إلغاء"
        closeLabel="إغلاق"
        tone="danger"
      />,
    );
    expect(ours(screen.getByRole('button', { name: 'حذف' }))).toBe(true);
    expect(ours(screen.getByRole('button', { name: 'إلغاء' }))).toBe(true);
  });

  it("pull to refresh's keyboard button is the system Button", () => {
    render(
      <PullToRefresh refreshLabel="تحديث" onRefresh={() => Promise.resolve()}>
        <p>القائمة</p>
      </PullToRefresh>,
    );
    expect(ours(screen.getByRole('button', { name: 'تحديث' }))).toBe(true);
  });
});
