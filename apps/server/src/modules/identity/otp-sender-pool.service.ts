import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull } from 'drizzle-orm';
import type { Valkey } from 'iovalkey';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { VALKEY } from '../../valkey/valkey.module.js';
import { type AuditRequestContext, AuditService } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import type { AdminSession } from './admin-sessions.service.js';
import { type DayCounts, NO_COUNTS, OtpSenderNumbers } from './otp-sender-numbers.js';
import {
  connectedKey,
  dailyCap,
  type PoolAlert,
  poolAlerts,
  type SenderStatus,
  senderDay,
  type Warmup,
  warmup,
} from './otp-sender-pool.js';
import { actorRole } from './roles.js';
import { otpSenderNumbers } from './schema.js';
import { IDENTITY_SECRETS, type IdentitySecrets } from './secrets.js';

export interface PoolNumberView {
  id: string;
  phone: string;
  status: SenderStatus;
  connected: boolean;
  pairedAt: Date;
  stoppedAt: Date | null;
  throttledUntil: Date | null;
  warmup: Warmup | null;
  dailyCap: number;
  today: DayCounts;
}

export interface PoolView {
  numbers: PoolNumberView[];
  alerts: PoolAlert[];
}

export type PoolRefusal = 'not_found' | 'needs_pairing';

export class PoolRefusedError extends Error {
  constructor(readonly refusal: PoolRefusal) {
    super(refusal);
  }
}

// The states OWN may set (§8.3.3 item 13).
export type SettableStatus = 'active' | 'standby';

// «أرقام إرسال الرموز» (architecture §8.3.3 items 13–14, AP §9.14), the API's
// side: the numbers with their state and daily counts, and OWN's changes.
// The otp-sender reads the states at every send and picks the changes up
// at its next supervision. Pairing stays the server command until the panel
// screen.
@Injectable()
export class OtpSenderPoolService {
  private readonly numbers: OtpSenderNumbers;

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(VALKEY) private readonly valkey: Valkey,
    @Inject(IDENTITY_SECRETS) secrets: IdentitySecrets,
    private readonly settings: SettingsService,
    private readonly audit: AuditService,
  ) {
    this.numbers = new OtpSenderNumbers(database, secrets);
  }

  async read(now: Date): Promise<PoolView> {
    const [pool, dailyMax, caps, stepDays] = await Promise.all([
      this.numbers.pool(),
      this.settings.get('otp.sender_daily_max'),
      this.settings.get('otp.sender_warmup_caps'),
      this.settings.get('otp.sender_warmup_step_days'),
    ]);
    const ids = pool.map((number) => number.id);
    const [counts, marks] = await Promise.all([
      this.numbers.counts(senderDay(now), ids),
      // Without Valkey no number shows as connected: the alert errs on the
      // side of telling.
      ids.length === 0
        ? Promise.resolve([])
        : this.valkey.mget(ids.map(connectedKey)).catch(() => ids.map(() => null)),
    ]);
    const numbers = pool.map((number, index): PoolNumberView => {
      const warming =
        number.status === 'warming' && number.warmupStartedAt
          ? warmup(number.warmupStartedAt, now, caps, stepDays)
          : null;
      return {
        id: number.id,
        phone: number.phone,
        status: number.status,
        connected: marks[index] === '1',
        pairedAt: number.pairedAt,
        stoppedAt: number.disconnectedAt,
        throttledUntil: number.throttledUntil,
        warmup: warming,
        dailyCap: dailyCap(warming, dailyMax),
        today: counts.get(number.id) ?? NO_COUNTS,
      };
    });
    const alerts = poolAlerts(
      numbers.map((number) => ({
        id: number.id,
        status: number.status,
        connected: number.connected,
        attemptedToday: number.today.sent + number.today.failed,
        dailyCap: number.dailyCap,
      })),
    );
    return { numbers, alerts };
  }

  // «نشط» or «احتياطي». A disconnected or banned number needs a new pairing.
  // Active ends the warm-up and a throttle; standby keeps the warm-up, which
  // resumes when the number is set warming again by a new pairing.
  async setStatus(
    numberId: string,
    status: SettableStatus,
    actor: AdminSession,
    context: AuditRequestContext,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const [number] = await tx
        .select({
          status: otpSenderNumbers.status,
          warmupStartedAt: otpSenderNumbers.warmupStartedAt,
        })
        .from(otpSenderNumbers)
        .where(and(eq(otpSenderNumbers.id, numberId), isNull(otpSenderNumbers.disabledAt)))
        .for('update');
      if (!number) throw new PoolRefusedError('not_found');
      if (number.status === 'disconnected' || number.status === 'banned') {
        throw new PoolRefusedError('needs_pairing');
      }
      if (number.status === status) return;
      await tx
        .update(otpSenderNumbers)
        .set({
          status,
          warmupStartedAt: status === 'active' ? null : number.warmupStartedAt,
          throttledUntil: null,
          throttledFrom: null,
        })
        .where(eq(otpSenderNumbers.id, numberId));
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'otp_sender_number.status_change',
          target: { type: 'otp_sender_number', id: numberId },
          before: { status: number.status },
          after: { status },
        },
        tx,
      );
    });
  }

  // «تعطيل»: the number is never used again; pairing it again makes a new row.
  async disable(
    numberId: string,
    actor: AdminSession,
    context: AuditRequestContext,
    now: Date,
  ): Promise<void> {
    await this.database.db.transaction(async (tx) => {
      const [number] = await tx
        .update(otpSenderNumbers)
        .set({ disabledAt: now })
        .where(and(eq(otpSenderNumbers.id, numberId), isNull(otpSenderNumbers.disabledAt)))
        .returning({ status: otpSenderNumbers.status });
      if (!number) throw new PoolRefusedError('not_found');
      await this.audit.recordWrite(
        {
          actor: this.actor(actor),
          context,
          cityId: null,
          action: 'otp_sender_number.disable',
          target: { type: 'otp_sender_number', id: numberId },
          before: { status: number.status, disabled: false },
          after: { status: number.status, disabled: true },
        },
        tx,
      );
    });
  }

  private actor(session: AdminSession) {
    return { type: 'admin' as const, id: session.accountId, role: actorRole(session.roles) };
  }
}
