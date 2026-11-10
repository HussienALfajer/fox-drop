import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  closeItemReportBody,
  type ItemReport,
  untilKeys,
  useCloseItemReport,
} from './order-item-report.js';

// RA §8.12, AP §9.3.1: the open item-unavailable report, its items with how
// long each is off, the restaurant's note and when it came.
export function ItemReportSection({
  report,
  time,
}: {
  report: ItemReport;
  time: (at: string) => string;
}) {
  const { t } = useTranslation();
  const title = useId();
  return (
    <section aria-labelledby={title}>
      <h3 id={title}>{t('order.alert.itemUnavailable')}</h3>
      <p>{t('order.itemReport.at', { time: time(report.at) })}</p>
      <ul>
        {report.items.map((item) => (
          <li key={item.itemId}>
            {t('order.itemReport.item', { name: item.name, until: t(untilKeys[item.until]) })}
          </li>
        ))}
      </ul>
      {report.note && <p>{report.note.label}</p>}
    </section>
  );
}

// AP §9.3.1 «item reported unavailable»: the timeline line's items, each
// with how long it is off, and the note's label.
export function ReportedItems({ report }: { report: Pick<ItemReport, 'items' | 'note'> }) {
  const { t } = useTranslation();
  const items = report.items
    .map((item) => t('order.itemReport.item', { name: item.name, until: t(untilKeys[item.until]) }))
    .join('، ');
  return (
    <span>
      {' '}
      {items}
      {report.note && <span> {report.note.label}</span>}
    </span>
  );
}

// AP §9.3.2 «إغلاق بلاغ صنف نفد»: closes the report without an edit, with
// operations' required reason; the menu stays as the restaurant left it.
export function CloseItemReport({ orderId }: { orderId: string }) {
  const { t } = useTranslation();
  const title = useId();
  const [reason, setReason] = useState('');
  const close = useCloseItemReport(orderId);
  const body = closeItemReportBody(reason);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) close.mutate(body);
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.itemReport.closeTitle')}</h3>
      <label>
        {t('order.onBehalf.reason')}
        <textarea
          required
          maxLength={500}
          value={reason}
          onChange={(event) => setReason(event.target.value)}
        />
      </label>
      <button type="submit" disabled={close.isPending || body === null}>
        {t('order.itemReport.closeConfirm')}
      </button>
      {close.isError && <p role="alert">{t('common.failed')}</p>}
      {close.data?.status === 'refused' && (
        <p role="alert">{t('order.itemReport.alreadyClosed')}</p>
      )}
    </form>
  );
}
