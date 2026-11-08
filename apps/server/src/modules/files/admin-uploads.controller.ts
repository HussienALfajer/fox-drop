import { Body, ForbiddenException, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminPermission, AdminSession } from '../identity/index.js';
import { FilesService, MAX_IMAGE_BYTES } from './files.service.js';
import { imageTypes, type UploadPurpose, uploadPurposes } from './schema.js';

class AdminNewUploadDto extends createZodDto(
  z.object({
    purpose: z.enum(uploadPurposes).describe('The record the file is for (architecture §5.8).'),
    contentType: z.enum(imageTypes),
    sizeBytes: z.int().min(1).max(MAX_IMAGE_BYTES),
  }),
) {}

class AdminUploadDto extends createZodDto(
  z.object({
    uploadId: z.uuid().describe('Links the file once uploaded (the record’s own route).'),
    key: z.string().describe('The object’s key in public-media, as the records keep it.'),
    url: z
      .string()
      .describe('A PUT of the exact bytes, with the same Content-Type, on the panel’s own origin.'),
    expiresAt: z.iso.datetime(),
  }),
) {}

// Who may upload what: logos and covers are the restaurant's profile
// (restaurants.manage), item photos its menu (restaurants.menus) (AP §6.2).
const purposePermission: Record<UploadPurpose, AdminPermission> = {
  restaurant_logo: 'restaurants.manage',
  restaurant_cover: 'restaurants.manage',
  item_photo: 'restaurants.menus',
};

// Architecture §5.8: a pre-signed upload to public-media. No Idempotency-Key:
// asking again makes another upload, and only the one linked is used.
@AdminController('uploads')
export class AdminUploadsController {
  constructor(private readonly files: FilesService) {}

  // 403 when the session may not set what the file is for.
  @Post()
  @RequireAnyPermission('restaurants.manage', 'restaurants.menus')
  @HttpCode(201)
  @ZodResponse({ status: 201, type: AdminUploadDto })
  async create(@Body() body: AdminNewUploadDto, @CurrentAdminSession() session: AdminSession) {
    if (!session.permissions.includes(purposePermission[body.purpose])) {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'forbidden' });
    }
    const upload = await this.files.createUpload(body, session.accountId);
    return { ...upload, expiresAt: upload.expiresAt.toISOString() };
  }
}
