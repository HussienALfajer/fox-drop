import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { api } from './api.js';
import type { components } from '@fox-drop/api-schema';

export const CONTENT_READ = 'content.read';
export const CONTENT_MANAGE = 'content.manage';
export const CONTENT_FAQS = 'content.faqs';

type ReasonLists = components['schemas']['AdminReasonListsDto_Output']['lists'];
export type ReasonListEntry = ReasonLists[number];
export type ReasonEntry = ReasonListEntry['reasons'][number];
export type ReasonListName = ReasonListEntry['list'];
export type FaqAudience = 'customer' | 'captain' | 'merchant';
export type FaqItem = { question: string; answer: string };
export type NotificationText =
  components['schemas']['AdminNotificationTextsDto_Output']['templates'][number];
export type NotificationAudience = NotificationText['audience'];

// The refusals the page explains; anything else is a thrown error.
export type ContentRefusal =
  | 'list_closed'
  | 'reason_fixed'
  | 'customer_text_not_allowed'
  | 'duplicate_label'
  | 'invalid_order'
  | 'invalid_value'
  | 'unknown_variable'
  | 'terms_unchanged';

const refusals: readonly string[] = [
  'list_closed',
  'reason_fixed',
  'customer_text_not_allowed',
  'duplicate_label',
  'invalid_order',
  'invalid_value',
  'unknown_variable',
  'terms_unchanged',
] satisfies ContentRefusal[];

export type EditResult = { status: 'saved' } | { status: 'refused'; refusal: ContentRefusal };

function refused(error: unknown, status: number): EditResult {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (status === 400 && typeof refusal === 'string' && refusals.includes(refusal)) {
    return { status: 'refused', refusal: refusal as ContentRefusal };
  }
  throw new Error(`content edit failed with ${status}`);
}

const keys = {
  reasons: ['content', 'reasons'] as const,
  faqs: ['content', 'faqs'] as const,
  texts: ['content', 'texts'] as const,
  notifications: ['content', 'notifications'] as const,
  terms: ['content', 'terms'] as const,
};

export function useReasonLists() {
  return useQuery({
    queryKey: keys.reasons,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/content/reasons');
      if (!data) throw new Error('reason lists unavailable');
      return data.lists;
    },
  });
}

export function useFaqs(enabled: boolean) {
  return useQuery({
    queryKey: keys.faqs,
    enabled,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/content/faqs');
      if (!data) throw new Error('FAQs unavailable');
      return data;
    },
  });
}

export function useTexts(enabled: boolean) {
  return useQuery({
    queryKey: keys.texts,
    enabled,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/content/texts');
      if (!data) throw new Error('texts unavailable');
      return data;
    },
  });
}

// One mutation per kind of edit; each refreshes what it changed.
function useEdit<Input>(key: readonly string[], run: (input: Input) => Promise<EditResult>) {
  const client = useQueryClient();
  return useMutation({
    mutationFn: run,
    onSuccess: (result) => {
      if (result.status === 'saved') void client.invalidateQueries({ queryKey: key });
    },
  });
}

export type NoteMode = ReasonEntry['note'];

export interface ReasonForm {
  label: string;
  customerText: string;
  note: NoteMode;
}

// The form's select gives one of the three modes; anything else is none.
export function noteMode(value: unknown): NoteMode {
  return value === 'optional' || value === 'required' ? value : 'none';
}

// An empty customer text is none: the customer sees the generic apology.
function fields(form: ReasonForm) {
  return {
    label: form.label.trim(),
    customerText: form.customerText.trim() === '' ? null : form.customerText.trim(),
    note: form.note,
  };
}

