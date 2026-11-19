import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import {
  type MerchantChange,
  MerchantsRefusedError,
  MerchantsService,
} from './merchants.service.js';
import { restaurantNotes } from './schema.js';

export const RESTAURANT_NOTE_MAX = 500;

export interface RestaurantNote {
  id: string;
  body: string;
  authorId: string;
  createdAt: Date;
}

export class RestaurantNoteKeyReusedError extends Error {
  constructor() {
    super('the key named another note');
  }
}

// AP §9.6.4 «ملاحظات» (slice 2.30d, owner decision 2026-11-18): internal
// notes on a restaurant, added by any reader of restaurants, never changed
// or removed. The Idempotency-Key is kept with the note (customers' notes
// do the same), so a retry adds none.
@Injectable()
export class RestaurantNotesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly merchants: MerchantsService,
    private readonly audit: AuditService,
  ) {}

  async notes(restaurantId: string): Promise<RestaurantNote[]> {
    return this.database.db
      .select({
        id: restaurantNotes.id,
        body: restaurantNotes.body,
        authorId: restaurantNotes.authorId,
        createdAt: restaurantNotes.createdAt,
      })
      .from(restaurantNotes)
      .where(eq(restaurantNotes.restaurantId, restaurantId))
      .orderBy(desc(restaurantNotes.createdAt), desc(restaurantNotes.id));
  }

  // 400 invalid_restaurant for an empty or long body, 404
  // unknown_restaurant, RestaurantNoteKeyReusedError for the key of another
  // note.
  async add(
    restaurantId: string,
    command: { body: string; idempotencyKey: string },
    change: MerchantChange & { actor: { id: string } },
    now = new Date(),
  ): Promise<void> {
    const body = command.body.trim();
    if (body.length === 0 || body.length > RESTAURANT_NOTE_MAX) {
      throw new MerchantsRefusedError(
        'invalid_restaurant',
        `a note is 1 to ${RESTAURANT_NOTE_MAX} characters`,
      );
    }
    const authorId = change.actor.id;
    const requestHash = createHash('sha256')
      .update(JSON.stringify({ restaurantId, body }))
      .digest('hex');
    const earlier = async () => {
      const [row] = await this.database.db
        .select({ requestHash: restaurantNotes.requestHash })
        .from(restaurantNotes)
        .where(
          and(
            eq(restaurantNotes.authorId, authorId),
            eq(restaurantNotes.idempotencyKey, command.idempotencyKey),
          ),
        );
      if (row && row.requestHash !== requestHash) throw new RestaurantNoteKeyReusedError();
      return row !== undefined;
    };
    if (await earlier()) return;
    const restaurant = await this.merchants.cityAndStatus(restaurantId);
    if (restaurant === null) {
      throw new MerchantsRefusedError('unknown_restaurant', 'no such restaurant');
    }
    await this.database.db.transaction(async (tx) => {
      const inserted = await tx
        .insert(restaurantNotes)
        .values({
          cityId: restaurant.cityId,
          restaurantId,
          body,
          authorId,
          createdAt: now,
          idempotencyKey: command.idempotencyKey,
          requestHash,
        })
        .onConflictDoNothing({ target: [restaurantNotes.authorId, restaurantNotes.idempotencyKey] })
        .returning({ id: restaurantNotes.id });
      // A repeat sent with the first wrote nothing: nothing to audit.
      if (inserted.length === 0) return;
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: restaurant.cityId,
          action: 'restaurant.note',
          target: { type: 'restaurant', id: restaurantId },
          before: null,
          // Never the text, which may hold a number (the audit log's rule).
          after: { noteId: inserted[0]!.id, length: body.length },
        },
        tx,
      );
    });
    // A repeat sent with the first lands on the key's unique index: answer
    // as the first, or refuse another body.
    await earlier();
  }
}
