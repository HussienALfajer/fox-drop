import { Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { PushQueue } from './push-queue.js';

class CustomerNotificationsDto extends createZodDto(
  z.object({
    notifications: z.array(
      z.object({
        id: z.string(),
        at: z.iso.datetime(),
        body: z.string(),
        data: z
          .record(z.string(), z.string())
          .describe('What a tap opens: `target` (order, codes, account) and its ids.'),
      }),
    ),
  }),
) {}

// CU §13 «الإشعارات»: every push the account received in the last 30 days,
// newest first (CU §14: every push is also stored).
@CustomerController('notifications')
export class CustomerNotificationsController {
  constructor(private readonly queue: PushQueue) {}

  @Get()
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerNotificationsDto })
  async list(@CurrentAppSession() session: AppSession) {
    const entries = await this.queue.inbox(session.accountId, new Date());
    return {
      notifications: entries.map((entry) => ({ ...entry, at: entry.at.toISOString() })),
    };
  }
}
