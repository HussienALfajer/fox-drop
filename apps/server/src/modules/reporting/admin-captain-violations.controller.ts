import {
  BadRequestException,
  Body,
  ConflictException,
  Get,
  HttpStatus,
  NotFoundException,
  Param,
  Post,
  Req,
  UnprocessableEntityException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequirePermission } from '../../http/access.js';
import { Idempotent, IdempotencyKey } from '../../http/idempotency.js';
import { requestContext } from '../../http/request-context.js';
import { AdminController } from '../../http/route-groups.js';
import { AuditService } from '../audit/index.js';
import {
  CaptainsService,
  VIOLATION_LISTS,
  VIOLATION_REASON_MAX,
  ViolationRefusedError,
  ViolationsService,
  violationSteps,
} from '../captains/index.js';
import { ContentService, NOTE_MAX } from '../content/index.js';
import { type AdminSession, AdminSessionsService } from '../identity/index.js';
import { CaptainFiguresService } from '../ordering/index.js';

// The suspensions shown in «المخالفات والإيقافات», newest first.
export const SUSPENSIONS_SHOWN = 50;

const step = z.enum(violationSteps);
const typeChoice = z.object({
  code: z.string(),
  label: z.string(),
  note: z.enum(['none', 'optional', 'required']),
});

class AdminCaptainViolationsParamsDto extends createZodDto(z.object({ captainId: z.uuid() })) {}

class AdminCaptainViolationsDto extends createZodDto(
  z.object({
    violations: z
      .array(
        z.object({
          id: z.uuid(),
          recordedAt: z.iso.datetime(),
          typeCode: z.string(),
          typeLabel: z.string(),
          typeNote: z.string().nullable(),
          severe: z.boolean(),
          suggestedStep: step,
          step,
          orderId: z.uuid().nullable(),
          orderNumber: z.string().nullable(),
          reason: z.string(),
          suspendedUntil: z.iso.datetime().nullable(),
          recordedByName: z.string().nullable(),
          appeal: z
            .object({
              ticketId: z.uuid(),
              at: z.iso.datetime(),
              outcome: z.enum(['accepted', 'rejected']).nullable(),
              decidedAt: z.iso.datetime().nullable(),
            })
            .nullable()
            .describe("The captain's «اعتراض»; an accepted one voids the violation."),
        }),
      )
      .describe('Newest first.'),
    suggestion: z
      .object({ step, windowDays: z.int() })
      .describe('The next step for a type not severe; a severe one is always termination.'),
    types: z.object({ regular: z.array(typeChoice), severe: z.array(typeChoice) }),
    suspensions: z
      .array(
        z.object({
          at: z.iso.datetime(),
          status: z.enum(['active', 'suspended', 'terminated']),
          until: z.iso.datetime().nullable(),
          reason: z.string().nullable(),
          actorName: z.string().nullable(),
        }),
      )
      .describe(`The latest ${SUSPENSIONS_SHOWN} status changes, newest first.`),
  }),
) {}

class AdminRecordViolationDto extends createZodDto(
  z.object({
    severe: z.boolean().describe('The type is from the severe list.'),
    typeCode: z.string().min(1),
    typeNote: z.string().trim().max(NOTE_MAX).nullable(),
    step: step.describe('The step the admin confirms (the suggestion or another).'),
    orderId: z.uuid().nullable().describe("One of the captain's orders, or null."),
    reason: z.string().trim().min(1).max(VIOLATION_REASON_MAX),
  }),
) {}

// AP §9.7.5 «تسجيل مخالفة», §9.7.6 (slice 2.36b): the profile's
// «المخالفات والإيقافات»: the violations with their appeals, the ladder's
// suggestion, the types to pick from and the status changes; recording one
// (captains.manage: OWN, OPS) with its consequence. 404 unknown_captain.
@AdminController('captains')
export class AdminCaptainViolationsController {
  constructor(
    private readonly captains: CaptainsService,
    private readonly violations: ViolationsService,
    private readonly content: ContentService,
    private readonly figures: CaptainFiguresService,
    private readonly admins: AdminSessionsService,
    private readonly audit: AuditService,
  ) {}

