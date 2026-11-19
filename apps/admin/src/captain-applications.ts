import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import type { AdminAlert } from './alerts.js';
import { api } from './api.js';
import { CAPTAINS_MANAGE } from './captain-device.js';
import { zonedToUtc } from './emergency-stop.js';
import { utcToZoned } from './promo-codes.js';
import { degreesOf } from './restaurant-drafts.js';
import { fileRefusal, uploadImage } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

// AP §9.7.1 «طلبات الانضمام» (slice 2.34b): captains.read reads the board
// and the review page; every action takes captains.manage (OWN, OPS).
export const CAPTAINS_READ = 'captains.read';

export function canSeeApplications(session: AdminSession | null | undefined): boolean {
  return can(session, CAPTAINS_READ);
}

export type Board = components['schemas']['AdminCaptainApplicationsDto_Output'];
export type BoardEntry = Board['applications'][number];
export type Application = components['schemas']['AdminCaptainApplicationDto_Output'];
export type ApplicationDocument = Application['documents'][number];
export type ApplicationEvent = Application['events'][number];
export type Stage = Application['stage'];
export type BoardStage = Exclude<Stage, 'draft'>;
export type DocumentKind = ApplicationDocument['kind'];
export type DocumentStatus = ApplicationDocument['status'];

// The board's stages in the pipeline's order, then the two side stages.
export const BOARD_STAGES = [
  'new',
  'under_review',
  'interview',
  'awaiting_kit',
  'active',
  'waitlist',
  'rejected',
] as const satisfies readonly BoardStage[];

export const stageKeys = {
  draft: 'captainApplications.stage.draft',
  new: 'captainApplications.stage.new',
  under_review: 'captainApplications.stage.under_review',
  interview: 'captainApplications.stage.interview',
  awaiting_kit: 'captainApplications.stage.awaiting_kit',
  active: 'captainApplications.stage.active',
  waitlist: 'captainApplications.stage.waitlist',
  rejected: 'captainApplications.stage.rejected',
} as const satisfies Record<Stage, string>;

// D24's documents the applicant uploads, in the table's order (the signed
// contract comes with «تسجيل العقد», slice 2.35a).
export const DOCUMENT_KINDS = [
  'national_id',
  'personal_photo',
  'civil_registry',
  'criminal_record',
  'vehicle_papers',
  'driving_licence',
] as const satisfies readonly DocumentKind[];

export const documentKindKeys = {
  national_id: 'captainApplications.document.national_id',
  personal_photo: 'captainApplications.document.personal_photo',
  civil_registry: 'captainApplications.document.civil_registry',
  criminal_record: 'captainApplications.document.criminal_record',
  vehicle_papers: 'captainApplications.document.vehicle_papers',
  driving_licence: 'captainApplications.document.driving_licence',
  signed_contract: 'captainApplications.document.signed_contract',
} as const satisfies Record<DocumentKind, string>;

export const documentStatusKeys = {
  pending: 'captainApplications.documentStatus.pending',
  accepted: 'captainApplications.documentStatus.accepted',
  rejected: 'captainApplications.documentStatus.rejected',
} as const satisfies Record<DocumentStatus, string>;

export const eventKindKeys = {
  submitted: 'captainApplications.event.submitted',
  stage: 'captainApplications.event.stage',
  note: 'captainApplications.event.note',
  document_review: 'captainApplications.event.document_review',
  document_request: 'captainApplications.event.document_request',
  document_upload: 'captainApplications.event.document_upload',
  interview: 'captainApplications.event.interview',
  kit: 'captainApplications.event.kit',
  cash_limit: 'captainApplications.event.cash_limit',
  contract: 'captainApplications.event.contract',
  deposit: 'captainApplications.event.deposit',
  probation_confirmed: 'captainApplications.event.probation_confirmed',
} as const satisfies Record<ApplicationEvent['kind'], string>;

export const duplicateFieldKeys = {
  id_number: 'captainApplications.duplicate.id_number',
  phone: 'captainApplications.duplicate.phone',
  plate: 'captainApplications.duplicate.plate',
} as const satisfies Record<Application['duplicates'][number]['field'], string>;

