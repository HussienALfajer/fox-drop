import { ForbiddenException, Get, HttpStatus, NotFoundException, Param } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { type Statement, SettlementService } from './settlement.service.js';

// CA §10.7: the statements the list shows (decided by us: the latest, as
// «عهدتي»'s receipts; one a week is a year of them).
export const CAPTAIN_STATEMENTS = 52;

const currency = z.string().length(3);
const minor = z
  .string()
  .regex(/^\d{1,19}$/)
  .describe('Integer minor units (AP §8.6).');
const signedMinor = z
  .string()
  .regex(/^-?\d{1,19}$/)
  .describe('Integer minor units (AP §8.6).');
const payout = z
  .object({ currency, amount: minor })
  .nullable()
  .describe('The cash paid, in the currency the desk paid it.');

class CaptainStatementListDto extends createZodDto(
  z.object({
    statements: z
      .array(
        z.object({
          id: z.uuid(),
          createdAt: z.iso.datetime(),
          periodFrom: z.iso
            .datetime()
            .nullable()
            .describe('The previous payout, null for the first.'),
          currency: currency.describe("The city's base currency."),
          orders: z.int().min(0),
          paid: minor.describe('In the base.'),
          payout,
          collected: minor.describe('A negative balance collected at the desk.'),
          carriedOut: signedMinor.describe('Carried to the next week.'),
        }),
      )
      .describe('Newest first.'),
  }),
) {}

class CaptainStatementDto extends createZodDto(
  z.object({
    id: z.uuid(),
    captainName: z.string(),
    periodFrom: z.iso.datetime().nullable().describe('The previous payout, null for the first.'),
    createdAt: z.iso.datetime(),
    currency: currency.describe("The city's base currency."),
    orders: z.int().min(0),
    basePay: signedMinor.describe('With the minimum top-up and the pay of orders not delivered.'),
    distancePay: minor,
    waitingPay: signedMinor,
    peakBonus: signedMinor,
    bonuses: signedMinor,
    charges: signedMinor.describe('Taken off the balance.'),
    instalments: signedMinor.describe('Taken off the balance.'),
    adjustments: signedMinor,
    carriedIn: signedMinor.describe('The balance the period started from.'),
    balance: signedMinor.describe('Before the payout.'),
    paid: minor.describe('In the base.'),
    payout,
    collected: minor.describe('A negative balance collected at the desk.'),
    carriedOut: signedMinor.describe('Carried to the next week.'),
  }),
) {}

class CaptainStatementParamsDto extends createZodDto(z.object({ statementId: z.uuid() })) {}

// CA §10.7, §14 #20 (slice 2.18c): the weekly statements the desk issued
// (`cashdesk.statements`), the captain's own only.
@CaptainController('statements')
export class CaptainStatementsController {
  constructor(private readonly settlements: SettlementService) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainStatementListDto })
  async list(@CurrentAppSession() session: AppSession) {
    const captainId = captainOf(session);
    const found = await this.settlements.captainStatements(captainId, CAPTAIN_STATEMENTS);
    return {
      statements: found.map((statement) => ({
        id: statement.id,
        createdAt: statement.createdAt.toISOString(),
        periodFrom: statement.periodFrom?.toISOString() ?? null,
        currency: statement.currency,
        orders: statement.orders,
        paid: statement.paid.toString(),
        payout: payoutOf(statement),
        collected: statement.collected.toString(),
        carriedOut: statement.carriedOut.toString(),
      })),
    };
  }

  @Get(':statementId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainStatementDto })
  async read(@CurrentAppSession() session: AppSession, @Param() params: CaptainStatementParamsDto) {
    const statement = await this.settlements.captainStatement(
      captainOf(session),
      params.statementId,
    );
    // Another captain's statement is unknown to this one.
    if (statement === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_statement' });
    }
    return {
      id: statement.id,
      captainName: statement.captainName,
      periodFrom: statement.periodFrom?.toISOString() ?? null,
      createdAt: statement.createdAt.toISOString(),
      currency: statement.currency,
      orders: statement.orders,
      basePay: statement.basePay.toString(),
      distancePay: statement.distancePay.toString(),
      waitingPay: statement.waitingPay.toString(),
      peakBonus: statement.peakBonus.toString(),
      bonuses: statement.bonuses.toString(),
      charges: statement.charges.toString(),
      instalments: statement.instalments.toString(),
      adjustments: statement.adjustments.toString(),
      carriedIn: statement.carriedIn.toString(),
      balance: statement.balance.toString(),
      paid: statement.paid.toString(),
      payout: payoutOf(statement),
      collected: statement.collected.toString(),
      carriedOut: statement.carriedOut.toString(),
    };
  }
}

function captainOf(session: AppSession): string {
  if (session.captain === null) throw new ForbiddenException();
  return session.captain.captainId;
}

function payoutOf(statement: Statement) {
  return (
    statement.payout && {
      currency: statement.payout.currency,
      amount: statement.payout.amount.toString(),
    }
  );
}
