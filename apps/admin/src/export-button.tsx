import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  exportGaveUp,
  type StatementExport,
  useDownloadExport,
  useExportState,
} from './restaurant-statements.js';

// What asks an export: a mutation of the screen's own export route.
export interface ExportRequest {
  data: StatementExport | undefined;
  isPending: boolean;
  isError: boolean;
  ask: () => void;
}

// «تصدير Excel» (architecture §5.9): the worker writes the file, then
// «تنزيل» downloads it through a URL signed at the click. The screen stops
// waiting after EXPORT_WAIT_MS and lets the user ask again.
export function ExportButton({ request }: { request: ExportRequest }) {
  const { t } = useTranslation();
  const [startedAt, setStartedAt] = useState(0);
  const state = useExportState(request.data?.id, startedAt);
  const download = useDownloadExport();
  const current = state.data ?? request.data;
  const pending = current?.status === 'pending';
  // The last read past the wait ends the polling, so it also tells the giving up.
  const gaveUp = pending && exportGaveUp(startedAt, state.dataUpdatedAt);
  return (
    <>
      <button
        type="button"
        disabled={request.isPending || (pending && !gaveUp)}
        onClick={() => {
          setStartedAt(Date.now());
          request.ask();
        }}
      >
        {t('restaurantStatements.export')}
      </button>{' '}
      {request.isError || state.isError || download.isError || gaveUp ? (
        <span role="alert">{t('restaurantStatements.exportFailed')}</span>
      ) : request.isPending || pending ? (
        <span role="status">{t('restaurantStatements.exporting')}</span>
      ) : current?.status === 'ready' ? (
        <button
          type="button"
          disabled={download.isPending}
          onClick={() => download.mutate(current.id)}
        >
          {t('restaurantStatements.download', { name: current.fileName })}
        </button>
      ) : current?.status === 'expired' ? (
        <span>{t('restaurantStatements.exportExpired')}</span>
      ) : null}
    </>
  );
}
