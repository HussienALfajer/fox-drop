import { and, desc, eq, inArray, isNull, lte, sql } from 'drizzle-orm';
import type { Database } from '../../database/database.js';
import {
  CONNECTED_STATUSES,
  type SenderStatus,
  SENDING_STATUSES,
  senderDay,
  THROTTLE_MINUTES,
} from './otp-sender-pool.js';
import { otpSenderCredentials, otpSenderDailyCounts, otpSenderNumbers } from './schema.js';
import type { IdentitySecrets } from './secrets.js';
import type { WhatsAppSessionStore } from './whatsapp-client.js';

export interface SenderNumber {
  id: string;
  phone: string;
}

export interface PoolNumber extends SenderNumber {
  status: SenderStatus;
  pairedAt: Date;
  disconnectedAt: Date | null;
  warmupStartedAt: Date | null;
  throttledUntil: Date | null;
}

export interface DayCounts {
  sent: number;
  failed: number;
  delivered: number;
  read: number;
}

export type DayCount = keyof DayCounts;

export const NO_COUNTS: DayCounts = { sent: 0, failed: 0, delivered: 0, read: 0 };

// The sending numbers, their sessions and their daily counts (architecture
// §8.3.3 items 6, 7, 10–12), shared by the otp-sender process, the pairing
// command and the API's read of «أرقام إرسال الرموز».
export class OtpSenderNumbers {
  constructor(
    private readonly database: Database,
    private readonly secrets: IdentitySecrets,
  ) {}

  // Every number not disabled, oldest pairing first.
  async pool(): Promise<PoolNumber[]> {
    const rows = await this.database.db
      .select({
        id: otpSenderNumbers.id,
        phoneEncrypted: otpSenderNumbers.phoneEncrypted,
        status: otpSenderNumbers.status,
        pairedAt: otpSenderNumbers.pairedAt,
        disconnectedAt: otpSenderNumbers.disconnectedAt,
        warmupStartedAt: otpSenderNumbers.warmupStartedAt,
        throttledUntil: otpSenderNumbers.throttledUntil,
      })
      .from(otpSenderNumbers)
      .where(isNull(otpSenderNumbers.disabledAt))
      .orderBy(otpSenderNumbers.pairedAt);
    return rows.map(({ phoneEncrypted, ...row }) => ({
      ...row,
      phone: this.secrets.decrypt(phoneEncrypted),
    }));
  }

  // The numbers that may send now, with their counts of the day.
  async sending(
    day: string,
  ): Promise<
    { id: string; status: SenderStatus; warmupStartedAt: Date | null; counts: DayCounts }[]
  > {
    const rows = await this.database.db
      .select({
        id: otpSenderNumbers.id,
        status: otpSenderNumbers.status,
        warmupStartedAt: otpSenderNumbers.warmupStartedAt,
        sent: otpSenderDailyCounts.sent,
        failed: otpSenderDailyCounts.failed,
        delivered: otpSenderDailyCounts.delivered,
        read: otpSenderDailyCounts.read,
      })
      .from(otpSenderNumbers)
      .leftJoin(
        otpSenderDailyCounts,
        and(
          eq(otpSenderDailyCounts.numberId, otpSenderNumbers.id),
          eq(otpSenderDailyCounts.day, day),
        ),
      )
      .where(
        and(
          isNull(otpSenderNumbers.disabledAt),
          inArray(otpSenderNumbers.status, [...SENDING_STATUSES]),
        ),
      );
    return rows.map(({ sent, failed, delivered, read, ...row }) => ({
      ...row,
      counts: {
        sent: sent ?? 0,
        failed: failed ?? 0,
        delivered: delivered ?? 0,
        read: read ?? 0,
      },
    }));
  }

