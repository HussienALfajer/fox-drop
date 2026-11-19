import { Injectable } from '@nestjs/common';
import {
  ApplicationPipelineService,
  type CaptainBalance,
  CaptainsService,
  type Custody,
} from '../captains/index.js';
import { DispatchService } from '../dispatch/index.js';
import { CaptainAccountsService } from '../identity/index.js';
import { type CaptainFigures, CaptainFiguresService } from '../ordering/index.js';
import { SettingsService, type Vehicle } from '../settings/index.js';
import { phoneOf } from '../../http/phone-search.js';
import { folded, inTurns } from './list-reads.js';

// AP §9.7.3: the statuses the list shows. «متصل متاح» online (offers or
// not), «مشغول» an active order (last-order mode included), «غير متصل»,
// «موقوف», «محجوب لعدم تسليم النقد» a hand-in block (cash due from a closed
// day with no grace, or the cash limit reached) while not busy, and
// «منتهي» for a terminated captain still holding money (AP §9.10.2).
export const listedCaptainStatuses = [
  'online',
  'busy',
  'offline',
  'suspended',
  'cash_blocked',
  'terminated',
] as const;
export type ListedCaptainStatus = (typeof listedCaptainStatuses)[number];

export interface ListedCaptain extends CaptainFigures {
  id: string;
  name: string;
  phone: string | null;
  vehicle: Vehicle;
  plateNumber: string | null;
  status: ListedCaptainStatus;
  // The latest activated application (the captain's file) and its
  // contract's phase; null for a captain the seed made.
  applicationId: string | null;
  contractPhase: 'probation' | 'commitment' | 'open' | null;
  custody: Custody;
  // captain.earnings in the base: + the platform owes the captain.
  earnings: { amount: bigint; currency: string };
  // Of the last captain.acceptance_window_offers answered; null without one.
  acceptance: { accepted: number; answered: number } | null;
}

// AP §9.7.3 «الكباتن» (slice 2.36a): the city's captains with the columns
// of the list, the money as «أرصدة الكباتن» reads it (every captain not
// terminated, and a terminated one still holding custody or earnings),
// searched by a part of the name or the sign-in number, filtered by the
// listed status. Reads every captain of the city at each call (fine for
// Azaz).
@Injectable()
export class CaptainListService {
  constructor(
    private readonly captains: CaptainsService,
    private readonly pipeline: ApplicationPipelineService,
    private readonly figures: CaptainFiguresService,
    private readonly dispatch: DispatchService,
    private readonly accounts: CaptainAccountsService,
    private readonly settings: SettingsService,
  ) {}

  async list(
    cityId: string,
    filter: { status: ListedCaptainStatus | null; q: string | null },
    now: Date,
  ): Promise<ListedCaptain[]> {
    const phone = filter.q === null ? null : phoneOf(filter.q);
    const [balances, files, byPhone, window] = await Promise.all([
      this.captains.balances(cityId, now),
      this.pipeline.captainFiles(cityId, now),
      phone === null ? null : this.accounts.captainByPhone(phone),
      this.settings.get('captain.acceptance_window_offers', { cityId }),
    ]);
    const typed = filter.q === null || phone !== null ? null : folded(filter.q.trim());
    const searched = balances.filter(
      (balance) =>
        (phone === null || balance.captainId === byPhone) &&
        (typed === null || folded(balance.name).includes(typed)),
    );
    const ids = searched.map((balance) => balance.captainId);
    const [figures, acceptance] = await Promise.all([
      this.figures.ofCaptains(cityId, ids, now),
      this.dispatch.acceptance(ids, window),
    ]);
    const listed = await inTurns(searched, async (balance): Promise<ListedCaptain> => {
      const [captain, state, number] = await Promise.all([
        this.captains.captain(balance.captainId, now),
        balance.status === 'terminated' ? null : this.captains.state(balance.captainId, now),
        this.accounts.phone(balance.captainId),
      ]);
      const file = files.get(balance.captainId) ?? null;
      return {
        id: balance.captainId,
        name: balance.name,
        phone: number,
        vehicle: captain!.vehicle,
        plateNumber: captain!.plateNumber,
        status: listedStatus(balance, state?.availability.state ?? null),
        applicationId: file?.applicationId ?? null,
        contractPhase: file?.phase ?? null,
        custody: balance.custody,
        earnings: balance.earnings,
        acceptance: acceptance.get(balance.captainId) ?? null,
        ...figures.get(balance.captainId)!,
      };
    });
    return filter.status === null
      ? listed
      : listed.filter((captain) => captain.status === filter.status);
  }
}

// AP §9.7.4 «التطبيق»: of the newest offers, the answered ones (accepted,
// declined, expired) that expired in a row from the newest.
export function expiredInRow(newestFirst: readonly { status: string }[]): number {
  const answered = newestFirst.filter(
    (offer) => offer.status !== 'open' && offer.status !== 'withdrawn',
  );
  const first = answered.findIndex((offer) => offer.status !== 'expired');
  return first === -1 ? answered.length : first;
}

// AP §9.7.3: a suspension first, then an order, then a hand-in block.
export function listedStatus(
  balance: Pick<CaptainBalance, 'status' | 'blocks'>,
  availability: string | null,
): ListedCaptainStatus {
  if (balance.status === 'terminated') return 'terminated';
  if (availability === 'suspended') return 'suspended';
  if (availability === 'busy' || availability === 'last_order') return 'busy';
  if (balance.blocks.length > 0) return 'cash_blocked';
  return availability === 'offline' || availability === null ? 'offline' : 'online';
}
