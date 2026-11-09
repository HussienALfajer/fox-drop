import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type ChangeEvent, type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime } from './format.js';
import { useOpsChannel } from './live.js';
import { restaurantsQuery } from './restaurant-images.js';
import {
  canChangeRestaurantStatus,
  type PauseLength,
  type RestaurantStatus,
  restaurantStatusQuery,
  type StatusResult,
  stateKey,
  useEndBusyMode,
  useEndHolidayClose,
  useHolidayClose,
  usePauseRestaurant,
  useResumeRestaurant,
  useSetMaxActiveOrders,
} from './restaurant-status.js';

const route = getRouteApi('/signed-in/restaurant-status');
const signedIn = getRouteApi('/signed-in');

const lengths = [
  ['15', 'restaurantStatus.pause.min15'],
  ['30', 'restaurantStatus.pause.min30'],
  ['60', 'restaurantStatus.pause.min60'],
  ['until', 'restaurantStatus.pause.untilTime'],
  ['resumed', 'restaurantStatus.pause.untilResumed'],
] as const satisfies readonly (readonly [PauseLength, string])[];

// AP §9.6.5, slice 2.6b: a restaurant's state and the panel's actions on it,
// on the restaurants of the first city (as «الصور») until the restaurant
// profile (2.30). Live over the city's channel. Unstyled until the design.
export function RestaurantStatusPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const restaurants = useQuery({
    ...restaurantsQuery(city?.id ?? ''),
    enabled: city !== undefined,
  });
  const choose = (event: ChangeEvent<HTMLSelectElement>) =>
    void navigate({
      to: '/restaurant-status',
      search: {
        ...(search.city ? { city: search.city } : {}),
        ...(event.target.value ? { restaurant: event.target.value } : {}),
      },
    });
  return (
    <main>
      <h1>{t('restaurantStatus.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('restaurantStatus.explain')}</p>
      {restaurants.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !restaurants.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <label>
          {t('restaurantStatus.restaurant')}
          <select value={search.restaurant ?? ''} onChange={choose}>
            <option value="">{t('restaurantStatus.choose')}</option>
            {restaurants.data.map((restaurant) => (
              <option key={restaurant.id} value={restaurant.id}>
                {restaurant.nameAr}
              </option>
            ))}
          </select>
        </label>
      )}
      {city && search.restaurant && (
        <Restaurant key={search.restaurant} restaurantId={search.restaurant} city={city} />
      )}
    </main>
  );
}

function Restaurant({ restaurantId, city }: { restaurantId: string; city: City }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  useOpsChannel(city.id);
  const status = useQuery(restaurantStatusQuery(restaurantId));
  if (status.isPending) return <p role="status">{t('status.loading')}</p>;
  if (status.isError) return <p role="alert">{t('common.failed')}</p>;
  const editable = canChangeRestaurantStatus(session);
  return (
    <>
      <Now status={status.data} city={city} />
      {editable && <Actions status={status.data} restaurantId={restaurantId} city={city} />}
    </>
  );
}

function Now({ status, city }: { status: RestaurantStatus; city: City }) {
  const { t } = useTranslation();
  const time = (at: string) => formatDateTime(at, city.timeZone);
  return (
    <section aria-label={status.nameAr}>
      <h2>{status.nameAr}</h2>
      <p>{t('restaurantStatus.now', { state: t(`restaurantStatus.state.${stateKey(status)}`) })}</p>
      {status.heldPauseSource && (
        <>
          {/* AP §9.6.5: an operations or auto pause holds while closed too. */}
          {status.state !== 'paused' && (
            <p>
              {t('restaurantStatus.pauseHeld', {
                state: t(
                  `restaurantStatus.state.${stateKey({ state: 'paused', pauseSource: status.heldPauseSource })}`,
                ),
              })}
            </p>
          )}
          <p>
            {status.heldPauseUntil
              ? t('restaurantStatus.until', { time: time(status.heldPauseUntil) })
              : t('restaurantStatus.untilResumed')}
          </p>
          {status.pauseMessage && (
            <p>{t('restaurantStatus.pauseMessage', { message: status.pauseMessage })}</p>
          )}
          {status.pauseReason && (
            <p>{t('restaurantStatus.pauseReason', { reason: status.pauseReason })}</p>
          )}
        </>
      )}
      {status.opensAt && <p>{t('restaurantStatus.opensAt', { time: time(status.opensAt) })}</p>}
      {status.closesAt && <p>{t('restaurantStatus.closesAt', { time: time(status.closesAt) })}</p>}
      {status.busyMode && (
        <p>
          {t('restaurantStatus.busyMode', {
            minutes: status.busyMode.extraMin,
            time: time(status.busyMode.until),
          })}
        </p>
      )}
      {status.maxActiveOrders !== null && (
        <p>
          {t('restaurantStatus.activeOrders', {
            count: status.activeOrders ?? 0,
            max: status.maxActiveOrders,
          })}
        </p>
      )}
      {status.holiday && (
        <>
          <p>
            {t('restaurantStatus.holidayAt', {
              from: time(status.holiday.startsAt),
              to: time(status.holiday.endsAt),
            })}
          </p>
          {status.holiday.message && (
            <p>{t('restaurantStatus.holidayMessage', { message: status.holiday.message })}</p>
          )}
        </>
      )}
    </section>
  );
}

function Outcome({
  pending,
  failed,
  result,
}: {
  pending: boolean;
  failed: boolean;
  result: StatusResult | undefined;
}) {
  const { t } = useTranslation();
  if (pending) return <p role="status">{t('status.loading')}</p>;
  if (failed) return <p role="alert">{t('common.failed')}</p>;
  if (result?.status === 'refused') {
    return <p role="alert">{t(`restaurantStatus.refused.${result.refusal}`)}</p>;
  }
  if (result?.status === 'done') return <p role="status">{t('restaurantStatus.done')}</p>;
  return null;
}

