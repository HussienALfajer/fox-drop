import { z } from 'zod';

// AP §5.1 item 1: an admin signs in with their email or their phone (owner
// decision 2026-11-05: an account has either or both).
export type SignInName = { email: string } | { phone: string };

const email = z.email();

export function normalizeEmail(input: string): string | null {
  const normal = input.trim().toLowerCase();
  return email.safeParse(normal).success ? normal : null;
}

// International numbers only, with + or 00, so no country is guessed. Spaces,
// dashes and brackets between the digits are dropped. Returns E.164.
export function normalizePhone(input: string): string | null {
  const compact = input.trim().replace(/[\s\-()]/g, '');
  const normal = compact.startsWith('00') ? `+${compact.slice(2)}` : compact;
  return /^\+[1-9]\d{7,14}$/.test(normal) ? normal : null;
}

export function parseSignInName(input: string): SignInName | null {
  if (input.includes('@')) {
    const normal = normalizeEmail(input);
    return normal ? { email: normal } : null;
  }
  const normal = normalizePhone(input);
  return normal ? { phone: normal } : null;
}
