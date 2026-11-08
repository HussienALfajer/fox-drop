import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, sql } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { ContentRefusedError, type ContentEdit } from './content.service.js';
import { TERMS_MAX, type TermsAudience } from './lists.js';
import { termsAcceptances, termsVersions } from './schema.js';

export interface TermsVersion {
  audience: TermsAudience;
  version: number;
  body: string;
  publishedAt: Date;
}

type Executor = Pick<Database['db'], 'select' | 'insert' | 'execute'>;

// AP §9.13 «الشروط والخصوصية»: the versions of each audience's document and
// which one each account accepted. Publishing a version makes every account
// of the audience accept it again on its next open (CU §4.7, CA §4.8, RA
// §4.10); what that blocks is each party's rule.
@Injectable()
export class TermsService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
  ) {}

  // The version in force: the newest. The migration seeds the first.
  async current(audience: TermsAudience, executor: Executor = this.database.db) {
    const [row] = await executor
      .select()
      .from(termsVersions)
      .where(eq(termsVersions.audience, audience))
      .orderBy(desc(termsVersions.version))
      .limit(1);
    if (row === undefined) throw new Error(`no ${audience} terms version`);
    return versionOf(row);
  }

  // Whether the account has not accepted the version in force.
  async pending(audience: TermsAudience, accountId: string): Promise<boolean> {
    const { version } = await this.current(audience);
    return !(await this.accepted(this.database.db, audience, accountId, version));
  }

  // «Accept terms» (CU §15, CA §15): the version the app showed. Refused
  // terms_outdated when a newer one was published meanwhile, so nobody
  // accepts a text they did not see. Accepting again changes nothing.
  async accept(
    audience: TermsAudience,
    accountId: string,
    version: number,
    now: Date,
    executor: Executor = this.database.db,
  ): Promise<void> {
    const current = await this.current(audience, executor);
    if (version !== current.version) {
      throw new ContentRefusedError(
        'terms_outdated',
        `version ${version} is not the ${audience} terms in force (${current.version})`,
      );
    }
    await executor
      .insert(termsAcceptances)
      .values({ audience, accountId, version, acceptedAt: now })
      .onConflictDoNothing();
  }

  // The customer's sign-up (CU §5.3): «أوافق على الشروط وسياسة الخصوصية»
  // accepts the version in force, in the caller's transaction.
  async acceptCurrent(
    audience: TermsAudience,
    accountId: string,
    now: Date,
    executor: Executor,
  ): Promise<void> {
    const { version } = await this.current(audience, executor);
    await this.accept(audience, accountId, version, now, executor);
  }

  // The panel's «نشر نسخة جديدة» (AP §9.13): the next version, audited.
  // Refused terms_unchanged for the text in force, which would only make
  // everyone accept it again.
  async publish(
    audience: TermsAudience,
    body: string,
    edit: ContentEdit,
    now: Date,
  ): Promise<TermsVersion> {
    const text = body.trim();
    if (text.length === 0 || text.length > TERMS_MAX) {
      throw new ContentRefusedError('invalid_value', `the terms have 1 to ${TERMS_MAX} characters`);
    }
    return this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`content:terms:${audience}`}, 0))`,
      );
      const current = await this.current(audience, tx);
      if (current.body === text) {
        throw new ContentRefusedError('terms_unchanged', 'the text is the version in force');
      }
      const [row] = await tx
        .insert(termsVersions)
        .values({
          audience,
          version: current.version + 1,
          body: text,
          publishedBy: edit.admin.accountId,
          publishedAt: now,
        })
        .returning();
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: edit.admin.accountId, role: edit.admin.roles.join(',') },
          context: edit.context,
          cityId: null,
          action: 'content.terms.publish',
          target: { type: 'content', id: `terms.${audience}` },
          before: { version: current.version },
          after: { version: row!.version },
          reason: null,
        },
        tx,
      );
      return versionOf(row!);
    });
  }

  private async accepted(
    executor: Executor,
    audience: TermsAudience,
    accountId: string,
    version: number,
  ): Promise<boolean> {
    const rows = await executor
      .select({ version: termsAcceptances.version })
      .from(termsAcceptances)
      .where(
        and(
          eq(termsAcceptances.audience, audience),
          eq(termsAcceptances.accountId, accountId),
          eq(termsAcceptances.version, version),
        ),
      );
    return rows.length > 0;
  }
}

function versionOf(row: typeof termsVersions.$inferSelect): TermsVersion {
  return {
    audience: row.audience,
    version: row.version,
    body: row.body,
    publishedAt: row.publishedAt,
  };
}
