import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { desc, eq, inArray, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { CaptainsService } from '../captains/index.js';
import { CustomersService } from '../customers/index.js';
import { FxService } from '../fx/index.js';
import {
  AdminSessionsService,
  CaptainAccountsService,
  CustomerAccountsService,
} from '../identity/index.js';
import {
  type AccountPurpose,
  type JournalRecord,
  type JournalType,
  LedgerService,
} from '../ledger/index.js';
import { MerchantsService } from '../merchants/index.js';
import { OrdersService } from '../ordering/index.js';
import {
  CashDeskRefusedError,
  CashDeskService,
  type DeskUser,
  keepKey,
} from './cashdesk.service.js';
import { type ManualEntryKind, type ManualEntryParty, manualEntries } from './schema.js';

// AP §9.10.7 «القيود التصحيحية» (slice 2.20c): the accounts a manual entry
// may reach, per party, and the journal type of each.
export const partyAccounts = {
  captain: ['captain.custody', 'captain.earnings'],
  restaurant: ['merchant.account'],
  customer: ['customer.dues'],
} as const satisfies Record<ManualEntryParty, readonly AccountPurpose[]>;
export type AdjustedAccount = (typeof partyAccounts)[ManualEntryParty][number];

const adjustmentTypes: Record<AdjustedAccount, JournalType> = {
  'captain.custody': 'custody.adjustment',
  'captain.earnings': 'earn.adjustment',
  'merchant.account': 'merchant.adjustment',
  'customer.dues': 'dues.adjustment',
};

// The ledger's sign of each account: a party amount times it is the
// platform's side (the ledger's catalogue, AP §8.5, §8.7, §8.8).
const accountSigns: Record<AdjustedAccount, bigint> = {
  'captain.custody': 1n,
  'captain.earnings': -1n,
  'merchant.account': -1n,
  'customer.dues': 1n,
};

const partyOfAccount: Record<string, ManualEntryParty> = {
  'captain.custody': 'captain',
  'captain.earnings': 'captain',
  'captain.deposit': 'captain',
  'merchant.account': 'restaurant',
  'customer.dues': 'customer',
};

// A journal touching these is the order's or the drawer's own record, which
// its receipt or the order's money settles: a manual reversal would leave the
// order clearing account or a drawer's cash apart from them. Corrected by an
// adjustment instead (decided by us, to confirm with the owner).
const NOT_REVERSIBLE_ON: readonly AccountPurpose[] = [
  'platform.order_clearing',
  'platform.cash',
  'platform.fx_rounding',
];

export const MANUAL_ENTRIES_LISTED = 100;
export const ACCOUNT_ENTRIES_LISTED = 50;

export interface PartyRef {
  kind: ManualEntryParty;
  id: string;
  name: string;
}

// One line of a journal on a party's account, from the party's view (the
// specs' signs: custody + the captain hands in, earnings + the platform owes
// the captain, the restaurant account − the restaurant owes, dues + the
// customer owes).
export interface PartyLine {
  purpose: AccountPurpose;
  currency: string;
  amount: bigint;
}

// What a journal is, for the list's «ما يصحّحه» and an account's entries.
export interface JournalSummary {
  journalId: string;
  type: JournalType;
  reason: string | null;
  createdAt: Date;
  lines: PartyLine[];
  orderId: string | null;
  orderNumber: bigint | null;
  // The manual entry that posted it, when one did.
  manualEntryId: string | null;
}

export interface ManualEntry {
  id: string;
  cityId: string;
  kind: ManualEntryKind;
  party: PartyRef;
  journal: JournalSummary;
  reason: string;
  admin: { id: string; name: string | null };
  createdAt: Date;
  // A reversal: the journal it cancels.
  corrects: JournalSummary | null;
  // The reversal of this entry's journal, by a manual entry or otherwise.
  reversedBy: { journalId: string; manualEntryId: string | null; at: Date } | null;
  reversible: boolean;
}

export interface AccountEntryView extends JournalSummary {
  reversible: boolean;
  reversed: boolean;
}

export interface AdjustCommand {
  idempotencyKey: string;
  cityId: string;
  party: ManualEntryParty;
  partyId: string;
  account: AdjustedAccount;
  currency: string;
  // From the party's view, never zero.
  amount: bigint;
  reason: string;
}

export interface ReverseCommand {
  idempotencyKey: string;
  cityId: string;
  journalId: string;
  reason: string;
}

type Tx = Parameters<Parameters<Database['db']['transaction']>[0]>[0];

// AP §9.10.7: OWN and FIN post a manual entry on a party's account against
// platform.adjustments, or reverse an existing journal, each with a reason;
// the list shows who, when, why and what each corrects. Nothing is deleted:
// the journals and the rows are append-only.
@Injectable()
export class ManualEntriesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
    private readonly ledger: LedgerService,
    private readonly captains: CaptainsService,
    private readonly merchants: MerchantsService,
    private readonly captainAccounts: CaptainAccountsService,
    private readonly customerAccounts: CustomerAccountsService,
    private readonly customers: CustomersService,
    private readonly fx: FxService,
    private readonly admins: AdminSessionsService,
    private readonly orders: OrdersService,
    private readonly desk: CashDeskService,
  ) {}

  // A manual entry on one account of one party, against platform.adjustments.
  async adjust(user: DeskUser, command: AdjustCommand, now: Date): Promise<ManualEntry> {
    const reason = command.reason.trim();
    if (!reason) throw new CashDeskRefusedError('reason_required', 'an adjustment says why');
    if (command.amount === 0n) {
      throw new CashDeskRefusedError('invalid_amounts', 'an adjustment of zero');
    }
    if (!(partyAccounts[command.party] as readonly string[]).includes(command.account)) {
      throw new CashDeskRefusedError(
        'invalid_currency',
        `${command.party} has no ${command.account}`,
      );
    }
    const requestHash = hashOf(['adjust', command]);
    const replayed = await this.replay(user, command.idempotencyKey, requestHash, now);
    if (replayed) return replayed;

    const party = await this.partyOf(command.cityId, command.party, command.partyId, now);
    await this.checkCurrency(command.cityId, command.account, command.currency);

    const id = await this.database.db.transaction(async (tx) => {
      const again = await this.keyLocked(tx, user, command.idempotencyKey, requestHash, now);
      if (again) return again;
      const [partyAccount, counter] = await Promise.all([
        this.ledger.openAccount(
          {
            cityId: command.cityId,
            purpose: command.account,
            ownerId: command.partyId,
            currency: command.currency,
          },
          tx,
        ),
        this.ledger.openAccount(
          {
            cityId: command.cityId,
            purpose: 'platform.adjustments',
            ownerId: null,
            currency: command.currency,
          },
          tx,
        ),
      ]);
      const platformSide = command.amount * accountSigns[command.account];
      const journalId = await this.ledger.post(
        {
          cityId: command.cityId,
          type: adjustmentTypes[command.account],
          source: null,
          actor: { type: 'admin', id: user.accountId },
          reason,
          entries: [
            { accountId: partyAccount, currency: command.currency, amount: platformSide },
            { accountId: counter, currency: command.currency, amount: -platformSide },
          ],
        },
        tx,
      );
      const entryId = await this.record(tx, user, now, {
        cityId: command.cityId,
        kind: 'adjustment',
        party: command.party,
        partyId: command.partyId,
        journalId,
        reversesJournalId: null,
        reason,
      });
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId: command.cityId,
          action: 'ledger.manual_adjustment',
          target: { type: 'manual_entry', id: entryId },
          before: null,
          after: {
            party: command.party,
            partyId: command.partyId,
            account: command.account,
            currency: command.currency,
            amount: command.amount.toString(),
            journalId,
            reason,
          },
        },
        tx,
      );
      if (command.party === 'captain') await this.captainChanged(tx, party.id, now);
      await keepKey(
        tx,
        user.accountId,
        command.idempotencyKey,
        requestHash,
        [],
        null,
        now,
        entryId,
      );
      return entryId;
    });
    return (await this.entries([id]))[0]!;
  }

  // The reversal of an existing journal on a party's account, linked to it
  // (AP §9.10.7), once.
  async reverse(user: DeskUser, command: ReverseCommand, now: Date): Promise<ManualEntry> {
    const reason = command.reason.trim();
    if (!reason) throw new CashDeskRefusedError('reason_required', 'a reversal says why');
    const requestHash = hashOf(['reverse', command]);
    const replayed = await this.replay(user, command.idempotencyKey, requestHash, now);
    if (replayed) return replayed;

    const id = await this.database.db.transaction(async (tx) => {
      const again = await this.keyLocked(tx, user, command.idempotencyKey, requestHash, now);
      if (again) return again;
      // Two reversals of one journal take turns, so the second finds it
      // reversed rather than failing on the ledger's unique index.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`ledger.reverse:${command.journalId}`}, 0))`,
      );
      const [journal] = await this.ledger.journalRecords([command.journalId], tx);
      if (!journal || journal.cityId !== command.cityId) {
        throw new CashDeskRefusedError('unknown_journal', `journal ${command.journalId} not found`);
      }
      if (journal.reversedById !== null) {
        throw new CashDeskRefusedError('already_reversed', 'the journal is already reversed');
      }
      const party = partyOfJournal(journal);
      if (!reversible(journal) || party === null) {
        throw new CashDeskRefusedError(
          'not_reversible',
          `a ${journal.type} journal is not reversed here`,
        );
      }
      const journalId = await this.ledger.reverse(
        journal.id,
        { actor: { type: 'admin', id: user.accountId }, reason },
        tx,
      );
      const entryId = await this.record(tx, user, now, {
        cityId: command.cityId,
        kind: 'reversal',
        party: party.kind,
        partyId: party.id,
        journalId,
        reversesJournalId: journal.id,
        reason,
      });
      await this.audit.recordWrite(
        {
          actor: user.actor,
          context: user.context,
          cityId: command.cityId,
          action: 'ledger.reversal',
          target: { type: 'manual_entry', id: entryId },
          before: null,
          after: {
            party: party.kind,
            partyId: party.id,
            reversesJournalId: journal.id,
            reversedType: journal.type,
            journalId,
            reason,
          },
        },
        tx,
      );
      if (party.kind === 'captain') await this.captainChanged(tx, party.id, now);
      await keepKey(
        tx,
        user.accountId,
        command.idempotencyKey,
        requestHash,
        [],
        null,
        now,
        entryId,
      );
      return entryId;
    });
    return (await this.entries([id]))[0]!;
  }

  // Every manual entry of the city, newest first (the latest
  // MANUAL_ENTRIES_LISTED; decided by us).
  async list(cityId: string): Promise<ManualEntry[]> {
    const rows = await this.database.db
      .select({ id: manualEntries.id })
      .from(manualEntries)
      .where(eq(manualEntries.cityId, cityId))
      .orderBy(desc(manualEntries.createdAt), desc(manualEntries.id))
      .limit(MANUAL_ENTRIES_LISTED);
    return this.entries(rows.map((row) => row.id));
  }

  // The parties of a city: a captain by a part of the name or the number,
  // a restaurant by a part of the name, a customer by the number only.
  async findParties(
    cityId: string,
    party: ManualEntryParty,
    query: { text: string; phone: string | null },
    now: Date,
  ): Promise<PartyRef[]> {
    switch (party) {
      case 'captain': {
        if (query.phone !== null) {
          const id = await this.captainAccounts.captainByPhone(query.phone);
          const found = id ? await this.captains.captain(id, now) : null;
          return found && found.cityId === cityId
            ? [{ kind: 'captain', id: found.id, name: found.name }]
            : [];
        }
        const found = await this.captains.findByName(cityId, query.text, 20);
        return found.map(({ id, name }) => ({ kind: 'captain', id, name }));
      }
      case 'restaurant': {
        const text = query.text.toLocaleLowerCase('ar');
        const all = await this.merchants.restaurantIds(cityId);
        return all
          .filter((each) => each.nameAr.toLocaleLowerCase('ar').includes(text))
          .slice(0, 20)
          .map(({ id, nameAr }) => ({ kind: 'restaurant', id, name: nameAr }));
      }
      case 'customer': {
        if (query.phone === null) return [];
        const id = await this.customerAccounts.customerByPhone(query.phone);
        if (id === null) return [];
        const names = await this.customers.firstNames([id]);
        return [{ kind: 'customer', id, name: names.get(id) ?? '' }];
      }
    }
  }

  // One party's account: its balance per currency and its latest entries,
  // each saying whether it may be reversed here.
  async account(
    cityId: string,
    party: ManualEntryParty,
    partyId: string,
    account: AdjustedAccount,
    now: Date,
  ): Promise<{
    party: PartyRef;
    balances: { currency: string; amount: bigint }[];
    entries: AccountEntryView[];
  }> {
    if (!(partyAccounts[party] as readonly string[]).includes(account)) {
      throw new CashDeskRefusedError('invalid_currency', `${party} has no ${account}`);
    }
    const ref = await this.partyOf(cityId, party, partyId, now);
    const accounts = await this.ledger.ownerAccounts(cityId, partyId, account);
    const balances = await Promise.all(accounts.map((each) => this.ledger.balance(each.id)));
    const posted = await this.ledger.accountEntries(
      accounts.map((each) => each.id),
      account,
      ACCOUNT_ENTRIES_LISTED,
    );
    const journals = await this.ledger.journalRecords(posted.map((entry) => entry.journalId));
    const summaries = await this.summaries(journals);
    const seen = new Set<string>();
    const entries: AccountEntryView[] = [];
    for (const entry of posted) {
      if (seen.has(entry.journalId)) continue;
      seen.add(entry.journalId);
      const journal = journals.find((each) => each.id === entry.journalId)!;
      entries.push({
        ...summaries.get(entry.journalId)!,
        reversible: reversible(journal) && journal.reversedById === null,
        reversed: journal.reversedById !== null,
      });
    }
    return {
      party: ref,
      balances: balances.sort((a, b) => a.currency.localeCompare(b.currency)),
      entries,
    };
  }

  // The manual entries by id, in that order, with what they correct.
  async entries(ids: readonly string[]): Promise<ManualEntry[]> {
    if (ids.length === 0) return [];
    const rows = await this.database.db
      .select()
      .from(manualEntries)
      .where(inArray(manualEntries.id, [...ids]));
    const journals = await this.ledger.journalRecords(
      rows.flatMap((row) => [
        row.journalId,
        ...(row.reversesJournalId ? [row.reversesJournalId] : []),
      ]),
    );
    const byJournal = new Map(journals.map((journal) => [journal.id, journal]));
    const reversals = journals.flatMap((journal) =>
      journal.reversedById ? [journal.reversedById] : [],
    );
    const reversalRecords = await this.ledger.journalRecords(reversals);
    const summaries = await this.summaries(journals);
    const names = await this.names(rows);
    return ids.flatMap((id) => {
      const row = rows.find((each) => each.id === id);
      if (!row) return [];
      const journal = byJournal.get(row.journalId)!;
      const reversal = journal.reversedById
        ? reversalRecords.find((each) => each.id === journal.reversedById)
        : undefined;
      return [
        {
          id: row.id,
          cityId: row.cityId,
          kind: row.kind,
          party: {
            kind: row.party,
            id: row.partyId,
            name: names.parties.get(`${row.party}:${row.partyId}`) ?? '',
          },
          journal: summaries.get(row.journalId)!,
          reason: row.reason,
          admin: { id: row.adminAccountId, name: names.admins.get(row.adminAccountId) ?? null },
          createdAt: row.createdAt,
          corrects: row.reversesJournalId ? (summaries.get(row.reversesJournalId) ?? null) : null,
          reversedBy: reversal
            ? {
                journalId: reversal.id,
                manualEntryId: summaries.get(reversal.id)?.manualEntryId ?? null,
                at: reversal.createdAt,
              }
            : null,
          reversible: reversible(journal) && journal.reversedById === null,
        },
      ];
    });
  }

  private async summaries(journals: JournalRecord[]): Promise<Map<string, JournalSummary>> {
    const orderIds = [
      ...new Set(
        journals.flatMap((each) => (each.source?.kind === 'order' ? [each.source.id] : [])),
      ),
    ];
    const ids = journals.map((each) => each.id);
    const [numbers, posted] = await Promise.all([
      this.orders.orderNumbers(orderIds),
      ids.length === 0
        ? Promise.resolve([])
        : this.database.db
            .select({ id: manualEntries.id, journalId: manualEntries.journalId })
            .from(manualEntries)
            .where(inArray(manualEntries.journalId, ids)),
    ]);
    const byJournal = new Map(posted.map((row) => [row.journalId, row.id]));
    return new Map(
      journals.map((journal) => {
        const orderId = journal.source?.kind === 'order' ? journal.source.id : null;
        return [
          journal.id,
          {
            journalId: journal.id,
            type: journal.type,
            reason: journal.reason,
            createdAt: journal.createdAt,
            lines: partyLines(journal),
            orderId,
            orderNumber: orderId ? (numbers.get(orderId) ?? null) : null,
            manualEntryId: byJournal.get(journal.id) ?? null,
          },
        ];
      }),
    );
  }

  private async names(
    rows: { party: ManualEntryParty; partyId: string; adminAccountId: string }[],
  ): Promise<{ parties: Map<string, string>; admins: Map<string, string> }> {
    const of = (kind: ManualEntryParty) => [
      ...new Set(rows.filter((row) => row.party === kind).map((row) => row.partyId)),
    ];
    const [admins, restaurants, customers, captains] = await Promise.all([
      this.admins.names([...new Set(rows.map((row) => row.adminAccountId))]),
      this.merchants.names(of('restaurant')),
      this.customers.firstNames(of('customer')),
      this.captains.names(of('captain')),
    ]);
    const parties = new Map<string, string>();
    for (const [id, name] of captains) parties.set(`captain:${id}`, name);
    for (const [id, name] of restaurants) parties.set(`restaurant:${id}`, name.nameAr);
    for (const [id, name] of customers) parties.set(`customer:${id}`, name);
    return { parties, admins };
  }

  private async partyOf(
    cityId: string,
    party: ManualEntryParty,
    partyId: string,
    now: Date,
  ): Promise<PartyRef> {
    const unknown = () =>
      new CashDeskRefusedError('unknown_party', `${party} ${partyId} is not of the city`);
    switch (party) {
      case 'captain': {
        const found = await this.captains.captain(partyId, now);
        if (!found || found.cityId !== cityId) throw unknown();
        return { kind: party, id: found.id, name: found.name };
      }
      case 'restaurant': {
        const found = await this.merchants.restaurant(partyId, now);
        if (!found || found.cityId !== cityId) throw unknown();
        return { kind: party, id: found.id, name: found.nameAr };
      }
      case 'customer': {
        if (!(await this.customerAccounts.exists(partyId))) throw unknown();
        const names = await this.customers.firstNames([partyId]);
        return { kind: party, id: partyId, name: names.get(partyId) ?? '' };
      }
    }
  }

  // Custody in any enabled currency of the city; earnings, a restaurant's
  // account and a customer's dues in the base only, as their statements and
  // the dues block read them.
  private async checkCurrency(cityId: string, account: AdjustedAccount, currency: string) {
    if (account === 'captain.custody') {
      const enabled = (await this.fx.cityCurrencies(cityId)).filter((each) => each.enabled);
      if (!enabled.some((each) => each.currency === currency)) {
        throw new CashDeskRefusedError(
          'invalid_currency',
          `${currency} is not enabled in the city`,
        );
      }
      return;
    }
    const base = await this.fx.baseCurrency(cityId);
    if (base === null) throw new CashDeskRefusedError('no_base_currency', 'the city has no base');
    if (currency !== base) {
      throw new CashDeskRefusedError('invalid_currency', `${account} is in the base ${base}`);
    }
  }

  private async record(
    tx: Tx,
    user: DeskUser,
    now: Date,
    row: {
      cityId: string;
      kind: ManualEntryKind;
      party: ManualEntryParty;
      partyId: string;
      journalId: string;
      reversesJournalId: string | null;
      reason: string;
    },
  ): Promise<string> {
    const [created] = await tx
      .insert(manualEntries)
      .values({ ...row, adminAccountId: user.accountId, createdAt: now })
      .returning({ id: manualEntries.id });
    return created!.id;
  }

  // The captain's app reads its custody, blocks and earnings again.
  private async captainChanged(tx: Tx, captainId: string, now: Date) {
    const captain = await this.captains.captain(captainId, now);
    if (captain) await this.captains.custodyChanged(tx, captain, now);
  }

  private async replay(
    user: DeskUser,
    key: string,
    requestHash: string,
    now: Date,
  ): Promise<ManualEntry | null> {
    const kept = await this.desk.replay(
      this.database.db,
      user.accountId,
      { idempotencyKey: key },
      requestHash,
      now,
    );
    if (!kept?.manualEntryId) return null;
    return (await this.entries([kept.manualEntryId]))[0] ?? null;
  }

  // The key again under its lock, so a request sent twice at once answers
  // the first one's entry.
  private async keyLocked(
    tx: Tx,
    user: DeskUser,
    key: string,
    requestHash: string,
    now: Date,
  ): Promise<string | null> {
    await tx.execute(
      sql`SELECT pg_advisory_xact_lock(hashtextextended(${`cashdesk.key:${user.accountId}:${key}`}, 0))`,
    );
    const kept = await this.desk.replay(
      tx,
      user.accountId,
      { idempotencyKey: key },
      requestHash,
      now,
    );
    return kept?.manualEntryId ?? null;
  }
}

