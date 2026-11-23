import type { Meta, StoryObj } from '@storybook/react-vite';
import { useState } from 'react';
import { EmptyState } from '../empty-state/empty-state';
import { Money } from '../money/money';
import { StatusChip, type OrderStatus } from '../status-chip/status-chip';
import { DataTable, type Column, type DataTableProps, type Sort } from './data-table';

interface Order {
  id: string;
  time: string;
  restaurant: string;
  status: OrderStatus;
  statusLabel: string;
  total: string;
}

const orders: Order[] = [
  {
    id: '10423',
    time: '9:45 م',
    restaurant: 'برجر كبصو',
    status: 'placed',
    statusLabel: 'بانتظار المطعم',
    total: '47000',
  },
  {
    id: '10422',
    time: '9:41 م',
    restaurant: 'شاورما الشام',
    status: 'accepted',
    statusLabel: 'قيد التحضير',
    total: '23500',
  },
  {
    id: '10421',
    time: '9:38 م',
    restaurant: 'كنافة أعزاز',
    status: 'picked_up',
    statusLabel: 'مع الكابتن',
    total: '112000',
  },
  {
    id: '10420',
    time: '9:30 م',
    restaurant: 'فطائر الريف',
    status: 'failed',
    statusLabel: 'فشل التسليم',
    total: '9000',
  },
];

const columns: Column<Order>[] = [
  { key: 'id', header: 'الطلب', cell: (o) => `#${o.id}`, sortable: true },
  { key: 'time', header: 'الوقت', cell: (o) => o.time, sortable: true },
  { key: 'restaurant', header: 'المطعم', cell: (o) => o.restaurant },
  {
    key: 'status',
    header: 'الحالة',
    cell: (o) => <StatusChip status={o.status} label={o.statusLabel} density="compact" />,
  },
  {
    key: 'total',
    header: 'المجموع',
    cell: (o) => <Money amount={o.total} symbol="₺" size="compact" />,
    numeric: true,
  },
];

// The table with its sort and selection held as an app would hold them.
function Table(props: DataTableProps<Order>) {
  const [sort, setSort] = useState<Sort | undefined>(props.sort);
  const [selection, setSelection] = useState(props.selection);
  return (
    <DataTable
      {...props}
      {...(sort && { sort })}
      onSortChange={setSort}
      {...(selection && { selection, onSelectionChange: setSelection })}
    />
  );
}

const meta = {
  title: 'DataTable',
  component: DataTable,
  args: {
    label: 'الطلبات',
    columns: columns as Column<unknown>[],
    rows: orders,
    rowKey: (o) => (o as Order).id,
  },
  render: (args) => <Table {...(args as DataTableProps<Order>)} />,
} satisfies Meta<typeof DataTable>;
export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const Sorted: Story = { args: { sort: { key: 'time', direction: 'descending' } } };
export const Hover: Story = { args: { onRowOpen: () => undefined } };
export const Selected: Story = {
  args: {
    selection: new Set(['10421']),
    rowLabel: (o) => `اختيار الطلب #${(o as Order).id}`,
  },
};
export const Loading: Story = { args: { rows: [], loading: true, loadingLabel: 'جارٍ التحميل' } };
export const Empty: Story = {
  args: {
    rows: [],
    empty: (
      <EmptyState
        icon="orders"
        title="لا طلبات بهذه الفلاتر"
        density="compact"
        action={{ label: 'مسح الفلاتر', onPress: () => undefined }}
      />
    ),
  },
};
