import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { serverNow } from './clock.js';
import {
  type Audience,
  BODY_MAX,
  DAYS_MAX,
  emptyForm,
  type MassPush,
  type MassPushes,
  type MassPushFields,
  type MassPushForm,
  type MassPushProblem,
  type MassPushRefusal,
  type MassPushResult,
  massPushesQuery,
  massPushFieldsOf,
  SCHEDULE_DAYS,
  type Target,
  TITLE_MAX,
  useAudienceSize,
  useCancelMassPush,
  useSendMassPush,
} from './mass-pushes.js';

const route = getRouteApi('/signed-in/mass-pushes');

const audienceKeys = {
  all: 'massPushes.audience.all',
  zone: 'massPushes.audience.zone',
  inactive: 'massPushes.audience.inactive',
  never_ordered: 'massPushes.audience.neverOrdered',
} as const satisfies Record<Audience, string>;

const targetKeys = {
  home: 'massPushes.target.home',
  restaurant: 'massPushes.target.restaurant',
  code: 'massPushes.target.code',
} as const satisfies Record<Target, string>;

const statusKeys = {
  scheduled: 'massPushes.status.scheduled',
  sent: 'massPushes.status.sent',
  cancelled: 'massPushes.status.cancelled',
} as const satisfies Record<MassPush['status'], string>;

const problemKeys = {
  title: 'massPushes.problem.title',
  body: 'massPushes.problem.body',
  zone: 'massPushes.problem.zone',
  days: 'massPushes.problem.days',
  target: 'massPushes.problem.target',
  time: 'massPushes.problem.time',
} as const satisfies Record<MassPushProblem, string>;

const refusalKeys = {
  invalid_mass_push: 'massPushes.refused.invalid',
  audience_changed: 'massPushes.refused.audienceChanged',
  audience_empty: 'massPushes.refused.audienceEmpty',
  not_cancellable: 'massPushes.refused.notCancellable',
  unknown_mass_push: 'massPushes.refused.unknown',
} as const satisfies Record<MassPushRefusal, string>;

// AP §9.11.4 «الإشعارات الجماعية» (slice 2.27d): the form with the audience
// size and a confirmation before sending, and the history. Unstyled until
// the design.
export function MassPushesPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const pushes = useQuery({ ...massPushesQuery(city?.id ?? ''), enabled: city !== undefined });
  return (
    <main>
      <h1>{t('massPushes.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      {pushes.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !pushes.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <MassPushesView pushes={pushes.data} city={city} />
      )}
    </main>
  );
}

function MassPushesView({ pushes, city }: { pushes: MassPushes; city: City }) {
  const { t } = useTranslation();
  const [sent, setSent] = useState(0);
  return (
    <>
      {pushes.canManage && (
        <section aria-label={t('massPushes.new')}>
          <h2>{t('massPushes.new')}</h2>
          <MassPushEditor
            key={sent}
            pushes={pushes}
            city={city}
            onSent={() => setSent((n) => n + 1)}
          />
        </section>
      )}
      <section aria-label={t('massPushes.history')}>
        <h2>{t('massPushes.history')}</h2>
        {pushes.pushes.length === 0 ? (
          <p>{t('massPushes.none')}</p>
        ) : (
          <ol>
            {pushes.pushes.map((push) => (
              <li key={push.id}>
                <HistoryItem push={push} pushes={pushes} city={city} />
              </li>
            ))}
          </ol>
        )}
      </section>
    </>
  );
}

function useAt(city: City) {
  return (value: string) =>
    new Intl.DateTimeFormat('ar-u-nu-latn', {
      timeZone: city.timeZone,
      dateStyle: 'medium',
      timeStyle: 'short',
    }).format(new Date(value));
}

// The audience and the target in words, as the confirmation and the history
// say them.
function useDescribe(pushes: MassPushes) {
  const { t } = useTranslation();
  const zones = new Map(pushes.zones.map((zone) => [zone.id, zone.name]));
  const restaurants = new Map(pushes.restaurants.map((each) => [each.id, each.name]));
  const codes = new Map(pushes.codes.map((each) => [each.id, each.code]));
  return {
    audience: (push: {
      audience: Audience;
      zoneId: string | null;
      inactiveDays: number | null;
      zoneName?: string | null;
    }) => {
      switch (push.audience) {
        case 'zone':
          return t('massPushes.audienceIs.zone', {
            name: push.zoneName ?? zones.get(push.zoneId ?? '') ?? '',
          });
        case 'inactive':
          return t('massPushes.audienceIs.inactive', { days: push.inactiveDays ?? 0 });
        default:
          return t(audienceKeys[push.audience]);
      }
    },
    target: (push: {
      target: Target;
      restaurantId: string | null;
      codeId: string | null;
      restaurantName?: string | null;
      code?: string | null;
    }) => {
      switch (push.target) {
        case 'restaurant':
          return t('massPushes.opens.restaurant', {
            name: push.restaurantName ?? restaurants.get(push.restaurantId ?? '') ?? '',
          });
        case 'code':
          return t('massPushes.opens.code', {
            code: push.code ?? codes.get(push.codeId ?? '') ?? '',
          });
        case 'home':
          return t('massPushes.opens.home');
      }
    },
  };
}

