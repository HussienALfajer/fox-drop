import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { type FormEvent, use, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatDateTime, formatMoney } from './format.js';
import { TimeZoneContext } from './live.js';
import { AvailabilityControl, PriceForm } from './menu-forms.js';
import {
  type BulkBody,
  type BulkForm,
  type BulkPreview,
  bulkBody,
  menuCurrency,
  menuQuery,
  previewQuery,
  priceLogQuery,
  quickRows,
  refusalKey,
  timeOfMinute,
  useApplyBulk,
  useBulkPreview,
} from './menu.js';

// RA §9.4, §9.6, §9.7 (slice 2.45b): «تعديل سريع», «تعديل جماعي للأسعار»,
// «سجل الأسعار» and «معاينة كما يراها الزبون» in the portal. Unstyled until
// the design.

function BackToMenu() {
  const { t } = useTranslation();
  return <Link to="/menu">{t('menu.back')}</Link>;
}

// RA §9.6: every item and option with its price and switch, searched by
// name and filtered by category.
export function QuickEditPage() {
  const { t } = useTranslation();
  const menu = useQuery(menuQuery);
  const [query, setQuery] = useState('');
  const [categoryId, setCategoryId] = useState('');
  const [editing, setEditing] = useState<string | null>(null);

  if (menu.isPending) return <p>{t('app.loading')}</p>;
  if (menu.isError) return <p role="alert">{t('menu.failed')}</p>;
  if (menu.data === 'terminated') return <p role="alert">{t('menu.refusal.terminated')}</p>;
  const rows = quickRows(menu.data, query, categoryId);

  return (
    <main>
      <h1>{t('menu.quickEdit')}</h1>
      <BackToMenu />
      <p>
        <label>
          {t('menu.search')}
          <input type="search" value={query} onChange={(e) => setQuery(e.target.value)} />
        </label>{' '}
        <label>
          {t('menu.category')}
          <select value={categoryId} onChange={(e) => setCategoryId(e.target.value)}>
            <option value="">{t('menu.allCategories')}</option>
            {menu.data.categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </label>
      </p>
      {rows.length === 0 && <p>{t('menu.noMatch')}</p>}
      <ul>
        {rows.map((row) => {
          const id = row.kind === 'item' ? row.item.id : row.option.id;
          const price = row.kind === 'item' ? row.item.price : row.option.priceDelta;
          return (
            <li key={row.kind + id}>
              {row.kind === 'item'
                ? row.item.name
                : t('menu.optionOf', { name: row.option.name, item: row.item.name })}{' '}
              <span>{formatMoney(price.amount, price.currency)}</span>{' '}
              <AvailabilityControl
                type={row.kind}
                id={id}
                switchedOff={row.kind === 'item' ? row.item.switchedOff : row.option.switchedOff}
              />{' '}
              {editing === id ? (
                <PriceForm
                  target={
                    row.kind === 'item'
                      ? { kind: 'item', itemId: id }
                      : { kind: 'option', optionId: id }
                  }
                  price={price}
                  onDone={() => setEditing(null)}
                />
              ) : (
                <button type="button" onClick={() => setEditing(id)}>
                  {t('menu.editPrice')}
                </button>
              )}
            </li>
          );
        })}
      </ul>
    </main>
  );
}

// RA §9.4: a percentage or an amount, up or down, for a category or the
// whole menu, previewed before and after, then confirmed.
export function BulkPricePage() {
  const { t } = useTranslation();
  const menu = useQuery(menuQuery);
  const preview = useBulkPreview();
  const apply = useApplyBulk();
  const [form, setForm] = useState<BulkForm>({
    categoryId: '',
    kind: 'percent',
    direction: 'up',
    value: '',
  });
  // The preview shown with the change it previews: confirming sends that
  // change, never one typed since (RA §9.4: preview, then confirm).
  const [shown, setShown] = useState<{ body: BulkBody; preview: BulkPreview } | null>(null);
  const [message, setMessage] = useState<string | null>(null);

  if (menu.isPending) return <p>{t('app.loading')}</p>;
  if (menu.isError) return <p role="alert">{t('menu.failed')}</p>;
  if (menu.data === 'terminated') return <p role="alert">{t('menu.refusal.terminated')}</p>;
  const currency = menuCurrency(menu.data);
  if (currency === null) return <p>{t('menu.empty')}</p>;
  const body = bulkBody(form, currency);
  const set = (change: Partial<BulkForm>) => {
    setForm({ ...form, ...change });
    setShown(null);
  };

  function show(event: FormEvent) {
    event.preventDefault();
    setMessage(null);
    if (body === null) {
      setMessage(t('menu.refusal.invalidPrice'));
      return;
    }
    const asked = body;
    preview
      .mutateAsync(asked)
      .then((answer) => {
        if (answer.status === 'done') setShown({ body: asked, preview: answer.preview });
        else
          setMessage(t(`menu.refusal.${refusalKey(answer.refusal)}` as 'menu.refusal.saveFailed'));
      })
      .catch(() => setMessage(t('menu.refusal.saveFailed')));
  }

  function confirm() {
    if (shown === null || JSON.stringify(shown.body) !== JSON.stringify(body)) return;
    apply
      .mutateAsync(shown.body)
      .then((answer) => {
        setShown(null);
        setMessage(
          answer.status === 'done'
            ? t('menu.bulk.done', { count: answer.changed })
            : t(`menu.refusal.${refusalKey(answer.refusal)}` as 'menu.refusal.saveFailed'),
        );
      })
      .catch(() => setMessage(t('menu.refusal.saveFailed')));
  }

  return (
    <main>
      <h1>{t('menu.bulk.title')}</h1>
      <BackToMenu />
      <p>{t('menu.parityReminder')}</p>
      <form onSubmit={show}>
        <label>
          {t('menu.category')}
          <select value={form.categoryId} onChange={(e) => set({ categoryId: e.target.value })}>
            <option value="">{t('menu.bulk.wholeMenu')}</option>
            {menu.data.categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </label>
        <fieldset>
          <legend>{t('menu.bulk.kind')}</legend>
          <label>
            <input
              type="radio"
              checked={form.kind === 'percent'}
              onChange={() => set({ kind: 'percent' })}
            />
            {t('menu.bulk.percent')}
          </label>
          <label>
            <input
              type="radio"
              checked={form.kind === 'amount'}
              onChange={() => set({ kind: 'amount' })}
            />
            {t('menu.bulk.amount')}
          </label>
        </fieldset>
        <fieldset>
          <legend>{t('menu.bulk.direction')}</legend>
          <label>
            <input
              type="radio"
              checked={form.direction === 'up'}
              onChange={() => set({ direction: 'up' })}
            />
            {t('menu.bulk.up')}
          </label>
          <label>
            <input
              type="radio"
              checked={form.direction === 'down'}
              onChange={() => set({ direction: 'down' })}
            />
            {t('menu.bulk.down')}
          </label>
        </fieldset>
        <label>
          {t('menu.bulk.value')}
          <input
            inputMode="decimal"
            required
            value={form.value}
            onChange={(e) => set({ value: e.target.value })}
          />
        </label>
        <button type="submit" disabled={preview.isPending}>
          {t('menu.bulk.preview')}
        </button>
      </form>
      {message !== null && <p role="status">{message}</p>}
      {shown && JSON.stringify(shown.body) === JSON.stringify(body) && (
        <BulkPreviewTable preview={shown.preview} applying={apply.isPending} onConfirm={confirm} />
      )}
    </main>
  );
}

function BulkPreviewTable(props: {
  preview: BulkPreview;
  applying: boolean;
  onConfirm: () => void;
}) {
  const { t } = useTranslation();
  const shown = props.preview;
  return (
    <section aria-label={t('menu.bulk.preview')}>
      <p>{t('menu.bulk.rounding', { unit: formatMoney(shown.roundingUnit, shown.currency) })}</p>
      {shown.refused > 0 && <p role="alert">{t('menu.refusal.bulkRefused')}</p>}
      <table>
        <thead>
          <tr>
            <th>{t('menu.bulk.item')}</th>
            <th>{t('menu.bulk.before')}</th>
            <th>{t('menu.bulk.after')}</th>
          </tr>
        </thead>
        <tbody>
          {shown.rows.map((row) => (
            <tr key={row.itemId}>
              <td>{row.name}</td>
              <td>{formatMoney(row.before, shown.currency)}</td>
              <td>
                {row.after === null
                  ? t('menu.bulk.reachesZero')
                  : formatMoney(row.after, shown.currency)}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <button
        type="button"
        disabled={shown.refused > 0 || props.applying}
        onClick={props.onConfirm}
      >
        {t('menu.bulk.confirm')}
      </button>
    </section>
  );
}

// RA §9.4 «سجل الأسعار»: the item or option, old and new, who and when.
export function PriceLogPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const log = useQuery(priceLogQuery);
  return (
    <main>
      <h1>{t('menu.priceLog.title')}</h1>
      <BackToMenu />
      {log.isPending && <p>{t('app.loading')}</p>}
      {log.isError && <p role="alert">{t('app.error')}</p>}
      {log.data === 'terminated' && <p role="alert">{t('menu.refusal.terminated')}</p>}
      {log.data?.length === 0 && <p>{t('menu.priceLog.empty')}</p>}
      <table>
        <tbody>
          {log.data !== 'terminated' &&
            log.data?.map((entry) => (
              <tr key={entry.id}>
                <td>
                  {entry.groupName === null
                    ? entry.name
                    : t('menu.priceLog.option', { name: entry.name, group: entry.groupName })}
                </td>
                <td>
                  {t('menu.priceLog.change', {
                    before: formatMoney(entry.oldPrice.amount, entry.oldPrice.currency),
                    after: formatMoney(entry.newPrice.amount, entry.newPrice.currency),
                  })}
                </td>
                <td>
                  {entry.byType === 'merchant'
                    ? (entry.byName ?? t('menu.priceLog.unknownUser'))
                    : t('menu.priceLog.foxDrop')}
                </td>
                <td>{formatDateTime(entry.at, timeZone)}</td>
              </tr>
            ))}
        </tbody>
      </table>
    </main>
  );
}

// RA §9.7: the menu exactly as the customer app shows it.
export function PreviewPage() {
  const { t } = useTranslation();
  const preview = useQuery(previewQuery);
  return (
    <main>
      <h1>{t('menu.preview.title')}</h1>
      <BackToMenu />
      {preview.isPending && <p>{t('app.loading')}</p>}
      {preview.isError && <p role="alert">{t('app.error')}</p>}
      {preview.data === 'terminated' && <p role="alert">{t('menu.refusal.terminated')}</p>}
      {preview.data?.length === 0 && <p>{t('menu.empty')}</p>}
      {preview.data !== 'terminated' &&
        preview.data?.map((category) => (
          <section key={category.id} aria-label={category.name}>
            <h2>{category.name}</h2>
            <ul>
              {category.items.map((item) => (
                <li key={item.id} aria-disabled={!item.available}>
                  <strong>{item.name}</strong>{' '}
                  <span>
                    {item.fromPrice === null
                      ? formatMoney(item.price.amount, item.price.currency)
                      : t('menu.preview.from', {
                          price: formatMoney(item.fromPrice.amount, item.fromPrice.currency),
                        })}
                  </span>
                  {item.description !== null && <p>{item.description}</p>}
                  {item.unavailableReason !== null && (
                    <p>
                      {item.unavailableReason === 'window' && category.window !== null
                        ? t('menu.preview.window', { time: timeOfMinute(category.window.startsAt) })
                        : item.unavailableReason === 'tomorrow'
                          ? t('menu.preview.tomorrow')
                          : t('menu.preview.unavailable')}
                    </p>
                  )}
                  {item.optionGroups.map((group) => (
                    <p key={group.id}>
                      {t(group.minChoices > 0 ? 'menu.preview.required' : 'menu.preview.optional', {
                        name: group.name,
                        options: group.options
                          .map((option) =>
                            /^0+$/.test(option.priceDelta.amount)
                              ? option.name
                              : t('menu.preview.option', {
                                  name: option.name,
                                  delta: formatMoney(
                                    option.priceDelta.amount,
                                    option.priceDelta.currency,
                                  ),
                                }),
                          )
                          .join(t('menu.listSeparator')),
                      })}
                    </p>
                  ))}
                </li>
              ))}
            </ul>
          </section>
        ))}
    </main>
  );
}
