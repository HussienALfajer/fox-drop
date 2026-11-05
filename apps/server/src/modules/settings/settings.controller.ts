import {
  BadRequestException,
  Body,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Query,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, SignedIn } from '../../http/access.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminSession } from '../identity/index.js';
import { type AdminRole, adminRoles, settingGroups } from './catalogue.js';
import {
  type SettingChange,
  type SettingEntry,
  SettingRefusedError,
  SettingsService,
  type SettingTarget,
} from './settings.service.js';

// Any JSON value: the setting's own schema in the catalogue checks it.
const settingValue = z.unknown();

const cityId = z.uuid().describe('The city of a city setting; none for a global one.');
const reason = z
  .string()
  .max(500)
  .nullish()
  .describe('Required for the settings with money impact (reasonRequired).');

class SettingParamsDto extends createZodDto(
  z.object({
    key: z
      .string()
      .max(100)
      .regex(/^[A-Za-z0-9_.]+$/)
      .describe('The concrete key, such as dispatch.mode or currency.TRY.rounding_unit.'),
  }),
) {}

class CityQueryDto extends createZodDto(z.object({ cityId })) {}

class SettingCityQueryDto extends createZodDto(z.object({ cityId: cityId.optional() })) {}

class UpdateSettingDto extends createZodDto(
  z.object({
    cityId: cityId.nullish(),
    value: settingValue
      .refine((value) => value !== undefined, { message: 'a value is needed' })
      .describe('The new value, in the shape of its setting; null where the setting allows it.'),
    reason,
  }),
) {}

class ResetSettingDto extends createZodDto(z.object({ cityId: cityId.nullish(), reason })) {}

const settingEntry = z.object({
  key: z.string(),
  template: z.string().describe('The Appendix A key, such as currency.<code>.rounding_unit.'),
  parameter: z.string().nullable(),
  group: z.enum(settingGroups),
  type: z.string(),
  unit: z.string().nullable(),
  scope: z.enum(['global', 'city']),
  cityId: z.uuid().nullable(),
  editRoles: z.array(z.enum(adminRoles)),
  reasonRequired: z.boolean(),
  beforeLaunch: z.boolean().describe('No default: the owner enters the value before launch.'),
  default: settingValue,
  value: settingValue.describe('The value in effect: the stored one, or the default.'),
  isDefault: z.boolean(),
});

class SettingEntryDto extends createZodDto(settingEntry) {}

class SettingListDto extends createZodDto(z.object({ settings: z.array(settingEntry) })) {}

class SettingHistoryDto extends createZodDto(
  z.object({
    changes: z.array(
      z.object({
        action: z.enum(['update', 'reset']),
        before: settingValue,
        after: settingValue,
        // Null for the placeholder values the system seeds in development and staging.
        editorId: z.uuid().nullable(),
        editorRoles: z.array(z.string()),
        reason: z.string().nullable(),
        changedAt: z.iso.datetime(),
      }),
    ),
  }),
) {}

// The roles of the session the settings catalogue knows.
function rolesOf(session: AdminSession): AdminRole[] {
  return session.roles.filter((role): role is AdminRole =>
    (adminRoles as readonly string[]).includes(role),
  );
}

function settingError(error: unknown): unknown {
  if (!(error instanceof SettingRefusedError)) return error;
  if (error.refusal === 'unknown_key') return new NotFoundException();
  if (error.refusal === 'role_may_not_edit') return new ForbiddenException();
  return new BadRequestException({
    statusCode: HttpStatus.BAD_REQUEST,
    error: error.refusal,
    message: error.message,
  });
}

async function refusalsAsHttp<T>(action: () => Promise<T>): Promise<T> {
  try {
    return await action();
  } catch (error) {
    throw settingError(error);
  }
}

function entryBody(entry: SettingEntry) {
  return { ...entry, editRoles: [...entry.editRoles] } as SettingEntryDto;
}

// AP §9.14 «الإعدادات». Each role reads, edits and resets only the settings
// whose Appendix A edit roles hold it (owner decision 2026-11-05), so the
// routes need a session and the service checks the roles.
@AdminController('settings')
export class SettingsController {
  constructor(private readonly settings: SettingsService) {}

  @Get()
  @SignedIn()
  @ZodResponse({ status: 200, type: SettingListDto })
  async list(@Query() query: CityQueryDto, @CurrentAdminSession() session: AdminSession) {
    const entries = await refusalsAsHttp(() => this.settings.list(query.cityId, rolesOf(session)));
    return { settings: entries.map(entryBody) };
  }

  @Put(':key')
  @SignedIn()
  @ZodResponse({ status: 200, type: SettingEntryDto })
  async update(
    @Param() params: SettingParamsDto,
    @Body() body: UpdateSettingDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const { key, target } = this.target(params.key, body.cityId);
      await this.settings.update(
        key,
        target,
        body.value,
        this.change(session, request, body.reason),
      );
      return entryBody(await this.settings.read(key, target, rolesOf(session)));
    });
  }

  @Post(':key/reset')
  @HttpCode(200)
  @SignedIn()
  @ZodResponse({ status: 200, type: SettingEntryDto })
  async reset(
    @Param() params: SettingParamsDto,
    @Body() body: ResetSettingDto,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return refusalsAsHttp(async () => {
      const { key, target } = this.target(params.key, body.cityId);
      await this.settings.reset(key, target, this.change(session, request, body.reason));
      return entryBody(await this.settings.read(key, target, rolesOf(session)));
    });
  }

  @Get(':key/history')
  @SignedIn()
  @ZodResponse({ status: 200, type: SettingHistoryDto })
  async history(
    @Param() params: SettingParamsDto,
    @Query() query: SettingCityQueryDto,
    @CurrentAdminSession() session: AdminSession,
  ) {
    return refusalsAsHttp(async () => {
      const { key, target } = this.target(params.key, query.cityId);
      const changes = await this.settings.history(key, target, rolesOf(session));
      return {
        changes: changes.map((change) => ({
          ...change,
          changedAt: change.changedAt.toISOString(),
        })),
      } as SettingHistoryDto;
    });
  }

  private target(concreteKey: string, cityId: string | null | undefined) {
    const { key, parameter } = this.settings.parseKey(concreteKey);
    const target: SettingTarget = { cityId: cityId ?? null, parameter };
    return { key, target };
  }

  private change(
    session: AdminSession,
    request: FastifyRequest,
    reason: string | null | undefined,
  ): SettingChange {
    return {
      editor: { id: session.accountId, roles: rolesOf(session) },
      context: requestContext(request),
      reason: reason ?? null,
    };
  }
}
