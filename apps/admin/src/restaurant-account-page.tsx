import { useQuery } from '@tanstack/react-query';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import type { City } from './cities.js';
import { formatDateTime } from './format.js';
import { percentText } from './restaurant-list.js';
import {
  type AccountResult,
  canChangeCommission,
  canManageAccount,
  canTerminate,
  type CommissionForm,
  type RestaurantAccount,
  restaurantAccountQuery,
  sortWeightOf,
  useChangeCommission,
  useReactivate,
  useSetSortWeight,
  useSetVisibility,
  useSuspend,
  useTerminate,
} from './restaurant-account.js';
import type { AdminSession } from './session.js';

// AP §9.6.5, D16 (slice 2.30c): the restaurant's account, visibility, sort
// weight and commission with the panel's actions on them, under «حالة
// المطاعم» until the profile (2.30d). Unstyled until the design.
export function RestaurantAccountSection({
  restaurantId,
  city,
  session,
}: {
  restaurantId: string;
  city: City;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const account = useQuery(restaurantAccountQuery(restaurantId));
  if (account.isPending) return <p role="status">{t('status.loading')}</p>;
  if (account.isError) return <p role="alert">{t('common.failed')}</p>;
  const data = account.data;
  const ended = data.accountStatus === 'terminated';
  const onboarding = data.accountStatus === 'draft';
  return (
    <section aria-label={t('restaurantAccount.title')}>
      <h2>{t('restaurantAccount.title')}</h2>
      <Facts account={data} city={city} />
      {canManageAccount(session) && !ended && (
        <>
          {data.accountStatus === 'active' && (
            <ReasonAction
              restaurantId={restaurantId}
              kind="suspend"
              label={t('restaurantAccount.suspend')}
            />
          )}
          {data.accountStatus === 'suspended' && (
            <ReasonAction
              restaurantId={restaurantId}
              kind="reactivate"
              label={t('restaurantAccount.reactivate')}
            />
          )}
          <Visibility restaurantId={restaurantId} visible={data.visible} />
          <SortWeight
            restaurantId={restaurantId}
            weight={data.sortWeight}
            max={data.sortWeightMax}
          />
        </>
      )}
      {canChangeCommission(session) && !ended && !onboarding && (
        <Commission restaurantId={restaurantId} city={city} />
      )}
      {canTerminate(session) && !ended && !onboarding && (
        <ReasonAction
          restaurantId={restaurantId}
          kind="terminate"
          label={t('restaurantAccount.terminate')}
        />
      )}
    </section>
  );
}

function Facts({ account, city }: { account: RestaurantAccount; city: City }) {
  const { t } = useTranslation();
  const time = (at: string) => formatDateTime(at, city.timeZone);
  return (
    <>
      <p>
        {t('restaurantAccount.status', {
          status: t(`restaurantList.accountStatus.${account.accountStatus}`),
        })}
      </p>
      {account.suspensionReason && (
        <p>{t('restaurantAccount.suspensionReason', { reason: account.suspensionReason })}</p>
      )}
      <p>{account.visible ? t('restaurantAccount.visible') : t('restaurantAccount.hidden')}</p>
      <p>{t('restaurantAccount.sortWeight', { weight: account.sortWeight })}</p>
      <p>
        {account.commissionBp === null
          ? t('restaurantAccount.noCommission')
          : t('restaurantAccount.commission', { rate: percentText(account.commissionBp) })}
      </p>
      {account.nextCommission && (
        <p>
          {t('restaurantAccount.nextCommission', {
            rate: percentText(account.nextCommission.rateBp),
            time: time(account.nextCommission.from),
          })}
        </p>
      )}
      {account.commissionHistory.length > 0 && (
        <>
          <h3>{t('restaurantAccount.history')}</h3>
          <ul aria-label={t('restaurantAccount.history')}>
            {account.commissionHistory.map((version) => (
              <li key={version.id}>
                {t('restaurantAccount.version', {
                  rate: percentText(version.rateBp),
                  from: time(version.from),
                  at: time(version.setAt),
                })}
                {version.reason && (
                  <> {t('restaurantAccount.versionReason', { reason: version.reason })}</>
                )}
              </li>
            ))}
          </ul>
        </>
      )}
    </>
  );
}

function Refused({ result }: { result: AccountResult | undefined }) {
  const { t } = useTranslation();
  if (result?.status !== 'refused') return null;
  return <p role="alert">{t(`restaurantAccount.refused.${result.refusal}`)}</p>;
}

// «تعليق», «إعادة التفعيل» and «إنهاء العقد»: a required reason; the
// termination asks a second press, since it is final.
function ReasonAction({
  restaurantId,
  kind,
  label,
}: {
  restaurantId: string;
  kind: 'suspend' | 'reactivate' | 'terminate';
  label: string;
}) {
  const { t } = useTranslation();
  const [reason, setReason] = useState('');
  const [confirming, setConfirming] = useState(false);
  const suspend = useSuspend(restaurantId);
  const reactivate = useReactivate(restaurantId);
  const terminate = useTerminate(restaurantId);
  const command = { suspend, reactivate, terminate }[kind];
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (kind === 'terminate' && !confirming) {
      setConfirming(true);
      return;
    }
    command.mutate(reason, {
      onSuccess: (result) => {
        setConfirming(false);
        if (result.status === 'done') setReason('');
      },
    });
  };
  return (
    <form onSubmit={submit} aria-label={label}>
      <label>
        {t('restaurantAccount.reason')}
        <input
          value={reason}
          required
          maxLength={500}
          onChange={(e) => setReason(e.target.value)}
        />
      </label>
      {kind === 'terminate' && <p>{t('restaurantAccount.terminateExplain')}</p>}
      <button type="submit" disabled={command.isPending || reason.trim() === ''}>
        {confirming ? t('restaurantAccount.confirmTerminate') : label}
      </button>
      {command.isError && <p role="alert">{t('common.failed')}</p>}
      <Refused result={command.data} />
    </form>
  );
}

