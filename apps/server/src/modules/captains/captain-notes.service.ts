import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { type CaptainChange, CaptainsRefusedError, CaptainsService } from './captains.service.js';
import { captainNotes } from './schema.js';

export const CAPTAIN_NOTE_MAX = 500;

export interface CaptainNote {
  id: string;
  body: string;
  authorId: string;
  createdAt: Date;
}

export class CaptainNoteKeyReusedError extends Error {
  constructor() {
    super('the key named another note');
  }
}

// AP §9.7.4 «ملاحظات» (slice 2.36a): internal notes on a captain, as the
// restaurants' (AP §9.6.4, owner decision 2026-11-18: any reader adds one),
// never changed or removed. The Idempotency-Key is kept with the note (customers' notes
// do the same), so a retry adds none.
@Injectable()
export class CaptainNotesService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly captains: CaptainsService,
    private readonly audit: AuditService,
  ) {}

  async notes(captainId: string): Promise<CaptainNote[]> {
    return this.database.db
      .select({
        id: captainNotes.id,
        body: captainNotes.body,
        authorId: captainNotes.authorId,
        createdAt: captainNotes.createdAt,
      })
      .from(captainNotes)
      .where(eq(captainNotes.captainId, captainId))
      .orderBy(desc(captainNotes.createdAt), desc(captainNotes.id));
  }

  // 400 invalid_captain for an empty or long body, 404 unknown_captain,
  // CaptainNoteKeyReusedError for the key of another note.
  async add(
    captainId: string,
    command: { body: string; idempotencyKey: string },
    change: CaptainChange & { actor: { id: string } },
    now = new Date(),
  ): Promise<void> {
    const body = command.body.trim();
    if (body.length === 0 || body.length > CAPTAIN_NOTE_MAX) {
      throw new CaptainsRefusedError(
        'invalid_captain',
        `a note is 1 to ${CAPTAIN_NOTE_MAX} characters`,
      );
    }
    const authorId = change.actor.id;
    const requestHash = createHash('sha256')
      .update(JSON.stringify({ captainId, body }))
      .digest('hex');
    const earlier = async () => {
      const [row] = await this.database.db
        .select({ requestHash: captainNotes.requestHash })
        .from(captainNotes)
        .where(
          and(
            eq(captainNotes.authorId, authorId),
            eq(captainNotes.idempotencyKey, command.idempotencyKey),
          ),
        );
      if (row && row.requestHash !== requestHash) throw new CaptainNoteKeyReusedError();
      return row !== undefined;
    };
    if (await earlier()) return;
    const captain = await this.captains.captain(captainId, now);
    if (captain === null) {
      throw new CaptainsRefusedError('unknown_captain', 'no such captain');
    }
    await this.database.db.transaction(async (tx) => {
      const inserted = await tx
        .insert(captainNotes)
        .values({
          cityId: captain.cityId,
          captainId,
          body,
          authorId,
          createdAt: now,
          idempotencyKey: command.idempotencyKey,
          requestHash,
        })
        .onConflictDoNothing({ target: [captainNotes.authorId, captainNotes.idempotencyKey] })
        .returning({ id: captainNotes.id });
      // A repeat sent with the first wrote nothing: nothing to audit.
      if (inserted.length === 0) return;
      await this.audit.recordWrite(
        {
          actor: change.actor,
          context: change.context,
          cityId: captain.cityId,
          action: 'captain.note',
          target: { type: 'captain', id: captainId },
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