// The board's search: the city and the stage shown («جديد» by default).
export function boardSearch(search: Record<string, unknown>): {
  city?: string;
  stage?: BoardStage;
} {
  return {
    ...(typeof search.city === 'string' ? { city: search.city } : {}),
    ...((BOARD_STAGES as readonly unknown[]).includes(search.stage)
      ? { stage: search.stage as BoardStage }
      : {}),
  };
}

// The server leaves out a stage without applications.
export function countOf(counts: Board['counts'], stage: BoardStage): number {
  return counts[stage] ?? 0;
}

// The panel's actions, as the server's `pipelineSteps` allows them
// (apps/server/src/modules/captains/applications.ts).
export type PipelineAction =
  | 'review_document'
  | 'upload_document'
  | 'request_document'
  | 'note'
  | 'schedule_interview'
  | 'training_passed'
  | 'reject'
  | 'waitlist'
  | 'back_from_waitlist';

const OPEN: readonly Stage[] = ['new', 'under_review', 'interview', 'awaiting_kit', 'waitlist'];
const FROM: Record<PipelineAction, readonly Stage[]> = {
  review_document: OPEN,
  upload_document: OPEN,
  request_document: OPEN,
  note: OPEN,
  schedule_interview: ['new', 'under_review', 'interview'],
  training_passed: ['interview'],
  reject: OPEN,
  waitlist: ['new', 'under_review', 'interview', 'awaiting_kit'],
  back_from_waitlist: ['waitlist'],
};

// The actions the page shows: those the stage takes, and none without
// captains.manage (the server checks both).
export function actionsOf(
  session: AdminSession | null | undefined,
  stage: Stage,
): ReadonlySet<PipelineAction> {
  if (!can(session, CAPTAINS_MANAGE)) return new Set();
  return new Set(
    (Object.keys(FROM) as PipelineAction[]).filter((action) => FROM[action].includes(stage)),
  );
}

// The kinds the office scans or asks for: the required ones and the optional
// driving licence (the vehicle papers only for a motor vehicle, which the
// server's requiredDocuments already says).
export function documentKindsOf(application: Pick<Application, 'requiredDocuments'>) {
  return DOCUMENT_KINDS.filter(
    (kind) => kind === 'driving_licence' || application.requiredDocuments.includes(kind),
  );
}

// Every upload of a kind, newest first as the server answers them.
export function documentsOf(application: Pick<Application, 'documents'>, kind: DocumentKind) {
  return application.documents.filter((document) => document.kind === kind);
}

// The alert «طلب انضمام كابتن»: its application, for the review page.
export function applicationOfAlert(alert: AdminAlert): string | null {
  if (
    alert.code === 'probation_ending' ||
    alert.code === 'probation_overdue' ||
    alert.code === 'document_expiring'
  ) {
    // «نهاية فترة تجربة» and «مستند ينتهي» (slice 2.35a): the captain's
    // application holds the contract and the documents.
    return alert.applicationId;
  }
  return alert.code === 'captain_application' && alert.subjectType === 'captain_application'
    ? alert.subjectId
    : null;
}

const boardKey = (cityId: string, stage: BoardStage) =>
  ['captain-applications', cityId, stage] as const;
const applicationKey = (applicationId: string) => ['captain-application', applicationId] as const;

export const boardQuery = (cityId: string, stage: BoardStage) =>
  queryOptions({
    queryKey: boardKey(cityId, stage),
    queryFn: async (): Promise<Board> => {
      const { data } = await api.GET('/v1/admin/captain-applications', {
        params: { query: { cityId, stage } },
      });
      if (!data) throw new Error('The applications read failed.');
      return data;
    },
  });

// Null for an unknown application (404). The files' signed links last 10
// minutes: the page is read again before.
export const applicationQuery = (applicationId: string) =>
  queryOptions({
    queryKey: applicationKey(applicationId),
    queryFn: async (): Promise<Application | null> => {
      const { data, response } = await api.GET('/v1/admin/captain-applications/{applicationId}', {
        params: { path: { applicationId } },
      });
      if (response.status === 404) return null;
      if (!data) throw new Error('The application read failed.');
      return data;
    },
    refetchInterval: 5 * 60_000,
  });

// The server's refusals, and what the panel refuses before sending a scan
// (`type`, `size`) or the storage refused (`upload_failed`); `not_image` is
// a stored file that is no image.
export type ApplicationRefusal =
  | 'unknown_application'
  | 'unknown_document'
  | 'wrong_stage'
  | 'document_replaced'
  | 'already_requested'
  | 'document_not_needed'
  | 'interview_in_past'
  | 'invalid_files'
  | 'number_required'
  | 'issue_date_required'
  | 'issue_date_in_future'
  | 'document_expired'
  | 'type'
  | 'size'
  | 'not_image'
  | 'upload_failed';

