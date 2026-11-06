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
// 2026-11-07), read at each request; an empty or malformed value is null, and
// the apps hide its button.
const E164 = /^\+[1-9]\d{7,14}$/;

const ContactSchema = z.object({
  phone: z.string().nullable().describe('The support phone number in E.164, or null.'),
  whatsapp: z.string().nullable().describe('The support WhatsApp number in E.164, or null.'),
});

class ContactDto extends createZodDto(ContactSchema) {}

export function supportContact(environment: NodeJS.ProcessEnv = process.env): ContactDto {
  const number = (value: string | undefined) =>
    value !== undefined && E164.test(value.trim()) ? value.trim() : null;
  return {
    phone: number(environment.SUPPORT_PHONE_NUMBER),
    whatsapp: number(environment.SUPPORT_WHATSAPP_NUMBER),
  };
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
