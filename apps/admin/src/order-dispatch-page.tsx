import { useQuery } from '@tanstack/react-query';
import { useTranslation } from 'react-i18next';
import {
  dispatchLine,
  manualReasonKeys,
  offerKindKeys,
  offerStatusKeys,
  orderOffersQuery,
  useManualDispatch,
} from './order-dispatch.js';
import type { OrderCard } from './orders-board.js';

// AP §9.2.1, §9.12.6 (slice 2.15c): the dispatch state on the card and the
// detail while the order waits for a captain.
export function DispatchState({
  card,
}: {
  card: Pick<OrderCard, 'dispatch' | 'captain' | 'captainTrack' | 'status'>;
}) {
  const { t } = useTranslation();
  const line = dispatchLine(card);
  if (line === null) return null;
  if (line.kind === 'manual') return <p>{t(manualReasonKeys[line.reason])}</p>;
  if (line.kind === 'searching') return <p>{t('dispatch.searching')}</p>;
  return (
    <p>
      {line.of === null
        ? t('dispatch.offer', { offer: line.offer })
        : t('dispatch.offerOf', { offer: line.offer, of: line.of })}
    </p>
  );
}

// AP §9.3.2 «توزيع يدوي لهذا الطلب». Once done, the detail read again hides
// the button and its dispatch line says the move.
export function MoveToManual({ orderId }: { orderId: string }) {
  const { t } = useTranslation();
  const move = useManualDispatch(orderId);
  const result = move.data;
  return (
    <section>
      <p>
        <button type="button" disabled={move.isPending} onClick={() => move.mutate()}>
          {t('dispatch.move')}
        </button>
      </p>
      <p>{t('dispatch.moveNote')}</p>
      {move.isError && <p role="alert">{t('status.error')}</p>}
      {result?.status === 'refused' && (
        <p role="alert">{t(`dispatch.refused.${result.refusal}`)}</p>
      )}
    </section>
  );
}

// AP §9.3.1, §9.7.4: each offer of the order with its captain, its kind,
// its answer and the response time.
export function OffersLog({
  orderId,
  cityId,
  time,
}: {
  orderId: string;
  cityId: string;
  time: (at: string) => string;
}) {
  const { t } = useTranslation();
  const offers = useQuery(orderOffersQuery(orderId, cityId));
  return (
    <section>
      <h4>{t('dispatch.offers.title')}</h4>
      {offers.isError && <p role="alert">{t('status.error')}</p>}
      {offers.data?.length === 0 && <p>{t('dispatch.offers.empty')}</p>}
      {offers.data && offers.data.length > 0 && (
        <ul>
          {offers.data.map((offer) => (
            <li key={offer.id}>
              {[
                t('dispatch.offers.line', {
                  time: time(offer.offeredAt),
                  captain: offer.captain.name,
                  kind: t(offerKindKeys[offer.kind]),
                  status: t(offerStatusKeys[offer.status]),
                }),
                offer.responseSec !== null &&
                  t('dispatch.offers.response', { seconds: offer.responseSec }),
                offer.handover && t('dispatch.offers.handover'),
              ]
                .filter(Boolean)
                .join(' ')}
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
