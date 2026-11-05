import { useQuery } from '@tanstack/react-query';
import { useTranslation } from 'react-i18next';
import { api } from './api.js';

export function StatusPage() {
  const { t } = useTranslation();
  const status = useQuery({
    queryKey: ['status'],
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/status');
      if (!data) throw new Error('The status request failed.');
      return data;
    },
  });

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
    </main>
  );
}
