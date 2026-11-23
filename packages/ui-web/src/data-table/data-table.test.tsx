import { render, screen, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it, vi } from 'vitest';
import { DataTable, type Column } from './data-table';

interface Row {
  id: string;
  number: string;
  restaurant: string;
  total: string;
}

const rows: Row[] = [
  { id: 'a', number: '#10423', restaurant: 'برجر كبصو', total: '470 ₺' },
  { id: 'b', number: '#10422', restaurant: 'شاورما الشام', total: '235 ₺' },
];
const columns: Column<Row>[] = [
  { key: 'number', header: 'الطلب', cell: (r) => r.number, sortable: true },
  { key: 'restaurant', header: 'المطعم', cell: (r) => r.restaurant },
  { key: 'total', header: 'المجموع', cell: (r) => r.total, numeric: true },
];
const props = { columns, rows, rowKey: (r: Row) => r.id, label: 'الطلبات' };

describe('DataTable', () => {
  it('is a named table with a header row and a row per item', () => {
    render(<DataTable {...props} />);
    const table = screen.getByRole('table', { name: 'الطلبات' });
    expect(
      within(table)
        .getAllByRole('columnheader')
        .map((h) => h.textContent),
    ).toEqual(['الطلب', 'المطعم', 'المجموع']);
    expect(within(table).getAllByRole('row')).toHaveLength(3);
  });

  it('aligns numbers to the end in tabular digits', () => {
    render(<DataTable {...props} />);
    const cell = screen.getByText('470 ₺').closest('td')!;
    expect(cell.className).toContain('text-end');
    expect(cell.className).toContain('tabular-nums');
  });

  it('marks the sorted column and asks the app to sort', async () => {
    const onSortChange = vi.fn();
    render(
      <DataTable
        {...props}
        sort={{ key: 'number', direction: 'descending' }}
        onSortChange={onSortChange}
      />,
    );
    const header = screen.getByRole('columnheader', { name: 'الطلب' });
    expect(header).toHaveAttribute('aria-sort', 'descending');
    expect(screen.getByRole('columnheader', { name: 'المطعم' })).not.toHaveAttribute('aria-sort');
    await userEvent.click(within(header).getByRole('button'));
    expect(onSortChange).toHaveBeenCalledWith({ key: 'number', direction: 'ascending' });
  });

  it('selects rows with a checkbox each, named by the row', async () => {
    const onSelectionChange = vi.fn();
    render(
      <DataTable
        {...props}
        selection={new Set(['b'])}
        onSelectionChange={onSelectionChange}
        rowLabel={(r) => `اختيار الطلب ${r.number}`}
      />,
    );
    const second = screen.getByRole('checkbox', { name: 'اختيار الطلب #10422' });
    expect(second).toBeChecked();
    expect(second.closest('tr')).toHaveAttribute('aria-selected', 'true');
    await userEvent.click(screen.getByRole('checkbox', { name: 'اختيار الطلب #10423' }));
    expect(onSelectionChange).toHaveBeenCalledWith(new Set(['b', 'a']));
  });

  it('opens a row by click', async () => {
    const onRowOpen = vi.fn();
    render(<DataTable {...props} onRowOpen={onRowOpen} />);
    await userEvent.click(screen.getByText('برجر كبصو'));
    expect(onRowOpen).toHaveBeenCalledWith(rows[0]);
  });

  it('shows skeleton rows while loading', () => {
    render(<DataTable {...props} rows={[]} loading loadingLabel="جارٍ التحميل" />);
    const table = screen.getByRole('table', { name: 'الطلبات' });
    expect(table).toHaveAttribute('aria-busy', 'true');
    expect(within(table).getAllByRole('row').length).toBeGreaterThan(1);
  });

  it('shows the empty state inside the table', () => {
    render(<DataTable {...props} rows={[]} empty={<p>لا طلبات</p>} />);
    const cell = screen.getByText('لا طلبات').closest('td')!;
    expect(cell).toHaveAttribute('colspan', '3');
  });
});
