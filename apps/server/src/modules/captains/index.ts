import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditModule } from '../audit/index.js';
import { ContentModule } from '../content/index.js';
import { FilesModule } from '../files/index.js';
import { FxModule } from '../fx/index.js';
import { GeoModule } from '../geo/index.js';
import { LedgerModule } from '../ledger/index.js';
import { SettingsModule } from '../settings/index.js';
import { ValkeyModule } from '../../valkey/valkey.module.js';
import { AdminCaptainApplicationsController } from './admin-captain-applications.controller.js';
import { AdminCaptainsController } from './admin-captains.controller.js';
import { ApplicationPipelineService } from './application-pipeline.service.js';
import { AdminPeakBonusController } from './admin-peak-bonus.controller.js';
import { ApplicationsService } from './applications.service.js';
import { CaptainApplicationController } from './captain-application.controller.js';
import { CaptainAvailabilityController } from './captain-availability.controller.js';
import { CaptainNotesService } from './captain-notes.service.js';
import { CaptainContractController } from './captain-contract.controller.js';
import { CaptainDocumentsController } from './captain-documents.controller.js';
import { CaptainPeakBonusController } from './captain-peak-bonus.controller.js';
import { CaptainsService } from './captains.service.js';
import { LivePositions } from './live-positions.js';
import { LocationPartitions } from './location-partitions.js';
import { PeakBonusService } from './peak-bonus.service.js';
import { ViolationsService } from './violations.service.js';

// The captains module (architecture §4.2): the applications (slices 2.34a,
// 2.34b), the captain record, its cash
// limit, availability and location, and the city's pay table and peak
// bonus. Other modules read them through CaptainsService and PeakBonusService
// only.
@Module({
  imports: [
    DatabaseModule,
    ValkeyModule,
    SettingsModule,
    FxModule,
    GeoModule,
    LedgerModule,
    AuditModule,
    ContentModule,
    FilesModule,
  ],
  controllers: [
    CaptainApplicationController,
    CaptainAvailabilityController,
    CaptainPeakBonusController,
    CaptainContractController,
    CaptainDocumentsController,
    AdminCaptainsController,
    AdminCaptainApplicationsController,
    AdminPeakBonusController,
  ],
  providers: [
    CaptainsService,
    PeakBonusService,
    LivePositions,
    ApplicationsService,
    ApplicationPipelineService,
    CaptainNotesService,
    ViolationsService,
  ],
  // ApplicationsService for notifications' listener, the pipeline for
  // identity's lookups (slice 2.34b), the notes for reporting's profile
  // (slice 2.36a), the violations for reporting's profile, support's appeal
  // and notifications' push (slice 2.36b).
  exports: [
    CaptainsService,
    PeakBonusService,
    ApplicationsService,
    ApplicationPipelineService,
    CaptainNotesService,
    ViolationsService,
  ],
})
export class CaptainsModule {}

// The worker role's upkeep of the captains module: the locations' monthly
// partitions.
@Module({ imports: [DatabaseModule], providers: [LocationPartitions] })
export class CaptainsWorkerModule {}

export type {
  Availability,
  CaptainStatus,
  LastOrderBy,
  NoOffersReason,
  OnlineBlock,
} from './availability.js';
export type { LivePosition } from './live-positions.js';
export {
  type ApplicationDocumentKind,
  type ApplicationStage,
  type DepositSettlement,
  depositInstalmentDue,
  depositSettlements,
} from './applications.js';
export {
  type ApplicationChange,
  type ApplicationNotice,
  ApplicationsService,
} from './applications.service.js';
export {
  ApplicationPipelineService,
  type ContractPhaseChange,
  type DepositAwaiting,
  type DepositToSettle,
  type ExpiringDocuments,
  type ProbationReview,
  type PipelineIdentity,
  PipelineRefusedError,
} from './application-pipeline.service.js';
export { orderPay, type PayParts, type PayRate } from './pay.js';
export { localClock, type PeakWindow } from './peak-bonus.js';
export {
  type ActiveOrderLookup,
  type AvailabilityChange,
  type CashReminder,
  type Candidate,
  type Captain,
  type CaptainBalance,
  type CaptainChange,
  type CaptainState,
  type CaptainsRefusal,
  CaptainsRefusedError,
  CaptainsService,
  type Custody,
  type CustodyCurrency,
  type DeskCaptain,
  type HandInGrace,
  type IneligibleReason,
  type LocationPoint,
  type Money,
  type NewCaptain,
  type PayTable,
  type StatusChanged,
} from './captains.service.js';
export {
  type ActivePeakWindow,
  type PeakBonusAmount,
  PeakBonusService,
} from './peak-bonus.service.js';
export {
  CAPTAIN_NOTE_MAX,
  type CaptainNote,
  CaptainNoteKeyReusedError,
  CaptainNotesService,
} from './captain-notes.service.js';
export {
  type AppealOutcome,
  appealOutcomes,
  STEP_LABELS,
  type ViolationStep,
  violationSteps,
} from './violations.js';
export {
  type NewViolation,
  VIOLATION_LISTS,
  VIOLATION_REASON_MAX,
  type ViolationAdmin,
  type ViolationRecorded,
  type ViolationRefusal,
  ViolationRefusedError,
  type ViolationRow,
  ViolationsService,
} from './violations.service.js';
