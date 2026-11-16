import { Injectable } from '@nestjs/common';
import { FxService } from '../fx/index.js';
import { AdminSessionsService } from '../identity/index.js';
import { type ActorType, LedgerService } from '../ledger/index.js';
import { type MerchantReceipt, MerchantSettlementService } from './merchant-settlement.service.js';
import { statementStatuses, type StatementStatus } from './merchant-statement.js';
import {
  MerchantStatementsService,
  type MerchantStatementView,
} from './merchant-statements.service.js';

// The receipts the restaurant app lists (decided by us: the latest, as the
// captain's; a few a week is a year of them).
export const MERCHANT_RECEIPTS = 100;

export interface MerchantStatementRow {
  id: string;
  cutoff: Date;
  periodFrom: Date | null;
  currency: string;
  weekTotal: bigint;
  totalDue: bigint;
  status: StatementStatus | null;
  unpaid: bigint;
}

// «من قرّر» on an exception (RA §12.5): who posted its journal, an admin by
// name; null on an order line or a payment.
export interface Decider {
  type: ActorType;
  name: string | null;
}

export type MerchantStatementRead = Omit<MerchantStatementView, 'lines'> & {
  lines: (MerchantStatementView['lines'][number] & { decidedBy: Decider | null })[];
};

// RA §12.3–12.5 (slice 2.19e): «الكشوف» and «الإيصالات» in the restaurant
// app, the restaurant's own only.
@Injectable()
export class MerchantRecordsService {
  constructor(
    private readonly statements: MerchantStatementsService,
    private readonly settlements: MerchantSettlementService,
    private readonly ledger: LedgerService,
    private readonly fx: FxService,
    private readonly admins: AdminSessionsService,
  ) {}

  // The latest statements (a year), newest first, each with its status.
  async statementList(restaurantId: string, cityId: string): Promise<MerchantStatementRow[]> {
    const currency = await this.fx.baseCurrency(cityId);
    const accounts = await this.ledger.ownerAccounts(cityId, restaurantId, 'merchant.account');
    // A statement is taken only from entries, so no account means none.
    const account = accounts.find((each) => each.currency === currency);
    if (!account) return [];
    const { statements, unpaid } = await this.statements.standing(restaurantId, account.id);
    const statuses = statementStatuses(statements, unpaid);
    return statements.map((statement) => ({
      id: statement.id,
      cutoff: statement.cutoff,
      periodFrom: statement.periodFrom,
      currency: statement.currency,
      weekTotal: statement.weekTotal,
      totalDue: statement.totalDue,
      status: statuses.get(statement.id)?.status ?? null,
      unpaid: statuses.get(statement.id)?.unpaid ?? 0n,
    }));
  }

  // One statement, null when it is another restaurant's or unknown.
  async statement(
    restaurantId: string,
    statementId: string,
  ): Promise<MerchantStatementRead | null> {
    const found = await this.statements.statement(statementId);
    if (!found || found.restaurantId !== restaurantId) return null;
    const exceptions = found.lines.flatMap((line) =>
      line.kind === 'exception' ? [line.journalId] : [],
    );
    const actors = await this.ledger.journalActors(exceptions);
    const names = await this.admins.names(
      [...actors.values()].flatMap((actor) =>
        actor.type === 'admin' && actor.id !== null ? [actor.id] : [],
      ),
    );
    return {
      ...found,
      lines: found.lines.map((line) => {
        const actor = line.kind === 'exception' ? actors.get(line.journalId) : undefined;
        return {
          ...line,
          decidedBy: actor
            ? {
                type: actor.type,
                name: actor.type === 'admin' && actor.id ? (names.get(actor.id) ?? null) : null,
              }
            : null,
        };
      }),
    };
  }

  async receipts(restaurantId: string): Promise<MerchantReceipt[]> {
    return this.settlements.restaurantReceipts(restaurantId, MERCHANT_RECEIPTS);
  }

  // One receipt, null when it is another restaurant's or unknown.
  async receipt(restaurantId: string, receiptId: string): Promise<MerchantReceipt | null> {
    const found = await this.settlements.receipt(receiptId);
    return found && found.restaurantId === restaurantId ? found : null;
  }
}
