import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';

export type Content = components['schemas']['MerchantContentDto_Output'];
export type Ticket = components['schemas']['MerchantReportsDto_Output']['tickets'][number];
export type ReportBody = components['schemas']['MerchantReportBodyDto'];
export type DataChangeSubject = NonNullable<ReportBody['subject']>;

// RA Appendix C: «طلب تعديل بيانات», the type that names its subject (its
// code in Content's merchant_ticket_type list; the server checks the same).
export const DATA_CHANGE_TYPE = 'data_change';

// RA §15 (owner decision 2026-11-17): what a data change may ask.
export const DATA_CHANGE_SUBJECTS = [
  'min_order',
  'coverage',
  'owners',
  'owner_phone',
] as const satisfies readonly DataChangeSubject[];

// The server's note limit (NOTE_MAX).
export const NOTE_MAX = 300;

// RA §15 (slice 2.45c): the report types and the FAQ from Content (AP §9.13).
export const contentQuery = queryOptions({
  queryKey: ['merchant-content'],
  queryFn: async (): Promise<Content> => {
    const { data, response } = await api.GET('/v1/merchant/content');
    if (!data) throw new Error(`The content read failed (${response.status}).`);
    return data;
  },
});

// «بلاغاتي»: an owner sees every ticket of the restaurant.
export const reportsQuery = queryOptions({
  queryKey: ['merchant-reports'],
  queryFn: async (): Promise<Ticket[]> => {
    const { data, response } = await api.GET('/v1/merchant/reports');
    if (!data) throw new Error(`The reports read failed (${response.status}).`);
    return data.tickets;
  },
});

export interface ReportForm {
  typeCode: string;
  subject: DataChangeSubject | '';
  orderId: string;
  note: string;
}

// The report as POST /v1/merchant/reports takes it (without the photo), or
// why not: a type chosen from the list, a data change with its subject, the
// note a type asks for, at most 300 characters.
export function reportOf(
  form: ReportForm,
  types: Content['reasons']['merchant_ticket_type'],
): { body: Omit<ReportBody, 'photoUploadId'> } | { invalid: 'type' | 'subject' | 'note' } {
  const type = types.find((each) => each.code === form.typeCode);
  if (!type) return { invalid: 'type' };
  const dataChange = type.code === DATA_CHANGE_TYPE;
  if (dataChange && form.subject === '') return { invalid: 'subject' };
  const note = form.note.trim();
  if ([...note].length > NOTE_MAX) return { invalid: 'note' };
  // The note is the ticket's description, always allowed; a type whose text
  // Content requires (AP §9.13, «أخرى») needs it.
  if (type.note === 'required' && note === '') return { invalid: 'note' };
  return {
    body: {
      typeCode: type.code,
      orderId: form.orderId === '' ? null : form.orderId,
      note: note === '' ? null : note,
      subject: dataChange ? (form.subject as DataChangeSubject) : null,
    },
  };
}

export type ReportAnswer =
  | { status: 'sent'; ticket: Ticket }
  | { status: 'refused'; refusal: 'typeChanged' | 'orderGone' | 'photo' | 'other' };

// One Idempotency-Key per report until it is answered, so a retry after a
// lost answer opens one ticket.
export function useSendReport() {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: ReportBody): Promise<ReportAnswer> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST('/v1/merchant/reports', {
        params: { header: { 'Idempotency-Key': key } },
        body,
      });
      if (data) {
        keys.current.delete(id);
        void queryClient.invalidateQueries({ queryKey: reportsQuery.queryKey });
        return { status: 'sent', ticket: data.ticket };
      }
      if (response.status >= 400 && response.status < 500) {
        keys.current.delete(id);
        const refusal = (error as { error?: unknown } | undefined)?.error;
        if (typeof refusal === 'string' && refusal.startsWith('reason_note')) {
          return { status: 'refused', refusal: 'typeChanged' };
        }
        if (refusal === 'unknown_reason' || refusal === 'subject_required') {
          void queryClient.invalidateQueries({ queryKey: contentQuery.queryKey });
          return { status: 'refused', refusal: 'typeChanged' };
        }
        if (refusal === 'unknown_order') return { status: 'refused', refusal: 'orderGone' };
        if (typeof refusal === 'string' && refusal.startsWith('upload_')) {
          return { status: 'refused', refusal: 'photo' };
        }
        return { status: 'refused', refusal: 'other' };
      }
      throw new Error(`The report failed (${response.status}).`);
    },
  });
}

// «سنرد عليك خلال …»: whole hours, else minutes (the app's formatReplyWithin).
export function replyWithin(minutes: number): { hours: number } | { minutes: number } {
  return minutes >= 60 && minutes % 60 === 0 ? { hours: minutes / 60 } : { minutes };
}

// WhatsApp to the team about an order, its text prefilled.
export function whatsappAbout(link: string, text: string): string {
  return `${link}?text=${encodeURIComponent(text)}`;
}
