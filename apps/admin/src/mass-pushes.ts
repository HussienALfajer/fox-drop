import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { zonedToUtc } from './emergency-stop.js';
import { type AdminSession, can } from './session.js';

// AP §6, §9.11.4 «الإشعارات الجماعية» (owner decision 2026-11-18): OWN
// sends (marketing.manage), OPS reads the history (marketing.read).
export function canSeeMassPushes(session: AdminSession | null | undefined): boolean {
  return can(session, 'marketing.read') || can(session, 'marketing.manage');
}

export type MassPushes = components['schemas']['AdminMassPushesDto_Output'];
export type MassPush = MassPushes['pushes'][number];
export type Audience = MassPush['audience'];
export type Target = MassPush['target'];

// The bounds the server checks (MASS_PUSH_TITLE_MAX, MASS_PUSH_BODY_MAX,
// MASS_PUSH_INACTIVE_DAYS_MAX, MASS_PUSH_SCHEDULE_DAYS).
export const TITLE_MAX = 50;
export const BODY_MAX = 200;
export const DAYS_MAX = 365;
export const SCHEDULE_DAYS = 30;

// The form as typed: the time as the city's wall time.
export interface MassPushForm {
  title: string;
  body: string;
  audience: Audience;
  zoneId: string;
  inactiveDays: string;
  target: Target;
  restaurantId: string;
  codeId: string;
  scheduled: boolean;
  sendAt: string;
}

export function emptyForm(): MassPushForm {
  return {
    title: '',
    body: '',
    audience: 'all',
    zoneId: '',
    inactiveDays: '30',
    target: 'home',
    restaurantId: '',
    codeId: '',
    scheduled: false,
    sendAt: '',
  };
}

export interface AudienceFields {
  audience: Audience;
  zoneId: string | null;
  inactiveDays: number | null;
}

export interface MassPushFields extends AudienceFields {
  title: string;
  body: string;
  target: Target;
  restaurantId: string | null;
  codeId: string | null;
  sendAt: string | null;
}

export type MassPushProblem = 'title' | 'body' | 'zone' | 'days' | 'target' | 'time';

// The audience's fields, or its problem: a zone for `zone`, 1 to 365 whole
// days for `inactive`.
export function audienceOf(
  form: MassPushForm,
): { fields: AudienceFields } | { problem: MassPushProblem } {
  if (form.audience === 'zone') {
    if (form.zoneId === '') return { problem: 'zone' };
    return { fields: { audience: 'zone', zoneId: form.zoneId, inactiveDays: null } };
  }
  if (form.audience === 'inactive') {
    const days = /^\d+$/.test(form.inactiveDays.trim()) ? Number(form.inactiveDays) : NaN;
    if (!Number.isInteger(days) || days < 1 || days > DAYS_MAX) return { problem: 'days' };
    return { fields: { audience: 'inactive', zoneId: null, inactiveDays: days } };
  }
  return { fields: { audience: form.audience, zoneId: null, inactiveDays: null } };
}

// The body's fields, or the form's first problem (the server checks the
// same): a title of 1 to 50 characters and a text of 1 to 200, trimmed; the
// audience; the target's choice; a scheduled time ahead within 30 days.
export function massPushFieldsOf(
  form: MassPushForm,
  timeZone: string,
  now: number,
): { fields: MassPushFields } | { problem: MassPushProblem } {
  const title = form.title.trim();
  if (title.length === 0 || [...title].length > TITLE_MAX) return { problem: 'title' };
  const body = form.body.trim();
  if (body.length === 0 || [...body].length > BODY_MAX) return { problem: 'body' };
  const audience = audienceOf(form);
  if ('problem' in audience) return audience;
  let target: Pick<MassPushFields, 'restaurantId' | 'codeId'> = {
    restaurantId: null,
    codeId: null,
  };
  if (form.target === 'restaurant') {
    if (form.restaurantId === '') return { problem: 'target' };
    target = { restaurantId: form.restaurantId, codeId: null };
  } else if (form.target === 'code') {
    if (form.codeId === '') return { problem: 'target' };
    target = { restaurantId: null, codeId: form.codeId };
  }
  let sendAt: string | null = null;
  if (form.scheduled) {
    sendAt = zonedToUtc(form.sendAt, timeZone);
    if (
      sendAt === null ||
      Date.parse(sendAt) <= now ||
      Date.parse(sendAt) > now + SCHEDULE_DAYS * 86_400_000
    ) {
      return { problem: 'time' };
    }
  }
  return {
    fields: { title, body, ...audience.fields, target: form.target, ...target, sendAt },
  };
}

