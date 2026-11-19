import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, isNull, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { TermsService } from '../content/index.js';
import { FilesService } from '../files/index.js';
import { GeoService } from '../geo/index.js';
import { SettingsService, type Vehicle } from '../settings/index.js';
import {
  type ApplicationDocumentKind,
  cityDay,
  criminalRecordExpiry,
  fileCountAllowed,
  isMotorVehicle,
  type Missing,
  missing,
  normaliseFullName,
  normaliseIdNumber,
  normalisePlate,
  oldEnough,
} from './applications.js';
import { applicationDocuments, applications, type applicationStages } from './schema.js';

export type ApplicationStage = (typeof applicationStages)[number];

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
  | 'incomplete';

export class ApplicationRefusedError extends Error {
  constructor(
    readonly refusal: ApplicationRefusal,
    readonly missing: Missing[] = [],
  ) {
    super(`application refused: ${refusal}`);
  }
}

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

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

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
    };
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
  // force, which stays as the history.
  async saveDocument(
    applicant: Applicant,
    kind: ApplicationDocumentKind,
    document: {
      uploadIds: string[];
      number?: string | null | undefined;
      issueDate?: string | null | undefined;
    },
    now = new Date(),
  ): Promise<Application> {
    refuseCaptain(applicant);
    if (!fileCountAllowed(kind, document.uploadIds.length)) {
      throw new ApplicationRefusedError('invalid_files');
    }
    if (new Set(document.uploadIds).size !== document.uploadIds.length) {
      throw new ApplicationRefusedError('invalid_files');
    }
    const current = await this.application(applicant.accountId, now);
    if (current === null) throw new ApplicationRefusedError('no_application');
    if (current.stage !== 'draft') throw new ApplicationRefusedError('application_submitted');
    if (
      kind === 'vehicle_papers' &&
      (current.vehicle === null || !isMotorVehicle(current.vehicle))
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
      const timeZone = (await this.geo.cityTimeZone(current.cityId)) ?? 'UTC';
      const today = cityDay(now, timeZone);
      if (document.issueDate > today) throw new ApplicationRefusedError('issue_date_in_future');
      issueDate = document.issueDate;
      expiresOn = criminalRecordExpiry(
        issueDate,
        await this.settings.get('captain.criminal_record_validity_months', {
          cityId: current.cityId,
        }),
      );
      if (expiresOn <= today) throw new ApplicationRefusedError('document_expired');
    }
    for (const uploadId of document.uploadIds) {
      await this.files.prepare(uploadId, 'captain_document', now, applicant.accountId);
    }
    await this.database.db.transaction(async (tx) => {
      const draft = await this.lockedDraft(tx, applicant.accountId);
      const fileKeys: string[] = [];
      for (const uploadId of document.uploadIds) {
        const { key, alreadyLinked } = await this.files.link(tx, uploadId, now);
        // A file linked before belongs to another document (or to this one
        // in force: sending the same files again changes nothing).
        if (alreadyLinked) {
          const [same] = await tx
            .select({ id: applicationDocuments.id })
            .from(applicationDocuments)
            .where(
              and(
                eq(applicationDocuments.applicationId, draft!.id),
                eq(applicationDocuments.kind, kind),
                isNull(applicationDocuments.replacedAt),
                sql`${key} = ANY(${applicationDocuments.fileKeys})`,
              ),
            );
          if (!same) throw new ApplicationRefusedError('invalid_files');
        }
        fileKeys.push(key);
      }
      await tx
        .update(applicationDocuments)
        .set({ replacedAt: now })
        .where(
          and(
            eq(applicationDocuments.applicationId, draft!.id),
            eq(applicationDocuments.kind, kind),
            isNull(applicationDocuments.replacedAt),
          ),
        );
      await tx.insert(applicationDocuments).values({
        applicationId: draft!.id,
        kind,
        fileKeys,
        number,
        issueDate,
        expiresOn,
        status: 'pending',
        uploadedBy: applicant.accountId,
        createdAt: now,
      });
      await tx.update(applications).set({ updatedAt: now }).where(eq(applications.id, draft!.id));
    });
    return (await this.application(applicant.accountId, now))!;
  }

  // Step 5 «إرسال الطلب»: the draft becomes «جديد» once nothing is missing.
  // A repeat answers the application sent, so it needs no key.
  async submit(applicant: Applicant, now = new Date()): Promise<Application> {
    refuseCaptain(applicant);
    const current = await this.application(applicant.accountId, now);
    if (current === null) throw new ApplicationRefusedError('no_application');
    if (current.stage !== 'draft') return current;
    if (current.missing.length > 0) {
      throw new ApplicationRefusedError('incomplete', current.missing);
    }
    await this.database.db.transaction(async (tx) => {
      const draft = await this.lockedDraft(tx, applicant.accountId);
      // A document saved since the read above was checked by its own save.
      await tx
        .update(applications)
        .set({ stage: 'new', submittedAt: now, updatedAt: now })
        .where(and(eq(applications.id, draft!.id), eq(applications.stage, 'draft')));
    });
    return (await this.application(applicant.accountId, now))!;
  }

  // The account's application not rejected, locked; a draft only. Every
  // save of one account takes turns on its advisory lock, so the first
  // save's insert never races another.
  private async lockedDraft(
    tx: Tx,
    accountId: string,
    options: { orNone?: boolean } = {},
  ): Promise<{ id: string } | null> {
    await tx.execute(
      sql`SELECT pg_advisory_xact_lock(hashtextextended(${`captains.application:${accountId}`}, 0))`,
    );
    const [row] = await tx
      .select({ id: applications.id, stage: applications.stage })
      .from(applications)
      .where(and(eq(applications.accountId, accountId), ne(applications.stage, 'rejected')))
      .for('update');
    if (!row) {
      if (options.orNone) return null;
      throw new ApplicationRefusedError('no_application');
    }
    if (row.stage !== 'draft') throw new ApplicationRefusedError('application_submitted');
    return { id: row.id };
  }

  private async documents(
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

function refuseCaptain(applicant: Applicant): void {
  if (applicant.captain) throw new ApplicationRefusedError('already_captain');
}
