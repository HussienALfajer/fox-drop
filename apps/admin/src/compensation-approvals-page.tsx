import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import {
  type CompensationRequest,
  type DecideRefusal,
  useCompensationRequests,
  useDecideCompensation,
} from './compensation-approvals.js';
import { formatDateTime } from './format.js';
import { CompensationValueText } from './order-compensation-page.js';
import { emptyValue, type ValueForm, valueOf } from './order-compensation.js';

const route = getRouteApi('/signed-in/compensations');

const refusalKeys = {
  compensation_decided: 'approvals.refusal.decided',
  unknown_compensation: 'approvals.refusal.unknown',
  invalid_value: 'compensation.refusal.invalidValue',
  no_base_currency: 'compensation.refusal.noBaseCurrency',
  currency_changed: 'compensation.refusal.currencyChanged',
} as const satisfies Record<DecideRefusal, string>;

// AP §6.4 «طلبات الموافقة» (slice 2.22a): the compensations SUP or OPS asked
// above their cap, oldest first; OWN approves, edits the value or rejects,
// and the customer gets the code only once approved. Unstyled until the design.
export function CompensationApprovalsPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const requests = useCompensationRequests(city?.id);
  return (
    <main>
      <h1>{t('approvals.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {requests.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !requests.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : requests.data.length === 0 ? (
        <p>{t('approvals.none')}</p>
      ) : (
        <ul>
          {requests.data.map((request) => (
            <li key={request.id}>
              <RequestLine request={request} city={city} />
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}

function RequestLine({ request, city }: { request: CompensationRequest; city: City }) {
  const { t } = useTranslation();
  const decide = useDecideCompensation(city.id);
  const [editing, setEditing] = useState(false);
  const [form, setForm] = useState<ValueForm>(emptyValue);
  const checked = valueOf(form, request.currency);
  const value = 'value' in checked ? checked.value : null;
  const result = decide.data;
  const approveEdited = (event: FormEvent) => {
    event.preventDefault();
    if (value) decide.mutate({ id: request.id, decision: { kind: 'approve', value } });
  };
  return (
    <article>
      <p>
        <Link
          to="/orders/$orderId"
          params={{ orderId: request.orderId }}
          search={{ city: city.code }}
        >
          {t('approvals.order', { number: request.orderNumber })}
        </Link>{' '}
        <CompensationValueText compensation={request} />{' '}
        {t('compensation.reason', { reason: request.reason.label })}
        {request.note && <> {t('compensation.note', { note: request.note })}</>}{' '}
        {t('compensation.requested', {
          name: request.requestedBy ?? t('compensation.unnamed'),
          time: formatDateTime(request.requestedAt, city.timeZone),
        })}
      </p>
      {result?.status === 'done' ? (
        <p role="status">
          {result.decided.status === 'issued'
            ? t('approvals.approved', { code: result.decided.code ?? '' })
            : t('approvals.rejected')}
        </p>
      ) : (
        <p>
          <button
            type="button"
            disabled={decide.isPending}
            onClick={() =>
              decide.mutate({ id: request.id, decision: { kind: 'approve', value: null } })
            }
          >
            {t('approvals.approve')}
          </button>{' '}
          <button type="button" disabled={decide.isPending} onClick={() => setEditing(!editing)}>
            {t('approvals.edit')}
          </button>{' '}
          <button
            type="button"
            disabled={decide.isPending}
            onClick={() => decide.mutate({ id: request.id, decision: { kind: 'reject' } })}
          >
            {t('approvals.reject')}
          </button>
        </p>
      )}
      {editing && result?.status !== 'done' && (
        <form onSubmit={approveEdited} noValidate>
          <fieldset>
            <legend>{t('compensation.kind')}</legend>
            <label>
              <input
                type="radio"
                name={request.id}
                checked={form.kind === 'fixed_amount'}
                onChange={() => setForm({ ...form, kind: 'fixed_amount' })}
              />
              {t('compensation.kindAmount')}
            </label>
            <label>
              <input
                type="radio"
                name={request.id}
                checked={form.kind === 'percentage'}
                onChange={() => setForm({ ...form, kind: 'percentage' })}
              />
              {t('compensation.kindPercent')}
            </label>
          </fieldset>
          {form.kind === 'fixed_amount' ? (
            <label>
              {t('compensation.amount', { currency: request.currency })}
              <input
                inputMode="decimal"
                value={form.amount}
                onChange={(event) => setForm({ ...form, amount: event.target.value })}
              />
            </label>
          ) : (
            <>
              <label>
                {t('compensation.percent')}
                <input
                  inputMode="decimal"
                  value={form.percent}
                  onChange={(event) => setForm({ ...form, percent: event.target.value })}
                />
              </label>
              <label>
                {t('compensation.maxDiscount', { currency: request.currency })}
                <input
                  inputMode="decimal"
                  value={form.maxDiscount}
                  onChange={(event) => setForm({ ...form, maxDiscount: event.target.value })}
                />
              </label>
            </>
          )}
          <button type="submit" disabled={decide.isPending || !value}>
            {t('approvals.approveEdited')}
          </button>
        </form>
      )}
      {decide.isError && <p role="alert">{t('common.failed')}</p>}
      {result?.status === 'refused' && <p role="alert">{t(refusalKeys[result.refusal])}</p>}
    </article>
  );
}

// AP §9.1.4 «المهام»: the requests waiting for OWN, in the first city until
// the top bar's selector, linking «طلبات الموافقة».
export function ApprovalsLink() {
  const { t } = useTranslation();
  const cities = useQuery(citiesQuery);
  const city = cities.data?.[0];
  const requests = useCompensationRequests(city?.id);
  return (
    <Link to="/compensations" search={city ? { city: city.code } : {}}>
      {requests.data
        ? t('approvals.countLink', { count: requests.data.length })
        : t('approvals.title')}
    </Link>
  );
}
