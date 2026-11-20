import { Inject, Injectable, Module } from '@nestjs/common';
import { and, eq, inArray, isNull } from 'drizzle-orm';
import { DATABASE, DatabaseModule } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { appSessions, merchantAccounts } from './schema.js';

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

  // Each session's device.
  async devicesOf(sessionIds: string[]): Promise<Map<string, string>> {
    if (sessionIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ id: appSessions.id, deviceId: appSessions.deviceId })
      .from(appSessions)
      .where(inArray(appSessions.id, sessionIds));
    return new Map(rows.map((row) => [row.id, row.deviceId]));
  }

  // RA §4.6 (slice 2.42): the open sessions of a restaurant's users, each
  // with its device and its user's role.
  async merchantSessions(
    restaurantId: string,
  ): Promise<{ sessionId: string; deviceId: string; role: 'owner' | 'cashier' }[]> {
    return this.database.db
      .select({
        sessionId: appSessions.id,
        deviceId: appSessions.deviceId,
        role: merchantAccounts.role,
      })
      .from(appSessions)
      .innerJoin(merchantAccounts, eq(merchantAccounts.id, appSessions.accountId))
      .where(
        and(
          eq(appSessions.party, 'merchant'),
          isNull(appSessions.endedAt),
          eq(merchantAccounts.restaurantId, restaurantId),
        ),
      );
  }
}

@Module({
  imports: [DatabaseModule],
  providers: [OpenAppSessions],
  exports: [OpenAppSessions],
})
export class OpenAppSessionsModule {}
