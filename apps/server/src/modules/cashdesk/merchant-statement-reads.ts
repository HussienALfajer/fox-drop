import { Injectable } from '@nestjs/common';
import { AdminSessionsService } from '../identity/index.js';
import { type ActorType, LedgerService } from '../ledger/index.js';
import type { StatementLine } from './merchant-statement.js';
import {
  MerchantStatementsService,
  type MerchantStatementView,
} from './merchant-statements.service.js';

// «من قرّر» on an exception (RA §12.5): who posted its journal, an admin by
// name; null on an order line or a payment.
export interface Decider {
  type: ActorType;
  name: string | null;
}

export type MerchantStatementRead = Omit<MerchantStatementView, 'lines'> & {
  lines: (MerchantStatementView['lines'][number] & { decidedBy: Decider | null })[];
};

// RA §12.3, §12.5: one weekly statement of a restaurant with «من قرّر» on
// each exception: the app's and the portal's «الكشوف» (slice 2.19e) and the
// portal's Excel file of it, which the worker writes (slice 2.45d).
@Injectable()
export class MerchantStatementReads {
  constructor(
    private readonly statements: MerchantStatementsService,
    private readonly ledger: LedgerService,
    private readonly admins: AdminSessionsService,
  ) {}

  // One statement, null when it is another restaurant's or unknown.
  async statement(
    restaurantId: string,
    statementId: string,
  ): Promise<MerchantStatementRead | null> {
    const found = await this.statements.statement(statementId, restaurantId);
    if (!found) return null;
    const deciders = await this.deciders(found.lines);
    return {
      ...found,
      lines: found.lines.map((line) => ({
        ...line,
        decidedBy: line.kind === 'exception' ? (deciders.get(line.journalId) ?? null) : null,
      })),
    };
  }

  // «من قرّر» of each exception by its journal (RA §12.5): who posted it, a
  // staff member by name. Shared by the statement and «الحساب»'s week.
  async deciders(lines: readonly StatementLine[]): Promise<Map<string, Decider>> {
    const exceptions = lines.flatMap((line) => (line.kind === 'exception' ? [line.journalId] : []));
    const actors = await this.ledger.journalActors(exceptions);
    const names = await this.admins.names(
      [...actors.values()].flatMap((actor) =>
        actor.type === 'admin' && actor.id !== null ? [actor.id] : [],
      ),
    );
    return new Map(
      [...actors].map(([journalId, actor]) => [
        journalId,
        {
          type: actor.type,
          name: actor.type === 'admin' && actor.id ? (names.get(actor.id) ?? null) : null,
        },
      ]),
    );
  }
}
