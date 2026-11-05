// AP §9.6.1: a restaurant's account status.
export const accountStatuses = ['draft', 'test', 'active', 'suspended', 'terminated'] as const;
export type AccountStatus = (typeof accountStatuses)[number];

// RA §7.1: who paused the restaurant.
export const pauseSources = ['restaurant', 'ops', 'auto'] as const;
export type PauseSource = (typeof pauseSources)[number];

// What the state is computed from at a moment. Each part is the one in
// force, or null: the holiday close and pause that have not ended, the
// opening period of the schedule the moment is in (hours.ts), and busy mode.
export interface OperatingInput {
  accountStatus: AccountStatus;
  holiday: { endsAt: Date } | null;
  period: { endsAt: Date } | null;
  // An operations or auto pause without an end lasts until resumed.
  pause: { source: PauseSource; endsAt: Date | null } | null;
  busyMode: { extraMin: number; endsAt: Date } | null;
  // Orders in placed, accepted or ready (RA §7.4).
  activeOrders: number;
  maxActiveOrders: number | null;
}

export type OperatingState =
  | { state: 'draft' | 'suspended' | 'terminated' }
  | { state: 'holiday'; until: Date }
  | { state: 'closed' }
  | { state: 'paused'; source: PauseSource; until: Date | null }
  | { state: 'busy' }
  | { state: 'open'; busyExtraMin: number | null };

// RA §7.1 precedence: suspended → holiday close → closed by schedule →
// paused (any source) → busy (limit) → open; the first that applies. A draft
// or terminated restaurant takes no orders either (AP §9.6.1). Busy mode is a
// flag that matters only while open.
export function operatingState(input: OperatingInput, now: Date): OperatingState {
  const running = (endsAt: Date | null) => endsAt === null || endsAt.getTime() > now.getTime();
  const { accountStatus } = input;
  if (
    accountStatus === 'draft' ||
    accountStatus === 'suspended' ||
    accountStatus === 'terminated'
  ) {
    return { state: accountStatus };
  }
  if (input.holiday !== null && running(input.holiday.endsAt)) {
    return { state: 'holiday', until: input.holiday.endsAt };
  }
  if (input.period === null) return { state: 'closed' };
  if (input.pause !== null && running(input.pause.endsAt)) {
    return { state: 'paused', source: input.pause.source, until: input.pause.endsAt };
  }
  if (input.maxActiveOrders !== null && input.activeOrders >= input.maxActiveOrders) {
    return { state: 'busy' };
  }
  const busyMode =
    input.busyMode !== null && running(input.busyMode.endsAt) ? input.busyMode : null;
  return { state: 'open', busyExtraMin: busyMode?.extraMin ?? null };
}

// Customers can order only from an open restaurant (RA §7.1).
export function takesOrders(state: OperatingState): boolean {
  return state.state === 'open';
}
