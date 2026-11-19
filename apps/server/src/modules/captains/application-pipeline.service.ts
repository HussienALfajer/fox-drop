import { Inject, Injectable } from '@nestjs/common';
import { and, asc, count, desc, eq, inArray, isNotNull, isNull, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { ContentService } from '../content/index.js';
import { FilesService } from '../files/index.js';
import { GeoService } from '../geo/index.js';
import { LedgerService } from '../ledger/index.js';
import { SettingsService, type Vehicle } from '../settings/index.js';
import { captainUploads } from './captain-documents.js';
import {
  type ActivationMissing,
  activationMissing,
  addDays,
  type ApplicationDocumentKind,
  cityDay,
  commitmentOf,
  type ContractPhase,
  contractDates,
  contractPhase,
  type DepositSettlement,
  depositSettlementOf,
  earlyExit,
  type OffboardingStep,
  offboardingMissing,
  type DocumentState,
  documentStates,
  probationReview,
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
  type KitItem,
} from './schema.js';
import { CaptainsService, type Money, type StatusChanged } from './captains.service.js';

export type PipelineRefusal =
  | 'unknown_application'
  // The action is not taken at the application's stage (`stage`).
  | 'wrong_stage'
  | 'unknown_document'
  // The document reviewed was replaced by a newer upload meanwhile.
  | 'document_replaced'
  | 'document_not_needed'
  | 'already_requested'
  | 'interview_in_past'
  // Slice 2.35a: a kit item not of the list, a size or a count out of
  // bounds; a cash limit at zero; contract dates in the future or upside
  // down; a deposit or instalment out of bounds; «تفعيل» before every
  // condition is met (`missing`).
  | 'invalid_kit'
  | 'invalid_cash_limit'
  | 'not_in_base_currency'
  | 'invalid_contract'
  | 'invalid_deposit'
  | 'activation_incomplete'
  | 'already_confirmed'
  // Slice 2.35a's review: a paid deposit, an accepted document after the
  // activation, a terminated captain's probation.
  | 'deposit_paid'
  | 'document_in_force'
  | 'captain_terminated'
  // Slice 2.35b, the offboarding (AP §9.7.5): «إنهاء التعاقد» once, with a
  // reason; its steps while it is open, in order; «إغلاق الحساب» once every
  // step is done (`steps`) and no order is active; a flagged captain's
  // activation is OWN's (C17).
  | 'reason_required'
  | 'already_terminated'
  | 'not_terminated'
  | 'contract_ended'
  | 'deposit_settled'
  | 'kit_not_checked'
  | 'wrong_settlement'
  | 'offboarding_incomplete'
  | 'active_order'
  | 'owner_approval_required';

export class PipelineRefusedError extends Error {
  constructor(
    readonly refusal: PipelineRefusal,
    readonly stage: ApplicationStage | null = null,
    readonly missing: ActivationMissing[] = [],
    readonly steps: OffboardingStep[] = [],
  ) {
    super(`pipeline refused: ${refusal}`);
  }
}

// The deposit as the review page and the desk show it (AP §9.7.1, §8.5):
// its amount and instalment in the city's base, what is paid (the
// captain.deposit account of the captain to be) and whether «تفعيل» counts it
// recorded: an amount, and either the instalments or all of it paid.
export interface DepositState {
  amount: Money | null;
  instalment: Money | null;
  paid: bigint;
  recorded: boolean;
}

export interface DepositAwaiting {
  applicationId: string;
  fullName: string;
  deposit: DepositState;
  suggested: Money | null;
  // The cash limit FIN sets at the desk (D10), and its suggestion.
  cashLimit: Money | null;
  suggestedCashLimit: Money | null;
}

export interface Contract {
  signedOn: string;
  startsOn: string;
  probationDays: number;
  commitmentMonths: number;
  probationEndsOn: string;
  // The commitment's start and end: as confirmed, or, before the
  // confirmation, as they would be when confirmed on the probation's end
  // (AP §9.7.2).
  commitmentStartsOn: string;
  commitmentEndsOn: string;
  probationConfirmedOn: string | null;
  // Once activated: the phase today, and the probation review's state.
  phase: ContractPhase;
  review: 'none' | 'due' | 'overdue';
}

// A phase reached that the captain was not told of yet (CA §14 #28).
export interface ContractPhaseChange {
  captainId: string;
  cityId: string;
  phase: ContractPhase;
  // The day it started on the city's clock.
  from: string;
  timeZone: string;
}

// CA §12.2: one of a captain's documents as the app shows it.
export interface CaptainDocument {
  kind: ApplicationDocumentKind;
  required: boolean;
  state: DocumentState;
  valid: { issueDate: string | null; expiresOn: string | null; uploadedAt: Date } | null;
  pending: { issueDate: string | null; expiresOn: string | null; uploadedAt: Date } | null;
  rejection: { reason: string; at: Date } | null;
}

// AP §9.1.3 «مستند ينتهي»: a captain's documents expiring or expired.
export interface ExpiringDocuments {
  captainId: string;
  applicationId: string;
  fullName: string;
  timeZone: string;
  documents: {
    documentId: string;
    kind: ApplicationDocumentKind;
    expiresOn: string;
    expired: boolean;
  }[];
}

// A captain whose probation review is due or overdue (AP §9.1.3).
export interface ProbationReview {
  captainId: string;
  applicationId: string;
  fullName: string;
  probationEndsOn: string;
  review: 'due' | 'overdue';
}

// What the activation shows at «بانتظار العدة» (slice 2.35a).
export interface Activation {
  kit: { items: KitItem[]; issuedAt: Date } | null;
  cashLimit: Money | null;
  // `captain.custody_limit_suggested.<vehicle>`, the prefill (D10).
  suggestedCashLimit: Money | null;
  contract: Contract | null;
  deposit: DepositState;
  // `captain.kit_deposit_amount`, the deposit offered.
  suggestedDeposit: Money | null;
  missing: ActivationMissing[];
  captainId: string | null;
  activatedAt: Date | null;
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
  // A contract that ended in «فترة التزام» (C17, slice 2.35b).
  earlyExit: boolean;
}

// AP §9.7.5 (slice 2.35b): the offboarding checklist of a contract being
// ended, or ended.
export interface Offboarding {
  terminatedAt: Date;
  terminatedBy: string | null;
  reason: string;
  earlyExit: boolean;
  // Step 1: null until OPS checked the kit.
  kitReturned: boolean | null;
  // Steps 2 and 3, read from the ledger.
  custodyZero: boolean;
  earningsZero: boolean;
  // Step 4: what the platform still holds of the deposit, and how it was
  // settled at the desk.
  depositHeld: bigint;
  depositSettled: DepositSettlement | null;
  missing: OffboardingStep[];
  // Step 5.
  endedAt: Date | null;
}

// The desk's «التأمينات» row (AP §9.10.3, slice 2.35b).
export interface DepositToSettle {
  applicationId: string;
  captainId: string;
  fullName: string;
  terminatedAt: Date;
  earlyExit: boolean;
  kitReturned: boolean | null;
  held: Money;
}

// A former captain's application (C17): the captain it makes again, and
// whether any of the account's contracts ended early (OWN activates it).
export interface FormerCaptain {
  captainId: string;
  earlyExit: boolean;
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
  activation: Activation;
  offboarding: Offboarding | null;
  formerCaptain: FormerCaptain | null;
}

// What identity answers this module (architecture §4.3: identity imports
// captains, so it registers these at start): the applicants' numbers and
// the admins' names.
export interface PipelineIdentity {
  phones(accountIds: string[]): Promise<Map<string, string>>;
  adminNames(accountIds: string[]): Promise<Map<string, string>>;
  // «تفعيل» (slice 2.35a): the applicant's sign-in account becomes the
  // captain's, in the activation's transaction.
  activate(tx: Tx, accountId: string, captainId: string, cityId: string): Promise<void>;
  // «إغلاق الحساب» (AP §9.7.5 step 5, slice 2.35b): the captain's sessions
  // end and its account is an applicant's again (C17: the same number
  // applies again), in the close's transaction; the answer runs after it
  // commits (the devices are disconnected).
  release(tx: Tx, accountId: string, now: Date): Promise<() => void>;
}

// The bounds of «تسليم العدة» (decided by us).
export const KIT_ITEMS_MAX = 20;
export const KIT_QUANTITY_MAX = 20;
export const KIT_SIZE_MAX = 20;

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
    private readonly settings: SettingsService,
    private readonly content: ContentService,
    private readonly ledger: LedgerService,
    private readonly captains: CaptainsService,
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
      .where(
        and(
          eq(applications.cityId, cityId),
          ne(applications.stage, 'draft'),
          isNull(applications.endedAt),
        ),
      )
      .groupBy(applications.stage);
    const rows = await this.database.db
      .select()
      .from(applications)
      .where(
        and(
          eq(applications.cityId, cityId),
          eq(applications.stage, stage),
          isNull(applications.endedAt),
        ),
      )
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
      activation: await this.activationOf(row, uploads, now),
      offboarding: await this.offboardingOf(row, names),
      formerCaptain: await this.formerCaptainOf(row),
    };
  }

  // What «بانتظار العدة» shows and «تفعيل» checks.
  private async activationOf(
    row: Row,
    uploads: (typeof applicationDocuments.$inferSelect)[],
    now: Date,
    executor: Executor = this.database.db,
  ): Promise<Activation> {
    const timeZone = (await this.geo.cityTimeZone(row.cityId)) ?? 'UTC';
    const deposit = await this.depositOf(row, executor);
    const [suggestedLimit, suggestedDeposit] = await Promise.all([
      row.vehicle === null
        ? null
        : this.settings.get('captain.custody_limit_suggested.<vehicle>', {
            cityId: row.cityId,
            parameter: row.vehicle,
          }),
      this.settings.get('captain.kit_deposit_amount', { cityId: row.cityId }),
    ]);
    return {
      kit: row.kitItems === null ? null : { items: row.kitItems, issuedAt: row.kitIssuedAt! },
      cashLimit:
        row.custodyLimit === null
          ? null
          : { amount: row.custodyLimit, currency: row.custodyLimitCurrency! },
      suggestedCashLimit: moneySetting(suggestedLimit),
      contract: contractOf(row, cityDay(now, timeZone), await this.noticeDays(row.cityId)),
      deposit,
      suggestedDeposit: moneySetting(suggestedDeposit),
      missing:
        row.vehicle === null
          ? []
          : activationMissing({
              vehicle: row.vehicle,
              documents: uploads.filter((upload) => upload.replacedAt === null),
              kitIssued: row.kitItems !== null,
              depositRecorded: deposit.recorded,
              contractRecorded: row.contractSignedOn !== null,
              cashLimitSet: row.custodyLimit !== null,
              today: cityDay(now, timeZone),
            }),
      captainId: row.captainId,
      activatedAt: row.activatedAt,
    };
  }

  private async depositOf(row: Row, executor: Executor): Promise<DepositState> {
    const paid = await this.depositPaid(row, executor);
    const amount =
      row.depositAmount === null
        ? null
        : { amount: row.depositAmount, currency: row.depositCurrency! };
    return {
      amount,
      instalment:
        row.depositInstalment === null
          ? null
          : { amount: row.depositInstalment, currency: row.depositCurrency! },
      paid,
      recorded: amount !== null && (row.depositInstalment !== null || paid >= amount.amount),
    };
  }

  // What the captain to be paid towards the deposit: its captain.deposit
  // account in the city's base (the desk's receipts, slice 2.35a).
  async depositPaid(
    row: { id: string; cityId: string; captainId: string | null; formerCaptainId?: string | null },
    executor: Executor = this.database.db,
  ): Promise<bigint> {
    let paid = 0n;
    for (const account of await this.ledger.ownerAccounts(
      row.cityId,
      captainIdOf(row),
      'captain.deposit',
      executor,
    )) {
      paid += (await this.ledger.balance(account.id, executor)).amount;
    }
    return paid;
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
          earlyExit: applications.earlyExit,
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
      .select({
        id: applications.id,
        fullName: applications.fullName,
        stage: applications.stage,
        earlyExit: applications.earlyExit,
      })
      .from(applications)
      .where(and(eq(applications.accountId, row.accountId), ne(applications.id, row.id)));
    for (const other of sameAccount) found.push(duplicate('phone', other));
    if (row.plate !== null) {
      const key = plateKey(row.plate);
      const others = await this.database.db
        .select({
          id: applications.id,
          fullName: applications.fullName,
          stage: applications.stage,
          earlyExit: applications.earlyExit,
        })
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
          earlyExit: false,
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
      // K6, CA §12.2 (slice 2.35a): an activated captain's accepted document
      // stays valid until it expires; a problem with it is a suspension.
      if (
        row.stage === 'active' &&
        document.status === 'accepted' &&
        review.status === 'rejected'
      ) {
        throw new PipelineRefusedError('document_in_force');
      }
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
    // The signed contract comes with «تسجيل العقد» and its dates.
    if (kind === 'signed_contract') throw new PipelineRefusedError('document_not_needed');
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
      if (request.kind === 'signed_contract') throw new PipelineRefusedError('document_not_needed');
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
      // The deposit paid at the desk has no refund before 2.35b: an
      // application holding it is not rejected (decided by us).
      if ((await this.depositPaid(row, tx)) > 0n) throw new PipelineRefusedError('deposit_paid');
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

  // «تسليم العدة» (AP §9.7.1; owner decision 2026-11-19): the items from
  // the list `kit_item`, each with its size typed and how many. Again
  // before the activation, the kit issued is replaced (a correction).
  async issueKit(
    applicationId: string,
    admin: PipelineAdmin,
    given: { code: string; size: string | null; quantity: number }[],
    now = new Date(),
  ): Promise<void> {
    if (
      given.length === 0 ||
      given.length > KIT_ITEMS_MAX ||
      new Set(given.map((item) => item.code)).size !== given.length
    ) {
      throw new PipelineRefusedError('invalid_kit');
    }
    const items: KitItem[] = [];
    for (const item of given) {
      const size = item.size?.trim() || null;
      if (
        !Number.isInteger(item.quantity) ||
        item.quantity < 1 ||
        item.quantity > KIT_QUANTITY_MAX ||
        (size !== null && size.length > KIT_SIZE_MAX)
      ) {
        throw new PipelineRefusedError('invalid_kit');
      }
      const chosen = await this.content
        .choose('kit_item', { code: item.code, note: null })
        .catch(() => {
          throw new PipelineRefusedError('invalid_kit');
        });
      items.push({ code: chosen.code, label: chosen.label, size, quantity: item.quantity });
    }
    await this.act(applicationId, admin, 'issue_kit', now, async (_tx, row) => {
      if (JSON.stringify(row.kitItems) === JSON.stringify(items)) return null;
      return {
        set: { kitItems: items, kitIssuedAt: now },
        event: { kind: 'kit' },
        audit: 'issue_kit',
        before: { kit: row.kitItems },
        after: { kit: items },
      };
    });
  }

  // The cash limit before activation (D10, AP §9.7.1), in the city's base.
  async setCashLimit(
    applicationId: string,
    admin: PipelineAdmin,
    limit: Money,
    now = new Date(),
  ): Promise<void> {
    if (limit.amount <= 0n || limit.amount > 2n ** 63n - 1n) {
      throw new PipelineRefusedError('invalid_cash_limit');
    }
    await this.act(applicationId, admin, 'set_cash_limit', now, async (tx, row) => {
      if (!(await this.captains.inBaseCurrency(tx, row.cityId, limit.currency))) {
        throw new PipelineRefusedError('not_in_base_currency');
      }
      if (row.custodyLimit === limit.amount && row.custodyLimitCurrency === limit.currency) {
        return null;
      }
      return {
        set: { custodyLimit: limit.amount, custodyLimitCurrency: limit.currency },
        event: { kind: 'cash_limit' },
        audit: 'cash_limit',
        before: {
          cashLimit:
            row.custodyLimit === null ? null : moneyOf(row.custodyLimit, row.custodyLimitCurrency!),
        },
        after: { cashLimit: moneyOf(limit.amount, limit.currency) },
      };
    });
  }

  // «تسجيل العقد» (AP §9.7.2, D24; owner decision 2026-11-19): the signing
  // and start dates with the scan, kept as the document «العقد الموقّع»,
  // accepted as the office uploads it. The probation and commitment lengths
  // are the settings' when it is recorded. Again before the activation, it
  // replaces the contract recorded.
  async recordContract(
    applicationId: string,
    admin: PipelineAdmin,
    contract: { signedOn: string; startsOn: string; document: NewDocument },
    now = new Date(),
  ): Promise<void> {
    const row = await this.row(applicationId);
    const timeZone = (await this.geo.cityTimeZone(row.cityId)) ?? 'UTC';
    if (
      !isDay(contract.signedOn) ||
      !isDay(contract.startsOn) ||
      contract.signedOn > cityDay(now, timeZone) ||
      contract.startsOn < contract.signedOn
    ) {
      throw new PipelineRefusedError('invalid_contract');
    }
    const [probationDays, commitmentMonths] = await Promise.all([
      this.settings.get('captain.probation_days', { cityId: row.cityId }),
      this.settings.get('captain.min_commitment_months', { cityId: row.cityId }),
    ]);
    const checked = await this.applications.checkedDocument(
      row,
      'signed_contract',
      { uploadIds: contract.document.uploadIds },
      admin.actor.id!,
      now,
    );
    const probationEndsOn = addDays(contract.startsOn, probationDays);
    await this.act(applicationId, admin, 'record_contract', now, async (tx, locked) => {
      const stored = await this.applications.storeDocument(
        tx,
        locked,
        'signed_contract',
        checked,
        admin.actor.id!,
        now,
        admin.actor.id!,
      );
      const same =
        locked.contractSignedOn === contract.signedOn &&
        locked.contractStartsOn === contract.startsOn &&
        locked.probationDays === probationDays &&
        locked.commitmentMonths === commitmentMonths;
      if (!stored && same) return null;
      return {
        set: {
          contractSignedOn: contract.signedOn,
          contractStartsOn: contract.startsOn,
          probationDays,
          commitmentMonths,
          probationEndsOn,
        },
        event: { kind: 'contract' },
        audit: 'contract',
        before: {
          contract:
            locked.contractSignedOn === null
              ? null
              : { signedOn: locked.contractSignedOn, startsOn: locked.contractStartsOn },
        },
        after: {
          contract: {
            signedOn: contract.signedOn,
            startsOn: contract.startsOn,
            probationDays,
            commitmentMonths,
            probationEndsOn,
          },
        },
      };
    });
  }

  // The deposit's amount and weekly instalment (AP §9.7.1, §8.5; owner
  // decision 2026-11-19), in the city's base, recorded by the desk in its
  // own transaction with what is paid now. A null instalment means nothing
  // is deducted on Thursdays: the whole amount is paid at the desk.
  async recordDeposit(
    tx: Tx,
    applicationId: string,
    admin: PipelineAdmin,
    deposit: { amount: Money; instalment: bigint | null },
    now: Date,
  ): Promise<void> {
    const { amount, instalment } = deposit;
    if (
      amount.amount < 0n ||
      amount.amount > 2n ** 63n - 1n ||
      (instalment !== null && (instalment <= 0n || instalment > amount.amount))
    ) {
      throw new PipelineRefusedError('invalid_deposit');
    }
    // Read in the desk's transaction, which holds the row (lockForDeposit).
    const [found] = await tx
      .select({ cityId: applications.cityId })
      .from(applications)
      .where(eq(applications.id, applicationId));
    if (!found) throw new PipelineRefusedError('unknown_application');
    const timeZone = (await this.geo.cityTimeZone(found.cityId, tx)) ?? 'UTC';
    await this.actIn(
      tx,
      applicationId,
      admin,
      'record_deposit',
      now,
      timeZone,
      async (_tx, row) => {
        if (
          row.depositAmount === amount.amount &&
          row.depositCurrency === amount.currency &&
          row.depositInstalment === instalment
        ) {
          return null;
        }
        return {
          set: {
            depositAmount: amount.amount,
            depositCurrency: amount.currency,
            depositInstalment: instalment,
          },
          event: { kind: 'deposit' },
          audit: 'deposit',
          before: {
            deposit:
              row.depositAmount === null
                ? null
                : {
                    amount: moneyOf(row.depositAmount, row.depositCurrency!),
                    instalment: row.depositInstalment?.toString() ?? null,
                  },
          },
          after: {
            deposit: {
              amount: moneyOf(amount.amount, amount.currency),
              instalment: instalment?.toString() ?? null,
            },
          },
        };
      },
    );
  }

  // The desk's read of the application whose deposit it records, locked in
  // its transaction: at «بانتظار العدة» only.
  async lockForDeposit(
    tx: Tx,
    applicationId: string,
  ): Promise<{
    id: string;
    accountId: string;
    cityId: string;
    fullName: string;
    captainId: string;
    stage: ApplicationStage;
  }> {
    const [row] = await tx
      .select()
      .from(applications)
      .where(eq(applications.id, applicationId))
      .for('update');
    if (!row || row.stage === 'draft') throw new PipelineRefusedError('unknown_application');
    if (pipelineSteps('record_deposit', row.stage) === null) {
      throw new PipelineRefusedError('wrong_stage', row.stage);
    }
    return {
      id: row.id,
      accountId: row.accountId,
      cityId: row.cityId,
      fullName: row.fullName,
      captainId: captainIdOf(row),
      stage: row.stage,
    };
  }

  // AP §8.5.5 step 2 (slice 2.35a): the deposit of the captain's latest
  // activated application, with what is paid, for the Thursday instalment;
  // null when it has none.
  async captainDeposit(captainId: string, executor: Executor): Promise<DepositState | null> {
    const [row] = await executor
      .select()
      .from(applications)
      .where(eq(applications.captainId, captainId))
      .orderBy(desc(applications.activatedAt))
      .limit(1);
    // No instalment is taken once the contract is being ended (slice
    // 2.35b, decided by us): the deposit is settled at the desk.
    return row && row.terminatedAt === null ? this.depositOf(row, executor) : null;
  }

  // The desk's tab (slice 2.35a): the city's applications at «بانتظار
  // العدة», oldest sent first, with their deposit and the amount offered.
  async depositsAwaiting(cityId: string): Promise<DepositAwaiting[]> {
    const rows = await this.database.db
      .select()
      .from(applications)
      .where(and(eq(applications.cityId, cityId), eq(applications.stage, 'awaiting_kit')))
      .orderBy(asc(applications.submittedAt), asc(applications.id));
    const suggested = moneySetting(
      await this.settings.get('captain.kit_deposit_amount', { cityId }),
    );
    const found: DepositAwaiting[] = [];
    for (const row of rows) {
      found.push({
        applicationId: row.id,
        fullName: row.fullName,
        deposit: await this.depositOf(row, this.database.db),
        suggested,
        cashLimit:
          row.custodyLimit === null
            ? null
            : { amount: row.custodyLimit, currency: row.custodyLimitCurrency! },
        suggestedCashLimit:
          row.vehicle === null
            ? null
            : moneySetting(
                await this.settings.get('captain.custody_limit_suggested.<vehicle>', {
                  cityId,
                  parameter: row.vehicle,
                }),
              ),
      });
    }
    return found;
  }

  // «تفعيل» (AP §9.7.1, CA §5.5): once every condition is met, the
  // application becomes a captain whose id is the application's, with its
  // name, vehicle, plate and cash limit; the applicant's sign-in account
  // becomes the captain's. «مفعّل» tells the applicant (CA §5.4).
  // A former captain's application makes that captain again (C17, slice
  // 2.35b), with its id, ledger accounts and history; when any of the
  // account's contracts ended early, only OWN activates it
  // (`ownerApproval`: `captains.activate_early_exit`).
  async activate(
    applicationId: string,
    admin: PipelineAdmin,
    now = new Date(),
    ownerApproval = false,
  ): Promise<string> {
    const { cityId } = await this.row(applicationId);
    const timeZone = (await this.geo.cityTimeZone(cityId)) ?? 'UTC';
    let captainId = '';
    await this.act(applicationId, admin, 'activate', now, async (tx, row) => {
      const uploads = await tx
        .select()
        .from(applicationDocuments)
        .where(
          and(
            eq(applicationDocuments.applicationId, row.id),
            isNull(applicationDocuments.replacedAt),
          ),
        );
      const deposit = await this.depositOf(row, tx);
      const missing = activationMissing({
        vehicle: row.vehicle!,
        documents: uploads,
        kitIssued: row.kitItems !== null,
        depositRecorded: deposit.recorded,
        contractRecorded: row.contractSignedOn !== null,
        cashLimitSet: row.custodyLimit !== null,
        today: cityDay(now, timeZone),
      });
      if (missing.length > 0) {
        throw new PipelineRefusedError('activation_incomplete', row.stage, missing);
      }
      if (!(await this.captains.inBaseCurrency(tx, row.cityId, row.custodyLimitCurrency!))) {
        throw new PipelineRefusedError('not_in_base_currency');
      }
      captainId = captainIdOf(row);
      const record = {
        cityId: row.cityId,
        name: row.fullName,
        vehicle: row.vehicle!,
        plateNumber: row.plate,
        custodyLimit: row.custodyLimit!,
        custodyLimitCurrency: row.custodyLimitCurrency!,
      };
      // C17: a person flagged «خروج مبكر» (by the account or the ID's
      // number, so a new number changes nothing) is OWN's to activate.
      if (!ownerApproval && (await this.flagged(tx, row))) {
        throw new PipelineRefusedError('owner_approval_required');
      }
      if (row.formerCaptainId === null) {
        await tx.insert(captainRecords).values({ id: captainId, ...record });
      } else {
        const rehired = await tx
          .update(captainRecords)
          .set({
            ...record,
            status: 'active',
            suspensionReason: null,
            suspendedUntil: null,
            updatedAt: sql`now()`,
          })
          .where(and(eq(captainRecords.id, captainId), eq(captainRecords.status, 'terminated')))
          .returning({ id: captainRecords.id });
        if (rehired.length !== 1) throw new PipelineRefusedError('captain_terminated');
      }
      await this.lookups().activate(tx, row.accountId, captainId, row.cityId);
      await this.audit.recordWrite(
        {
          actor: admin.actor,
          context: admin.context,
          cityId: row.cityId,
          action: row.formerCaptainId === null ? 'captain.create' : 'captain.rehire',
          target: { type: 'captain', id: captainId },
          before: row.formerCaptainId === null ? null : { status: 'terminated' },
          after: {
            name: row.fullName,
            vehicle: row.vehicle,
            plateNumber: row.plate,
            custodyLimit: moneyOf(row.custodyLimit!, row.custodyLimitCurrency!),
            applicationId: row.id,
          },
        },
        tx,
      );
      return {
        set: { captainId, activatedAt: now, phaseNotified: 'probation' },
        audit: 'activate',
        after: { captainId },
      };
    });
    return captainId;
  }

  // AP §9.7.2: OPS confirms the probation; the commitment starts on its end,
  // or on this day once it has passed (`commitmentOf`). Once only
  // (`409 already_confirmed`).
  async confirmProbation(
    applicationId: string,
    admin: PipelineAdmin,
    now = new Date(),
  ): Promise<void> {
    const { cityId } = await this.row(applicationId);
    const timeZone = (await this.geo.cityTimeZone(cityId)) ?? 'UTC';
    const today = cityDay(now, timeZone);
    await this.act(applicationId, admin, 'confirm_probation', now, async (tx, row) => {
      if (row.probationConfirmedOn !== null) throw new PipelineRefusedError('already_confirmed');
      if (row.terminatedAt !== null) throw new PipelineRefusedError('already_terminated');
      const [captain] = await tx
        .select({ status: captainRecords.status })
        .from(captainRecords)
        .where(eq(captainRecords.id, row.captainId!));
      if (captain?.status === 'terminated') throw new PipelineRefusedError('captain_terminated');
      const commitment = commitmentOf({
        probationEndsOn: row.probationEndsOn!,
        confirmedOn: today,
        months: row.commitmentMonths!,
      });
      return {
        set: {
          probationConfirmedOn: today,
          probationConfirmedBy: admin.actor.id!,
          commitmentStartsOn: commitment.startsOn,
          commitmentEndsOn: commitment.endsOn,
        },
        event: { kind: 'probation_confirmed' },
        audit: 'probation_confirmed',
        after: { commitmentStartsOn: commitment.startsOn, commitmentEndsOn: commitment.endsOn },
      };
    });
  }

  // CA §14 #28, AP §9.7.2 (the worker's, every minute): each activated
  // captain of the city whose phase today is not the one they were told of
  // is told once, in a transaction of its own under the application's lock
  // (`notify`: the push). Commitment to open-ended happens so on its day.
  async sweepContractPhases(
    cityId: string,
    now: Date,
    notify: (tx: Tx, change: ContractPhaseChange) => Promise<void>,
  ): Promise<number> {
    const timeZone = (await this.geo.cityTimeZone(cityId)) ?? 'UTC';
    const today = cityDay(now, timeZone);
    const rows = await this.activeContracts(cityId);
    let told = 0;
    for (const candidate of rows) {
      if (contractPhase(candidate, today) === candidate.phaseNotified) continue;
      await this.database.db.transaction(async (tx) => {
        const [row] = await tx
          .select()
          .from(applications)
          .where(eq(applications.id, candidate.id))
          .for('update');
        if (!row || row.captainId === null) return;
        const phase = contractPhase(row, today);
        if (phase === row.phaseNotified) return;
        await tx
          .update(applications)
          .set({ phaseNotified: phase, updatedAt: now })
          .where(eq(applications.id, row.id));
        await notify(tx, {
          captainId: row.captainId,
          cityId: row.cityId,
          phase,
          from:
            phase === 'probation'
              ? row.contractStartsOn!
              : phase === 'commitment'
                ? row.commitmentStartsOn!
                : row.commitmentEndsOn!,
          timeZone,
        });
        told += 1;
      });
    }
    return told;
  }

  // AP §9.1.3 «نهاية فترة تجربة» (the worker's alerts sweep): the city's
  // captains whose probation review is due or overdue.
  async probationReviews(cityId: string, now: Date): Promise<ProbationReview[]> {
    const timeZone = (await this.geo.cityTimeZone(cityId)) ?? 'UTC';
    const today = cityDay(now, timeZone);
    const noticeDays = await this.noticeDays(cityId);
    const found: ProbationReview[] = [];
    for (const row of await this.activeContracts(cityId)) {
      const review = probationReview({
        probationEndsOn: row.probationEndsOn!,
        noticeDays,
        confirmed: row.probationConfirmedOn !== null,
        today,
      });
      if (review === 'none') continue;
      found.push({
        captainId: row.captainId!,
        applicationId: row.id,
        fullName: row.fullName,
        probationEndsOn: row.probationEndsOn!,
        review,
      });
    }
    return found;
  }

  // CA §12.3–12.4: the captain's own contract, kit and deposit, from its
  // latest activated application; null for a captain the seed made. The
  // contract's scan waits for a signed GET on the API's host (nginx serves
  // private-docs reads on the panel's only).
  async captainContract(
    captainId: string,
    now: Date,
  ): Promise<{
    contract: Contract | null;
    kit: { items: KitItem[]; issuedAt: Date } | null;
    deposit: DepositState;
  } | null> {
    const [row] = await this.database.db
      .select()
      .from(applications)
      .where(eq(applications.captainId, captainId))
      .orderBy(desc(applications.activatedAt))
      .limit(1);
    if (!row) return null;
    const timeZone = (await this.geo.cityTimeZone(row.cityId)) ?? 'UTC';
    return {
      contract: contractOf(row, cityDay(now, timeZone), await this.noticeDays(row.cityId)),
      kit: row.kitItems === null ? null : { items: row.kitItems, issuedAt: row.kitIssuedAt! },
      deposit: await this.depositOf(row, this.database.db),
    };
  }

  // AP §9.7.4 «سجل التغييرات» (slice 2.36a): every application that became
  // this captain, a rehire's included.
  async applicationIds(captainId: string): Promise<string[]> {
    const rows = await this.database.db
      .select({ id: applications.id })
      .from(applications)
      .where(eq(applications.captainId, captainId));
    return rows.map((row) => row.id);
  }

  // AP §9.7.3 (slice 2.36a): each activated captain of the city's file, its
  // latest activated application (the page holding the contract, kit,
  // deposit, documents and the offboarding) and the contract's phase now
  // (null before the contract is recorded and once it ended). A captain the seed made has none.
  async captainFiles(
    cityId: string,
    now: Date,
  ): Promise<Map<string, { applicationId: string; phase: ContractPhase | null }>> {
    const rows = await this.database.db
      .selectDistinctOn([applications.captainId])
      .from(applications)
      .where(and(eq(applications.cityId, cityId), isNotNull(applications.captainId)))
      .orderBy(applications.captainId, sql`${applications.activatedAt} DESC NULLS LAST`);
    const today = cityDay(now, (await this.geo.cityTimeZone(cityId)) ?? 'UTC');
    return new Map(
      rows.map((row) => [
        row.captainId!,
        {
          applicationId: row.id,
          // An ended contract has no phase (AP §9.7.5 step 5).
          phase:
            row.contractSignedOn === null || row.endedAt !== null
              ? null
              : contractPhase(row, today),
        },
      ]),
    );
  }

  // CA §12.2 (slice 2.35a): the captain's documents by kind, the required
  // ones and any other uploaded (the driving licence), each with the one in
  // force, a replacement waiting and its state; the latest rejection's
  // reason while no newer upload replaced it.
  async captainDocuments(captainId: string, now: Date): Promise<CaptainDocument[]> {
    const found = await captainUploads(this.database.db, captainId);
    if (found === null) return [];
    const { application, uploads } = found;
    const timeZone = (await this.geo.cityTimeZone(application.cityId)) ?? 'UTC';
    const notice = await this.settings.get('captain.document_expiry_notice_days', {
      cityId: application.cityId,
    });
    const states = documentStates(uploads, cityDay(now, timeZone), notice);
    const required = requiredDocuments(application.vehicle);
    const kinds = [
      ...required,
      ...[...states.keys()].filter(
        (kind) => !required.includes(kind) && kind !== 'signed_contract',
      ),
    ];
    return kinds.map((kind) => {
      const state = states.get(kind);
      const newest = uploads.find((upload) => upload.kind === kind) ?? null;
      const view = (upload: (typeof uploads)[number] | null | undefined) =>
        upload
          ? {
              issueDate: upload.issueDate,
              expiresOn: upload.expiresOn,
              uploadedAt: upload.createdAt,
            }
          : null;
      return {
        kind,
        required: required.includes(kind),
        state: state?.state ?? 'missing',
        valid: view(state?.valid),
        pending: view(state?.pending),
        rejection:
          newest !== null && newest.status === 'rejected'
            ? { reason: newest.reason ?? '', at: newest.reviewedAt ?? newest.createdAt }
            : null,
      };
    });
  }

  // «رفع نسخة جديدة» (CA §12.2): the captain's replacement waits for OPS's
  // review; the one in force stays valid until it expires. Not the signed
  // contract (the office's).
  async replaceDocument(
    captain: { captainId: string; accountId: string },
    kind: ApplicationDocumentKind,
    document: NewDocument,
    now = new Date(),
  ): Promise<void> {
    if (kind === 'signed_contract') throw new PipelineRefusedError('document_not_needed');
    const found = await captainUploads(this.database.db, captain.captainId);
    if (found === null) throw new PipelineRefusedError('unknown_application');
    const checked = await this.applications.checkedDocument(
      found.application,
      kind,
      document,
      captain.accountId,
      now,
    );
    const timeZone = (await this.geo.cityTimeZone(found.application.cityId)) ?? 'UTC';
    await this.actIn(
      undefined,
      found.application.id,
      { actor: { type: 'captain', id: captain.captainId, role: null }, context: NO_CONTEXT },
      'upload_document',
      now,
      timeZone,
      async (tx, locked) => {
        if (
          !(await this.applications.storeDocument(
            tx,
            locked,
            kind,
            checked,
            captain.accountId,
            now,
          ))
        ) {
          return null;
        }
        return {
          event: { kind: 'document_upload', documentKind: kind },
          audit: 'document_upload',
          after: { kind },
        };
      },
    );
  }

  // AP §9.1.3 «مستند ينتهي», CA §12.2 (the worker's): the city's activated
  // captains with a document in force expiring within
  // `captain.document_expiry_notice_days` or expired, not replaced by an
  // accepted one.
  async expiringDocuments(cityId: string, now: Date): Promise<ExpiringDocuments[]> {
    const timeZone = (await this.geo.cityTimeZone(cityId)) ?? 'UTC';
    const today = cityDay(now, timeZone);
    const notice = await this.settings.get('captain.document_expiry_notice_days', { cityId });
    const found: ExpiringDocuments[] = [];
    for (const row of await this.activeContracts(cityId)) {
      const uploads = await this.database.db
        .select()
        .from(applicationDocuments)
        .where(eq(applicationDocuments.applicationId, row.id));
      const documents = [...documentStates(uploads, today, notice)]
        .filter(([kind, each]) => kind !== 'signed_contract' && each.valid !== null)
        .filter(([, each]) => each.state === 'expiring' || each.state === 'expired')
        .map(([kind, each]) => ({
          documentId: each.valid!.id,
          kind,
          expiresOn: each.valid!.expiresOn!,
          expired: each.state === 'expired',
        }));
      if (documents.length === 0) continue;
      found.push({
        captainId: row.captainId!,
        applicationId: row.id,
        fullName: row.fullName,
        timeZone,
        documents,
      });
    }
    return found;
  }

  // The activated applications of a city whose captain is not terminated.
  // «إنهاء التعاقد» (AP §9.7.5, §9.7.2, C17; slice 2.35b): OPS or OWN end an
  // activated captain's contract with a reason, at the probation review or
  // any time after. The captain is suspended until further notice with that
  // reason (offline at once, or in last-order mode during an order), so its
  // custody and earnings stop moving while the checklist runs and the app
  // still shows them (decided by us). Ended in «فترة التزام», the contract
  // flags «خروج مبكر».
  async terminate(
    applicationId: string,
    admin: PipelineAdmin,
    reason: string,
    now = new Date(),
  ): Promise<void> {
    const trimmed = reason.trim();
    if (trimmed === '') throw new PipelineRefusedError('reason_required');
    const { cityId } = await this.row(applicationId);
    const timeZone = (await this.geo.cityTimeZone(cityId)) ?? 'UTC';
    let changed: StatusChanged | null = null;
    let captainId = '';
    await this.act(applicationId, admin, 'terminate', now, async (tx, row) => {
      if (row.terminatedAt !== null) throw new PipelineRefusedError('already_terminated');
      captainId = row.captainId!;
      const [captain] = await tx
        .select({ status: captainRecords.status })
        .from(captainRecords)
        .where(eq(captainRecords.id, captainId));
      if (captain?.status === 'terminated') throw new PipelineRefusedError('captain_terminated');
      const early = earlyExit(row, cityDay(now, timeZone));
      changed = await this.captains.setStatusIn(
        tx,
        captainId,
        'suspended',
        { actor: admin.actor, context: admin.context, reason: trimmed, until: null },
        now,
      );
      return {
        set: {
          terminatedAt: now,
          terminatedBy: admin.actor.id!,
          terminationReason: trimmed,
          earlyExit: early,
        },
        event: { kind: 'terminated', note: trimmed },
        audit: 'terminate',
        after: { earlyExit: early },
        reason: trimmed,
      };
    });
    if (changed !== null) await this.captains.afterStatus(captainId, changed, now);
  }

  // The checklist's step 1 (OPS, OWN): the kit came back in good condition
  // or not. Changed until the deposit is settled by it.
  async recordKitReturn(
    applicationId: string,
    admin: PipelineAdmin,
    returned: boolean,
    now = new Date(),
  ): Promise<void> {
    await this.act(applicationId, admin, 'return_kit', now, async (_tx, row) => {
      openOffboarding(row);
      if (row.depositSettled !== null) throw new PipelineRefusedError('deposit_settled');
      if (row.kitReturned === returned) return null;
      return {
        set: { kitReturned: returned, kitCheckedAt: now },
        event: { kind: 'kit_returned' },
        audit: 'kit_return',
        before: { kitReturned: row.kitReturned },
        after: { kitReturned: returned },
      };
    });
  }

  // The desk's read of a contract whose deposit it settles (AP §9.7.5 step
  // 4, §9.10.3 «التأمينات»), locked in its transaction: being ended, the kit
  // checked, not settled yet.
  async lockForSettlement(
    tx: Tx,
    applicationId: string,
  ): Promise<{
    id: string;
    accountId: string;
    cityId: string;
    fullName: string;
    captainId: string;
    settlement: DepositSettlement;
    held: bigint;
  }> {
    const [row] = await tx
      .select()
      .from(applications)
      .where(eq(applications.id, applicationId))
      .for('update');
    if (!row || row.stage === 'draft') throw new PipelineRefusedError('unknown_application');
    openOffboarding(row);
    if (row.depositSettled !== null) throw new PipelineRefusedError('deposit_settled');
    if (row.kitReturned === null) throw new PipelineRefusedError('kit_not_checked');
    return {
      id: row.id,
      accountId: row.accountId,
      cityId: row.cityId,
      fullName: row.fullName,
      captainId: row.captainId!,
      settlement: depositSettlementOf(row.kitReturned),
      held: await this.depositPaid(row, tx),
    };
  }

  // Step 4 recorded in the desk's transaction, once its journal is posted.
  async recordSettlement(
    tx: Tx,
    applicationId: string,
    admin: PipelineAdmin,
    settlement: DepositSettlement,
    amount: Money,
    now: Date,
  ): Promise<void> {
    const timeZone = (await this.geo.cityTimeZone((await this.row(applicationId)).cityId)) ?? 'UTC';
    await this.actIn(tx, applicationId, admin, 'settle_deposit', now, timeZone, async () => ({
      set: { depositSettled: settlement, depositSettledAt: now },
      event: { kind: 'deposit_settled' },
      audit: `deposit_${settlement}`,
      after: { amount: amount.amount.toString(), currency: amount.currency },
    }));
  }

  // The desk's «التأمينات» (AP §9.10.3): the city's contracts being ended
  // whose deposit is still held, the earliest ended first, with the kit's
  // step (null until OPS checked it).
  async depositsToSettle(cityId: string): Promise<DepositToSettle[]> {
    const rows = await this.database.db
      .select()
      .from(applications)
      .where(
        and(
          eq(applications.cityId, cityId),
          isNotNull(applications.terminatedAt),
          isNull(applications.endedAt),
          isNull(applications.depositSettled),
        ),
      )
      .orderBy(asc(applications.terminatedAt), asc(applications.id));
    const found: DepositToSettle[] = [];
    for (const row of rows) {
      const held = await this.depositPaid(row);
      if (held === 0n) continue;
      found.push({
        applicationId: row.id,
        captainId: row.captainId!,
        fullName: row.fullName,
        terminatedAt: row.terminatedAt!,
        earlyExit: row.earlyExit!,
        kitReturned: row.kitReturned,
        held: { amount: held, currency: row.depositCurrency! },
      });
    }
    return found;
  }

  // «إغلاق الحساب» (AP §9.7.5 step 5): once the kit is checked, the custody
  // is zero in every currency, the earnings are settled and the deposit is
  // refunded or withheld, and no order is active, the captain is
  // terminated (it can no longer go online), its sessions end and its
  // sign-in account is an applicant's again, so the same number applies
  // again (C17).
  async close(applicationId: string, admin: PipelineAdmin, now = new Date()): Promise<void> {
    let changed: StatusChanged | null = null;
    let captainId = '';
    let released: (() => void) | null = null;
    await this.act(applicationId, admin, 'close', now, async (tx, row) => {
      openOffboarding(row);
      captainId = row.captainId!;
      // The captain's row first, as the desk and the manual entries lock it
      // before they move its custody or earnings, so the balances read here
      // stay as read until the commit.
      await tx
        .select({ id: captainRecords.id })
        .from(captainRecords)
        .where(eq(captainRecords.id, captainId))
        .for('update');
      const state = await this.offboardingState(row, tx);
      if (state.missing.length > 0) {
        throw new PipelineRefusedError('offboarding_incomplete', null, [], state.missing);
      }
      if (await this.captains.hasActiveOrder(captainId, tx)) {
        throw new PipelineRefusedError('active_order');
      }
      changed = await this.captains.setStatusIn(
        tx,
        captainId,
        'terminated',
        { actor: admin.actor, context: admin.context, reason: row.terminationReason! },
        now,
      );
      released = await this.lookups().release(tx, row.accountId, now);
      return {
        set: { endedAt: now },
        event: { kind: 'contract_ended' },
        audit: 'close',
        after: { captainId },
      };
    });
    (released as (() => void) | null)?.();
    if (changed !== null) await this.captains.afterStatus(captainId, changed, now);
  }

  private async offboardingOf(row: Row, names: Map<string, string>): Promise<Offboarding | null> {
    if (row.terminatedAt === null) return null;
    // Once closed every step was done: the captain's accounts may belong to
    // a later contract since (a rehire).
    const state =
      row.endedAt === null
        ? await this.offboardingState(row, this.database.db)
        : { custodyZero: true, earningsZero: true, depositHeld: 0n, missing: [] };
    return {
      terminatedAt: row.terminatedAt,
      terminatedBy: names.get(row.terminatedBy!) ?? null,
      reason: row.terminationReason!,
      earlyExit: row.earlyExit!,
      kitReturned: row.kitReturned,
      custodyZero: state.custodyZero,
      earningsZero: state.earningsZero,
      depositHeld: state.depositHeld,
      depositSettled: row.depositSettled,
      missing: row.endedAt === null ? state.missing : [],
      endedAt: row.endedAt,
    };
  }

  // Steps 2 to 4 read from the ledger: every custody and earnings balance of
  // the captain at zero, and what the platform holds of the deposit.
  private async offboardingState(
    row: Row,
    executor: Executor,
  ): Promise<{
    custodyZero: boolean;
    earningsZero: boolean;
    depositHeld: bigint;
    missing: OffboardingStep[];
  }> {
    const zero = async (purpose: 'captain.custody' | 'captain.earnings') => {
      for (const account of await this.ledger.ownerAccounts(
        row.cityId,
        row.captainId!,
        purpose,
        executor,
      )) {
        if ((await this.ledger.balance(account.id, executor)).amount !== 0n) return false;
      }
      return true;
    };
    const custodyZero = await zero('captain.custody');
    const earningsZero = await zero('captain.earnings');
    const depositHeld = await this.depositPaid(row, executor);
    return {
      custodyZero,
      earningsZero,
      depositHeld,
      missing: offboardingMissing({
        kitReturned: row.kitReturned,
        custodyZero,
        earningsZero,
        depositHeld,
      }),
    };
  }

  // C17: a former captain applying again; flagged when any contract of the
  // account ended early.
  private async formerCaptainOf(row: Row): Promise<FormerCaptain | null> {
    if (row.formerCaptainId === null) return null;
    return {
      captainId: row.formerCaptainId,
      earlyExit: await this.flagged(this.database.db, row),
    };
  }

  // Any contract of the same account, or of an application with the same ID
  // number as this one's, ended early (C17: the flag is the person's).
  private async flagged(
    executor: Executor,
    row: { id: string; accountId: string },
  ): Promise<boolean> {
    const [byAccount] = await executor
      .select({ id: applications.id })
      .from(applications)
      .where(and(eq(applications.accountId, row.accountId), eq(applications.earlyExit, true)))
      .limit(1);
    if (byAccount) return true;
    const numbers = await executor
      .select({ number: applicationDocuments.number })
      .from(applicationDocuments)
      .where(
        and(
          eq(applicationDocuments.applicationId, row.id),
          eq(applicationDocuments.kind, 'national_id'),
          isNotNull(applicationDocuments.number),
        ),
      );
    const values = [...new Set(numbers.map((each) => each.number!))];
    if (values.length === 0) return false;
    const [byNumber] = await executor
      .select({ id: applications.id })
      .from(applicationDocuments)
      .innerJoin(applications, eq(applications.id, applicationDocuments.applicationId))
      .where(
        and(
          inArray(applicationDocuments.number, values),
          eq(applicationDocuments.kind, 'national_id'),
          eq(applications.earlyExit, true),
        ),
      )
      .limit(1);
    return byNumber !== undefined;
  }

  private async activeContracts(cityId: string): Promise<Row[]> {
    return this.database.db
      .select({ application: applications })
      .from(applications)
      .innerJoin(captainRecords, eq(captainRecords.id, applications.captainId))
      .where(
        and(
          eq(applications.cityId, cityId),
          eq(applications.stage, 'active'),
          isNull(applications.terminatedAt),
          ne(captainRecords.status, 'terminated'),
        ),
      )
      .then((rows) => rows.map((each) => each.application));
  }

  private noticeDays(cityId: string): Promise<number> {
    return this.settings.get('captain.probation_review_notice_days', { cityId });
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
    await this.database.db.transaction((tx) =>
      this.actIn(tx, applicationId, admin, action, now, timeZone, work),
    );
  }

  private async actIn(
    given: Tx | undefined,
    applicationId: string,
    admin: PipelineAdmin,
    action: PipelineAction,
    now: Date,
    timeZone: string,
    work: (tx: Tx, row: Row) => Promise<Outcome | null>,
  ): Promise<void> {
    if (given === undefined) {
      return this.database.db.transaction((tx) =>
        this.actIn(tx, applicationId, admin, action, now, timeZone, work),
      );
    }
    const tx = given;
    {
      const [row] = await tx
        .select()
        .from(applications)
        .where(eq(applications.id, applicationId))
        .for('update');
      if (!row || row.stage === 'draft') throw new PipelineRefusedError('unknown_application');
      const steps = pipelineSteps(action, row.stage);
      if (steps === null) throw new PipelineRefusedError('wrong_stage', row.stage);
      // An ended contract is history (slice 2.35b).
      if (row.endedAt !== null) throw new PipelineRefusedError('contract_ended');
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
            actorId: eventActorOf(admin),
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
            actorId: eventActorOf(admin),
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
    }
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

type Executor = Pick<Database['db'], 'select' | 'insert'>;

// The history names an admin; a captain's own upload is the applicant's
// (null), as before the activation.
function eventActorOf(admin: PipelineAdmin): string | null {
  return admin.actor.type === 'admin' ? admin.actor.id : null;
}

const NO_CONTEXT = { ipAddress: null, device: null };

// The offboarding's steps are taken while the contract is being ended.
function openOffboarding(row: Row): void {
  if (row.terminatedAt === null) throw new PipelineRefusedError('not_terminated');
  if (row.endedAt !== null) throw new PipelineRefusedError('contract_ended');
}

// The captain an application makes: its own id for a new captain, the
// former captain's for one applying again (C17, slice 2.35b).
function captainIdOf(row: {
  id: string;
  captainId: string | null;
  formerCaptainId?: string | null;
}): string {
  return row.captainId ?? row.formerCaptainId ?? row.id;
}

function contractOf(row: Row, today: string, noticeDays: number): Contract | null {
  if (row.contractSignedOn === null) return null;
  const expected = contractDates({
    startsOn: row.contractStartsOn!,
    probationDays: row.probationDays!,
    commitmentMonths: row.commitmentMonths!,
  });
  return {
    signedOn: row.contractSignedOn,
    startsOn: row.contractStartsOn!,
    probationDays: row.probationDays!,
    commitmentMonths: row.commitmentMonths!,
    probationEndsOn: row.probationEndsOn!,
    commitmentStartsOn: row.commitmentStartsOn ?? expected.probationEndsOn,
    commitmentEndsOn: row.commitmentEndsOn ?? expected.commitmentEndsOn,
    probationConfirmedOn: row.probationConfirmedOn,
    phase: contractPhase(row, today),
    review:
      row.activatedAt === null
        ? 'none'
        : probationReview({
            probationEndsOn: row.probationEndsOn!,
            noticeDays,
            confirmed: row.probationConfirmedOn !== null,
            today,
          }),
  };
}

function isDay(value: string): boolean {
  return /^\d{4}-\d{2}-\d{2}$/u.test(value) && !Number.isNaN(Date.parse(`${value}T00:00:00Z`));
}

function moneyOf(amount: bigint, currency: string) {
  return { amount: amount.toString(), currency };
}

function moneySetting(
  value: { amountMinor: number; currency: string | null } | null,
): Money | null {
  return value === null || value.currency === null
    ? null
    : { amount: BigInt(value.amountMinor), currency: value.currency };
}

function duplicate(
  field: Duplicate['field'],
  other: { id: string; fullName: string; stage: ApplicationStage; earlyExit: boolean | null },
): Duplicate {
  return {
    field,
    applicationId: other.id,
    captainId: null,
    fullName: other.fullName,
    stage: other.stage,
    earlyExit: other.earlyExit === true,
  };
}