function HistoryItem({ push, pushes, city }: { push: MassPush; pushes: MassPushes; city: City }) {
  const { t } = useTranslation();
  const describe = useDescribe(pushes);
  const at = useAt(city);
  const cancel = useCancelMassPush(city.id);
  const [confirming, setConfirming] = useState(false);
  return (
    <section aria-label={push.title}>
      <h3>{push.title}</h3>
      <p>{push.body}</p>
      <p>{t(statusKeys[push.status])}</p>
      <p>
        {push.scheduled
          ? t('massPushes.scheduledFor', { at: at(push.sendAt) })
          : t('massPushes.sentAt', { at: at(push.sendAt) })}
      </p>
      <p>{t('massPushes.sender', { name: push.sentBy })}</p>
      <p>{describe.audience(push)}</p>
      <p>{describe.target(push)}</p>
      <p>
        {t('massPushes.counts', {
          recipients: push.recipients,
          sent: push.sent,
          delivered: push.delivered,
        })}
      </p>
      {push.cancelledAt !== null && (
        <p>
          {t('massPushes.cancelledBy', { name: push.cancelledBy ?? '', at: at(push.cancelledAt) })}
        </p>
      )}
      {pushes.canManage && push.status === 'scheduled' && (
        <>
          {confirming ? (
            <button
              type="button"
              disabled={cancel.isPending}
              onClick={() => cancel.mutate(push.id)}
            >
              {t('massPushes.confirmCancel')}
            </button>
          ) : (
            <button type="button" onClick={() => setConfirming(true)}>
              {t('massPushes.cancel')}
            </button>
          )}
          <Outcome result={cancel.data} failed={cancel.isError} />
        </>
      )}
    </section>
  );
}

