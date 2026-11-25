import { parsePhoneNumberFromString } from 'libphonenumber-js/max';

// Architecture §15.3: a number in the panel is masked unless its holder must
// act on it: its own calling code and its last three digits, such as
// «+963 ••• 456» or «+44 ••• 123» (slice D.11a). Shared, not identity's: the
// modules that mask a number (captains, customers, reporting) must not load
// identity's entry, which loads them.
export function maskedPhone(phone: string): string {
  const code = parsePhoneNumberFromString(phone)?.countryCallingCode;
  return `${code === undefined ? '+' : `+${code}`} ••• ${phone.slice(-3)}`;
}
