import { and, eq, isNull } from 'drizzle-orm';
import type { Database } from '../../database/database.js';
import type { AdminPermission } from './permissions.js';
import { adminAccountRoles, adminRolePermissions } from './schema.js';

export interface AdminAccess {
  // Sorted, such as ['FIN', 'OPS'].
  roles: string[];
  // The union of the roles' permissions (AP §6.1).
  permissions: AdminPermission[];
}

// The roles an account holds now and the union of their permissions.
export async function accountAccess(
  executor: Pick<Database['db'], 'select'>,
  accountId: string,
): Promise<AdminAccess> {
  const rows = await executor
    .select({ role: adminAccountRoles.roleCode, permission: adminRolePermissions.permissionCode })
    .from(adminAccountRoles)
    .leftJoin(adminRolePermissions, eq(adminRolePermissions.roleCode, adminAccountRoles.roleCode))
    .where(and(eq(adminAccountRoles.accountId, accountId), isNull(adminAccountRoles.revokedAt)));
  const roles = [...new Set(rows.map((row) => row.role))].sort();
  const permissions = [
    ...new Set(rows.flatMap((row) => (row.permission ? [row.permission] : []))),
  ].sort() as AdminPermission[];
  return { roles, permissions };
}

// Owner decision 2026-11-05: the audit records every role the actor held when
// it acted, sorted and joined, such as FIN,OPS.
export function actorRole(roles: readonly string[]): string {
  return [...roles].sort().join(',');
}
