import { useMutation } from '@tanstack/react-query';
import QRCode from 'qrcode';
import { api } from './api.js';

// AP §5.1 item 3: the owner shares /setup#token=<token>; the fragment never
// reaches a server log.
export function setupToken(hash: string): string | null {
  const token = new URLSearchParams(hash.replace(/^#/, '')).get('token');
  return token && token.length > 0 ? token : null;
}

export type SetupRefusal =
  | 'link_invalid'
  | 'enrolment_not_started'
  | 'password_too_short'
  | 'password_invalid'
  | 'account_locked'
  | 'code_invalid'
  | 'password_mismatch';

type Refused = { refusal: SetupRefusal; passwordMinLength?: number };

const refusals: readonly string[] = [
  'link_invalid',
  'enrolment_not_started',
  'password_too_short',
  'password_invalid',
  'account_locked',
  'code_invalid',
] satisfies SetupRefusal[];

// A 400 names its refusal; one without a known refusal failed validation, a
// malformed field, which the caller maps to the refusal it means.
function refusalOf(response: Response, error: unknown, malformed: SetupRefusal): Refused | null {
  if (response.status !== 400) return null;
  const body = (typeof error === 'object' && error !== null ? error : {}) as {
    error?: unknown;
    passwordMinLength?: unknown;
  };
  if (typeof body.error !== 'string' || !refusals.includes(body.error)) {
    return { refusal: malformed };
  }
  return {
    refusal: body.error as SetupRefusal,
    ...(typeof body.passwordMinLength === 'number'
      ? { passwordMinLength: body.passwordMinLength }
      : {}),
  };
}

export type Enrolment =
  { status: 'enrolling'; secret: string; otpauthUri: string } | ({ status: 'refused' } & Refused);

// Each call offers a new secret, and only the last one offered is checked, so
// this runs on a click and never again by itself.
export function useStartEnrolment(token: string) {
  return useMutation({
    mutationFn: async (): Promise<Enrolment> => {
      const { data, error, response } = await api.POST('/v1/admin/auth/setup/totp', {
        body: { token },
      });
      if (data) return { status: 'enrolling', ...data };
      const refused = refusalOf(response, error, 'link_invalid');
      if (refused) return { status: 'refused', ...refused };
      throw new Error('The TOTP enrolment failed.');
    },
  });
}

// The QR code as an SVG path of its dark modules, drawn inline: the panel's
// Content-Security-Policy (`default-src 'self'`) refuses a data: image.
export function qrCodePath(otpauthUri: string): { size: number; path: string } {
  const { modules } = QRCode.create(otpauthUri, { errorCorrectionLevel: 'M' });
  let path = '';
  for (let y = 0; y < modules.size; y++) {
    for (let x = 0; x < modules.size; x++) {
      if (modules.get(y, x)) path += `M${x} ${y}h1v1h-1z`;
    }
  }
  return { size: modules.size, path };
}

export type SetupResult =
  { status: 'done'; backupCodes: string[] } | ({ status: 'refused' } & Refused);

// The backup codes are shown once: the result leaves the cache as soon as
// the page closes.
export function useCompleteSetup(token: string) {
  return useMutation({
    gcTime: 0,
    mutationFn: async (input: {
      password: string;
      confirmation: string;
      code: string;
    }): Promise<SetupResult> => {
      // Typed twice: AP §5.3 has no password reset, so a typo here would keep
      // the person out for good.
      if (input.password !== input.confirmation) {
        return { status: 'refused', refusal: 'password_mismatch' };
      }
      const { data, error, response } = await api.POST('/v1/admin/auth/setup/complete', {
        body: { token, password: input.password, code: input.code },
      });
      if (data) return { status: 'done', backupCodes: data.backupCodes };
      // The code is the only field the form lets through malformed.
      const refused = refusalOf(response, error, 'code_invalid');
      if (refused) return { status: 'refused', ...refused };
      throw new Error('The setup failed.');
    },
  });
}
