import type { components } from '@fox-drop/api-schema';
import { useMutation } from '@tanstack/react-query';
import { api } from './api.js';
import {
  type Application,
  CAPTAINS_CASH_LIMIT,
  commandResult,
  type CommandResult,
  useAnswered,
} from './captain-applications.js';
import { minorOf } from './format.js';
import { fileRefusal, uploadImage } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

// AP §9.7.1–9.7.2, D24 (slice 2.35a): «بانتظار العدة», «تفعيل» and the
// contract on the application's page; the deposit is the desk's
// (cash-desk-deposits.ts).

export type Activation = Application['activation'];
export type Contract = NonNullable<Activation['contract']>;

// What «تفعيل» still waits for, in words: a document's name, or one of the
// records.
export const missingKeys = {
  kit: 'captainActivation.missing.kit',
  deposit: 'captainActivation.missing.deposit',
  contract: 'captainActivation.missing.contract',
  cash_limit: 'captainActivation.missing.cash_limit',
} as const;

export function missingDocumentOf(missing: string): string | null {
  return missing.startsWith('document:') ? missing.slice('document:'.length) : null;
}

export const phaseKeys = {
  probation: 'captainActivation.phase.probation',
  commitment: 'captainActivation.phase.commitment',
  open: 'captainActivation.phase.open',
} as const satisfies Record<Contract['phase'], string>;

export const reviewKeys = {
  none: null,
  due: 'captainActivation.review.due',
  overdue: 'captainActivation.review.overdue',
} as const satisfies Record<Contract['review'], string | null>;

// FIN and OWN set the cash limit (AP §9.7.1, D10).
export function canSetCashLimit(session: AdminSession | null | undefined): boolean {
  return can(session, CAPTAINS_CASH_LIMIT);
}

// «تسليم العدة»: each item of the list `kit_item` ticked, with its size and
// how many (1 to 20).
export interface KitLine {
  code: string;
  picked: boolean;
  size: string;
  quantity: string;
}

export type KitBody = components['schemas']['AdminCaptainApplicationKitDto'];

export function kitLinesOf(
  reasons: { code: string; active: boolean }[],
  kit: Activation['kit'],
): KitLine[] {
  return reasons
    .filter((reason) => reason.active)
    .map((reason) => {
      const issued = kit?.items.find((item) => item.code === reason.code);
      return {
        code: reason.code,
        picked: issued !== undefined,
        size: issued?.size ?? '',
        quantity: String(issued?.quantity ?? 1),
      };
    });
}

// The body, or null when nothing is ticked or a count or size is out of
// bounds (the server checks again).
export function kitBody(lines: KitLine[]): KitBody | null {
  const picked = lines.filter((line) => line.picked);
  if (picked.length === 0) return null;
  const items: KitBody['items'] = [];
  for (const line of picked) {
    const quantity = Number(line.quantity);
    const size = line.size.trim();
    if (!Number.isInteger(quantity) || quantity < 1 || quantity > 20 || size.length > 20) {
      return null;
    }
    items.push({ code: line.code, size: size === '' ? null : size, quantity });
  }
  return { items };
}

// The cash limit typed in the base currency's major units, as minor units;
// null when it is not an amount above zero.
export function cashLimitOf(typed: string, currency: string): string | null {
  const minor = minorOf(typed, currency);
  return minor === null || /^0+$/.test(minor) ? null : minor;
}

// «تسجيل العقد»: the signing and start days and the scan's pages (1 to 6).
export interface ContractForm {
  signedOn: string;
  startsOn: string;
  files: File[];
}

export type ContractProblem = 'dates' | 'files';

export function contractProblem(form: ContractForm, today: string): ContractProblem | null {
  const day = /^\d{4}-\d{2}-\d{2}$/;
  if (
    !day.test(form.signedOn) ||
    !day.test(form.startsOn) ||
    form.signedOn > today ||
    form.startsOn < form.signedOn
  ) {
    return 'dates';
  }
  if (form.files.length < 1 || form.files.length > 6) return 'files';
  return null;
}

export type ActivationCommand =
  | { action: 'issue_kit'; body: KitBody }
  | { action: 'set_cash_limit'; amount: string; currency: string }
  | { action: 'activate' }
  | { action: 'confirm_probation' };

// Each sets a value or is refused once taken, so none takes a key; each
// answers the review page.
export function useActivationCommand(applicationId: string) {
  const answered = useAnswered(applicationId);
  const path = { applicationId };
  return useMutation({
    mutationFn: async (command: ActivationCommand): Promise<CommandResult> => {
      switch (command.action) {
        case 'issue_kit':
          return commandResult(
            await api.PUT('/v1/admin/captain-applications/{applicationId}/kit', {
              params: { path },
              body: command.body,
            }),
          );
        case 'set_cash_limit':
          return commandResult(
            await api.PUT('/v1/admin/captain-applications/{applicationId}/cash-limit', {
              params: { path },
              body: { cashLimit: { amount: command.amount, currency: command.currency } },
            }),
          );
        case 'activate':
          return commandResult(
            await api.POST('/v1/admin/captain-applications/{applicationId}/activate', {
              params: { path },
            }),
          );
        case 'confirm_probation':
          return commandResult(
            await api.POST('/v1/admin/captain-applications/{applicationId}/confirm-probation', {
              params: { path },
            }),
          );
      }
    },
    ...answered,
  });
}

// «تسجيل العقد»: the pages are uploaded with signed PUTs (captain_document),
// then the contract links them with its dates.
export function useRecordContract(applicationId: string) {
  const answered = useAnswered(applicationId);
  return useMutation({
    mutationFn: async (form: ContractForm): Promise<CommandResult> => {
      for (const file of form.files) {
        const refusal = fileRefusal(file);
        if (refusal !== null) return { status: 'refused', refusal };
      }
      const uploadIds: string[] = [];
      for (const file of form.files) {
        const uploadId = await uploadImage('captain_document', file);
        if (uploadId === null) return { status: 'refused', refusal: 'upload_failed' };
        uploadIds.push(uploadId);
      }
      return commandResult(
        await api.PUT('/v1/admin/captain-applications/{applicationId}/contract', {
          params: { path: { applicationId } },
          body: { signedOn: form.signedOn, startsOn: form.startsOn, uploadIds },
        }),
      );
    },
    ...answered,
  });
}
