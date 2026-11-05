import { timingSafeEqual } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, isNull, sql } from 'drizzle-orm';
import { Valkey } from 'iovalkey';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { VALKEY } from '../../valkey/valkey.module.js';
import type { AuditRequestContext } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import { type AppParty, AppSessionsService, type AppTokens } from './app-sessions.service.js';
import { CODE_SENDER, type CodeSender } from './code-sender.js';
import { DAY_MS, HOUR_MS, RequestLimits } from './request-limits.js';
import { appSignInCodes, customerAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets, newSignInCode } from './secrets.js';

// A code request the server refuses (architecture §8.3.3 item 2, CU §5.2):
// the resend wait, the hourly limit of a number, the daily limit of a number
// or a device («تجاوزت عدد المحاولات المسموح…»), the hourly limit of an IP
// address; or nothing could be sent.
export type CodeRequestRefusal =
  'resend_wait' | 'hourly_limit' | 'daily_limit' | 'ip_limit' | 'not_on_whatsapp' | 'unavailable';

export class CodeRequestRefusedError extends Error {
  constructor(
    readonly refusal: CodeRequestRefusal,
    readonly retryAfterSec?: number,
  ) {
    super(`code request refused: ${refusal}`);
  }
}

// wrong_code: attemptsLeft more tries of this code. code_expired: no usable
// code for this number and device (none, used, expired, out of attempts, or
// asked for by another device), so the app asks for a new one.
export class SignInCodeRefusedError extends Error {
  constructor(
    readonly refusal: 'wrong_code' | 'code_expired',
    readonly attemptsLeft: number,
  ) {
    super(`sign-in refused: ${refusal}`);
  }
}

export interface CodeRequest {
  party: AppParty;
  // E.164.
  phone: string;
  deviceId: string;
}

export interface AppSignIn extends AppTokens {
  accountId: string;
  // CU §5.2 item 4: the app shows the details screen (CU §5.3).
  newAccount: boolean;
}

