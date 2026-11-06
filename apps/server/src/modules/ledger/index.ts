import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { LedgerPartitions } from './ledger-partitions.js';
import { LedgerService } from './ledger.service.js';

// The ledger module (architecture §4.2, §5.6): accounts and append-only
// double-entry journals. Other modules import LedgerModule and move money
// through LedgerService only (architecture §4.3 item 5).
@Module({
  imports: [DatabaseModule],
  providers: [LedgerService],
  exports: [LedgerService],
})
export class LedgerModule {}

// The worker role's upkeep of the ledger: the entries' monthly partitions.
@Module({ imports: [DatabaseModule], providers: [LedgerPartitions] })
export class LedgerWorkerModule {}

export {
  type AccountPurpose,
  type ActorType,
  type JournalType,
  type SourceKind,
} from './catalogue.js';
export {
  type Balance,
  type LedgerAccount,
  type LedgerEntry,
  type LedgerActor,
  type LedgerExecutor,
  LedgerRefusal,
  LedgerService,
  type PostJournal,
} from './ledger.service.js';
