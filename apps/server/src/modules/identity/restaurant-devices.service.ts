import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { type DevicePlatform, MerchantsService } from '../merchants/index.js';
import { appSessions, merchantAccounts } from './schema.js';

export class RestaurantDevicesRefusedError extends Error {
  constructor(
    readonly refusal: 'unknown_restaurant' | 'no_device',
    message: string,
  ) {
    super(message);
  }
}

// A restaurant's device in the profile's «الحسابات» (AP §9.6.4, RA §14.2).
export interface RestaurantDeviceView {
  deviceId: string;
  name: string;
  platform: DevicePlatform;
  appVersion: string;
  // The user signed in on it now, else the latest who was.
  user: { name: string; role: 'owner' | 'cashier' } | null;
  signedIn: boolean;
  // The latest moment the device was heard from: its session's last refresh
  // (every 15 minutes while open), or its end.
  lastSeenAt: Date | null;
}

// AP §9.6.4 (slice 2.30d): a restaurant's devices with who uses them, and
// operations' force sign-out of one or every device (RA §14.2: signing a
// cashier's device out never removes the cashier). Presence, the ring
// setting and the device check join with 2.42.
@Injectable()
export class RestaurantDevicesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {}

  async devices(restaurantId: string): Promise<RestaurantDeviceView[]> {
    const named = await this.merchants.devices(restaurantId);
    if (named.length === 0) return [];
    // The latest session of each device among the restaurant's users.
    const sessions = await this.database.db
      .selectDistinctOn([appSessions.deviceId], {
        deviceId: appSessions.deviceId,
        endedAt: appSessions.endedAt,
        lastRefreshedAt: appSessions.lastRefreshedAt,
        name: merchantAccounts.name,
        role: merchantAccounts.role,
      })
      .from(appSessions)
      .innerJoin(merchantAccounts, eq(merchantAccounts.id, appSessions.accountId))
      .where(
        and(
          eq(appSessions.party, 'merchant'),
          eq(merchantAccounts.restaurantId, restaurantId),
          inArray(
            appSessions.deviceId,
            named.map((device) => device.deviceId),
          ),
        ),
      )
      .orderBy(appSessions.deviceId, desc(appSessions.signedInAt));
    const byDevice = new Map(sessions.map((session) => [session.deviceId, session]));
    return named.map((device) => {
      const session = byDevice.get(device.deviceId);
      return {
        deviceId: device.deviceId,
        name: device.name,
        platform: device.platform,
        appVersion: device.appVersion,
        user: session ? { name: session.name, role: session.role } : null,
        signedIn: session !== undefined && session.endedAt === null,
        lastSeenAt: session ? (session.endedAt ?? session.lastRefreshedAt) : null,
      };
    });
  }

  // Ends the open sessions of the restaurant's users on one device, or on
  // every device (null), with `signed_out_by_operations`, audited
  // `merchant_devices.sign_out` with the reason. The ids it ended, which the
  // caller passes to notifyEnded once it commits. 409 no_device when none
  // was signed in, so a repeat changes nothing.
  async signOut(
    restaurantId: string,
    deviceId: string | null,
    change: { actor: AuditActor; context: AuditRequestContext; reason: string },
    now = new Date(),
  ): Promise<string[]> {
    const restaurant = await this.merchants.cityAndStatus(restaurantId);
    if (restaurant === null) {
      throw new RestaurantDevicesRefusedError('unknown_restaurant', 'no such restaurant');
    }
    return this.database.db.transaction(async (tx) => {
      const users = tx
        .select({ id: merchantAccounts.id })
        .from(merchantAccounts)
        .where(eq(merchantAccounts.restaurantId, restaurantId));
      const ended = await tx
        .update(appSessions)
        .set({ endedAt: now, endReason: 'signed_out_by_operations' })
        .where(
          and(
            eq(appSessions.party, 'merchant'),
            isNull(appSessions.endedAt),
            inArray(appSessions.accountId, users),
            ...(deviceId === null ? [] : [eq(appSessions.deviceId, deviceId)]),
          ),
        )
        .returning({ id: appSessions.id });
      if (ended.length === 0) {
        throw new RestaurantDevicesRefusedError('no_device', 'no device is signed in');
      }
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: restaurant.cityId,
          action: 'merchant_devices.sign_out',
          target: { type: 'restaurant', id: restaurantId },
          before: null,
          after: { deviceId, sessions: ended.length },
          reason: change.reason,
        },
        tx,
      );
      return ended.map((row) => row.id);
    });
  }
}
