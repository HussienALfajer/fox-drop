import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { use } from 'react';
import { useTranslation } from 'react-i18next';
import {
  absolute,
  accountQuery,
  balanceKind,
  pickupsTotal,
  receiptQuery,
  receiptsQuery,
  type Statement,
  type StatementLine,
  statementQuery,
  statementsQuery,
  type WeekLine,
  weekByDay,
} from './account.js';
import { ExportButton } from './export-button.js';
import { formatDateTime, formatDay, formatMoney, formatTime } from './format.js';
import { TimeZoneContext } from './live.js';

// RA §12, §17 (slice 2.45d): «الحساب», «الكشوف» and «الإيصالات», the app's
// on the same routes, read only; a terminated restaurant's owners keep them
// (RA §5.5). The statement prints to PDF from the browser and exports to
// Excel (owner decision 2026-11-20), its layout plain until the design.

function MoneyLinks() {
  const { t } = useTranslation();
  return (
    <nav data-print="hide">
      <Link to="/account">{t('account.title')}</Link>{' '}
      <Link to="/statements">{t('statements.title')}</Link>{' '}
      <Link to="/receipts">{t('receipts.title')}</Link>
    </nav>
  );
}

function Loading<T>({
  read,
  children,
}: {
  read: { isPending: boolean; isError: boolean; data: T | undefined };
  children: (data: T) => React.ReactNode;
}) {
  const { t } = useTranslation();
  if (read.isPending) return <p>{t('app.loading')}</p>;
  if (read.isError || read.data === undefined) return <p role="alert">{t('app.error')}</p>;
  return <>{children(read.data)}</>;
}

// An exception's words (RA §12.5): its cause, «تسوية يدوية: {السبب}» with
// the reason, and the order it is about.
function useExceptionText() {
  const { t } = useTranslation();
  return (line: {
    cause: StatementLine['cause'];
    reason: string | null;
    orderNumber: string | null;
  }) => {
    const label =
      line.cause === null
        ? t('account.entry')
        : line.cause === 'adjustment'
          ? t('account.adjustment', { reason: line.reason ?? '' })
          : t(`account.cause.${line.cause}`);
    return line.orderNumber === null
      ? label
      : `${label} — ${t('account.exceptionOrder', { number: line.orderNumber })}`;
  };
}

// «من قرّر» (RA §12.5): the staff member by name, else who posted it.
function useDecidedBy() {
  const { t } = useTranslation();
  const deciders: Record<NonNullable<StatementLine['decidedBy']>, string> = {
    admin: t('excel.statement.deciders.admin'),
    merchant: t('excel.statement.deciders.merchant'),
    captain: t('excel.statement.deciders.captain'),
    customer: t('excel.statement.deciders.customer'),
    system: t('excel.statement.deciders.system'),
  };
  return (line: { decidedBy: StatementLine['decidedBy']; decidedByName: string | null }) =>
    line.decidedBy === null
      ? null
      : t('account.decidedBy', { who: line.decidedByName ?? deciders[line.decidedBy] });
}

// «{البند}: {المبلغ} — يزيد المستحق عليك — من قرّر: …» (RA §12.5).
function useExceptionLine() {
  const { t } = useTranslation();
  const exception = useExceptionText();
  const decidedBy = useDecidedBy();
  return (
    line: Parameters<ReturnType<typeof useExceptionText>>[0] &
      Parameters<ReturnType<typeof useDecidedBy>>[0] & { amount: string | null },
    money: (amount: string) => string,
  ): string => {
    const amount = line.amount ?? '0';
    return [
      t('account.exceptionAmount', { label: exception(line), amount: money(absolute(amount)) }),
      amount.startsWith('-') ? t('account.lowers') : t('account.raises'),
      decidedBy(line),
    ]
      .filter((part) => part !== null)
      .join(t('app.separator'));
  };
}

