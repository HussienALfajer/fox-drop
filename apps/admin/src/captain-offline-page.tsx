import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { releaseReason } from './captain-device.js';
import { canForceOffline, captainAvailabilityQuery, useForceOffline } from './captain-offline.js';

const stateKeys = {
  offline: 'forceOffline.state.offline',
  online_available: 'forceOffline.state.available',
  busy: 'forceOffline.state.busy',
  last_order: 'forceOffline.state.lastOrder',
  not_receiving_offers: 'forceOffline.state.noOffers',
  suspended: 'forceOffline.state.suspended',
} as const;

// AP §9.7.5 «فصل من الاتصال» (CA §7.6, K18): the captain's state, then a
// required reason the captain sees. With an active order the captain goes
// offline when it ends; tracking continues until then.
export function ForceOffline({ captainId }: { captainId: string }) {
  const { t } = useTranslation();
  const title = useId();
  const [note, setNote] = useState('');
  const state = useQuery(captainAvailabilityQuery(captainId));
  const force = useForceOffline(captainId);
  const reason = releaseReason(note);
  const shown = state.data ?? null;
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (reason === null) return;
    force.mutate(reason, { onSuccess: () => setNote('') });
  };
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h4 id={title}>{t('forceOffline.title')}</h4>
      {state.isError && <p role="alert">{t('status.error')}</p>}
      {shown && (
        <p>
          {t('forceOffline.stateIs', { state: t(stateKeys[shown.state]) })}
          {shown.state === 'last_order' && shown.lastOrderBy === 'forced' && (
            <> {t('forceOffline.afterOrder')}</>
          )}
        </p>
      )}
      {canForceOffline(shown) && (
        <>
          <p>{t('forceOffline.explain')}</p>
          <label>
            {t('forceOffline.reason')}
            <textarea
              required
              maxLength={500}
              value={note}
              onChange={(event) => setNote(event.target.value)}
            />
          </label>
          <button type="submit" disabled={force.isPending || reason === null}>
            {t('forceOffline.confirm')}
          </button>
        </>
      )}
      {force.isError && <p role="alert">{t('common.failed')}</p>}
      {force.data && (
        <p role="status">
          {force.data.state === 'last_order'
            ? t('forceOffline.doneAfterOrder')
            : t('forceOffline.done')}
        </p>
      )}
    </form>
  );
}
