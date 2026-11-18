import { Body, Get, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, Public } from '../../http/access.js';
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

class CustomerPushReceiptDto extends createZodDto(
  z.object({ messageId: z.uuid().describe("The push's `messageId`, from its data.") }),
) {}

class CustomerPushReceivedDto extends createZodDto(z.object({ status: z.literal('received') })) {}

// AP §9.11.4 «وصل» (slice 2.27d): the app acknowledges a push when it
// arrives, in the foreground or from its background handler, which has no
// session; so the route is public, the message's id (random, known only to
// the devices it went to) its only key. It answers alike for any id, and a
// repeat changes nothing.
@CustomerController('push-receipts')
export class CustomerPushReceiptsController {
  constructor(private readonly queue: PushQueue) {}

  @Post()
  @Public()
  @HttpCode(HttpStatus.OK)
  @ZodResponse({ status: HttpStatus.OK, type: CustomerPushReceivedDto })
  async receive(@Body() body: CustomerPushReceiptDto) {
    await this.queue.acknowledge(body.messageId, new Date());
    return { status: 'received' as const };
  }
}
