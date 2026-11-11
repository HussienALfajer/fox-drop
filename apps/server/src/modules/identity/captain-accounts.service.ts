import { Inject, Injectable } from '@nestjs/common';
import { and, eq, isNull, ne, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { type AuditActor, type AuditRequestContext, AuditService } from '../audit/index.js';
import { CaptainsService } from '../captains/index.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import { appSessions, captainAccounts } from './schema.js';
import { IDENTITY_SECRETS, IdentitySecrets } from './secrets.js';

// Why a captain cannot sign in (CA §4.9): the number belongs to no captain, or
// the captain's contract ended. A suspended captain signs in and sees why.
export type CaptainSignInRefusal = 'not_registered' | 'contract_ended';

export class CaptainSignInRefusedError extends Error {
  // active_order_elsewhere: the captain has an active order and is signed in
  // on another device (CA §4.9), which OWN or OPS release first (AP §9.7.5).
  constructor(readonly refusal: CaptainSignInRefusal | 'active_order_elsewhere') {
    super(`captain sign-in refused: ${refusal}`);
  }
}

export class CaptainAccountRefusedError extends Error {
  constructor(
    readonly refusal: 'unknown_captain' | 'phone_taken' | 'account_exists' | 'invalid_account',
    message: string,
  ) {
    super(message);
  }
}

export interface CaptainAccount {
  id: string;
  captainId: string;
}

type Executor = Pick<Database['db'], 'select'>;

// The captains' sign-in accounts (CA §4.9): one number per captain record,
// never created by sign-in.
@Injectable()
export class CaptainAccountsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(IDENTITY_SECRETS) private readonly secrets: IdentitySecrets,
    private readonly captains: CaptainsService,
    private readonly audit: AuditService,
  ) {}

  // The number a captain signs in with (OPS and the seed so far). A number
  // belongs to one captain, and a captain has one number.
  async addAccount(
    captainId: string,
    phone: string,
    change: { actor: AuditActor; context: AuditRequestContext },
    now = new Date(),
  ): Promise<string> {
    if (!APP_PHONE_PATTERN.test(phone)) {
      throw new CaptainAccountRefusedError(
        'invalid_account',
        'a captain signs in with a Syrian or Turkish mobile in E.164',
      );
    }
    const captain = await this.captains.captain(captainId, now);
    if (!captain) throw new CaptainAccountRefusedError('unknown_captain', 'no such captain');
    const phoneHash = this.secrets.phoneHash(phone);
    return this.database.db.transaction(async (tx) => {
      // The unique indexes refuse a second account; the locks turn that into
      // a refusal instead of an error.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.captain_phone:${phoneHash}`}, 0))`,
      );
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`identity.captain:${captainId}`}, 0))`,
      );
      const [taken] = await tx
        .select({ id: captainAccounts.id })
        .from(captainAccounts)
        .where(eq(captainAccounts.phoneHash, phoneHash));
      if (taken) {
        throw new CaptainAccountRefusedError('phone_taken', 'the number belongs to a captain');
      }
      const [existing] = await tx
        .select({ id: captainAccounts.id })
        .from(captainAccounts)
        .where(eq(captainAccounts.captainId, captainId));
      if (existing) {
        throw new CaptainAccountRefusedError('account_exists', 'the captain has a number');
      }
      const [created] = await tx
        .insert(captainAccounts)
        .values({
          cityId: captain.cityId,
          captainId,
          phoneEncrypted: this.secrets.encrypt(phone),
          phoneHash,
        })
        .returning({ id: captainAccounts.id });
      if (!created) throw new Error('the account was not created');
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: captain.cityId,
          action: 'captain_account.create',
          target: { type: 'captain_account', id: created.id },
          before: null,
          after: { captainId },
        },
        tx,
      );
      return created.id;
    });
  }

  // The captain's account, or null.
  async accountOf(captainId: string): Promise<CaptainAccount | null> {
    const [account] = await this.database.db
      .select({ id: captainAccounts.id, captainId: captainAccounts.captainId })
      .from(captainAccounts)
      .where(eq(captainAccounts.captainId, captainId));
    return account ?? null;
  }

  // CA §9.10.1 (slice 2.12b): the captain's number, which the other captain
  // of a handover dials («اتصال»); null without an account.
  async phone(captainId: string): Promise<string | null> {
    const [row] = await this.database.db
      .select({ phoneEncrypted: captainAccounts.phoneEncrypted })
      .from(captainAccounts)
      .where(eq(captainAccounts.captainId, captainId));
    return row ? this.secrets.decrypt(row.phoneEncrypted) : null;
  }

  // The account a number signs in to, or why it cannot. The code request
  // answers the refusal before sending anything (architecture §8.3.3 sends
  // codes to real users only); the sign-in checks it again. Read outside any
  // transaction, since the captain's status takes a pool connection of its
  // own.
  async signInAccount(
    phoneHash: string,
    now: Date,
  ): Promise<CaptainAccount | CaptainSignInRefusal> {
    const [account] = await this.database.db
      .select({ id: captainAccounts.id, captainId: captainAccounts.captainId })
      .from(captainAccounts)
      .where(eq(captainAccounts.phoneHash, phoneHash));
    if (!account) return 'not_registered';
    return (await this.refusal(account, now)) ?? account;
  }

  async account(executor: Executor, accountId: string): Promise<CaptainAccount | null> {
    const [account] = await executor
      .select({ id: captainAccounts.id, captainId: captainAccounts.captainId })
      .from(captainAccounts)
      .where(eq(captainAccounts.id, accountId));
    return account ?? null;
  }

  // CA §4.9 «During an active order»: the captain cannot sign in on a second
  // device by themselves while they have an active order and another device
  // is still signed in; the same device may sign in again. Read in the
  // sign-in's transaction.
  async activeOrderElsewhere(
    executor: Executor,
    account: CaptainAccount,
    deviceId: string,
  ): Promise<boolean> {
    const [other] = await executor
      .select({ id: appSessions.id })
      .from(appSessions)
      .where(
        and(
          eq(appSessions.party, 'captain'),
          eq(appSessions.accountId, account.id),
          ne(appSessions.deviceId, deviceId),
          isNull(appSessions.endedAt),
        ),
      )
      .limit(1);
    return other !== undefined && (await this.captains.hasActiveOrder(account.captainId, executor));
  }

  // Whether the account may still sign in, refresh and call the routes: a
  // terminated captain's sessions end with the contract (CA §4.9).
  async mayUse(account: CaptainAccount, now: Date): Promise<boolean> {
    return (await this.refusal(account, now)) === null;
  }

  private async refusal(account: CaptainAccount, now: Date): Promise<CaptainSignInRefusal | null> {
    const captain = await this.captains.captain(account.captainId, now);
    if (captain === null) return 'not_registered';
    return captain.status === 'terminated' ? 'contract_ended' : null;
  }
}
