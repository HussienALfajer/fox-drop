import { arrayContains, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { AuditService } from '../audit/index.js';
import { adminAccounts, adminSetupLinks } from './schema.js';
import { type IdentitySecrets, newToken, tokenHash } from './secrets.js';
import type { SignInName } from './sign-in-name.js';

// AP §5.1 item 3: a setup link is valid 24 hours (fixed).
export const SETUP_LINK_HOURS = 24;

export interface CreatedAccount {
  accountId: string;
  // Shown once, in the setup link; only its hash is stored.
  setupToken: string;
  setupExpiresAt: Date;
}

export class FirstOwnerExistsError extends Error {
  constructor() {
    super('an OWN account already exists');
  }
}

// AP §5.3: the first OWN account is created by a server command, never from
// the panel. It stays pending until its setup link is used.
export async function createFirstOwner(
  dependencies: { db: NodePgDatabase; audit: AuditService; secrets: IdentitySecrets },
  name: SignInName,
  now = new Date(),
): Promise<CreatedAccount> {
  const { db, audit, secrets } = dependencies;
  return db.transaction(async (tx) => {
    // Two commands at once still make one owner.
    await tx.execute(sql`SELECT pg_advisory_xact_lock(hashtext('identity.first_owner'))`);
    const owners = await tx
      .select({ id: adminAccounts.id })
      .from(adminAccounts)
      .where(arrayContains(adminAccounts.roles, ['OWN']))
      .limit(1);
    if (owners.length > 0) throw new FirstOwnerExistsError();

    const phone = 'phone' in name ? name.phone : null;
    const [account] = await tx
      .insert(adminAccounts)
      .values({
        email: 'email' in name ? name.email : null,
        phoneEncrypted: phone && secrets.encrypt(phone),
        phoneHash: phone && secrets.phoneHash(phone),
        roles: ['OWN'],
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      })
      .returning({ id: adminAccounts.id });
    if (!account) throw new Error('the account was not created');

    const setupToken = newToken();
    const setupExpiresAt = new Date(now.getTime() + SETUP_LINK_HOURS * 3_600_000);
    await tx.insert(adminSetupLinks).values({
      accountId: account.id,
      tokenHash: tokenHash(setupToken),
      expiresAt: setupExpiresAt,
      createdAt: now,
    });
    await audit.recordWrite(
      {
        actor: { type: 'system', id: null, role: null },
        context: { ipAddress: null, device: null },
        cityId: null,
        action: 'admin_account.create',
        target: { type: 'admin_account', id: account.id },
        before: null,
        after: {
          roles: ['OWN'],
          status: 'pending',
          hasEmail: 'email' in name,
          hasPhone: phone !== null,
          setupLinkExpiresAt: setupExpiresAt.toISOString(),
        },
      },
      tx,
    );
    return { accountId: account.id, setupToken, setupExpiresAt };
  });
}
