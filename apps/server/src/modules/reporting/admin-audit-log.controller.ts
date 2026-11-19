import { BadRequestException, Get, HttpStatus, Query } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { RequirePermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import { AuditService } from '../audit/index.js';
import { AdminSessionsService } from '../identity/index.js';

// The events of one page of «سجل التدقيق».
export const AUDIT_LOG_PAGE = 50;

const actorTypes = ['admin', 'merchant', 'captain', 'customer', 'system'] as const;
const dotted = z
  .string()
  .max(100)
  .regex(/^[a-z_]+(\.[a-z_]+)*$/);
// The last event of a page: its time to the microsecond and id,
// `<ISO time>_<uuid>`.
const cursor = z
  .string()
  .max(80)
  .regex(/^[0-9T:.-]+Z_[0-9a-f-]{36}$/);

class AdminAuditLogQueryDto extends createZodDto(
  z.object({
    actorType: z.enum(actorTypes).optional(),
    actorId: z.uuid().optional().describe("An actor's account id."),
    action: dotted.optional().describe('An action, such as setting.update.'),
    targetType: dotted.optional().describe('A target type, such as setting or order.'),
    targetId: z.string().min(1).max(100).optional(),
    from: z.iso.datetime().optional().describe('Included.'),
    to: z.iso.datetime().optional().describe('Excluded.'),
    cursor: cursor.optional().describe("The page's nextCursor: the page after it."),
  }),
) {}

class AdminAuditLogDto extends createZodDto(
  z.object({
    events: z
      .array(
        z.object({
          id: z.uuid(),
          at: z.iso.datetime(),
          kind: z.enum(['write', 'view']).describe('view: a sensitive view, without changes.'),
          cityId: z.uuid().nullable().describe('None for an action on the whole platform (D28).'),
          actorType: z.enum(actorTypes),
          actorId: z.uuid().nullable().describe('None for the system.'),
          actorName: z.string().nullable().describe("An admin's name; null for the others."),
          actorRole: z.string().nullable().describe('The role when it acted (D27).'),
          action: z.string(),
          targetType: z.string(),
          targetId: z.string(),
          changes: z
            .array(
              z.object({
                field: z.string(),
                before: z.string().nullable().describe('JSON; null for none.'),
                after: z.string().nullable().describe('JSON; null for none.'),
              }),
            )
            .describe('The changed fields of a write.'),
          reason: z.string().nullable(),
          ipAddress: z.string().nullable(),
          device: z.string().nullable(),
        }),
      )
      .describe('Newest first.'),
    nextCursor: cursor.nullable().describe('Null on the last page.'),
  }),
) {}

const json = (value: unknown) =>
  value === null || value === undefined ? null : JSON.stringify(value);

function afterOf(text: string | undefined) {
  if (text === undefined) return null;
  const split = text.lastIndexOf('_');
  const occurredAt = text.slice(0, split);
  if (Number.isNaN(new Date(occurredAt).getTime())) {
    throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: 'invalid_cursor' });
  }
  return { occurredAt, id: text.slice(split + 1) };
}

// AP §9.16 «سجل التدقيق» (OWN; slice 2.38a): every write and sensitive view,
// read only, newest first, a page at a time. The log is append-only in the
// database, so no route changes it. 400 invalid_cursor.
@AdminController('audit-log')
export class AdminAuditLogController {
  constructor(
    private readonly audit: AuditService,
    private readonly admins: AdminSessionsService,
  ) {}

  @Get()
  @RequirePermission('audit_log.read')
  @ZodResponse({ status: 200, type: AdminAuditLogDto })
  async list(@Query() query: AdminAuditLogQueryDto) {
    // One more than a page tells whether another follows.
    const found = await this.audit.search(
      {
        actorType: query.actorType ?? null,
        actorId: query.actorId ?? null,
        action: query.action ?? null,
        targetType: query.targetType ?? null,
        targetId: query.targetId ?? null,
        from: query.from === undefined ? null : new Date(query.from),
        to: query.to === undefined ? null : new Date(query.to),
        after: afterOf(query.cursor),
      },
      AUDIT_LOG_PAGE + 1,
    );
    const page = found.slice(0, AUDIT_LOG_PAGE);
    const names = await this.admins.names(
      page.flatMap((event) =>
        event.actor.type === 'admin' && event.actor.id !== null ? [event.actor.id] : [],
      ),
    );
    const last = page.at(-1);
    return {
      events: page.map((event) => ({
        id: event.id,
        at: event.occurredAt.toISOString(),
        kind: event.kind,
        cityId: event.cityId,
        actorType: event.actor.type,
        actorId: event.actor.id,
        actorName:
          event.actor.type === 'admin' && event.actor.id !== null
            ? (names.get(event.actor.id) ?? null)
            : null,
        actorRole: event.actor.role,
        action: event.action,
        targetType: event.target.type,
        targetId: event.target.id,
        changes: Object.entries(event.changes ?? {}).map(([field, change]) => ({
          field,
          before: json(change.before),
          after: json(change.after),
        })),
        reason: event.reason,
        ipAddress: event.ipAddress,
        device: event.device,
      })),
      nextCursor:
        found.length > AUDIT_LOG_PAGE && last !== undefined ? `${last.position}_${last.id}` : null,
    };
  }
}
