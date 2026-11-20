import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  downloadUrl,
  type ExportAsk,
  exportGaveUp,
  type ExportRefusal,
  useExportState,
  useRequestExport,
} from './exports.js';

// RA §17: «تصدير Excel», then «تنزيل» once the server wrote the file; the
// file is kept 24 hours.
export function ExportButton({ ask }: { ask: ExportAsk | null }) {
  const { t } = useTranslation();
  const request = useRequestExport();
  const [asked, setAsked] = useState<{ id: string; at: number } | null>(null);
  const [refusal, setRefusal] = useState<ExportRefusal | null>(null);
  const [failed, setFailed] = useState(false);
  const state = useExportState(asked?.id, asked?.at ?? 0);
  const status = state.data?.status;
  // Judged at the last read, which stops once the wait is over.
  const gaveUp =
    asked !== null && status === 'pending' && exportGaveUp(asked.at, state.dataUpdatedAt);

  async function start() {
    if (ask === null) return;
    setRefusal(null);
    setFailed(false);
    try {
      const answer = await request.mutateAsync(ask);
      if (answer.status === 'refused') setRefusal(answer.refusal);
      else setAsked({ id: answer.export.id, at: Date.now() });
    } catch {
      setFailed(true);
    }
  }

  async function download() {
    if (asked === null) return;
    setFailed(false);
    try {
      const url = await downloadUrl(asked.id);
      if (url !== null) window.location.assign(url);
    } catch {
      setFailed(true);
    }
  }

  return (
    <p data-print="hide">
      <button
        type="button"
        disabled={ask === null || request.isPending || status === 'pending'}
        onClick={() => void start()}
      >
        {t('exports.ask')}
      </button>{' '}
      {asked !== null && status === 'pending' && !gaveUp && <span>{t('exports.pending')}</span>}
      {gaveUp && <span role="alert">{t('exports.gaveUp')}</span>}
      {status === 'ready' && (
        <button type="button" onClick={() => void download()}>
          {t('exports.download', { name: state.data?.fileName ?? '' })}
        </button>
      )}
      {status === 'expired' && <span>{t('exports.expired')}</span>}
      {refusal !== null && <span role="alert">{t(`exports.refusal.${refusal}`)}</span>}
      {(failed || state.isError) && <span role="alert">{t('exports.failed')}</span>}
    </p>
  );
}
