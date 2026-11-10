import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import {
  type AssignRefusal,
  ineligibleKeys as reasonKeys,
  pickerQuery,
  secondsLeft,
  useAssignCaptain,
} from './assign-captain.js';
import { useServerNow } from './clock.js';
import { formatDistance, formatMoney } from './format.js';
import { vehicleKeys } from './order-labels.js';

const route = getRouteApi('/signed-in/orders/$orderId/assign');

const refusalKeys = {
  order_not_assignable: 'assign.refused.orderNotAssignable',
  captain_not_eligible: 'assign.refused.captainNotEligible',
  captain_has_offer: 'assign.refused.captainHasOffer',
  unknown_captain: 'assign.refused.unknownCaptain',
} as const satisfies Record<AssignRefusal, string>;

// AP §9.3.2's assignment picker, inside the order's detail: the online
// captains nearest the restaurant first, the ineligible ones greyed out with
// their reasons, and «تعيين». After an offer the detail's own reads show
// whether the captain accepted (the track and the timeline).
export function AssignCaptainPage() {
  const { t } = useTranslation();
  const { orderId } = route.useParams();
  const picker = useQuery(pickerQuery(orderId));
  const assign = useAssignCaptain(orderId);
  const now = useServerNow();
  const back = (
    <p>
      <Link to="/orders/$orderId" params={{ orderId }} search>
        {t('assign.back')}
      </Link>
    </p>
  );

  if (assign.data && assign.data.status !== 'refused') {
    return (
      <section aria-labelledby="assign-title">
        <h3 id="assign-title">{t('assign.title')}</h3>
        <p role="status">
          {assign.data.status === 'offered'
            ? t('assign.offered', { seconds: secondsLeft(assign.data.expiresAt, now) })
            : t('assign.assigned')}
        </p>
        {back}
      </section>
    );
  }

  return (
    <section aria-labelledby="assign-title">
      <h3 id="assign-title">{t('assign.title')}</h3>
      <button type="button" onClick={() => void picker.refetch()} disabled={picker.isFetching}>
        {t('assign.refresh')}
      </button>
      {assign.data?.status === 'refused' && (
        <p role="alert">
          {t(refusalKeys[assign.data.refusal])}
          {assign.data.reasons.map((reason) => (
            <span key={reason}> {t(reasonKeys[reason])}</span>
          ))}
        </p>
      )}
      {assign.isError && <p role="alert">{t('common.failed')}</p>}
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
                  ? t('assign.distance', { distance: formatDistance(captain.distanceMetres) })
                  : t('assign.distanceEta', {
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
              <p>
                {captain.acceptanceRate === null
                  ? t('assign.noAcceptanceRate')
                  : t('assign.acceptanceRate', { rate: captain.acceptanceRate })}
              </p>
              {captain.eligible ? (
                <button
                  type="button"
                  onClick={() => assign.mutate(captain.captainId)}
                  disabled={assign.isPending}
                >
                  {t('assign.submit', { name: captain.name })}
                </button>
              ) : (
                <ul>
                  {captain.reasons.map((reason) => (
                    <li key={reason}>{t(reasonKeys[reason])}</li>
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