export type CommandResult =
  | { status: 'done'; application: Application }
  | { status: 'refused'; refusal: ApplicationRefusal; stage?: Stage };

const serverRefusals: readonly string[] = [
  'unknown_application',
  'unknown_document',
  'wrong_stage',
  'document_replaced',
  'already_requested',
  'document_not_needed',
  'interview_in_past',
  'invalid_files',
  'number_required',
  'issue_date_required',
  'issue_date_in_future',
  'document_expired',
] satisfies ApplicationRefusal[];

type Answer = { data?: Application; error?: unknown; response: Response };

// Maps an action's answer: the review page after it, or the refusal the
// page explains; anything else throws.
export function commandResult(answer: Answer): CommandResult {
  if (answer.data) return { status: 'done', application: answer.data };
  const status = answer.response.status;
  const error = answer.error as { error?: unknown; stage?: unknown } | undefined;
  const code = error?.error;
  if ((status === 400 || status === 404 || status === 409) && typeof code === 'string') {
    if (serverRefusals.includes(code)) {
      const refusal = code as ApplicationRefusal;
      return refusal === 'wrong_stage' && typeof error?.stage === 'string'
        ? { status: 'refused', refusal, stage: error.stage as Stage }
        : { status: 'refused', refusal };
    }
    // The uploads' refusals (architecture §5.8).
    if (code === 'upload_invalid') return { status: 'refused', refusal: 'not_image' };
    if (code.startsWith('upload_')) return { status: 'refused', refusal: 'upload_failed' };
  }
  throw new Error(`The application action failed with ${status}.`);
}

// A reason the server takes (1 to 500 characters, trimmed); null while
// empty.
export function reasonOf(text: string): string | null {
  const reason = text.trim();
  return reason === '' || reason.length > 500 ? null : reason;
}

// «تحديد مقابلة»: the time typed on the city's clock, the place and its
// point.
export interface InterviewForm {
  at: string;
  place: string;
  latitude: string;
  longitude: string;
}

export function interviewFormOf(
  interview: Application['interview'],
  timeZone: string,
): InterviewForm {
  return interview
    ? {
        at: utcToZoned(interview.at, timeZone),
        place: interview.place,
        latitude: String(interview.latitude),
        longitude: String(interview.longitude),
      }
    : { at: '', place: '', latitude: '', longitude: '' };
}

export type InterviewBody = components['schemas']['AdminCaptainApplicationInterviewDto'];
export type InterviewProblem = 'at' | 'in_past' | 'place' | 'point';

// The body, or the first problem; the server checks the future again.
export function interviewBody(
  form: InterviewForm,
  timeZone: string,
  now: number,
): { body: InterviewBody } | { problem: InterviewProblem } {
  const at = zonedToUtc(form.at, timeZone);
  if (at === null) return { problem: 'at' };
  if (Date.parse(at) <= now) return { problem: 'in_past' };
  const place = form.place.trim();
  if (place === '' || place.length > 200) return { problem: 'place' };
  const latitude = degreesOf(form.latitude, 90);
  const longitude = degreesOf(form.longitude, 180);
  if (latitude === null || longitude === null) return { problem: 'point' };
  return { body: { at, place, latitude, longitude } };
}

// «رفع نسخة المكتب»: the office's scan of a paper document.
export interface ScanForm {
  kind: DocumentKind;
  files: File[];
  number: string;
  issueDate: string;
}

export type ScanProblem = 'files' | 'number' | 'issue_date';

// What the server checks first: the ID's front and back, one or two pages
// of the others, the ID's number and the criminal record's issue date.
export function scanProblem(
  form: Pick<ScanForm, 'kind' | 'files' | 'number' | 'issueDate'>,
): ScanProblem | null {
  const count = form.files.length;
  if (form.kind === 'national_id' ? count !== 2 : count < 1 || count > 2) {
    return 'files';
  }
  if (form.kind === 'national_id' && form.number.trim() === '') {
    return 'number';
  }
  if (form.kind === 'criminal_record' && !/^\d{4}-\d{2}-\d{2}$/.test(form.issueDate)) {
    return 'issue_date';
  }
  return null;
}

