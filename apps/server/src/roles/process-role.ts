// Architecture §4.4: one image, four roles, chosen by PROCESS_ROLE.
export const PROCESS_ROLES = ['api', 'worker', 'dispatcher', 'otp-sender'] as const;
export type ProcessRole = (typeof PROCESS_ROLES)[number];

export function parseProcessRole(value: string | undefined): ProcessRole {
  const role = PROCESS_ROLES.find((candidate) => candidate === value);
  if (!role) {
    throw new Error(
      `PROCESS_ROLE must be one of ${PROCESS_ROLES.join(', ')}; got ${value === undefined ? 'nothing' : `"${value}"`}.`,
    );
  }
  return role;
}
