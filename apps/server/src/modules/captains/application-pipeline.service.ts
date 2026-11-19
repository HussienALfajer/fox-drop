import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, desc, eq, inArray, isNull, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { FilesService } from '../files/index.js';
import { GeoService } from '../geo/index.js';
import type { Vehicle } from '../settings/index.js';
import {
  type ApplicationDocumentKind,
  type ApplicationStage,
  isMotorVehicle,
  type PipelineAction,
  pipelineSteps,
  plateKey,
  requiredDocuments,
} from './applications.js';
import {
  type ApplicationNotice,
  ApplicationsService,
  changeOf,
  type DocumentRequest,
  type Interview,
  interviewOf,
  type NewDocument,
  type Rejection,
  rejectionOf,
  type Tx,
} from './applications.service.js';
import {
  applicationDocumentRequests,
  applicationDocuments,
  applicationEvents,
  type applicationEventKinds,
  applications,
  applicationStages,
  captainRecords,
} from './schema.js';

export type PipelineRefusal =
  | 'unknown_application'
  // The action is not taken at the application's stage (`stage`).
  | 'wrong_stage'
  | 'unknown_document'
  // The document reviewed was replaced by a newer upload meanwhile.
  | 'document_replaced'
  | 'document_not_needed'
  | 'already_requested'
  | 'interview_in_past';

export class PipelineRefusedError extends Error {
  constructor(
    readonly refusal: PipelineRefusal,
    readonly stage: ApplicationStage | null = null,
  ) {
    super(`pipeline refused: ${refusal}`);
  }
}

// The admin who acts, for the audit log and the history.
export interface PipelineAdmin {
  actor: AuditActor;
  context: AuditRequestContext;
}

// The stages of the board (AP §9.7.1): every one but the draft.
export type BoardStage = Exclude<ApplicationStage, 'draft'>;
export const boardStages = applicationStages.filter(
  (stage): stage is BoardStage => stage !== 'draft',
) as [BoardStage, ...BoardStage[]];

export interface BoardEntry {
  id: string;
  fullName: string;
  vehicle: Vehicle;
  zoneId: string;
  stage: ApplicationStage;
  submittedAt: Date;
  updatedAt: Date;
}

export interface ReviewDocument {
  id: string;
  kind: ApplicationDocumentKind;
  status: 'pending' | 'accepted' | 'rejected';
  reason: string | null;
  number: string | null;
  issueDate: string | null;
  expiresOn: string | null;
  uploadedAt: Date;
  // The applicant's own upload, or the office's scan with its admin.
  uploadedByOffice: boolean;
  uploadedBy: string | null;
  reviewedBy: string | null;
  reviewedAt: Date | null;
  inForce: boolean;
  // Signed for the panel's origin, valid FILE_URL_SECONDS.
  fileUrls: string[];
}

export interface Duplicate {
  field: 'id_number' | 'phone' | 'plate';
  // Another application, or a captain.
  applicationId: string | null;
  captainId: string | null;
  fullName: string;
  stage: ApplicationStage | null;
}

export interface ReviewEvent {
  id: string;
  at: Date;
  // The admin's name; null for the applicant.
  actor: string | null;
  kind: (typeof applicationEventKinds)[number];
  stage: ApplicationStage;
  documentKind: ApplicationDocumentKind | null;
  documentStatus: 'pending' | 'accepted' | 'rejected' | null;
  note: string | null;
}

export interface Review {
  id: string;
  stage: ApplicationStage;
  cityId: string;
  fullName: string;
  birthDate: string;
  zoneId: string;
  zoneName: string | null;
  vehicle: Vehicle | null;
  plate: string | null;
  // The verified number the applicant signed in with.
  phone: string | null;
  submittedAt: Date | null;
  updatedAt: Date;
  requiredDocuments: ApplicationDocumentKind[];
  documents: ReviewDocument[];
  requests: (DocumentRequest & { requestedBy: string | null })[];
  interview: Interview | null;
  rejection: Rejection | null;
  duplicates: Duplicate[];
  events: ReviewEvent[];
}

