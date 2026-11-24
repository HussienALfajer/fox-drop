import { parsePhoneNumberFromString } from 'libphonenumber-js/max';
import { z } from 'zod';

// CU U3, §5.2 item 1 (owner decision 2026-11-24): the apps take a mobile
// number of any country, in E.164. A restaurant user's and a captain's number
// follow it too, or they could never sign in.
const E164 = /^\+[1-9]\d{7,14}$/;

// Today's Syrian (+963 9…, 9 digits) and Turkish (+90 5…, 10 digits) rule
// stays taken: the metadata refuses some numbers it took, such as +96391…
// (slice D.11a plan critique).
const SYRIA_OR_TURKEY_MOBILE = /^(\+9639\d{8}|\+905\d{9})$/;

export function isAppMobile(phone: string): boolean {
  if (!E164.test(phone)) return false;
  if (SYRIA_OR_TURKEY_MOBILE.test(phone)) return true;
  const parsed = parsePhoneNumberFromString(phone);
  if (parsed === undefined || !parsed.isValid()) return false;
  // Countries such as the United States do not tell the two apart.
  const type = parsed.getType();
  return type === 'MOBILE' || type === 'FIXED_LINE_OR_MOBILE';
}

// The number the apps' routes take: the E.164 shape (the OpenAPI pattern)
// and a mobile.
export const appPhone = z
  .string()
  .regex(E164)
  .refine(isAppMobile, { message: 'not a mobile number' });

// Architecture §8.3.3 item 2 (owner decision 2026-11-24): a number outside
// Syria (+963) and Turkey (+90) has a daily code limit of its own. No other
// calling code starts with 963 or 90.
export function signsInAbroad(phone: string): boolean {
  return !phone.startsWith('+963') && !phone.startsWith('+90');
}

export { maskedPhone } from '../../phone/masked-phone.js';
