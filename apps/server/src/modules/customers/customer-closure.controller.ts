import {
  BadRequestException,
  Body,
  ConflictException,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  Res,
} from '@nestjs/common';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { CustomerController } from '../../http/route-groups.js';
import {
  AppCheckHeader,
  AppCheckToken,
  type AppSession,
  codeRequestAnswer,
  codeSent,
  CustomerAccountsService,
  SignInCodeRefusedError,
  signInCode,
} from '../identity/index.js';
import { CustomerAdminRefusedError, CustomerAdminService } from './customer-admin.service.js';
import { CustomersService } from './customers.service.js';

class CustomerCloseCodeSentDto extends createZodDto(codeSent) {}

class CustomerCloseAccountDto extends createZodDto(z.object({ code: signInCode })) {}

class CustomerAccountClosedDto extends createZodDto(
  z.object({
    status: z
      .literal('closed')
      .describe('Every session of the account ended; the app signs out (CU §5.6 item 4).'),
  }),
) {}

// CU §5.6 «حذف الحساب» (D19, AP §8.8; slice 2.25c): a fresh code to the
// account's own number (Q20), then the closure with it. Both refuse
// `409 active_order` while an order is active («لا يمكن حذف الحساب أثناء
// وجود طلب جارٍ»), the code request before anything is sent.
@CustomerController('account')
export class CustomerClosureController {
  constructor(
    private readonly customers: CustomersService,
    private readonly admin: CustomerAdminService,
    private readonly accounts: CustomerAccountsService,
  ) {}

  @Post('close-code')
  @AppSignedIn()
  @HttpCode(200)
  @AppCheckHeader()
  @ZodResponse({ status: 200, type: CustomerCloseCodeSentDto })
  async requestCode(
    @CurrentAppSession() session: AppSession,
    @Req() request: FastifyRequest,
    @Res({ passthrough: true }) reply: FastifyReply,
    @AppCheckToken() appCheckToken: string | undefined,
  ) {
    if (await this.customers.hasActiveOrder(session.accountId)) throw activeOrder();
    try {
      const sent = await this.accounts.sendCloseCode(
        session.accountId,
        { deviceId: session.deviceId, appCheckToken },
        requestContext(request),
        new Date(),
      );
      return { ...sent, expiresAt: sent.expiresAt.toISOString() };
    } catch (error) {
      codeRequestAnswer(error, reply);
    }
  }

  @Post('close')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerAccountClosedDto })
  async close(
    @CurrentAppSession() session: AppSession,
    @Body() body: CustomerCloseAccountDto,
    @Req() request: FastifyRequest,
  ) {
    const now = new Date();
    // Checked before the code is used up, and again under the lock.
    if (await this.customers.hasActiveOrder(session.accountId)) throw activeOrder();
    try {
      await this.accounts.useCloseCode(
        session.accountId,
        { deviceId: session.deviceId, code: body.code },
        now,
      );
    } catch (error) {
      if (!(error instanceof SignInCodeRefusedError)) throw error;
      throw new BadRequestException({
        statusCode: HttpStatus.BAD_REQUEST,
        error: error.refusal,
        attemptsLeft: error.attemptsLeft,
      });
    }
    try {
      await this.admin.closeAccount(
        session.accountId,
        { admin: null, context: requestContext(request), cityId: null },
        now,
      );
    } catch (error) {
      if (error instanceof CustomerAdminRefusedError && error.refusal === 'active_order') {
        throw activeOrder();
      }
      // The panel closed it meanwhile: closed all the same.
      if (error instanceof CustomerAdminRefusedError && error.refusal === 'account_closed') {
        return { status: 'closed' as const };
      }
      throw error;
    }
    return { status: 'closed' as const };
  }
}

function activeOrder(): ConflictException {
  return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: 'active_order' });
}
