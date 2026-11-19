import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import {
  importable,
  importFileProblem,
  type ImportPlan,
  useDryRun,
  useImport,
  useTemplate,
} from './restaurant-menu-import.js';

// AP §9.6.6 «استيراد من Excel» (slice 2.31): download the template (filled
// with the menu), upload it, read the validation report and what would be
// added, changed or left alone, then «تنفيذ الاستيراد». Nothing is deleted.
export function MenuImportSection(props: { restaurantId: string; currency: string }) {
  const { t } = useTranslation();
  const template = useTemplate(props.restaurantId);
  const dryRun = useDryRun(props.restaurantId);
  const commit = useImport(props.restaurantId);
  const [problem, setProblem] = useState<string | null>(null);
  const download = () =>
    template.mutate(undefined, {
      onSuccess: ({ fileName, blob }) => {
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = fileName;
        link.click();
        URL.revokeObjectURL(link.href);
      },
    });
  const report = dryRun.data?.status === 'report' ? dryRun.data : null;
  return (
    <section aria-label={t('menu.import.title')}>
      <h3>{t('menu.import.title')}</h3>
      <p>{t('menu.import.explain')}</p>
      <button type="button" onClick={download} disabled={template.isPending}>
        {t('menu.import.template')}
      </button>
      {template.isError && <p role="alert">{t('common.failed')}</p>}
      <label>
        {t('menu.import.file')}
        <input
          type="file"
          accept=".xlsx"
          onChange={(event) => {
            const file = event.target.files?.[0];
            event.target.value = '';
            if (!file) return;
            const found = importFileProblem(file);
            setProblem(found);
            commit.reset();
            if (found === null) dryRun.mutate(file);
          }}
        />
      </label>
      {problem !== null && (
        <p role="alert">{t(`menu.import.problem.${problem}` as 'menu.import.problem.type')}</p>
      )}
      {dryRun.isPending && <p role="status">{t('menu.import.checking')}</p>}
      {dryRun.isError && <p role="alert">{t('common.failed')}</p>}
      {dryRun.data?.status === 'refused' && <ImportRefusal refusal={dryRun.data.refusal} />}
      {report !== null && <ImportReport plan={report.plan} currency={props.currency} />}
      {report !== null && importable(report.plan) && commit.data?.status !== 'done' && (
        <button
          type="button"
          disabled={commit.isPending}
          onClick={() => commit.mutate(report.uploadId)}
        >
          {t('menu.import.commit')}
        </button>
      )}
      {commit.isPending && <p role="status">{t('drafts.saving')}</p>}
      {commit.isError && <p role="alert">{t('common.failed')}</p>}
      {commit.data?.status === 'refused' && <ImportRefusal refusal={commit.data.refusal} />}
      {commit.data?.status === 'done' && (
        <p role="status">{t('menu.import.done', { ...commit.data.result })}</p>
      )}
    </section>
  );
}

function ImportRefusal(props: { refusal: string }) {
  const { t } = useTranslation();
  return (
    <p role="alert">
      {t(`menu.import.refused.${props.refusal}` as 'menu.import.refused.import_invalid', {
        defaultValue: t(`menu.refused.${props.refusal}` as 'menu.refused.invalid_menu', {
          defaultValue: t('drafts.refused.invalid'),
        }),
      })}
    </p>
  );
}

function ImportReport(props: { plan: ImportPlan; currency: string }) {
  const { t } = useTranslation();
  const { plan } = props;
  const money = (amount: string) => formatMoney({ amount, currency: props.currency });
  if (plan.fileError !== null) {
    return <p role="alert">{t(`menu.import.fileError.${plan.fileError}`)}</p>;
  }
  return (
    <>
      <p>
        {t('menu.import.summary', {
          added: plan.added.length,
          changed: plan.changed.length,
          unchanged: plan.unchanged,
        })}
      </p>
      {plan.errors.length > 0 && (
        <table aria-label={t('menu.import.errors')}>
          <thead>
            <tr>
              <th>{t('menu.import.row')}</th>
              <th>{t('menu.import.column')}</th>
              <th>{t('menu.import.error')}</th>
            </tr>
          </thead>
          <tbody>
            {plan.errors.map((error) => (
              <tr key={[error.row, error.column].join()}>
                <td>{t('menu.import.rowNumber', { row: error.row })}</td>
                <td>{t(`menu.import.columns.${error.column}`)}</td>
                <td>{t(`menu.import.rowError.${error.error}`)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {plan.categoriesAdded.length > 0 && (
        <p>{t('menu.import.newCategories', { names: plan.categoriesAdded.join('، ') })}</p>
      )}
      {plan.added.length > 0 && (
        <table aria-label={t('menu.import.added')}>
          <thead>
            <tr>
              <th>{t('menu.import.row')}</th>
              <th>{t('menu.bulk.item')}</th>
              <th>{t('menu.import.price')}</th>
            </tr>
          </thead>
          <tbody>
            {plan.added.map((row) => (
              <tr key={row.row}>
                <td>{t('menu.import.rowNumber', { row: row.row })}</td>
                <td>
                  {t('menu.import.addedItem', {
                    code: row.code ?? t('menu.import.generated'),
                    name: row.name,
                    category: row.categoryName,
                  })}
                </td>
                <td>{money(row.price)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      {plan.changed.length > 0 && (
        <table aria-label={t('menu.import.changed')}>
          <thead>
            <tr>
              <th>{t('menu.import.row')}</th>
              <th>{t('menu.bulk.item')}</th>
              <th>{t('menu.import.fields')}</th>
              <th>{t('menu.import.price')}</th>
            </tr>
          </thead>
          <tbody>
            {plan.changed.map((row) => (
              <tr key={row.row}>
                <td>{t('menu.import.rowNumber', { row: row.row })}</td>
                <td>{t('menu.bulk.itemCell', { code: row.code, name: row.name })}</td>
                <td>{row.fields.map((field) => t(`menu.import.field.${field}`)).join('، ')}</td>
                <td>
                  {row.fields.includes('price')
                    ? t('menu.import.priceChange', {
                        before: money(row.oldPrice),
                        after: money(row.price),
                      })
                    : money(row.price)}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </>
  );
}
