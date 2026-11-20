import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, inArray, isNotNull, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { MerchantsRefusedError } from './merchants.service.js';
import type { DeviceCheckCode } from './receiving.js';
import { devices, receiving } from './schema.js';

// RA §4.3–4.6 (slice 2.42): what each device of a restaurant reports (its
// app version, its ring setting, its device check), what the worker sees of
// it on the channel, and since when an open restaurant has had no receiving
// device. None of these is a status change or audited: they describe a
// device, as its app version does.
@Injectable()
export class ReceivingDevicesService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  // The app's report at every start and whenever it changes: its version,
  // and the owner's «الرنين على هذا الجهاز» (null leaves it as it is: a
  // cashier's device rings whatever it holds). 404 unknown_device before
  // the device is named.
  async report(
    restaurantId: string,
    deviceId: string,
    report: { appVersion: string; ringing: boolean | null },
  ): Promise<void> {
    const updated = await this.database.db
      .update(devices)
      .set({
        appVersion: report.appVersion,
        ...(report.ringing === null ? {} : { ringing: report.ringing }),
      })
      .where(and(eq(devices.restaurantId, restaurantId), eq(devices.deviceId, deviceId)))
      .returning({ id: devices.id });
    if (updated.length === 0) throw new MerchantsRefusedError('unknown_device', 'no such device');
  }

  // RA §4.5: the device's latest check; it passes with no failed item.
  // `sleep` (Windows' power plan) is a warning only (SHOULD), so it never
  // fails the check.
  async recordCheck(
    restaurantId: string,
    deviceId: string,
    check: { failed: DeviceCheckCode[]; delayMs: number | null },
    now = new Date(),
  ): Promise<void> {
    const failed = [...new Set(check.failed)];
    const updated = await this.database.db
      .update(devices)
      .set({
        checkedAt: now,
        checkPassed: failed.every((code) => code === 'sleep'),
        checkFailed: failed,
        checkDelayMs: check.delayMs,
      })
      .where(and(eq(devices.restaurantId, restaurantId), eq(devices.deviceId, deviceId)))
      .returning({ id: devices.id });
    if (updated.length === 0) throw new MerchantsRefusedError('unknown_device', 'no such device');
  }

  // AP §9.6.3 step 8: the devices whose latest check passed.
  async passedChecks(restaurantId: string): Promise<number> {
    const [row] = await this.database.db
      .select({ count: count() })
      .from(devices)
      .where(and(eq(devices.restaurantId, restaurantId), eq(devices.checkPassed, true)));
    return row?.count ?? 0;
  }

  // RA §4.3: the devices the worker saw on the restaurant's channel now.
  async recordPresence(restaurantId: string, deviceIds: string[], now: Date): Promise<void> {
    if (deviceIds.length === 0) return;
    await this.database.db
      .update(devices)
      .set({ presentAt: now })
      .where(and(eq(devices.restaurantId, restaurantId), inArray(devices.deviceId, deviceIds)));
  }

  // RA §4.6: since when the restaurant has had no receiving device.
  async withoutDeviceSince(restaurantId: string): Promise<Date | null> {
    const [row] = await this.database.db
      .select({ since: receiving.withoutDeviceSince })
      .from(receiving)
      .where(eq(receiving.restaurantId, restaurantId));
    return row?.since ?? null;
  }

  async setWithoutDeviceSince(restaurantId: string, since: Date | null): Promise<void> {
    await this.database.db
      .insert(receiving)
      .values({ restaurantId, withoutDeviceSince: since })
      .onConflictDoUpdate({
        target: receiving.restaurantId,
        set: { withoutDeviceSince: since, updatedAt: sql`now()` },
        setWhere: sql`${receiving.withoutDeviceSince} IS DISTINCT FROM excluded.without_device_since`,
      });
  }

  // AP §9.1.1: of these restaurants, those the worker last saw open with no
  // receiving device.
  async withoutDevice(restaurantIds: string[]): Promise<Set<string>> {
    if (restaurantIds.length === 0) return new Set();
    const rows = await this.database.db
      .select({ id: receiving.restaurantId })
      .from(receiving)
      .where(
        and(
          inArray(receiving.restaurantId, restaurantIds),
          isNotNull(receiving.withoutDeviceSince),
        ),
      );
    return new Set(rows.map((row) => row.id));
  }
}
