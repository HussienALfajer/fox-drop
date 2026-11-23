import { fireEvent, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { CountBadge } from './count-badge/count-badge';
import { DataTable } from './data-table/data-table';
import { ListRow } from './list-row/list-row';
import { OrderCard } from './order-card/order-card';
import { Skeleton } from './skeleton/skeleton';
import { Timer } from './timer/timer';

// The review of D.9.
describe('data display, after review', () => {
  it('a zero badge keeps what it sits on', () => {
    render(
      <CountBadge count={0} label="لا شيء">
        <span>السلة</span>
      </CountBadge>,
    );
    expect(screen.getByText('السلة')).toBeInTheDocument();
  });

  it('a pressable row is described by its end slot too', () => {
    render(<ListRow title="رصيد العهدة" end={<span>1,250 ₺</span>} onPress={() => undefined} />);
    expect(screen.getByRole('button', { name: 'رصيد العهدة' })).toHaveAccessibleDescription(
      '1,250 ₺',
    );
  });

  it('an order card opens by its number, the main button stays apart', async () => {
    const onOpen = vi.fn();
    const onPress = vi.fn();
    render(
      <OrderCard
        label="طلب #10423"
        number="10423"
        since="منذ 1 د"
        items="3 أصناف"
        captain="بانتظار كابتن"
        timer={<Timer seconds={272} direction="down" minuteUnit="د" />}
        action={{ label: 'قبول', onPress }}
        onOpen={onOpen}
      />,
    );
    await userEvent.click(screen.getByRole('button', { name: 'طلب #10423' }));
    expect(onOpen).toHaveBeenCalledOnce();
    expect(onPress).not.toHaveBeenCalled();
  });

  it('a skeleton announces its label as text', () => {
    render(
      <Skeleton label="جارٍ التحميل">
        <Skeleton.Block />
      </Skeleton>,
    );
    expect(screen.getByRole('status')).toHaveTextContent('جارٍ التحميل');
  });

  it('Enter on a row checkbox does not open the row', () => {
    const onRowOpen = vi.fn();
    render(
      <DataTable
        label="الطلبات"
        columns={[{ key: 'n', header: 'الطلب', cell: (r: { id: string }) => r.id }]}
        rows={[{ id: 'a' }]}
        rowKey={(r) => r.id}
        selection={new Set<string>()}
        onSelectionChange={() => undefined}
        rowLabel={(r) => `اختيار ${r.id}`}
        onRowOpen={onRowOpen}
      />,
    );
    fireEvent.keyDown(screen.getByRole('checkbox', { name: 'اختيار a' }), { key: 'Enter' });
    expect(onRowOpen).not.toHaveBeenCalled();
    fireEvent.keyDown(screen.getByRole('checkbox').closest('tr')!, { key: 'Enter' });
    expect(onRowOpen).toHaveBeenCalledOnce();
  });
});