function Actions({
  status,
  restaurantId,
  city,
}: {
  status: RestaurantStatus;
  restaurantId: string;
  city: City;
}) {
  const { t } = useTranslation();
  const resume = useResumeRestaurant(restaurantId);
  const endBusy = useEndBusyMode(restaurantId);
  const endHoliday = useEndHolidayClose(restaurantId);
  return (
    <>
      {status.heldPauseSource && (
        <section>
          <button type="button" disabled={resume.isPending} onClick={() => resume.mutate()}>
            {t('restaurantStatus.resume')}
          </button>
          <Outcome pending={resume.isPending} failed={resume.isError} result={resume.data} />
        </section>
      )}
      {status.busyMode && (
        <section>
          <button type="button" disabled={endBusy.isPending} onClick={() => endBusy.mutate()}>
            {t('restaurantStatus.endBusyMode')}
          </button>
          <Outcome pending={endBusy.isPending} failed={endBusy.isError} result={endBusy.data} />
        </section>
      )}
      <PauseForm restaurantId={restaurantId} city={city} />
      <HolidayForm restaurantId={restaurantId} city={city} />
      {status.holiday && (
        <section>
          <button type="button" disabled={endHoliday.isPending} onClick={() => endHoliday.mutate()}>
            {t('restaurantStatus.holiday.end')}
          </button>
          <Outcome
            pending={endHoliday.isPending}
            failed={endHoliday.isError}
            result={endHoliday.data}
          />
        </section>
      )}
      <MaxForm restaurantId={restaurantId} current={status.maxActiveOrders} />
    </>
  );
}

function PauseForm({ restaurantId, city }: { restaurantId: string; city: City }) {
  const { t } = useTranslation();
  const pause = usePauseRestaurant(restaurantId, city.timeZone);
  const [length, setLength] = useState<PauseLength>('30');
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    const text = (name: string) => String(form.get(name) ?? '');
    pause.mutate({
      length,
      until: text('until'),
      message: text('message'),
      reason: text('reason'),
    });
  }
  return (
    <form onSubmit={submit} aria-label={t('restaurantStatus.pause.title')}>
      <h3>{t('restaurantStatus.pause.title')}</h3>
      <fieldset disabled={pause.isPending}>
        <legend>{t('restaurantStatus.pause.length')}</legend>
        {lengths.map(([value, key]) => (
          <label key={value}>
            <input
              type="radio"
              name="length"
              value={value}
              checked={length === value}
              onChange={() => setLength(value)}
            />
            {t(key)}
          </label>
        ))}
        {length === 'until' && (
          <label>
            {t('restaurantStatus.pause.time')}
            <input name="until" type="datetime-local" required />
          </label>
        )}
        <label>
          {t('restaurantStatus.pause.message')}
          <input name="message" maxLength={100} />
        </label>
        <label>
          {t('restaurantStatus.pause.reason')}
          <input name="reason" required maxLength={500} />
        </label>
        <button type="submit">{t('restaurantStatus.pause.submit')}</button>
      </fieldset>
      <Outcome pending={pause.isPending} failed={pause.isError} result={pause.data} />
    </form>
  );
}

function HolidayForm({ restaurantId, city }: { restaurantId: string; city: City }) {
  const { t } = useTranslation();
  const close = useHolidayClose(restaurantId, city.timeZone);
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    const text = (name: string) => String(form.get(name) ?? '');
    close.mutate({
      startsAt: text('startsAt'),
      endsAt: text('endsAt'),
      message: text('message'),
      reason: text('reason'),
    });
  }
  return (
    <form onSubmit={submit} aria-label={t('restaurantStatus.holiday.title')}>
      <h3>{t('restaurantStatus.holiday.title')}</h3>
      <fieldset disabled={close.isPending}>
        <label>
          {t('restaurantStatus.holiday.startsAt')}
          <input name="startsAt" type="datetime-local" />
        </label>
        <label>
          {t('restaurantStatus.holiday.endsAt')}
          <input name="endsAt" type="datetime-local" required />
        </label>
        <label>
          {t('restaurantStatus.holiday.message')}
          <input name="message" maxLength={100} />
        </label>
        <label>
          {t('restaurantStatus.holiday.reason')}
          <input name="reason" required maxLength={500} />
        </label>
        <button type="submit">{t('restaurantStatus.holiday.submit')}</button>
      </fieldset>
      <Outcome pending={close.isPending} failed={close.isError} result={close.data} />
    </form>
  );
}

function MaxForm({ restaurantId, current }: { restaurantId: string; current: number | null }) {
  const { t } = useTranslation();
  const set = useSetMaxActiveOrders(restaurantId);
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    set.mutate(String(new FormData(event.currentTarget).get('max') ?? ''));
  }
  return (
    <form onSubmit={submit} aria-label={t('restaurantStatus.max.title')}>
      <h3>{t('restaurantStatus.max.title')}</h3>
      <p>{t('restaurantStatus.max.explain')}</p>
      <fieldset disabled={set.isPending}>
        <label>
          {t('restaurantStatus.max.label')}
          <input name="max" type="number" min={1} max={50} defaultValue={current ?? ''} />
        </label>
        <button type="submit">{t('restaurantStatus.max.submit')}</button>
      </fieldset>
      <Outcome pending={set.isPending} failed={set.isError} result={set.data} />
    </form>
  );
}
