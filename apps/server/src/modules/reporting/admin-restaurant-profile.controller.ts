import {
  BadRequestException,
  Body,
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
  type AdminSession,
  AdminSessionsService,
  MerchantAccountsService,
} from '../identity/index.js';
import {
  MerchantsRefusedError,
  MerchantsService,
  RESTAURANT_NOTE_MAX,
  RestaurantNoteKeyReusedError,
  RestaurantNotesService,
} from '../merchants/index.js';

// How many changes the log shows, newest first (decided by us).
export const CHANGE_LOG_LIMIT = 200;

class AdminRestaurantProfileParamsDto extends createZodDto(z.object({ restaurantId: z.uuid() })) {}

class AdminRestaurantNotesDto extends createZodDto(
  z.object({
    notes: z
      .array(
        z.object({
          id: z.uuid(),
          body: z.string(),
          authorName: z.string().nullable(),
          createdAt: z.iso.datetime(),
        }),
      )
      .describe('Newest first.'),
  }),
) {}

class AdminAddRestaurantNoteDto extends createZodDto(
  z.object({ body: z.string().trim().min(1).max(RESTAURANT_NOTE_MAX) }),
) {}

class AdminRestaurantChangeLogDto extends createZodDto(
  z.object({
    entries: z
      .array(
        z.object({
          id: z.uuid(),
          at: z.iso.datetime(),
          action: z
            .string()
            .describe('The audit action, such as restaurant.operations or restaurant.commission.'),
          actorType: z.enum(['admin', 'merchant', 'captain', 'customer', 'system']),
          actorName: z
            .string()
            .nullable()
            .describe('The admin or the restaurant user; null for the system.'),
          actorRole: z.string().nullable(),
          account: z
            .string()
            .nullable()
            .describe('The restaurant user an account change is about, by name.'),
          changes: z
            .array(
              z.object({
                field: z.string(),
                before: z.string().nullable().describe('The value as JSON; null for none.'),
                after: z.string().nullable(),
              }),
            )
            .describe('The changed fields only.'),
          reason: z.string().nullable(),
        }),
      )
      .describe(`The latest ${CHANGE_LOG_LIMIT} changes, newest first.`),
  }),
) {}

const json = (value: unknown) => (value === null || value === undefined ? null : JSON.stringify(value));

// AP §9.6.4 «ملاحظات» and «سجل التغييرات» (slice 2.30d): a restaurant's
// internal notes, which every reader of restaurants adds (owner decision
// 2026-11-18; Idempotency-Key, 422 idempotency_key_reused), and its change
// log, the audit log's writes on the restaurant and its users: its data,
// hours, commission, state and accounts (the price log joins with the menu
// editor, 2.31).
@AdminController('restaurants')
export class AdminRestaurantProfileReadsController {
  constructor(
    private readonly merchants: MerchantsService,
    private readonly notes: RestaurantNotesService,
    private readonly audit: AuditService,
    private readonly admins: AdminSessionsService,
    private readonly accounts: MerchantAccountsService,
  ) {}

  @Get(':restaurantId/notes')
  @RequirePermission('restaurants.read')
  @ZodResponse({ status: 200, type: AdminRestaurantNotesDto })
  async listNotes(@Param() params: AdminRestaurantProfileParamsDto) {
    await this.found(params.restaurantId);
    return this.notesAnswer(params.restaurantId);
  }

  @Post(':restaurantId/notes')
  @RequirePermission('restaurants.read')
  @Idempotent()
  @ZodResponse({ status: 201, type: AdminRestaurantNotesDto })
  async addNote(
    @Param() params: AdminRestaurantProfileParamsDto,
    @Body() body: AdminAddRestaurantNoteDto,
    @IdempotencyKey() idempotencyKey: string,
    @CurrentAdminSession() session: AdminSession,
    @Req() request: FastifyRequest,
  ) {
    try {
      await this.notes.add(
        params.restaurantId,
        { body: body.body, idempotencyKey },
        {
          actor: { type: 'admin', id: session.accountId, role: session.roles.join(',') },
          context: requestContext(request),
        },
      );
    } catch (error) {
      if (error instanceof RestaurantNoteKeyReusedError) {
        throw new UnprocessableEntityException({
          statusCode: HttpStatus.UNPROCESSABLE_ENTITY,
          error: 'idempotency_key_reused',
        });
      }
      if (error instanceof MerchantsRefusedError && error.refusal === 'unknown_restaurant') {
        throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: error.refusal });
      }
      if (error instanceof MerchantsRefusedError) {
        throw new BadRequestException({ statusCode: HttpStatus.BAD_REQUEST, error: error.refusal });
      }
      throw error;
    }
    return this.notesAnswer(params.restaurantId);
  }

  @Get(':restaurantId/change-log')
  @RequirePermission('restaurants.read')
  @ZodResponse({ status: 200, type: AdminRestaurantChangeLogDto })
  async changeLog(@Param() params: AdminRestaurantProfileParamsDto) {
    await this.found(params.restaurantId);
    const users = await this.accounts.everyAccount(params.restaurantId);
    const entries = await this.audit.history(
      [
        { type: 'restaurant', ids: [params.restaurantId] },
        { type: 'merchant_account', ids: [...users.keys()] },
      ],
      CHANGE_LOG_LIMIT,
    );
    const admins = await this.admins.names(
      entries.flatMap((entry) =>
        entry.actor.type === 'admin' && entry.actor.id !== null ? [entry.actor.id] : [],
      ),
    );
    return {
      entries: entries.map((entry) => ({
        id: entry.id,
        at: entry.occurredAt.toISOString(),
        action: entry.action,
        actorType: entry.actor.type,
        actorName:
          entry.actor.id === null
            ? null
            : entry.actor.type === 'admin'
              ? (admins.get(entry.actor.id) ?? null)
              : entry.actor.type === 'merchant'
                ? (users.get(entry.actor.id) ?? null)
                : null,
        actorRole: entry.actor.role,
        account: entry.target.type === 'merchant_account' ? (users.get(entry.target.id) ?? null) : null,
        changes: Object.entries(entry.changes ?? {}).map(([field, change]) => ({
          field,
          before: json(change.before),
          after: json(change.after),
        })),
        reason: entry.reason,
      })),
    };
  }

  private async notesAnswer(restaurantId: string) {
    const notes = await this.notes.notes(restaurantId);
    const names = await this.admins.names(notes.map((note) => note.authorId));
    return {
      notes: notes.map((note) => ({
        id: note.id,
        body: note.body,
        authorName: names.get(note.authorId) ?? null,
        createdAt: note.createdAt.toISOString(),
      })),
    };
  }

  private async found(restaurantId: string): Promise<void> {
    if ((await this.merchants.cityAndStatus(restaurantId)) === null) {
      throw new NotFoundException({ statusCode: HttpStatus.NOT_FOUND, error: 'unknown_restaurant' });
    }
  }
}
