import { Body, HttpCode, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { AppSignedIn, CurrentAppSession } from '../../http/access.js';
import { CustomerController } from '../../http/route-groups.js';
import type { AppSession } from '../identity/index.js';
import { FilesService, MAX_IMAGE_BYTES } from './files.service.js';
import { imageTypes } from './schema.js';

class CustomerNewUploadDto extends createZodDto(
  z.object({
    contentType: z.enum(imageTypes),
    sizeBytes: z.int().min(1).max(MAX_IMAGE_BYTES),
  }),
) {}

class CustomerUploadDto extends createZodDto(
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

  @Post('report-photo')
  @AppSignedIn()
  @HttpCode(201)
  @ZodResponse({ status: 201, type: CustomerUploadDto })
  async create(@Body() body: CustomerNewUploadDto, @CurrentAppSession() session: AppSession) {
    const upload = await this.files.createUpload(
      { ...body, purpose: 'report_photo' },
      session.accountId,
    );
    return { ...upload, expiresAt: upload.expiresAt.toISOString() };
  }
}
