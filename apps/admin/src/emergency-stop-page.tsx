import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, type City, citiesQuery } from './cities.js';
import {
  type EmergencyStop,
  emergencyStopQuery,
  type EmergencyStopState,
  fillReason,
  useResumeEmergencyStop,
  useStartEmergencyStop,
} from './emergency-stop.js';
import { formatDateTime } from './format.js';

// AP §9.1.6 «الإيقاف الطارئ» (OWN, OPS): the dialog that starts it, or the
// stop as it is with «استئناف».
export function EmergencyStopPage() {
  const { t } = useTranslation();
  const cities = useQuery(citiesQuery);
  const city = cities.data && chosenCity(cities.data, undefined);
  const state = useQuery({ ...emergencyStopQuery(city?.id ?? ''), enabled: city !== undefined });
  return (
    <main>
      <h1>{t('emergencyStop.title')}</h1>
      <Link to="/">{t('common.home')}</Link>
      {!city || !state.data ? (
        <p role="status">
          {cities.isError || state.isError ? t('status.error') : t('status.loading')}
        </p>
      ) : state.data.stop ? (
        <ResumeForm city={city} stop={state.data.stop} />
      ) : (
        <StartForm city={city} defaults={state.data.defaults} />
      )}
    </main>
  );
}

function StartForm({ city, defaults }: { city: City; defaults: EmergencyStopState['defaults'] }) {
  const { t } = useTranslation();
  const start = useStartEmergencyStop(city.id, city.timeZone);
  const [delayNotice, setDelayNotice] = useState(defaults.delayNotice);
  const [customerReason, setCustomerReason] = useState('');

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    const text = (name: string) => String(form.get(name) ?? '').trim();
    start.mutate({
      internalReason: text('internalReason'),
      browseMessage: text('browseMessage'),
      delayNotice: delayNotice.trim(),
      customerReason: customerReason.trim(),
      resumeAt: text('resumeAt'),
    });
  }

  const refusal = start.data?.status === 'refused' ? start.data.refusal : null;
  return (
    <form onSubmit={submit}>
      <fieldset disabled={start.isPending}>
        <label>
          {t('emergencyStop.internalReason')}
          <textarea name="internalReason" required maxLength={500} />
        </label>
        <label>
          {t('emergencyStop.browseMessage')}
          <textarea
            name="browseMessage"
            required
            maxLength={500}
            defaultValue={defaults.browseMessage}
          />
        </label>
        <label>
          {t('emergencyStop.delayNotice')}
          <textarea
            name="delayNotice"
            required
            maxLength={500}
            value={delayNotice}
            onChange={(event) => setDelayNotice(event.target.value)}
          />
        </label>
        <label>
          {t('emergencyStop.customerReason')}
          <input
            name="customerReason"
            required
            maxLength={500}
            value={customerReason}
            onChange={(event) => setCustomerReason(event.target.value)}
          />
        </label>
        <p>
          {t('emergencyStop.preview', { text: fillReason(delayNotice, customerReason.trim()) })}
        </p>
        <label>
          {t('emergencyStop.resumeAt')}
          <input name="resumeAt" type="datetime-local" />
        </label>
        <button type="submit">{t('emergencyStop.start')}</button>
      </fieldset>
      {refusal && <p role="alert">{t(`emergencyStop.refusal.${refusal}`)}</p>}
      {start.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

function ResumeForm({ city, stop }: { city: City; stop: EmergencyStop }) {
  const { t } = useTranslation();
  const resume = useResumeEmergencyStop(city.id);
  const [sendBack, setSendBack] = useState(false);

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const text = String(new FormData(event.currentTarget).get('serviceBack') ?? '').trim();
    resume.mutate({ stopId: stop.id, serviceBack: sendBack ? text : null });
  }

  const refusal = resume.data?.status === 'refused' ? resume.data.refusal : null;
  return (
    <>
      <dl>
        <dt>{t('emergencyStop.startedAt')}</dt>
        <dd>{formatDateTime(stop.startedAt, city.timeZone)}</dd>
        <dt>{t('emergencyStop.internalReason')}</dt>
        <dd>{stop.internalReason}</dd>
        <dt>{t('emergencyStop.browseMessage')}</dt>
        <dd>{stop.browseMessage}</dd>
        <dt>{t('emergencyStop.delayNotice')}</dt>
        <dd>{fillReason(stop.delayNotice, stop.customerReason)}</dd>
        <dt>{t('emergencyStop.resumeAt')}</dt>
        <dd>
          {stop.resumeAt
            ? formatDateTime(stop.resumeAt, city.timeZone)
            : t('emergencyStop.noAutomaticResume')}
        </dd>
        <dt>{t('emergencyStop.attempts')}</dt>
        <dd>{stop.attempts}</dd>
      </dl>
      <form onSubmit={submit}>
        <fieldset disabled={resume.isPending}>
          <label>
            <input
              type="checkbox"
              checked={sendBack}
              onChange={(event) => setSendBack(event.target.checked)}
            />
            {t('emergencyStop.sendServiceBack')}
          </label>
          {sendBack && (
            <label>
              {t('emergencyStop.serviceBack')}
              <textarea name="serviceBack" required maxLength={500} />
            </label>
          )}
          <button type="submit">{t('emergencyStop.resume')}</button>
        </fieldset>
        {refusal && <p role="alert">{t(`emergencyStop.refusal.${refusal}`)}</p>}
        {resume.isError && <p role="alert">{t('common.failed')}</p>}
      </form>
    </>
  );
}
