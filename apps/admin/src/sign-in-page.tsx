import { useNavigate } from '@tanstack/react-router';
import type { FormEvent } from 'react';
import { useTranslation } from 'react-i18next';
import { useSignIn } from './session.js';

// AP §5.1 items 1–2: the email or phone, the password, then the TOTP code or a
// backup code, in one form.
export function SignInPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const signIn = useSignIn();

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    signIn.mutate(
      {
        login: String(form.get('login')).trim(),
        password: String(form.get('password')),
        code: String(form.get('code')).trim(),
      },
      {
        onSuccess: (result) => {
          if (result === 'signed_in') void navigate({ to: '/' });
        },
      },
    );
  }

  return (
    <main>
      <h1>{t('signIn.title')}</h1>
      <form onSubmit={submit}>
        <p>
          <label>
            {t('signIn.login')}
            <input name="login" autoComplete="username" dir="ltr" required maxLength={254} />
          </label>
        </p>
        <p>
          <label>
            {t('signIn.password')}
            <input
              name="password"
              type="password"
              autoComplete="current-password"
              required
              maxLength={256}
            />
          </label>
        </p>
        <p>
          <label>
            {t('signIn.code')}
            <input name="code" autoComplete="one-time-code" dir="ltr" required maxLength={20} />
          </label>
        </p>
        <button type="submit" disabled={signIn.isPending}>
          {t('signIn.submit')}
        </button>
      </form>
      {signIn.data === 'refused' && <p role="alert">{t('signIn.refused')}</p>}
      {signIn.isError && <p role="alert">{t('common.failed')}</p>}
    </main>
  );
}
