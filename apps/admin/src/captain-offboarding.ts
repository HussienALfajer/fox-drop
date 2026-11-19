import { useMutation } from '@tanstack/react-query';
import { api } from './api.js';
import {
  type Application,
  commandResult,
  type CommandResult,
  useAnswered,
} from './captain-applications.js';

// AP §9.7.5, §9.7.2, C17 (slice 2.35b): «إنهاء التعاقد» and its checklist on
// the application's page; the deposit's step is the desk's
// (cash-desk-deposits.ts).

export type Offboarding = NonNullable<Application['offboarding']>;
export type OffboardingStep = Offboarding['missing'][number];

// The checklist's steps «إغلاق الحساب» waits for, in words.
export const stepKeys = {
  kit: 'captainOffboarding.step.kit',
  custody: 'captainOffboarding.step.custody',
  earnings: 'captainOffboarding.step.earnings',
  deposit: 'captainOffboarding.step.deposit',
} as const satisfies Record<OffboardingStep, string>;

export const settlementKeys = {
  refunded: 'captainOffboarding.settled.refunded',
  withheld: 'captainOffboarding.settled.withheld',
} as const satisfies Record<NonNullable<Offboarding['depositSettled']>, string>;

export type OffboardingCommand =
  | { action: 'terminate'; reason: string }
  | { action: 'return_kit'; returned: boolean }
  | { action: 'close' };

// Each is refused once taken or sets a value, so none takes a key; each
// answers the review page.
export function useOffboardingCommand(applicationId: string) {
  const answered = useAnswered(applicationId);
  const path = { applicationId };
  return useMutation({
    mutationFn: async (command: OffboardingCommand): Promise<CommandResult> => {
      switch (command.action) {
        case 'terminate':
          return commandResult(
            await api.POST('/v1/admin/captain-applications/{applicationId}/terminate', {
              params: { path },
              body: { reason: command.reason },
            }),
          );
        case 'return_kit':
          return commandResult(
            await api.PUT('/v1/admin/captain-applications/{applicationId}/offboarding/kit', {
              params: { path },
              body: { returned: command.returned },
            }),
          );
        case 'close':
          return commandResult(
            await api.POST('/v1/admin/captain-applications/{applicationId}/offboarding/close', {
              params: { path },
            }),
          );
      }
    },
    ...answered,
  });
}