export function AccountPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const read = useQuery(accountQuery);
  return (
    <main>
      <h1>{t('account.title')}</h1>
      <MoneyLinks />
      <Loading read={read}>
        {(account) => {
          const currency = account.currency ?? '';
          const money = (amount: string) => (currency ? formatMoney(amount, currency) : amount);
          const kind = balanceKind(account.balance);
          return (
            <>
              <section>
                <p>
                  {kind === 'owed'
                    ? t('account.owed', { amount: money(account.balance) })
                    : kind === 'credit'
                      ? t('account.credit', { amount: money(absolute(account.balance)) })
                      : t('account.settled')}
                </p>
                <p>{t('account.settlement', { date: formatDay(account.settlementDate) })}</p>
                {account.overdue && (
                  <p role="alert">
                    {t('account.overdue', {
                      amount: money(account.overdue.amount),
                      date: formatDay(account.overdue.statementDate),
                    })}
                  </p>
                )}
                {account.commissionBp !== null && (
                  <p>{t('account.commission', { rate: account.commissionBp / 100 })}</p>
                )}
                {account.nextCommission && (
                  <p>
                    {t('account.commissionChange', {
                      rate: account.nextCommission.rateBp / 100,
                      date: formatDateTime(account.nextCommission.from, timeZone),
                    })}
                  </p>
                )}
              </section>
              <section>
                <h2>
                  {t('account.today', {
                    amount: money(pickupsTotal(account.pickups)),
                    count: account.pickups.length,
                  })}
                </h2>
                <ul>
                  {account.pickups.map((pickup) => (
                    <li key={pickup.orderId}>
                      {t('account.pickup', {
                        number: pickup.orderNumber,
                        time: formatTime(pickup.at, timeZone),
                        captain: pickup.captainName ?? '',
                      })}{' '}
                      {pickup.lines
                        .map((line) => formatMoney(line.amount, line.currency))
                        .join(' + ')}
                    </li>
                  ))}
                </ul>
              </section>
              <section>
                <h2>{t('account.week')}</h2>
                {account.weekLines.length === 0 && <p>{t('account.weekEmpty')}</p>}
                {weekByDay(account.weekLines).map(({ day, lines }) => (
                  <section key={day}>
                    <h3>{formatDay(day)}</h3>
                    <ul>
                      {lines.map((line, index) => (
                        <li key={index}>
                          <WeekEntry line={line} money={money} />
                        </li>
                      ))}
                    </ul>
                  </section>
                ))}
              </section>
            </>
          );
        }}
      </Loading>
    </main>
  );
}

function WeekEntry({ line, money }: { line: WeekLine; money: (amount: string) => string }) {
  const { t } = useTranslation();
  const exceptionLine = useExceptionLine();
  if (line.kind === 'order') {
    return (
      <>
        {t('account.order', {
          number: line.orderNumber ?? '',
          amount: money(line.commission ?? '0'),
        })}
        {line.discountShare !== null && line.discountShare !== '0' && (
          <>
            {t('app.separator')}
            {t('account.orderDiscount', { amount: money(line.discountShare) })}
          </>
        )}
      </>
    );
  }
  const amount = line.amount ?? '0';
  if (line.kind === 'payment') {
    return amount.startsWith('-') ? (
      <>{t('account.payment', { amount: money(absolute(amount)) })}</>
    ) : (
      <>{t('account.payout', { amount: money(amount) })}</>
    );
  }
  return <>{exceptionLine(line, money)}</>;
}

export function StatementsPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const read = useQuery(statementsQuery);
  return (
    <main>
      <h1>{t('statements.title')}</h1>
      <MoneyLinks />
      <Loading read={read}>
        {(statements) =>
          statements.length === 0 ? (
            <p>{t('statements.none')}</p>
          ) : (
            <ul>
              {statements.map((statement) => (
                <li key={statement.id}>
                  <Link to="/statements/$statementId" params={{ statementId: statement.id }}>
                    {t('statements.summary', {
                      date: formatDateTime(statement.cutoff, timeZone),
                      amount: formatMoney(statement.totalDue, statement.currency),
                    })}
                  </Link>
                  {statement.status !== null &&
                    ` — ${t(`excel.statement.statuses.${statement.status}`)}`}
                </li>
              ))}
            </ul>
          )
        }
      </Loading>
    </main>
  );
}

export function StatementPage({ statementId }: { statementId: string }) {
  const { t } = useTranslation();
  const read = useQuery(statementQuery(statementId));
  return (
    <main>
      <MoneyLinks />
      <Loading read={read}>
        {(statement) =>
          statement === null ? (
            <p>{t('statements.notFound')}</p>
          ) : (
            <StatementSheet statement={statement} />
          )
        }
      </Loading>
    </main>
  );
}

