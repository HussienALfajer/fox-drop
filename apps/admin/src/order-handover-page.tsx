import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ineligibleKeys, pickerQuery, secondsLeft } from './assign-captain.js';
import { useServerNow } from './clock.js';
import { formatDistance, formatMoney } from './format.js';
import { type HandoverRefusal, handoverNote, useHandOver } from './order-handover.js';
import { vehicleKeys } from './order-labels.js';

const route = getRouteApi('/signed-in/orders/$orderId/handover');

const refusalKeys = {
  order_not_handoverable: 'handover.refused.orderNotHandoverable',
  captain_not_eligible: 'assign.refused.captainNotEligible',
  captain_has_offer: 'assign.refused.captainHasOffer',
  unknown_captain: 'assign.refused.unknownCaptain',
} as const satisfies Record<HandoverRefusal, string>;

// AP §9.3.2 «تسليم لكابتن آخر» (slice 2.12b), inside the order's detail: the
// required note, then the picker measured from the order's captain (the
// server leaves them out), each eligible captain with «تسليم إلى {الاسم}».
// The second captain goes to the first and confirms the receipt in the app.
export function OrderHandoverPage() {
  const { t } = useTranslation();
  const { orderId } = route.useParams();
  const picker = useQuery(pickerQuery(orderId));
  const handOver = useHandOver(orderId);
  const now = useServerNow();
  const [text, setText] = useState('');
  const note = handoverNote(text);
  const back = (
    <p>
      <Link to="/orders/$orderId" params={{ orderId }} search>
        {t('assign.back')}
      </Link>
    </p>
  );

  if (handOver.data && handOver.data.status !== 'refused') {
    return (
      <section aria-labelledby="handover-title">
        <h3 id="handover-title">{t('handover.title')}</h3>
        <p role="status">
          {handOver.data.status === 'offered'
            ? t('handover.offered', { seconds: secondsLeft(handOver.data.expiresAt, now) })
            : t('handover.assigned')}
        </p>
        {back}
      </section>
    );
  }

  return (
    <section aria-labelledby="handover-title">
      <h3 id="handover-title">{t('handover.title')}</h3>
      <p>{t('handover.explain')}</p>
      <label>
        {t('handover.note')}
        <textarea value={text} onChange={(event) => setText(event.target.value)} required />
      </label>
      {note === null && <p>{t('handover.noteRequired')}</p>}
      <button type="button" onClick={() => void picker.refetch()} disabled={picker.isFetching}>
        {t('assign.refresh')}
      </button>
      {handOver.data?.status === 'refused' && (
        <p role="alert">
          {t(refusalKeys[handOver.data.refusal])}
          {handOver.data.reasons.map((reason) => (
            <span key={reason}> {t(ineligibleKeys[reason])}</span>
          ))}
        </p>
      )}
      {handOver.isError && <p role="alert">{t('common.failed')}</p>}
      {picker.isError && <p role="alert">{t('status.error')}</p>}
      {picker.isPending ? (
        <p>{t('status.loading')}</p>
      ) : picker.data?.length === 0 ? (
        <p>{t('assign.none')}</p>
      ) : (
        <ul>
          {picker.data?.map((captain) => (
            <li key={captain.captainId} aria-disabled={!captain.eligible}>
              <h4>{captain.name}</h4>
              <p>{t(vehicleKeys[captain.vehicle])}</p>
              <p>
                {captain.etaMin === null
                  ? t('handover.distance', { distance: formatDistance(captain.distanceMetres) })
                  : t('handover.distanceEta', {
                      distance: formatDistance(captain.distanceMetres),
                      minutes: captain.etaMin,
                    })}
              </p>
              <p>{t('assign.ordersToday', { count: captain.ordersToday })}</p>
              <p>
                {t('assign.custody', {
                  usage: formatMoney(captain.custody.usage),
                  limit: formatMoney(captain.custody.limit),
                })}
              </p>
              {captain.eligible ? (
                <button
                  type="button"
                  onClick={() =>
                    note !== null && handOver.mutate({ captainId: captain.captainId, reason: note })
                  }
                  disabled={handOver.isPending || note === null}
                >
                  {t('handover.submit', { name: captain.name })}
                </button>
              ) : (
                <ul>
                  {captain.reasons.map((reason) => (
                    <li key={reason}>{t(ineligibleKeys[reason])}</li>
                  ))}
                </ul>
              )}
            </li>
          ))}
        </ul>
      )}
      {back}
    </section>
  );
}
