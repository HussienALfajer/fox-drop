import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatDateTime, formatMoney } from './format.js';
import {
  type BulkForm,
  bulkBody,
  bulkFormOf,
  type BulkPreview,
  priceLogQuery,
  ticked,
  useApplyBulk,
  useBulkPreview,
} from './restaurant-menu-bulk.js';
import { CommandStatus } from './restaurant-menu-status.js';
import { type Menu, useMenuCommand } from './restaurant-menu.js';

// AP §9.6.6 «تعديل جماعي» (slice 2.31): the change, its before and after for
// every item in scope, then «تأكيد التعديل». The owners get one summary.
export function BulkPriceSection(props: { restaurantId: string; menu: Menu; currency: string }) {
  const { t } = useTranslation();
  const [form, setForm] = useState<BulkForm>(bulkFormOf());
  const [problem, setProblem] = useState(false);
  const preview = useBulkPreview(props.restaurantId);
  const apply = useApplyBulk(props.restaurantId);
  const change = (next: Partial<BulkForm>) => {
    setForm({ ...form, ...next });
    preview.reset();
    apply.reset();
  };
  const body = bulkBody(form, props.currency);
  const show = (event: FormEvent) => {
    event.preventDefault();
    if ('problem' in body) return setProblem(true);
    setProblem(false);
    apply.reset();
    preview.mutate(body);
  };
  const shown = preview.data?.status === 'done' ? preview.data.value : null;
  return (
    <section aria-label={t('menu.bulk.title')}>
      <h3>{t('menu.bulk.title')}</h3>
      <form onSubmit={show} aria-label={t('menu.bulk.title')}>
        <label>
          {t('menu.bulk.scope')}
          <select
            value={form.categoryId}
            onChange={(event) => change({ categoryId: event.target.value })}
          >
            <option value="">{t('menu.bulk.wholeMenu')}</option>
            {props.menu.categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('menu.bulk.direction')}
          <select
            value={form.direction}
            onChange={(event) => change({ direction: event.target.value as BulkForm['direction'] })}
          >
            <option value="up">{t('menu.bulk.up')}</option>
            <option value="down">{t('menu.bulk.down')}</option>
          </select>
        </label>
        <label>
          {t('menu.bulk.kind')}
          <select
            value={form.kind}
            onChange={(event) => change({ kind: event.target.value as BulkForm['kind'] })}
          >
            <option value="percent">{t('menu.bulk.percent')}</option>
            <option value="amount">{t('menu.bulk.amount', { currency: props.currency })}</option>
          </select>
        </label>
        <label>
          {t('menu.bulk.value')}
          <input
            inputMode="decimal"
            value={form.value}
            onChange={(event) => change({ value: event.target.value })}
          />
        </label>
        <button type="submit" disabled={preview.isPending}>
          {t('menu.bulk.preview')}
        </button>
        {problem && <p role="alert">{t('menu.bulk.problem')}</p>}
      </form>
      {preview.isPending && <p role="status">{t('status.loading')}</p>}
      {preview.isError && <p role="alert">{t('common.failed')}</p>}
      {preview.data?.status === 'refused' && <Refusal refusal={preview.data.refusal} />}
      {shown !== null && <PreviewTable preview={shown} />}
      {shown !== null && shown.changed > 0 && shown.refused === 0 && !('problem' in body) && (
        <button
          type="button"
          disabled={apply.isPending || apply.data?.status === 'done'}
          onClick={() => apply.mutate(body)}
        >
          {t('menu.bulk.confirm', { count: shown.changed })}
        </button>
      )}
      {apply.isPending && <p role="status">{t('drafts.saving')}</p>}
      {apply.isError && <p role="alert">{t('common.failed')}</p>}
      {apply.data?.status === 'refused' && <Refusal refusal={apply.data.refusal} />}
      {apply.data?.status === 'done' && (
        <p role="status">{t('menu.bulk.applied', { count: apply.data.value.changed })}</p>
      )}
    </section>
  );
}

function Refusal(props: { refusal: string }) {
  const { t } = useTranslation();
  return (
    <p role="alert">
      {t(`menu.refused.${props.refusal}` as 'menu.refused.invalid_menu', {
        defaultValue: t('drafts.refused.invalid'),
      })}
    </p>
  );
}