// Architecture §8.3.2: app sign-in with a 6-digit code sent to the phone. The
// code is stored as a keyed hash with the number, the device and the expiry;
// one open code per number. Every setting is read at each request.
@Injectable()
export class AppSignInService {
  private readonly limits: RequestLimits;

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(VALKEY) valkey: Valkey,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    @Inject(CODE_SENDER) private readonly sender: CodeSender,
    private readonly settings: SettingsService,
    private readonly sessions: AppSessionsService,
  ) {
    this.limits = new RequestLimits(valkey);
  }

  // The answer is the same whether the number has an account or not
  // (architecture §8.3.2).
  async requestCode(
    request: CodeRequest,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<{ channel: 'whatsapp'; resendAfterSec: number; expiresAt: Date }> {
    const phoneHash = this.secrets.phoneHash(request.phone);
    const keys = {
      ip: `identity:otp:ip:${context.ipAddress ?? 'unknown'}`,
      number: `identity:otp:number:${phoneHash}`,
      device: `identity:otp:device:${request.deviceId}`,
    };

    // Every request counts towards its IP address, refused ones included.
    const ip = await this.limits.count(keys.ip, HOUR_MS, now);
    await this.limits.add(keys.ip, HOUR_MS, now);
    if (ip.count >= (await this.settings.get('otp.ip_hourly_max'))) {
      throw new CodeRequestRefusedError('ip_limit', ip.retryAfterSec);
    }

    const resendAfterSec = await this.settings.get('otp.resend_after_sec');
    const validityMin = await this.settings.get('otp.validity_min');
    return this.database.db.transaction(async (tx) => {
      // One request per number at a time, so the resend wait and the one open
      // code hold under concurrent requests.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.app_code:${phoneHash}`}, 0))`,
      );
      const [last] = await tx
        .select({ createdAt: appSignInCodes.createdAt })
        .from(appSignInCodes)
        .where(eq(appSignInCodes.phoneHash, phoneHash))
        .orderBy(desc(appSignInCodes.createdAt))
        .limit(1);
      const waitMs = last ? last.createdAt.getTime() + resendAfterSec * 1000 - now.getTime() : 0;
      if (waitMs > 0) {
        throw new CodeRequestRefusedError('resend_wait', Math.ceil(waitMs / 1000));
      }

      const hourly = await this.limits.count(keys.number, HOUR_MS, now);
      const daily = await this.limits.count(keys.number, DAY_MS, now);
      const device = await this.limits.count(keys.device, DAY_MS, now);
      if (daily.count >= (await this.settings.get('otp.number_daily_max'))) {
        throw new CodeRequestRefusedError('daily_limit', daily.retryAfterSec);
      }
      if (device.count >= (await this.settings.get('otp.device_daily_max'))) {
        throw new CodeRequestRefusedError('daily_limit', device.retryAfterSec);
      }
      if (hourly.count >= (await this.settings.get('otp.number_hourly_max'))) {
        throw new CodeRequestRefusedError('hourly_limit', hourly.retryAfterSec);
      }

      const code = newSignInCode();
      const expiresAt = new Date(now.getTime() + validityMin * 60_000);
      await tx
        .update(appSignInCodes)
        .set({ endedAt: now, endReason: 'replaced' })
        .where(and(eq(appSignInCodes.phoneHash, phoneHash), isNull(appSignInCodes.endedAt)));
      await tx.insert(appSignInCodes).values({
        party: request.party,
        phoneHash,
        deviceId: request.deviceId,
        codeHash: this.secrets.signInCodeHash(request.phone, code),
        expiresAt,
        createdAt: now,
      });
      // Sent last, so a refusal rolls the new code back and keeps the old.
      const sent = await this.sender.send(request.phone, code);
      if (sent !== 'sent') throw new CodeRequestRefusedError(sent);
      await this.limits.add(keys.number, DAY_MS, now);
      await this.limits.add(keys.device, DAY_MS, now);
      return { channel: 'whatsapp' as const, resendAfterSec, expiresAt };
    });
  }

  // Checks the code and signs the device in, creating the account on the
  // number's first sign-in (CU §5.2 items 3–4).
  async signIn(
    request: CodeRequest & { code: string },
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<AppSignIn> {
    const phoneHash = this.secrets.phoneHash(request.phone);
    const maxAttempts = await this.settings.get('otp.max_attempts');
    const result = await this.database.db.transaction(async (tx) => {
      const [code] = await tx
        .select()
        .from(appSignInCodes)
        .where(and(eq(appSignInCodes.phoneHash, phoneHash), isNull(appSignInCodes.endedAt)))
        .for('update');
      if (
        !code ||
        code.party !== request.party ||
        code.deviceId !== request.deviceId ||
        now.getTime() >= code.expiresAt.getTime() ||
        code.attempts >= maxAttempts
      ) {
        return new SignInCodeRefusedError('code_expired', 0);
      }
      const given = Buffer.from(this.secrets.signInCodeHash(request.phone, request.code), 'hex');
      const stored = Buffer.from(code.codeHash, 'hex');
      if (given.length !== stored.length || !timingSafeEqual(given, stored)) {
        // The wrong attempt is committed, so the limit holds.
        const attempts = code.attempts + 1;
        await tx
          .update(appSignInCodes)
          .set(
            attempts >= maxAttempts
              ? { attempts, endedAt: now, endReason: 'attempts_exhausted' }
              : { attempts },
          )
          .where(eq(appSignInCodes.id, code.id));
        return new SignInCodeRefusedError('wrong_code', Math.max(0, maxAttempts - attempts));
      }
      await tx
        .update(appSignInCodes)
        .set({ endedAt: now, endReason: 'used' })
        .where(eq(appSignInCodes.id, code.id));

      const account = await this.findOrCreateAccount(tx, request.party, request.phone, phoneHash);
      const tokens = await this.sessions.start(
        tx,
        request.party,
        account.id,
        request.deviceId,
        context,
        now,
      );
      return { accountId: account.id, newAccount: account.created, ...tokens };
    });
    if (result instanceof SignInCodeRefusedError) throw result;
    return result;
  }

  private async findOrCreateAccount(
    tx: Pick<Database['db'], 'select' | 'insert'>,
    party: AppParty,
    phone: string,
    phoneHash: string,
  ): Promise<{ id: string; created: boolean }> {
    switch (party) {
      case 'customer': {
        // The code row lock serialises sign-ins of one number, so two cannot
        // both create its account.
        const [existing] = await tx
          .select({ id: customerAccounts.id })
          .from(customerAccounts)
          .where(
            and(eq(customerAccounts.phoneHash, phoneHash), eq(customerAccounts.status, 'active')),
          );
        if (existing) return { id: existing.id, created: false };
        const [created] = await tx
          .insert(customerAccounts)
          .values({ phoneEncrypted: this.secrets.encrypt(phone), phoneHash })
          .returning({ id: customerAccounts.id });
        if (!created) throw new Error('the account was not created');
        return { id: created.id, created: true };
      }
    }
  }
}
