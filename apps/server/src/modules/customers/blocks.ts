import type { blockKinds } from './schema.js';

export type BlockKind = (typeof blockKinds)[number];

// AP §9.8 «حظر» as the panel sends it: for a duration (until a moment),
// until further notice, or until dues of a set amount (minor units of the
// city's base) are paid.
export type BlockCommand =
  { kind: 'until'; until: Date } | { kind: 'indefinite' } | { kind: 'dues'; amount: bigint };

// The longest a duration may run: a block for longer is «حتى إشعار آخر»
// (decided by us).
export const BLOCK_MAX_DAYS = 366;

// Why a block command cannot be taken, or null: a duration ends after now
// and within BLOCK_MAX_DAYS, a dues amount is above zero and at most 15
// digits.
export function blockProblem(command: BlockCommand, now: Date): 'invalid_block' | null {
  switch (command.kind) {
    case 'until':
      return command.until.getTime() > now.getTime() &&
        command.until.getTime() <= now.getTime() + BLOCK_MAX_DAYS * 24 * 60 * 60 * 1000
        ? null
        : 'invalid_block';
    case 'indefinite':
      return null;
    case 'dues':
      return command.amount > 0n && command.amount < 10n ** 15n ? null : 'invalid_block';
  }
}

// Whether a block row stops ordering now (CU §5.5): a duration until its
// end, «حتى إشعار آخر» until «فك الحظر». A dues block's row never does: the
// dues balance is that block (docs/domain/08).
export function blockInForce(
  row: { kind: BlockKind; until: Date | null; endedAt: Date | null },
  now: Date,
): boolean {
  if (row.kind === 'dues' || row.endedAt !== null) return false;
  return row.until === null || row.until.getTime() > now.getTime();
}

// AP §9.8 «الحالة»: what the panel and the app show, the first that applies.
// A closed account is «مغلق» whatever else holds (D19, slice 2.25c); a
// manual block before the dues (its own banner names the reason), the dues
// before the review stop (paying them is what the customer can do).
export type AccountStatus = 'active' | 'blocked' | 'dues_unpaid' | 'review_stop' | 'closed';

export function accountStatus(state: {
  closed: boolean;
  blocked: boolean;
  duesOwed: boolean;
  reviewStopped: boolean;
}): AccountStatus {
  if (state.closed) return 'closed';
  if (state.blocked) return 'blocked';
  if (state.duesOwed) return 'dues_unpaid';
  if (state.reviewStopped) return 'review_stop';
  return 'active';
}

// AP §9.8 «name and masked phone»: the country code and the last three
// digits (decided by us), such as «+963 ••• 456».
export { maskedPhone } from '../../phone/masked-phone.js';
