import {
  BadRequestException,
  Body,
  ConflictException,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession, Public } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import { GeoRefusedError, GeoService } from '../geo/index.js';
import { type AppSession, deviceId } from '../identity/index.js';
import { addressFields, checked, location, personName } from './address-fields.js';
import {
  type AddressFields,
  CustomersRefusedError,
  CustomersService,
} from './customers.service.js';
import { pointQuery } from './point-query.js';
import { genders } from './schema.js';

const profile = z.object({
  firstName: personName(30).describe('«الاسم»: 2 to 30 Arabic or Latin letters, spaces and «-».'),
  lastName: personName(30).nullable().describe('«الكنية», optional, the same rule.'),
  gender: z.enum(genders).describe('«ذكر» male or «أنثى» female.'),
  birthday: z.iso.date().nullable().describe('«تاريخ الميلاد», optional, a past date.'),
});

class CustomerProfileDto extends createZodDto(
  z.object({
    completed: z.boolean().describe('false until «أكمل بياناتك» is sent (CU §5.3).'),
    profile: profile.nullable(),
  }),
) {}

class CustomerSaveProfileDto extends createZodDto(
  profile.extend({
    acceptTerms: z
      .boolean()
      .describe('«أوافق على الشروط وسياسة الخصوصية»: needed the first time only.'),
  }),
) {}

class CustomerNewAddressDto extends createZodDto(
  checked(
    addressFields.extend({
      isDefault: z.boolean().describe('Make it the default; the first address always is.'),
    }),
  ),
) {}

class CustomerAddressFieldsDto extends createZodDto(checked(addressFields)) {}

const address = addressFields.extend({
  id: z.uuid(),
  isDefault: z.boolean(),
  neighbourhood: z
    .string()
    .nullable()
    .describe('«الحي», the zone name; null is «خارج منطقة التوصيل حالياً» (Q6).'),
});

class CustomerAddressDto extends createZodDto(address) {}

class CustomerAddressListDto extends createZodDto(z.object({ addresses: z.array(address) })) {}

class CustomerAddressParamsDto extends createZodDto(z.object({ addressId: z.uuid() })) {}

class CustomerAddressDeletedDto extends createZodDto(z.object({ status: z.literal('deleted') })) {}

class CustomerLocationQueryDto extends createZodDto(pointQuery) {}

class CustomerLocationDto extends createZodDto(
  z.object({
    state: z
      .enum(['served', 'no_restaurants', 'outside_zones'])
      .describe(
        'CU §7.1: the home screen; «لا توجد مطاعم توصل إلى موقعك حالياً»; «قريباً في منطقتك» with the vote.',
      ),
    zone: z
      .object({ id: z.uuid(), name: z.string() })
      .nullable()
      .describe('The zone the point is in, the neighbourhood of an unsaved point.'),
  }),
) {}

class CustomerZoneVoteDto extends createZodDto(z.object({ deviceId, location })) {}

class CustomerZoneVotedDto extends createZodDto(
  z.object({
    status: z
      .enum(['recorded', 'already_voted'])
      .describe('Either way the app shows «شكراً، سنخبرك عندما نصل إلى منطقتك».'),
  }),
) {}

// CU §5.3 and §7: the customer's details, the zone check of a point, the
// vote from outside the zones and the saved addresses. A guest checks a
// point and votes (CU §5.1); the rest needs the account.
@CustomerController()
export class CustomerProfileController {
  constructor(
    private readonly customers: CustomersService,
    private readonly geo: GeoService,
  ) {}

  @Get('location')
  @Public()
  @ZodResponse({ status: 200, type: CustomerLocationDto })
  async location(@Query() query: CustomerLocationQueryDto) {
    const { state, zone } = await this.customers.location(query);
    return { state, zone };
  }

  // CU §7.2: one vote per device within 500 m; a point inside a zone
  // answers 409 inside_zone.
  @Post('zone-votes')
  @Public()
  @HttpCode(200)
  @ZodResponse({ status: 200, type: CustomerZoneVotedDto })
  async vote(@Body() body: CustomerZoneVoteDto) {
    try {
      return { status: await this.geo.castVote(body.deviceId, body.location) };
    } catch (error) {
      if (error instanceof GeoRefusedError && error.refusal === 'inside_zone') {
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
      }
      throw error;
    }
  }

  @Get('profile')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerProfileDto })
  async profile(@CurrentAppSession() session: AppSession) {
    const profile = await this.customers.profile(session.accountId);
    return { completed: profile !== null, profile };
  }

  // «أكمل بياناتك» (CU §5.3); 400 terms_required the first time without the
  // terms, 400 invalid_birthday for a date not in the past.
  @Put('profile')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerProfileDto })
  async saveProfile(
    @CurrentAppSession() session: AppSession,
    @Body() body: CustomerSaveProfileDto,
  ) {
    const { acceptTerms, ...fields } = body;
    const profile = await refusalsAsHttp(() =>
      this.customers.saveProfile(session.accountId, fields, { acceptTerms, now: new Date() }),
    );
    return { completed: true, profile };
  }

  @Get('addresses')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerAddressListDto })
  async addresses(@CurrentAppSession() session: AppSession) {
    return { addresses: await this.customers.addresses(session.accountId) };
  }

  // CU §7.3: 409 outside_zones for a pin outside every active zone, 409
  // address_limit past 10.
  @Post('addresses')
  @AppSignedIn()
  @ZodResponse({ status: 201, type: CustomerAddressDto })
  async addAddress(@CurrentAppSession() session: AppSession, @Body() body: CustomerNewAddressDto) {
    return refusalsAsHttp(() =>
      this.customers.addAddress(session.accountId, fieldsOf(body), new Date()),
    );
  }

  @Put('addresses/:addressId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerAddressDto })
  async updateAddress(
    @CurrentAppSession() session: AppSession,
    @Param() params: CustomerAddressParamsDto,
    @Body() body: CustomerAddressFieldsDto,
  ) {
    return refusalsAsHttp(() =>
      this.customers.updateAddress(session.accountId, params.addressId, fieldsOf(body), new Date()),
    );
  }

  @Put('addresses/:addressId/default')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerAddressDto })
  async setDefaultAddress(
    @CurrentAppSession() session: AppSession,
    @Param() params: CustomerAddressParamsDto,
  ) {
    return refusalsAsHttp(() =>
      this.customers.setDefaultAddress(session.accountId, params.addressId, new Date()),
    );
  }

  @Delete('addresses/:addressId')
  @AppSignedIn()
  @ZodResponse({ status: 200, type: CustomerAddressDeletedDto })
  async deleteAddress(
    @CurrentAppSession() session: AppSession,
    @Param() params: CustomerAddressParamsDto,
  ) {
    await refusalsAsHttp(() =>
      this.customers.deleteAddress(session.accountId, params.addressId, new Date()),
    );
    return { status: 'deleted' as const };
  }
}

function fieldsOf<T extends AddressFields>(body: T): T {
  return { ...body, customLabel: body.label === 'other' ? body.customLabel : null };
}

async function refusalsAsHttp<T>(run: () => Promise<T>): Promise<T> {
  try {
    return await run();
  } catch (error) {
    if (!(error instanceof CustomersRefusedError)) throw error;
    const body = { error: error.refusal };
    switch (error.refusal) {
      case 'unknown_address':
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
      case 'outside_zones':
      case 'address_limit':
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
      case 'terms_required':
      case 'invalid_birthday':
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
    }
  }
}
