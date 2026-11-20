import { randomBytes, timingSafeEqual } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, isNotNull, isNull, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Valkey } from 'iovalkey';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { VALKEY } from '../../valkey/valkey.module.js';
import type { AuditRequestContext } from '../audit/index.js';
import { SettingsService } from '../settings/index.js';
import { type AppParty, AppSessionsService, type AppTokens } from './app-sessions.service.js';
import {
  type AnyCaptainAccount,
  CaptainAccountsService,
  CaptainSignInRefusedError,
} from './captain-accounts.service.js';
import { type DevicePlatform } from '../merchants/index.js';
import { APP_CHECK_VERIFIER, type AppCheckVerifier } from './app-check.js';
import { CODE_SENDER, type CodeSender } from './code-sender.js';
import {
  type MerchantAccount,
  MerchantAccountsService,
  MerchantSignInRefusedError,
} from './merchant-accounts.service.js';
import { PortalSessionsService } from './portal-sessions.service.js';
import { DAY_MS, HOUR_MS, type Limit, RequestLimits } from './request-limits.js';
import { appSignInCodes, customerAccounts, merchantAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets, newSignInCode } from './secrets.js';
import { type DeviceSignature, WindowsDevicesService } from './windows-devices.service.js';

// A code request the server refuses (architecture §8.3.3 item 2, CU §5.2):
// the resend wait, the hourly limit of a number, the daily limit of a number
// or a device («تجاوزت عدد المحاولات المسموح…»), the hourly limit of an IP
// address; no valid App Check token while one is required (§8.3.3 item 1);
// or nothing could be sent.
export type CodeRequestRefusal =
  | 'resend_wait'
  | 'hourly_limit'
  | 'daily_limit'
  | 'ip_limit'
  | 'app_check_failed'
  | 'not_on_whatsapp'
  | 'unavailable';

export class CodeRequestRefusedError extends Error {
  constructor(
    readonly refusal: CodeRequestRefusal,
    readonly retryAfterSec?: number,
  ) {
    super(`code request refused: ${refusal}`);
  }
}

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// AP §8.8 (slice 2.25c): a new account on a number whose latest account is
// closed continues its line. Registered by the customers module, which moves
// the closed account's dues in the sign-in's transaction.
export type CustomerRelinked = (
  tx: Tx,
  link: { accountId: string; closedAccountId: string; now: Date },
) => Promise<void>;

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
  // The X-Firebase-AppCheck header, when the app sent one.
  appCheckToken?: string | undefined;
  // The restaurant app says which platform it runs on: Windows has no App
  // Check provider (owner decision 2026-11-07), and signs with the key of its
  // registration instead (slice 2.44).
  platform?: DevicePlatform | undefined;
  deviceSignature?: DeviceSignature | undefined;
  // CA §5.1 «انضم ككابتن» (slice 2.34a; owner decision 2026-11-19): the
  // captain app's join sends the code to a number without an account too.
  join?: boolean | undefined;
  // RA §17 (slice 2.45a; owner decision 2026-11-20): the owner web portal's
  // code request, for an owner's number only, with no App Check (a browser
  // has none); the request limits still hold.
  portal?: boolean | undefined;
}

export interface AppSignIn extends AppTokens {
  accountId: string;
  // CU §5.2 item 4: the app shows the details screen (CU §5.3).
  newAccount: boolean;
  // The restaurant user's account (RA §5.1), for the restaurant app.
  merchant: MerchantAccount | null;
  // The captain's account (CA §4.9), for the captain app; an applicant's has
  // no captain (CA §5.1).
  captain: AnyCaptainAccount | null;
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
    @Inject(APP_CHECK_VERIFIER) private readonly appCheck: AppCheckVerifier,
    private readonly settings: SettingsService,
    private readonly sessions: AppSessionsService,
    private readonly merchantAccounts: MerchantAccountsService,
    private readonly captainAccounts: CaptainAccountsService,
    private readonly windowsDevices: WindowsDevicesService,
    private readonly portalSessions: PortalSessionsService,
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
    const appCheckRequired = await this.settings.get('otp.app_check_required');
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

    // Architecture §8.3.3 item 1: scripts and modified apps are refused before
    // anything else, once the apps send the token (owner decisions 2026-11-06,
    // 2026-11-07). The IP limit above counts them, so a script that sends no
    // token still runs into it. The restaurant app on Windows has no App
    // Check provider: a PC an owner registered signs the request with its
    // key instead (slice 2.44; owner decision 2026-11-20).
    if (appCheckRequired && !(request.party === 'merchant' && request.portal === true)) {
      const attested =
        request.party === 'merchant' && request.platform === 'windows'
          ? await this.windowsDevices.verify(
              request.deviceId,
              request.phone,
              request.deviceSignature,
              now,
            )
          : await this.appCheck.verify(request.appCheckToken, now);
      if (!attested) throw new CodeRequestRefusedError('app_check_failed');
    }

