import { useQuery } from '@tanstack/react-query';
import { type FormEvent, use, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { TimeZoneContext } from './live.js';
import { serverNow } from './clock.js';
import { formatDateTime, formatTime } from './format.js';
import { callLink, contactQuery } from './session.js';
import {
  type StatusCommand,
  controlsOf,
  holidayOf,
  stateLabel,
  statusQuery,
  useStatusCommand,
} from './status.js';

// RA §7.1–7.3, §10, §17: the status, pause, resume, busy mode and the
// holiday close, which work from the portal since they receive no order.
export function StatusPage() {
  const { t } = useTranslation();
  const status = useQuery(statusQuery);
  const contact = useQuery(contactQuery);
  const command = useStatusCommand();
  const timeZone = use(TimeZoneContext);
  const [refused, setRefused] = useState(false);

  if (status.isPending) return <p>{t('app.loading')}</p>;
  if (status.isError) return <p role="alert">{t('app.error')}</p>;
  if (status.data === 'terminated') return <p role="alert">{t('layout.terminated')}</p>;
  const data = status.data;
  const controls = controlsOf(data);
  const label = stateLabel(data);

  function run(next: StatusCommand) {
    setRefused(false);
    void command.mutateAsync(next).then((answer) => setRefused(answer.status === 'refused'));
  }

  return (
    <main>
      <h1>{t('status.title')}</h1>
      <p role="status">
        {label.key === 'busyMode'
          ? t('status.state.busyMode', { minutes: label.minutes })
          : label.key === 'holiday'
            ? label.until
              ? t('status.state.holiday', { date: formatDateTime(label.until, timeZone) })
              : t('status.state.holidayOpenEnded')
            : t(`status.state.${label.key}`)}
      </p>
      {data.state === 'paused' && data.stateUntil && (
        <p>{t('status.pauseEnds', { at: formatTime(data.stateUntil, timeZone) })}</p>
      )}
      {data.closesAt && <p>{t('status.closesAt', { at: formatTime(data.closesAt, timeZone) })}</p>}
      {data.opensAt && <p>{t('status.opensAt', { at: formatDateTime(data.opensAt, timeZone) })}</p>}
      {data.maxActiveOrders !== null && data.activeOrders !== null && (
        <p>
          {data.state === 'busy'
            ? t('status.limitReached', { count: data.maxActiveOrders })
            : t('status.activeOrders', { count: data.activeOrders, max: data.maxActiveOrders })}
        </p>
      )}
      {refused && <p role="alert">{t('status.refused')}</p>}
      {command.isError && <p role="alert">{t('app.error')}</p>}

      {controls.heldByOperations ? (
        <p>
          {t('status.heldByOperations')}{' '}
          {contact.data?.phone && (
            <a href={callLink(contact.data.phone)}>{t('status.callOperations')}</a>
          )}
        </p>
      ) : (
        <fieldset disabled={command.isPending}>
          <legend>{t('status.pause')}</legend>
          {controls.canPause &&
            data.pauseChoicesMin.map((minutes) => (
              <button key={minutes} type="button" onClick={() => run({ kind: 'pause', minutes })}>
                {t('status.pauseFor', { minutes })}
              </button>
            ))}
          {controls.canPause && (
            <button type="button" onClick={() => run({ kind: 'pause', minutes: null })}>
              {t('status.pauseUntilReopening')}
            </button>
          )}
          {controls.canResume && (
            <button type="button" onClick={() => run({ kind: 'resume' })}>
              {t('status.resume')}
            </button>
          )}
        </fieldset>
      )}

      <fieldset disabled={command.isPending || !controls.canBusyMode}>
        <legend>{t('status.busyMode')}</legend>
        {data.busyMode && (
          <p>
            {t('status.busyOn', {
              minutes: data.busyMode.extraMin,
              until: formatTime(data.busyMode.until, timeZone),
            })}
          </p>
        )}
        {data.busyExtraOptionsMin.map((extraMin) => (
          <button
            key={extraMin}
            type="button"
            aria-pressed={data.busyMode?.extraMin === extraMin}
            onClick={() => run({ kind: 'busy_mode', extraMin })}
          >
            {t('status.busyExtra', { minutes: extraMin })}
          </button>
        ))}
        {data.busyMode && (
          <button type="button" onClick={() => run({ kind: 'busy_mode', extraMin: null })}>
            {t('status.busyOff')}
          </button>
        )}
      </fieldset>

      <Holiday holiday={data.holiday} pending={command.isPending} run={run} />
    </main>
  );
}

function Holiday({
  holiday,
  pending,
  run,
}: {
  holiday: { startsAt: string; endsAt: string; message: string | null } | null;
  pending: boolean;
  run: (command: StatusCommand) => void;
}) {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const [from, setFrom] = useState('');
  const [to, setTo] = useState('');
  const [message, setMessage] = useState('');
  const [invalid, setInvalid] = useState(false);

  function submit(event: FormEvent) {
    event.preventDefault();
    const holidayClose = holidayOf({ from, to, message }, timeZone, serverNow());
    setInvalid(holidayClose === null);
    if (holidayClose) run({ kind: 'holiday', ...holidayClose });
  }

  return (
    <fieldset disabled={pending}>
      <legend>{t('status.holidayTitle')}</legend>
      {holiday ? (
        <>
          <p>
            {t('status.holidaySet', {
              from: formatDateTime(holiday.startsAt, timeZone),
              to: formatDateTime(holiday.endsAt, timeZone),
            })}
          </p>
          {holiday.message && (
            <p>{t('status.holidayMessageShown', { message: holiday.message })}</p>
          )}
          <button type="button" onClick={() => run({ kind: 'end_holiday' })}>
            {t('status.holidayEnd')}
          </button>
        </>
      ) : (
        <form onSubmit={submit}>
          <label>
            {t('status.holidayFrom')}
            <input type="datetime-local" value={from} onChange={(e) => setFrom(e.target.value)} />
          </label>
          <label>
            {t('status.holidayTo')}
            <input
              type="datetime-local"
              required
              value={to}
              onChange={(e) => setTo(e.target.value)}
            />
          </label>
          <label>
            {t('status.holidayMessage')}
            <input maxLength={100} value={message} onChange={(e) => setMessage(e.target.value)} />
          </label>
          {invalid && <p role="alert">{t('status.holidayInvalid')}</p>}
          <button type="submit">{t('status.holidayClose')}</button>
        </form>
      )}
    </fieldset>
  );
}