// The form, then «عدد المستلمين» before «تأكيد الإرسال»: the confirmation
// shows the audience's size for the form as it is, and the server refuses
// the send when the audience moved since.
function MassPushEditor({
  pushes,
  city,
  onSent,
}: {
  pushes: MassPushes;
  city: City;
  onSent: () => void;
}) {
  const { t } = useTranslation();
  const describe = useDescribe(pushes);
  const at = useAt(city);
  const count = useAudienceSize(city.id);
  const send = useSendMassPush(city.id);
  const [form, setForm] = useState<MassPushForm>(emptyForm);
  // The fields the size was counted for, and the size.
  const [counted, setCounted] = useState<{ fields: string; size: number } | null>(null);
  const checked = massPushFieldsOf(form, city.timeZone, serverNow());
  const current = 'fields' in checked ? JSON.stringify(checked.fields) : null;
  const confirming = counted !== null && counted.fields === current;

  const set = (change: Partial<MassPushForm>) => setForm({ ...form, ...change });

  const ask = () => {
    if (!('fields' in checked) || current === null) return;
    const fields = checked.fields;
    count.mutate(fields, { onSuccess: (size) => setCounted({ fields: current, size }) });
  };

  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!('fields' in checked) || !confirming || counted.size === 0) return;
    const fields: MassPushFields = checked.fields;
    send.mutate(
      { fields, audienceSize: counted.size },
      {
        onSuccess: (result: MassPushResult) => {
          if (result.status === 'saved') onSent();
          else setCounted(null);
        },
      },
    );
  };

  return (
    <form onSubmit={submit}>
      <label>
        {t('massPushes.titleField', { max: TITLE_MAX })}
        <input
          value={form.title}
          maxLength={TITLE_MAX}
          required
          onChange={(event) => set({ title: event.target.value })}
        />
      </label>
      <label>
        {t('massPushes.bodyField', { max: BODY_MAX })}
        <textarea
          value={form.body}
          maxLength={BODY_MAX}
          required
          onChange={(event) => set({ body: event.target.value })}
        />
      </label>
      <fieldset>
        <legend>{t('massPushes.audienceField')}</legend>
        {(Object.keys(audienceKeys) as Audience[]).map((audience) => (
          <label key={audience}>
            <input
              type="radio"
              name="audience"
              checked={form.audience === audience}
              onChange={() => set({ audience })}
            />
            {t(audienceKeys[audience])}
          </label>
        ))}
      </fieldset>
      {form.audience === 'zone' && (
        <label>
          {t('massPushes.zone')}
          <select value={form.zoneId} onChange={(event) => set({ zoneId: event.target.value })}>
            <option value="">{t('massPushes.choose')}</option>
            {pushes.zones.map((zone) => (
              <option key={zone.id} value={zone.id}>
                {zone.name}
              </option>
            ))}
          </select>
        </label>
      )}
      {form.audience === 'inactive' && (
        <label>
          {t('massPushes.days', { max: DAYS_MAX })}
          <input
            inputMode="numeric"
            value={form.inactiveDays}
            onChange={(event) => set({ inactiveDays: event.target.value })}
          />
        </label>
      )}
      <fieldset>
        <legend>{t('massPushes.targetField')}</legend>
        {(Object.keys(targetKeys) as Target[]).map((target) => (
          <label key={target}>
            <input
              type="radio"
              name="target"
              checked={form.target === target}
              onChange={() => set({ target })}
            />
            {t(targetKeys[target])}
          </label>
        ))}
      </fieldset>
      {form.target === 'restaurant' && (
        <label>
          {t('massPushes.restaurant')}
          <select
            value={form.restaurantId}
            onChange={(event) => set({ restaurantId: event.target.value })}
          >
            <option value="">{t('massPushes.choose')}</option>
            {pushes.restaurants.map((each) => (
              <option key={each.id} value={each.id}>
                {each.name}
              </option>
            ))}
          </select>
        </label>
      )}
      {form.target === 'code' && (
        <label>
          {t('massPushes.code')}
          <select value={form.codeId} onChange={(event) => set({ codeId: event.target.value })}>
            <option value="">{t('massPushes.choose')}</option>
            {pushes.codes.map((each) => (
              <option key={each.id} value={each.id}>
                {each.code}
              </option>
            ))}
          </select>
        </label>
      )}
      <fieldset>
        <legend>{t('massPushes.timing')}</legend>
        <label>
          <input
            type="radio"
            name="timing"
            checked={!form.scheduled}
            onChange={() => set({ scheduled: false })}
          />
          {t('massPushes.now')}
        </label>
        <label>
          <input
            type="radio"
            name="timing"
            checked={form.scheduled}
            onChange={() => set({ scheduled: true })}
          />
          {t('massPushes.later')}
        </label>
        {form.scheduled && (
          <label>
            {t('massPushes.sendAt', { days: SCHEDULE_DAYS })}
            <input
              type="datetime-local"
              value={form.sendAt}
              onChange={(event) => set({ sendAt: event.target.value })}
            />
          </label>
        )}
      </fieldset>
      {'problem' in checked && (
        <p>
          {t(problemKeys[checked.problem], { title: TITLE_MAX, body: BODY_MAX, days: DAYS_MAX })}
        </p>
      )}
      <button type="button" disabled={!('fields' in checked) || count.isPending} onClick={ask}>
        {t('massPushes.countAudience')}
      </button>
      {count.isError && <p role="alert">{t('common.failed')}</p>}
      {confirming && 'fields' in checked && (
        <section aria-label={t('massPushes.confirmation')}>
          <h3>{t('massPushes.confirmation')}</h3>
          <p>{t('massPushes.audienceSize', { size: counted.size })}</p>
          <p>{checked.fields.title}</p>
          <p>{checked.fields.body}</p>
          <p>{describe.audience(checked.fields)}</p>
          <p>{describe.target(checked.fields)}</p>
          <p>
            {checked.fields.sendAt === null
              ? t('massPushes.sendsNow')
              : t('massPushes.scheduledFor', { at: at(checked.fields.sendAt) })}
          </p>
          {counted.size === 0 ? (
            <p role="alert">{t('massPushes.refused.audienceEmpty')}</p>
          ) : (
            <button type="submit" disabled={send.isPending}>
              {checked.fields.sendAt === null
                ? t('massPushes.confirmSend', { size: counted.size })
                : t('massPushes.confirmSchedule', { size: counted.size })}
            </button>
          )}
        </section>
      )}
      <Outcome result={send.data} failed={send.isError} />
    </form>
  );
}

function Outcome({ result, failed }: { result: MassPushResult | undefined; failed: boolean }) {
  const { t } = useTranslation();
  if (failed) return <p role="alert">{t('common.failed')}</p>;
  if (result?.status === 'refused') return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
  if (result?.status === 'saved') return <p role="status">{t('massPushes.saved')}</p>;
  return null;
}
