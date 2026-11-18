import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import type { components } from '@fox-drop/api-schema';
import { api } from './api.js';
import { type AdminSession, can } from './session.js';

// AP §6.2: who reads the restaurants and who sets which image.
export const RESTAURANTS_READ = 'restaurants.read';
export const RESTAURANTS_MANAGE = 'restaurants.manage';
export const RESTAURANTS_CREATE = 'restaurants.create';
export const RESTAURANTS_MENUS = 'restaurants.menus';

// «الصور» lists restaurants for those who read them or edit menus.
export function canSeeImages(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_READ) || can(session, RESTAURANTS_MENUS);
}

// The logo and cover: those who manage restaurants or add them (AP §9.6.3
// step 1: DATA, OPS, OWN).
export function canSetProfileImages(session: AdminSession | null | undefined): boolean {
  return can(session, RESTAURANTS_MANAGE) || can(session, RESTAURANTS_CREATE);
}

export type RestaurantImages = components['schemas']['AdminRestaurantImagesDto_Output'];

// The server's limits (architecture §5.8): checked here first so a wrong
// file never starts an upload.
export const IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/webp'] as const;
export type ImageType = (typeof IMAGE_TYPES)[number];
export const MAX_IMAGE_BYTES = 8 * 1024 * 1024;

export type ImageTarget =
  | { kind: 'logo'; restaurantId: string }
  | { kind: 'cover'; restaurantId: string }
  | { kind: 'item'; restaurantId: string; itemId: string }
  // AP §9.13 «التصنيفات» (slice 2.27a): a category's icon or image.
  | { kind: 'category'; categoryId: string };

// What the page explains: a file the panel refuses before sending, the
// server's refusals of a stored file, and an upload the storage refused.
export type ImageRefusal = 'type' | 'size' | 'not_image' | 'upload_failed';

export type ImageResult =
  { status: 'set'; key: string } | { status: 'refused'; refusal: ImageRefusal };

export function fileRefusal(file: { type: string; size: number }): ImageRefusal | null {
  if (!(IMAGE_TYPES as readonly string[]).includes(file.type)) return 'type';
  if (file.size === 0 || file.size > MAX_IMAGE_BYTES) return 'size';
  return null;
}

const purposes = {
  logo: 'restaurant_logo',
  cover: 'restaurant_cover',
  item: 'item_photo',
  category: 'category_image',
} as const satisfies Record<ImageTarget['kind'], string>;

// The server's refusals of a link, as the page explains them. A file never
// uploaded or too late is retried as a failed upload.
export function linkRefusal(error: unknown): ImageRefusal {
  return error === 'upload_invalid' ? 'not_image' : 'upload_failed';
}

export const restaurantsQuery = (cityId: string) =>
  queryOptions({
    queryKey: ['restaurants', cityId],
    queryFn: async () => {
      const { data } = await api.GET('/v1/admin/restaurants', {
        params: { query: { cityId } },
      });
      if (!data) throw new Error('The restaurants read failed.');
      return data.restaurants;
    },
  });

export const restaurantImagesQuery = (restaurantId: string) =>
  queryOptions({
    queryKey: ['restaurant-images', restaurantId],
    queryFn: async (): Promise<RestaurantImages> => {
      const { data } = await api.GET('/v1/admin/restaurants/{restaurantId}/images', {
        params: { path: { restaurantId } },
      });
      if (!data) throw new Error('The images read failed.');
      return data;
    },
  });

async function link(target: ImageTarget, uploadId: string) {
  const body = { uploadId };
  if (target.kind === 'category') {
    const linked = await api.PUT('/v1/admin/content/categories/{categoryId}/image', {
      params: { path: { categoryId: target.categoryId } },
      body,
    });
    return {
      data: linked.data ? { key: linked.data.imageKey ?? '' } : undefined,
      error: linked.error,
      response: linked.response,
    };
  }
  if (target.kind === 'item') {
    return api.PUT('/v1/admin/restaurants/{restaurantId}/items/{itemId}/photo', {
      params: { path: { restaurantId: target.restaurantId, itemId: target.itemId } },
      body,
    });
  }
  const path = { restaurantId: target.restaurantId };
  return target.kind === 'logo'
    ? api.PUT('/v1/admin/restaurants/{restaurantId}/logo', { params: { path }, body })
    : api.PUT('/v1/admin/restaurants/{restaurantId}/cover', { params: { path }, body });
}

export type UploadPurpose = components['schemas']['AdminNewUploadDto']['purpose'];

// Architecture §5.8: ask for a signed upload and PUT the file straight to the
// storage on the panel's own origin (/public-media, not the API, so not
// through the API client). The upload's id, which the record's route links
// (and the server checks), or null when the storage refused the file.
export async function uploadImage(purpose: UploadPurpose, file: Blob): Promise<string | null> {
  const asked = await api.POST('/v1/admin/uploads', {
    body: { purpose, contentType: file.type as ImageType, sizeBytes: file.size },
  });
  if (!asked.data) throw new Error('The upload was not signed.');
  const put = await fetch(asked.data.url, {
    method: 'PUT',
    body: file,
    headers: { 'Content-Type': file.type },
  });
  return put.ok ? asked.data.uploadId : null;
}

// Uploads the file, then links it with the record's route.
export function useSetImage() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async ({
      target,
      file,
    }: {
      target: ImageTarget;
      file: File;
    }): Promise<ImageResult> => {
      const refusal = fileRefusal(file);
      if (refusal) return { status: 'refused', refusal };
      const uploadId = await uploadImage(purposes[target.kind], file);
      if (uploadId === null) return { status: 'refused', refusal: 'upload_failed' };
      const linked = await link(target, uploadId);
      if (linked.data) return { status: 'set', key: linked.data.key };
      const error = (linked.error as { error?: unknown } | undefined)?.error;
      if (linked.response.status === 400 || linked.response.status === 409) {
        return { status: 'refused', refusal: linkRefusal(error) };
      }
      throw new Error('The image was not linked.');
    },
    onSuccess: async (_result, { target }) => {
      if (target.kind === 'category') {
        await queryClient.invalidateQueries({ queryKey: ['content', 'categories'] });
        return;
      }
      await queryClient.invalidateQueries({ queryKey: ['restaurant-images', target.restaurantId] });
      // «إضافة مطعم» shows the logo and cover of its draft (slice 2.30a).
      await queryClient.invalidateQueries({ queryKey: ['restaurant-draft', target.restaurantId] });
      // Step 7's photos and step 8's image rule (slice 2.30b).
      await queryClient.invalidateQueries({ queryKey: ['restaurant-menu', target.restaurantId] });
      await queryClient.invalidateQueries({
        queryKey: ['restaurant-checklist', target.restaurantId],
      });
    },
  });
}
