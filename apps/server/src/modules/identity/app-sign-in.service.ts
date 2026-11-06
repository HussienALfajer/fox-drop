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
import {
  type CaptainAccount,
  CaptainAccountsService,
  CaptainSignInRefusedError,
} from './captain-accounts.service.js';
import { CODE_SENDER, type CodeSender } from './code-sender.js';
import {
  type MerchantAccount,
  MerchantAccountsService,
  MerchantSignInRefusedError,
} from './merchant-accounts.service.js';
import { DAY_MS, HOUR_MS, type Limit, RequestLimits } from './request-limits.js';
import { appSignInCodes, customerAccounts, merchantAccounts } from './schema.js';
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
  // The restaurant user's account (RA §5.1), for the restaurant app.
  merchant: MerchantAccount | null;
  // The captain's account (CA §4.9), for the captain app.
  captain: CaptainAccount | null;
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
    private readonly merchantAccounts: MerchantAccountsService,
    private readonly captainAccounts: CaptainAccountsService,
  ) {
    this.limits = new RequestLimits(valkey);
  }

  // A customer's answer is the same whether the number has an account or not
  // (architecture §8.3.2); a restaurant user's tells the refusals of RA §5.2
  // items 3–4 and §5.5.
  async requestCode(
    request: CodeRequest,
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<{ channel: 'whatsapp'; resendAfterSec: number; expiresAt: Date }> {
    const phoneHash = this.secrets.phoneHash(request.phone);
    // Read before the transaction, so a settings cache miss never waits for a
    // second pool connection while this one is held.
    const ipHourlyMax = await this.settings.get('otp.ip_hourly_max');
    const resendAfterSec = await this.settings.get('otp.resend_after_sec');
    const validityMin = await this.settings.get('otp.validity_min');
    const numberKey = `identity:otp:number:${phoneHash}`;
    const requesterLimits: Limit[] = [
      { key: numberKey, windowMs: DAY_MS, max: await this.settings.get('otp.number_daily_max') },
      {
        key: `identity:otp:device:${request.deviceId}`,
        windowMs: DAY_MS,
        max: await this.settings.get('otp.device_daily_max'),
      },
      { key: numberKey, windowMs: HOUR_MS, max: await this.settings.get('otp.number_hourly_max') },
    ];

    // Every request the IP limit lets through counts towards it, those
    // refused later included; one it refuses does not, so a client that waits
    // for Retry-After gets through.
    const ip = await this.limits.reserve(
      [
        {
          key: `identity:otp:ip:${context.ipAddress ?? 'unknown'}`,
          windowMs: HOUR_MS,
          max: ipHourlyMax,
        },
      ],
      now,
    );
    if (!ip.reserved) throw new CodeRequestRefusedError('ip_limit', ip.retryAfterSec);

    // RA §5.2 items 3–4: a restaurant user hears at once why no code comes,
    // and nothing is sent to a number of no restaurant (architecture §8.3.2–
    // 8.3.3). The IP limit above still counts the request.
    if (request.party === 'merchant') {
      const merchant = await this.merchantAccounts.signInAccount(phoneHash);
      if (typeof merchant === 'string') throw new MerchantSignInRefusedError(merchant);
    }
    // A captain is never created by sign-in, and the answer never tells
    // whether a number belongs to a captain (architecture §8.3.2; owner
    // decision 2026-11-06): every step runs, the limits and the resend wait
    // included, but a number that cannot sign in gets nothing (§8.3.3). The
    // joining slice sends codes to new numbers for the application form
    // (CA §5.1).
    const silent =
      request.party === 'captain' &&
      typeof (await this.captainAccounts.signInAccount(phoneHash, now)) === 'string';

    return this.database.db.transaction(async (tx) => {
      // One request per number at a time, so the resend wait and the one open
      // code hold under concurrent requests. The wait is per number whatever
      // the app, since it protects the sending numbers (architecture §8.3.3).
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

      const reservation = await this.limits.reserve(requesterLimits, now);
      if (!reservation.reserved) {
        throw new CodeRequestRefusedError(
          reservation.limit.windowMs === HOUR_MS ? 'hourly_limit' : 'daily_limit',
          reservation.retryAfterSec,
        );
      }
      try {
        const code = newSignInCode();
        const expiresAt = new Date(now.getTime() + validityMin * 60_000);
        await tx
          .update(appSignInCodes)
          .set({ endedAt: now, endReason: 'replaced' })
          .where(
            and(
              eq(appSignInCodes.party, request.party),
              eq(appSignInCodes.phoneHash, phoneHash),
              isNull(appSignInCodes.endedAt),
            ),
          );
        await tx.insert(appSignInCodes).values({
          party: request.party,
          phoneHash,
          deviceId: request.deviceId,
          codeHash: this.secrets.signInCodeHash(request.phone, code),
          expiresAt,
          createdAt: now,
        });
        // Sent last, so a refusal rolls the new code back and keeps the old.
        // Outside development this waits for the otp-sender's answer
        // (code-send-queue.ts), up to 10 seconds under the number's lock.
        const sent = silent ? 'sent' : await this.sender.send(request.phone, code);
        if (sent !== 'sent') throw new CodeRequestRefusedError(sent);
        return { channel: 'whatsapp' as const, resendAfterSec, expiresAt };
      } catch (error) {
        // Nothing was sent: the code does not count towards the limits.
        await reservation.release();
        throw error;
      }
    });
  }

  // Checks the code and signs the device in, creating a customer's account on
  // the number's first sign-in (CU §5.2 items 3–4). A restaurant user's
  // account is never created here (RA §5.2 item 3). The code request refused
  // them already; a status changed since is refused here
  // (MerchantSignInRefusedError) and the code is used up.
  async signIn(
    request: CodeRequest & { code: string },
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<AppSignIn> {
    const phoneHash = this.secrets.phoneHash(request.phone);
    const maxAttempts = await this.settings.get('otp.max_attempts');
    // Before the transaction, so loading or creating the key never waits for
    // a second pool connection while this one is held.
    const signingKey = await this.sessions.signingKey(now);
    // Before the transaction too: the restaurant's status is read through the
    // merchants module, on a connection of its own.
    const merchant =
      request.party === 'merchant' ? await this.merchantAccounts.signInAccount(phoneHash) : null;
    const captain =
      request.party === 'captain' ? await this.captainAccounts.signInAccount(phoneHash, now) : null;
    let endedElsewhere: string[] = [];
    const result = await this.database.db.transaction(async (tx) => {
      const [code] = await tx
        .select()
        .from(appSignInCodes)
        .where(
          and(
            eq(appSignInCodes.party, request.party),
            eq(appSignInCodes.phoneHash, phoneHash),
            isNull(appSignInCodes.endedAt),
          ),
        )
        .for('update');
      if (
        !code ||
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

      if (typeof merchant === 'string') return new MerchantSignInRefusedError(merchant);
      if (typeof captain === 'string') return new CaptainSignInRefusedError(captain);
      let account: { id: string; created: boolean } | null;
      if (merchant !== null) {
        account = await this.stillNotRemoved(tx, merchant);
        if (account === null) return new MerchantSignInRefusedError('not_registered');
      } else if (captain !== null) {
        account = { id: captain.id, created: false };
      } else {
        account = await this.findOrCreateCustomer(tx, request.phone, phoneHash, now);
      }
      const { tokens, ended } = await this.sessions.start(
        tx,
        request.party,
        account.id,
        request.deviceId,
        context,
        signingKey,
        now,
      );
      endedElsewhere = ended;
      return {
        accountId: account.id,
        newAccount: account.created,
        merchant,
        captain,
        ...tokens,
      };
    });
    // The other devices' connections end once their sessions' end committed.
    if (endedElsewhere.length > 0) this.sessions.notifyEnded(endedElsewhere);
    if (
      result instanceof SignInCodeRefusedError ||
      result instanceof MerchantSignInRefusedError ||
      result instanceof CaptainSignInRefusedError
    ) {
      throw result;
    }
    return result;
  }

  // The merchant account read before the transaction, unless it was removed
  // since.
  private async stillNotRemoved(
    tx: Pick<Database['db'], 'select'>,
    merchant: MerchantAccount,
  ): Promise<{ id: string; created: boolean } | null> {
    const [row] = await tx
      .select({ id: merchantAccounts.id })
      .from(merchantAccounts)
      .where(and(eq(merchantAccounts.id, merchant.id), isNull(merchantAccounts.removedAt)));
    return row ? { id: row.id, created: false } : null;
  }

  private async findOrCreateCustomer(
    tx: Pick<Database['db'], 'select' | 'insert'>,
    phone: string,
    phoneHash: string,
    now: Date,
  ): Promise<{ id: string; created: boolean }> {
    // The code row lock serialises sign-ins of one number, so two cannot both
    // create its account.
    const [existing] = await tx
      .select({ id: customerAccounts.id })
      .from(customerAccounts)
      .where(and(eq(customerAccounts.phoneHash, phoneHash), eq(customerAccounts.status, 'active')));
    if (existing) return { id: existing.id, created: false };
    const [created] = await tx
      .insert(customerAccounts)
      .values({
        phoneEncrypted: this.secrets.encrypt(phone),
        phoneHash,
        createdAt: now,
        updatedAt: now,
      })
      .returning({ id: customerAccounts.id });
    if (!created) throw new Error('the account was not created');
    return { id: created.id, created: true };
  }
}
