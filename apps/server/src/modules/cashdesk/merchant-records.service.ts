import { Injectable } from '@nestjs/common';
import { FxService } from '../fx/index.js';
import { LedgerService } from '../ledger/index.js';
import { type MerchantReceipt, MerchantSettlementService } from './merchant-settlement.service.js';
import {
  type StatementLine,
  statementStatuses,
  type StatementStatus,
} from './merchant-statement.js';
import {
  type Decider,
  MerchantStatementReads,
  type MerchantStatementRead,
} from './merchant-statement-reads.js';
import { MerchantStatementsService } from './merchant-statements.service.js';

export type { Decider, MerchantStatementRead };

// The receipts the restaurant app lists (decided by us: the latest, as the
// captain's; a few a week is a year of them).
export const MERCHANT_RECEIPTS = 100;

// The ledger's actor types (AP D27), as «من قرّر» names them.
export const actorTypes = ['admin', 'merchant', 'captain', 'customer', 'system'] as const;

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

// RA §12.3–12.5 (slice 2.19e): «الكشوف» and «الإيصالات» in the restaurant
// app, the restaurant's own only.
@Injectable()
export class MerchantRecordsService {
  constructor(
    private readonly statements: MerchantStatementsService,
    private readonly settlements: MerchantSettlementService,
    private readonly ledger: LedgerService,
    private readonly fx: FxService,
    private readonly reads: MerchantStatementReads,
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
  statement(restaurantId: string, statementId: string): Promise<MerchantStatementRead | null> {
    return this.reads.statement(restaurantId, statementId);
  }

  // «من قرّر» of each exception, shared with «الحساب»'s week.
  deciders(lines: readonly StatementLine[]): Promise<Map<string, Decider>> {
    return this.reads.deciders(lines);
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
