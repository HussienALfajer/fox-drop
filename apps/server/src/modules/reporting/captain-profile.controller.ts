import { ForbiddenException, Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CaptainController } from '../../http/route-groups.js';
import { ApplicationPipelineService, CaptainsService } from '../captains/index.js';
import { type AppSession, CaptainAccountsService } from '../identity/index.js';
import { vehicles } from '../settings/index.js';

// CA §12.1 «رقم الهوية في FOX DROP» (owner decision 2026-11-19: the
// captain's id shown short). The last 8 hex digits, since a UUIDv7 starts
// with its time and two captains made within a minute would share the first.
export function foxDropId(captainId: string): string {
  return `C-${captainId.replaceAll('-', '').slice(-8).toUpperCase()}`;
}

class CaptainProfileDto extends createZodDto(
  z.object({
    foxDropId: z.string().describe('«رقم الهوية في FOX DROP», the id shown short.'),
    name: z.string(),
    phone: z.string().nullable().describe('The number the captain signs in with.'),
    neighbourhood: z
      .string()
      .nullable()
      .describe("The application's zone; null for a captain the seed made."),
    vehicle: z.enum(vehicles),
    plateNumber: z.string().nullable(),
  }),
) {}

// CA §12.1 (slice 2.36c): the captain's data and vehicle, read-only; a
// change is asked through Support and made by OPS.
@CaptainController('profile')
export class CaptainProfileController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly pipeline: ApplicationPipelineService,
    private readonly accounts: CaptainAccountsService,
  ) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CaptainProfileDto })
  async profile(@CurrentAppSession() session: AppSession) {
    if (session.captain === null) throw new ForbiddenException();
    const { captainId } = session.captain;
    const [captain, phone, neighbourhood] = await Promise.all([
      this.captains.captain(captainId, new Date()),
      this.accounts.phone(captainId),
      this.pipeline.captainNeighbourhood(captainId),
    ]);
    if (!captain) throw new ForbiddenException();
    return {
      foxDropId: foxDropId(captain.id),
      name: captain.name,
      phone,
      neighbourhood,
      vehicle: captain.vehicle,
      plateNumber: captain.plateNumber,
    };
  }
}
