import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type ChangeEvent, type FormEvent, useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  BANNER_HEIGHT,
  BANNER_RESTAURANTS_MAX,
  BANNER_TITLE_MAX,
  BANNER_WIDTH,
  type Banner,
  type BannerFields,
  type BannerForm,
  type BannerImageRefusal,
  type BannerProblem,
  type BannerRefusal,
  type BannerResult,
  type Banners,
  type BannerTarget,
  bannerFieldsOf,
  bannerImageRefusal,
  bannersQuery,
  bannerState,
  CENTRED,
  type Crop,
  cropBox,
  emptyForm,
  formOf,
  MAX_ZOOM,
  usePublishBanner,
  useRemoveBanner,
  useReorderBanners,
  useUpdateBanner,
} from './banners.js';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { movedKey, pickedRestaurants } from './home-sections.js';
import { mediaUrl } from './media.js';
import { serverNow } from './clock.js';

const route = getRouteApi('/signed-in/banners');

const targetKeys = {
  restaurant: 'banners.target.restaurant',
  category: 'banners.target.category',
  restaurants: 'banners.target.restaurants',
  code: 'banners.target.code',
} as const satisfies Record<BannerTarget, string>;

const stateKeys = {
  running: 'banners.state.running',
  scheduled: 'banners.state.scheduled',
  ended: 'banners.state.ended',
} as const;

const problemKeys = {
  title: 'banners.problem.title',
  target: 'banners.problem.target',
  period: 'banners.problem.period',
  ended: 'banners.problem.ended',
} as const satisfies Record<BannerProblem, string>;

const imageRefusalKeys = {
  type: 'images.refused.type',
  size: 'images.refused.size',
  not_image: 'images.refused.notImage',
  upload_failed: 'images.refused.uploadFailed',
  too_small: 'banners.image.tooSmall',
} as const satisfies Record<BannerImageRefusal, string>;

const refusalKeys = {
  invalid_banner: 'banners.refused.invalid',
  banners_changed: 'banners.refused.changed',
  unknown_banner: 'banners.refused.unknown',
  upload_wrong_size: 'banners.refused.wrongSize',
  upload_invalid: 'images.refused.notImage',
  upload_failed: 'images.refused.uploadFailed',
} as const satisfies Record<BannerRefusal, string>;

// AP §9.11.2 «البانرات» (slice 2.27c): the city's banners in the strip's
// order, and the form: the image cut to 1200×500 with its crop preview, the
// title, the target, the period and the zones, then «معاينة» before «نشر».
// Unstyled until the design; up and down stand for a drag until then.
export function BannersPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const banners = useQuery({ ...bannersQuery(city?.id ?? ''), enabled: city !== undefined });
  return (
    <main>
      <h1>{t('banners.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('banners.intro', { width: BANNER_WIDTH, height: BANNER_HEIGHT })}</p>
      {banners.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !banners.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <BannersView banners={banners.data} city={city} />
      )}
    </main>
  );
}

function BannersView({ banners, city }: { banners: Banners; city: City }) {
  const { t } = useTranslation();
  const reorder = useReorderBanners(city.id);
  const ids = banners.banners.map((banner) => banner.id);
  const [adding, setAdding] = useState(0);
  return (
    <>
      {banners.banners.length === 0 ? (
        <p>{t('banners.none')}</p>
      ) : (
        <ol>
          {banners.banners.map((banner, index) => (
            <li key={banner.id}>
              <BannerItem banner={banner} banners={banners} city={city} />
              {banners.canManage && (
                <>
                  <button
                    type="button"
                    disabled={reorder.isPending || index === 0}
                    onClick={() => reorder.mutate(movedKey(ids, banner.id, -1))}
                  >
                    {t('banners.moveUp')}
                  </button>
                  <button
                    type="button"
                    disabled={reorder.isPending || index === ids.length - 1}
                    onClick={() => reorder.mutate(movedKey(ids, banner.id, 1))}
                  >
                    {t('banners.moveDown')}
                  </button>
                </>
              )}
            </li>
          ))}
        </ol>
      )}
      <Outcome result={reorder.data} failed={reorder.isError} />
      {banners.canManage && (
        <section aria-label={t('banners.add')}>
          <h2>{t('banners.add')}</h2>
          <BannerEditor
            key={adding}
            banners={banners}
            city={city}
            banner={null}
            onSaved={() => setAdding((value) => value + 1)}
          />
        </section>
      )}
    </>
  );
}

