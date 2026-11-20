import { useQuery } from '@tanstack/react-query';
import { Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatMoney } from './format.js';
import {
  type Hours,
  type PickupCurrencies,
  type SettingsAnswer,
  type SettingsCommand,
  type WeekForm,
  WEEKDAY_ORDER,
  hoursQuery,
  orderSettingsOf,
  pickupCurrenciesQuery,
  scheduleOf,
  switchedCurrencies,
  useSettingsCommand,
  weekOf,
  withChange,
  withPeriod,
  withoutPeriod,
} from './settings.js';

const WEEKDAYS = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
] as const;

// RA §10, §14.3, §17 (slice 2.45c): the owner's «الأوقات والإعدادات» as the
// app's «الحالة والأوقات» and «الإعدادات»: the weekly schedule, the default
// prep time and the limit, what FOX DROP sets (with «طلب تعديل»), and the
// pickup currencies. The holiday close is on «الحالة». Unstyled until the
// design.
export function SettingsPage() {
  const { t } = useTranslation();
  const hours = useQuery(hoursQuery);
  const pickup = useQuery(pickupCurrenciesQuery);
  const command = useSettingsCommand();
  const [answer, setAnswer] = useState<SettingsAnswer | null>(null);

  function run(next: SettingsCommand) {
    setAnswer(null);
    void command.mutateAsync(next).then(setAnswer);
  }

  if (hours.isPending) return <p>{t('app.loading')}</p>;
  if (hours.isError) return <p role="alert">{t('app.error')}</p>;

  return (
    <main>
      <h1>{t('settings.title')}</h1>
      {answer?.status === 'done' && <p role="status">{t('settings.saved')}</p>}
      {answer?.status === 'refused' && (
        <p role="alert">{t(`settings.refusal.${answer.refusal}`)}</p>
      )}
      {command.isError && <p role="alert">{t('app.error')}</p>}
      {/* Keyed by the read, so a save's answer starts the forms afresh. */}
      <Schedule key={JSON.stringify(hours.data.periods)} hours={hours.data} run={run} />
      <OrderSettings
        key={JSON.stringify([hours.data.defaultPrepMin, hours.data.maxActiveOrders])}
        hours={hours.data}
        run={run}
      />
      <SetByFoxDrop hours={hours.data} />
      {pickup.isError && <p role="alert">{t('app.error')}</p>}
      {pickup.data && <Currencies pickup={pickup.data} pending={command.isPending} run={run} />}
    </main>
  );
}

function Schedule({ hours, run }: { hours: Hours; run: (command: SettingsCommand) => void }) {
  const { t } = useTranslation();
  const [week, setWeek] = useState<WeekForm>(() => weekOf(hours.periods));
  const [invalid, setInvalid] = useState(false);

  function submit(event: FormEvent) {
    event.preventDefault();
    const periods = scheduleOf(week);
    setInvalid(periods === null);
    if (periods) run({ kind: 'hours', periods });
  }

  return (
    <form onSubmit={submit}>
      <fieldset>
        <legend>{t('settings.schedule')}</legend>
        <p>{t('settings.scheduleExplain')}</p>
        {WEEKDAY_ORDER.map((weekday) => (
          <fieldset key={weekday}>
            <legend>{t(`settings.weekday.${WEEKDAYS[weekday]}`)}</legend>
            {(week[weekday] ?? []).length === 0 && <p>{t('settings.closedAllDay')}</p>}
            {(week[weekday] ?? []).map((period, index) => (
              <p key={index}>
                <label>
                  {t('settings.opensAt')}
                  <input
                    type="time"
                    required
                    value={period.opensAt}
                    onChange={(e) =>
                      setWeek(
                        withChange(week, weekday, index, { ...period, opensAt: e.target.value }),
                      )
                    }
                  />
                </label>{' '}
                <label>
                  {t('settings.closesAt')}
                  <input
                    type="time"
                    required
                    value={period.closesAt}
                    onChange={(e) =>
                      setWeek(
                        withChange(week, weekday, index, { ...period, closesAt: e.target.value }),
                      )
                    }
                  />
                </label>{' '}
                <button type="button" onClick={() => setWeek(withoutPeriod(week, weekday, index))}>
                  {t('settings.removePeriod')}
                </button>
              </p>
            ))}
            <button type="button" onClick={() => setWeek(withPeriod(week, weekday))}>
              {t('settings.addPeriod')}
            </button>
          </fieldset>
        ))}
        {invalid && <p role="alert">{t('settings.refusal.invalidSchedule')}</p>}
        <button type="submit">{t('settings.saveSchedule')}</button>
      </fieldset>
    </form>
  );
}

