import { Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import {
  AdminController,
  CaptainController,
  CustomerController,
  MerchantController,
} from './route-groups.js';

// A cheap call each product can make to check that the server is reachable.
// The body carries the same clock as the Server-Time header.
const StatusSchema = z.object({
  status: z.literal('ok'),
  serverTime: z.int().nonnegative().describe('The server clock in Unix milliseconds.'),
});

class StatusDto extends createZodDto(StatusSchema) {}

function currentStatus(): StatusDto {
  return { status: 'ok', serverTime: Date.now() };
}

@AdminController('status')
export class AdminStatusController {
  @Get()
  @ZodResponse({ status: 200, type: StatusDto })
  get() {
    return currentStatus();
  }
}

@MerchantController('status')
export class MerchantStatusController {
  @Get()
  @ZodResponse({ status: 200, type: StatusDto })
  get() {
    return currentStatus();
  }
}

@CaptainController('status')
export class CaptainStatusController {
  @Get()
  @ZodResponse({ status: 200, type: StatusDto })
  get() {
    return currentStatus();
  }
}

@CustomerController('status')
export class CustomerStatusController {
  @Get()
  @ZodResponse({ status: 200, type: StatusDto })
  get() {
    return currentStatus();
  }
}

export const STATUS_CONTROLLERS = [
  AdminStatusController,
  MerchantStatusController,
  CaptainStatusController,
  CustomerStatusController,
];
