import { type FormEvent, useId, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type ReleaseDeviceRefusal, releaseReason, useReleaseDevice } from './captain-device.js';

const refusalKeys = {
  no_device: 'releaseDevice.noDevice',
  unknown_captain: 'releaseDevice.unknownCaptain',
} as const satisfies Record<ReleaseDeviceRefusal, string>;

// AP §9.7.5 «تحرير الجهاز» (CA §4.9): signs the captain's phone out with a
// required reason, so they sign in on another phone and continue the order.
export function ReleaseDevice({ captainId }: { captainId: string }) {
  const { t } = useTranslation();
  const title = useId();
  const [note, setNote] = useState('');
  const release = useReleaseDevice(captainId);
  const reason = releaseReason(note);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (reason === null) return;
    release.mutate(reason, {
      onSuccess: (result) => {
        if (result.status === 'released') setNote('');
      },
    });
  };
  const result = release.data;
  return (
    <form onSubmit={submit} aria-labelledby={title} noValidate>
      <h4 id={title}>{t('releaseDevice.title')}</h4>
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
      {release.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(refusalKeys[result.refusal])}</p>}
      {result?.status === 'released' && <p role="status">{t('releaseDevice.done')}</p>}
    </form>
  );
}
