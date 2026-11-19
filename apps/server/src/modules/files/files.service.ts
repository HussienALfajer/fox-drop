import { randomUUID } from 'node:crypto';
import {
  CopyObjectCommand,
  DeleteObjectCommand,
  GetObjectCommand,
  HeadObjectCommand,
  NoSuchKey,
  NotFound,
  PutObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, gt } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { PRIVATE_DOCS_BUCKET, PUBLIC_MEDIA_BUCKET } from '../../storage/storage-setup.js';
import { imageSize } from './image-size.js';
import {
  type ImageType,
  type UploadPurpose,
  type UploadType,
  uploads,
  XLSX_TYPE,
} from './schema.js';

// Architecture §5.8: the largest image the panel may upload. A phone photo is
// 2 to 5 MB; imgproxy serves it at most 1280 pixels wide.
export const MAX_IMAGE_BYTES = 8 * 1024 * 1024;
// AP §9.6.6 (slice 2.31, decided by us): the largest menu workbook.
export const MAX_IMPORT_BYTES = 2 * 1024 * 1024;

// What each purpose takes: a menu's import an Excel workbook of 2 MB at
// most, every other an image of 8 MB at most.
export function uploadAllowed(purpose: UploadPurpose, type: UploadType, size: number): boolean {
  return purpose === 'menu_import'
    ? type === XLSX_TYPE && size <= MAX_IMPORT_BYTES
    : type !== XLSX_TYPE && size <= MAX_IMAGE_BYTES;
}
// How long the pre-signed PUT stays valid, and how long after asking an
// upload may still be linked.
export const UPLOAD_URL_SECONDS = 10 * 60;
export const LINK_WITHIN_MS = 60 * 60 * 1000;
// A customer's report photos asked in an hour (slice 2.24a): a report takes
// at most 3, so this leaves room for retries and stops an account from
// filling the storage (architecture §15).
export const REPORT_UPLOADS_PER_HOUR = 20;

export type FilesRefusal =
  | 'upload_not_found'
  | 'upload_wrong_purpose'
  | 'upload_used'
  | 'upload_expired'
  | 'upload_missing'
  | 'upload_invalid'
  | 'upload_wrong_size'
  | 'too_many_uploads';

