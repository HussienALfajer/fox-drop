import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type CaptainProfile, captainOrdersQuery } from './captain-profile.js';
import {
  appealStateOf,
  canRecordViolation,
  type CaptainViolations,
  captainViolationsQuery,
  suggestedFor,
  typeKey,
  typeOfKey,
  useRecordViolation,
  VIOLATION_STEPS,
  type ViolationRefusal,
  type ViolationStep,
} from './captain-violations.js';
import type { City } from './cities.js';
import { formatDateTime } from './format.js';
import type { AdminSession } from './session.js';

const refusals = {
  unknown_reason: 'captainViolations.refusal.unknownReason',
  reason_note_required: 'captainViolations.refusal.noteRequired',
  reason_note_not_allowed: 'captainViolations.refusal.noteNotAllowed',
  unknown_order: 'captainViolations.refusal.unknownOrder',
  captain_terminated: 'captainViolations.refusal.terminated',
  no_contract: 'captainViolations.refusal.noContract',
  already_terminated: 'captainViolations.refusal.alreadyTerminated',
  offboarding_open: 'captainViolations.refusal.offboarding',
} as const satisfies Record<ViolationRefusal, string>;

// AP §9.7.5–9.7.6 (slice 2.36b): the captain's violations with their appeals,
// the status changes, and «تسجيل مخالفة» with the ladder's suggestion.
// Unstyled until the design.
export function ViolationsSection(props: {
  captain: CaptainProfile;
  city: City;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const { captain, city, session } = props;
  const violations = useQuery(captainViolationsQuery(captain.id));
  if (violations.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!violations.data) return <p role="status">{t('status.loading')}</p>;
  const data = violations.data;
  return (
    <>
      <h3>{t('captainViolations.title')}</h3>
      {data.violations.length === 0 ? (
        <p>{t('captainViolations.none')}</p>
      ) : (
        <ul aria-label={t('captainViolations.title')}>
          {data.violations.map((violation) => {
            const appeal = appealStateOf(violation);
            return (
              <li key={violation.id}>
                <p>
                  {t('captainViolations.line', {
                    time: formatDateTime(violation.recordedAt, city.timeZone),
                    type:
                      violation.typeNote === null
                        ? violation.typeLabel
                        : `${violation.typeLabel}: ${violation.typeNote}`,
                    step: t(`captainViolations.step.${violation.step}`),
                  })}
                  {violation.severe && ` ${t('captainViolations.severe')}`}
                </p>
                {violation.suggestedStep !== violation.step && (
                  <p>
                    {t('captainViolations.suggestedWas', {
                      step: t(`captainViolations.step.${violation.suggestedStep}`),
                    })}
                  </p>
                )}
                {violation.orderNumber !== null && (
                  <p>{t('captainViolations.order', { number: violation.orderNumber })}</p>
                )}
                {violation.suspendedUntil !== null && (
                  <p>
                    {t('captainViolations.suspendedUntil', {
                      time: formatDateTime(violation.suspendedUntil, city.timeZone),
                    })}
                  </p>
                )}
                <p>
                  {t('captainViolations.reasonBy', {
                    reason: violation.reason,
                    name: violation.recordedByName ?? t('profile.someone'),
                  })}
                </p>
                {violation.appeal !== null && (
                  <p>
                    {appeal !== 'none' && t(`captainViolations.appeal.${appeal}`)}{' '}
                    <Link
                      to="/tickets/$ticketId"
                      params={{ ticketId: violation.appeal.ticketId }}
                      search={{ city: city.code }}
                    >
                      {t('captainViolations.appeal.ticket')}
                    </Link>
                  </p>
                )}
              </li>
            );
          })}
        </ul>
      )}
      {canRecordViolation(session) && captain.status !== 'terminated' && (
        <RecordViolation captain={captain} violations={data} />
      )}
      <h3>{t('captainViolations.suspensions')}</h3>
      {data.suspensions.length === 0 ? (
        <p>{t('captainViolations.noSuspensions')}</p>
      ) : (
        <ul aria-label={t('captainViolations.suspensions')}>
          {data.suspensions.map((change) => (
            <li key={change.at}>
              {t(`captainViolations.statusLine.${change.status}`, {
                time: formatDateTime(change.at, city.timeZone),
                until:
                  change.until === null
                    ? t('captainViolations.furtherNotice')
                    : formatDateTime(change.until, city.timeZone),
                reason: change.reason ?? '',
                name: change.actorName ?? t('profile.someone'),
              })}
            </li>
          ))}
        </ul>
      )}
    </>
  );
}

function RecordViolation(props: { captain: CaptainProfile; violations: CaptainViolations }) {
  const { t } = useTranslation();
  const { captain, violations } = props;
  const orders = useQuery(captainOrdersQuery(captain.id));
  const record = useRecordViolation(captain.id);
  const [type, setType] = useState('');
  const [note, setNote] = useState('');
  const [step, setStep] = useState<ViolationStep | ''>('');
  const [orderId, setOrderId] = useState('');
  const [reason, setReason] = useState('');
  const { severe, code } = typeOfKey(type);
  const chosen = (severe ? violations.types.severe : violations.types.regular).find(
    (each) => each.code === code,
  );
  const suggested = suggestedFor(violations, severe);
  const confirmed: ViolationStep = step === '' ? suggested : step;
  const why = reason.trim();
  const typeNote = note.trim();
  const ready =
    chosen !== undefined && why !== '' && (chosen.note !== 'required' || typeNote !== '');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!ready) return;
    record.mutate(
      {
        severe,
        typeCode: chosen.code,
        typeNote: chosen.note === 'none' || typeNote === '' ? null : typeNote,
        step: confirmed,
        orderId: orderId === '' ? null : orderId,
        reason: why,
      },
      {
        onSuccess: (result) => {
          if (result.status === 'done') {
            setType('');
            setNote('');
            setStep('');
            setOrderId('');
            setReason('');
          }
        },
      },
    );
  };
  return (
    <form onSubmit={submit} aria-label={t('captainViolations.record')}>
      <h3>{t('captainViolations.record')}</h3>
      <label>
        {t('captainViolations.type')}
        <select
          value={type}
          onChange={(event) => {
            setType(event.target.value);
            setStep('');
          }}
        >
          <option value="">{t('captainViolations.choose')}</option>
          <optgroup label={t('captainViolations.regular')}>
            {violations.types.regular.map((each) => (
              <option key={each.code} value={typeKey(false, each.code)}>
                {each.label}
              </option>
            ))}
          </optgroup>
          <optgroup label={t('captainViolations.severeTypes')}>
            {violations.types.severe.map((each) => (
              <option key={each.code} value={typeKey(true, each.code)}>
                {each.label}
              </option>
            ))}
          </optgroup>
        </select>
      </label>
      {chosen !== undefined && chosen.note !== 'none' && (
        <label>
          {t('captainViolations.typeNote')}
          <input maxLength={300} value={note} onChange={(event) => setNote(event.target.value)} />
        </label>
      )}
      {chosen !== undefined && (
        <p>
          {t('captainViolations.suggestion', {
            step: t(`captainViolations.step.${suggested}`),
            days: violations.suggestion.windowDays,
          })}
        </p>
      )}
      <label>
        {t('captainViolations.step.label')}
        <select
          value={confirmed}
          onChange={(event) => setStep(event.target.value as ViolationStep)}
        >
          {VIOLATION_STEPS.map((each) => (
            <option key={each} value={each}>
              {t(`captainViolations.step.${each}`)}
            </option>
          ))}
        </select>
      </label>
      {confirmed === 'termination' && <p>{t('captainViolations.terminationExplain')}</p>}
      <label>
        {t('captainViolations.orderLabel')}
        <select value={orderId} onChange={(event) => setOrderId(event.target.value)}>
          <option value="">{t('captainViolations.noOrder')}</option>
          {(orders.data ?? []).map((order) => (
            <option key={order.id} value={order.id}>
              {t('captainViolations.order', { number: order.number })}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('captainProfile.reason')}
        <textarea
          maxLength={500}
          value={reason}
          onChange={(event) => setReason(event.target.value)}
        />
      </label>
      <button type="submit" disabled={record.isPending || !ready}>
        {t('captainViolations.confirm')}
      </button>
      {record.isError && <p role="alert">{t('common.failed')}</p>}
      {record.data?.status === 'refused' && <p role="alert">{t(refusals[record.data.refusal])}</p>}
    </form>
  );
}
