import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import {
  type Direction,
  EDIT_RATES,
  type ExchangeRates,
  type RateEditResult,
  type RateRow,
  type RateVersion,
  rateLines,
  type RoundingMode,
  unitText,
  useExchangeRates,
  useRateHistory,
  useSaveRounding,
  useSetRate,
} from './exchange-rates.js';
import { formatDateTime } from './format.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/exchange-rates');
const signedIn = getRouteApi('/signed-in');

const modeKeys = {
  nearest: 'exchangeRates.mode.nearest',
  up: 'exchangeRates.mode.up',
  down: 'exchangeRates.mode.down',
} as const satisfies Record<RoundingMode, string>;

// AP §9.10.4 «أسعار الصرف» (slice 2.20a): each currency of the city with
// its rate, last update, editor and history; OWN and FIN edit the rate (a
// large change asks twice, AP §8.6) and the rounding rule (D14). A new rate
// applies to new orders only. Unstyled until the design.
export function ExchangeRatesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const rates = useExchangeRates(city?.id);
  return (
    <main>
      <h1>{t('exchangeRates.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('exchangeRates.newOrdersOnly')}</p>
      {cities.isError || rates.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !rates.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : rates.data.baseCurrency === null ? (
        <p>{t('exchangeRates.noBase')}</p>
      ) : (
        <Board board={rates.data} city={city} />
      )}
    </main>
  );
}

function Board({ board, city }: { board: ExchangeRates; city: City }) {
  const { t } = useTranslation();
  return (
    <>
      <p>
        {t('exchangeRates.base', { currency: board.baseCurrency })}{' '}
        {t('exchangeRates.staleAfter', { hours: board.staleAlertHours })}
      </p>
      {board.currencies.map((row) => (
        <Currency key={row.currency} row={row} board={board} city={city} />
      ))}
    </>
  );
}

function Currency({ row, board, city }: { row: RateRow; board: ExchangeRates; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const editor = can(session, EDIT_RATES);
  const [history, setHistory] = useState(false);
  return (
    <section>
      <h2>
        {t('exchangeRates.currency', { name: row.nameAr, code: row.currency })}{' '}
        {row.isBase && <span>{t('exchangeRates.isBase')}</span>}{' '}
        {!row.enabled && <span>{t('exchangeRates.disabled')}</span>}{' '}
        {row.stale && <strong>{t('exchangeRates.stale')}</strong>}
      </h2>
      {!row.isBase &&
        (row.rate ? (
          <RateLine currency={row.currency} rate={row.rate} city={city} />
        ) : (
          <p>{t('exchangeRates.noRate')}</p>
        ))}
      <p>
        {t('exchangeRates.rounding', {
          unit:
            unitText(row.roundingUnitMinor, row.decimals) ?? t('exchangeRates.roundingUnitMissing'),
          code: row.currency,
          mode: t(modeKeys[row.roundingMode]),
        })}
      </p>
      {!row.isBase && editor && (
        <RateForm
          row={row}
          cityId={city.id}
          pct={board.largeChangePct}
          baseCurrency={board.baseCurrency}
        />
      )}
      {editor && <RoundingForm row={row} cityId={city.id} />}
      {!row.isBase && (
        <button type="button" onClick={() => setHistory(!history)}>
          {history ? t('exchangeRates.hideHistory') : t('exchangeRates.showHistory')}
        </button>
      )}
      {history && <History cityId={city.id} currency={row.currency} city={city} />}
    </section>
  );
}

function RateLine({ currency, rate, city }: { currency: string; rate: RateVersion; city: City }) {
  const { t } = useTranslation();
  const lines = rateLines(currency, rate);
  return (
    <p>
      {t('exchangeRates.basePerUnit', {
        code: currency,
        value: lines.basePerUnit,
        base: lines.base,
      })}{' '}
      {t('exchangeRates.unitsPerBase', {
        code: currency,
        value: lines.unitsPerBase,
        base: lines.base,
      })}{' '}
      {t('exchangeRates.setBy', {
        time: formatDateTime(rate.setAt, city.timeZone),
        name: rate.editorName ?? t('exchangeRates.unnamed'),
      })}{' '}
      {rate.reason && <span>{t('exchangeRates.reason', { reason: rate.reason })}</span>}
    </p>
  );
}

const refusalKeys: Record<string, 'exchangeRates.refusal.invalidRate'> = {
  invalid_rate: 'exchangeRates.refusal.invalidRate',
};

function RateForm({
  row,
  cityId,
  pct,
  baseCurrency,
}: {
  row: RateRow;
  cityId: string;
  pct: number;
  baseCurrency: string | null;
}) {
  const { t } = useTranslation();
  const setRate = useSetRate(cityId);
  const [direction, setDirection] = useState<Direction>('base_per_unit');
  const [value, setValue] = useState('');
  const [reason, setReason] = useState('');
  const [result, setResult] = useState<RateEditResult | null>(null);
  const base = row.rate?.baseCurrency ?? baseCurrency ?? '';
  const send = async (confirmLargeChange: boolean) => {
    const answer = await setRate.mutateAsync({
      currency: row.currency,
      value,
      direction,
      reason,
      confirmLargeChange,
    });
    setResult(answer);
    if (answer.status === 'saved') {
      setValue('');
      setReason('');
    }
  };
  const submit = (event: FormEvent) => {
    event.preventDefault();
    void send(false);
  };
  return (
    <form onSubmit={submit}>
      <fieldset disabled={setRate.isPending}>
        <legend>{t('exchangeRates.editRate')}</legend>
        <label>
          {t('exchangeRates.direction')}
          <select
            value={direction}
            onChange={(event) => {
              setDirection(event.target.value as Direction);
              setResult(null);
            }}
          >
            <option value="base_per_unit">
              {t('exchangeRates.directionBasePerUnit', { code: row.currency, base })}
            </option>
            <option value="units_per_base">
              {t('exchangeRates.directionUnitsPerBase', { code: row.currency, base })}
            </option>
          </select>
        </label>
        <label>
          {t('exchangeRates.value')}
          <input
            inputMode="decimal"
            value={value}
            onChange={(event) => {
              setValue(event.target.value);
              setResult(null);
            }}
            required
          />
        </label>
        <label>
          {t('exchangeRates.reasonOptional')}
          <input value={reason} onChange={(event) => setReason(event.target.value)} />
        </label>
        <button type="submit">{t('exchangeRates.save')}</button>
      </fieldset>
      {result?.status === 'confirm' && (
        <p role="alert">
          {t('exchangeRates.largeChange', { pct })}{' '}
          <button type="button" onClick={() => void send(true)} disabled={setRate.isPending}>
            {t('exchangeRates.confirmLarge')}
          </button>
        </p>
      )}
      {result?.status === 'saved' && <p role="status">{t('exchangeRates.saved')}</p>}
      {result?.status === 'refused' && (
        <p role="alert">{t(refusalKeys[result.refusal] ?? 'exchangeRates.refusal.other')}</p>
      )}
      {setRate.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

function RoundingForm({ row, cityId }: { row: RateRow; cityId: string }) {
  const { t } = useTranslation();
  const save = useSaveRounding(cityId);
  const [unit, setUnit] = useState(unitText(row.roundingUnitMinor, row.decimals) ?? '');
  const [mode, setMode] = useState<RoundingMode>(row.roundingMode);
  const [reason, setReason] = useState('');
  const submit = (event: FormEvent) => {
    event.preventDefault();
    save.mutate({ row, edit: { currency: row.currency, unit, mode, reason } });
  };
  return (
    <form onSubmit={submit}>
      <fieldset disabled={save.isPending}>
        <legend>{t('exchangeRates.editRounding')}</legend>
        <label>
          {t('exchangeRates.roundingUnit', { code: row.currency })}
          <input
            inputMode="decimal"
            value={unit}
            onChange={(event) => setUnit(event.target.value)}
            required
          />
        </label>
        <label>
          {t('exchangeRates.roundingMode')}
          <select value={mode} onChange={(event) => setMode(event.target.value as RoundingMode)}>
            {(Object.keys(modeKeys) as RoundingMode[]).map((key) => (
              <option key={key} value={key}>
                {t(modeKeys[key])}
              </option>
            ))}
          </select>
        </label>
        <label>
          {t('exchangeRates.reasonRequired')}
          <input value={reason} onChange={(event) => setReason(event.target.value)} required />
        </label>
        <button type="submit">{t('exchangeRates.saveRounding')}</button>
      </fieldset>
      {save.data?.status === 'saved' && <p role="status">{t('exchangeRates.saved')}</p>}
      {save.data?.status === 'refused' && <p role="alert">{t('exchangeRates.refusal.rounding')}</p>}
      {save.isError && <p role="alert">{t('common.failed')}</p>}
    </form>
  );
}

function History({ cityId, currency, city }: { cityId: string; currency: string; city: City }) {
  const { t } = useTranslation();
  const history = useRateHistory(cityId, currency);
  if (history.isError) return <p role="alert">{t('common.failed')}</p>;
  if (!history.data) return <p role="status">{t('status.loading')}</p>;
  return (
    <ol>
      {history.data.map((version) => (
        <li key={version.versionId}>
          <RateLine currency={currency} rate={version} city={city} />
        </li>
      ))}
    </ol>
  );
}
