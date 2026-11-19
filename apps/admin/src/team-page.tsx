import { useQuery } from '@tanstack/react-query';
import { getRouteApi } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatDateTime } from './format.js';
import { useCitySettings } from './city-settings.js';
import { GroupSettings } from './settings-page.js';
import {
  CAP_KEYS,
  type NewUserForm,
  type NewUserProblem,
  ROLES,
  type Role,
  type TeamAction,
  type TeamRefusal,
  type TeamResult,
  type TeamUser,
  actionsOf,
  emptyNewUser,
  isRole,
  matrixRows,
  newUserRequestOf,
  roleMatrixQuery,
  setupLinkOf,
  teamQuery,
  useTeamCommand,
} from './team.js';

const route = getRouteApi('/signed-in/team');
const signedIn = getRouteApi('/signed-in');

const refusalKeys = {
  name_taken: 'team.refused.nameTaken',
  last_owner: 'team.refused.lastOwner',
  own_account: 'team.refused.ownAccount',
  wrong_status: 'team.refused.wrongStatus',
  not_found: 'team.refused.notFound',
  forbidden: 'team.refused.forbidden',
  invalid: 'team.refused.invalid',
} as const satisfies Record<TeamRefusal, string>;

const problemKeys = {
  name_required: 'team.problem.name',
  contact_required: 'team.problem.contact',
  roles_required: 'team.problem.roles',
} as const satisfies Record<NewUserProblem, string>;

const actionKeys = {
  setup_link: 'team.action.setupLink',
  totp_reset: 'team.action.totpReset',
  sign_out: 'team.action.signOut',
  disable: 'team.action.disable',
  enable: 'team.action.enable',
} as const satisfies Record<TeamAction, string>;

// A second press confirms what locks a user out (AP §7.4).
const confirmKeys: Partial<Record<TeamAction, string>> = {
  disable: 'team.confirm.disable',
  totp_reset: 'team.confirm.totpReset',
  sign_out: 'team.confirm.signOut',
};

// AP §9.15 «فريق الإدارة» (OWN; slice 2.38b): the users with their roles,
// status, TOTP, last sign-in and open sessions; «مستخدم جديد» with its setup
// link; each user's actions; the read-only role matrix (AP §6) with the
// compensation cap per role editable (AP §6.4). Unstyled until the design.
export function TeamPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const users = useQuery(teamQuery);
  const command = useTeamCommand();
  return (
    <main>
      <h1>{t('team.title')}</h1>
      <NewUser command={command} timeZone={city?.timeZone ?? 'Asia/Damascus'} />
      <h2>{t('team.users')}</h2>
      {users.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !users.data || !city ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <ul>
          {users.data.map((user) => (
            <li key={user.id}>
              <UserCard user={user} city={city} command={command} />
            </li>
          ))}
        </ul>
      )}
      <RoleMatrixSection city={city} />
    </main>
  );
}

type Command = ReturnType<typeof useTeamCommand>;

// A command's answer as the card shows it, or a request that failed.
type Shown = TeamResult | { status: 'failed' };

function RolesText({ roles }: { roles: readonly string[] }) {
  const { t } = useTranslation();
  return (
    <>
      {roles
        .map((role) => (isRole(role) ? t(`team.role.${role}`) : role))
        .join(t('team.separator'))}
    </>
  );
}

function ResultLine({ result, timeZone }: { result: Shown | undefined; timeZone: string }) {
  const { t } = useTranslation();
  if (!result) return null;
  if (result.status === 'failed') return <p role="alert">{t('common.failed')}</p>;
  if (result.status === 'refused') return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
  if (result.status === 'done') return <p role="status">{t('team.done')}</p>;
  return <SetupLink token={result.token} expiresAt={result.expiresAt} timeZone={timeZone} />;
}

