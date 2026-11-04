// Architecture §16: logs never contain codes, tokens or full phone numbers.

const SECRET_KEYS = new Set([
  'accesstoken',
  'apikey',
  'authorization',
  'backupcode',
  'code',
  'cookie',
  'idtoken',
  'otp',
  'password',
  'refreshtoken',
  'secret',
  'setcookie',
  'token',
  'totp',
]);

const PHONE_KEYS = new Set(['mobile', 'msisdn', 'phone', 'phonenumber']);

// E.164 numbers and Syrian local mobile numbers (09XXXXXXXX).
const PHONE_PATTERN = /\+\d{8,15}|(?<!\d)09\d{8}(?!\d)/g;

export const REDACTED = '[REDACTED]';

function normalKey(key: string): string {
  return key.toLowerCase().replace(/[-_]/g, '');
}

export function maskPhone(phone: string): string {
  return `***${phone.replace(/\D/g, '').slice(-2)}`;
}

export function redactText(text: string): string {
  return text.replace(PHONE_PATTERN, maskPhone);
}

function isPlainObject(value: unknown): value is Record<string, unknown> {
  if (typeof value !== 'object' || value === null) return false;
  const prototype = Object.getPrototypeOf(value) as unknown;
  return prototype === Object.prototype || prototype === null;
}

// Walks plain objects and arrays only: requests, errors and other class
// instances go through their own serializers.
export function redact(value: unknown, key?: string): unknown {
  if (key !== undefined) {
    const normal = normalKey(key);
    if (SECRET_KEYS.has(normal)) return REDACTED;
    if (PHONE_KEYS.has(normal) && typeof value === 'string') return maskPhone(value);
  }
  if (typeof value === 'string') return redactText(value);
  if (Array.isArray(value)) return value.map((item) => redact(item));
  if (isPlainObject(value)) {
    return Object.fromEntries(Object.entries(value).map(([k, v]) => [k, redact(v, k)]));
  }
  return value;
}
