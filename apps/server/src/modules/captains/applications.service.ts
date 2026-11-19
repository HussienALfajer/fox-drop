import { Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, isNull, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { TermsService } from '../content/index.js';
import { FilesService } from '../files/index.js';
import { GeoService } from '../geo/index.js';
import { SettingsService, type Vehicle } from '../settings/index.js';
import {
  type ApplicationDocumentKind,
  type ApplicationStage,
  cityDay,
  criminalRecordExpiry,
  fileCountAllowed,
  isMotorVehicle,
  type Missing,
  missing,
  normaliseFullName,
  normaliseIdNumber,
  normalisePlate,
  mayUploadAgain,
  oldEnough,
  reapplyFrom,
} from './applications.js';
import {
  applicationDocumentRequests,
  applicationDocuments,
  applicationEvents,
  applications,
} from './schema.js';

export type { ApplicationStage } from './applications.js';

export type ApplicationRefusal =
  // The form is for an account without a captain (CA §15).
  | 'already_captain'
  // A step before step 1.
  | 'no_application'
  // Sent already: only the panel moves it now (CA §5.4).
  | 'application_submitted'
  | 'invalid_name'
  | 'too_young'
  | 'unknown_zone'
  | 'plate_required'
  | 'invalid_files'
  | 'number_required'
  | 'issue_date_required'
  | 'issue_date_in_future'
  | 'document_expired'
  | 'document_not_needed'
  | 'incomplete'
  // K11 (slice 2.34b): a new application 30 days after a rejection.
  | 'reapply_wait';

export class ApplicationRefusedError extends Error {
  constructor(
    readonly refusal: ApplicationRefusal,
    readonly missing: Missing[] = [],
    readonly reapplyFrom: Date | null = null,
  ) {
    super(`application refused: ${refusal}`);
  }
}

// What the panel asked for (AP §9.7.1 «طلب مستند»), open until the applicant
// uploads that document again.
export interface DocumentRequest {
  kind: ApplicationDocumentKind;
  reason: string;
  requestedAt: Date;
}

export interface Interview {
  at: Date;
  place: string;
  latitude: number;
  longitude: number;
}

export interface Rejection {
  reason: string;
  at: Date;
  // K11: a new application from then.
  reapplyFrom: Date;
}

// What the applicant is told of a change (CA §5.4, §14 #29): a stage, a
// document asked for or rejected; null for none (a note, an acceptance).
export type ApplicationNotice =
  | { kind: 'submitted' }
  | { kind: 'stage'; stage: ApplicationStage }
  | { kind: 'document_requested'; document: ApplicationDocumentKind; reason: string }
  | { kind: 'document_rejected'; document: ApplicationDocumentKind; reason: string };

// Heard in the transaction of every change of a sent application: the alert
// «طلب انضمام كابتن» and the applicant's pushes (notifications), one per
// notice: a document asked for on a «جديد» application tells both the stage
// and the request.
export interface ApplicationChange {
  applicationId: string;
  accountId: string;
  cityId: string;
  fullName: string;
  stage: ApplicationStage;
  // The captain made from it, once «مفعّل» (slice 2.35a).
  captainId: string | null;
  // The event that tells it: names the push once.
  eventId: string;
  at: Date;
  notices: ApplicationNotice[];
  interview: Interview | null;
  rejection: Rejection | null;
  timeZone: string;
}

export type ApplicationListener = (tx: Tx, change: ApplicationChange) => Promise<void>;

export interface ApplicationDocument {
  kind: ApplicationDocumentKind;
  status: 'pending' | 'accepted' | 'rejected';
  reason: string | null;
  fileCount: number;
  number: string | null;
  issueDate: string | null;
  expiresOn: string | null;
  uploadedAt: Date;
}

export interface Application {
  id: string;
  stage: ApplicationStage;
  cityId: string;
  fullName: string;
  birthDate: string;
  zoneId: string;
  vehicle: Vehicle | null;
  plate: string | null;
  documents: ApplicationDocument[];
  // What «إرسال الطلب» still waits for, in the form's order.
  missing: Missing[];
  submittedAt: Date | null;
  // The panel's (slice 2.34b): what it asked for, the interview, the
  // rejection, and the stages so far (CA §5.4's history).
  requests: DocumentRequest[];
  interview: Interview | null;
  rejection: Rejection | null;
  history: { stage: ApplicationStage; at: Date }[];
}

export interface ApplicationZone {
  id: string;
  name: string;
  cityId: string;
  cityName: string;
}

// The applicant: their sign-in account, and whether it has a captain.
export interface Applicant {
  accountId: string;
  captain: boolean;
}

export type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

type ApplicationRow = typeof applications.$inferSelect;

// CA §5.1–5.3, §15 (slice 2.34a): the applicant's own application, saved
// after every step of the form, then sent. The applicant's own data, as a
// customer's details are, so not audited (decided by us); the panel's
// changes are (slice 2.34b).
@Injectable()
export class ApplicationsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly settings: SettingsService,
    private readonly terms: TermsService,
    private readonly files: FilesService,
  ) {}

  private readonly listeners: ApplicationListener[] = [];

  // Notifications registers the alert and the applicant's push.
  onChanged(listener: ApplicationListener): void {
    this.listeners.push(listener);
  }

  async notify(tx: Tx, change: ApplicationChange): Promise<void> {
    for (const listener of this.listeners) await listener(tx, change);
  }

  // The neighbourhoods an applicant chooses from (owner decision 2026-11-19):
  // the active zones of the active cities, by city then name.
  async zones(): Promise<ApplicationZone[]> {
    const found: ApplicationZone[] = [];
    for (const city of await this.geo.activeCities()) {
      for (const zone of await this.geo.zones(city.id)) {
        if (zone.active) {
          found.push({ id: zone.id, name: zone.name, cityId: city.id, cityName: city.name });
        }
      }
    }
    return found;
  }

  // The account's application: the one not rejected, else the latest
  // rejected; null before step 1.
  async application(accountId: string, now = new Date()): Promise<Application | null> {
    const [row] = await this.database.db
      .select()
      .from(applications)
      .where(eq(applications.accountId, accountId))
      .orderBy(sql`${applications.stage} = 'rejected'`, desc(applications.createdAt))
      .limit(1);
    if (!row) return null;
    const documents = await this.documents(this.database.db, row.id);
    const timeZone = (await this.geo.cityTimeZone(row.cityId)) ?? 'UTC';
    const history = await this.database.db
      .select({ stage: applicationEvents.stage, at: applicationEvents.at })
      .from(applicationEvents)
      .where(
        and(
          eq(applicationEvents.applicationId, row.id),
          inArray(applicationEvents.kind, ['submitted', 'stage']),
        ),
      )
      .orderBy(asc(applicationEvents.at), asc(applicationEvents.id));
    return {
      id: row.id,
      stage: row.stage,
      cityId: row.cityId,
      fullName: row.fullName,
      birthDate: row.birthDate,
      zoneId: row.zoneId,
      vehicle: row.vehicle,
      plate: row.plate,
      documents,
      missing: missing({
        vehicle: row.vehicle,
        documents,
        termsPending: await this.terms.pending('captain', accountId),
        today: cityDay(now, timeZone),
      }),
      submittedAt: row.submittedAt,
      requests: await this.openRequests(this.database.db, row.id),
      interview: interviewOf(row),
      rejection: rejectionOf(row),
      history,
    };
  }

  // The panel asked for these and the applicant has not uploaded them again.
  async openRequests(
    executor: Pick<Database['db'], 'select'>,
    applicationId: string,
  ): Promise<DocumentRequest[]> {
    return executor
      .select({
        kind: applicationDocumentRequests.kind,
        reason: applicationDocumentRequests.reason,
        requestedAt: applicationDocumentRequests.requestedAt,
      })
      .from(applicationDocumentRequests)
      .where(
        and(
          eq(applicationDocumentRequests.applicationId, applicationId),
          isNull(applicationDocumentRequests.fulfilledAt),
        ),
      )
      .orderBy(asc(applicationDocumentRequests.requestedAt));
  }

  // Step 1: the name, the date of birth and the neighbourhood, which makes
  // the draft on its first save.
  async savePersonal(
    applicant: Applicant,
    personal: { fullName: string; birthDate: string; zoneId: string },
    now = new Date(),
  ): Promise<Application> {
    refuseCaptain(applicant);
    const fullName = normaliseFullName(personal.fullName);
    if (fullName === null) throw new ApplicationRefusedError('invalid_name');
    const zone = (await this.zones()).find((each) => each.id === personal.zoneId);
    if (!zone) throw new ApplicationRefusedError('unknown_zone');
    const minAge = await this.settings.get('captain.min_age');
    const timeZone = (await this.geo.cityTimeZone(zone.cityId)) ?? 'UTC';
    if (!oldEnough(personal.birthDate, minAge, cityDay(now, timeZone))) {
      throw new ApplicationRefusedError('too_young');
    }
    await this.database.db.transaction(async (tx) => {
      const draft = await this.lockedDraft(tx, applicant.accountId, { orNone: true });
      if (!draft) {
        // K11: a rejected applicant applies again 30 days after it.
        const [rejected] = await tx
          .select({ rejectedAt: applications.rejectedAt })
          .from(applications)
          .where(
            and(
              eq(applications.accountId, applicant.accountId),
              eq(applications.stage, 'rejected'),
            ),
          )
          .orderBy(desc(applications.rejectedAt))
          .limit(1);
        if (rejected?.rejectedAt && reapplyFrom(rejected.rejectedAt) > now) {
          throw new ApplicationRefusedError('reapply_wait', [], reapplyFrom(rejected.rejectedAt));
        }
      }
      const values = {
        fullName,
        birthDate: personal.birthDate,
        zoneId: zone.id,
        cityId: zone.cityId,
        updatedAt: now,
      };
      if (draft) {
        await tx.update(applications).set(values).where(eq(applications.id, draft.id));
      } else {
        await tx
          .insert(applications)
          .values({ ...values, accountId: applicant.accountId, stage: 'draft', createdAt: now });
      }
    });
    return (await this.application(applicant.accountId, now))!;
  }

  // Step 2: the vehicle, with its plate for a motor vehicle (licensed
  // vehicles only, CA §5.2).
  async saveVehicle(
    applicant: Applicant,
    choice: { vehicle: Vehicle; plate?: string | null | undefined },
    now = new Date(),
  ): Promise<Application> {
    refuseCaptain(applicant);
    const plate = isMotorVehicle(choice.vehicle) ? normalisePlate(choice.plate) : null;
    if (isMotorVehicle(choice.vehicle) && plate === null) {
      throw new ApplicationRefusedError('plate_required');
    }
    await this.database.db.transaction(async (tx) => {
      const draft = await this.lockedDraft(tx, applicant.accountId);
      await tx
        .update(applications)
        .set({ vehicle: choice.vehicle, plate, updatedAt: now })
        .where(eq(applications.id, draft!.id));
    });
    return (await this.application(applicant.accountId, now))!;
  }

  // Step 3: one document's photos, uploaded with `POST
  // /v1/captain/application/documents/upload`, each checked by files before
  // the transaction (it calls the storage). A new upload replaces the one in
  // force, which stays as the history. Once sent, only a document the panel
  // asked for or rejected is uploaded again (CA §5.3, slice 2.34b).
  async saveDocument(
    applicant: Applicant,
    kind: ApplicationDocumentKind,
    document: NewDocument,
    now = new Date(),
  ): Promise<Application> {
    refuseCaptain(applicant);
    // «العقد الموقّع» is the office's (CA §5.3).
    if (kind === 'signed_contract') throw new ApplicationRefusedError('document_not_needed');
    const current = await this.application(applicant.accountId, now);
    if (current === null) throw new ApplicationRefusedError('no_application');
    if (current.stage !== 'draft' && !uploadAgain(current, kind)) {
      throw new ApplicationRefusedError('application_submitted');
    }
    const checked = await this.checkedDocument(current, kind, document, applicant.accountId, now);
    await this.database.db.transaction(async (tx) => {
      const locked = await this.locked(tx, applicant.accountId);
      if (locked.stage !== 'draft') {
        // Checked again under the lock: the panel may have moved it since.
        const again = {
          stage: locked.stage,
          requests: await this.openRequests(tx, locked.id),
          documents: await this.documents(tx, locked.id),
        };
        if (!uploadAgain(again, kind)) throw new ApplicationRefusedError('application_submitted');
      }
      if (!(await this.storeDocument(tx, locked, kind, checked, applicant.accountId, now))) return;
      await tx.update(applications).set({ updatedAt: now }).where(eq(applications.id, locked.id));
      if (locked.stage !== 'draft') {
        await tx.insert(applicationEvents).values({
          applicationId: locked.id,
          at: now,
          actorId: null,
          kind: 'document_upload',
          stage: locked.stage,
          documentKind: kind,
        });
      }
    });
    return (await this.application(applicant.accountId, now))!;
  }

  // A document's checks before its transaction: its files' count, whether
  // the vehicle needs it, the ID's number, the criminal record's dates (C18),
  // and each file by files.prepare (it calls the storage). `owner` made the
  // uploads: the applicant, or the admin of an office scan (slice 2.34b).
  async checkedDocument(
    application: { cityId: string; vehicle: Vehicle | null },
    kind: ApplicationDocumentKind,
    document: NewDocument,
    owner: string,
    now: Date,
  ): Promise<CheckedDocument> {
    if (!fileCountAllowed(kind, document.uploadIds.length)) {
      throw new ApplicationRefusedError('invalid_files');
    }
    if (new Set(document.uploadIds).size !== document.uploadIds.length) {
      throw new ApplicationRefusedError('invalid_files');
    }
    if (
      kind === 'vehicle_papers' &&
      (application.vehicle === null || !isMotorVehicle(application.vehicle))
    ) {
      throw new ApplicationRefusedError('document_not_needed');
    }
    // The ID's number is the duplicate check's (CA §5.2; decided by us: the
    // applicant types it with the photos).
    const number = kind === 'national_id' ? normaliseIdNumber(document.number) : null;
    if (kind === 'national_id' && number === null) {
      throw new ApplicationRefusedError('number_required');
    }
    let issueDate: string | null = null;
    let expiresOn: string | null = null;
    if (kind === 'criminal_record') {
      if (!document.issueDate) throw new ApplicationRefusedError('issue_date_required');
      const timeZone = (await this.geo.cityTimeZone(application.cityId)) ?? 'UTC';
      const today = cityDay(now, timeZone);
      if (document.issueDate > today) throw new ApplicationRefusedError('issue_date_in_future');
      issueDate = document.issueDate;
      expiresOn = criminalRecordExpiry(
        issueDate,
        await this.settings.get('captain.criminal_record_validity_months', {
          cityId: application.cityId,
        }),
      );
      if (expiresOn <= today) throw new ApplicationRefusedError('document_expired');
    }
    for (const uploadId of document.uploadIds) {
      await this.files.prepare(uploadId, 'captain_document', now, owner);
    }
    return { uploadIds: document.uploadIds, number, issueDate, expiresOn };
  }

  // A checked document's row, in the caller's transaction under the
  // application's lock: it replaces the one in force and answers the
  // panel's open request for it. `uploadedBy` is the applicant's account or
  // the admin's (the office's scan). The files of the document in force sent
  // again change nothing (a retry): it answers false.
  async storeDocument(
    tx: Tx,
    application: { id: string; vehicle: Vehicle | null },
    kind: ApplicationDocumentKind,
    checked: CheckedDocument,
    uploadedBy: string,
    now: Date,
    // The office's signed contract is accepted as it is uploaded (owner
    // decision 2026-11-19, slice 2.35a).
    acceptedBy: string | null = null,
  ): Promise<boolean> {
    // Checked again under the lock: a vehicle changed since the read.
    if (
      kind === 'vehicle_papers' &&
      (application.vehicle === null || !isMotorVehicle(application.vehicle))
    ) {
      throw new ApplicationRefusedError('document_not_needed');
    }
    const fileKeys: string[] = [];
    let sameFiles = 0;
    for (const uploadId of checked.uploadIds) {
      const { key, alreadyLinked } = await this.files.link(tx, uploadId, now);
      // A file linked before belongs to another document (or to this one
      // in force: sending the same files again changes nothing).
      if (alreadyLinked) {
        const [same] = await tx
          .select({ id: applicationDocuments.id })
          .from(applicationDocuments)
          .where(
            and(
              eq(applicationDocuments.applicationId, application.id),
              eq(applicationDocuments.kind, kind),
              isNull(applicationDocuments.replacedAt),
              sql`${key} = ANY(${applicationDocuments.fileKeys})`,
            ),
          );
        if (!same) throw new ApplicationRefusedError('invalid_files');
        sameFiles += 1;
      }
      fileKeys.push(key);
    }
    if (sameFiles === fileKeys.length) {
      const [inForce] = await tx
        .select({ fileKeys: applicationDocuments.fileKeys })
        .from(applicationDocuments)
        .where(
          and(
            eq(applicationDocuments.applicationId, application.id),
            eq(applicationDocuments.kind, kind),
            isNull(applicationDocuments.replacedAt),
          ),
        );
      if (inForce?.fileKeys.length === fileKeys.length) return false;
    }
    await tx
      .update(applicationDocuments)
      .set({ replacedAt: now })
      .where(
        and(
          eq(applicationDocuments.applicationId, application.id),
          eq(applicationDocuments.kind, kind),
          isNull(applicationDocuments.replacedAt),
        ),
      );
    await tx.insert(applicationDocuments).values({
      applicationId: application.id,
      kind,
      fileKeys,
      number: checked.number,
      issueDate: checked.issueDate,
      expiresOn: checked.expiresOn,
      status: acceptedBy === null ? 'pending' : 'accepted',
      ...(acceptedBy === null ? {} : { reviewedBy: acceptedBy, reviewedAt: now }),
      uploadedBy,
      createdAt: now,
    });
    await tx
      .update(applicationDocumentRequests)
      .set({ fulfilledAt: now })
      .where(
        and(
          eq(applicationDocumentRequests.applicationId, application.id),
          eq(applicationDocumentRequests.kind, kind),
          isNull(applicationDocumentRequests.fulfilledAt),
        ),
      );
    return true;
  }

  // Step 5 «إرسال الطلب»: the draft becomes «جديد» once nothing is missing,
  // and the panel hears it (the alert «طلب انضمام كابتن», slice 2.34b). A
  // repeat answers the application sent, so it needs no key.
  async submit(applicant: Applicant, now = new Date()): Promise<Application> {
    refuseCaptain(applicant);
    const current = await this.application(applicant.accountId, now);
    if (current === null) throw new ApplicationRefusedError('no_application');
    if (current.stage !== 'draft') return current;
    if (current.missing.length > 0) {
      throw new ApplicationRefusedError('incomplete', current.missing);
    }
    // Read before the transaction: each takes a connection of its own. The
    // terms, once accepted, stay so.
    const termsPending = await this.terms.pending('captain', applicant.accountId);
    const timeZone = (await this.geo.cityTimeZone(current.cityId)) ?? 'UTC';
    const today = cityDay(now, timeZone);
    try {
      await this.database.db.transaction(async (tx) => {
        const draft = await this.lockedDraft(tx, applicant.accountId);
        // What is missing, again under the lock: a vehicle or a document
        // changed since the read above.
        const found = missing({
          vehicle: draft!.vehicle,
          documents: await this.documents(tx, draft!.id),
          termsPending,
          today,
        });
        if (found.length > 0) throw new ApplicationRefusedError('incomplete', found);
        const [row] = await tx
          .update(applications)
          .set({ stage: 'new', submittedAt: now, updatedAt: now })
          .where(eq(applications.id, draft!.id))
          .returning();
        const [event] = await tx
          .insert(applicationEvents)
          .values({
            applicationId: row!.id,
            at: now,
            actorId: null,
            kind: 'submitted',
            stage: 'new',
          })
          .returning({ id: applicationEvents.id });
        await this.notify(tx, changeOf(row!, event!.id, now, [{ kind: 'submitted' }], timeZone));
      });
    } catch (error) {
      // A submission at the same time sent it: answer it.
      if (
        !(error instanceof ApplicationRefusedError) ||
        error.refusal !== 'application_submitted'
      ) {
        throw error;
      }
    }
    return (await this.application(applicant.accountId, now))!;
  }

  // The account's application not rejected, locked; a draft only. Every
  // save of one account takes turns on its advisory lock, so the first
  // save's insert never races another.
  private async lockedDraft(
    tx: Tx,
    accountId: string,
    options: { orNone?: boolean } = {},
  ): Promise<{ id: string; vehicle: Vehicle | null } | null> {
    const row = await this.locked(tx, accountId, options);
    if (row === null) return null;
    if (row.stage !== 'draft') throw new ApplicationRefusedError('application_submitted');
    return { id: row.id, vehicle: row.vehicle };
  }

  // The account's application not rejected, locked, at any stage.
  private async locked(tx: Tx, accountId: string): Promise<LockedApplication>;
  private async locked(
    tx: Tx,
    accountId: string,
    options: { orNone?: boolean },
  ): Promise<LockedApplication | null>;
  private async locked(
    tx: Tx,
    accountId: string,
    options: { orNone?: boolean } = {},
  ): Promise<LockedApplication | null> {
    await tx.execute(
      sql`SELECT pg_advisory_xact_lock(hashtextextended(${`captains.application:${accountId}`}, 0))`,
    );
    const [row] = await tx
      .select({ id: applications.id, stage: applications.stage, vehicle: applications.vehicle })
      .from(applications)
      .where(and(eq(applications.accountId, accountId), ne(applications.stage, 'rejected')))
      .for('update');
    if (!row) {
      if (options.orNone) return null;
      throw new ApplicationRefusedError('no_application');
    }
    return row;
  }

  // The application's documents in force.
  async documents(
    executor: Pick<Database['db'], 'select'>,
    applicationId: string,
  ): Promise<ApplicationDocument[]> {
    const rows = await executor
      .select()
      .from(applicationDocuments)
      .where(
        and(
          eq(applicationDocuments.applicationId, applicationId),
          isNull(applicationDocuments.replacedAt),
        ),
      )
      .orderBy(applicationDocuments.createdAt);
    return rows.map((row) => ({
      kind: row.kind,
      status: row.status,
      reason: row.reason,
      fileCount: row.fileKeys.length,
      number: row.number,
      issueDate: row.issueDate,
      expiresOn: row.expiresOn,
      uploadedAt: row.createdAt,
    }));
  }
}