export class FilesRefusedError extends Error {
  override readonly name = 'FilesRefusedError';
  constructor(
    readonly refusal: FilesRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface NewUpload {
  purpose: UploadPurpose;
  contentType: UploadType;
  sizeBytes: number;
}

export interface SignedUpload {
  uploadId: string;
  // A PUT of the file's exact bytes with this Content-Type.
  url: string;
  expiresAt: Date;
}

// The transaction a record links an upload in.
export type FilesExecutor = Pick<Database['db'], 'select' | 'update'>;

// Where the panel uploads: a pre-signed PUT may write here for 10 minutes,
// so nothing here is ever shown. imgproxy's nginx path serves only the
// published folders below.
const INCOMING = 'incoming';

// Where a checked file is published, by purpose.
const folders: Record<UploadPurpose, string> = {
  restaurant_logo: 'restaurants/logos',
  restaurant_cover: 'restaurants/covers',
  item_photo: 'menu/items',
  report_photo: 'tickets/photos',
  category_image: 'content/categories',
  banner_image: 'marketing/banners',
  restaurant_contract: 'restaurants/contracts',
  restaurant_licence: 'restaurants/licences',
  menu_import: 'menus/imports',
  captain_document: 'captains/documents',
};

// The purposes whose image must have an exact size in pixels: a banner is
// cut to 1200×500 in the panel before it is uploaded (AP §9.11.2, owner
// decision 2026-11-18), so every phone shows the same frame.
export const EXACT_IMAGE_SIZES: Partial<Record<UploadPurpose, { width: number; height: number }>> =
  { banner_image: { width: 1200, height: 500 } };
// How much of the file the size is read from: a JPEG's frame header follows
// its other segments (EXIF can run to 64 KB).
const SIZE_HEAD_BYTES = 128 * 1024;

// A report's photo is the customer's (owner decision 2026-11-17): it goes to
// private-docs, uploaded from the app. A restaurant's contract and licence
// scans (AP §9.6.3 step 5, slice 2.30a) go to private-docs from the panel.
// The others go to public-media from the panel, and a restaurant owner's
// item photo from the restaurant app too (slice 2.32b, `createUpload`'s
// `from`).
const APP_PURPOSES: readonly UploadPurpose[] = ['report_photo', 'captain_document'];
const PRIVATE_PURPOSES: readonly UploadPurpose[] = [
  'report_photo',
  'restaurant_contract',
  'restaurant_licence',
  'menu_import',
  'captain_document',
];

function bucketOf(purpose: UploadPurpose): string {
  return PRIVATE_PURPOSES.includes(purpose) ? PRIVATE_DOCS_BUCKET : PUBLIC_MEDIA_BUCKET;
}
const extensions: Record<UploadType, string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
  [XLSX_TYPE]: 'xlsx',
};

// The published key of an upload: its file's name in its purpose's folder.
function publishedKey(row: { purpose: UploadPurpose; key: string }): string {
  return `${folders[row.purpose]}/${row.key.slice(INCOMING.length + 1)}`;
}

// The first bytes of each type (its file signature); a workbook is a ZIP.
export function hasSignature(type: UploadType, head: Uint8Array): boolean {
  if (type === XLSX_TYPE) return [0x50, 0x4b, 0x03, 0x04].every((byte, i) => head[i] === byte);
  return hasImageSignature(type, head);
}

export function hasImageSignature(type: ImageType, head: Uint8Array): boolean {
  const starts = (bytes: number[], at = 0) => bytes.every((byte, i) => head[at + i] === byte);
  switch (type) {
    case 'image/jpeg':
      return starts([0xff, 0xd8, 0xff]);
    case 'image/png':
      return starts([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
    case 'image/webp':
      // RIFF, the size, then WEBP.
      return starts([0x52, 0x49, 0x46, 0x46]) && starts([0x57, 0x45, 0x42, 0x50], 8);
  }
}

interface Storage {
  // Reads and checks objects on the environment's network.
  internal: S3Client;
  // Signs the panel's uploads and downloads for its own origin, whose
  // /public-media/incoming/ (PUT), /private-docs/exports/ and
  // /private-docs/tickets/ (GET) paths nginx (and Vite in development)
  // forward to the storage.
  uploads: S3Client;
  // Signs the apps' uploads for APP_UPLOAD_URL (the API's host, whose
  // /private-docs/incoming/ nginx forwards for PUT); built on first use.
  apps: () => S3Client;
}

// The storage from STORAGE_URL, STORAGE_KEY_ID, STORAGE_SECRET,
// ADMIN_PANEL_URL and, for the apps' uploads, APP_UPLOAD_URL. Built on first use, so a process or test that never
// uploads needs none of them.
function storageFromEnvironment(env: NodeJS.ProcessEnv = process.env): Storage {
  const value = (name: string) => {
    const found = env[name];
    if (!found) throw new Error(`${name} is not set: the object storage is off`);
    return found;
  };
  const client = (endpoint: string) =>
    new S3Client({
      endpoint,
      region: 'garage',
      forcePathStyle: true,
      credentials: {
        accessKeyId: value('STORAGE_KEY_ID'),
        secretAccessKey: value('STORAGE_SECRET'),
      },
      // Garage does not need the SDK's default checksums, and a pre-signed
      // URL must not carry one the browser cannot send.
      requestChecksumCalculation: 'WHEN_REQUIRED',
      responseChecksumValidation: 'WHEN_REQUIRED',
      // A storage that stops answering fails the request instead of holding
      // a pool connection.
      requestHandler: { connectionTimeout: 2_000, requestTimeout: 10_000 },
    });
  let apps: S3Client | undefined;
  return {
    internal: client(value('STORAGE_URL')),
    uploads: client(new URL(value('ADMIN_PANEL_URL')).origin),
    apps: () => (apps ??= client(new URL(value('APP_UPLOAD_URL')).origin)),
  };
}

// Architecture §5.8: uploads go straight from the panel to public-media with
// a pre-signed PUT, and a record links the file only after the server checks
// it. The module owns no record that shows an image: the merchants module
// links logos, covers and item photos with `prepare` and `link`.
@Injectable()
export class FilesService {
  private storage: Storage | undefined;

  constructor(@Inject(DATABASE) private readonly database: Database) {}

  private get store(): Storage {
    this.storage ??= storageFromEnvironment();
    return this.storage;
  }

  // A new upload with its pre-signed PUT to `incoming/`. The type and the
  // size are signed, so the storage refuses any other body. No
  // Idempotency-Key: the answer is a URL to upload with, never stored, and
  // asking again makes another upload, of which only the linked one is used.
  // An app's upload (a report's photo, a restaurant owner's item photo,
  // slice 2.32b) is signed for the apps' origin and limited per account and
  // hour; every other upload for the panel's. The bucket follows the purpose.
  async createUpload(
    upload: NewUpload,
    accountId: string,
    now = new Date(),
    from: 'panel' | 'app' = APP_PURPOSES.includes(upload.purpose) ? 'app' : 'panel',
  ) {
    const key = `${INCOMING}/${randomUUID()}.${extensions[upload.contentType]}`;
    const fromApp = from === 'app';
    if (fromApp) {
      const [{ asked }] = (await this.database.db
        .select({ asked: count() })
        .from(uploads)
        .where(
          and(
            eq(uploads.createdBy, accountId),
            eq(uploads.purpose, upload.purpose),
            gt(uploads.createdAt, new Date(now.getTime() - 3_600_000)),
          ),
        )) as [{ asked: number }];
      if (asked >= REPORT_UPLOADS_PER_HOUR) {
        throw new FilesRefusedError('too_many_uploads', 'too many photos this hour');
      }
    }
    const url = await getSignedUrl(
      fromApp ? this.store.apps() : this.store.uploads,
      new PutObjectCommand({
        Bucket: bucketOf(upload.purpose),
        Key: key,
        ContentType: upload.contentType,
        ContentLength: upload.sizeBytes,
      }),
      {
        expiresIn: UPLOAD_URL_SECONDS,
        signableHeaders: new Set(['content-type', 'content-length']),
        signingDate: now,
      },
    );
    const [{ id }] = (await this.database.db
      .insert(uploads)
      .values({ ...upload, key, createdBy: accountId, createdAt: now })
      .returning({ id: uploads.id })) as [{ id: string }];
    return {
      uploadId: id,
      url,
      expiresAt: new Date(now.getTime() + UPLOAD_URL_SECONDS * 1000),
    } satisfies SignedUpload;
  }

  // The first half of linking, before the record's transaction (it calls the
  // storage, so it never runs under a row lock): the upload must be for this
  // purpose and recent; its file is copied from `incoming/` to its published
  // key, which no pre-signed URL covers, and the copy must have the size and
  // type asked for and start with that type's signature. A file checked this
  // way can no longer change. An upload linked before passes as it is. With
  // `owner`, only that account's upload is found (a customer links only
  // their own photos).
  async prepare(
    uploadId: string,
    purpose: UploadPurpose,
    now = new Date(),
    owner: string | null = null,
  ): Promise<void> {
    const [row] = await this.database.db.select().from(uploads).where(eq(uploads.id, uploadId));
    if (!row || (owner !== null && row.createdBy !== owner)) {
      throw new FilesRefusedError('upload_not_found', `no upload ${uploadId}`);
    }
    if (row.purpose !== purpose) {
      throw new FilesRefusedError('upload_wrong_purpose', `the upload is for ${row.purpose}`);
    }
    if (row.linkedAt !== null) return;
    if (now.getTime() - row.createdAt.getTime() > LINK_WITHIN_MS) {
      throw new FilesRefusedError('upload_expired', 'the upload is older than an hour');
    }
    const key = publishedKey(row);
    const bucket = bucketOf(row.purpose);
    try {
      await this.store.internal.send(
        new CopyObjectCommand({
          Bucket: bucket,
          Key: key,
          CopySource: `${bucket}/${row.key}`,
        }),
      );
    } catch (error) {
      if (error instanceof NoSuchKey || (error as { name?: string }).name === 'NoSuchKey') {
        throw new FilesRefusedError('upload_missing', 'the file was not uploaded');
      }
      throw error;
    }
    await this.check(bucket, key, row.contentType, row.sizeBytes, EXACT_IMAGE_SIZES[row.purpose]);
  }

  // The second half, in the record's transaction after `prepare`: takes the
  // upload's lock and marks it linked. `alreadyLinked` is true when an earlier
  // call linked it: the caller decides whether that is a repeat of the same
  // change (the same key) or a refusal (`upload_used`).
  async link(
    tx: FilesExecutor,
    uploadId: string,
    now = new Date(),
  ): Promise<{ key: string; alreadyLinked: boolean }> {
    const [row] = await tx.select().from(uploads).where(eq(uploads.id, uploadId)).for('update');
    if (!row) throw new FilesRefusedError('upload_not_found', `no upload ${uploadId}`);
    const key = publishedKey(row);
    if (row.linkedAt !== null) return { key, alreadyLinked: true };
    await tx.update(uploads).set({ linkedAt: now }).where(eq(uploads.id, uploadId));
    return { key, alreadyLinked: false };
  }

  // Architecture §5.8, §5.9: a file the server writes to private-docs (an
  // Excel export), never public.
  async putPrivate(key: string, body: Uint8Array, contentType: string): Promise<void> {
    await this.store.internal.send(
      new PutObjectCommand({
        Bucket: PRIVATE_DOCS_BUCKET,
        Key: key,
        Body: body,
        ContentType: contentType,
      }),
    );
  }

  // A short signed GET of a private file on the panel's origin, saved as
  // `fileName` (RFC 6266, with an ASCII fallback).
  async privateDownloadUrl(
    key: string,
    fileName: string,
    seconds: number,
    now = new Date(),
  ): Promise<string> {
    const encoded = encodeURIComponent(fileName).replace(
      /['()*]/g,
      (character) => `%${character.charCodeAt(0).toString(16).toUpperCase()}`,
    );
    const extension = /\.[a-z0-9]+$/i.exec(fileName)?.[0] ?? '';
    return getSignedUrl(
      this.store.uploads,
      new GetObjectCommand({
        Bucket: PRIVATE_DOCS_BUCKET,
        Key: key,
        ResponseContentDisposition: `attachment; filename="download${extension}"; filename*=UTF-8''${encoded}`,
      }),
      { expiresIn: seconds, signingDate: now },
    );
  }

  // A short signed GET of a private image on the panel's origin, shown in
  // the page: a report's photo under tickets/ (slice 2.24a) or a
  // restaurant's scan under restaurants/ (slice 2.30a), the two paths nginx
  // forwards.
  privateImageUrl(key: string, seconds: number, now = new Date()): Promise<string> {
    return getSignedUrl(
      this.store.uploads,
      new GetObjectCommand({ Bucket: PRIVATE_DOCS_BUCKET, Key: key }),
      { expiresIn: seconds, signingDate: now },
    );
  }

  // The bytes of a private upload `prepare` checked (a menu's workbook, read
  // by the server; slice 2.31).
  async preparedBytes(uploadId: string): Promise<Uint8Array> {
    const [row] = await this.database.db.select().from(uploads).where(eq(uploads.id, uploadId));
    if (!row) throw new FilesRefusedError('upload_not_found', `no upload ${uploadId}`);
    const file = await this.store.internal.send(
      new GetObjectCommand({ Bucket: bucketOf(row.purpose), Key: publishedKey(row) }),
    );
    return (await file.Body?.transformToByteArray()) ?? new Uint8Array();
  }

  // Removes a private file; one already gone is fine.
  async deletePrivate(key: string): Promise<void> {
    await this.store.internal.send(
      new DeleteObjectCommand({ Bucket: PRIVATE_DOCS_BUCKET, Key: key }),
    );
  }

  // `exact`: the pixel size the image must have (`upload_wrong_size`).
  private async check(
    bucket: string,
    key: string,
    type: UploadType,
    size: number,
    exact?: { width: number; height: number },
  ): Promise<void> {
    const object = { Bucket: bucket, Key: key };
    let head;
    try {
      head = await this.store.internal.send(new HeadObjectCommand(object));
    } catch (error) {
      if (error instanceof NotFound) {
        throw new FilesRefusedError('upload_missing', 'the file was not uploaded');
      }
      throw error;
    }
    if (head.ContentLength !== size || head.ContentType !== type) {
      throw new FilesRefusedError('upload_invalid', 'the stored file differs from the upload');
    }
    const start = await this.store.internal.send(
      new GetObjectCommand({
        ...object,
        Range: `bytes=0-${exact === undefined ? 15 : SIZE_HEAD_BYTES - 1}`,
      }),
    );
    const bytes = (await start.Body?.transformToByteArray()) ?? new Uint8Array();
    if (!hasSignature(type, bytes)) {
      throw new FilesRefusedError('upload_invalid', `the file is not a ${type}`);
    }
    if (exact === undefined || type === XLSX_TYPE) return;
    const found = imageSize(type, bytes);
    if (found === null) {
      throw new FilesRefusedError('upload_invalid', `the ${type} image has no readable size`);
    }
    if (found.width !== exact.width || found.height !== exact.height) {
      throw new FilesRefusedError(
        'upload_wrong_size',
        `the image is ${found.width}×${found.height}, not ${exact.width}×${exact.height}`,
      );
    }
  }
}
