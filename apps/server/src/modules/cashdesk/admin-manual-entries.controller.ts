import { Body, Get, HttpCode, Post, Query, Req } from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { phoneOf } from '../../http/phone-search.js';
import { deskUser, refusalsAsHttp } from './desk-http.js';
import {
  type AccountEntryView,
  type JournalSummary,
  type ManualEntry,
  ManualEntriesService,
} from './manual-entries.service.js';
import { manualEntryKinds, manualEntryParties } from './schema.js';

const signedMinor = z.string().regex(/^-?\d{1,18}$/);
const currency = z.string().regex(/^[A-Z]{3}$/);
const party = z.enum(manualEntryParties);
const adjustedAccount = z.enum([
  'captain.custody',
  'captain.earnings',
  'merchant.account',
  'customer.dues',
]);
const reason = z.string().trim().min(1).max(500);

// Nested fields are plain strings: the Dart generator misnames an enum inside
// a nested object.
const journalSummary = z.object({
  journalId: z.uuid(),
  type: z.string().describe('The ledger journal type, such as earn.adjustment.'),
  reason: z.string().nullable(),
  createdAt: z.iso.datetime(),
  lines: z.array(
    z.object({
      purpose: z.string().describe('The party account, such as captain.earnings.'),
      currency,
      amount: signedMinor.describe(
        "From the party's view: custody + the captain hands in, earnings + the platform owes them, the restaurant account − it owes, dues + the customer owes.",
      ),
    }),
  ),
  orderId: z.uuid().nullable(),
  orderNumber: z.string().nullable(),
  manualEntryId: z.uuid().nullable().describe('The manual entry that posted it, if one did.'),
});

const entryBody = z.object({
  id: z.uuid(),
  kind: z.enum(manualEntryKinds),
  partyKind: party,
  partyId: z.uuid(),
  partyName: z.string(),
  reason: z.string(),
  adminId: z.uuid(),
  adminName: z.string().nullable(),
  createdAt: z.iso.datetime(),
  journal: journalSummary.describe('The journal the entry posted.'),
  corrects: journalSummary.nullable().describe('A reversal: the journal it cancels.'),
  reversedBy: z
    .object({ journalId: z.uuid(), manualEntryId: z.uuid().nullable(), at: z.iso.datetime() })
    .nullable(),
  reversible: z.boolean(),
});

class AdminManualEntryDto extends createZodDto(entryBody) {}
class AdminManualEntriesDto extends createZodDto(z.object({ entries: z.array(entryBody) })) {}
class AdminManualEntriesQueryDto extends createZodDto(z.object({ cityId: z.uuid() })) {}

class AdminManualAdjustmentDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    party,
    partyId: z.uuid(),
    account: adjustedAccount,
    currency,
    amount: signedMinor.describe("From the party's view, never zero."),
    reason,
  }),
) {}

class AdminManualReversalDto extends createZodDto(
  z.object({ cityId: z.uuid(), journalId: z.uuid(), reason }),
) {}

class AdminManualPartySearchDto extends createZodDto(
  z.object({
    cityId: z.uuid(),
    party,
    q: z
      .string()
      .trim()
      .min(2)
      .max(100)
      .describe('A part of the name (captain, restaurant), or the number (captain, customer).'),
  }),
) {}

class AdminManualPartiesDto extends createZodDto(
  z.object({ parties: z.array(z.object({ id: z.uuid(), name: z.string() })) }),
) {}

class AdminManualAccountQueryDto extends createZodDto(
  z.object({ cityId: z.uuid(), party, partyId: z.uuid(), account: adjustedAccount }),
) {}

class AdminManualAccountDto extends createZodDto(
  z.object({
    partyId: z.uuid(),
    partyName: z.string(),
    balances: z.array(z.object({ currency, amount: signedMinor })),
    currencies: z
      .array(currency)
      .describe('What an adjustment takes: custody any enabled currency, the others the base.'),
    entries: z.array(
      journalSummary.extend({
        reversible: z.boolean(),
        reversed: z.boolean(),
      }),
    ),
  }),
) {}

function summaryBody(summary: JournalSummary) {
  return {
    journalId: summary.journalId,
    type: summary.type,
    reason: summary.reason,
    createdAt: summary.createdAt.toISOString(),
    lines: summary.lines.map((line) => ({
      purpose: line.purpose,
      currency: line.currency,
      amount: line.amount.toString(),
    })),
    orderId: summary.orderId,
    orderNumber: summary.orderNumber?.toString() ?? null,
    manualEntryId: summary.manualEntryId,
  };
}

