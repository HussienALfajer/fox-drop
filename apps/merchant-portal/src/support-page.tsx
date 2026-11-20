import { useQuery } from '@tanstack/react-query';
import { type FormEvent, use, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { boardQuery } from './board.js';
import { ContactLinks } from './contact-links.js';
import { formatDateTime } from './format.js';
import { TimeZoneContext } from './live.js';
import { photoRefusal, usePhotoUpload } from './menu.js';
import {
  type DataChangeSubject,
  type ReportAnswer,
  type Ticket,
  DATA_CHANGE_SUBJECTS,
  DATA_CHANGE_TYPE,
  NOTE_MAX,
  contentQuery,
  replyWithin,
  reportOf,
  reportsQuery,
  useSendReport,
} from './support.js';

// RA §15, §17 (slice 2.45c): «الدعم» as the app's: the team's call and
// WhatsApp, «إبلاغ عن مشكلة» (a type, optionally an order, a data change's
// subject, a note and a photo), «بلاغاتي» and the FAQ. `report` opens the
// form on a type, as «طلب تعديل» does from the settings; `order` on an
// order, as an order's page does (one of «السجل» too, slice 2.45d).
export function SupportPage({
  report,
  order,
}: {
  report?: string | undefined;
  order?: { id: string; number: string } | undefined;
}) {
  const { t } = useTranslation();
  const content = useQuery(contentQuery);

  return (
    <main>
      <h1>{t('support.title')}</h1>
      <p>
        <ContactLinks />
      </p>
      {content.isPending && <p>{t('app.loading')}</p>}
      {content.isError && <p role="alert">{t('support.typesFailed')}</p>}
      {content.data && (
        <ReportForm
          types={content.data.reasons.merchant_ticket_type}
          initialType={report ?? ''}
          initialOrder={order}
        />
      )}
      <MyReports />
      <section>
        <h2>{t('support.faq')}</h2>
        {content.data?.faq.map((entry, index) => (
          <details key={index}>
            <summary>{entry.question}</summary>
            <p>{entry.answer}</p>
          </details>
        ))}
      </section>
    </main>
  );
}

function ReportForm({
  types,
  initialType,
  initialOrder,
}: {
  types: { code: string; label: string; note: 'none' | 'optional' | 'required' }[];
  initialType: string;
  initialOrder: { id: string; number: string } | undefined;
}) {
  const { t } = useTranslation();
  const board = useQuery(boardQuery);
  const send = useSendReport();
  const within = useWithin();
  const photos = usePhotoUpload('report');
  const [typeCode, setType] = useState(
    types.some((each) => each.code === initialType) ? initialType : '',
  );
  const [subject, setSubject] = useState<DataChangeSubject | ''>('');
  const [orderId, setOrderId] = useState(initialOrder?.id ?? '');
  // The board's orders, and the one the page was opened on when it has left
  // the board.
  const orders = [
    ...(board.data ?? []).map((order) => ({ id: order.id, number: order.number })),
    ...(initialOrder && !board.data?.some((order) => order.id === initialOrder.id)
      ? [initialOrder]
      : []),
  ];
  const [note, setNote] = useState('');
  const [photo, setPhoto] = useState<File | null>(null);
  const [problem, setProblem] = useState<string | null>(null);
  const [sent, setSent] = useState<Ticket | null>(null);

  async function submit(event: FormEvent) {
    event.preventDefault();
    setProblem(null);
    setSent(null);
    const report = reportOf({ typeCode, subject, orderId, note }, types);
    if ('invalid' in report) {
      setProblem(`support.invalid.${report.invalid}`);
      return;
    }
    let photoUploadId: string | null = null;
    if (photo) {
      photoUploadId = await photos.upload.mutateAsync(photo);
      if (photoUploadId === null) {
        setProblem('support.refusal.photo');
        return;
      }
    }
    const answer: ReportAnswer = await send.mutateAsync({ ...report.body, photoUploadId });
    if (answer.status === 'sent') {
      setSent(answer.ticket);
      setType('');
      setSubject('');
      setOrderId('');
      setNote('');
      setPhoto(null);
      return;
    }
    if (answer.refusal === 'photo' && photo) photos.refused(photo, 'upload_');
    setProblem(`support.refusal.${answer.refusal}`);
  }

  const pending = send.isPending || photos.upload.isPending;
  return (
    <form onSubmit={(event) => void submit(event)}>
      <fieldset disabled={pending}>
        <legend>{t('support.report')}</legend>
        <label>
          {t('support.type')}
          <select required value={typeCode} onChange={(e) => setType(e.target.value)}>
            <option value="">{t('support.choose')}</option>
            {types.map((type) => (
              <option key={type.code} value={type.code}>
                {type.label}
              </option>
            ))}
          </select>
        </label>
        {typeCode === DATA_CHANGE_TYPE && (
          <label>
            {t('support.subject')}
            <select
              required
              value={subject}
              onChange={(e) => setSubject(e.target.value as DataChangeSubject | '')}
            >
              <option value="">{t('support.choose')}</option>
              {DATA_CHANGE_SUBJECTS.map((each) => (
                <option key={each} value={each}>
                  {t(`support.subjects.${each}`)}
                </option>
              ))}
            </select>
          </label>
        )}
        <label>
          {t('support.order')}
          <select value={orderId} onChange={(e) => setOrderId(e.target.value)}>
            <option value="">{t('support.noOrder')}</option>
            {orders.map((order) => (
              <option key={order.id} value={order.id}>
                {t('support.orderNumber', { number: order.number })}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('support.note')}
          <textarea maxLength={NOTE_MAX} value={note} onChange={(e) => setNote(e.target.value)} />
        </label>
        <label>
          {t('support.photo')}
          <input
            type="file"
            accept="image/jpeg,image/png,image/webp"
            onChange={(e) => {
              const file = e.target.files?.[0] ?? null;
              const refusal = file && photoRefusal(file);
              setProblem(refusal ? 'support.refusal.photoTooLarge' : null);
              setPhoto(refusal ? null : file);
            }}
          />
        </label>
        {problem && <p role="alert">{t(problem as 'support.refusal.other')}</p>}
        {(send.isError || photos.upload.isError) && (
          <p role="alert">{t('support.refusal.other')}</p>
        )}
        {sent && (
          <p role="status">
            {t('support.sent', {
              number: sent.number,
              within: within(sent.replyWithinMinutes),
            })}
          </p>
        )}
        <button type="submit">{t('support.send')}</button>
      </fieldset>
    </form>
  );
}

// «سنرد عليك خلال …» in hours or minutes.
function useWithin() {
  const { t } = useTranslation();
  return (minutes: number): string => {
    const time = replyWithin(minutes);
    return 'hours' in time
      ? t('support.withinHours', { count: time.hours })
      : t('support.withinMinutes', { count: time.minutes });
  };
}

function MyReports() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const reports = useQuery(reportsQuery);
  return (
    <section>
      <h2>{t('support.myReports')}</h2>
      {reports.isPending && <p>{t('app.loading')}</p>}
      {reports.isError && <p role="alert">{t('support.reportsFailed')}</p>}
      {reports.data?.length === 0 && <p>{t('support.noReports')}</p>}
      <ul>
        {reports.data?.map((ticket) => (
          <li key={ticket.id}>
            <strong>
              {t('support.ticketTitle', { number: ticket.number, type: ticket.typeLabel })}
            </strong>
            <p>
              {[
                t(`support.status.${ticket.status}`),
                formatDateTime(ticket.openedAt, timeZone),
                ticket.subject && t(`support.subjects.${ticket.subject}`),
                ticket.orderNumber && t('support.orderNumber', { number: ticket.orderNumber }),
                ticket.openedBy === 'restaurant' && t('support.byRestaurant'),
                ticket.openedBy === 'operations' && t('support.byOperations'),
              ]
                .filter(Boolean)
                .join(' · ')}
            </p>
            {ticket.description && <p>{ticket.description}</p>}
            {ticket.message && <p>{t('support.reply', { message: ticket.message })}</p>}
          </li>
        ))}
      </ul>
    </section>
  );
}