// Shown once: the server keeps only its hash.
function SetupLink({
  token,
  expiresAt,
  timeZone,
}: {
  token: string;
  expiresAt: string;
  timeZone: string;
}) {
  const { t } = useTranslation();
  const link = setupLinkOf(window.location.origin, token);
  return (
    <div role="status">
      <p>{t('team.link.explain')}</p>
      <label>
        {t('team.link.label')}
        <input readOnly value={link} onFocus={(event) => event.currentTarget.select()} />
      </label>
      <p>{t('team.link.expires', { at: formatDateTime(expiresAt, timeZone) })}</p>
    </div>
  );
}

function RoleChoices({
  roles,
  onChange,
  disabled,
}: {
  roles: Role[];
  onChange: (roles: Role[]) => void;
  disabled?: boolean;
}) {
  const { t } = useTranslation();
  return (
    <fieldset disabled={disabled}>
      <legend>{t('team.roles')}</legend>
      {ROLES.map((role) => (
        <label key={role}>
          <input
            type="checkbox"
            checked={roles.includes(role)}
            onChange={(event) =>
              onChange(
                event.target.checked ? [...roles, role] : roles.filter((each) => each !== role),
              )
            }
          />
          {t(`team.role.${role}`)}
        </label>
      ))}
    </fieldset>
  );
}

function NewUser({ command, timeZone }: { command: Command; timeZone: string }) {
  const { t } = useTranslation();
  const [form, setForm] = useState<NewUserForm>(emptyNewUser);
  const [problem, setProblem] = useState<NewUserProblem | null>(null);
  const [result, setResult] = useState<Shown>();
  function submit(event: FormEvent) {
    event.preventDefault();
    const request = newUserRequestOf(form);
    setResult(undefined);
    if (!request.ok) {
      setProblem(request.problem);
      return;
    }
    setProblem(null);
    command.mutate(
      { kind: 'create', body: request.body },
      {
        onError: () => setResult({ status: 'failed' }),
        onSuccess: (answer) => {
          setResult(answer);
          if (answer.status === 'link') setForm(emptyNewUser);
        },
      },
    );
  }
  return (
    <section>
      <h2>{t('team.new.title')}</h2>
      <form onSubmit={submit}>
        <label>
          {t('team.new.name')}
          <input value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
        </label>
        <label>
          {t('team.new.email')}
          <input
            type="email"
            value={form.email}
            onChange={(e) => setForm({ ...form, email: e.target.value })}
          />
        </label>
        <label>
          {t('team.new.phone')}
          <input
            type="tel"
            dir="ltr"
            value={form.phone}
            onChange={(e) => setForm({ ...form, phone: e.target.value })}
          />
        </label>
        <p>{t('team.new.contactHint')}</p>
        <RoleChoices roles={form.roles} onChange={(roles) => setForm({ ...form, roles })} />
        {problem && <p role="alert">{t(problemKeys[problem])}</p>}
        <button type="submit" disabled={command.isPending}>
          {t('team.new.submit')}
        </button>
      </form>
      <ResultLine result={result} timeZone={timeZone} />
    </section>
  );
}