  @Get(':captainId/violations')
  @RequirePermission('captains.read')
  @ZodResponse({ status: 200, type: AdminCaptainViolationsDto })
  async list(@Param() params: AdminCaptainViolationsParamsDto) {
    const now = new Date();
    const captain = await this.captains.captain(params.captainId, now);
    if (captain === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_captain' });
    }
    const [rows, suggestion, regular, severe, history] = await Promise.all([
      this.violations.list(captain.id),
      this.violations.suggestion(captain.id, captain.cityId, now),
      this.content.reasonsOf(VIOLATION_LISTS.regular),
      this.content.reasonsOf(VIOLATION_LISTS.severe),
      this.audit.history([{ type: 'captain', ids: [captain.id] }], SUSPENSIONS_SHOWN, null, null, [
        'captain.status',
      ]),
    ]);
    const statuses = history;
    const names = await this.admins.names([
      ...rows.map((row) => row.recordedBy),
      ...statuses.flatMap((entry) =>
        entry.actor.type === 'admin' && entry.actor.id !== null ? [entry.actor.id] : [],
      ),
    ]);
    const active = (list: typeof regular) =>
      list
        .filter((each) => each.active)
        .map((each) => ({ code: each.code, label: each.label, note: each.note }));
    return {
      violations: rows.map((row) => ({
        id: row.id,
        recordedAt: row.recordedAt.toISOString(),
        typeCode: row.typeCode,
        typeLabel: row.typeLabel,
        typeNote: row.typeNote,
        severe: row.severe,
        suggestedStep: row.suggestedStep,
        step: row.step,
        orderId: row.orderId,
        orderNumber: row.orderNumber?.toString() ?? null,
        reason: row.reason,
        suspendedUntil: row.suspendedUntil?.toISOString() ?? null,
        recordedByName: names.get(row.recordedBy) ?? null,
        appeal:
          row.appealTicketId === null
            ? null
            : {
                ticketId: row.appealTicketId,
                at: row.appealedAt!.toISOString(),
                outcome: row.appealOutcome,
                decidedAt: row.appealDecidedAt?.toISOString() ?? null,
              },
      })),
      suggestion,
      types: { regular: active(regular), severe: active(severe) },
      suspensions: statuses.map((entry) => {
        // The audit keeps the fields that changed: a suspension that replaced
        // a running one keeps its status, the only change with no status.
        const after = (entry.changes?.status?.after ?? 'suspended') as string;
        const until = (entry.changes?.suspendedUntil?.after ?? null) as string | null;
        return {
          at: entry.occurredAt.toISOString(),
          status: after as 'active' | 'suspended' | 'terminated',
          until,
          reason: entry.reason,
          actorName:
            entry.actor.type === 'admin' && entry.actor.id !== null
              ? (names.get(entry.actor.id) ?? null)
              : null,
        };
      }),
    };
  }

  // Idempotency-Key (per admin): a repeat answers the first; another
  // request with it is 422 idempotency_key_reused. 400 unknown_reason,
  // reason_note_required, reason_note_not_allowed, unknown_order; 409
  // captain_terminated, no_contract (a captain the seed made has no contract
  // to end), already_terminated, offboarding_open (a suspension while the
  // contract is being ended).
  @Post(':captainId/violations')
  @RequirePermission('captains.manage')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminCaptainViolationsDto })
  async record(
    @Param() params: AdminCaptainViolationsParamsDto,
    @Body() body: AdminRecordViolationDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    let order: { id: string; number: bigint } | null = null;
    if (body.orderId !== null) {
      const number = await this.figures.captainOrderNumber(params.captainId, body.orderId);
      if (number === null) {
        throw new BadRequestException({
          statusCode: HttpStatus.BAD_REQUEST,
          error: 'unknown_order',
        });
      }
      order = { id: body.orderId, number };
    }
    try {
      await this.violations.record(
        params.captainId,
        {
          severe: body.severe,
          typeCode: body.typeCode,
          typeNote: body.typeNote,
          step: body.step,
          order,
          reason: body.reason,
          idempotencyKey,
        },
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
        },
        new Date(),
      );
    } catch (error) {
      if (error instanceof ViolationRefusedError) {
        const body = { error: error.refusal };
        if (error.refusal === 'unknown_captain') {
          throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, ...body });
        }
        if (error.refusal === 'idempotency_key_reused') {
          throw new UnprocessableEntityException({
            statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
            ...body,
          });
        }
        if (
          error.refusal === 'unknown_reason' ||
          error.refusal === 'reason_note_required' ||
          error.refusal === 'reason_note_not_allowed' ||
          error.refusal === 'reason_required'
        ) {
          throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, ...body });
        }
        throw new ConflictException({ statusCode: HttpStatus.CONFLICT, ...body });
      }
      throw error;
    }
    return this.list(params);
  }
}