function Visibility({ restaurantId, visible }: { restaurantId: string; visible: boolean }) {
  const { t } = useTranslation();
  const command = useSetVisibility(restaurantId);
  return (
    <p>
      <button type="button" disabled={command.isPending} onClick={() => command.mutate(!visible)}>
        {visible ? t('restaurantAccount.hide') : t('restaurantAccount.show')}
      </button>
      {command.isError && <span role="alert">{t('common.failed')}</span>}
    </p>
  );
}

function SortWeight({
  restaurantId,
  weight,
  max,
}: {
  restaurantId: string;
  weight: number;
  max: number;
}) {
  const { t } = useTranslation();
  const [typed, setTyped] = useState(String(weight));
  const command = useSetSortWeight(restaurantId);
  const value = sortWeightOf(typed, max);
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (value !== null) command.mutate(value);
  };
  return (
    <form onSubmit={submit} aria-label={t('restaurantAccount.pin')}>
      <label>
        {t('restaurantAccount.pinField', { max })}
        <input inputMode="numeric" value={typed} onChange={(e) => setTyped(e.target.value)} />
      </label>
      <button type="submit" disabled={command.isPending || value === null}>
        {t('restaurantAccount.pin')}
      </button>
      {command.isError && <p role="alert">{t('common.failed')}</p>}
      <Refused result={command.data} />
    </form>
  );
}

const emptyCommission: CommissionForm = { percent: '', when: 'now', at: '', reason: '' };

function Commission({ restaurantId, city }: { restaurantId: string; city: City }) {
  const { t } = useTranslation();
  const [form, setForm] = useState<CommissionForm>(emptyCommission);
  const command = useChangeCommission(restaurantId, city.timeZone);
  const set = (fields: Partial<CommissionForm>) => setForm((before) => ({ ...before, ...fields }));
  const submit = (event: FormEvent) => {
    event.preventDefault();
    command.mutate(form, {
      onSuccess: (result) => {
        if (result.status === 'done') setForm(emptyCommission);
      },
    });
  };
  return (
    <form onSubmit={submit} aria-label={t('restaurantAccount.changeCommission')}>
      <h3>{t('restaurantAccount.changeCommission')}</h3>
      <p>{t('restaurantAccount.newOrdersOnly')}</p>
      <label>
        {t('restaurantAccount.percent')}
        <input
          inputMode="decimal"
          value={form.percent}
          onChange={(e) => set({ percent: e.target.value })}
        />
      </label>
      <label>
        <input
          type="radio"
          name="when"
          checked={form.when === 'now'}
          onChange={() => set({ when: 'now' })}
        />
        {t('restaurantAccount.now')}
      </label>
      <label>
        <input
          type="radio"
          name="when"
          checked={form.when === 'at'}
          onChange={() => set({ when: 'at' })}
        />
        {t('restaurantAccount.at')}
      </label>
      {form.when === 'at' && (
        <label>
          {t('restaurantAccount.from')}
          <input
            type="datetime-local"
            value={form.at}
            onChange={(e) => set({ at: e.target.value })}
          />
        </label>
      )}
      <label>
        {t('restaurantAccount.reason')}
        <input
          value={form.reason}
          required
          maxLength={500}
          onChange={(e) => set({ reason: e.target.value })}
        />
      </label>
      <p>{t('restaurantAccount.ownersTold')}</p>
      <button type="submit" disabled={command.isPending}>
        {t('restaurantAccount.changeCommission')}
      </button>
      {command.isError && <p role="alert">{t('common.failed')}</p>}
      <Refused result={command.data} />
    </form>
  );
}
