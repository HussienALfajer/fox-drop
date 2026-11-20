import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, isNull } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import {
  connectedAt,
  type DeviceCheck,
  type DevicePlatform,
  MerchantsService,
} from '../merchants/index.js';
import { appSessions, merchantAccounts } from './schema.js';

export class RestaurantDevicesRefusedError extends Error {
  constructor(
    readonly refusal: 'unknown_restaurant' | 'no_device' | 'restaurant_terminated',
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
  // (every 15 minutes while open), or its end, or its last moment on the
  // restaurant's channel, whichever is later.
  lastSeenAt: Date | null;
  // RA §4.4: whether ring events ring on it: the owner's setting, always for
  // a cashier signed in on it (slice 2.42).
  ringing: boolean;
  // RA §4.3: signed in and seen on the channel within the last 60 s.
  connected: boolean;
  // RA §4.5: its latest device check.
  check: DeviceCheck | null;
}

// AP §9.6.4 (slice 2.30d): a restaurant's devices with who uses them, and
// operations' force sign-out of one or every device (RA §14.2: signing a
// cashier's device out never removes the cashier), with presence, the ring
// setting and the device check (slice 2.42).
@Injectable()
export class RestaurantDevicesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {}

  async devices(restaurantId: string, now = new Date()): Promise<RestaurantDeviceView[]> {
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
      const signedIn = session !== undefined && session.endedAt === null;
      const heard = session ? (session.endedAt ?? session.lastRefreshedAt) : null;
      return {
        deviceId: device.deviceId,
        name: device.name,
        platform: device.platform,
        appVersion: device.appVersion,
        user: session ? { name: session.name, role: session.role } : null,
        signedIn,
        lastSeenAt: latest(heard, signedIn ? device.presentAt : null),
        ringing: (signedIn && session.role === 'cashier') || device.ringing,
        connected: signedIn && connectedAt(device.presentAt, now),
        check: device.check,
      };
    });
  }

  // Ends the open sessions of the restaurant's users on one device, or on
  // every device (null), with `signed_out_by_operations`, or
  // `signed_out_by_owner` when an owner signs one out in the app (RA §14.2,
  // slice 2.33), audited `merchant_devices.sign_out` with the reason if any.
  // The ids it ended, which the caller passes to notifyEnded once it
  // commits. 409 no_device when none was signed in, so a repeat changes
  // nothing.
  async signOut(
    restaurantId: string,
    deviceId: string | null,
    change: { actor: AuditActor; context: AuditRequestContext; reason: string | null },
    now = new Date(),
  ): Promise<string[]> {
    const endReason =
      change.actor.type === 'merchant' ? 'signed_out_by_owner' : 'signed_out_by_operations';
    const restaurant = await this.merchants.cityAndStatus(restaurantId);
    if (restaurant === null) {
      throw new RestaurantDevicesRefusedError('unknown_restaurant', 'no such restaurant');
    }
    return this.database.db.transaction(async (tx) => {
      // RA §5.5: a terminated restaurant's owners keep only the money
      // section, read under the restaurant row's share lock.
      if (
        change.actor.type === 'merchant' &&
        (await this.merchants.lockedAccountStatus(tx, restaurantId)) === 'terminated'
      ) {
        throw new RestaurantDevicesRefusedError('restaurant_terminated', 'the contract has ended');
      }
      const users = tx
        .select({ id: merchantAccounts.id })
        .from(merchantAccounts)
        .where(eq(merchantAccounts.restaurantId, restaurantId));
      const ended = await tx
        .update(appSessions)
        .set({ endedAt: now, endReason })
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

function latest(a: Date | null, b: Date | null): Date | null {
  if (a === null) return b;
  if (b === null) return a;
  return a > b ? a : b;
}
