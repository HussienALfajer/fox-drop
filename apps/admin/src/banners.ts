import type { components } from '@fox-drop/api-schema';
import { queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { zonedToUtc } from './emergency-stop.js';
import { utcToZoned } from './promo-codes.js';
import { fileRefusal, type ImageRefusal, uploadImage } from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

// AP §6, §9.11.2 «البانرات» (owner decision 2026-11-18): OWN and DATA
// publish (marketing.banners), OPS reads (marketing.read).
export function canSeeBanners(session: AdminSession | null | undefined): boolean {
  return (
    can(session, 'marketing.read') ||
    can(session, 'marketing.manage') ||
    can(session, 'marketing.banners')
  );
}

export type Banners = components['schemas']['AdminBannersDto_Output'];
export type Banner = Banners['banners'][number];
export type BannerTarget = Banner['target'];

// The banner's size (owner decision 2026-11-18) and the bounds the server
// checks (BANNER_TITLE_MAX, BANNER_RESTAURANTS_MAX).
export const BANNER_WIDTH = 1200;
export const BANNER_HEIGHT = 500;
export const BANNER_TITLE_MAX = 60;
export const BANNER_RESTAURANTS_MAX = 30;
// How far the crop zooms in on the image.
export const MAX_ZOOM = 3;

// The crop the admin picks: the zoom (1 shows as much of the image as the
// 1200×500 frame can hold) and where the frame sits, 0 to 1 across the room
// left on each axis (0.5 is the middle). Across, 0 is the image's start: its
// right edge, as the slider's 0 sits on the right in the panel's right to
// left (AP §4.7); down, 0 is the top.
export interface Crop {
  zoom: number;
  x: number;
  y: number;
}

export const CENTRED: Crop = { zoom: 1, x: 0.5, y: 0.5 };

// The part of the image the frame cuts, in the image's pixels.
export function cropBox(
  image: { width: number; height: number },
  crop: Crop,
): { sx: number; sy: number; sw: number; sh: number } {
  const ratio = BANNER_WIDTH / BANNER_HEIGHT;
  const zoom = Math.min(Math.max(crop.zoom, 1), MAX_ZOOM);
  const fullWidth = Math.min(image.width, image.height * ratio);
  const sw = fullWidth / zoom;
  const sh = sw / ratio;
  const along = (value: number) => Math.min(Math.max(value, 0), 1);
  return {
    sx: (image.width - sw) * (1 - along(crop.x)),
    sy: (image.height - sh) * along(crop.y),
    sw,
    sh,
  };
}

// A picked image the panel refuses before cutting it: the type and size of
// any upload, and an image smaller than the frame, which would blur
// (decided by us).
export type BannerImageRefusal = ImageRefusal | 'too_small';

export function bannerImageRefusal(
  file: { type: string; size: number },
  image: { width: number; height: number } | null,
): BannerImageRefusal | null {
  const refusal = fileRefusal(file);
  if (refusal !== null) return refusal;
  if (image === null) return 'not_image';
  if (image.width < BANNER_WIDTH || image.height < BANNER_HEIGHT) return 'too_small';
  return null;
}

// The form as typed: the period as the city's wall time.
export interface BannerForm {
  title: string;
  target: BannerTarget;
  restaurantIds: string[];
  categoryId: string;
  codeId: string;
  zoneIds: string[];
  startsAt: string;
  endsAt: string;
}

export function emptyForm(): BannerForm {
  return {
    title: '',
    target: 'restaurant',
    restaurantIds: [],
    categoryId: '',
    codeId: '',
    zoneIds: [],
    startsAt: '',
    endsAt: '',
  };
}

export function formOf(banner: Banner, timeZone: string): BannerForm {
  return {
    title: banner.title,
    target: banner.target,
    restaurantIds: banner.restaurantIds,
    categoryId: banner.categoryId ?? '',
    codeId: banner.codeId ?? '',
    zoneIds: banner.zoneIds,
    startsAt: utcToZoned(banner.startsAt, timeZone),
    endsAt: utcToZoned(banner.endsAt, timeZone),
  };
}

export type BannerProblem = 'title' | 'target' | 'period' | 'ended';

export interface BannerFields {
  title: string;
  target: BannerTarget;
  restaurantIds: string[];
  categoryId: string | null;
  codeId: string | null;
  zoneIds: string[];
  startsAt: string;
  endsAt: string;
}

// The body's fields, or the form's first problem (the server checks the
// same): a title of 1 to 60 characters, the target's choice (one
// restaurant, 1 to 30 restaurants, a category or a code), a start before the
// end and an end after now.
export function bannerFieldsOf(
  form: BannerForm,
  timeZone: string,
  now: number,
): { fields: BannerFields } | { problem: BannerProblem } {
  const title = form.title.trim();
  if (title.length === 0 || [...title].length > BANNER_TITLE_MAX) return { problem: 'title' };
  const target = { restaurantIds: [] as string[], categoryId: null, codeId: null };
  let chosen: Pick<BannerFields, 'restaurantIds' | 'categoryId' | 'codeId'>;
  switch (form.target) {
    case 'restaurant':
      if (form.restaurantIds.length !== 1) return { problem: 'target' };
      chosen = { ...target, restaurantIds: form.restaurantIds };
      break;
    case 'restaurants':
      if (form.restaurantIds.length === 0 || form.restaurantIds.length > BANNER_RESTAURANTS_MAX) {
        return { problem: 'target' };
      }
      chosen = { ...target, restaurantIds: form.restaurantIds };
      break;
    case 'category':
      if (form.categoryId === '') return { problem: 'target' };
      chosen = { ...target, categoryId: form.categoryId };
      break;
    case 'code':
      if (form.codeId === '') return { problem: 'target' };
      chosen = { ...target, codeId: form.codeId };
      break;
  }
  const startsAt = zonedToUtc(form.startsAt, timeZone);
  const endsAt = zonedToUtc(form.endsAt, timeZone);
  if (startsAt === null || endsAt === null || Date.parse(startsAt) >= Date.parse(endsAt)) {
    return { problem: 'period' };
  }
  if (Date.parse(endsAt) <= now) return { problem: 'ended' };
  return {
    fields: { title, target: form.target, ...chosen, zoneIds: form.zoneIds, startsAt, endsAt },
  };
}

// Whether a banner runs now, has not started or has ended.
export function bannerState(banner: Banner, now: number): 'running' | 'scheduled' | 'ended' {
  if (Date.parse(banner.endsAt) <= now) return 'ended';
  if (Date.parse(banner.startsAt) > now) return 'scheduled';
  return 'running';
}

// The refusals the page explains; anything else is a thrown error.
export type BannerRefusal =
  | 'invalid_banner'
  | 'banners_changed'
  | 'unknown_banner'
  | 'upload_wrong_size'
  | 'upload_invalid'
  | 'upload_failed';
const refusals: readonly string[] = [
  'invalid_banner',
  'banners_changed',
  'unknown_banner',
  'upload_wrong_size',
  'upload_invalid',
] satisfies BannerRefusal[];
// A file never uploaded, too late, or taken by another record: upload again.
const uploadAgain = ['upload_missing', 'upload_expired', 'upload_used', 'upload_not_found'];

export type BannerResult = { status: 'saved' } | { status: 'refused'; refusal: BannerRefusal };

function refused(error: unknown, status: number): BannerResult {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  if (typeof refusal === 'string' && [400, 404, 409].includes(status)) {
    if (refusals.includes(refusal)) {
      return { status: 'refused', refusal: refusal as BannerRefusal };
    }
    if (uploadAgain.includes(refusal)) return { status: 'refused', refusal: 'upload_failed' };
  }
  throw new Error(`banner edit failed with ${status}`);
}

const bannersKey = (cityId: string) => ['banners', cityId] as const;

export const bannersQuery = (cityId: string) =>
  queryOptions({
    queryKey: bannersKey(cityId),
    queryFn: async (): Promise<Banners> => {
      const { data } = await api.GET('/v1/admin/banners', { params: { query: { cityId } } });
      if (!data) throw new Error('The banners read failed.');
      return data;
    },
  });

// Every command answers the city's banners, which replace the read.
function useBannerEdit<Input>(
  cityId: string,
  run: (input: Input) => Promise<{ data: Banners | undefined; error: unknown; status: number }>,
) {
  const client = useQueryClient();
  return useMutation({
    mutationFn: async (input: Input): Promise<BannerResult> => {
      const { data, error, status } = await run(input);
      if (!data) return refused(error, status);
      client.setQueryData(bannersKey(cityId), data);
      return { status: 'saved' };
    },
  });
}

// One upload and one Idempotency-Key per body until an answer arrives
// (architecture §5.3), so a retry after a lost answer neither uploads again
// nor publishes the banner twice.
export function usePublishBanner(cityId: string) {
  const kept = useRef(new Map<string, { uploadId: string; key: string }>());
  return useBannerEdit(
    cityId,
    async (input: { fields: BannerFields; image: Blob; imageId: string }) => {
      // The fields with the picked image and its crop (the page's `imageId`),
      // so a retry of the same cut reuses its upload and a new cut uploads.
      const id = JSON.stringify([input.fields, input.imageId]);
      let entry = kept.current.get(id);
      if (entry === undefined) {
        const uploadId = await uploadImage('banner_image', input.image);
        if (uploadId === null) {
          return { data: undefined, error: { error: 'upload_missing' }, status: 409 };
        }
        entry = { uploadId, key: crypto.randomUUID() };
        kept.current.set(id, entry);
      }
      const { data, error, response } = await api.POST('/v1/admin/banners', {
        body: { cityId, ...input.fields, uploadId: entry.uploadId },
        params: { header: { 'Idempotency-Key': entry.key } },
      });
      if (data || response.status < 500) kept.current.delete(id);
      return { data, error, status: response.status };
    },
  );
}

// Every field, and a new image when one was cut (null keeps it).
export function useUpdateBanner(cityId: string) {
  return useBannerEdit(
    cityId,
    async (input: { bannerId: string; fields: BannerFields; image: Blob | null }) => {
      let uploadId: string | null = null;
      if (input.image !== null) {
        uploadId = await uploadImage('banner_image', input.image);
        if (uploadId === null) {
          return { data: undefined, error: { error: 'upload_missing' }, status: 409 };
        }
      }
      const { data, error, response } = await api.PUT('/v1/admin/banners/{bannerId}', {
        params: { path: { bannerId: input.bannerId } },
        body: { cityId, ...input.fields, uploadId },
      });
      return { data, error, status: response.status };
    },
  );
}

export function useReorderBanners(cityId: string) {
  return useBannerEdit(cityId, async (ids: string[]) => {
    const { data, error, response } = await api.POST('/v1/admin/banners/order', {
      body: { cityId, ids },
    });
    return { data, error, status: response.status };
  });
}

export function useRemoveBanner(cityId: string) {
  return useBannerEdit(cityId, async (bannerId: string) => {
    const { data, error, response } = await api.POST('/v1/admin/banners/{bannerId}/remove', {
      params: { path: { bannerId } },
      body: { cityId },
    });
    return { data, error, status: response.status };
  });
}
