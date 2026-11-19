import { Inject, Injectable, type OnModuleInit } from '@nestjs/common';
import { inArray } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { ApplicationPipelineService } from '../captains/index.js';
import { AdminSessionsService } from './admin-sessions.service.js';
import { captainAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

// AP §9.7.1 (slice 2.34b): the captain applications' review page shows the
// applicant's verified number and the admins who acted. Identity imports
// captains, so it registers both lookups with the pipeline at start. The
// number is decrypted for the pipeline's review page only, which masks it
// for a reader without captains.manage.
@Injectable()
export class ApplicantLookups implements OnModuleInit {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly pipeline: ApplicationPipelineService,
    private readonly admins: AdminSessionsService,
  ) {}

  onModuleInit(): void {
    this.pipeline.useIdentity({
      phones: (accountIds) => this.phones(accountIds),
      adminNames: (accountIds) => this.admins.names(accountIds),
    });
  }

  private async phones(accountIds: string[]): Promise<Map<string, string>> {
    if (accountIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ id: captainAccounts.id, phoneEncrypted: captainAccounts.phoneEncrypted })
      .from(captainAccounts)
      .where(inArray(captainAccounts.id, accountIds));
    return new Map(rows.map((row) => [row.id, this.secrets.decrypt(row.phoneEncrypted)]));
  }
}
