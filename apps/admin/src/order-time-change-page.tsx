import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import type { OrderDetail } from './order-detail.js';
import {
  addMinFits,
  type ChangeTimeRefusal,
  changeTimeBody,
  newPromisedAt,
  prepMoves,
  type TimeChange,
  timeChips,
  useChangeTime,
} from './order-time-change.js';

const refusalKeys = {
  order_state_changed: 'order.changeTime.stateChanged',
  invalid_time_change: 'order.changeTime.invalid',
} as const satisfies Record<ChangeTimeRefusal, string>;

// AP §9.3.2 «تعديل الوقت» (owner decision 2026-11-10): +5, +10, +15, +20 or
// a typed whole number of minutes up to the ceiling, the optional note, and
// the promised time now and after the change before the confirm.
export function ChangeTime({
  orderId,
  status,
  promisedAt,
  choices,
  time,
}: {
  orderId: string;
  status: OrderDetail['status'];
  promisedAt: string | null;
  choices: TimeChange;
  time: (at: string) => string;
}) {
  const { t } = useTranslation();
  const title = useId();
  const [minutes, setMinutes] = useState<number>(Number.NaN);
  const [note, setNote] = useState('');
  const change = useChangeTime(orderId);
  const { maxMin } = choices;
  const fits = addMinFits(minutes, maxMin);
  const body = changeTimeBody(minutes, maxMin, note);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!body) return;
    change.mutate(body, {
      onSuccess: (result) => {
        if (result.status !== 'done') return;
        setMinutes(Number.NaN);
        setNote('');
      },
    });
  };
  const result = change.data;
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.changeTime.title')}</h3>
      <p>{t(prepMoves(status) ? 'order.changeTime.prepMoves' : 'order.changeTime.promiseOnly')}</p>
      <p>
        {timeChips(maxMin).map((option) => (
          <button
            key={option}
            type="button"
            aria-pressed={minutes === option}
            onClick={() => setMinutes(option)}
          >
            {t('order.changeTime.chip', { minutes: option })}
          </button>
        ))}
      </p>
      <label>
        {t('order.changeTime.minutes')}
        <input
          type="number"
          min={1}
          max={maxMin}
          step={1}
          value={Number.isNaN(minutes) ? '' : minutes}
          onChange={(event) => setMinutes(event.target.valueAsNumber)}
        />
      </label>
      {!fits && !Number.isNaN(minutes) && (
        <p role="alert">{t('order.changeTime.outOfRange', { max: maxMin })}</p>
      )}
      {promisedAt && (
        <p aria-live="polite">
          {t('order.changeTime.current', { time: time(promisedAt) })}
          {fits && (
            <span>
              {' '}
              {t('order.changeTime.next', { time: time(newPromisedAt(promisedAt, minutes)) })}
            </span>
          )}
        </p>
      )}
      <label>
        {t('order.changeTime.note')}
        <textarea maxLength={500} value={note} onChange={(event) => setNote(event.target.value)} />
      </label>
      <button type="submit" disabled={change.isPending || body === null}>
        {t('order.changeTime.confirm')}
      </button>
      {change.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(refusalKeys[result.refusal])}</p>}
      {result?.status === 'done' && <p role="status">{t('order.changeTime.done')}</p>}
    </form>
  );
}
