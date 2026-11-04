import { parseArgs } from 'node:util';
import type { AdminName } from './first-owner.js';
import { normalizeEmail, normalizePhone } from './sign-in-name.js';

export const OWNER_COMMAND_USAGE =
  'Usage: create-owner-command.js [--email <email>] [--phone <+E.164 phone>], at least one';

// The first OWN's name from the command line: an email, a phone or both.
// Returns the error to print when the arguments are wrong.
export function parseOwnerArguments(args: string[]): AdminName | string {
  let values;
  try {
    ({ values } = parseArgs({
      args,
      options: { email: { type: 'string' }, phone: { type: 'string' } },
    }));
  } catch {
    return OWNER_COMMAND_USAGE;
  }
  if (values.email === undefined && values.phone === undefined) return OWNER_COMMAND_USAGE;
  const email = values.email === undefined ? null : normalizeEmail(values.email);
  if (values.email !== undefined && !email) return 'Not an email address.';
  const phone = values.phone === undefined ? null : normalizePhone(values.phone);
  if (values.phone !== undefined && !phone) {
    return 'Not an international phone number, such as +963944000000.';
  }
  return { email, phone };
}