function OrderSettings({ hours, run }: { hours: Hours; run: (command: SettingsCommand) => void }) {
  const { t } = useTranslation();
  const [defaultPrepMin, setPrep] = useState(String(hours.defaultPrepMin));
  const [limited, setLimited] = useState(hours.maxActiveOrders !== null);
  const [maxActiveOrders, setMax] = useState(String(hours.maxActiveOrders ?? 10));
  const [invalid, setInvalid] = useState(false);

  function submit(event: FormEvent) {
    event.preventDefault();
    const settings = orderSettingsOf({ defaultPrepMin, limited, maxActiveOrders }, hours);
    setInvalid(settings === null);
    if (settings) run({ kind: 'order_settings', ...settings });
  }

  return (
    <form onSubmit={submit}>
      <fieldset>
        <legend>{t('settings.orders')}</legend>
        <label>
          {t('settings.defaultPrep', { floor: hours.prepFloorMin, ceiling: hours.prepCeilingMin })}
          <input
            inputMode="numeric"
            required
            value={defaultPrepMin}
            onChange={(e) => setPrep(e.target.value)}
          />
        </label>
        <label>
          <input type="checkbox" checked={limited} onChange={(e) => setLimited(e.target.checked)} />
          {t('settings.limitOrders')}
        </label>
        {limited ? (
          <label>
            {t('settings.maxActiveOrders')}
            <input
              inputMode="numeric"
              required
              value={maxActiveOrders}
              onChange={(e) => setMax(e.target.value)}
            />
          </label>
        ) : (
          <p>{t('settings.noLimit')}</p>
        )}
        {invalid && <p role="alert">{t('settings.refusal.invalidSettings')}</p>}
        <button type="submit">{t('settings.saveOrders')}</button>
      </fieldset>
    </form>
  );
}

// RA §10, R13: set by FOX DROP; «طلب تعديل» opens «طلب تعديل بيانات» (§15).
function SetByFoxDrop({ hours }: { hours: Hours }) {
  const { t } = useTranslation();
  const { coverage } = hours;
  return (
    <section>
      <h2>{t('settings.setByFoxDrop')}</h2>
      <dl>
        <dt>{t('settings.minimumOrder')}</dt>
        <dd>{formatMoney(hours.minimumOrder.amount, hours.minimumOrder.currency)}</dd>
        <dt>{t('settings.coverage')}</dt>
        <dd>
          {coverage.kind === 'radius'
            ? t('settings.coverageRadius', { km: ((coverage.radiusMetres ?? 0) / 1000).toFixed(1) })
            : t('settings.coverageZones', { count: coverage.zoneCount ?? 0 })}
        </dd>
        <dt>{t('settings.commission')}</dt>
        <dd>
          {hours.commissionBp === null
            ? t('settings.none')
            : t('settings.percent', { value: hours.commissionBp / 100 })}
        </dd>
        <dt>{t('settings.settlementDay')}</dt>
        <dd>
          {(WEEKDAYS as readonly string[]).includes(hours.settlementWeekday)
            ? t(`settings.weekday.${hours.settlementWeekday as (typeof WEEKDAYS)[number]}`)
            : hours.settlementWeekday}
        </dd>
      </dl>
      <Link to="/support" search={{ report: 'data_change' }}>
        {t('settings.requestChange')}
      </Link>
    </section>
  );
}

function Currencies({
  pickup,
  pending,
  run,
}: {
  pickup: PickupCurrencies;
  pending: boolean;
  run: (command: SettingsCommand) => void;
}) {
  const { t } = useTranslation();
  return (
    <fieldset disabled={pending}>
      <legend>{t('settings.pickupCurrencies')}</legend>
      <p>{t('settings.pickupExplain')}</p>
      {pickup.baseCurrency && (
        <label>
          <input type="checkbox" checked disabled />
          {t('settings.baseCurrency', { name: pickup.baseCurrency.name })}
        </label>
      )}
      {pickup.choices.map((choice) => (
        <label key={choice.currency}>
          <input
            type="checkbox"
            checked={pickup.accepted.includes(choice.currency)}
            onChange={(e) =>
              run({
                kind: 'pickup_currencies',
                currencies: switchedCurrencies(pickup, choice.currency, e.target.checked),
              })
            }
          />
          {choice.name}
        </label>
      ))}
      {pickup.choices.length === 0 && <p>{t('settings.noOtherCurrencies')}</p>}
    </fieldset>
  );
}
