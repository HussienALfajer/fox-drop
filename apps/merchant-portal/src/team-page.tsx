import { useQuery } from '@tanstack/react-query';
import { type FormEvent, use, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatDateTime, formatTime } from './format.js';
import { TimeZoneContext } from './live.js';
import { phoneOf } from './session.js';
import {
  type Device,
  type Pairing,
  type TeamAnswer,
  type TeamCommand,
  browserOf,
  devicesQuery,
  portalSessionsQuery,
  staffQuery,
  usePairWindows,
  useTeamCommand,
} from './team.js';

function Answer({ answer }: { answer: TeamAnswer | null }) {
  const { t } = useTranslation();
  if (answer?.status !== 'refused') return null;
  return <p role="alert">{t(`team.refusal.${answer.refusal}`)}</p>;
}

// RA §14.1, §17 (slice 2.45c): «الموظفون». Owners are listed read only (S5:
// they change through FOX DROP); a cashier is added by name and number and
// removed after a confirmation, signed out of every device at once.
export function StaffPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const staff = useQuery(staffQuery);
  const command = useTeamCommand();
  const [answer, setAnswer] = useState<TeamAnswer | null>(null);
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');

  function run(next: TeamCommand) {
    setAnswer(null);
    return command.mutateAsync(next).then((done) => {
      setAnswer(done);
      return done;
    });
  }

  function add(event: FormEvent) {
    event.preventDefault();
    const number = phoneOf(phone);
    if (number === null || name.trim() === '') {
      setAnswer({ status: 'refused', refusal: 'invalidPhone' });
      return;
    }
    void run({ kind: 'add_cashier', name: name.trim(), phone: number }).then((done) => {
      if (done.status === 'done') {
        setName('');
        setPhone('');
      }
    });
  }

  if (staff.isPending) return <p>{t('app.loading')}</p>;
  if (staff.isError) return <p role="alert">{t('app.error')}</p>;

  return (
    <main>
      <h1>{t('team.staff')}</h1>
      <Answer answer={answer} />
      {command.isError && <p role="alert">{t('app.error')}</p>}
      <p>{t('team.ownersNote')}</p>
      <ul>
        {staff.data.staff.map((member) => (
          <li key={member.accountId}>
            <strong>{member.name}</strong>{' '}
            {[
              t(`team.role.${member.role}`),
              member.phone,
              t('team.devicesCount', { count: member.devices }),
              member.lastActiveAt &&
                t('team.lastActive', { at: formatDateTime(member.lastActiveAt, timeZone) }),
            ]
              .filter(Boolean)
              .join(' · ')}{' '}
            {member.role === 'cashier' && (
              <button
                type="button"
                disabled={command.isPending}
                onClick={() => {
                  if (window.confirm(t('team.removeConfirm', { name: member.name }))) {
                    void run({ kind: 'remove_cashier', accountId: member.accountId });
                  }
                }}
              >
                {t('team.remove')}
              </button>
            )}
          </li>
        ))}
      </ul>
      <form onSubmit={add}>
        <fieldset disabled={command.isPending}>
          <legend>{t('team.addCashier')}</legend>
          <label>
            {t('team.name')}
            <input required maxLength={80} value={name} onChange={(e) => setName(e.target.value)} />
          </label>
          <label>
            {t('team.phone')}
            <input
              required
              inputMode="tel"
              dir="ltr"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />
          </label>
          <button type="submit">{t('team.add')}</button>
        </fieldset>
      </form>
    </main>
  );
}

// RA §14.2, §4.3, §17 (slice 2.45c): «الأجهزة»: each app installation with
// its user, ringing, connection and device check, renamed or signed out
// (the user stays); «ربط كمبيوتر بويندوز»; and the portal's own sessions
// (owner decision 2026-11-20), never devices, which an owner signs out.
export function DevicesPage() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const devices = useQuery(devicesQuery);
  const sessions = useQuery(portalSessionsQuery);
  const command = useTeamCommand();
  const [answer, setAnswer] = useState<TeamAnswer | null>(null);

  function run(next: TeamCommand) {
    setAnswer(null);
    void command.mutateAsync(next).then(setAnswer);
  }

  if (devices.isPending) return <p>{t('app.loading')}</p>;
  if (devices.isError) return <p role="alert">{t('app.error')}</p>;

  return (
    <main>
      <h1>{t('team.devices')}</h1>
      {devices.data.withoutDevice && <p role="alert">{t('team.noReceivingDevice')}</p>}
      <Answer answer={answer} />
      {command.isError && <p role="alert">{t('app.error')}</p>}
      <ul>
        {devices.data.devices.map((device) => (
          <DeviceRow key={device.deviceId} device={device} pending={command.isPending} run={run} />
        ))}
      </ul>
      {devices.data.devices.length === 0 && <p>{t('team.noDevices')}</p>}
      <PairWindows />
      <section>
        <h2>{t('team.portalSessions')}</h2>
        <p>{t('team.portalSessionsExplain')}</p>
        {sessions.isError && <p role="alert">{t('app.error')}</p>}
        <ul>
          {sessions.data?.sessions.map((session) => {
            const browser = browserOf(session.userAgent);
            return (
              <li key={session.sessionId}>
                <strong>{browser ? t('team.browserOn', browser) : t('team.unknownBrowser')}</strong>{' '}
                {[
                  session.ownerName,
                  t('team.signedInAt', { at: formatDateTime(session.signedInAt, timeZone) }),
                ].join(' · ')}{' '}
                {session.thisSession ? (
                  <em>{t('team.thisBrowser')}</em>
                ) : (
                  <button
                    type="button"
                    disabled={command.isPending}
                    onClick={() => {
                      if (window.confirm(t('team.signOutBrowserConfirm'))) {
                        run({ kind: 'sign_out_portal', sessionId: session.sessionId });
                      }
                    }}
                  >
                    {t('team.signOutBrowser')}
                  </button>
                )}
              </li>
            );
          })}
        </ul>
      </section>
    </main>
  );
}

