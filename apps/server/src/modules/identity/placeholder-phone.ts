import { and, eq, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { AuditService } from '../audit/index.js';
import { APP_PHONE_PATTERN } from './app-phone.js';
import { captainAccounts, merchantAccounts } from './schema.js';
import type { IdentitySecrets } from './secrets.js';

// Slice 1.14 (owner decision 2026-11-07): the test restaurant owner and the
// test captain of development and staging get the owner's real numbers by a
// server command, never in the repository. The placeholder seed creates them
// with fake numbers and never adds a second account for their role, so the
// change stays. Production changes numbers from the panel (AP §9.6, §9.7), so
// the command refuses there.
export type PlaceholderParty = 'merchant' | 'captain';

export class PlaceholderPhoneRefusedError extends Error {
  constructor(
    readonly refusal: 'invalid_phone' | 'not_found' | 'phone_taken' | 'wrong_environment',
    message: string,
  ) {
    super(message);
  }
}

type Dependencies = { db: NodePgDatabase; audit: AuditService; secrets: IdentitySecrets };

const system = { type: 'system', id: null, role: null } as const;
const noRequest = { ipAddress: null, device: null };

// Moves the account that signs in with `from` to `to`, in one transaction under
// both numbers' advisory locks (the ones addAccount takes), audited without
// either number. Open sessions stay: the same tester holds the account.
export async function changePlaceholderPhone(
  { db, audit, secrets }: Dependencies,
  change: { party: PlaceholderParty; from: string; to: string },
  environment = process.env.FOX_DROP_ENVIRONMENT,
): Promise<{ accountId: string }> {
  if (environment !== 'development' && environment !== 'staging') {
    throw new PlaceholderPhoneRefusedError(
      'wrong_environment',
      'only development and staging change numbers by command',
    );
  }
  if (!APP_PHONE_PATTERN.test(change.from) || !APP_PHONE_PATTERN.test(change.to)) {
    throw new PlaceholderPhoneRefusedError(
      'invalid_phone',
      'both numbers must be Syrian or Turkish mobiles in E.164 (+9639xxxxxxxx or +905xxxxxxxxx)',
    );
  }
  const fromHash = secrets.phoneHash(change.from);
  const toHash = secrets.phoneHash(change.to);
  const lockKey =
    change.party === 'merchant' ? 'identity.merchant_phone' : 'identity.captain_phone';
  return db.transaction(async (tx) => {
    // Sorted, so two commands crossing the same numbers never deadlock.
    for (const hash of [fromHash, toHash].toSorted()) {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`${lockKey}:${hash}`}, 0))`,
      );
    }
    const table = change.party === 'merchant' ? merchantAccounts : captainAccounts;
    const open = (hash: string) =>
      change.party === 'merchant'
        ? and(eq(merchantAccounts.phoneHash, hash), isNull(merchantAccounts.removedAt))
        : eq(captainAccounts.phoneHash, hash);
    const [taken] = await tx.select({ id: table.id }).from(table).where(open(toHash));
    if (taken) {
      throw new PlaceholderPhoneRefusedError(
        'phone_taken',
        'the new number already has an account',
      );
    }
    const [account] = await tx
      .select({ id: table.id, cityId: table.cityId })
      .from(table)
      .where(open(fromHash));
    if (!account) {
      throw new PlaceholderPhoneRefusedError('not_found', 'no account signs in with that number');
    }
    await tx
      .update(table)
      .set({ phoneEncrypted: secrets.encrypt(change.to), phoneHash: toHash })
      .where(eq(table.id, account.id));
    await audit.recordWrite(
      {
        actor: system,
        context: noRequest,
        cityId: account.cityId,
        action: `${change.party}_account.phone_change`,
        target: { type: `${change.party}_account`, id: account.id },
        before: null,
        after: { phone: 'changed by the placeholder phone command' },
      },
      tx,
    );
    return { accountId: account.id };
  });
}
