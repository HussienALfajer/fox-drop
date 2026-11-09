import { randomUUID } from 'node:crypto';
import {
  CopyObjectCommand,
  GetObjectCommand,
  HeadObjectCommand,
  NoSuchKey,
  NotFound,
  PutObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { PUBLIC_MEDIA_BUCKET } from '../../storage/storage-setup.js';
import { type ImageType, type UploadPurpose, uploads } from './schema.js';

// Architecture §5.8: the largest image the panel may upload. A phone photo is
// 2 to 5 MB; imgproxy serves it at most 1280 pixels wide.
export const MAX_IMAGE_BYTES = 8 * 1024 * 1024;
// How long the pre-signed PUT stays valid, and how long after asking an
// upload may still be linked.
export const UPLOAD_URL_SECONDS = 10 * 60;
export const LINK_WITHIN_MS = 60 * 60 * 1000;

export type FilesRefusal =
  | 'upload_not_found'
  | 'upload_wrong_purpose'
  | 'upload_used'
  | 'upload_expired'
  | 'upload_missing'
  | 'upload_invalid';

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
  contentType: ImageType;
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
};
const extensions: Record<ImageType, string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
};

// The published key of an upload: its file's name in its purpose's folder.
function publishedKey(row: { purpose: UploadPurpose; key: string }): string {
  return `${folders[row.purpose]}/${row.key.slice(INCOMING.length + 1)}`;
}

// The first bytes of each type (its file signature).
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
  // Signs the panel's uploads for its own origin, whose /public-media path
  // nginx (and Vite in development) forwards to the storage.
  uploads: S3Client;
}

// The storage from STORAGE_URL, STORAGE_KEY_ID, STORAGE_SECRET and
// ADMIN_PANEL_URL. Built on first use, so a process or test that never
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
  return {
    internal: client(value('STORAGE_URL')),
    uploads: client(new URL(value('ADMIN_PANEL_URL')).origin),
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
  async createUpload(upload: NewUpload, adminAccountId: string, now = new Date()) {
    const key = `${INCOMING}/${randomUUID()}.${extensions[upload.contentType]}`;
    const url = await getSignedUrl(
      this.store.uploads,
      new PutObjectCommand({
        Bucket: PUBLIC_MEDIA_BUCKET,
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
      .values({ ...upload, key, createdBy: adminAccountId, createdAt: now })
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
  // way can no longer change. An upload linked before passes as it is.
  async prepare(uploadId: string, purpose: UploadPurpose, now = new Date()): Promise<void> {
    const [row] = await this.database.db.select().from(uploads).where(eq(uploads.id, uploadId));
    if (!row) throw new FilesRefusedError('upload_not_found', `no upload ${uploadId}`);
    if (row.purpose !== purpose) {
      throw new FilesRefusedError('upload_wrong_purpose', `the upload is for ${row.purpose}`);
    }
    if (row.linkedAt !== null) return;
    if (now.getTime() - row.createdAt.getTime() > LINK_WITHIN_MS) {
      throw new FilesRefusedError('upload_expired', 'the upload is older than an hour');
    }
    const key = publishedKey(row);
    try {
      await this.store.internal.send(
        new CopyObjectCommand({
          Bucket: PUBLIC_MEDIA_BUCKET,
          Key: key,
          CopySource: `${PUBLIC_MEDIA_BUCKET}/${row.key}`,
        }),
      );
    } catch (error) {
      if (error instanceof NoSuchKey || (error as { name?: string }).name === 'NoSuchKey') {
        throw new FilesRefusedError('upload_missing', 'the file was not uploaded');
      }
      throw error;
    }
    await this.check(key, row.contentType, row.sizeBytes);
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

  private async check(key: string, type: ImageType, size: number): Promise<void> {
    const object = { Bucket: PUBLIC_MEDIA_BUCKET, Key: key };
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
      new GetObjectCommand({ ...object, Range: 'bytes=0-15' }),
    );
    const bytes = (await start.Body?.transformToByteArray()) ?? new Uint8Array();
    if (!hasImageSignature(type, bytes)) {
      throw new FilesRefusedError('upload_invalid', `the file is not a ${type} image`);
    }
  }
}
