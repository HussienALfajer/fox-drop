import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type Paper, type Receipt, type ReceiptType, useReceipt } from './cash-desk.js';
import { citiesQuery } from './cities.js';
import { formatDateTime, formatMoney } from './format.js';
import './receipt-print.css';

const route = getRouteApi('/signed-in/cash-desk/receipts/$receiptId');

export const receiptTypeKeys = {
  captain_hand_in: 'cashDesk.receiptType.captain_hand_in',
  captain_reimbursement: 'cashDesk.receiptType.captain_reimbursement',
} as const satisfies Record<ReceiptType, string>;

const paperClasses = { thermal: 'paper-thermal', a4: 'paper-a4' } as const satisfies Record<
  Paper,
  string
>;

// AP §9.10.3: the receipt, printed on an 80 mm thermal roll or on A4. The
// print stylesheet only sets the paper and hides the rest of the page; the
// receipt's look waits for the design (owner decision 2026-11-12).
export function ReceiptPage() {
  const { t } = useTranslation();
  const { receiptId } = route.useParams();
  const receipt = useReceipt(receiptId);
  const cities = useQuery(citiesQuery);
  const [paper, setPaper] = useState<Paper>('thermal');

  function print(choice: Paper) {
    setPaper(choice);
    // After React has applied the paper's class.
    requestAnimationFrame(() => window.print());
  }

  const city = cities.data?.find((each) => each.id === receipt.data?.cityId);
  return (
    <main>
      <p className="no-print">
        <Link to="/cash-desk">{t('cashDesk.title')}</Link>
      </p>
      {receipt.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !receipt.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          <p className="no-print">
            <button type="button" onClick={() => print('thermal')}>
              {t('cashDesk.receipt.printThermal')}
            </button>{' '}
            <button type="button" onClick={() => print('a4')}>
              {t('cashDesk.receipt.printA4')}
            </button>
          </p>
          <ReceiptView receipt={receipt.data} timeZone={city.timeZone} paper={paper} />
        </>
      )}
    </main>
  );
}

function ReceiptView({
  receipt,
  timeZone,
  paper,
}: {
  receipt: Receipt;
  timeZone: string;
  paper: Paper;
}) {
  const { t } = useTranslation();
  return (
    <article
      className={['receipt', paperClasses[paper]].join(' ')}
      aria-labelledby="receipt-number"
    >
      <h1>{t('app.name')}</h1>
      <h2 id="receipt-number">{t('cashDesk.receipt.number', { number: receipt.number })}</h2>
      <p>{t(receiptTypeKeys[receipt.type])}</p>
      <p>{formatDateTime(receipt.createdAt, timeZone)}</p>
      <p>{t('cashDesk.receipt.captain', { name: receipt.captainName })}</p>
      <p>{t('cashDesk.receipt.cashier', { name: receipt.cashierName ?? '' })}</p>
      <table>
        <thead>
          <tr>
            <th scope="col">{t('cashDesk.currency')}</th>
            <th scope="col">{t('cashDesk.receipt.expected')}</th>
            <th scope="col">
              {receipt.type === 'captain_hand_in'
                ? t('cashDesk.receipt.received')
                : t('cashDesk.receipt.paid')}
            </th>
            <th scope="col">{t('cashDesk.receipt.remaining')}</th>
          </tr>
        </thead>
        <tbody>
          {receipt.lines.map((line) => (
            <tr key={line.currency}>
              <th scope="row">{line.currency}</th>
              <td>{formatMoney({ amount: line.expected, currency: line.currency })}</td>
              <td>{formatMoney({ amount: line.amount, currency: line.currency })}</td>
              <td>{formatMoney({ amount: line.remaining, currency: line.currency })}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </article>
  );
}