function entryBodyOf(entry: ManualEntry) {
  return {
    id: entry.id,
    kind: entry.kind,
    partyKind: entry.party.kind,
    partyId: entry.party.id,
    partyName: entry.party.name,
    reason: entry.reason,
    adminId: entry.admin.id,
    adminName: entry.admin.name,
    createdAt: entry.createdAt.toISOString(),
    journal: summaryBody(entry.journal),
    corrects: entry.corrects ? summaryBody(entry.corrects) : null,
    reversedBy: entry.reversedBy
      ? {
          journalId: entry.reversedBy.journalId,
          manualEntryId: entry.reversedBy.manualEntryId,
          at: entry.reversedBy.at.toISOString(),
        }
      : null,
    reversible: entry.reversible,
  };
}

function accountEntryBody(entry: AccountEntryView) {
  return { ...summaryBody(entry), reversible: entry.reversible, reversed: entry.reversed };
}

// AP §9.10.7 «القيود التصحيحية» (slice 2.20c), OWN and FIN
// (`ledger.manual_adjustment`): a manual entry on a party's account, the
// reversal of an existing journal, and the list of every manual entry.
@AdminController('manual-entries')
export class AdminManualEntriesController {
  constructor(private readonly entries: ManualEntriesService) {}

  // Every manual entry of the city, newest first: who, when, why and what it
  // corrects.
  @Get()
  @RequirePermission('ledger.manual_adjustment')
  @ZodResponse({ status: 200, type: AdminManualEntriesDto })
  async list(@Query() query: AdminManualEntriesQueryDto) {
    const found = await this.entries.list(query.cityId);
    return { entries: found.map(entryBodyOf) };
  }

  // A manual entry on one account of one party, against «القيود التصحيحية».
  // Refused 400 reason_required, invalid_amounts (zero), invalid_currency,
  // invalid_account (an account the party has not);
  // 404 unknown_party; 409 no_base_currency.
  @Post()
  @RequirePermission('ledger.manual_adjustment')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminManualEntryDto })
  adjust(
    @Body() body: AdminManualAdjustmentDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      entryBodyOf(
        await this.entries.adjust(
          deskUser(session, request),
          {
            idempotencyKey,
            cityId: body.cityId,
            party: body.party,
            partyId: body.partyId,
            account: body.account,
            currency: body.currency,
            amount: BigInt(body.amount),
            reason: body.reason,
          },
          new Date(),
        ),
      ),
    );
  }

  // The reversal of an existing journal, linked to it, once. Refused 404
  // unknown_journal; 409 already_reversed, not_reversible (a reversal, or a
  // journal of an order or a receipt).
  @Post('reversals')
  @RequirePermission('ledger.manual_adjustment')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminManualEntryDto })
  reverse(
    @Body() body: AdminManualReversalDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () =>
      entryBodyOf(
        await this.entries.reverse(
          deskUser(session, request),
          { idempotencyKey, cityId: body.cityId, journalId: body.journalId, reason: body.reason },
          new Date(),
        ),
      ),
    );
  }

  // The party: a captain by a part of the name or the number, a restaurant
  // by a part of the name, a customer by the number. A read sent as a POST so
  // a number never sits in a URL; no Idempotency-Key.
  @Post('parties/search')
  @RequirePermission('ledger.manual_adjustment')
  @HttpCode(200)
  @ZodResponse({ status: 200, type: AdminManualPartiesDto })
  async findParties(@Body() body: AdminManualPartySearchDto) {
    const found = await this.entries.findParties(
      body.cityId,
      body.party,
      { text: body.q, phone: phoneOf(body.q) },
      new Date(),
    );
    return { parties: found.map(({ id, name }) => ({ id, name })) };
  }

  // One account of the party: its balance per currency and its latest
  // entries, each saying whether it may be reversed. 404 unknown_party.
  @Get('account')
  @RequirePermission('ledger.manual_adjustment')
  @ZodResponse({ status: 200, type: AdminManualAccountDto })
  account(@Query() query: AdminManualAccountQueryDto) {
    return refusalsAsHttp(async () => {
      const found = await this.entries.account(
        query.cityId,
        query.party,
        query.partyId,
        query.account,
        new Date(),
      );
      return {
        partyId: found.party.id,
        partyName: found.party.name,
        balances: found.balances.map((each) => ({
          currency: each.currency,
          amount: each.amount.toString(),
        })),
        entries: found.entries.map(accountEntryBody),
        currencies: found.currencies,
      };
    });
  }
}
