import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { ApplicationPipelineService } from './application-pipeline.service.js';
import { contractPhases } from './schema.js';

const money = z.object({ amount: z.string().regex(/^\d+$/), currency: z.string().length(3) });

class CaptainContractDto extends createZodDto(
  z.object({
    contract: z
      .object({
        signedOn: z.iso.date(),
        startsOn: z.iso.date(),
        probationEndsOn: z.iso.date(),
        commitmentStartsOn: z.iso.date(),
        commitmentEndsOn: z.iso.date(),
        probationConfirmed: z.boolean(),
        phase: z.enum(contractPhases),
      })
      .nullable()
      .describe('Null for a captain who joined before the contracts.'),
    kit: z
      .array(z.object({ label: z.string(), size: z.string().nullable(), quantity: z.int() }))
      .describe('The items issued, with their labels as issued.'),
    deposit: z.object({
      amount: money.nullable(),
      paid: z.string().regex(/^\d+$/).describe("Minor units in the city's base."),
      instalment: money.nullable().describe('Deducted each Thursday until paid; null for none.'),
    }),
  }),
) {}

// CA §12.3–12.4 (slice 2.35a): «العقد» and «العدة والتأمين» on the profile:
// the contract's phase and dates, the kit issued, the deposit paid and its
// instalments. The app reads it on opening the profile and on a contract
// phase push.
@CaptainController('contract')
export class CaptainContractController {
  constructor(private readonly pipeline: ApplicationPipelineService) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainContractDto })
  async contract(@CurrentAppSession() session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    const found = await this.pipeline.captainContract(session.captain.captainId, new Date());
    const contract = found?.contract ?? null;
    const deposit = found?.deposit ?? null;
    const moneyOf = (value: { amount: bigint; currency: string } | null) =>
      value && { amount: value.amount.toString(), currency: value.currency };
    return {
      contract: contract && {
        signedOn: contract.signedOn,
        startsOn: contract.startsOn,
        probationEndsOn: contract.probationEndsOn,
        commitmentStartsOn: contract.commitmentStartsOn,
        commitmentEndsOn: contract.commitmentEndsOn,
        probationConfirmed: contract.probationConfirmedOn !== null,
        phase: contract.phase,
      },
      kit: (found?.kit?.items ?? []).map((item) => ({
        label: item.label,
        size: item.size,
        quantity: item.quantity,
      })),
      deposit: {
        amount: moneyOf(deposit?.amount ?? null),
        paid: (deposit?.paid ?? 0n).toString(),
        instalment: moneyOf(deposit?.instalment ?? null),
      },
    };
  }
}
