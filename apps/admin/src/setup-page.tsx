import { Link } from '@tanstack/react-router';
import { type FormEvent, useMemo } from 'react';
import { useTranslation } from 'react-i18next';
import {
  setupToken,
  type SetupRefusal,
  useCompleteSetup,
  qrCodePath,
  useStartEnrolment,
} from './setup.js';

const refusalKeys = {
  link_invalid: 'setup.refused.linkInvalid',
  enrolment_not_started: 'setup.refused.enrolmentNotStarted',
  password_too_short: 'setup.refused.passwordTooShort',
  password_invalid: 'setup.refused.passwordInvalid',
  account_locked: 'setup.refused.accountLocked',
  code_invalid: 'setup.refused.codeInvalid',
  password_mismatch: 'setup.refused.passwordMismatch',
} as const satisfies Record<SetupRefusal, string>;

// AP §5.1 item 3: the first sign-in (and a TOTP reset) from the setup link.
export function SetupPage() {
  const { t } = useTranslation();
  const token = setupToken(window.location.hash);
  if (!token) {
    return (
      <main>
        <h1>{t('setup.title')}</h1>
        <p role="alert">{t('setup.refused.linkInvalid')}</p>
      </main>
    );
  }
  return <Setup token={token} />;
}

function Setup({ token }: { token: string }) {
  const { t } = useTranslation();
  const enrolment = useStartEnrolment(token);
  const setup = useCompleteSetup(token);
  // An enrolment the server no longer holds starts again from the button.
  const restart =
    setup.data?.status === 'refused' && setup.data.refusal === 'enrolment_not_started';
  const enrolling = enrolment.data?.status === 'enrolling' && !restart ? enrolment.data : undefined;

  function start() {
    setup.reset();
    enrolment.mutate();
  }

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    setup.mutate({
      password: String(form.get('password')),
      confirmation: String(form.get('confirmation')),
      code: String(form.get('code')).trim(),
    });
  }

  if (setup.data?.status === 'done') {
    return (
      <main>
        <h1>{t('setup.backupCodes.title')}</h1>
        <p>{t('setup.backupCodes.once')}</p>
        <ol dir="ltr">
          {setup.data.backupCodes.map((code) => (
            <li key={code}>
              <code>{code}</code>
            </li>
          ))}
        </ol>
        <Link to="/sign-in">{t('setup.backupCodes.signIn')}</Link>
      </main>
    );
  }

  const refused =
    setup.data?.status === 'refused'
      ? setup.data
      : enrolment.data?.status === 'refused'
        ? enrolment.data
        : undefined;

  return (
    <main>
      <h1>{t('setup.title')}</h1>
      {!enrolling ? (
        <>
          <p>{t('setup.start.explain')}</p>
          <button type="button" onClick={start} disabled={enrolment.isPending}>
            {t('setup.start.button')}
          </button>
        </>
      ) : (
        <>
          <p>{t('setup.scan')}</p>
          <QrCode otpauthUri={enrolling.otpauthUri} />
          <p>
            {t('setup.secret')} <code dir="ltr">{enrolling.secret}</code>
          </p>
          <form onSubmit={submit}>
            <p>{t('setup.passwordHint')}</p>
            <p>
              <label>
                {t('setup.password')}
                <input name="password" type="password" required maxLength={256} />
              </label>
            </p>
            <p>
              <label>
                {t('setup.confirmation')}
                <input name="confirmation" type="password" required maxLength={256} />
              </label>
            </p>
            <p>
              <label>
                {t('setup.code')}
                <input
                  name="code"
                  autoComplete="one-time-code"
                  inputMode="numeric"
                  dir="ltr"
                  required
                  pattern="\d{6}"
                  maxLength={6}
                />
              </label>
            </p>
            <button type="submit" disabled={setup.isPending}>
              {t('setup.submit')}
            </button>
          </form>
        </>
      )}
      {refused && (
        <p role="alert">
          {t(refusalKeys[refused.refusal], { min: refused.passwordMinLength ?? 0 })}
        </p>
      )}
      {(enrolment.isError || setup.isError) && <p role="alert">{t('common.failed')}</p>}
    </main>
  );
}

function QrCode({ otpauthUri }: { otpauthUri: string }) {
  const { t } = useTranslation();
  const { size, path } = useMemo(() => qrCodePath(otpauthUri), [otpauthUri]);
  // Four modules of quiet zone around the code, on white.
  const viewBox = [-4, -4, size + 8, size + 8].join(' ');
  return (
    <svg
      role="img"
      aria-label={t('setup.qrAlt')}
      viewBox={viewBox}
      width={(size + 8) * 6}
      height={(size + 8) * 6}
      shapeRendering="crispEdges"
    >
      <rect x={-4} y={-4} width={size + 8} height={size + 8} fill="#fff" />
      <path d={path} fill="#000" />
    </svg>
  );
}
