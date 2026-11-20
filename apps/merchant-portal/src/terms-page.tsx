import { useQuery } from '@tanstack/react-query';
import { use, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { TimeZoneContext } from './live.js';
import { formatDateTime } from './format.js';
import { termsQuery, useAcceptTerms } from './terms.js';

// RA §4.10: the terms in force, accepted by the owner with «أوافق».
export function TermsPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const terms = useQuery(termsQuery);
  const accept = useAcceptTerms();
  const [outdated, setOutdated] = useState(false);

  if (terms.isPending) return <p>{t('app.loading')}</p>;
  if (terms.isError) return <p role="alert">{t('app.error')}</p>;
  const { version, body, publishedAt, pending } = terms.data;

  return (
    <main>
      <h1>{t('terms.title')}</h1>
      {pending && <p>{t('terms.newVersion')}</p>}
      <p>{t('terms.publishedAt', { date: formatDateTime(publishedAt, timeZone) })}</p>
      {body.split('\n').map((paragraph, index) => (
        <p key={index}>{paragraph}</p>
      ))}
      {outdated && <p role="alert">{t('terms.outdated')}</p>}
      {accept.isError && <p role="alert">{t('app.error')}</p>}
      {pending ? (
        <button
          type="button"
          disabled={accept.isPending}
          onClick={() =>
            void accept.mutateAsync(version).then((result) => setOutdated(result === 'outdated'))
          }
        >
          {t('terms.accept')}
        </button>
      ) : (
        <p>{t('terms.accepted')}</p>
      )}
    </main>
  );
}