export function useAddReason() {
  return useEdit(keys.reasons, async (input: { list: ReasonListName } & ReasonForm) => {
    const { data, error, response } = await api.POST('/v1/admin/content/reasons/{list}', {
      params: { path: { list: input.list } },
      body: fields(input),
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

export function useUpdateReason() {
  return useEdit(
    keys.reasons,
    async (input: { list: ReasonListName; code: string; active: boolean } & ReasonForm) => {
      const { data, error, response } = await api.PUT('/v1/admin/content/reasons/{list}/{code}', {
        params: { path: { list: input.list, code: input.code } },
        body: { ...fields(input), active: input.active },
      });
      return data ? { status: 'saved' } : refused(error, response.status);
    },
  );
}

// Moves a reason one place up (-1) or down (+1) in its list.
export function moved(codes: string[], code: string, by: -1 | 1): string[] {
  const from = codes.indexOf(code);
  const to = from + by;
  if (from < 0 || to < 0 || to >= codes.length) return codes;
  const next = [...codes];
  [next[from], next[to]] = [next[to]!, next[from]!];
  return next;
}

export function useReorder() {
  return useEdit(keys.reasons, async (input: { list: ReasonListName; codes: string[] }) => {
    const { data, error, response } = await api.POST('/v1/admin/content/reasons/{list}/order', {
      params: { path: { list: input.list } },
      body: { codes: input.codes },
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

// The FAQ pairs as the form holds them, trimmed; a pair left empty is dropped.
export function faqItems(items: { question: string; answer: string }[]): FaqItem[] {
  return items
    .map((item) => ({ question: item.question.trim(), answer: item.answer.trim() }))
    .filter((item) => item.question !== '' && item.answer !== '');
}

export function useUpdateFaq() {
  return useEdit(keys.faqs, async (input: { audience: FaqAudience; items: FaqItem[] }) => {
    const { data, error, response } = await api.PUT('/v1/admin/content/faqs/{audience}', {
      params: { path: { audience: input.audience } },
      body: { items: faqItems(input.items) },
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

export function useUpdateWorkRules() {
  return useEdit(keys.texts, async (workRules: string) => {
    const { data, error, response } = await api.PUT('/v1/admin/content/work-rules', {
      body: { workRules },
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

// A number typed as written; an empty one hides its button in the apps.
export function contactBody(phone: string, whatsapp: string) {
  const number = (typed: string) => {
    const value = typed.replace(/[\s-]/g, '').replace(/^00/, '+');
    return value === '' ? null : value;
  };
  return { phone: number(phone), whatsapp: number(whatsapp) };
}

export function useUpdateContact() {
  return useEdit(keys.texts, async (input: { phone: string; whatsapp: string }) => {
    const { data, error, response } = await api.PUT('/v1/admin/content/contact', {
      body: contactBody(input.phone, input.whatsapp),
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

// «نصوص الإشعارات» (AP §9.13): every push's text, grouped by app in the
// server's order.
export function useNotificationTexts() {
  return useQuery({
    queryKey: keys.notifications,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/content/notifications');
      if (!data) throw new Error('notification texts unavailable');
      return data.templates;
    },
  });
}

export function byAudience(templates: NotificationText[]) {
  const groups = new Map<NotificationAudience, NotificationText[]>();
  for (const template of templates) {
    groups.set(template.audience, [...(groups.get(template.audience) ?? []), template]);
  }
  return [...groups.entries()].map(([audience, entries]) => ({ audience, templates: entries }));
}

export function useUpdateNotificationText() {
  return useEdit(keys.notifications, async (input: { key: string; text: string }) => {
    const { data, error, response } = await api.PUT('/v1/admin/content/notifications/{key}', {
      params: { path: { key: input.key } },
      body: { text: input.text.trim() },
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}

// «الشروط والخصوصية» (AP §9.13): the version in force of each audience's
// document; publishing the next makes everyone of that audience accept it
// again on their next app open.
export type TermsAudience = FaqAudience;
export const termsAudiences = [
  'customer',
  'captain',
  'merchant',
] as const satisfies readonly TermsAudience[];

export function useTerms() {
  return useQuery({
    queryKey: keys.terms,
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/content/terms');
      if (!data) throw new Error('terms unavailable');
      return data;
    },
  });
}

export function usePublishTerms() {
  return useEdit(keys.terms, async (input: { audience: TermsAudience; body: string }) => {
    const { data, error, response } = await api.POST('/v1/admin/content/terms/{audience}', {
      params: { path: { audience: input.audience } },
      body: { body: input.body.trim() },
    });
    return data ? { status: 'saved' } : refused(error, response.status);
  });
}
