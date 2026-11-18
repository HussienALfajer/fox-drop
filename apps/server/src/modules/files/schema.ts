import { sql } from 'drizzle-orm';
import { check, index, integer, pgSchema, text, timestamp, uuid } from 'drizzle-orm/pg-core';

// Architecture §4.3: the files module owns the files schema.
export const files = pgSchema('files');

// What an upload is for: the record it may be linked to (architecture §5.8).
// A report's photo (CU §12.2, §9.5; slice 2.24a) is the customer's, kept in
// private-docs (owner decision 2026-11-17). A category's icon or image (AP
// §9.13, slice 2.27a) is content's; a banner's image (AP §9.11.2, slice
// 2.27c) marketing's.
export const uploadPurposes = [
  'restaurant_logo',
  'restaurant_cover',
  'item_photo',
  'report_photo',
  'category_image',
  'banner_image',
  // AP §9.6.3 step 5 (slice 2.30a): a restaurant's contract and its
  // commercial registration or licence, scanned, in private-docs.
  'restaurant_contract',
  'restaurant_licence',
] as const;
export type UploadPurpose = (typeof uploadPurposes)[number];

// The image types the panel may upload; the server checks the stored bytes.
export const imageTypes = ['image/jpeg', 'image/png', 'image/webp'] as const;
export type ImageType = (typeof imageTypes)[number];

// One pre-signed upload, to public-media or (a report's photo) private-docs. The object's key is new for every
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
    // The account (identity's id, a plain column) that asked for it: an
    // admin's, or the customer's for a report's photo.
    createdBy: uuid('created_by').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
    linkedAt: timestamp('linked_at', { withTimezone: true }),
  },
  (table) => [
    check(
      'uploads_purpose_values',
      sql`${table.purpose} IN ('restaurant_logo', 'restaurant_cover', 'item_photo', 'report_photo', 'category_image', 'banner_image', 'restaurant_contract', 'restaurant_licence')`,
    ),
    check(
      'uploads_content_type_values',
      sql`${table.contentType} IN ('image/jpeg', 'image/png', 'image/webp')`,
    ),
    check('uploads_size_positive', sql`${table.sizeBytes} > 0`),
    // A customer's photos asked in the last hour (slice 2.24a).
    index('uploads_created_by').on(table.createdBy, table.createdAt),
  ],
);