function DeviceRow({
  device,
  pending,
  run,
}: {
  device: Device;
  pending: boolean;
  run: (command: TeamCommand) => void;
}) {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const [renaming, setRenaming] = useState(false);
  const [name, setName] = useState(device.name);

  function rename(event: FormEvent) {
    event.preventDefault();
    if (name.trim() === '') return;
    run({ kind: 'rename_device', deviceId: device.deviceId, name: name.trim() });
    setRenaming(false);
  }

  return (
    <li>
      <strong>{device.name}</strong>{' '}
      {[
        t('team.deviceDetails', {
          platform: t(`team.platform.${device.platform}`),
          version: device.appVersion,
        }),
        device.user &&
          t('team.deviceUser', {
            name: device.user.name,
            role: t(`team.role.${device.user.role}`),
          }),
        device.signedIn ? t('team.signedIn') : t('team.signedOut'),
        device.connected
          ? t('team.connected')
          : device.lastSeenAt
            ? t('team.lastSeen', { at: formatDateTime(device.lastSeenAt, timeZone) })
            : t('team.notConnected'),
        device.ringing ? t('team.ringing') : t('team.silent'),
        device.deviceCheck === null
          ? t('team.notChecked')
          : device.deviceCheck.passed
            ? t('team.checkPassed')
            : t('team.checkFailed'),
        device.deviceCheck &&
          t('team.checkedAt', { at: formatDateTime(device.deviceCheck.at, timeZone) }),
      ]
        .filter(Boolean)
        .join(' · ')}{' '}
      {renaming ? (
        <form onSubmit={rename}>
          <label>
            {t('team.deviceName')}
            <input required maxLength={60} value={name} onChange={(e) => setName(e.target.value)} />
          </label>
          <button type="submit" disabled={pending}>
            {t('team.save')}
          </button>
          <button type="button" onClick={() => setRenaming(false)}>
            {t('team.cancel')}
          </button>
        </form>
      ) : (
        <button type="button" disabled={pending} onClick={() => setRenaming(true)}>
          {t('team.rename')}
        </button>
      )}{' '}
      {device.signedIn && (
        <button
          type="button"
          disabled={pending}
          onClick={() => {
            if (window.confirm(t('team.signOutDeviceConfirm', { name: device.name }))) {
              run({ kind: 'sign_out_device', deviceId: device.deviceId });
            }
          }}
        >
          {t('team.signOutDevice')}
        </button>
      )}
    </li>
  );
}

// The code is shown once and kept only in this page's memory.
function PairWindows() {
  const { t } = useTranslation();
  const timeZone = use(TimeZoneContext);
  const pair = usePairWindows();
  const [pairing, setPairing] = useState<Pairing | null>(null);
  const [refused, setRefused] = useState<TeamAnswer | null>(null);

  function ask() {
    setRefused(null);
    void pair.mutateAsync().then((answer) => {
      if (answer.status === 'done') setPairing(answer.pairing);
      else setRefused(answer);
    });
  }

  return (
    <section>
      <h2>{t('team.pairWindows')}</h2>
      <p>{t('team.pairWindowsIntro')}</p>
      {pairing && (
        <>
          <p>
            <output aria-label={t('team.pairingCode')} dir="ltr">
              {pairing.code}
            </output>
          </p>
          <p>{t('team.pairWindowsHow', { until: formatTime(pairing.expiresAt, timeZone) })}</p>
        </>
      )}
      <Answer answer={refused} />
      {pair.isError && <p role="alert">{t('team.pairFailed')}</p>}
      <button type="button" disabled={pair.isPending} onClick={ask}>
        {pairing ? t('team.pairAgain') : t('team.pairWindows')}
      </button>
    </section>
  );
}