function UserCard({ user, city, command }: { user: TeamUser; city: City; command: Command }) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const [result, setResult] = useState<Shown>();
  const [confirming, setConfirming] = useState<TeamAction | null>(null);
  const [roles, setRoles] = useState<Role[]>(user.roles.filter(isRole));
  // Another owner's change read again replaces the choice not saved.
  const [seed, setSeed] = useState(user.roles.join());
  if (seed !== user.roles.join()) {
    setSeed(user.roles.join());
    setRoles(user.roles.filter(isRole));
  }
  const changed =
    roles.length !== user.roles.length || roles.some((role) => !user.roles.includes(role));
  function act(kind: TeamAction) {
    if (confirmKeys[kind] && confirming !== kind) {
      setConfirming(kind);
      return;
    }
    setConfirming(null);
    command.mutate(
      { kind, accountId: user.id },
      { onSuccess: setResult, onError: () => setResult({ status: 'failed' }) },
    );
  }
  return (
    <article>
      <h3>{user.name ?? t('team.noName')}</h3>
      <dl>
        <dt>{t('team.phone')}</dt>
        <dd dir="ltr">{user.phone ?? t('team.none')}</dd>
        <dt>{t('team.email')}</dt>
        <dd dir="ltr">{user.email ?? t('team.none')}</dd>
        <dt>{t('team.roles')}</dt>
        <dd>
          <RolesText roles={user.roles} />
        </dd>
        <dt>{t('team.status')}</dt>
        <dd>{t(`team.statusLabel.${user.status}`)}</dd>
        <dt>{t('team.totp')}</dt>
        <dd>{user.totpEnrolled ? t('team.totpOn') : t('team.totpOff')}</dd>
        <dt>{t('team.lastSignIn')}</dt>
        <dd>
          {user.lastSignInAt ? formatDateTime(user.lastSignInAt, city.timeZone) : t('team.never')}
        </dd>
        <dt>{t('team.sessions', { count: user.openSessions.length })}</dt>
        <dd>
          <ul>
            {user.openSessions.map((open) => (
              <li key={open.id}>
                {t('team.session', {
                  device: open.userAgent ?? t('team.none'),
                  ip: open.ipAddress ?? t('team.none'),
                  at: formatDateTime(open.lastActivityAt, city.timeZone),
                })}
              </li>
            ))}
          </ul>
        </dd>
      </dl>
      <form
        onSubmit={(event) => {
          event.preventDefault();
          command.mutate(
            { kind: 'roles', accountId: user.id, roles },
            { onSuccess: setResult, onError: () => setResult({ status: 'failed' }) },
          );
        }}
      >
        <RoleChoices roles={roles} onChange={setRoles} />
        <button type="submit" disabled={!changed || roles.length === 0 || command.isPending}>
          {t('team.saveRoles')}
        </button>
      </form>
      {actionsOf(user, session.accountId).map((kind) => (
        <button key={kind} type="button" onClick={() => act(kind)} disabled={command.isPending}>
          {confirming === kind
            ? t(confirmKeys[kind] as 'team.confirm.disable')
            : t(actionKeys[kind])}
        </button>
      ))}
      <ResultLine result={result} timeZone={city.timeZone} />
    </article>
  );
}

// AP §6: read-only in V1, with each role's compensation cap (AP §6.4) as
// its settings, edited where «الإعدادات» edits them.
function RoleMatrixSection({ city }: { city: City | undefined }) {
  const { t } = useTranslation();
  const matrix = useQuery(roleMatrixQuery);
  const settings = useCitySettings(city?.id);
  const caps = settings.data?.filter((entry) => CAP_KEYS.includes(entry.key)) ?? [];
  return (
    <section>
      <h2>{t('team.matrix.title')}</h2>
      <p>{t('team.matrix.explain')}</p>
      {matrix.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !matrix.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th scope="col">{t('team.matrix.permission')}</th>
              {ROLES.map((role) => (
                <th key={role} scope="col">
                  {t(`team.role.${role}`)}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {matrixRows(matrix.data).map((row) => (
              <tr key={row.permission}>
                <th scope="row">
                  <PermissionName code={row.permission} />
                </th>
                {ROLES.map((role) => (
                  <td key={role}>
                    {row.roles.has(role) ? t('team.matrix.yes') : t('team.matrix.no')}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <h3>{t('team.caps.title')}</h3>
      <ul>
        <li>{t('team.caps.own')}</li>
        <li>{t('team.caps.none')}</li>
      </ul>
      {settings.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !settings.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <GroupSettings city={city} entries={caps} />
      )}
    </section>
  );
}

// A permission by its Arabic name; one the panel does not name shows its
// code, so the matrix never hides a row.
function PermissionName({ code }: { code: string }) {
  const { t, i18n } = useTranslation();
  const key = `team.permission.${code}`;
  return <>{i18n.exists(key) ? t(key as 'team.title') : code}</>;
}
