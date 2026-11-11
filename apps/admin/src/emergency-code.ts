import { useMutation } from '@tanstack/react-query';
import { api } from './api.js';

export const EMERGENCY_CODE_PERMISSION = 'sign_in.emergency_code';

export type EmergencyParty = 'captain' | 'merchant';

// The 409 refusals of a number that cannot sign in, and a malformed number.
export type EmergencyRefusal =
  | 'not_registered'
  | 'contract_ended'
  | 'restaurant_draft'
  | 'restaurant_terminated'
  // A captain with an active order still signed in on another device:
  // «تحرير الجهاز» first (CA §4.9, slice 2.12c).
  | 'active_order_elsewhere'
  | 'phone_invalid'
  | 'reason_missing';

const refusals: readonly string[] = [
  'not_registered',
  'contract_ended',
  'restaurant_draft',
  'restaurant_terminated',
  'active_order_elsewhere',
] satisfies EmergencyRefusal[];

export type EmergencyResult =
  | { status: 'issued'; code: string; expiresAt: string }
  | { status: 'refused'; refusal: EmergencyRefusal };

// Arabic-Indic digits become Western ones, spaces and dashes are dropped and
// a leading 00 becomes +; the server checks the rest (+9639xxxxxxxx or
// +905xxxxxxxxx).
export function normalisePhone(typed: string): string {
  return typed
    .replace(/[٠-٩]/g, (digit) => String(digit.charCodeAt(0) - 0x0660))
    .replace(/[۰-۹]/g, (digit) => String(digit.charCodeAt(0) - 0x06f0))
    .replace(/[\s-]/g, '')
    .replace(/^00/, '+');
}

// Architecture §8.3.5, W4: OWN or OPS issue a one-time code after verifying
// the person by phone. The code is shown once and kept nowhere in the panel:
// the mutation's result leaves the cache as soon as the page closes.
export function useIssueEmergencyCode() {
  return useMutation({
    gcTime: 0,
    mutationFn: async (input: {
      party: EmergencyParty;
      phone: string;
      reason: string;
    }): Promise<EmergencyResult> => {
      const reason = input.reason.trim();
      if (reason === '') return { status: 'refused', refusal: 'reason_missing' };
      const { data, error, response } = await api.POST('/v1/admin/emergency-sign-in-codes', {
        body: { ...input, phone: normalisePhone(input.phone), reason },
      });
      if (data) return { status: 'issued', code: data.code, expiresAt: data.expiresAt };
      // The party is a radio button and the reason is checked above, so a
      // malformed request can only be the number.
      if (response.status === 400) return { status: 'refused', refusal: 'phone_invalid' };
      const refusal = (error as { error?: unknown } | undefined)?.error;
      if (response.status === 409 && typeof refusal === 'string' && refusals.includes(refusal)) {
        return { status: 'refused', refusal: refusal as EmergencyRefusal };
      }
      throw new Error('Issuing the emergency code failed.');
    },
  });
}