function PreviewTable(props: { preview: BulkPreview }) {
  const { t } = useTranslation();
  const { preview } = props;
  const money = (amount: string) => formatMoney({ amount, currency: preview.currency });
  return (
    <>
      <p>
        {t('menu.bulk.summary', {
          changed: preview.changed,
          unchanged: preview.unchanged,
          unit: money(preview.roundingUnit),
        })}
      </p>
      {preview.refused > 0 && (
        <p role="alert">{t('menu.bulk.refusedRows', { count: preview.refused })}</p>
      )}
      <table aria-label={t('menu.bulk.previewTable')}>
        <thead>
          <tr>
            <th>{t('menu.bulk.item')}</th>
            <th>{t('menu.bulk.before')}</th>
            <th>{t('menu.bulk.after')}</th>
          </tr>
        </thead>
        <tbody>
          {preview.rows.map((row) => (
            <tr key={row.itemId}>
              <td>{t('menu.bulk.itemCell', { code: row.code, name: row.name })}</td>
              <td>{money(row.before)}</td>
              <td>{row.after === null ? t('menu.bulk.reachesZero') : money(row.after)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  );
}

// AP §9.6.6 «توفر جماعي»: tick items, then switch them all on, or off «حتى
// الغد» or «حتى أعيده».
export function BulkAvailabilitySection(props: { restaurantId: string; menu: Menu }) {
  const { t } = useTranslation();
  const command = useMenuCommand(props.restaurantId);
  const [chosen, setChosen] = useState<Set<string>>(new Set());
  const order = props.menu.categories.flatMap((category) => category.items.map((item) => item.id));
  const itemIds = ticked(order, chosen);
  const switchAll = (available: boolean, until?: 'tomorrow' | 'turned_back_on') =>
    command.mutate(
      { kind: 'bulkAvailability', itemIds, available, ...(until ? { until } : {}) },
      { onSuccess: (result) => result.status === 'saved' && setChosen(new Set()) },
    );
  return (
    <section aria-label={t('menu.bulkAvailability.title')}>
      <h3>{t('menu.bulkAvailability.title')}</h3>
      {props.menu.categories.map((category) => (
        <fieldset key={category.id}>
          <legend>{category.name}</legend>
          {category.items.map((item) => (
            <label key={item.id}>
              <input
                type="checkbox"
                checked={chosen.has(item.id)}
                onChange={(event) => {
                  const next = new Set(chosen);
                  if (event.target.checked) next.add(item.id);
                  else next.delete(item.id);
                  setChosen(next);
                }}
              />
              {item.switchedOff === null
                ? item.name
                : t('menu.bulkAvailability.off', { name: item.name })}
            </label>
          ))}
        </fieldset>
      ))}
      <p>{t('menu.bulkAvailability.chosen', { count: itemIds.length })}</p>
      <button
        type="button"
        disabled={itemIds.length === 0 || command.isPending}
        onClick={() => switchAll(true)}
      >
        {t('menu.bulkAvailability.on')}
      </button>{' '}
      <button
        type="button"
        disabled={itemIds.length === 0 || command.isPending}
        onClick={() => switchAll(false, 'tomorrow')}
      >
        {t('menu.bulkAvailability.offTomorrow')}
      </button>{' '}
      <button
        type="button"
        disabled={itemIds.length === 0 || command.isPending}
        onClick={() => switchAll(false, 'turned_back_on')}
      >
        {t('menu.bulkAvailability.offUntilBack')}
      </button>
      <CommandStatus pending={command.isPending} failed={command.isError} result={command.data} />
    </section>
  );
}

// AP §9.6.6 «سجل الأسعار»: every price change, the newest first.
export function PriceLogSection(props: { restaurantId: string; timeZone: string }) {
  const { t } = useTranslation();
  const log = useQuery(priceLogQuery(props.restaurantId));
  return (
    <section aria-label={t('menu.priceLog.title')}>
      <h3>{t('menu.priceLog.title')}</h3>
      {log.isError && <p role="alert">{t('common.failed')}</p>}
      {log.data?.length === 0 && <p>{t('menu.priceLog.none')}</p>}
      {log.data && log.data.length > 0 && (
        <table aria-label={t('menu.priceLog.title')}>
          <thead>
            <tr>
              <th>{t('menu.priceLog.row')}</th>
              <th>{t('menu.bulk.before')}</th>
              <th>{t('menu.bulk.after')}</th>
              <th>{t('menu.priceLog.who')}</th>
              <th>{t('menu.priceLog.when')}</th>
            </tr>
          </thead>
          <tbody>
            {log.data.map((entry) => (
              <tr key={entry.id}>
                <td>
                  {entry.groupName === null
                    ? entry.name
                    : t('menu.priceLog.option', { group: entry.groupName, name: entry.name })}
                </td>
                <td>{formatMoney(entry.oldPrice)}</td>
                <td>{formatMoney(entry.newPrice)}</td>
                <td>
                  {entry.byName ?? t(`menu.priceLog.by.${entry.byType}`)}
                  {entry.byType === 'merchant' && ` · ${t('menu.priceLog.restaurant')}`}
                </td>
                <td>{formatDateTime(entry.at, props.timeZone)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}
