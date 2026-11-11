import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  closedHowKeys,
  type NoAnswer,
  pingAnswerKeys,
  useWaitForCustomer,
  waitBody,
} from './order-no-answer.js';

// CA §9.9, AP §9.3.1 (slice 2.13d): the captain's pings at the door with the
// customer's answers, and each «الزبون لا يستجيب» with operations' «انتظر».
// Nothing before the first ping.
export function NoAnswerSection({
  noAnswer,
  time,
}: {
  noAnswer: NoAnswer;
  time: (at: string) => string;
}) {
  const { t } = useTranslation();
  const title = useId();
  if (noAnswer.pings.length === 0 && noAnswer.reports.length === 0) return null;
  return (
    <section aria-labelledby={title}>
      <h3 id={title}>{t('order.noAnswer.title')}</h3>
      <ul>
        {noAnswer.pings.map((ping) => (
          <li key={ping.at}>
            {t('order.noAnswer.ping', { time: time(ping.at) })}
            {ping.answer && ping.answeredAt && (
              <span>
                {' '}
                {t('order.noAnswer.answered', {
                  answer: t(pingAnswerKeys[ping.answer]),
                  time: time(ping.answeredAt),
                })}
              </span>
            )}
          </li>
        ))}
        {noAnswer.reports.map((report) => (
          <li key={report.at}>
            {t('order.noAnswer.reported', { time: time(report.at) })}
            {report.waitedAt && report.waitMessage && (
              <span>
                {' '}
                {t('order.noAnswer.waited', {
                  time: time(report.waitedAt),
                  message: report.waitMessage,
                })}
              </span>
            )}
            {report.closedHow && <span> {t(closedHowKeys[report.closedHow])}</span>}
          </li>
        ))}
      </ul>
    </section>
  );
}

// CA §9.9 «انتظر»: operations' message to the captain at the door; «زبون لا
// يرد» closes. The failed outcome stays «تحديد النتيجة» (owner decision
// 2026-11-11).
export function WaitForCustomer({ orderId }: { orderId: string }) {
  const { t } = useTranslation();
  const title = useId();
  const [message, setMessage] = useState('');
  const wait = useWaitForCustomer(orderId);
  const body = waitBody(message);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) wait.mutate(body);
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.noAnswer.waitTitle')}</h3>
      <p>{t('order.noAnswer.waitExplanation')}</p>
      <label>
        {t('order.noAnswer.message')}
        <textarea
          required
          maxLength={300}
          value={message}
          onChange={(event) => setMessage(event.target.value)}
        />
      </label>
      <button type="submit" disabled={wait.isPending || body === null}>
        {t('order.noAnswer.wait')}
      </button>
      {wait.isError && <p role="alert">{t('common.failed')}</p>}
      {wait.data?.status === 'refused' && <p role="alert">{t('order.noAnswer.nothingWaits')}</p>}
    </form>
  );
}
