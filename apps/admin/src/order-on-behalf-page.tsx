import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type ItemUntil,
  type OnBehalfChoices,
  type OnBehalfResult,
  prepTimeFits,
  rejectBody,
  type TooBusyStep,
  TOO_BUSY_PAUSE_MIN,
  useDecideOnBehalf,
} from './order-on-behalf.js';
import type { OrderDetail } from './order-detail.js';

// AP §9.3.2 «قبول نيابة عن المطعم» and «رفض نيابة عن المطعم», with the
// restaurant's own choices (RA §8.5, §8.6) and operations' required reason.
export function DecideOnBehalf({
  orderId,
  choices,
  lines,
}: {
  orderId: string;
  choices: OnBehalfChoices;
  lines: OrderDetail['lines'];
}) {
  const decide = useDecideOnBehalf(orderId);
  return (
    <>
      <AcceptForm choices={choices} decide={decide} />
      <RejectForm choices={choices} lines={lines} decide={decide} />
      <Outcome decide={decide} />
    </>
  );
}

type Decide = ReturnType<typeof useDecideOnBehalf>;

function AcceptForm({ choices, decide }: { choices: OnBehalfChoices; decide: Decide }) {
  const { t } = useTranslation();
  const { prepTime } = choices;
  const title = useId();
  const [minutes, setMinutes] = useState(prepTime.defaultMin);
  const [reason, setReason] = useState('');
  const fits = prepTimeFits(minutes, prepTime);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!fits || reason.trim() === '') return;
    decide.mutate({ kind: 'accept', body: { prepMin: minutes, reason: reason.trim() } });
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.onBehalf.acceptTitle')}</h3>
      <p>
        {prepTime.options.map((option) => (
          <button
            key={option}
            type="button"
            aria-pressed={minutes === option}
            onClick={() => setMinutes(option)}
          >
            {t('order.onBehalf.prepMinutes', { minutes: option })}
          </button>
        ))}
      </p>
      <label>
        {t('order.onBehalf.prepTime')}
        <input
          type="number"
          min={prepTime.floorMin}
          max={prepTime.ceilingMin}
          // Any whole minute within the limits, not only the chips' steps (RA §8.5).
          step={1}
          value={minutes}
          onChange={(event) => setMinutes(event.target.valueAsNumber)}
        />
      </label>
      {!fits && (
        <p role="alert">
          {t('order.onBehalf.prepOutOfRange', {
            floor: prepTime.floorMin,
            ceiling: prepTime.ceilingMin,
          })}
        </p>
      )}
      <label>
        {t('order.onBehalf.reason')}
        <textarea
          required
          maxLength={500}
          value={reason}
          onChange={(event) => setReason(event.target.value)}
        />
      </label>
      <button type="submit" disabled={decide.isPending || !fits || reason.trim() === ''}>
        {t('order.onBehalf.acceptConfirm')}
      </button>
    </form>
  );
}

function RejectForm({
  choices,
  lines,
  decide,
}: {
  choices: OnBehalfChoices;
  lines: OrderDetail['lines'];
  decide: Decide;
}) {
  const { t } = useTranslation();
  const title = useId();
  const [rejection, setRejection] = useState<string | null>(null);
  const [items, setItems] = useState<ReadonlyMap<string, ItemUntil>>(new Map());
  const [tooBusy, setTooBusy] = useState<TooBusyStep>({ kind: 'none' });
  const [reason, setReason] = useState('');
  const body = rejectBody({ rejection, items, tooBusy, reason });
  // An item ordered on several lines is offered once.
  const orderItems = [...new Map(lines.map((line) => [line.itemId, line.name]))];
  const setItem = (itemId: string, until: ItemUntil | null) => {
    const next = new Map(items);
    if (until === null) next.delete(itemId);
    else next.set(itemId, until);
    setItems(next);
  };
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (body) decide.mutate({ kind: 'reject', body });
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h3 id={title}>{t('order.onBehalf.rejectTitle')}</h3>
      <fieldset>
        {choices.rejectionReasons.map((choice) => (
          <label key={choice.code}>
            <input
              type="radio"
              name="rejection"
              checked={rejection === choice.code}
              onChange={() => setRejection(choice.code)}
            />
            {choice.label}
          </label>
        ))}
      </fieldset>
      {rejection === 'item_unavailable' && (
        <fieldset>
          <legend>{t('order.onBehalf.pickItems')}</legend>
          {orderItems.map(([itemId, name]) => {
            const until = items.get(itemId);
            return (
              <p key={itemId}>
                <label>
                  <input
                    type="checkbox"
                    checked={until !== undefined}
                    onChange={(event) => setItem(itemId, event.target.checked ? 'tomorrow' : null)}
                  />
                  {name}
                </label>
                {until !== undefined && (
                  <select
                    value={until}
                    onChange={(event) => setItem(itemId, event.target.value as ItemUntil)}
                  >
                    <option value="tomorrow">{t('order.onBehalf.untilTomorrow')}</option>
                    <option value="turned_back_on">{t('order.onBehalf.untilTurnedBackOn')}</option>
                  </select>
                )}
              </p>
            );
          })}
        </fieldset>
      )}
      {rejection === 'restaurant_closed' && <p>{t('order.onBehalf.closedNote')}</p>}
      {rejection === 'too_busy' && (
        <fieldset>
          <label>
            <input
              type="radio"
              name="too-busy"
              checked={tooBusy.kind === 'none'}
              onChange={() => setTooBusy({ kind: 'none' })}
            />
            {t('order.onBehalf.nothingElse')}
          </label>
          {choices.busyExtraOptionsMin.map((minutes) => (
            <label key={minutes}>
              <input
                type="radio"
                name="too-busy"
                checked={tooBusy.kind === 'busy' && tooBusy.minutes === minutes}
                onChange={() => setTooBusy({ kind: 'busy', minutes })}
              />
              {t('order.onBehalf.busyMode', { minutes })}
            </label>
          ))}
          <label>
            <input
              type="radio"
              name="too-busy"
              checked={tooBusy.kind === 'pause'}
              onChange={() => setTooBusy({ kind: 'pause' })}
            />
            {t('order.onBehalf.pause', { minutes: TOO_BUSY_PAUSE_MIN })}
          </label>
        </fieldset>
      )}
      <label>
        {t('order.onBehalf.reason')}
        <textarea
          required
          maxLength={500}
          value={reason}
          onChange={(event) => setReason(event.target.value)}
        />
      </label>
      <button type="submit" disabled={decide.isPending || body === null}>
        {t('order.onBehalf.rejectConfirm')}
      </button>
    </form>
  );
}

const refusalKeys = {
  order_state_changed: 'order.onBehalf.stateChanged',
  invalid_prep_time: 'order.onBehalf.invalidPrepTime',
  unknown_reason: 'order.onBehalf.refused',
  invalid_rejection: 'order.onBehalf.refused',
} as const satisfies Record<Extract<OnBehalfResult, { status: 'refused' }>['refusal'], string>;

function Outcome({ decide }: { decide: Decide }) {
  const { t } = useTranslation();
  if (decide.isError) return <p role="alert">{t('common.failed')}</p>;
  const result = decide.data;
  if (result?.status !== 'refused') return null;
  return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
}