  async counts(day: string, numberIds: string[]): Promise<Map<string, DayCounts>> {
    if (numberIds.length === 0) return new Map();
    const rows = await this.database.db
      .select()
      .from(otpSenderDailyCounts)
      .where(
        and(eq(otpSenderDailyCounts.day, day), inArray(otpSenderDailyCounts.numberId, numberIds)),
      );
    return new Map(
      rows.map(({ numberId, sent, failed, delivered, read }) => [
        numberId,
        { sent, failed, delivered, read },
      ]),
    );
  }

  async count(numberId: string, day: string, counts: Partial<DayCounts>): Promise<void> {
    const values = { ...NO_COUNTS, ...counts };
    await this.database.db
      .insert(otpSenderDailyCounts)
      .values({ numberId, day, ...values })
      .onConflictDoUpdate({
        target: [otpSenderDailyCounts.numberId, otpSenderDailyCounts.day],
        set: {
          sent: sql`${otpSenderDailyCounts.sent} + excluded.sent`,
          failed: sql`${otpSenderDailyCounts.failed} + excluded.failed`,
          delivered: sql`${otpSenderDailyCounts.delivered} + excluded.delivered`,
          read: sql`${otpSenderDailyCounts.read} + excluded.read`,
        },
      });
  }

  // A pairing in progress keeps its session in memory; once WhatsApp opens
  // it, the number and every key are saved in one transaction. Pairing a
  // number again disables its earlier rows and resumes their warm-up: a
  // number that was active stays active, a new one starts warming.
  async savePaired(
    phone: string,
    entries: Map<string, string | null>,
    now: Date,
  ): Promise<SenderNumber & { status: SenderStatus }> {
    const phoneHash = this.secrets.phoneHash(phone);
    return this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtext(${`identity.otp_sender:${phoneHash}`}))`,
      );
      const [earlier] = await tx
        .select({
          status: otpSenderNumbers.status,
          warmupStartedAt: otpSenderNumbers.warmupStartedAt,
        })
        .from(otpSenderNumbers)
        .where(and(eq(otpSenderNumbers.phoneHash, phoneHash), isNull(otpSenderNumbers.disabledAt)))
        .orderBy(desc(otpSenderNumbers.pairedAt))
        .limit(1);
      await tx
        .update(otpSenderNumbers)
        .set({ disabledAt: now })
        .where(and(eq(otpSenderNumbers.phoneHash, phoneHash), isNull(otpSenderNumbers.disabledAt)));
      const warmupStartedAt = earlier ? earlier.warmupStartedAt : now;
      const [number] = await tx
        .insert(otpSenderNumbers)
        .values({
          phoneEncrypted: this.secrets.encrypt(phone),
          phoneHash,
          status: warmupStartedAt ? 'warming' : 'active',
          pairedAt: now,
          warmupStartedAt,
        })
        .returning({ id: otpSenderNumbers.id, status: otpSenderNumbers.status });
      if (!number) throw new Error('the sending number was not saved');
      // The day's caps are the phone's, whichever row sent: the new row takes
      // over today's counts of the earlier ones.
      await tx.execute(sql`
        INSERT INTO identity.otp_sender_daily_counts (number_id, day, sent, failed, delivered, read)
        SELECT ${number.id}, counts.day, sum(counts.sent), sum(counts.failed), sum(counts.delivered), sum(counts.read)
        FROM identity.otp_sender_daily_counts AS counts
        JOIN identity.otp_sender_numbers AS numbers ON numbers.id = counts.number_id
        WHERE numbers.phone_hash = ${phoneHash} AND numbers.id <> ${number.id} AND counts.day = ${senderDay(now)}
        GROUP BY counts.day`);
      const rows = [...entries].map(([key, value]) => ({
        numberId: number.id,
        key,
        valueEncrypted: value === null ? null : this.secrets.encrypt(value),
        updatedAt: now,
      }));
      if (rows.length > 0) await tx.insert(otpSenderCredentials).values(rows);
      return { id: number.id, phone, status: number.status };
    });
  }

  // WhatsApp logged the number out (disconnected) or refused it (banned): it
  // sends nothing until paired again. False when it was already stopped.
  async stop(numberId: string, status: 'disconnected' | 'banned', now: Date): Promise<boolean> {
    const stopped = await this.database.db
      .update(otpSenderNumbers)
      .set({ status, disconnectedAt: now, throttledUntil: null, throttledFrom: null })
      .where(
        and(
          eq(otpSenderNumbers.id, numberId),
          isNull(otpSenderNumbers.disabledAt),
          inArray(otpSenderNumbers.status, [...CONNECTED_STATUSES]),
        ),
      )
      .returning({ id: otpSenderNumbers.id });
    return stopped.length > 0;
  }

  // Item 12: a sending number rests for THROTTLE_MINUTES. False when it no
  // longer sends.
  async throttle(numberId: string, now: Date): Promise<boolean> {
    const throttled = await this.database.db
      .update(otpSenderNumbers)
      .set({
        status: 'throttled',
        throttledFrom: sql`${otpSenderNumbers.status}`,
        throttledUntil: new Date(now.getTime() + THROTTLE_MINUTES * 60_000),
      })
      .where(
        and(
          eq(otpSenderNumbers.id, numberId),
          isNull(otpSenderNumbers.disabledAt),
          inArray(otpSenderNumbers.status, [...SENDING_STATUSES]),
        ),
      )
      .returning({ id: otpSenderNumbers.id });
    return throttled.length > 0;
  }

  // Throttled numbers whose rest is over return to their earlier state.
  async endThrottles(now: Date): Promise<void> {
    await this.database.db
      .update(otpSenderNumbers)
      .set({
        status: sql`${otpSenderNumbers.throttledFrom}`,
        throttledFrom: null,
        throttledUntil: null,
      })
      .where(
        and(eq(otpSenderNumbers.status, 'throttled'), lte(otpSenderNumbers.throttledUntil, now)),
      );
  }

  // Item 6: a warming number whose warm-up reached full becomes active.
  async endWarmup(numberIds: string[]): Promise<void> {
    if (numberIds.length === 0) return;
    await this.database.db
      .update(otpSenderNumbers)
      .set({ status: 'active', warmupStartedAt: null })
      .where(and(inArray(otpSenderNumbers.id, numberIds), eq(otpSenderNumbers.status, 'warming')));
  }

  session(numberId: string): WhatsAppSessionStore {
    return {
      read: async (key) => {
        const [row] = await this.database.db
          .select({ value: otpSenderCredentials.valueEncrypted })
          .from(otpSenderCredentials)
          .where(
            and(eq(otpSenderCredentials.numberId, numberId), eq(otpSenderCredentials.key, key)),
          );
        return row?.value ? this.secrets.decrypt(row.value) : null;
      },
      write: async (entries) => {
        const now = new Date();
        const rows = Object.entries(entries).map(([key, value]) => ({
          numberId,
          key,
          valueEncrypted: value === null ? null : this.secrets.encrypt(value),
          updatedAt: now,
        }));
        if (rows.length === 0) return;
        await this.database.db
          .insert(otpSenderCredentials)
          .values(rows)
          .onConflictDoUpdate({
            target: [otpSenderCredentials.numberId, otpSenderCredentials.key],
            set: {
              valueEncrypted: sql`excluded.value_encrypted`,
              updatedAt: sql`excluded.updated_at`,
            },
          });
      },
    };
  }
}

// The session of a number being paired, kept in memory until WhatsApp opens
// it, so an abandoned pairing leaves nothing behind.
export function memorySession(): WhatsAppSessionStore & { entries: Map<string, string | null> } {
  const entries = new Map<string, string | null>();
  return {
    entries,
    read: (key) => Promise.resolve(entries.get(key) ?? null),
    write: (written) => {
      for (const [key, value] of Object.entries(written)) entries.set(key, value);
      return Promise.resolve();
    },
  };
}