function BannerItem({ banner, banners, city }: { banner: Banner; banners: Banners; city: City }) {
  const { t } = useTranslation();
  const describe = useDescribe(banners);
  const remove = useRemoveBanner(city.id);
  const [editing, setEditing] = useState(false);
  const [confirming, setConfirming] = useState(false);
  const state = bannerState(banner, serverNow());
  return (
    <section aria-label={banner.title}>
      <h2>{banner.title}</h2>
      <img src={mediaUrl(banner.imageKey, 640)} alt={banner.title} width={640} />
      <p>{t(stateKeys[state])}</p>
      <BannerFacts
        target={describe(banner)}
        zoneIds={banner.zoneIds}
        startsAt={banner.startsAt}
        endsAt={banner.endsAt}
        banners={banners}
        city={city}
      />
      {banners.canManage && (
        <>
          <button type="button" onClick={() => setEditing((value) => !value)}>
            {editing ? t('banners.closeEdit') : t('banners.edit')}
          </button>
          {confirming ? (
            <button
              type="button"
              disabled={remove.isPending}
              onClick={() => remove.mutate(banner.id)}
            >
              {t('banners.confirmRemove')}
            </button>
          ) : (
            <button type="button" onClick={() => setConfirming(true)}>
              {t('banners.remove')}
            </button>
          )}
          <Outcome result={remove.data} failed={remove.isError} />
          {editing && (
            <BannerEditor
              banners={banners}
              city={city}
              banner={banner}
              onSaved={() => setEditing(false)}
            />
          )}
        </>
      )}
    </section>
  );
}

// The banner's target in words, as the preview and the list say it.
function useDescribe(banners: Banners) {
  const { t } = useTranslation();
  const restaurants = new Map(banners.restaurants.map((each) => [each.id, each.name]));
  const categories = new Map(banners.categories.map((each) => [each.id, each.name]));
  const codes = new Map(banners.codes.map((each) => [each.id, each.code]));
  return (
    banner: Pick<BannerFields, 'target' | 'restaurantIds' | 'categoryId' | 'codeId'> & {
      code?: string | null;
    },
  ): string => {
    const names = banner.restaurantIds.map((id) => restaurants.get(id) ?? id);
    switch (banner.target) {
      case 'restaurant':
        return t('banners.opens.restaurant', { name: names[0] ?? '' });
      case 'restaurants':
        return t('banners.opens.restaurants', { names: names.join(t('banners.separator')) });
      case 'category':
        return t('banners.opens.category', {
          name: categories.get(banner.categoryId ?? '') ?? '',
        });
      case 'code':
        return t('banners.opens.code', {
          code: banner.code ?? codes.get(banner.codeId ?? '') ?? '',
        });
    }
  };
}

function BannerFacts({
  target,
  zoneIds,
  startsAt,
  endsAt,
  banners,
  city,
}: {
  target: string;
  zoneIds: string[];
  startsAt: string;
  endsAt: string;
  banners: Banners;
  city: City;
}) {
  const { t } = useTranslation();
  const zones = new Map(banners.zones.map((zone) => [zone.id, zone.name]));
  const at = (value: string) =>
    new Intl.DateTimeFormat('ar-u-nu-latn', {
      timeZone: city.timeZone,
      dateStyle: 'medium',
      timeStyle: 'short',
    }).format(new Date(value));
  return (
    <>
      <p>{target}</p>
      <p>
        {zoneIds.length === 0
          ? t('banners.allZones')
          : t('banners.zonesList', {
              names: zoneIds.map((id) => zones.get(id) ?? id).join(t('banners.separator')),
            })}
      </p>
      <p>{t('banners.period', { from: at(startsAt), to: at(endsAt) })}</p>
    </>
  );
}

