import { Module } from '@nestjs/common';
import { DatabaseModule } from '../../database/database.module.js';
import { AuditPartitions } from './audit-partitions.js';
import { AuditService } from './audit.service.js';

// The audit module (architecture §4.2): the append-only audit log. Other
// modules import AuditModule and record events through AuditService only.
@Module({
  imports: [DatabaseModule],
  providers: [AuditService],
  exports: [AuditService],
})
export class AuditModule {}

// The worker role's upkeep of the log: its monthly partitions.
@Module({ imports: [DatabaseModule], providers: [AuditPartitions] })
export class AuditWorkerModule {}

export {
  AuditService,
  type AuditActor,
  type AuditExecutor,
  type AuditRequestContext,
  type AuditView,
  type AuditWrite,
} from './audit.service.js';
