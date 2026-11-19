import { Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Status } from './captain-activation-page.js';
import { type Application, reasonOf } from './captain-applications.js';
import {
  type Offboarding,
  settlementKeys,
  stepKeys,
  useOffboardingCommand,
} from './captain-offboarding.js';
import { CASH_DESK } from './cash-desk.js';
import { formatDateTime, formatMoney } from './format.js';
import { type AdminSession, can } from './session.js';

// AP §9.7.5, §9.7.2, C17 (slice 2.35b): «إنهاء التعاقد» on an activated
// captain's application, then the offboarding checklist down to «إغلاق
// الحساب». Unstyled until the design.
export function OffboardingSection(props: {
  application: Application;
  session: AdminSession;
  actions: ReadonlySet<string>;
  cityCode: string;
  timeZone: string;
}) {
  const { t } = useTranslation();
  const { application, actions } = props;
  if (application.stage !== 'active') return null;
  const offboarding = application.offboarding;
  return (
    <section aria-label={t('captainOffboarding.title')}>
      <h2>{t('captainOffboarding.title')}</h2>
      {offboarding === null ? (
        actions.has('terminate') && <TerminateForm applicationId={application.id} />
      ) : (
        <Checklist
          application={application}
          offboarding={offboarding}
          canAct={actions.has('close')}
          canSettle={can(props.session, CASH_DESK)}
          cityCode={props.cityCode}
          timeZone={props.timeZone}
        />
      )}
    </section>
  );
}

// The reason is required; a second press confirms, since the captain is
// suspended at once.
function TerminateForm({ applicationId }: { applicationId: string }) {
  const { t } = useTranslation();
  const [reason, setReason] = useState('');
  const [confirming, setConfirming] = useState(false);
  const command = useOffboardingCommand(applicationId);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    const typed = reasonOf(reason);
    if (typed === null) return;
    if (!confirming) {
      setConfirming(true);
      return;
    }
    command.mutate({ action: 'terminate', reason: typed });
  };
  return (
    <form onSubmit={submit} aria-label={t('captainOffboarding.terminate')}>
      <p>{t('captainOffboarding.explain')}</p>
      <label>
        {t('captainOffboarding.reason')}
        <textarea
          value={reason}
          maxLength={500}
          required
          onChange={(event) => {
            setReason(event.target.value);
            setConfirming(false);
          }}
        />
      </label>
      <button type="submit" disabled={command.isPending || reasonOf(reason) === null}>
        {confirming ? t('captainOffboarding.confirmTerminate') : t('captainOffboarding.terminate')}
      </button>
      <Status pending={command.isPending} failed={command.isError} result={command.data} />
    </form>
  );
}

function Checklist(props: {
  application: Application;
  offboarding: Offboarding;
  canAct: boolean;
  canSettle: boolean;
  cityCode: string;
  timeZone: string;
}) {
  const { t } = useTranslation();
  const { offboarding } = props;
  const command = useOffboardingCommand(props.application.id);
  const currency = props.application.activation.deposit.amount?.currency ?? null;
  const done = (ok: boolean) => (ok ? t('captainOffboarding.done') : t('captainOffboarding.open'));
  const open = offboarding.endedAt === null;
  return (
    <>
      <p>
        {t('captainOffboarding.terminatedLine', {
          day: formatDateTime(offboarding.terminatedAt, props.timeZone),
          by: offboarding.terminatedBy ?? t('captainApplications.dash'),
          reason: offboarding.reason,
        })}
      </p>
      {offboarding.earlyExit && <p role="alert">{t('captainOffboarding.earlyExit')}</p>}
      <ol>
        <li>
          {t('captainOffboarding.stepLabel', { step: t('captainOffboarding.step.kit') })}{' '}
          {offboarding.kitReturned === null
            ? t('captainOffboarding.open')
            : offboarding.kitReturned
              ? t('captainOffboarding.kitReturned')
              : t('captainOffboarding.kitNotReturned')}
          {props.canAct && open && offboarding.depositSettled === null && (
            <>
              {' '}
              <button
                type="button"
                disabled={command.isPending || offboarding.kitReturned === true}
                onClick={() => command.mutate({ action: 'return_kit', returned: true })}
              >
                {t('captainOffboarding.markReturned')}
              </button>{' '}
              <button
                type="button"
                disabled={command.isPending || offboarding.kitReturned === false}
                onClick={() => command.mutate({ action: 'return_kit', returned: false })}
              >
                {t('captainOffboarding.markNotReturned')}
              </button>
            </>
          )}
        </li>
        <li>
          {t('captainOffboarding.stepLabel', { step: t('captainOffboarding.step.custody') })}{' '}
          {done(offboarding.custodyZero)}
        </li>
        <li>
          {t('captainOffboarding.stepLabel', { step: t('captainOffboarding.step.earnings') })}{' '}
          {done(offboarding.earningsZero)}
        </li>
        <li>
          {t('captainOffboarding.stepLabel', { step: t('captainOffboarding.step.deposit') })}{' '}
          {offboarding.depositSettled !== null
            ? t(settlementKeys[offboarding.depositSettled])
            : offboarding.depositHeld === '0' || currency === null
              ? t('captainOffboarding.nothingHeld')
              : t('captainOffboarding.held', {
                  amount: formatMoney({ amount: offboarding.depositHeld, currency }),
                })}{' '}
          {props.canSettle && open && offboarding.depositHeld !== '0' && (
            <Link to="/cash-desk/deposits" search={{ city: props.cityCode }}>
              {t('captainOffboarding.toDesk')}
            </Link>
          )}
        </li>
        <li>
          {t('captainOffboarding.stepLabel', { step: t('captainOffboarding.step.close') })}{' '}
          {open
            ? t('captainOffboarding.open')
            : t('captainOffboarding.closedAt', {
                day: formatDateTime(offboarding.endedAt!, props.timeZone),
              })}
        </li>
      </ol>
      {open && offboarding.missing.length > 0 && (
        <>
          <p>{t('captainOffboarding.waitingFor')}</p>
          <ul>
            {offboarding.missing.map((step) => (
              <li key={step}>{t(stepKeys[step])}</li>
            ))}
          </ul>
        </>
      )}
      {props.canAct && open && (
        <button
          type="button"
          disabled={command.isPending || offboarding.missing.length > 0}
          onClick={() => command.mutate({ action: 'close' })}
        >
          {t('captainOffboarding.close')}
        </button>
      )}
      <Status pending={command.isPending} failed={command.isError} result={command.data} />
    </>
  );
}