// The form for a new banner (`banner` null) or an edit. The image is cut in
// the browser to exactly 1200×500 (owner decision 2026-11-18), so the
// server stores the frame every phone shows. «نشر» waits for «معاينة» of
// the form as it is.
function BannerEditor({
  banners,
  city,
  banner,
  onSaved,
}: {
  banners: Banners;
  city: City;
  banner: Banner | null;
  onSaved: () => void;
}) {
  const { t } = useTranslation();
  const publish = usePublishBanner(city.id);
  const update = useUpdateBanner(city.id);
  const describe = useDescribe(banners);
  const [form, setForm] = useState<BannerForm>(() =>
    banner === null ? emptyForm() : formOf(banner, city.timeZone),
  );
  const [image, setImage] = useState<ImageBitmap | null>(null);
  const [crop, setCrop] = useState<Crop>(CENTRED);
  const [imageRefusal, setImageRefusal] = useState<BannerImageRefusal | null>(null);
  const [previewed, setPreviewed] = useState<string | null>(null);
  const frame = useRef<HTMLCanvasElement>(null);
  const checked = bannerFieldsOf(form, city.timeZone, serverNow());
  const needsImage = banner === null && image === null;
  const current = JSON.stringify([form, crop, image?.width, image?.height]);
  const pending = publish.isPending || update.isPending;

  useEffect(() => {
    const canvas = frame.current;
    if (canvas === null || image === null) return;
    const box = cropBox(image, crop);
    const context = canvas.getContext('2d');
    if (context === null) return;
    // A transparent part of a PNG or WebP would turn black in the JPEG:
    // white behind it (decided by us, until the design).
    context.fillStyle = 'white';
    context.fillRect(0, 0, BANNER_WIDTH, BANNER_HEIGHT);
    context.drawImage(image, box.sx, box.sy, box.sw, box.sh, 0, 0, BANNER_WIDTH, BANNER_HEIGHT);
  }, [image, crop]);

  const pick = async (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file === undefined) return;
    const bitmap = await createImageBitmap(file).catch(() => null);
    const refusal = bannerImageRefusal(file, bitmap);
    setImageRefusal(refusal);
    setImage(refusal === null ? bitmap : null);
    setCrop(CENTRED);
  };

  const cut = (): Blob | null => {
    const canvas = frame.current;
    if (canvas === null || image === null) return null;
    return jpegOf(canvas.toDataURL('image/jpeg', JPEG_QUALITY));
  };

  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (!('fields' in checked) || needsImage || previewed !== current) return;
    const blob = cut();
    const done = (result: BannerResult) => {
      if (result.status === 'saved') onSaved();
    };
    if (banner === null) {
      if (blob === null) return;
      publish.mutate(
        { fields: checked.fields, image: blob, imageId: current },
        { onSuccess: done },
      );
    } else {
      update.mutate(
        { bannerId: banner.id, fields: checked.fields, image: blob },
        { onSuccess: done },
      );
    }
  };

  const set = (change: Partial<BannerForm>) => setForm({ ...form, ...change });
  return (
    <form onSubmit={submit}>
      <fieldset>
        <legend>{t('banners.image.label', { width: BANNER_WIDTH, height: BANNER_HEIGHT })}</legend>
        {banner !== null && image === null && (
          <img src={mediaUrl(banner.imageKey, 640)} alt={banner.title} width={640} />
        )}
        <label>
          {banner === null ? t('banners.image.pick') : t('banners.image.replace')}
          <input type="file" accept="image/jpeg,image/png,image/webp" onChange={pick} />
        </label>
        {imageRefusal !== null && (
          <p role="alert">
            {t(imageRefusalKeys[imageRefusal], { width: BANNER_WIDTH, height: BANNER_HEIGHT })}
          </p>
        )}
        {image !== null && (
          <>
            <p>{t('banners.image.crop')}</p>
            <canvas
              ref={frame}
              width={BANNER_WIDTH}
              height={BANNER_HEIGHT}
              aria-label={t('banners.image.cropPreview')}
            />
            <label>
              {t('banners.image.zoom')}
              <input
                type="range"
                min={1}
                max={MAX_ZOOM}
                step={0.05}
                value={crop.zoom}
                onChange={(event) => setCrop({ ...crop, zoom: Number(event.target.value) })}
              />
            </label>
            <label>
              {t('banners.image.across')}
              <input
                type="range"
                min={0}
                max={1}
                step={0.01}
                value={crop.x}
                onChange={(event) => setCrop({ ...crop, x: Number(event.target.value) })}
              />
            </label>
            <label>
              {t('banners.image.down')}
              <input
                type="range"
                min={0}
                max={1}
                step={0.01}
                value={crop.y}
                onChange={(event) => setCrop({ ...crop, y: Number(event.target.value) })}
              />
            </label>
          </>
        )}
      </fieldset>
      <label>
        {t('banners.titleField')}
        <input
          value={form.title}
          maxLength={BANNER_TITLE_MAX}
          required
          onChange={(event) => set({ title: event.target.value })}
        />
      </label>
      <fieldset>
        <legend>{t('banners.targetField')}</legend>
        {(Object.keys(targetKeys) as BannerTarget[]).map((target) => (
          <label key={target}>
            <input
              type="radio"
              name="target"
              checked={form.target === target}
              onChange={() => set({ target, restaurantIds: [] })}
            />
            {t(targetKeys[target])}
          </label>
        ))}
      </fieldset>
      {form.target === 'restaurant' && (
        <label>
          {t('banners.restaurant')}
          <select
            value={form.restaurantIds[0] ?? ''}
            onChange={(event) =>
              set({ restaurantIds: event.target.value === '' ? [] : [event.target.value] })
            }
          >
            <option value="">{t('banners.choose')}</option>
            {banners.restaurants.map((each) => (
              <option key={each.id} value={each.id}>
                {each.name}
              </option>
            ))}
          </select>
        </label>
      )}
      {form.target === 'restaurants' && (
        <fieldset>
          <legend>{t('banners.restaurants', { max: BANNER_RESTAURANTS_MAX })}</legend>
          {banners.restaurants.map((each) => (
            <label key={each.id}>
              <input
                type="checkbox"
                checked={form.restaurantIds.includes(each.id)}
                onChange={(event) =>
                  set({
                    restaurantIds: pickedRestaurants(
                      form.restaurantIds,
                      each.id,
                      event.target.checked,
                    ),
                  })
                }
              />
              {each.name}
            </label>
          ))}
        </fieldset>
      )}
      {form.target === 'category' && (
        <label>
          {t('banners.category')}
          <select
            value={form.categoryId}
            onChange={(event) => set({ categoryId: event.target.value })}
          >
            <option value="">{t('banners.choose')}</option>
            {banners.categories.map((each) => (
              <option key={each.id} value={each.id}>
                {each.name}
              </option>
            ))}
          </select>
        </label>
      )}
      {form.target === 'code' && (
        <label>
          {t('banners.code')}
          <select value={form.codeId} onChange={(event) => set({ codeId: event.target.value })}>
            <option value="">{t('banners.choose')}</option>
            {banners.codes.map((each) => (
              <option key={each.id} value={each.id}>
                {each.code}
              </option>
            ))}
          </select>
        </label>
      )}
      <label>
        {t('banners.startsAt')}
        <input
          type="datetime-local"
          value={form.startsAt}
          onChange={(event) => set({ startsAt: event.target.value })}
        />
      </label>
      <label>
        {t('banners.endsAt')}
        <input
          type="datetime-local"
          value={form.endsAt}
          onChange={(event) => set({ endsAt: event.target.value })}
        />
      </label>
      <fieldset>
        <legend>{t('banners.zones')}</legend>
        {banners.zones.map((zone) => (
          <label key={zone.id}>
            <input
              type="checkbox"
              checked={form.zoneIds.includes(zone.id)}
              onChange={(event) =>
                set({
                  zoneIds: event.target.checked
                    ? [...form.zoneIds, zone.id]
                    : form.zoneIds.filter((id) => id !== zone.id),
                })
              }
            />
            {zone.name}
          </label>
        ))}
      </fieldset>
      {'problem' in checked && <p>{t(problemKeys[checked.problem], { max: BANNER_TITLE_MAX })}</p>}
      {needsImage && <p>{t('banners.problem.image')}</p>}
      <button
        type="button"
        disabled={!('fields' in checked) || needsImage}
        onClick={() => setPreviewed(current)}
      >
        {t('banners.preview')}
      </button>
      {previewed === current && 'fields' in checked && (
        <section aria-label={t('banners.preview')}>
          <h3>{t('banners.previewTitle')}</h3>
          <PreviewImage image={image} crop={crop} banner={banner} />
          <p>{checked.fields.title}</p>
          <BannerFacts
            target={describe(checked.fields)}
            zoneIds={checked.fields.zoneIds}
            startsAt={checked.fields.startsAt}
            endsAt={checked.fields.endsAt}
            banners={banners}
            city={city}
          />
          <button type="submit" disabled={pending}>
            {banner === null ? t('banners.publish') : t('banners.save')}
          </button>
        </section>
      )}
      <Outcome result={publish.data ?? update.data} failed={publish.isError || update.isError} />
    </form>
  );
}

