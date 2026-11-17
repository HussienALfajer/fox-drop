import { Body, HttpCode, HttpException, HttpStatus, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { FilesRefusedError, FilesService, MAX_IMAGE_BYTES } from './files.service.js';
import { imageTypes } from './schema.js';

export class CustomerNewUploadDto extends createZodDto(
  z.object({
    contentType: z.enum(imageTypes),
    sizeBytes: z.int().min(1).max(MAX_IMAGE_BYTES),
  }),
) {}

export class CustomerUploadDto extends createZodDto(
  z.object({
    uploadId: z.uuid().describe('Sent with the report once the file is uploaded.'),
    url: z.string().describe('A PUT of the exact bytes, with the same Content-Type.'),
    expiresAt: z.iso.datetime(),
  }),
) {}

// CU §12.2, §9.5 (slice 2.24a): a report's photo, a pre-signed PUT into the
// private bucket (owner decision 2026-11-17). No Idempotency-Key: the answer
// is a URL to upload with, and only the photo a report links is used.
@CustomerController('uploads')
export class CustomerUploadsController {
  constructor(private readonly files: FilesService) {}

  // 429 too_many_uploads past REPORT_UPLOADS_PER_HOUR.
  @Post('report-photo')
  @AppSignedIn()
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerUploadDto })
  create(@Body() body: CustomerNewUploadDto, @CurrentAppSession() session: AppSession) {
    return reportPhoto(this.files, body, session.accountId);
  }
}

// A report's photo for an app user (CU §12.2, RA §15): the same purpose,
// bucket and hourly limit per account. 429 too_many_uploads.
export async function reportPhoto(
  files: FilesService,
  body: CustomerNewUploadDto,
  accountId: string,
): Promise<CustomerUploadDto> {
  const upload = await files
    .createUpload({ ...body, purpose: 'report_photo' }, accountId)
    .catch((error: unknown) => {
      if (error instanceof FilesRefusedError && error.refusal === 'too_many_uploads') {
        throw new HttpException(
          { statusCode: HttpStatus.TOO_MANY_REQUESTS, error: error.refusal },
          HttpStatus.TOO_MANY_REQUESTS,
        );
      }
      throw error;
    });
  return { ...upload, expiresAt: upload.expiresAt.toISOString() };
}
