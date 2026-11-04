import {
  Body,
  ConflictException,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Put,
  Req,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AdminController } from '../../http/route-groups.js';
import { adminRoles } from '../settings/index.js';
import type { AdminSession } from './admin-sessions.service.js';
import { type IssuedLink, AdminTeamService, TeamRefusedError } from './admin-team.service.js';
import { requestContext } from './request-context.js';
import { CurrentAdminSession, RequirePermission } from './route-access.guard.js';
import { adminAccountStatuses } from './schema.js';
import { normalizeEmail, normalizePhone } from './sign-in-name.js';

const roles = z
  .array(z.enum(adminRoles))
  .min(1)
  .max(adminRoles.length)
  .describe('One or more roles (AP §6.1).');

class AccountParamsDto extends createZodDto(z.object({ accountId: z.uuid() })) {}

class CreateUserDto extends createZodDto(
  z
    .object({
      name: z.string().trim().min(1).max(100),
      email: z
        .string()
        .max(254)
        .transform((value, context) => {
          const email = normalizeEmail(value);
          if (!email) context.addIssue({ code: 'custom', message: 'not an email address' });
          return email ?? z.NEVER;
        })
        .nullish(),
      phone: z
        .string()
        .max(30)
        .transform((value, context) => {
          const phone = normalizePhone(value);
          if (!phone) {
            context.addIssue({ code: 'custom', message: 'not an international phone number' });
          }
          return phone ?? z.NEVER;
        })
        .nullish()
        .describe('In international form, such as +963944000000.'),
      roles,
    })
    .refine((user) => user.email || user.phone, { message: 'an email or a phone is needed' }),
) {}

class ChangeRolesDto extends createZodDto(z.object({ roles })) {}

class SetupLinkDto extends createZodDto(
  z.object({
    accountId: z.uuid(),
    setupToken: z
      .string()
      .describe(
        'Shown this once. The panel builds the link <panel>/setup#token=<setupToken> for the owner to share.',
      ),
    setupExpiresAt: z.iso.datetime(),
  }),
) {}

class OpenSessionDto extends createZodDto(
  z.object({
    id: z.uuid(),
    userAgent: z.string().nullable(),
    ipAddress: z.string().nullable(),
    signedInAt: z.iso.datetime(),
    lastActivityAt: z.iso.datetime(),
  }),
) {}

class TeamUserDto extends createZodDto(
  z.object({
    id: z.uuid(),
    name: z.string().nullable(),
    email: z.string().nullable(),
    phone: z.string().nullable(),
    roles: z.array(z.string()),
    status: z.enum(adminAccountStatuses),
    totpEnrolled: z.boolean(),
    lastSignInAt: z.iso.datetime().nullable(),
    openSessions: z.array(OpenSessionDto.schema),
  }),
) {}

class TeamUsersDto extends createZodDto(z.object({ users: z.array(TeamUserDto.schema) })) {}

class RoleMatrixDto extends createZodDto(
  z.object({
    roles: z.array(z.object({ role: z.string(), permissions: z.array(z.string()) })),
  }),
) {}

class DoneDto extends createZodDto(z.object({ status: z.literal('done') })) {}

const done = { status: 'done' as const };

function linkBody(link: IssuedLink): SetupLinkDto {
  return {
    accountId: link.accountId,
    setupToken: link.setupToken,
    setupExpiresAt: link.setupExpiresAt.toISOString(),
  };
}

function teamError(error: unknown): unknown {
  if (!(error instanceof TeamRefusedError)) return error;
  if (error.refusal === 'not_found') return new NotFoundException();
  return new ConflictException({ statusCode: HttpStatus.CONFLICT, error: error.refusal });
}

async function refusalsAsHttp<T>(action: () => Promise<T>): Promise<T> {
  try {
    return await action();
  } catch (error) {
    throw teamError(error);
  }
}

// AP §9.15 «فريق الإدارة», OWN only (AP §6.2), with AP §5.2–5.3.
@AdminController('team')
export class AdminTeamController {
  constructor(private readonly team: AdminTeamService) {}

  @Get('users')
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 200, type: TeamUsersDto })
  async list() {
    const users = await this.team.list();
    return {
      users: users.map((user) => ({
        ...user,
        lastSignInAt: user.lastSignInAt?.toISOString() ?? null,
        openSessions: user.openSessions.map((session) => ({
          id: session.id,
          userAgent: session.userAgent,
          ipAddress: session.ipAddress,
          signedInAt: session.signedInAt.toISOString(),
          lastActivityAt: session.lastActivityAt.toISOString(),
        })),
      })),
    };
  }

  @Post('users')
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 201, type: SetupLinkDto })
  async create(
    @Body() body: CreateUserDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    const user = {
      name: body.name,
      email: body.email ?? null,
      phone: body.phone ?? null,
      roles: body.roles,
    };
    return linkBody(
      await refusalsAsHttp(() => this.team.create(user, actor, requestContext(request))),
    );
  }

  @Put('users/:accountId/roles')
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 200, type: DoneDto })
  async changeRoles(
    @Param() params: AccountParamsDto,
    @Body() body: ChangeRolesDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await refusalsAsHttp(() =>
      this.team.changeRoles(params.accountId, body.roles, actor, requestContext(request)),
    );
    return done;
  }

  @Post('users/:accountId/disable')
  @HttpCode(200)
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 200, type: DoneDto })
  async disable(
    @Param() params: AccountParamsDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await refusalsAsHttp(() => this.team.disable(params.accountId, actor, requestContext(request)));
    return done;
  }

  @Post('users/:accountId/enable')
  @HttpCode(200)
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 200, type: DoneDto })
  async enable(
    @Param() params: AccountParamsDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await refusalsAsHttp(() => this.team.enable(params.accountId, actor, requestContext(request)));
    return done;
  }

  @Post('users/:accountId/sign-out')
  @HttpCode(200)
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 200, type: DoneDto })
  async forceSignOut(
    @Param() params: AccountParamsDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    await refusalsAsHttp(() =>
      this.team.forceSignOut(params.accountId, actor, requestContext(request)),
    );
    return done;
  }

  @Post('users/:accountId/totp-reset')
  @HttpCode(200)
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 200, type: SetupLinkDto })
  async resetTotp(
    @Param() params: AccountParamsDto,
    @CurrentAdminSession() actor: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    return linkBody(
      await refusalsAsHttp(() =>
        this.team.resetTotp(params.accountId, actor, requestContext(request)),
      ),
    );
  }

  @Get('roles')
  @RequirePermission('admin_team.manage')
  @ZodResponse({ status: 200, type: RoleMatrixDto })
  async roleMatrix() {
    return { roles: await this.team.roleMatrix() };
  }
}