export type Command =
  | { action: 'review_document'; documentId: string; status: 'accepted' }
  | { action: 'review_document'; documentId: string; status: 'rejected'; reason: string }
  | { action: 'request_document'; kind: DocumentKind; reason: string }
  | { action: 'schedule_interview'; body: InterviewBody }
  | { action: 'training_passed' }
  | { action: 'reject'; reason: string }
  | { action: 'waitlist' }
  | { action: 'back_from_waitlist' };

async function send(applicationId: string, command: Command): Promise<Answer> {
  const path = { applicationId };
  switch (command.action) {
    case 'review_document':
      return api.POST(
        '/v1/admin/captain-applications/{applicationId}/documents/{documentId}/review',
        {
          params: { path: { applicationId, documentId: command.documentId } },
          body:
            command.status === 'accepted'
              ? { status: 'accepted' }
              : { status: 'rejected', reason: command.reason },
        },
      );
    case 'request_document':
      return api.POST('/v1/admin/captain-applications/{applicationId}/document-requests', {
        params: { path },
        body: { kind: command.kind, reason: command.reason },
      });
    case 'schedule_interview':
      return api.PUT('/v1/admin/captain-applications/{applicationId}/interview', {
        params: { path },
        body: command.body,
      });
    case 'training_passed':
      return api.POST('/v1/admin/captain-applications/{applicationId}/training-passed', {
        params: { path },
      });
    case 'reject':
      return api.POST('/v1/admin/captain-applications/{applicationId}/reject', {
        params: { path },
        body: { reason: command.reason },
      });
    case 'waitlist':
      return api.POST('/v1/admin/captain-applications/{applicationId}/waitlist', {
        params: { path },
      });
    case 'back_from_waitlist':
      return api.POST('/v1/admin/captain-applications/{applicationId}/back-from-waitlist', {
        params: { path },
      });
  }
}

function useAnswered(applicationId: string) {
  const queryClient = useQueryClient();
  return {
    onSuccess: (result: CommandResult) => {
      if (result.status === 'done') {
        queryClient.setQueryData(applicationKey(applicationId), result.application);
      } else {
        // A refusal may mean the page is out of date (another admin acted).
        void queryClient.invalidateQueries({ queryKey: applicationKey(applicationId) });
      }
      void queryClient.invalidateQueries({ queryKey: ['captain-applications'] });
    },
  };
}

// The actions that set a value or are refused once taken (409 wrong_stage,
// already_requested), so they take no Idempotency-Key. Each answers the
// review page, which replaces the read; the board is read again.
export function useApplicationCommand(applicationId: string) {
  const answered = useAnswered(applicationId);
  return useMutation({
    mutationFn: async (command: Command) => commandResult(await send(applicationId, command)),
    ...answered,
  });
}

// «رفع نسخة المكتب»: each file is uploaded with a signed PUT (architecture
// §5.8, purpose captain_document, to /private-docs/incoming/ on the panel's
// origin), then the document links them.
export function useUploadScan(applicationId: string) {
  const answered = useAnswered(applicationId);
  return useMutation({
    mutationFn: async (form: ScanForm): Promise<CommandResult> => {
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
        await api.PUT('/v1/admin/captain-applications/{applicationId}/documents/{kind}', {
          params: { path: { applicationId, kind: form.kind } },
          body: {
            uploadIds,
            ...(form.kind === 'national_id' ? { number: form.number.trim() } : {}),
            ...(form.kind === 'criminal_record' ? { issueDate: form.issueDate } : {}),
          },
        }),
      );
    },
    ...answered,
  });
}

// «إضافة ملاحظة»: one Idempotency-Key per note, kept until an answer
// arrives, so a retry after a lost answer adds it once.
export function useAddApplicationNote(applicationId: string) {
  const answered = useAnswered(applicationId);
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (note: string): Promise<CommandResult> => {
      let key = keys.current.get(note);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(note, key);
      }
      const result = commandResult(
        await api.POST('/v1/admin/captain-applications/{applicationId}/notes', {
          params: { path: { applicationId }, header: { 'Idempotency-Key': key } },
          body: { note },
        }),
      );
      keys.current.delete(note);
      return result;
    },
    ...answered,
  });
}