    // RA §5.2 items 3–4: a restaurant user hears at once why no code comes,
    // and nothing is sent to a number of no restaurant (architecture §8.3.2–
    // 8.3.3). The IP limit above still counts the request.
    if (request.party === 'merchant') {
      const merchant = await this.merchantAccounts.signInAccount(phoneHash);
      if (typeof merchant === 'string') throw new MerchantSignInRefusedError(merchant);
      if (request.portal === true && merchant.role !== 'owner') {
        throw new MerchantSignInRefusedError('owner_only');
      }
    }
    // A captain is never created by sign-in, and the answer never tells
    // whether a number belongs to a captain (architecture §8.3.2; owner
    // decision 2026-11-06): every step runs, the limits and the resend wait
    // included, but a number that cannot sign in gets nothing (§8.3.3). Only
    // «انضم ككابتن» sends to a number without an account, for the
    // application form (CA §5.1; owner decision 2026-11-19); a terminated
    // captain's number gets nothing either way.
    const captainRefusal =
      request.party === 'captain' ? await this.captainAccounts.signInAccount(phoneHash, now) : null;
    const silent =
      typeof captainRefusal === 'string' &&
      !(request.join === true && captainRefusal === 'not_registered');

    return this.database.db.transaction(async (tx) => {
      // One request per number at a time, so the resend wait and the one open
      // code hold under concurrent requests. The wait is per number whatever
      // the app, since it protects the sending numbers (architecture §8.3.3).
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.app_code:${phoneHash}`}, 0))`,
      );
      // An emergency code (W4) is never replaced by a code request while it
      // is open (owner decision 2026-11-07), so neither the person's own
      // resend nor anyone who knows the number can end the code operations
      // read out.
      const [emergency] = await tx
        .select({ expiresAt: appSignInCodes.expiresAt })
        .from(appSignInCodes)
        .where(
          and(
            eq(appSignInCodes.party, request.party),
            eq(appSignInCodes.phoneHash, phoneHash),
            isNull(appSignInCodes.endedAt),
            isNotNull(appSignInCodes.issuedBy),
          ),
        );
      const emergencyMs = emergency ? emergency.expiresAt.getTime() - now.getTime() : 0;
      if (emergencyMs > 0) {
        throw new CodeRequestRefusedError('resend_wait', Math.ceil(emergencyMs / 1000));
      }
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
          // A code never sent is stored as a value no code matches, so a
          // guessed code is a wrong code and never makes an applicant
          // (slice 2.34a).
          codeHash: silent
            ? randomBytes(32).toString('hex')
            : this.secrets.signInCodeHash(request.phone, code),
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
      const refused = await this.useCodeIn(tx, request, phoneHash, maxAttempts, now);
      if (refused !== null) return refused;

      if (typeof merchant === 'string') return new MerchantSignInRefusedError(merchant);
      if (captain === 'contract_ended') return new CaptainSignInRefusedError(captain);
      let account: { id: string; created: boolean } | null;
      let captainAccount: AnyCaptainAccount | null = null;
      if (merchant !== null) {
        account = await this.stillNotRemoved(tx, merchant);
        if (account === null) return new MerchantSignInRefusedError('not_registered');
      } else if (captain === 'not_registered') {
        // CA §5.1 (slice 2.34a): the number proved by its code applies. Only
        // «انضم ككابتن» sent it a code (`requestCode`); a code sent to no one
        // matches no code.
        const applied = await this.captainAccounts.createApplicant(tx, request.phone, now);
        captainAccount = applied.account;
        account = { id: applied.account.id, created: applied.created };
      } else if (captain !== null) {
        if (
          captain.captainId !== null &&
          (await this.captainAccounts.activeOrderElsewhere(tx, captain, request.deviceId))
        ) {
          return new CaptainSignInRefusedError('active_order_elsewhere');
        }
        captainAccount = captain;
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
        captain: captainAccount,
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

  // RA §17, §5.2–5.3, S14 (slice 2.45a): the owner web portal's sign-in with
  // the code its browser asked for (or an emergency code, W4). Only an
  // owner's number signs in (owner_only, the code used up); the session is a
  // portal session for `merchant.web_session_days`, never an app session.
  async signInToPortal(
    request: { phone: string; browserId: string; code: string },
    context: AuditRequestContext,
    now = new Date(),
  ): Promise<{ merchant: MerchantAccount; sessionId: string; token: string; expiresAt: Date }> {
    const phoneHash = this.secrets.phoneHash(request.phone);
    const maxAttempts = await this.settings.get('otp.max_attempts');
    const sessionDays = await this.settings.get('merchant.web_session_days');
    // Before the transaction: the status is read on a connection of its own.
    const merchant = await this.merchantAccounts.signInAccount(phoneHash);
    const codeRequest = {
      party: 'merchant' as const,
      phone: request.phone,
      deviceId: request.browserId,
      code: request.code,
    };
    const result = await this.database.db.transaction(async (tx) => {
      const refused = await this.useCodeIn(tx, codeRequest, phoneHash, maxAttempts, now);
      if (refused !== null) return refused;
      if (typeof merchant === 'string') return new MerchantSignInRefusedError(merchant);
      if (merchant.role !== 'owner') return new MerchantSignInRefusedError('owner_only');
      if ((await this.stillNotRemoved(tx, merchant)) === null) {
        return new MerchantSignInRefusedError('not_registered');
      }
      const session = await this.portalSessions.start(
        tx,
        merchant.id,
        request.browserId,
        context,
        sessionDays,
        now,
      );
      return {
        merchant,
        sessionId: session.id,
        token: session.token,
        expiresAt: session.expiresAt,
      };
    });
    if (result instanceof SignInCodeRefusedError || result instanceof MerchantSignInRefusedError) {
      throw result;
    }
    return result;
  }

  // CU §5.6 (slice 2.25c): checks a code the device asked for and uses it up,
  // without signing in: the fresh code «حذف الحساب» asks for. A wrong one
  // counts as at the sign-in (`SignInCodeRefusedError`).
  async useCode(request: CodeRequest & { code: string }, now = new Date()): Promise<void> {
    const phoneHash = this.secrets.phoneHash(request.phone);
    const maxAttempts = await this.settings.get('otp.max_attempts');
    const refused = await this.database.db.transaction((tx) =>
      this.useCodeIn(tx, request, phoneHash, maxAttempts, now),
    );
    if (refused !== null) throw refused;
  }

  // The number's open code for the party: used up when right, a wrong
  // attempt committed otherwise (the caller returns the refusal from its
  // transaction rather than throwing, so the attempt stays).
  private async useCodeIn(
    tx: Pick<Database['db'], 'select' | 'update'>,
    request: CodeRequest & { code: string },
    phoneHash: string,
    maxAttempts: number,
    now: Date,
  ): Promise<SignInCodeRefusedError | null> {
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
    // An emergency code has no device (W4): the first device that enters
    // it signs in.
    if (
      !code ||
      (code.deviceId !== null && code.deviceId !== request.deviceId) ||
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
    return null;
  }

  private customerRelinked: CustomerRelinked | null = null;

  // AP §8.8 (slice 2.25c): registered by the customers module through
  // `CustomerAccountsService.onRelinked`.
  onCustomerRelinked(listener: CustomerRelinked): void {
    this.customerRelinked = listener;
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
    tx: Tx,
    phone: string,
    phoneHash: string,
    now: Date,
  ): Promise<{ id: string; created: boolean }> {
    // The code row lock serialises sign-ins of one number, so two cannot both
    // create its account. The share lock waits for a closure in progress
    // (slice 2.25c), so the session starts on an open account, or after the
    // closure on a new one, never on the account being closed.
    const [existing] = await tx
      .select({ id: customerAccounts.id })
      .from(customerAccounts)
      .where(and(eq(customerAccounts.phoneHash, phoneHash), eq(customerAccounts.status, 'active')))
      .for('share');
    if (existing) return { id: existing.id, created: false };
    // AP §8.8 (slice 2.25c): the number's latest account, closed, is
    // continued: the new one joins its line, and its dues move over. A line
    // that already has an open account (its customer moved to another number
    // with «تغيير الرقم») is that customer's, and the number starts a line
    // of its own (decided by us).
    const [latest] = await tx
      .select({ id: customerAccounts.id, lineageId: customerAccounts.lineageId })
      .from(customerAccounts)
      .where(and(eq(customerAccounts.phoneHash, phoneHash), eq(customerAccounts.status, 'closed')))
      .orderBy(desc(customerAccounts.closedAt))
      .limit(1);
    let closed = latest;
    if (latest) {
      const root = latest.lineageId ?? latest.id;
      const [open] = await tx
        .select({ id: customerAccounts.id })
        .from(customerAccounts)
        .where(
          and(
            or(eq(customerAccounts.id, root), eq(customerAccounts.lineageId, root)),
            eq(customerAccounts.status, 'active'),
          ),
        )
        .limit(1);
      if (open) closed = undefined;
    }
    const [created] = await tx
      .insert(customerAccounts)
      .values({
        phoneEncrypted: this.secrets.encrypt(phone),
        phoneHash,
        lineageId: closed ? (closed.lineageId ?? closed.id) : null,
        createdAt: now,
        updatedAt: now,
      })
      .returning({ id: customerAccounts.id });
    if (!created) throw new Error('the account was not created');
    if (closed) {
      if (this.customerRelinked === null) {
        throw new Error('customers has not registered its relink');
      }
      await this.customerRelinked(tx, { accountId: created.id, closedAccountId: closed.id, now });
    }
    return { id: created.id, created: true };
  }
}
