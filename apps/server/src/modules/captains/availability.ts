import { versionBelow } from '../settings/index.js';

// AP §9.7.5: a captain's account status. Activation is the pipeline's last
// step (AP §9.7.1), so a captain record starts active.
export const captainStatuses = ['active', 'suspended', 'terminated'] as const;
export type CaptainStatus = (typeof captainStatuses)[number];

// What the state of a captain is made of at a moment. Amounts are minor units
// of the city's base currency.
export interface AvailabilityInput {
  status: CaptainStatus;
  // While suspended: the reason shown to the captain and the end, if any.
  suspension: { reason: string; until: Date | null } | null;
  // The start of the open online period; null while offline.
  onlineSince: Date | null;
  // The positive custody positions in base (AP §8.5.3).
  custodyUsage: bigint;
  custodyLimit: bigint;
  // AP §8.5.4, counted at lastCutoff.
  closedDue: bigint;
  remitTolerance: bigint;
  lastCutoff: Date;
  remitOnlineGraceHours: number;
  appVersion: string | null;
  // app.captain.min_version; null for none.
  minVersion: string | null;
  simulatedLocation: boolean;
  // K7: the captain has not accepted the terms in force. Known only when
  // going online, the one moment it blocks (CA §7.2).
  termsPending: boolean;
  // CA §7.1: the captain has an active order (AP §9.12.6: no stacking in V1).
  activeOrder: boolean;
  // CA §7.3, §7.6, K18: the open online period's last-order mode, or null.
  lastOrder: LastOrderMode | null;
}

// CA §7.3, §7.6, K18: who put the captain in last-order mode. The captain
// asked («لا أريد طلبات جديدة»), operations forced them offline with a
// reason, or a suspension or termination came during an order.
export const lastOrderBy = ['captain', 'forced', 'suspended', 'terminated'] as const;
export type LastOrderBy = (typeof lastOrderBy)[number];
// reason: operations' reason of a force offline, null otherwise.
export interface LastOrderMode {
  by: LastOrderBy;
  reason: string | null;
}

// CA §7.2: a reason the «متصل» switch is refused, in the table's order.
export type OnlineBlock =
  | { kind: 'suspended'; reason: string; until: Date | null }
  | { kind: 'contract_ended' }
  | { kind: 'closed_due'; amount: bigint; cutoff: Date }
  | { kind: 'cash_limit'; limit: bigint }
  | { kind: 'terms_not_accepted' }
  | { kind: 'version_below_minimum'; minVersion: string }
  | { kind: 'simulated_location' };

// CA §7.1, §7.2: why an online captain gets no offers.
export type NoOffersReason = 'cash_limit' | 'closed_due' | 'simulated_location';

// CA §7.1.
export type Availability =
  | { state: 'offline' }
  | { state: 'online_available'; since: Date }
  // «مشغول»: an active order; no offers in V1 (no stacking, AP §9.12.6).
  | { state: 'busy'; since: Date }
  // «آخر طلب» (CA §7.3, K18): no offers, offline once no order is left. The
  // reason shown: a force offline's, or a suspension's.
  | { state: 'last_order'; since: Date; by: LastOrderBy; reason: string | null }
  | { state: 'not_receiving_offers'; since: Date; reasons: NoOffersReason[] }
  | { state: 'suspended'; reason: string; until: Date | null };

function suspendedAt(input: AvailabilityInput, now: Date) {
  const { suspension } = input;
  if (input.status !== 'suspended' || suspension === null) return null;
  return suspension.until === null || now < suspension.until ? suspension : null;
}

// Every block that refuses going online now, so the app shows each (CA §7.2).
// Required documents (K6) join with their slice.
export function onlineBlocks(input: AvailabilityInput, now: Date): OnlineBlock[] {
  const blocks: OnlineBlock[] = [];
  if (input.status === 'terminated') return [{ kind: 'contract_ended' }];
  const suspension = suspendedAt(input, now);
  if (suspension !== null) {
    blocks.push({ kind: 'suspended', reason: suspension.reason, until: suspension.until });
  }
  if (input.closedDue > input.remitTolerance) {
    blocks.push({ kind: 'closed_due', amount: input.closedDue, cutoff: input.lastCutoff });
  }
  if (input.custodyUsage >= input.custodyLimit) {
    blocks.push({ kind: 'cash_limit', limit: input.custodyLimit });
  }
  if (input.termsPending) blocks.push({ kind: 'terms_not_accepted' });
  if (
    input.minVersion !== null &&
    (input.appVersion === null || versionBelow(input.appVersion, input.minVersion))
  ) {
    blocks.push({ kind: 'version_below_minimum', minVersion: input.minVersion });
  }
  if (input.simulatedLocation) blocks.push({ kind: 'simulated_location' });
  return blocks;
}

// The captain's state now (CA §7.1, §7.2 "already online when a block
// starts"). A captain online when the cutoff passed keeps offers for
// captain.remit_online_grace_hours (AP §8.5.4); the version and terms apply
// only the next time they go online.
//
// Last-order mode (CA §7.3, K18) holds while the captain is online: with an
// order, a suspension or termination too keeps tracking until it ends; once
// no order is left, the mode stays until the online period ends, and is
// never offered.
export function availability(input: AvailabilityInput, now: Date): Availability {
  const suspension = suspendedAt(input, now);
  const since = input.onlineSince;
  const mode = input.lastOrder;
  if (
    since !== null &&
    mode !== null &&
    (input.activeOrder || (suspension === null && input.status !== 'terminated'))
  ) {
    const reason = mode.by === 'suspended' ? (suspension?.reason ?? null) : mode.reason;
    return { state: 'last_order', since, by: mode.by, reason };
  }
  if (suspension !== null) {
    return { state: 'suspended', reason: suspension.reason, until: suspension.until };
  }
  if (input.status === 'terminated' || since === null) return { state: 'offline' };
  if (input.activeOrder) return { state: 'busy', since };
  const reasons: NoOffersReason[] = [];
  if (input.custodyUsage >= input.custodyLimit) reasons.push('cash_limit');
  if (input.closedDue > input.remitTolerance) {
    const graceEnds = input.lastCutoff.getTime() + input.remitOnlineGraceHours * 3_600_000;
    if (since >= input.lastCutoff || now.getTime() >= graceEnds) reasons.push('closed_due');
  }
  if (input.simulatedLocation) reasons.push('simulated_location');
  return reasons.length === 0
    ? { state: 'online_available', since }
    : { state: 'not_receiving_offers', since, reasons };
}
