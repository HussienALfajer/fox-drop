import { and, arrayContains, eq, gt, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { AuditService } from '../audit/index.js';
import { adminAccounts, adminSetupLinks } from './schema.js';
import { type IdentitySecrets, newToken, tokenHash } from './secrets.js';

// AP §5.1 item 3: a setup link is valid 24 hours (fixed).
export const SETUP_LINK_HOURS = 24;

// Either or both (owner decision 2026-11-05), already normalised.
export interface AdminName {
  email: string | null;
  phone: string | null;
}

export interface CreatedAccount {
  accountId: string;
  // Shown once, in the setup link; only its hash is stored.
  setupToken: string;
  setupExpiresAt: Date;
  // A new link for the owner that never used the first one.
  reissued: boolean;
}

export class FirstOwnerExistsError extends Error {
  constructor() {
    super('an OWN account already exists');
  }
}

type Dependencies = { db: NodePgDatabase; audit: AuditService; secrets: IdentitySecrets };

// AP §5.3: the first OWN account is created by a server command, never from
// the panel. It stays pending until its setup link is used. Run again with
// the same name while it is pending, the command replaces the link, so a lost
// or expired link does not lock the platform out.
export async function createFirstOwner(
  { db, audit, secrets }: Dependencies,
  name: AdminName,
  now = new Date(),
): Promise<CreatedAccount> {
  if (!name.email && !name.phone) throw new Error('an email or a phone is needed');
  const phoneHash = name.phone && secrets.phoneHash(name.phone);
  return db.transaction(async (tx) => {
    // Two commands at once still make one owner.
    await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtext('identity.first_owner'))`);
    const [owner] = await tx
      .select({
        id: adminAccounts.id,
        status: adminAccounts.status,
        email: adminAccounts.email,
        phoneHash: adminAccounts.phoneHash,
      })
      .from(adminAccounts)
      .where(arrayContains(adminAccounts.roles, ['OWN']))
      .limit(1);
    if (
      owner &&
      (owner.status !== 'pending' || owner.email !== name.email || owner.phoneHash !== phoneHash)
    ) {
      throw new FirstOwnerExistsError();
    }

    let accountId: string;
    if (owner) {
      accountId = owner.id;
      await tx
        .update(adminSetupLinks)
        .set({ expiresAt: now })
        .where(
          and(
            eq(adminSetupLinks.accountId, accountId),
            isNull(adminSetupLinks.usedAt),
            gt(adminSetupLinks.expiresAt, now),
          ),
        );
    } else {
      const [account] = await tx
        .insert(adminAccounts)
        .values({
          email: name.email,
          phoneEncrypted: name.phone && secrets.encrypt(name.phone),
          phoneHash,
          roles: ['OWN'],
          status: 'pending',
          createdAt: now,
          updatedAt: now,
        })
        .returning({ id: adminAccounts.id });
      if (!account) throw new Error('the account was not created');
      accountId = account.id;
    }

    const setupToken = newToken();
    const setupExpiresAt = new Date(now.getTime() + SETUP_LINK_HOURS * 3_600_000);
    await tx.insert(adminSetupLinks).values({
      accountId,
      tokenHash: tokenHash(setupToken),
      expiresAt: setupExpiresAt,
      createdAt: now,
    });
    await audit.recordWrite(
      {
        actor: { type: 'system', id: null, role: null },
        context: { ipAddress: null, device: null },
        cityId: null,
        action: owner ? 'admin_account.setup_link_reissue' : 'admin_account.create',
        target: { type: 'admin_account', id: accountId },
        before: owner ? { status: 'pending' } : null,
        after: {
          roles: ['OWN'],
          status: 'pending',
          hasEmail: name.email !== null,
          hasPhone: name.phone !== null,
          setupLinkExpiresAt: setupExpiresAt.toISOString(),
        },
      },
      tx,
    );
    return { accountId, setupToken, setupExpiresAt, reissued: owner !== undefined };
  });
}
