import { Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { Public } from '../../http/access.js';
import {
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import { ContentService } from './content.service.js';

// AP §9.13 «Contact info»: the support phone and WhatsApp numbers the apps
// show, such as the call button of «لديّ رمز من العمليات» (RA §5.2, CA §4.9)
// and RA §5.2 item 3's buttons: the ones stored in the panel, else
// SUPPORT_PHONE_NUMBER and SUPPORT_WHATSAPP_NUMBER (ContentService.contact).

// The numbers in E.164, left out when unset. Optional rather than nullable:
// Nest's document reads a top-level nullable type as a list.
export const ContactSchema = z
  .object({ phone: z.string().optional(), whatsapp: z.string().optional() })
  .describe('The support phone and WhatsApp numbers in E.164, when set (AP §9.13).');

class ContactDto extends createZodDto(ContactSchema) {}

@MerchantController('contact')
export class MerchantContactController {
  constructor(private readonly content: ContentService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: ContactDto })
  get() {
    return this.content.contact();
  }
}

@CaptainController('contact')
export class CaptainContactController {
  constructor(private readonly content: ContentService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: ContactDto })
  get() {
    return this.content.contact();
  }
}

@CustomerController('contact')
export class CustomerContactController {
  constructor(private readonly content: ContentService) {}

  @Get()
  @Public()
  @ZodResponse({ status: 200, type: ContactDto })
  get() {
    return this.content.contact();
  }
}
