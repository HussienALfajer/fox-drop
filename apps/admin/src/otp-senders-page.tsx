import { useQuery } from '@tanstack/react-query';
import { Link, useRouteContext } from '@tanstack/react-router';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { SETTINGS_MANAGE } from './city-settings.js';
import { formatDateTime } from './format.js';
import {
  type SenderNumber,
  senderPoolQuery,
  statusChoices,
  useSenderCommand,
} from './otp-senders.js';
import { can } from './session.js';

// The counts and times are on Damascus's clock, as the server counts a day
// (architecture §8.3.3).
const POOL_ZONE = 'Asia/Damascus';

// AP §9.14 «أرقام إرسال الرموز» (OWN; slice 2.38a): each WhatsApp number that
// sends the sign-in codes with its state, today's counts and its cap, set
// active or standby and disabled here; a new number is paired with the
// server command (owner decision 2026-11-19). Unstyled until the design.
export function OtpSendersPage() {
  const { t } = useTranslation();
  const { session } = useRouteContext({ from: '/signed-in' });
  const pool = useQuery(senderPoolQuery);
  const manages = can(session, SETTINGS_MANAGE);
  return (
    <main>
      <h1>{t('otpSenders.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>{' '}
        <Link to="/settings" search={{ group: 'security' }}>
          {t('settings.title')}
        </Link>
      </p>
      <p>{t('otpSenders.explain')}</p>
      <p>{t('otpSenders.pairing')}</p>
      {pool.isError && <p role="alert">{t('common.failed')}</p>}
      {pool.data && (
        <>
          {pool.data.alerts.map((alert) => (
            <p key={alert.type} role="alert">
              {t(`otpSenders.alert.${alert.type}`)}
            </p>
          ))}
          {pool.data.numbers.length === 0 ? (
            <p>{t('otpSenders.none')}</p>
          ) : (
            <ul>
              {pool.data.numbers.map((number) => (
                <li key={number.id}>
                  <SenderRow number={number} manages={manages} />
                </li>
              ))}
            </ul>
          )}
        </>
      )}
    </main>
  );
}

function SenderRow({ number, manages }: { number: SenderNumber; manages: boolean }) {
  const { t } = useTranslation();
  const command = useSenderCommand();
  const [confirming, setConfirming] = useState(false);
  return (
    <section aria-label={number.phone}>
      <h2>
        <bdi dir="ltr">{number.phone}</bdi>
      </h2>
      <p>
        {t('otpSenders.state', { status: t(`otpSenders.status.${number.status}`) })}{' '}
        {t(number.connected ? 'otpSenders.connected' : 'otpSenders.notConnected')}
      </p>
      <p>{t('otpSenders.pairedAt', { at: formatDateTime(number.pairedAt, POOL_ZONE) })}</p>
      {number.stoppedAt !== null && (
        <p>{t('otpSenders.stoppedAt', { at: formatDateTime(number.stoppedAt, POOL_ZONE) })}</p>
      )}
      {number.throttledUntil !== null && (
        <p>
          {t('otpSenders.throttledUntil', {
            at: formatDateTime(number.throttledUntil, POOL_ZONE),
          })}
        </p>
      )}
      {number.warmup !== null && (
        <p>
          {t('otpSenders.warmup', {
            step: number.warmup.step,
            cap: number.warmup.cap,
            at: formatDateTime(number.warmup.nextStepAt, POOL_ZONE),
          })}
        </p>
      )}
      <p>
        {t('otpSenders.today', {
          sent: number.today.sent,
          failed: number.today.failed,
          delivered: number.today.delivered,
          read: number.today.read,
          cap: number.dailyCap,
        })}
      </p>
      {manages && (
        <p>
          {statusChoices(number).map((status) => (
            <button
              key={status}
              type="button"
              disabled={command.isPending}
              onClick={() => command.mutate({ kind: 'status', numberId: number.id, status })}
            >
              {t(`otpSenders.make.${status}`)}
            </button>
          ))}
          {confirming ? (
            <button
              type="button"
              disabled={command.isPending}
              onClick={() => command.mutate({ kind: 'disable', numberId: number.id })}
            >
              {t('otpSenders.confirmDisable')}
            </button>
          ) : (
            <button type="button" onClick={() => setConfirming(true)}>
              {t('otpSenders.disable')}
            </button>
          )}
        </p>
      )}
      {(number.status === 'disconnected' || number.status === 'banned') && (
        <p>{t('otpSenders.repair')}</p>
      )}
      {command.data?.status === 'refused' && (
        <p role="alert">{t(`otpSenders.refused.${command.data.refusal}`)}</p>
      )}
      {command.isError && <p role="alert">{t('common.failed')}</p>}
    </section>
  );
}
