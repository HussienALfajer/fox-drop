import { Get } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { Public } from '../../http/access.js';
import {
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';

// AP §9.13 «Contact info»: the support phone and WhatsApp numbers the apps
// show, such as the call button of «لديّ رمز من العمليات» (RA §5.2, CA §4.9)
// and RA §5.2 item 3's buttons. Until Content's panel screen exists they come
// from SUPPORT_PHONE_NUMBER and SUPPORT_WHATSAPP_NUMBER (owner decision
// 2026-11-07), read at each request; an empty or malformed value is left out,
// and the apps hide its button.
const E164 = /^\+[1-9]\d{7,14}$/;

// The numbers in E.164, left out when unset. Optional rather than nullable:
// Nest's document reads a top-level nullable type as a list.
const ContactSchema = z
  .object({ phone: z.string().optional(), whatsapp: z.string().optional() })
  .describe('The support phone and WhatsApp numbers in E.164, when set (AP §9.13).');

class ContactDto extends createZodDto(ContactSchema) {}

export function supportContact(environment: NodeJS.ProcessEnv = process.env): ContactDto {
  const contact: ContactDto = {};
  const phone = environment.SUPPORT_PHONE_NUMBER?.trim();
  const whatsapp = environment.SUPPORT_WHATSAPP_NUMBER?.trim();
  if (phone && E164.test(phone)) contact.phone = phone;
  if (whatsapp && E164.test(whatsapp)) contact.whatsapp = whatsapp;
  return contact;
}

@MerchantController('contact')
export class MerchantContactController {
  @Get()
  @Public()
  @ZodResponse({ status: 200, type: ContactDto })
  get() {
    return supportContact();
  }
}

@CaptainController('contact')
export class CaptainContactController {
  @Get()
  @Public()
  @ZodResponse({ status: 200, type: ContactDto })
  get() {
    return supportContact();
  }
}

@CustomerController('contact')
export class CustomerContactController {
  @Get()
  @Public()
  @ZodResponse({ status: 200, type: ContactDto })
  get() {
    return supportContact();
  }
}