function StatementSheet({ statement }: { statement: Statement }) {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const exceptionLine = useExceptionLine();
  const money = (amount: string) => formatMoney(amount, statement.currency);
  const orders = statement.lines.filter((line) => line.kind === 'order');
  const exceptions = statement.lines.filter((line) => line.kind === 'exception');
  const payments = statement.lines.filter((line) => line.kind === 'payment');
  const s = 'excel.statement';
  return (
    <>
      <h1>{t('statements.sheetTitle', { name: statement.restaurantName })}</h1>
      <p data-print="hide">
        <button type="button" onClick={() => window.print()}>
          {t('statements.print')}
        </button>
      </p>
      <ExportButton ask={{ kind: 'statement', body: { statementId: statement.id } }} />
      <p>
        {statement.periodFrom === null
          ? t('statements.periodFirst', { to: formatDateTime(statement.cutoff, timeZone) })
          : t('statements.period', {
              from: formatDateTime(statement.periodFrom, timeZone),
              to: formatDateTime(statement.cutoff, timeZone),
            })}
      </p>
      {statement.status !== null && (
        <p>
          {t('statements.status', { status: t(`${s}.statuses.${statement.status}`) })}
          {statement.status === 'partly_paid' &&
            ` — ${t('statements.unpaidPart', { amount: money(statement.unpaid) })}`}
        </p>
      )}
      <table>
        <tbody>
          <tr>
            <th scope="row">{t(`${s}.orders`)}</th>
            <td>{statement.orders}</td>
          </tr>
          {(
            [
              ['itemsValue', statement.itemsValue],
              ['commission', statement.commission],
              ['discountShare', statement.discountShare],
              ['exceptions', statement.exceptions],
              ['weekTotal', statement.weekTotal],
              ['previousDue', statement.previousDue],
              ['paid', statement.paid],
              ['earlierUnpaid', statement.earlierUnpaid],
              ['totalDue', statement.totalDue],
            ] as const
          ).map(([key, amount]) => (
            <tr key={key}>
              <th scope="row">{t(`${s}.${key}`)}</th>
              <td>{money(amount)}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <h2>{t(`${s}.orders`)}</h2>
      <ul>
        {orders.map((line, index) => (
          <li key={index}>
            {t('statements.orderLine', {
              number: line.orderNumber ?? '',
              commission: money(line.commission ?? '0'),
            })}
            {line.itemsValue !== null &&
              ` — ${t('statements.pickup', {
                amount: money(line.itemsValue),
                lines: (line.pickupLines ?? [])
                  .map((each) => formatMoney(each.amount, each.currency))
                  .join(' + '),
              })}`}
            {line.discountShare !== null &&
              line.discountShare !== '0' &&
              ` — ${t('account.orderDiscount', { amount: money(line.discountShare) })}`}
          </li>
        ))}
      </ul>
      <h2>{t('statements.exceptionsTitle')}</h2>
      {exceptions.length === 0 ? (
        <p>{t('statements.noExceptions')}</p>
      ) : (
        <ul>
          {exceptions.map((line, index) => (
            <li key={index}>{exceptionLine(line, money)}</li>
          ))}
        </ul>
      )}
      {payments.length > 0 && (
        <>
          <h2>{t('statements.paymentsTitle')}</h2>
          <ul>
            {payments.map((line, index) => (
              <li key={index}>
                {[
                  formatDateTime(line.at, timeZone),
                  (line.amount ?? '').startsWith('-')
                    ? t('account.payment', { amount: money(absolute(line.amount ?? '0')) })
                    : t('account.payout', { amount: money(line.amount ?? '0') }),
                ].join(t('app.separator'))}
              </li>
            ))}
          </ul>
        </>
      )}
      <p>{t(`${s}.sign`)}</p>
    </>
  );
}

export function ReceiptsPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const read = useQuery(receiptsQuery);
  return (
    <main>
      <h1>{t('receipts.title')}</h1>
      <MoneyLinks />
      <p>{t('receipts.safety')}</p>
      <Loading read={read}>
        {(receipts) =>
          receipts.length === 0 ? (
            <p>{t('receipts.none')}</p>
          ) : (
            <ul>
              {receipts.map((receipt) => (
                <li key={receipt.id}>
                  <Link to="/receipts/$receiptId" params={{ receiptId: receipt.id }}>
                    {t(
                      receipt.type === 'merchant_settlement'
                        ? 'receipts.payment'
                        : 'receipts.payout',
                      {
                        number: receipt.number,
                        amount: formatMoney(receipt.total, receipt.currency),
                      },
                    )}
                  </Link>
                  {t('app.separator')}
                  {formatDateTime(receipt.createdAt, timeZone)}
                </li>
              ))}
            </ul>
          )
        }
      </Loading>
    </main>
  );
}

export function ReceiptPage({ receiptId }: { receiptId: string }) {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const read = useQuery(receiptQuery(receiptId));
  return (
    <main>
      <MoneyLinks />
      <Loading read={read}>
        {(receipt) =>
          receipt === null ? (
            <p>{t('receipts.notFound')}</p>
          ) : (
            <>
              <h1>{t('receipts.number', { number: receipt.number })}</h1>
              <p>{formatDateTime(receipt.createdAt, timeZone)}</p>
              <p>{t('receipts.method', { method: t(`receipts.methods.${receipt.method}`) })}</p>
              {receipt.staffName !== null && (
                <p>{t('receipts.staff', { name: receipt.staffName })}</p>
              )}
              <ul>
                {receipt.lines.map((line) => (
                  <li key={line.currency}>
                    {line.currency === receipt.currency
                      ? formatMoney(line.amount, line.currency)
                      : t('receipts.lineBase', {
                          amount: formatMoney(line.amount, line.currency),
                          base: formatMoney(line.base, receipt.currency),
                        })}
                  </li>
                ))}
              </ul>
              <p>{t('receipts.total', { amount: formatMoney(receipt.total, receipt.currency) })}</p>
              {(
                [
                  ['dueBefore', receipt.dueBefore],
                  ['dueAfter', receipt.dueAfter],
                ] as const
              ).map(([key, due]) => (
                <p key={key}>
                  {t(`receipts.${key}`, {
                    due:
                      balanceKind(due) === 'owed'
                        ? t('receipts.dueOwed', { amount: formatMoney(due, receipt.currency) })
                        : balanceKind(due) === 'credit'
                          ? t('receipts.dueCredit', {
                              amount: formatMoney(absolute(due), receipt.currency),
                            })
                          : t('receipts.dueNone'),
                  })}
                </p>
              ))}
              <p>{t('receipts.safety')}</p>
            </>
          )
        }
      </Loading>
    </main>
  );
}
