import { Body, ForbiddenException, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { createZodDto, ZodResponse } from 'nestjs-zod';
import { z } from 'zod';
import { CurrentAdminSession, RequireAnyPermission } from '../../http/access.js';
import { AdminController } from '../../http/route-groups.js';
import type { AdminPermission, AdminSession } from '../identity/index.js';
import { FilesService, MAX_IMAGE_BYTES } from './files.service.js';
import { imageTypes } from './schema.js';

// What the panel uploads; a report's photo is the customer app's.
const adminPurposes = [
  'restaurant_logo',
  'restaurant_cover',
  'item_photo',
  'category_image',
] as const;
type AdminPurpose = (typeof adminPurposes)[number];

// The permissions that set a restaurant's logo and cover.
export const RESTAURANT_PROFILE = ['restaurants.manage', 'restaurants.create'] as const;

class AdminNewUploadDto extends createZodDto(
  z.object({
    purpose: z.enum(adminPurposes).describe('The record the file is for (architecture §5.8).'),
    contentType: z.enum(imageTypes),
    sizeBytes: z.int().min(1).max(MAX_IMAGE_BYTES),
  }),
) {}

class AdminUploadDto extends createZodDto(
  z.object({
    uploadId: z.uuid().describe('Links the file once uploaded (the record’s own route).'),
    url: z
      .string()
      .describe('A PUT of the exact bytes, with the same Content-Type, on the panel’s own origin.'),
    expiresAt: z.iso.datetime(),
  }),
) {}

// Who may upload what: logos and covers are the restaurant's profile, set by
// those who manage restaurants or add them (AP §9.6.3 step 1: DATA, OPS,
// OWN); item photos its menu (restaurants.menus); a category's image the
// categories (content.categories: OWN, DATA) (AP §6.2, §9.13).
const purposePermissions: Record<AdminPurpose, AdminPermission[]> = {
  restaurant_logo: [...RESTAURANT_PROFILE],
  restaurant_cover: [...RESTAURANT_PROFILE],
  item_photo: ['restaurants.menus'],
  category_image: ['content.categories'],
};

// Architecture §5.8: a pre-signed upload to public-media. No Idempotency-Key:
// asking again makes another upload, and only the one linked is used.
@AdminController('uploads')
export class AdminUploadsController {
  constructor(private readonly files: FilesService) {}

  // 403 when the session may not set what the file is for.
  @Post()
  @RequireAnyPermission(...RESTAURANT_PROFILE, 'restaurants.menus', 'content.categories')
  @HttpCode(201)
  @ZodResponse({ status: 201, type: AdminUploadDto })
  async create(@Body() body: AdminNewUploadDto, @CurrentAdminSession() session: AdminSession) {
    if (!purposePermissions[body.purpose].some((p) => session.permissions.includes(p))) {
      throw new ForbiddenException({ statusCode: HttpStatus.FORBIDDEN, error: 'forbidden' });
    }
    const upload = await this.files.createUpload(body, session.accountId);
    return { ...upload, expiresAt: upload.expiresAt.toISOString() };
  }
}
