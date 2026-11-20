import { useQuery } from '@tanstack/react-query';
import { useNavigate } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { serverNow, useServerNow } from './clock.js';
import {
  type CodeRefusal,
  callLink,
  contactQuery,
  phoneOf,
  useRequestCode,
  useSignIn,
  whatsappLink,
} from './session.js';

// RA §5.2, §17: the owner's number, then the WhatsApp code.
export function SignInPage() {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const now = useServerNow();
  const requestCode = useRequestCode();
  const signIn = useSignIn();
  const [typed, setTyped] = useState('');
  const [phone, setPhone] = useState<string | null>(null);
  const [operationsCode, setOperationsCode] = useState(false);
  const [code, setCode] = useState('');
  const [resendAt, setResendAt] = useState(0);
  const [refusal, setRefusal] = useState<{ refusal: CodeRefusal; retryAfterSec: number | null }>();
  const [message, setMessage] = useState<string | null>(null);

  async function send(number: string) {
    setRefusal(undefined);
    setMessage(null);
    const result = await requestCode.mutateAsync(number);
    if (result.status === 'sent') {
      setPhone(number);
      setOperationsCode(false);
      setResendAt(serverNow() + result.resendAfterSec * 1000);
    } else {
      setRefusal(result);
    }
  }

  function submitPhone(event: FormEvent) {
    event.preventDefault();
    const number = phoneOf(typed);
    if (!number) {
      setRefusal({ refusal: 'invalid_phone', retryAfterSec: null });
      return;
    }
    void send(number);
  }

  async function submitCode(event: FormEvent) {
    event.preventDefault();
    if (!phone) return;
    setMessage(null);
    const result = await signIn.mutateAsync({ phone, code: code.trim() });
    if (result.status === 'signed_in') {
      await navigate({ to: '/orders' });
    } else if (result.status === 'wrong_code') {
      setMessage(t('signIn.wrongCode', { attempts: result.attemptsLeft }));
    } else if (result.status === 'code_expired') {
      setMessage(t('signIn.codeExpired'));
    } else {
      setMessage(refusalText(result.refusal, null));
    }
  }

  function refusalText(refusal: CodeRefusal, retryAfterSec: number | null): string {
    return t(`signIn.refusal.${refusal}`, {
      seconds: retryAfterSec ?? 0,
      minutes: Math.ceil((retryAfterSec ?? 60) / 60),
    });
  }

  const failed = requestCode.isError || signIn.isError;
  const resendLeft = Math.ceil((resendAt - now) / 1000);

  return (
    <main>
      <h1>{t('signIn.title')}</h1>
      <p>{t('signIn.ownersOnly')}</p>
      {phone === null ? (
        <form onSubmit={submitPhone}>
          <label>
            {t('signIn.phoneLabel')}
            <input
              type="tel"
              dir="ltr"
              autoComplete="tel"
              value={typed}
              placeholder={t('signIn.phoneHint')}
              onChange={(event) => setTyped(event.target.value)}
            />
          </label>
          <button type="submit" disabled={requestCode.isPending}>
            {t('signIn.sendCode')}
          </button>
        </form>
      ) : (
        <form onSubmit={(event) => void submitCode(event)}>
          <p>
            {operationsCode
              ? t('signIn.operationsCodeHint', { phone })
              : t('signIn.codeSent', { phone })}
          </p>
          <label>
            {t('signIn.codeLabel')}
            <input
              inputMode="numeric"
              autoComplete="one-time-code"
              dir="ltr"
              maxLength={6}
              value={code}
              onChange={(event) => setCode(event.target.value)}
            />
          </label>
          <button type="submit" disabled={signIn.isPending || code.trim().length !== 6}>
            {t('signIn.confirm')}
          </button>
          <button
            type="button"
            disabled={requestCode.isPending || resendLeft > 0}
            onClick={() => void send(phone)}
          >
            {resendLeft > 0 ? t('signIn.resendIn', { seconds: resendLeft }) : t('signIn.resend')}
          </button>
          <button
            type="button"
            onClick={() => {
              setPhone(null);
              setCode('');
              setMessage(null);
            }}
          >
            {t('signIn.editPhone')}
          </button>
        </form>
      )}
      {refusal && (
        <div role="alert">
          <p>{refusalText(refusal.refusal, refusal.retryAfterSec)}</p>
          {(refusal.refusal === 'not_registered' || refusal.refusal === 'unavailable') && (
            <ContactButtons />
          )}
          {refusal.refusal === 'unavailable' && (
            <button
              type="button"
              onClick={() => {
                const number = phoneOf(typed);
                if (!number) return;
                setPhone(number);
                setOperationsCode(true);
                setRefusal(undefined);
              }}
            >
              {t('signIn.operationsCode')}
            </button>
          )}
        </div>
      )}
      {message && <p role="alert">{message}</p>}
      {failed && <p role="alert">{t('app.error')}</p>}
    </main>
  );
}

function ContactButtons() {
  const { t } = useTranslation();
  const contact = useQuery(contactQuery);
  return (
    <p>
      {contact.data?.phone && (
        <a href={callLink(contact.data.phone)}>{t('signIn.callOperations')}</a>
      )}{' '}
      {contact.data?.whatsapp && (
        <a href={whatsappLink(contact.data.whatsapp)} target="_blank" rel="noreferrer">
          {t('signIn.whatsappOperations')}
        </a>
      )}
    </p>
  );
}
