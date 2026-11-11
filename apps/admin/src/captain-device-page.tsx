import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  captainDeviceQuery,
  type ReleaseDeviceRefusal,
  releaseReason,
  useReleaseDevice,
} from './captain-device.js';

const refusalKeys = {
  no_device: 'releaseDevice.noDevice',
  unknown_captain: 'releaseDevice.unknownCaptain',
} as const satisfies Record<ReleaseDeviceRefusal, string>;

// AP §9.7.5 «تحرير الجهاز» (CA §4.9): the captain's signed-in phone and the
// time it signed in, then a required reason; the release signs that phone
// out, so the captain signs in on another one and continues the order.
export function ReleaseDevice({
  captainId,
  time,
}: {
  captainId: string;
  time: (at: string) => string;
}) {
  const { t } = useTranslation();
  const title = useId();
  const [note, setNote] = useState('');
  const device = useQuery(captainDeviceQuery(captainId));
  const release = useReleaseDevice(captainId);
  const reason = releaseReason(note);
  const shown = device.data ?? null;
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (reason === null || shown === null) return;
    release.mutate(
      { sessionId: shown.sessionId, reason },
      {
        onSuccess: (result) => {
          if (result.status === 'released') setNote('');
        },
      },
    );
  };
  const result = release.data;
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h4 id={title}>{t('releaseDevice.title')}</h4>
      {device.isError && <p role="alert">{t('status.error')}</p>}
      {device.isSuccess &&
        (shown ? (
          <p>{t('releaseDevice.signedIn', { time: time(shown.signedInAt) })}</p>
        ) : (
          <p>{t('releaseDevice.noDevice')}</p>
        ))}
      {shown && (
        <>
          <p>{t('releaseDevice.explain')}</p>
          <label>
            {t('releaseDevice.reason')}
            <textarea
              required
              maxLength={500}
              value={note}
              onChange={(event) => setNote(event.target.value)}
            />
          </label>
          <button type="submit" disabled={release.isPending || reason === null}>
            {t('releaseDevice.confirm')}
          </button>
        </>
      )}
      {release.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(refusalKeys[result.refusal])}</p>}
      {result?.status === 'released' && <p role="status">{t('releaseDevice.done')}</p>}
    </form>
  );
}
