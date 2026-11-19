import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import {
  ApplicationPipelineService,
  type DepositAwaiting,
  type DepositSettlement,
  type DepositToSettle,
  PipelineRefusedError,
} from '../captains/index.js';
import { formatMoney, NotificationTexts, receiptTypeLabels } from '../content/index.js';
import { FxService } from '../fx/index.js';
import { GeoService } from '../geo/index.js';
import { LedgerService } from '../ledger/index.js';
import { PushQueue } from '../notifications/index.js';
import {
  CashDeskRefusedError,
  CashDeskService,
  cityYear,
  type DeskUser,
  keepKey,
  nextNumber,
  openOf,
  type Receipt,
} from './cashdesk.service.js';
import { drawerSessions, receipts } from './schema.js';

// «تسجيل التأمين» (AP §9.7.1, §6.3, §8.5; owner decision 2026-11-19): the
// deposit's amount and weekly instalment, and the cash paid now.
export interface DepositCommand {
  cityId: string;
  applicationId: string;
  amount: bigint;
  // Deducted each Thursday until the deposit is paid; null for none.
  instalment: bigint | null;
  // The cash received now, in the city's base; 0 records the plan alone.
  paidNow: bigint;
  idempotencyKey: string;
}

// AP §9.7.1 «Record the deposit» (FIN, OWN; slice 2.35a): the desk records
// the deposit of an application at «بانتظار العدة»: the plan on the
// application (the pipeline's `recordDeposit`) and, when cash is paid now,
// a numbered receipt «تأمين العدة» posting deposit.payment (the deposit of
// the captain to be against the drawer's platform.cash, in the base), never
// above what is left to pay. The captain's id is the application's, so the
// receipt and the account are the captain's once activated.
@Injectable()
export class DepositsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly desk: CashDeskService,
    private readonly pipeline: ApplicationPipelineService,
    private readonly ledger: LedgerService,
    private readonly fx: FxService,
    private readonly geo: GeoService,
    private readonly audit: AuditService,
    private readonly texts: NotificationTexts,
    private readonly pushes: PushQueue,
  ) {}

  // The applications at «بانتظار العدة» of the city with their deposit, for
  // the desk's tab.
  awaiting(cityId: string): Promise<DepositAwaiting[]> {
    return this.pipeline.depositsAwaiting(cityId);
  }

  // The cash limit before activation (D10, AP §9.7.1: FIN, OWN), set from
  // the desk so FIN never reads the application's page (slice 2.35a).
  async setCashLimit(
    user: DeskUser,
    applicationId: string,
    limit: { amount: bigint; currency: string },
    now: Date,
  ): Promise<void> {
    await this.pipeline.setCashLimit(applicationId, user, limit, now).catch((error: unknown) => {
      throw deskRefusal(error);
    });
  }

  async record(user: DeskUser, command: DepositCommand, now: Date): Promise<Receipt | null> {
    if (
      command.amount < 0n ||
      command.paidNow < 0n ||
      (command.instalment !== null && command.instalment <= 0n)
    ) {
      throw new CashDeskRefusedError('invalid_amounts', 'amounts are zero or more');
    }
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          deposit: command.applicationId,
          cityId: command.cityId,
          amount: command.amount.toString(),
          instalment: command.instalment?.toString() ?? null,
          paidNow: command.paidNow.toString(),
        }),
      )
      .digest('hex');
    const replayed = await this.desk.replay(
      this.database.db,
      user.accountId,
      command,
      requestHash,
      now,
    );
    if (replayed) return this.answer(replayed.receiptIds);
    const [city, base, currencies] = await Promise.all([
      this.geo.cityCode(command.cityId),
      this.fx.baseCurrency(command.cityId),
      this.fx.currencies(),
    ]);
    if (!city) throw new CashDeskRefusedError('unknown_city', 'no such city');
    if (base === null) throw new CashDeskRefusedError('no_base_currency', 'the city has no base');
    const known = new Map(
      currencies.map((each) => [each.code, { symbol: each.symbol, decimals: each.decimals }]),
    );

    const receiptIds = await this.database.db
      .transaction(async (tx) => {
        let session: typeof drawerSessions.$inferSelect | undefined;
        if (command.paidNow > 0n) {
          [session] = await tx
            .select()
            .from(drawerSessions)
            .where(openOf(user.accountId, 'office'))
            .for('share');
          if (!session) throw new CashDeskRefusedError('no_open_session', 'open the drawer first');
          if (session.cityId !== command.cityId) {
            throw new CashDeskRefusedError('unknown_party', 'the drawer is of another city');
          }
        }
        const application = await this.pipeline.lockForDeposit(tx, command.applicationId);
        if (application.cityId !== command.cityId) {
          throw new CashDeskRefusedError('unknown_party', 'the application is of another city');
        }
        const again = await this.desk.replay(tx, user.accountId, command, requestHash, now);
        if (again) return again.receiptIds;
        const paid = await this.pipeline.depositPaid(application, tx);
        if (paid + command.paidNow > command.amount) {
          throw new CashDeskRefusedError('above_balance', 'more than is left of the deposit');
        }
        await this.pipeline.recordDeposit(
          tx,
          application.id,
          user,
          { amount: { amount: command.amount, currency: base }, instalment: command.instalment },
          now,
        );
        const ids: string[] = [];
        if (session) {
          const year = cityYear(now, city.timeZone);
          const number = await nextNumber(tx, command.cityId, city.code, year);
          const [created] = await tx
            .insert(receipts)
            .values({
              cityId: command.cityId,
              year,
              sequence: number.sequence,
              number: number.number,
              type: 'captain_deposit',
              sessionId: session.id,
              adminAccountId: user.accountId,
              captainId: application.captainId,
              captainName: application.fullName,
              createdAt: now,
            })
            .returning({ id: receipts.id });
          const receiptId = created!.id;
          const line = { currency: base, amount: command.paidNow };
          const [deposit, cash] = await Promise.all([
            this.ledger.openAccount(
              {
                cityId: command.cityId,
                purpose: 'captain.deposit',
                ownerId: application.captainId,
                currency: base,
              },
              tx,
            ),
            this.ledger.openAccount(
              {
                cityId: command.cityId,
                purpose: 'platform.cash',
                ownerId: session.id,
                currency: base,
              },
              tx,
            ),
          ]);
          // From the platform's side: it holds more for the captain (the
          // deposit −) and the drawer holds the cash (+).
          const journalId = await this.ledger.post(
            {
              cityId: command.cityId,
              type: 'deposit.payment',
              source: { kind: 'receipt', id: receiptId },
              actor: { type: 'admin', id: user.accountId },
              entries: [
                { accountId: deposit, currency: base, amount: -command.paidNow },
                { accountId: cash, currency: base, amount: command.paidNow },
              ],
            },
            tx,
          );
          // The line expects what was left to pay before it.
          await this.desk.keepLine(
            tx,
            session.id,
            receiptId,
            line,
            { expected: command.amount - paid },
            journalId,
          );
          await this.audit.recordWrite(
            {
              actor: user.actor,
              context: user.context,
              cityId: command.cityId,
              action: 'cash_desk.receipt',
              target: { type: 'receipt', id: receiptId },
              before: null,
              after: {
                number: number.number,
                type: 'captain_deposit',
                captainId: application.captainId,
                applicationId: application.id,
                sessionId: session.id,
                lines: [
                  {
                    currency: base,
                    expected: (command.amount - paid).toString(),
                    amount: command.paidNow.toString(),
                  },
                ],
              },
            },
            tx,
          );
          // CA §14 #19 «إيصال {رقم}: {النوع} {المبلغ}», to the applicant's
          // devices (no captain yet).
          const templateKey = 'captain.desk_receipt';
          const rendered = await this.texts.render(
            templateKey,
            {
              رقم: number.number,
              النوع: receiptTypeLabels.captain_deposit,
              المبلغ: formatMoney(command.paidNow, base, known),
            },
            tx,
          );
          await this.pushes.enqueue(
            tx,
            [
              {
                source: `cashdesk:receipt:${receiptId}`,
                recipient: { party: 'applicant', accountId: application.accountId },
                templateKey,
                body: rendered.body,
                level: rendered.level,
                priority: rendered.priority,
                data: { target: 'application', receiptId },
                at: now,
              },
            ],
            now,
          );
          ids.push(receiptId);
        }
        await keepKey(tx, user.accountId, command.idempotencyKey, requestHash, ids, null, now);
        return ids;
      })
      .catch((error: unknown) => {
        throw deskRefusal(error);
      });
    return this.answer(receiptIds);
  }

  // «التأمينات» at termination (AP §9.7.5 step 4, §9.10.3; slice 2.35b): the
  // contracts being ended whose deposit is still held.
  toSettle(cityId: string): Promise<DepositToSettle[]> {
    return this.pipeline.depositsToSettle(cityId);
  }

  // The deposit the platform holds, settled as the kit's step says (C17;
  // owner decision 2026-11-19): refunded in cash from the user's open drawer
  // with a receipt «استرداد التأمين» (deposit.refund) when the kit came
  // back, withheld whole to the platform's revenue (deposit.withhold, no
  // cash, no receipt) when it did not. `settlement` is what the desk showed:
  // another one is `409 wrong_settlement`. Answers the receipt, or null.
  async settle(
    user: DeskUser,
    command: {
      cityId: string;
      applicationId: string;
      settlement: DepositSettlement;
      idempotencyKey: string;
    },
    now: Date,
  ): Promise<Receipt | null> {
    const requestHash = createHash('sha256')
      .update(
        JSON.stringify({
          depositSettlement: command.applicationId,
          cityId: command.cityId,
          settlement: command.settlement,
        }),
      )
      .digest('hex');
    const replayed = await this.desk.replay(
      this.database.db,
      user.accountId,
      command,
      requestHash,
      now,
    );
    if (replayed) return this.answer(replayed.receiptIds);
    const [city, base, currencies] = await Promise.all([
      this.geo.cityCode(command.cityId),
      this.fx.baseCurrency(command.cityId),
      this.fx.currencies(),
    ]);
    if (!city) throw new CashDeskRefusedError('unknown_city', 'no such city');
    if (base === null) throw new CashDeskRefusedError('no_base_currency', 'the city has no base');
    const known = new Map(
      currencies.map((each) => [each.code, { symbol: each.symbol, decimals: each.decimals }]),
    );

    const receiptIds = await this.database.db
      .transaction(async (tx) => {
        let session: typeof drawerSessions.$inferSelect | undefined;
        if (command.settlement === 'refunded') {
          [session] = await tx
            .select()
            .from(drawerSessions)
            .where(openOf(user.accountId, 'office'))
            .for('share');
          if (!session) throw new CashDeskRefusedError('no_open_session', 'open the drawer first');
          if (session.cityId !== command.cityId) {
            throw new CashDeskRefusedError('unknown_party', 'the drawer is of another city');
          }
        }
        const contract = await this.pipeline.lockForSettlement(tx, command.applicationId);
        if (contract.cityId !== command.cityId) {
          throw new CashDeskRefusedError('unknown_party', 'the contract is of another city');
        }
        const again = await this.desk.replay(tx, user.accountId, command, requestHash, now);
        if (again) return again.receiptIds;
        if (contract.settlement !== command.settlement) {
          throw new CashDeskRefusedError(
            'wrong_settlement',
            `the deposit is ${contract.settlement}`,
          );
        }
        if (contract.held <= 0n) {
          throw new CashDeskRefusedError('nothing_held', 'the platform holds no deposit');
        }
        const deposit = await this.ledger.openAccount(
          {
            cityId: command.cityId,
            purpose: 'captain.deposit',
            ownerId: contract.captainId,
            currency: base,
          },
          tx,
        );
        const ids: string[] = [];
        if (session) {
          const year = cityYear(now, city.timeZone);
          const number = await nextNumber(tx, command.cityId, city.code, year);
          const [created] = await tx
            .insert(receipts)
            .values({
              cityId: command.cityId,
              year,
              sequence: number.sequence,
              number: number.number,
              type: 'captain_deposit_refund',
              sessionId: session.id,
              adminAccountId: user.accountId,
              captainId: contract.captainId,
              captainName: contract.fullName,
              createdAt: now,
            })
            .returning({ id: receipts.id });
          const receiptId = created!.id;
          const cash = await this.ledger.openAccount(
            {
              cityId: command.cityId,
              purpose: 'platform.cash',
              ownerId: session.id,
              currency: base,
            },
            tx,
          );
          // From the platform's side: it holds less for the captain (the
          // deposit +) and the drawer pays the cash out (−).
          const journalId = await this.ledger.post(
            {
              cityId: command.cityId,
              type: 'deposit.refund',
              source: { kind: 'receipt', id: receiptId },
              actor: { type: 'admin', id: user.accountId },
              entries: [
                { accountId: deposit, currency: base, amount: contract.held },
                { accountId: cash, currency: base, amount: -contract.held },
              ],
            },
            tx,
          );
          // As a reimbursement, the line expects what the platform owes the
          // captain, below zero.
          await this.desk.keepLine(
            tx,
            session.id,
            receiptId,
            { currency: base, amount: contract.held },
            { expected: -contract.held },
            journalId,
          );
          await this.audit.recordWrite(
            {
              actor: user.actor,
              context: user.context,
              cityId: command.cityId,
              action: 'cash_desk.receipt',
              target: { type: 'receipt', id: receiptId },
              before: null,
              after: {
                number: number.number,
                type: 'captain_deposit_refund',
                captainId: contract.captainId,
                applicationId: contract.id,
                sessionId: session.id,
                lines: [
                  {
                    currency: base,
                    expected: (-contract.held).toString(),
                    amount: contract.held.toString(),
                  },
                ],
              },
            },
            tx,
          );
          // CA §14 #19 «إيصال {رقم}: {النوع} {المبلغ}».
          const templateKey = 'captain.desk_receipt';
          const rendered = await this.texts.render(
            templateKey,
            {
              رقم: number.number,
              النوع: receiptTypeLabels.captain_deposit_refund,
              المبلغ: formatMoney(contract.held, base, known),
            },
            tx,
          );
          await this.pushes.enqueue(
            tx,
            [
              {
                source: `cashdesk:receipt:${receiptId}`,
                recipient: { party: 'captain', captainId: contract.captainId },
                templateKey,
                body: rendered.body,
                level: rendered.level,
                priority: rendered.priority,
                data: { target: 'custody', receiptId },
                at: now,
              },
            ],
            now,
          );
          ids.push(receiptId);
        } else {
          const revenue = await this.ledger.openAccount(
            {
              cityId: command.cityId,
              purpose: 'platform.revenue_deposits',
              ownerId: null,
              currency: base,
            },
            tx,
          );
          await this.ledger.post(
            {
              cityId: command.cityId,
              type: 'deposit.withhold',
              source: null,
              actor: { type: 'admin', id: user.accountId },
              entries: [
                { accountId: deposit, currency: base, amount: contract.held },
                { accountId: revenue, currency: base, amount: -contract.held },
              ],
            },
            tx,
          );
        }
        await this.pipeline.recordSettlement(
          tx,
          contract.id,
          user,
          command.settlement,
          { amount: contract.held, currency: base },
          now,
        );
        await keepKey(tx, user.accountId, command.idempotencyKey, requestHash, ids, null, now);
        return ids;
      })
      .catch((error: unknown) => {
        throw deskRefusal(error);
      });
    return this.answer(receiptIds);
  }

  private async answer(receiptIds: readonly string[]): Promise<Receipt | null> {
    if (receiptIds.length === 0) return null;
    return (await this.desk.receiptsOf(receiptIds))[0] ?? null;
  }
}

// The pipeline's refusals in the desk's words.
function deskRefusal(error: unknown): unknown {
  if (!(error instanceof PipelineRefusedError)) return error;
  switch (error.refusal) {
    case 'unknown_application':
      return new CashDeskRefusedError('unknown_party', 'no such application');
    case 'invalid_deposit':
      return new CashDeskRefusedError('invalid_amounts', 'the instalment is above the deposit');
    case 'invalid_cash_limit':
      return new CashDeskRefusedError('invalid_amounts', 'the cash limit is above zero');
    case 'not_in_base_currency':
      return new CashDeskRefusedError('invalid_currency', "in the city's base currency");
    case 'wrong_stage':
      return new CashDeskRefusedError('wrong_stage', `the application is ${error.stage}`);
    case 'not_terminated':
    case 'contract_ended':
    case 'deposit_settled':
    case 'kit_not_checked':
      return new CashDeskRefusedError(error.refusal, 'the offboarding is not at this step');
    default:
      return error;
  }
}
