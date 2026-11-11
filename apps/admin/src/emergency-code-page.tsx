import { Link } from '@tanstack/react-router';
import type { FormEvent } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type EmergencyParty,
  type EmergencyRefusal,
  useIssueEmergencyCode,
} from './emergency-code.js';

const refusalKeys = {
  not_registered: 'emergencyCode.refused.notRegistered',
  contract_ended: 'emergencyCode.refused.contractEnded',
  restaurant_draft: 'emergencyCode.refused.restaurantDraft',
  restaurant_terminated: 'emergencyCode.refused.restaurantTerminated',
  active_order_elsewhere: 'emergencyCode.refused.activeOrderElsewhere',
  phone_invalid: 'emergencyCode.refused.phoneInvalid',
  reason_missing: 'emergencyCode.refused.reasonMissing',
} as const satisfies Record<EmergencyRefusal, string>;

// Times show in the city's zone, not the browser's: the operator reads the
// expiry out to the person. Azaz is the only city until the session carries
// one (the cities' default zone, `geo.cities.time_zone`).
const time = new Intl.DateTimeFormat('ar-u-nu-latn', {
  timeStyle: 'short',
  timeZone: 'Asia/Damascus',
});

// «رمز دخول طارئ» (architecture §8.3.5): after verifying the captain or the
// restaurant user by a phone call, operations read the code out to them.
export function EmergencyCodePage() {
  const { t } = useTranslation();
  const issue = useIssueEmergencyCode();

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    issue.mutate({
      party: String(form.get('party')) as EmergencyParty,
      phone: String(form.get('phone')),
      reason: String(form.get('reason')),
    });
  }

  if (issue.data?.status === 'issued') {
    return (
      <main>
        <h1>{t('emergencyCode.title')}</h1>
        <p>{t('emergencyCode.issued.readOut')}</p>
        <p>
          <output dir="ltr">{issue.data.code}</output>
        </p>
        <p>
          {t('emergencyCode.issued.expiresAt', {
            time: time.format(new Date(issue.data.expiresAt)),
          })}
        </p>
        <button type="button" onClick={() => issue.reset()}>
          {t('emergencyCode.issued.another')}
        </button>
        <p>
          <Link to="/">{t('common.home')}</Link>
        </p>
      </main>
    );
  }

  return (
    <main>
      <h1>{t('emergencyCode.title')}</h1>
      <p>{t('emergencyCode.explain')}</p>
      <form onSubmit={submit}>
        <fieldset>
          <legend>{t('emergencyCode.party')}</legend>
          <label>
            <input type="radio" name="party" value="captain" required />
            {t('emergencyCode.captain')}
          </label>
          <label>
            <input type="radio" name="party" value="merchant" required />
            {t('emergencyCode.merchant')}
          </label>
        </fieldset>
        <p>
          <label>
            {t('emergencyCode.phone')}
            <input name="phone" type="tel" dir="ltr" required maxLength={20} />
          </label>
        </p>
        <p>{t('emergencyCode.phoneHint')}</p>
        <p>
          <label>
            {t('emergencyCode.reason')}
            <textarea name="reason" required maxLength={500} />
          </label>
        </p>
        <button type="submit" disabled={issue.isPending}>
          {t('emergencyCode.submit')}
        </button>
      </form>
      {issue.data?.status === 'refused' && <p role="alert">{t(refusalKeys[issue.data.refusal])}</p>}
      {issue.isError && <p role="alert">{t('common.failed')}</p>}
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
    </main>
  );
}
