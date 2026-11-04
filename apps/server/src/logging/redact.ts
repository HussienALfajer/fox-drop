// Architecture §16: logs never contain codes, tokens or full phone numbers.
// Redaction runs on the finished JSON line, after pino's serializers, so it
// covers fields, child bindings, errors and messages alike.

// A field is secret when its normalised name ends with one of these.
const SECRET_SUFFIXES = [
  'apikey',
  'authorization',
  'code',
  'codes',
  'cookie',
  'otp',
  'passwd',
  'password',
  'pin',
  'privatekey',
  'secret',
  'secrets',
  'token',
  'tokens',
  'totp',
];

// Fields that end like a secret but are not one.
const NOT_SECRET = new Set(['countrycode', 'currencycode', 'errorcode', 'statuscode']);

const PHONE_SUFFIXES = ['mobile', 'msisdn', 'phone', 'phonenumber', 'phones'];

const PHONE_PATTERNS = [
  // WhatsApp ids, as the otp-sender's library logs them.
  /(?<!\d)\d{8,15}@s\.whatsapp\.net/g,
  // International, with + or 00, digit groups optionally split by spaces or dashes.
  /(?:\+|(?<!\d)00)\d(?:[\s-]?\d){7,14}(?!\d)/g,
  // Syrian numbers without a prefix: 963XXXXXXXXX and 09XXXXXXXX.
  /(?<!\d)963(?:[\s-]?\d){9}(?!\d)/g,
  /(?<!\d)09\d(?:[\s-]?\d){7}(?!\d)/g,
];

// Error codes such as ECONNREFUSED or FST_ERR_VALIDATION stay readable.
const ERROR_CODE = /^[A-Z][A-Z0-9_]*$/;

export const REDACTED = '[REDACTED]';

function normalKey(key: string): string {
  return key.toLowerCase().replace(/[-_\s]/g, '');
}

function endsWithAny(key: string, suffixes: string[]): boolean {
  return suffixes.some((suffix) => key.endsWith(suffix));
}

export function maskPhone(phone: string): string {
  return `***${phone.replace(/\D/g, '').slice(-2)}`;
}

export function redactText(text: string): string {
  return PHONE_PATTERNS.reduce((result, pattern) => result.replace(pattern, maskPhone), text);
}

// `value` is parsed JSON, so it holds no cycles and no class instances.
export function redact(value: unknown, key?: string, inError = false): unknown {
  if (key !== undefined) {
    const normal = normalKey(key);
    const keepErrorCode =
      inError && normal === 'code' && typeof value === 'string' && ERROR_CODE.test(value);
    if (endsWithAny(normal, SECRET_SUFFIXES) && !NOT_SECRET.has(normal) && !keepErrorCode) {
      return REDACTED;
    }
    if (
      endsWithAny(normal, PHONE_SUFFIXES) &&
      (typeof value === 'string' || typeof value === 'number')
    ) {
      return maskPhone(String(value));
    }
  }
  if (typeof value === 'string') return redactText(value);
  if (Array.isArray(value)) return value.map((item) => redact(item, undefined, inError));
  if (typeof value === 'object' && value !== null) {
    return Object.fromEntries(
      Object.entries(value).map(([k, v]) => [k, redact(v, k, inError || k === 'err')]),
    );
  }
  return value;
}

// Redacts one line as pino writes it.
export function redactLine(line: string): string {
  try {
    return `${JSON.stringify(redact(JSON.parse(line)))}\n`;
  } catch {
    return redactText(line);
  }
}
