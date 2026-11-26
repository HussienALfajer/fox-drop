import type { ReactNode } from 'react';
import { formTv, keyboardRing } from '../field/styles';
import { Icon } from '../icon/icon';

/** The states the stories show (R3). */
export const STATES = ['default', 'sorted', 'hover', 'selected', 'loading', 'empty'] as const;

export interface Column<Row> {
  key: string;
  header: string;
  cell: (row: Row) => ReactNode;
  /** Numbers and money: aligned to the end, tabular digits. */
  numeric?: boolean;
  sortable?: boolean;
}

export interface Sort {
  key: string;
  direction: 'ascending' | 'descending';
}

const cell = formTv({
  base: 'h-(--fd-data-table-row-height) border-t-(length:--fd-data-table-border-width) border-(--fd-data-table-color-border) px-(--fd-data-table-padding-inline) text-panel-body whitespace-nowrap text-(color:--fd-data-table-color-text)',
  variants: { numeric: { true: 'text-end tabular-nums', false: 'text-start' } },
});

const head = formTv({
  base: 'sticky top-none z-10 h-(--fd-data-table-row-height) bg-(--fd-data-table-color-head-background) px-(--fd-data-table-padding-inline) text-panel-secondary font-medium whitespace-nowrap text-(color:--fd-data-table-color-head-text)',
  variants: { numeric: { true: 'text-end', false: 'text-start' } },
});

const row = formTv({
  base: 'transition-colors duration-(--fd-duration-base) ease-(--fd-easing-standard)',
  variants: {
    selected: {
      true: 'bg-(--fd-data-table-color-row-selected)',
      false: 'hover:bg-(--fd-data-table-color-row-hover)',
    },
    opens: { true: `cursor-pointer ${keyboardRing}` },
  },
});

const sortButton = formTv({
  base: `inline-flex cursor-pointer items-center gap-(--fd-data-table-sort-gap) rounded-(--fd-data-table-inner-radius) ${keyboardRing}`,
  variants: { sorted: { true: 'text-(color:--fd-data-table-color-text)' } },
});

export interface DataTableProps<Row> {
  /** The table's name: «الطلبات». */
  label: string;
  columns: Column<Row>[];
  rows: Row[];
  rowKey: (row: Row) => string;
  sort?: Sort;
  onSortChange?: (sort: Sort) => void;
  /** The selected row keys; with `onSelectionChange` each row gets a checkbox. */
  selection?: ReadonlySet<string>;
  onSelectionChange?: (selection: Set<string>) => void;
  /** The checkbox's name for a row: «اختيار الطلب #10423». */
  rowLabel?: (row: Row) => string;
  /** Opens a row (its detail); Enter on a focused row too. */
  onRowOpen?: (row: Row) => void;
  loading?: boolean;
  /** Read by screen readers while loading. */
  loadingLabel?: string;
  /** Shown inside the table when there are no rows: an `EmptyState`. */
  empty?: ReactNode;
}

const SKELETON_ROWS = 3;

/** The panel's and portal's table (compact 40): sort, selection, loading and empty rows. */
export function DataTable<Row>(props: DataTableProps<Row>) {
  const { label, columns, rows, rowKey, sort, onSortChange, selection, onSelectionChange } = props;
  const { rowLabel, onRowOpen, loading = false, loadingLabel, empty } = props;
  const selectable = selection !== undefined && onSelectionChange !== undefined;
  const span = columns.length + (selectable ? 1 : 0);
  const toggle = (key: string) => {
    const next = new Set(selection);
    if (next.has(key)) next.delete(key);
    else next.add(key);
    onSelectionChange?.(next);
  };
  const sortBy = (key: string) =>
    onSortChange?.({
      key,
      direction: sort?.key === key && sort.direction === 'descending' ? 'ascending' : 'descending',
    });
  return (
    <div className="overflow-x-auto rounded-(--fd-data-table-radius) bg-(--fd-data-table-color-background) inset-ring-(length:--fd-data-table-border-width) inset-ring-(--fd-data-table-color-border)">
      <table aria-label={label} aria-busy={loading || undefined} className="w-full border-collapse">
        <thead>
          <tr>
            {selectable ? <th className={head({ numeric: false })} aria-hidden="true" /> : null}
            {columns.map((column) => {
              const sorted = sort?.key === column.key ? sort.direction : undefined;
              return (
                <th
                  key={column.key}
                  scope="col"
                  aria-sort={sorted}
                  className={head({ numeric: column.numeric ?? false })}
                >
                  {column.sortable && onSortChange ? (
                    <button
                      type="button"
                      onClick={() => sortBy(column.key)}
                      className={sortButton({ sorted: sorted !== undefined })}
                    >
                      {column.header}
                      <span
                        className={
                          sorted === 'ascending' ? 'inline-flex rotate-180' : 'inline-flex'
                        }
                      >
                        <Icon name="chevron-down" size="sm" />
                      </span>
                    </button>
                  ) : (
                    column.header
                  )}
                </th>
              );
            })}
          </tr>
        </thead>
        <tbody>
          {rows.map((item) => {
            const key = rowKey(item);
            const selected = selection?.has(key) ?? false;
            return (
              <tr
                key={key}
                aria-selected={selectable ? selected : undefined}
                onClick={onRowOpen ? () => onRowOpen(item) : undefined}
                onKeyDown={
                  // Enter on the row itself, not on a checkbox or a link in a cell.
                  onRowOpen
                    ? (event) =>
                        event.key === 'Enter' &&
                        event.target === event.currentTarget &&
                        onRowOpen(item)
                    : undefined
                }
                tabIndex={onRowOpen ? 0 : undefined}
                className={row({ selected, opens: onRowOpen !== undefined })}
              >
                {selectable ? (
                  <td className={cell({ numeric: false })}>
                    <input
                      type="checkbox"
                      aria-label={rowLabel?.(item)}
                      checked={selected}
                      onChange={() => toggle(key)}
                      onClick={(event) => event.stopPropagation()}
                      className="size-(--fd-input-check-size) cursor-pointer accent-(--fd-input-check-color-checked)"
                    />
                  </td>
                ) : null}
                {columns.map((column) => (
                  <td key={column.key} className={cell({ numeric: column.numeric ?? false })}>
                    {column.cell(item)}
                  </td>
                ))}
              </tr>
            );
          })}
          {loading
            ? Array.from({ length: SKELETON_ROWS }, (_, i) => (
                <tr key={i}>
                  {Array.from({ length: span }, (_, j) => (
                    <td key={j} className={cell({ numeric: false })}>
                      <span
                        aria-hidden="true"
                        className="block h-(--fd-data-table-loading-line-height) w-full rounded-(--fd-data-table-inner-radius) bg-(--fd-data-table-color-loading) motion-safe:animate-skeleton"
                      />
                    </td>
                  ))}
                </tr>
              ))
            : null}
          {!loading && rows.length === 0 && empty ? (
            <tr>
              <td colSpan={span} className="p-none">
                {empty}
              </td>
            </tr>
          ) : null}
        </tbody>
      </table>
      {loading && loadingLabel ? (
        <span role="status" className="sr-only">
          {loadingLabel}
        </span>
      ) : null}
    </div>
  );
}
