import { Inject, Injectable } from '@nestjs/common';
import { eq, like, sql } from 'drizzle-orm';
import { z } from 'zod';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { AuditService } from '../audit/index.js';
import { ContentRefusedError, type ContentEdit } from './content.service.js';
import {
  NOTIFICATION_TEMPLATES,
  NOTIFICATION_TEXT_MAX,
  notificationTemplate,
  type NotificationTemplate,
  renderNotification,
  variablesOf,
} from './notification-templates.js';
import { texts } from './schema.js';

const PREFIX = 'notification.';
const stored = z.object({ text: z.string().min(1) });

export interface NotificationText extends NotificationTemplate {
  // The text in use: the admin's edit, else the default.
  current: string;
}

// A push ready to send: its rendered text, the template's sound level and
// priority.
export interface RenderedNotification {
  key: string;
  body: string;
  level: NotificationTemplate['level'];
  priority: NotificationTemplate['priority'];
}

// AP §9.13 «نصوص الإشعارات»: each template's text, edited in the panel
// (content.manage, audited as content.text.update) and rendered for each
// push. An edit keeps to the template's variables, so a push never shows a
// placeholder nobody fills.
@Injectable()
export class NotificationTexts {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly audit: AuditService,
  ) {}

  async all(): Promise<NotificationText[]> {
    const edits = await this.edits();
    return NOTIFICATION_TEMPLATES.map((template) => ({
      ...template,
      current: edits.get(template.key) ?? template.text,
    }));
  }

  // The template's text in use, filled with the values.
  async render(key: string, values: Record<string, string>): Promise<RenderedNotification> {
    const template = notificationTemplate(key);
    if (!template) throw new Error(`no notification template ${key}`);
    const [row] = await this.database.db
      .select({ value: texts.value })
      .from(texts)
      .where(eq(texts.key, PREFIX + key));
    const edit = stored.safeParse(row?.value);
    return {
      key,
      body: renderNotification(edit.success ? edit.data.text : template.text, values),
      level: template.level,
      priority: template.priority,
    };
  }

  // 404 unknown_template; 400 invalid_value (empty or too long),
  // unknown_variable (a placeholder the template does not take).
  async update(key: string, text: string, edit: ContentEdit): Promise<NotificationText> {
    const template = notificationTemplate(key);
    if (!template) throw new ContentRefusedError('unknown_template', `no template ${key}`);
    const value = text.trim();
    if (value.length === 0 || value.length > NOTIFICATION_TEXT_MAX) {
      throw new ContentRefusedError(
        'invalid_value',
        `a notification has 1 to ${NOTIFICATION_TEXT_MAX} characters`,
      );
    }
    const unknown = variablesOf(value).filter((name) => !template.variables.includes(name));
    if (unknown.length > 0) {
      throw new ContentRefusedError(
        'unknown_variable',
        `${key} takes no {${unknown.join('}, {')}}`,
      );
    }
    const textKey = PREFIX + key;
    await this.database.db.transaction(async (tx) => {
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`content:${textKey}`}, 0))`,
      );
      const [before] = await tx
        .select({ value: texts.value })
        .from(texts)
        .where(eq(texts.key, textKey));
      await tx
        .insert(texts)
        .values({ key: textKey, value: { text: value } })
        .onConflictDoUpdate({
          target: texts.key,
          set: { value: { text: value }, updatedAt: sql`now()` },
        });
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: edit.admin.accountId, role: edit.admin.roles.join(',') },
          context: edit.context,
          cityId: null,
          action: 'content.text.update',
          target: { type: 'content', id: textKey },
          before: before ? { value: before.value } : null,
          after: { value: { text: value } },
          reason: null,
        },
        tx,
      );
    });
    return { ...template, current: value };
  }

  private async edits(): Promise<Map<string, string>> {
    const rows = await this.database.db
      .select({ key: texts.key, value: texts.value })
      .from(texts)
      .where(like(texts.key, `${PREFIX}%`));
    const edits = new Map<string, string>();
    for (const row of rows) {
      const edit = stored.safeParse(row.value);
      if (edit.success) edits.set(row.key.slice(PREFIX.length), edit.data.text);
    }
    return edits;
  }
}
