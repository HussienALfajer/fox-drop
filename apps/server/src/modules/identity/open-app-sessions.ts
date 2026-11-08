import { Inject, Injectable, Module } from '@nestjs/common';
import { and, inArray, isNull } from 'drizzle-orm';
import { DATABASE, DatabaseModule } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { appSessions } from './schema.js';

// Which app sessions are still open, without the account checks of
// AppSessionsService.openSession: a push reaches the devices of open
// sessions only (architecture §8.1), so a signed-out device gets nothing.
// A module of its own, so the worker reads it without the API's routes.
@Injectable()
export class OpenAppSessions {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  async of(sessionIds: string[]): Promise<Set<string>> {
    if (sessionIds.length === 0) return new Set();
    const rows = await this.database.db
      .select({ id: appSessions.id })
      .from(appSessions)
      .where(and(inArray(appSessions.id, sessionIds), isNull(appSessions.endedAt)));
    return new Set(rows.map((row) => row.id));
  }
}

@Module({
  imports: [DatabaseModule],
  providers: [OpenAppSessions],
  exports: [OpenAppSessions],
})
export class OpenAppSessionsModule {}
