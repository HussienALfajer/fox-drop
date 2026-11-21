import {
  Body,
  ConflictException,
  ForbiddenException,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import {
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { OrderContactRefusedError, OrderContacts } from './order-contacts.js';
import { contactChannels } from './schema.js';

class OrderContactParamsDto extends createZodDto(z.object({ orderId: z.uuid() })) {}

class OrderContactDto extends createZodDto(
  z.object({
    phone: z
      .string()
      .describe(
        'E.164, for the dialer or WhatsApp only: the app never prints it (RA §8.9, CU §11.3, CA §9.5).',
      ),
  }),
) {}

class CaptainCustomerContactDto extends createZodDto(
  z.object({
    channel: z
      .enum(contactChannels)
      .describe('«اتصال بالزبون» (`call`) or «واتساب الزبون» (`whatsapp`).'),
  }),
) {}

// A tap takes no Idempotency-Key: it dials now or not at all, never queued
// and sent again later, and every tap is recorded. The refusals carry no
// order: a tap changes none, and the app hides the button with the order's
// next read or event.
async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof OrderContactRefusedError)) throw error;
    if (error.refusal === 'unknown_order') {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
    }
    throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
  }
}

// RA §8.9, §18, R17 (slice L.1b): «اتصال بالكابتن» from the assignment until
// the order is delivered, failed or cancelled; owners and cashiers in the
// app only, never the portal (RA §5.4). Recorded with the device. 404
// unknown_order; 409 order_state_changed; 403 restaurant_terminated.
@MerchantController()
export class MerchantOrderContactsController {
  constructor(
    private readonly contacts: OrderContacts,
    private readonly merchants: MerchantsService,
  ) {}

  @Post('orders/:orderId/captain-call')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: OrderContactDto })
  async callCaptain(
    @CurrentAppSession() session: AppSession,
    @Param() params: OrderContactParamsDto,
  ) {
    if (!session.merchant) throw new Error('a merchant route without a restaurant user');
    const { restaurantId } = session.merchant;
    if ((await this.merchants.accountStatus(restaurantId)) === 'terminated') {
      throw new ForbiddenException({
        statusCode: HttpStatus.FORBIDDEN,
        error: 'restaurant_terminated',
      });
    }
    return refusalsAsHttp(() =>
      this.contacts.reveal(
        params.orderId,
        {
          type: 'restaurant',
          restaurantId,
          accountId: session.accountId,
          deviceId: session.deviceId,
        },
        'call',
        new Date(),
      ),
    );
  }
}

// CU §11.3, §15 (slice L.1b): «اتصال بالكابتن» on the customer's own order,
// picked up or arrived. 404 unknown_order; 409 order_state_changed.
@CustomerController()
export class CustomerOrderContactsController {
  constructor(private readonly contacts: OrderContacts) {}

  @Post('orders/:orderId/captain-call')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: OrderContactDto })
  async callCaptain(
    @CurrentAppSession() session: AppSession,
    @Param() params: OrderContactParamsDto,
  ) {
    return refusalsAsHttp(() =>
      this.contacts.reveal(
        params.orderId,
        { type: 'customer', accountId: session.accountId },
        'call',
        new Date(),
      ),
    );
  }
}

// CA §9.5, §15, C10 (slice L.1b): «اتصال بالزبون» and «واتساب الزبون» while
// the captain's order is active: the address's contact number, else the
// account's. 404 unknown_order (another captain's, or no longer theirs); 409
// order_state_changed.
@CaptainController('orders')
export class CaptainOrderContactsController {
  constructor(private readonly contacts: OrderContacts) {}

  @Post(':orderId/customer-contact')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: OrderContactDto })
  async contactCustomer(
    @CurrentAppSession() session: AppSession,
    @Param() params: OrderContactParamsDto,
    @Body() body: CaptainCustomerContactDto,
  ) {
    if (session.captain === null) throw new ForbiddenException();
    const { captainId } = session.captain;
    return refusalsAsHttp(() =>
      this.contacts.reveal(
        params.orderId,
        { type: 'captain', captainId },
        body.channel,
        new Date(),
      ),
    );
  }
}
