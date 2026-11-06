import { and, desc, eq, sql } from 'drizzle-orm';
import type { Database } from '../../database/database.js';
import { otpSenderCredentials, otpSenderNumbers } from './schema.js';
import type { IdentitySecrets } from './secrets.js';
import type { WhatsAppSessionStore } from './whatsapp-client.js';

export interface SenderNumber {
  id: string;
  phone: string;
}

// The sending numbers and their sessions (architecture §8.3.3 items 10–11),
// shared by the otp-sender process and the pairing command.
export class OtpSenderNumbers {
  constructor(
    private readonly database: Database,
    private readonly secrets: IdentitySecrets,
  ) {}

  // W1 sends from one number: the latest paired that is still active.
  async latestActive(): Promise<SenderNumber | null> {
    const [row] = await this.database.db
      .select({ id: otpSenderNumbers.id, phoneEncrypted: otpSenderNumbers.phoneEncrypted })
      .from(otpSenderNumbers)
      .where(eq(otpSenderNumbers.status, 'active'))
      .orderBy(desc(otpSenderNumbers.pairedAt))
      .limit(1);
    return row ? { id: row.id, phone: this.secrets.decrypt(row.phoneEncrypted) } : null;
  }

  // A pairing in progress keeps its session in memory; once WhatsApp opens
  // it, the number and every key are saved in one transaction.
  async savePaired(
    phone: string,
    entries: Map<string, string | null>,
    now: Date,
  ): Promise<SenderNumber> {
    return this.database.db.transaction(async (tx) => {
      const [number] = await tx
        .insert(otpSenderNumbers)
        .values({
          phoneEncrypted: this.secrets.encrypt(phone),
          phoneHash: this.secrets.phoneHash(phone),
          status: 'active',
          pairedAt: now,
        })
        .returning({ id: otpSenderNumbers.id });
      if (!number) throw new Error('the sending number was not saved');
      const rows = [...entries].map(([key, value]) => ({
        numberId: number.id,
        key,
        valueEncrypted: value === null ? null : this.secrets.encrypt(value),
        updatedAt: now,
      }));
      if (rows.length > 0) await tx.insert(otpSenderCredentials).values(rows);
      return { id: number.id, phone };
    });
  }

  // WhatsApp logged the number out: it sends nothing until paired again.
  async disconnect(numberId: string, now: Date): Promise<void> {
    await this.database.db
      .update(otpSenderNumbers)
      .set({ status: 'disconnected', disconnectedAt: now })
      .where(and(eq(otpSenderNumbers.id, numberId), eq(otpSenderNumbers.status, 'active')));
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