// What identity answers this module (architecture §4.3: identity imports
// captains, so it registers these at start): the applicants' numbers and
// the admins' names.
export interface PipelineIdentity {
  phones(accountIds: string[]): Promise<Map<string, string>>;
  adminNames(accountIds: string[]): Promise<Map<string, string>>;
}

// How long a document's signed link stays valid, as the restaurants' scans.
export const FILE_URL_SECONDS = 600;

type Row = typeof applications.$inferSelect;

// What an action changed, for its row, its event, its audit and its push.
interface Outcome {
  set?: Partial<typeof applications.$inferInsert>;
  event?: Omit<typeof applicationEvents.$inferInsert, 'applicationId' | 'at' | 'actorId' | 'stage'>;
  audit: string;
  before?: Record<string, unknown>;
  after?: Record<string, unknown>;
  reason?: string | null;
  // What the applicant is told besides the stage it moved to (CA §14 #29).
  notices?: ApplicationNotice[];
}

// AP §9.7.1 (slice 2.34b): the panel's pipeline of captain applications:
// the board by stage, the review page and its actions. Each action locks the
// application, checks its stage (`pipelineSteps`), moves a «جديد» one to
// «قيد المراجعة» first, records the history, audits it as
// `captain_application.<action>` and lets the listeners hear it in its
// transaction (the alert and the applicant's push).
@Injectable()
export class ApplicationPipelineService {
  private identity: PipelineIdentity | null = null;

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly applications: ApplicationsService,
    private readonly files: FilesService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
  ) {}

  useIdentity(identity: PipelineIdentity): void {
    this.identity = identity;
  }

  // The board: the count of each stage, and one stage's applications,
  // oldest sent first.
  async board(
    cityId: string,
    stage: ApplicationStage,
  ): Promise<{ counts: Partial<Record<BoardStage, number>>; applications: BoardEntry[] }> {
    const counted = await this.database.db
      .select({ stage: applications.stage, n: count() })
      .from(applications)
      .where(and(eq(applications.cityId, cityId), ne(applications.stage, 'draft')))
      .groupBy(applications.stage);
    const rows = await this.database.db
      .select()
      .from(applications)
      .where(and(eq(applications.cityId, cityId), eq(applications.stage, stage)))
      .orderBy(asc(applications.submittedAt), asc(applications.id));
    return {
      counts: Object.fromEntries(counted.map((row) => [row.stage, row.n])) as Partial<
        Record<BoardStage, number>
      >,
      applications: rows
        .filter((row) => row.stage !== 'draft')
        .map((row) => ({
          id: row.id,
          fullName: row.fullName,
          vehicle: row.vehicle!,
          zoneId: row.zoneId,
          stage: row.stage,
          submittedAt: row.submittedAt!,
          updatedAt: row.updatedAt,
        })),
    };
  }

  // The review page (AP §9.7.1). A draft is the applicant's still: unknown.
  async review(applicationId: string, now = new Date()): Promise<Review> {
    const [row] = await this.database.db
      .select()
      .from(applications)
      .where(eq(applications.id, applicationId));
    if (!row || row.stage === 'draft') throw new PipelineRefusedError('unknown_application');
    const uploads = await this.database.db
      .select()
      .from(applicationDocuments)
      .where(eq(applicationDocuments.applicationId, row.id))
      .orderBy(desc(applicationDocuments.createdAt));
    const requests = await this.database.db
      .select()
      .from(applicationDocumentRequests)
      .where(
        and(
          eq(applicationDocumentRequests.applicationId, row.id),
          isNull(applicationDocumentRequests.fulfilledAt),
        ),
      )
      .orderBy(asc(applicationDocumentRequests.requestedAt));
    const events = await this.database.db
      .select()
      .from(applicationEvents)
      .where(eq(applicationEvents.applicationId, row.id))
      .orderBy(asc(applicationEvents.at), asc(applicationEvents.id));
    const admins = [
      ...uploads.flatMap((upload) => [upload.uploadedBy, upload.reviewedBy]),
      ...requests.map((request) => request.requestedBy),
      ...events.map((event) => event.actorId),
    ].filter((id): id is string => id !== null && id !== row.accountId);
    const names = await this.lookups().adminNames([...new Set(admins)]);
    const phone = (await this.lookups().phones([row.accountId])).get(row.accountId) ?? null;
    const zone = (await this.geo.zones(row.cityId)).find((each) => each.id === row.zoneId);
    const documents: ReviewDocument[] = [];
    for (const upload of uploads) {
      const office = upload.uploadedBy !== row.accountId;
      documents.push({
        id: upload.id,
        kind: upload.kind,
        status: upload.status,
        reason: upload.reason,
        number: upload.number,
        issueDate: upload.issueDate,
        expiresOn: upload.expiresOn,
        uploadedAt: upload.createdAt,
        uploadedByOffice: office,
        uploadedBy: office ? (names.get(upload.uploadedBy) ?? null) : null,
        reviewedBy: upload.reviewedBy === null ? null : (names.get(upload.reviewedBy) ?? null),
        reviewedAt: upload.reviewedAt,
        inForce: upload.replacedAt === null,
        fileUrls: await Promise.all(
          upload.fileKeys.map((key) => this.files.privateImageUrl(key, FILE_URL_SECONDS, now)),
        ),
      });
    }
    return {
      id: row.id,
      stage: row.stage,
      cityId: row.cityId,
      fullName: row.fullName,
      birthDate: row.birthDate,
      zoneId: row.zoneId,
      zoneName: zone?.name ?? null,
      vehicle: row.vehicle,
      plate: row.plate,
      phone,
      submittedAt: row.submittedAt,
      updatedAt: row.updatedAt,
      requiredDocuments: requiredDocuments(row.vehicle),
      documents,
      requests: requests.map((request) => ({
        kind: request.kind,
        reason: request.reason,
        requestedAt: request.requestedAt,
        requestedBy: names.get(request.requestedBy) ?? null,
      })),
      interview: interviewOf(row),
      rejection: rejectionOf(row),
      duplicates: await this.duplicates(row, uploads),
      events: events.map((event) => ({
        id: event.id,
        at: event.at,
        actor: event.actorId === null ? null : (names.get(event.actorId) ?? null),
        kind: event.kind,
        stage: event.stage,
        documentKind: event.documentKind,
        documentStatus: event.documentStatus,
        note: event.note,
      })),
    };
  }

  // AP §9.7.1, CA §5.2: the ID's number, the phone and the plate already
  // registered to another applicant or a captain. One number signs in to one
  // account (identity), so the phone finds the account's other
  // applications.
  private async duplicates(
    row: Row,
    uploads: (typeof applicationDocuments.$inferSelect)[],
  ): Promise<Duplicate[]> {
    const found: Duplicate[] = [];
    const numbers = [
      ...new Set(
        uploads
          .filter((upload) => upload.kind === 'national_id' && upload.number !== null)
          .map((upload) => upload.number!),
      ),
    ];
    if (numbers.length > 0) {
      const others = await this.database.db
        .selectDistinct({
          id: applications.id,
          fullName: applications.fullName,
          stage: applications.stage,
        })
        .from(applicationDocuments)
        .innerJoin(applications, eq(applications.id, applicationDocuments.applicationId))
        .where(
          and(
            inArray(applicationDocuments.number, numbers),
            eq(applicationDocuments.kind, 'national_id'),
            ne(applications.id, row.id),
          ),
        );
      for (const other of others) found.push(duplicate('id_number', other));
    }
    const sameAccount = await this.database.db
      .select({ id: applications.id, fullName: applications.fullName, stage: applications.stage })
      .from(applications)
      .where(and(eq(applications.accountId, row.accountId), ne(applications.id, row.id)));
    for (const other of sameAccount) found.push(duplicate('phone', other));
    if (row.plate !== null) {
      const key = plateKey(row.plate);
      const others = await this.database.db
        .select({ id: applications.id, fullName: applications.fullName, stage: applications.stage })
        .from(applications)
        .where(
          and(
            sql`lower(replace(${applications.plate}, ' ', '')) = ${key}`,
            sql`${applications.plate} IS NOT NULL`,
            ne(applications.id, row.id),
          ),
        );
      for (const other of others) found.push(duplicate('plate', other));
      const captains = await this.database.db
        .select({ id: captainRecords.id, name: captainRecords.name })
        .from(captainRecords)
        .where(sql`lower(replace(${captainRecords.plateNumber}, ' ', '')) = ${key}`);
      for (const captain of captains) {
        found.push({
          field: 'plate',
          applicationId: null,
          captainId: captain.id,
          fullName: captain.name,
          stage: null,
        });
      }
    }
    return found;
  }

  // A document's «مقبول» or «مرفوض» with its reason (D24), by the upload the
  // panel showed: a newer upload is `document_replaced`. The same status and
  // reason again changes nothing.
  async reviewDocument(
    applicationId: string,
    admin: PipelineAdmin,
    review: {
      documentId: string;
      status: 'accepted' | 'rejected';
      reason: string | null;
    },
    now = new Date(),
  ): Promise<void> {
    const reason = review.status === 'rejected' ? review.reason : null;
    await this.act(applicationId, admin, 'review_document', now, async (tx, row) => {
      const [document] = await tx
        .select()
        .from(applicationDocuments)
        .where(
          and(
            eq(applicationDocuments.id, review.documentId),
            eq(applicationDocuments.applicationId, row.id),
          ),
        )
        .for('update');
      if (!document) throw new PipelineRefusedError('unknown_document');
      if (document.replacedAt !== null) throw new PipelineRefusedError('document_replaced');
      if (document.status === review.status && document.reason === reason) return null;
      await tx
        .update(applicationDocuments)
        .set({ status: review.status, reason, reviewedBy: admin.actor.id, reviewedAt: now })
        .where(eq(applicationDocuments.id, document.id));
      return {
        event: {
          kind: 'document_review',
          documentKind: document.kind,
          documentStatus: review.status,
          note: reason,
        },
        audit: 'document_review',
        before: { kind: document.kind, status: document.status },
        after: { kind: document.kind, status: review.status },
        reason,
        ...(reason === null
          ? {}
          : { notices: [{ kind: 'document_rejected', document: document.kind, reason }] }),
      };
    });
  }

  // The office's paper scan of a document (AP §9.7.1), uploaded with `POST
  // /v1/admin/uploads` (`captain_document`): it replaces the one in force,
  // pending until reviewed, and answers an open request for it.
  async uploadDocument(
    applicationId: string,
    admin: PipelineAdmin,
    kind: ApplicationDocumentKind,
    document: NewDocument,
    now = new Date(),
  ): Promise<void> {
    const row = await this.row(applicationId);
    const checked = await this.applications.checkedDocument(
      row,
      kind,
      document,
      admin.actor.id!,
      now,
    );
    await this.act(applicationId, admin, 'upload_document', now, async (tx, locked) => {
      if (
        !(await this.applications.storeDocument(tx, locked, kind, checked, admin.actor.id!, now))
      ) {
        return null;
      }
      return {
        event: { kind: 'document_upload', documentKind: kind },
        audit: 'document_upload',
        after: { kind },
      };
    });
  }

  // «طلب مستند»: the applicant is told what is missing (CA §5.4 «يرجى رفع
  // {المستند}: {السبب}»); one open request per document.
  async requestDocument(
    applicationId: string,
    admin: PipelineAdmin,
    request: { kind: ApplicationDocumentKind; reason: string },
    now = new Date(),
  ): Promise<void> {
    await this.act(applicationId, admin, 'request_document', now, async (tx, row) => {
      if (
        request.kind === 'vehicle_papers' &&
        (row.vehicle === null || !isMotorVehicle(row.vehicle))
      ) {
        throw new PipelineRefusedError('document_not_needed');
      }
      const [inserted] = await tx
        .insert(applicationDocumentRequests)
        .values({
          applicationId: row.id,
          kind: request.kind,
          reason: request.reason,
          requestedBy: admin.actor.id!,
          requestedAt: now,
        })
        .onConflictDoNothing()
        .returning({ id: applicationDocumentRequests.id });
      if (!inserted) throw new PipelineRefusedError('already_requested');
      return {
        event: { kind: 'document_request', documentKind: request.kind, note: request.reason },
        audit: 'document_request',
        after: { kind: request.kind },
        reason: request.reason,
        notices: [{ kind: 'document_requested', document: request.kind, reason: request.reason }],
      };
    });
  }

  // A reviewer's note, kept with its Idempotency-Key: a repeat adds none.
  async addNote(
    applicationId: string,
    admin: PipelineAdmin,
    note: string,
    idempotencyKey: string,
    now = new Date(),
  ): Promise<void> {
    if (await this.noted(this.database.db, applicationId, admin, idempotencyKey)) return;
    await this.act(applicationId, admin, 'note', now, async (tx) => {
      if (await this.noted(tx, applicationId, admin, idempotencyKey)) return null;
      return {
        event: { kind: 'note', note, idempotencyKey },
        audit: 'note',
      };
    });
  }

  // «تحديد مقابلة»: its time, place and point, sent to the applicant
  // (→ «مقابلة وتدريب»); again with new values, a new time is sent.
  async scheduleInterview(
    applicationId: string,
    admin: PipelineAdmin,
    interview: Interview,
    now = new Date(),
  ): Promise<void> {
    if (interview.at <= now) throw new PipelineRefusedError('interview_in_past');
    await this.act(applicationId, admin, 'schedule_interview', now, async (_tx, row) => {
      const current = interviewOf(row);
      if (
        row.stage === 'interview' &&
        current !== null &&
        current.at.getTime() === interview.at.getTime() &&
        current.place === interview.place &&
        current.latitude === interview.latitude &&
        current.longitude === interview.longitude
      ) {
        return null;
      }
      return {
        set: {
          interviewAt: interview.at,
          interviewPlace: interview.place,
          interviewLatitude: interview.latitude,
          interviewLongitude: interview.longitude,
        },
        event: { kind: 'interview', note: interview.place },
        audit: 'interview',
        before: current === null ? {} : { interviewAt: current.at.toISOString() },
        after: { interviewAt: interview.at.toISOString(), place: interview.place },
        // A new time is told even when the stage stays.
        notices: [{ kind: 'stage', stage: 'interview' }],
      };
    });
  }

  // Training and the test passed (→ «بانتظار العدة»).
  trainingPassed(applicationId: string, admin: PipelineAdmin, now = new Date()): Promise<void> {
    return this.act(applicationId, admin, 'training_passed', now, async () => ({
      audit: 'training_passed',
    }));
  }

  // «رفض» with its reason, sent to the applicant; a new application after
  // 30 days (K11).
  reject(
    applicationId: string,
    admin: PipelineAdmin,
    reason: string,
    now = new Date(),
  ): Promise<void> {
    return this.act(applicationId, admin, 'reject', now, async (tx, row) => {
      // Nothing more is uploaded to a rejected application: its open
      // requests close with it.
      await tx
        .update(applicationDocumentRequests)
        .set({ fulfilledAt: now })
        .where(
          and(
            eq(applicationDocumentRequests.applicationId, row.id),
            isNull(applicationDocumentRequests.fulfilledAt),
          ),
        );
      return { set: { rejectedAt: now, rejectionReason: reason }, audit: 'reject', reason };
    });
  }

  // «قائمة انتظار» when no captains are needed now; the applicant is told.
  waitlist(applicationId: string, admin: PipelineAdmin, now = new Date()): Promise<void> {
    return this.act(applicationId, admin, 'waitlist', now, async () => ({ audit: 'waitlist' }));
  }

  // Out of the waitlist, back to «قيد المراجعة» (owner decision 2026-11-19).
  backFromWaitlist(applicationId: string, admin: PipelineAdmin, now = new Date()): Promise<void> {
    return this.act(applicationId, admin, 'back_from_waitlist', now, async () => ({
      audit: 'back_from_waitlist',
    }));
  }

  private async act(
    applicationId: string,
    admin: PipelineAdmin,
    action: PipelineAction,
    now: Date,
    work: (tx: Tx, row: Row) => Promise<Outcome | null>,
  ): Promise<void> {
    const { cityId } = await this.row(applicationId);
    const timeZone = (await this.geo.cityTimeZone(cityId)) ?? 'UTC';
    await this.database.db.transaction(async (tx) => {
      const [row] = await tx
        .select()
        .from(applications)
        .where(eq(applications.id, applicationId))
        .for('update');
      if (!row || row.stage === 'draft') throw new PipelineRefusedError('unknown_application');
      const steps = pipelineSteps(action, row.stage);
      if (steps === null) throw new PipelineRefusedError('wrong_stage', row.stage);
      const outcome = await work(tx, row);
      if (outcome === null) return;
      const stage = steps.at(-1) ?? row.stage;
      const [updated] = await tx
        .update(applications)
        .set({ ...outcome.set, stage, updatedAt: now })
        .where(eq(applications.id, row.id))
        .returning();
      let eventId: string | null = null;
      let previous: ApplicationStage = row.stage;
      for (const step of steps) {
        if (step === previous) continue;
        const [event] = await tx
          .insert(applicationEvents)
          .values({
            applicationId: row.id,
            at: now,
            actorId: admin.actor.id,
            kind: 'stage',
            stage: step,
            note: step === 'rejected' ? (outcome.reason ?? null) : null,
          })
          .returning({ id: applicationEvents.id });
        eventId = event!.id;
        previous = step;
      }
      if (outcome.event) {
        const [event] = await tx
          .insert(applicationEvents)
          .values({
            ...outcome.event,
            applicationId: row.id,
            at: now,
            actorId: admin.actor.id,
            stage,
          })
          .returning({ id: applicationEvents.id });
        eventId = event!.id;
      }
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: row.cityId,
          action: `captain_application.${outcome.audit}`,
          target: { type: 'captain_application', id: row.id },
          before: { stage: row.stage, ...outcome.before },
          after: { stage, ...outcome.after },
          reason: outcome.reason ?? null,
        },
        tx,
      );
      // The stage it moved to, unless the action tells it itself, then the
      // action's own notices.
      const own = outcome.notices ?? [];
      const notices: ApplicationNotice[] =
        stage !== row.stage && !own.some((notice) => notice.kind === 'stage')
          ? [{ kind: 'stage', stage }, ...own]
          : own;
      await this.applications.notify(tx, changeOf(updated!, eventId!, now, notices, timeZone));
    });
  }

  private async row(applicationId: string): Promise<Row> {
    const [row] = await this.database.db
      .select()
      .from(applications)
      .where(eq(applications.id, applicationId));
    if (!row || row.stage === 'draft') throw new PipelineRefusedError('unknown_application');
    return row;
  }

  private async noted(
    executor: Pick<Database['db'], 'select'>,
    applicationId: string,
    admin: PipelineAdmin,
    idempotencyKey: string,
  ): Promise<boolean> {
    const [found] = await executor
      .select({ id: applicationEvents.id })
      .from(applicationEvents)
      .where(
        and(
          eq(applicationEvents.applicationId, applicationId),
          eq(applicationEvents.actorId, admin.actor.id!),
          eq(applicationEvents.idempotencyKey, idempotencyKey),
        ),
      );
    return found !== undefined;
  }

  private lookups(): PipelineIdentity {
    if (this.identity === null) throw new Error('identity has not registered its lookups');
    return this.identity;
  }
}

function duplicate(
  field: Duplicate['field'],
  other: { id: string; fullName: string; stage: ApplicationStage },
): Duplicate {
  return {
    field,
    applicationId: other.id,
    captainId: null,
    fullName: other.fullName,
    stage: other.stage,
  };
}