export interface NewDocument {
  uploadIds: string[];
  number?: string | null | undefined;
  issueDate?: string | null | undefined;
}

export interface CheckedDocument {
  uploadIds: string[];
  number: string | null;
  issueDate: string | null;
  expiresOn: string | null;
}

interface LockedApplication {
  id: string;
  stage: ApplicationStage;
  vehicle: Vehicle | null;
}

function refuseCaptain(applicant: Applicant): void {
  if (applicant.captain) throw new ApplicationRefusedError('already_captain');
}

// Whether a sent application takes this document from the applicant again.
function uploadAgain(
  application: {
    stage: ApplicationStage;
    requests: { kind: ApplicationDocumentKind }[];
    documents: { kind: ApplicationDocumentKind; status: string }[];
  },
  kind: ApplicationDocumentKind,
): boolean {
  return mayUploadAgain(application.stage, {
    requested: application.requests.some((request) => request.kind === kind),
    rejected: application.documents.some(
      (document) => document.kind === kind && document.status === 'rejected',
    ),
  });
}

export function interviewOf(row: ApplicationRow): Interview | null {
  return row.interviewAt === null
    ? null
    : {
        at: row.interviewAt,
        place: row.interviewPlace!,
        latitude: row.interviewLatitude!,
        longitude: row.interviewLongitude!,
      };
}

export function rejectionOf(row: ApplicationRow): Rejection | null {
  return row.rejectedAt === null
    ? null
    : {
        reason: row.rejectionReason!,
        at: row.rejectedAt,
        reapplyFrom: reapplyFrom(row.rejectedAt),
      };
}

export function changeOf(
  row: ApplicationRow,
  eventId: string,
  at: Date,
  notices: ApplicationNotice[],
  timeZone: string,
): ApplicationChange {
  return {
    applicationId: row.id,
    accountId: row.accountId,
    cityId: row.cityId,
    fullName: row.fullName,
    stage: row.stage,
    captainId: row.captainId,
    eventId,
    at,
    notices,
    interview: interviewOf(row),
    rejection: rejectionOf(row),
    timeZone,
  };
}