// The cut's JPEG quality (decided by us).
const JPEG_QUALITY = 0.9;

// The canvas's JPEG as a Blob, from toDataURL, which encodes at once:
// toBlob encodes in the browser's idle time, which a busy page may not give
// for seconds. The data URL is only decoded here, never shown (the
// Content-Security-Policy refuses data: images).
function jpegOf(dataUrl: string): Blob {
  const bytes = atob(dataUrl.slice(dataUrl.indexOf(',') + 1));
  const buffer = new Uint8Array(bytes.length);
  for (let i = 0; i < bytes.length; i += 1) buffer[i] = bytes.charCodeAt(i);
  return new Blob([buffer], { type: 'image/jpeg' });
}

// The banner at a phone's width (360 points), as the home shows it.
const PHONE_WIDTH = 360;
const PHONE_HEIGHT = Math.round((PHONE_WIDTH * BANNER_HEIGHT) / BANNER_WIDTH);

function PreviewImage({
  image,
  crop,
  banner,
}: {
  image: ImageBitmap | null;
  crop: Crop;
  banner: Banner | null;
}) {
  const { t } = useTranslation();
  const small = useRef<HTMLCanvasElement>(null);
  useEffect(() => {
    if (image === null || small.current === null) return;
    const box = cropBox(image, crop);
    const context = small.current.getContext('2d');
    if (context === null) return;
    // White behind a transparent part, as in the uploaded JPEG.
    context.fillStyle = 'white';
    context.fillRect(0, 0, PHONE_WIDTH, PHONE_HEIGHT);
    context.drawImage(image, box.sx, box.sy, box.sw, box.sh, 0, 0, PHONE_WIDTH, PHONE_HEIGHT);
  }, [image, crop]);
  if (image === null && banner !== null) {
    return <img src={mediaUrl(banner.imageKey, 320)} alt={banner.title} width={PHONE_WIDTH} />;
  }
  return (
    <canvas
      ref={small}
      width={PHONE_WIDTH}
      height={PHONE_HEIGHT}
      aria-label={t('banners.previewTitle')}
    />
  );
}

function Outcome({ result, failed }: { result: BannerResult | undefined; failed: boolean }) {
  const { t } = useTranslation();
  if (failed) return <p role="alert">{t('common.failed')}</p>;
  if (result?.status === 'refused') {
    return (
      <p role="alert">
        {t(refusalKeys[result.refusal], { width: BANNER_WIDTH, height: BANNER_HEIGHT })}
      </p>
    );
  }
  if (result?.status === 'saved') return <p role="status">{t('banners.saved')}</p>;
  return null;
}
