import { useTranslation } from 'react-i18next';
import { useServerStatus } from './status.js';

// The start page of a session that may not read the dashboard (slice 2.40
// opens it for the others): the server status; the pages are in the side
// menu (AP §7.1).
export function HomePage() {
  const { t } = useTranslation();
  const status = useServerStatus();
  return (
    <main>
      <h1>{t('app.name')}</h1>
      <p role="status">
        {status.isPending
          ? t('status.loading')
          : status.isError
            ? t('status.error')
            : t('status.ok')}
      </p>
      <p>{t('layout.start')}</p>
    </main>
  );
}
