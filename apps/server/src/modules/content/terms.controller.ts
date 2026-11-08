import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import {
  AppSignedIn,
  AppSignedInOrGuest,
  CurrentAdminSession,
  CurrentAppSession,
  OptionalAppSession,
  RequirePermission,
} from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import {
  AdminController,
  CaptainController,
  CustomerController,
  MerchantController,
} from '../../http/route-groups.js';
import type { AdminSession, AppSession } from '../identity/index.js';
import { ContentRefusedError } from './content.service.js';
import { TERMS_MAX, termsAudiences, type TermsAudience } from './lists.js';
import { type TermsVersion, TermsService } from './terms.service.js';

// AP §9.13 «الشروط والخصوصية»: the apps read the document in force and accept
// it (CU §4.7, §15, CA §4.8, §15, RA §4.10); the panel publishes a new
// version (content.manage, AP §6.2).

const termsVersion = {
  version: z.int().min(1).describe('Sent back with «أوافق» (CU §15, CA §15).'),
  body: z.string().describe('Plain text; a line per paragraph.'),
  publishedAt: z.iso.datetime(),
};

class TermsDto extends createZodDto(
  z.object({
    ...termsVersion,
    pending: z
      .boolean()
      .describe(
        'The signed-in account has not accepted this version; false for a guest and for a cashier (RA S13).',
      ),
  }),
) {}

class TermsAcceptDto extends createZodDto(z.object({ version: z.int().min(1) })) {}

class TermsAcceptedDto extends createZodDto(z.object({ status: z.literal('accepted') })) {}

class AdminTermsVersionDto extends createZodDto(z.object(termsVersion)) {}

class AdminTermsDto extends createZodDto(
  z.object(
    Object.fromEntries(termsAudiences.map((audience) => [audience, z.object(termsVersion)])) as {
      [Audience in TermsAudience]: z.ZodObject<typeof termsVersion>;
    },
  ),
) {}

class TermsAudienceParamsDto extends createZodDto(z.object({ audience: z.enum(termsAudiences) })) {}

class AdminPublishTermsDto extends createZodDto(
  z.object({ body: z.string().min(1).max(TERMS_MAX) }),
) {}

function versionBody(terms: TermsVersion) {
  return {
    version: terms.version,
    body: terms.body,
    publishedAt: terms.publishedAt.toISOString(),
  };
}

// Whether the session's account still has to accept: a restaurant's cashier
// never does, since only owners accept (RA §4.10, S13).
async function read(terms: TermsService, audience: TermsAudience, session: AppSession | null) {
  const current = await terms.current(audience);
  const accepts =
    session !== null && (audience !== 'merchant' || session.merchant?.role === 'owner');
  return {
    ...versionBody(current),
    pending: accepts && (await terms.pending(audience, session.accountId)),
  };
}

// 409 terms_outdated: a newer version was published since the app read it;
// the app reads it again and shows it.
async function accept(
  terms: TermsService,
  audience: TermsAudience,
  session: AppSession,
  version: number,
) {
  try {
    await terms.accept(audience, session.accountId, version, new Date());
  } catch (error) {
    if (error instanceof ContentRefusedError && error.refusal === 'terms_outdated') {
      throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
    }
    throw error;
  }
  return { status: 'accepted' as const };
}

@MerchantController('terms')
export class MerchantTermsController {
  constructor(private readonly terms: TermsService) {}

  @Get()
  @AppSignedInOrGuest()
  @ZodResponse({ status: 200, type: TermsDto })
  get(@OptionalAppSession() session: AppSession | null) {
    return read(this.terms, 'merchant', session);
  }

  @Post('accept')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: TermsAcceptedDto })
  accept(@CurrentAppSession() session: AppSession, @Body() body: TermsAcceptDto) {
    return accept(this.terms, 'merchant', session, body.version);
  }
}

@CaptainController('terms')
export class CaptainTermsController {
  constructor(private readonly terms: TermsService) {}

  @Get()
  @AppSignedInOrGuest()
  @ZodResponse({ status: 200, type: TermsDto })
  get(@OptionalAppSession() session: AppSession | null) {
    return read(this.terms, 'captain', session);
  }

  @Post('accept')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: TermsAcceptedDto })
  accept(@CurrentAppSession() session: AppSession, @Body() body: TermsAcceptDto) {
    return accept(this.terms, 'captain', session, body.version);
  }
}

@CustomerController('terms')
export class CustomerTermsController {
  constructor(private readonly terms: TermsService) {}

  @Get()
  @AppSignedInOrGuest()
  @ZodResponse({ status: 200, type: TermsDto })
  get(@OptionalAppSession() session: AppSession | null) {
    return read(this.terms, 'customer', session);
  }

  @Post('accept')
  @AppSignedIn()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: TermsAcceptedDto })
  accept(@CurrentAppSession() session: AppSession, @Body() body: TermsAcceptDto) {
    return accept(this.terms, 'customer', session, body.version);
  }
}

@AdminController('content/terms')
export class AdminTermsController {
  constructor(private readonly terms: TermsService) {}

  // The version in force of each audience.
  @Get()
  @RequirePermission('content.read')
  @ZodResponse({ status: 200, type: AdminTermsDto })
  async all() {
    const versions = await Promise.all(
      termsAudiences.map(async (audience) => [
        audience,
        versionBody(await this.terms.current(audience)),
      ]),
    );
    return Object.fromEntries(versions) as AdminTermsDto;
  }

  // «نشر نسخة جديدة»: every account of the audience accepts it again on its
  // next open. 400 terms_unchanged for the text in force.
  @Post(':audience')
  @RequirePermission('content.manage')
  @ZodResponse({ status: 201, type: AdminTermsVersionDto })
  async publish(
    @Param() params: TermsAudienceParamsDto,
    @Body() body: AdminPublishTermsDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      const published = await this.terms.publish(
        params.audience,
        body.body,
        {
          admin: { accountId: session.accountId, roles: session.roles },
          context: requestContext(request),
        },
        new Date(),
      );
      return versionBody(published);
    } catch (error) {
      if (error instanceof ContentRefusedError) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: error.refusal,
          message: error.message,
        });
      }
      throw error;
    }
  }
}
