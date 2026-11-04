import { eq } from 'drizzle-orm';
import type { AuditExecutor, AuditRequestContext, AuditService } from '../audit/index.js';
import type { Database } from '../../database/database.js';
import { adminAccounts } from './schema.js';

type Executor = AuditExecutor & Pick<Database['db'], 'update'>;

// AP §5.1 item 4: a wrong password counts towards the lockout, at sign-in and
// at a TOTP re-enrolment. Called under the account's row lock, so concurrent
// attempts take turns and none is left uncounted. Returns whether it locked.
export async function recordFailedAttempt(
  tx: Executor,
  audit: AuditService,
  account: { id: string; failedAttempts: number; lockedUntil: Date | null },
  limits: { maxAttempts: number; lockoutMinutes: number },
  context: AuditRequestContext,
  now: Date,
): Promise<boolean> {
  const failedAttempts = account.failedAttempts + 1;
  if (failedAttempts < limits.maxAttempts) {
    await tx
      .update(adminAccounts)
      .set({ failedAttempts, updatedAt: now })
      .where(eq(adminAccounts.id, account.id));
    return false;
  }
  const lockedUntil = new Date(now.getTime() + limits.lockoutMinutes * 60_000);
  await tx
    .update(adminAccounts)
    .set({ failedAttempts: 0, lockedUntil, updatedAt: now })
    .where(eq(adminAccounts.id, account.id));
  await audit.recordWrite(
    {
      actor: { type: 'system', id: null, role: null },
      context,
      cityId: null,
      action: 'admin_account.lock',
      target: { type: 'admin_account', id: account.id },
      before: {
        lockedUntil: account.lockedUntil?.toISOString() ?? null,
        failedAttempts: account.failedAttempts,
      },
      after: { lockedUntil: lockedUntil.toISOString(), failedAttempts: 0 },
    },
    tx,
  );
  return true;
}