// The lines of a journal on party accounts, from the party's view.
function partyLines(journal: JournalRecord): PartyLine[] {
  return journal.entries.flatMap((entry) => {
    const sign = signOf(entry.purpose);
    return sign === null
      ? []
      : [{ purpose: entry.purpose, currency: entry.currency, amount: entry.amount * sign }];
  });
}

function signOf(purpose: AccountPurpose): bigint | null {
  if (purpose in accountSigns) return accountSigns[purpose as AdjustedAccount];
  if (purpose === 'captain.deposit') return -1n;
  return null;
}

function partyOfJournal(journal: JournalRecord): { kind: ManualEntryParty; id: string } | null {
  for (const entry of journal.entries) {
    const kind = partyOfAccount[entry.purpose];
    if (kind && entry.ownerId) return { kind, id: entry.ownerId };
  }
  return null;
}

// Not a reversal itself, on a party's account, and touching neither an
// order's clearing nor a drawer's cash.
export function reversible(journal: Pick<JournalRecord, 'reversesJournalId' | 'entries'>): boolean {
  return (
    journal.reversesJournalId === null &&
    journal.entries.some((entry) => entry.purpose in partyOfAccount) &&
    !journal.entries.some((entry) => NOT_REVERSIBLE_ON.includes(entry.purpose))
  );
}

function hashOf(value: unknown): string {
  return createHash('sha256')
    .update(JSON.stringify(value, (_, each) => (typeof each === 'bigint' ? each.toString() : each)))
    .digest('hex');
}
