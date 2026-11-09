import { sql } from 'drizzle-orm';
import { check, integer, pgSchema, text, timestamp, uuid } from 'drizzle-orm/pg-core';

// Architecture §4.3: the files module owns the files schema.
export const files = pgSchema('files');

// What an upload is for: the record it may be linked to (architecture §5.8).
export const uploadPurposes = ['restaurant_logo', 'restaurant_cover', 'item_photo'] as const;
export type UploadPurpose = (typeof uploadPurposes)[number];

// The image types the panel may upload; the server checks the stored bytes.
export const imageTypes = ['image/jpeg', 'image/png', 'image/webp'] as const;
export type ImageType = (typeof imageTypes)[number];

// One pre-signed upload to public-media. The object's key is new for every
// upload and never reused, so a cached image never goes stale. linked_at is
// set once, when a record takes the file, after its size, type and first
// bytes are checked; an upload never linked stays an unused object.
export const uploads = files.table(
  'uploads',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    purpose: text('purpose', { enum: uploadPurposes }).notNull(),
    key: text('key').notNull().unique(),
    contentType: text('content_type', { enum: imageTypes }).notNull(),
    sizeBytes: integer('size_bytes').notNull(),
    // The admin account (identity's id, a plain column) that asked for it.
    createdBy: uuid('created_by').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    linkedAt: timestamp('linked_at', { withTimezone: true }),
  },
  (table) => [
    check(
      'uploads_purpose_values',
      sql`${table.purpose} IN ('restaurant_logo', 'restaurant_cover', 'item_photo')`,
    ),
    check(
      'uploads_content_type_values',
      sql`${table.contentType} IN ('image/jpeg', 'image/png', 'image/webp')`,
    ),
    check('uploads_size_positive', sql`${table.sizeBytes} > 0`),
  ],
);