// The refusals the page explains; anything else is a thrown error.
export type MassPushRefusal =
  | 'invalid_mass_push'
  | 'audience_changed'
  | 'audience_empty'
  | 'not_cancellable'
  | 'unknown_mass_push';
const refusals: readonly string[] = [
  'invalid_mass_push',
  'audience_changed',
  'audience_empty',
  'not_cancellable',
  'unknown_mass_push',
] satisfies MassPushRefusal[];

export type MassPushResult = { status: 'saved' } | { status: 'refused'; refusal: MassPushRefusal };

function refused(error: unknown, status: number): MassPushResult {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (
    typeof refusal === 'string' &&
    [400, 404, 409].includes(status) &&
    refusals.includes(refusal)
  ) {
    return { status: 'refused', refusal: refusal as MassPushRefusal };
  }
  throw new Error(`mass push failed with ${status}`);
}

const pushesKey = (cityId: string) => ['mass-pushes', cityId] as const;

export const massPushesQuery = (cityId: string) =>
  queryOptions({
    queryKey: pushesKey(cityId),
    queryFn: async (): Promise<MassPushes> => {
      const { data } = await api.GET('/v1/admin/mass-pushes', { params: { query: { cityId } } });
      if (!data) throw new Error('The mass pushes read failed.');
      return data;
    },
  });

// The audience's size now, which the confirmation shows and sends back.
export function useAudienceSize(cityId: string) {
  return useMutation({
    mutationFn: async (audience: AudienceFields): Promise<number> => {
      const { data } = await api.GET('/v1/admin/mass-pushes/audience', {
        params: {
          query: {
            cityId,
            audience: audience.audience,
            ...(audience.zoneId === null ? {} : { zoneId: audience.zoneId }),
            ...(audience.inactiveDays === null ? {} : { inactiveDays: audience.inactiveDays }),
          },
        },
      });
      if (!data) throw new Error('The audience count failed.');
      return data.size;
    },
  });
}

// One Idempotency-Key per body and size until an answer arrives
// (architecture §5.3), so a retry after a lost answer never sends twice.
export function useSendMassPush(cityId: string) {
  const client = useQueryClient();
  const kept = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (input: {
      fields: MassPushFields;
      audienceSize: number;
    }): Promise<MassPushResult> => {
      const id = JSON.stringify(input);
      let key = kept.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        kept.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/admin/mass-pushes', {
        body: { cityId, ...input.fields, audienceSize: input.audienceSize },
        params: { header: { 'Idempotency-Key': key } },
      });
      if (data || response.status < 500) kept.current.delete(id);
      if (!data) return refused(error, response.status);
      client.setQueryData(pushesKey(cityId), data);
      return { status: 'saved' };
    },
  });
}

export function useCancelMassPush(cityId: string) {
  const client = useQueryClient();
  return useMutation({
    mutationFn: async (massPushId: string): Promise<MassPushResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/mass-pushes/{massPushId}/cancel',
        {
          params: { path: { massPushId } },
          body: { cityId },
        },
      );
      if (!data) return refused(error, response.status);
      client.setQueryData(pushesKey(cityId), data);
      return { status: 'saved' };
    },
  });
}
