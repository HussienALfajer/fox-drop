import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import type { ChangeEvent } from 'react';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { mediaUrl, type MediaWidth } from './media.js';
import {
  IMAGE_TYPES,
  type ImageRefusal,
  type ImageTarget,
  canSetProfileImages,
  RESTAURANTS_MENUS,
  restaurantImagesQuery,
  restaurantsQuery,
  useSetImage,
} from './restaurant-images.js';
import { type AdminSession, can } from './session.js';

const route = getRouteApi('/signed-in/images');
const signedIn = getRouteApi('/signed-in');

const refusalKeys = {
  type: 'images.refused.type',
  size: 'images.refused.size',
  not_image: 'images.refused.notImage',
  upload_failed: 'images.refused.uploadFailed',
} as const satisfies Record<ImageRefusal, string>;

// «الصور» (slice 2.5, owner decision 2026-11-09): pick a restaurant, then set
// its logo and cover (AP §9.6.3) and each item's photo (AP §9.6.6). A new
// image is published at once. The onboarding wizard (2.30) and the menu
// editor (2.31) take this over. Unstyled until the design.
export function RestaurantImagesPage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const search = route.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const restaurants = useQuery({
    ...restaurantsQuery(city?.id ?? ''),
    enabled: city !== undefined,
  });
  const choose = (event: ChangeEvent<HTMLSelectElement>) =>
    void navigate({
      to: '/images',
      search: {
        ...(search.city ? { city: search.city } : {}),
        ...(event.target.value ? { restaurant: event.target.value } : {}),
      },
    });
  return (
    <main>
      <h1>{t('images.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('images.explain')}</p>
      {restaurants.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !restaurants.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <label>
          {t('images.restaurant')}
          <select value={search.restaurant ?? ''} onChange={choose}>
            <option value="">{t('images.choose')}</option>
            {restaurants.data.map((restaurant) => (
              <option key={restaurant.id} value={restaurant.id}>
                {restaurant.nameAr}
              </option>
            ))}
          </select>
        </label>
      )}
      {search.restaurant && (
        <RestaurantImages
          key={search.restaurant}
          restaurantId={search.restaurant}
          session={session}
        />
      )}
    </main>
  );
}

function RestaurantImages({
  restaurantId,
  session,
}: {
  restaurantId: string;
  session: AdminSession;
}) {
  const { t } = useTranslation();
  const images = useQuery(restaurantImagesQuery(restaurantId));
  if (images.isPending) return <p role="status">{t('status.loading')}</p>;
  if (images.isError) return <p role="alert">{t('common.failed')}</p>;
  const profile = canSetProfileImages(session);
  const menu = can(session, RESTAURANTS_MENUS);
  return (
    <>
      <ImageField
        label={t('images.logo')}
        imageKey={images.data.logoKey}
        width={160}
        target={{ kind: 'logo', restaurantId }}
        editable={profile}
      />
      <ImageField
        label={t('images.cover')}
        imageKey={images.data.coverKey}
        width={640}
        target={{ kind: 'cover', restaurantId }}
        editable={profile}
      />
      {images.data.categories.map((category) => (
        <section key={category.id} aria-label={category.name}>
          <h2>{category.name}</h2>
          {category.items.map((item) => (
            <ImageField
              key={item.id}
              label={item.name}
              imageKey={item.photoKey}
              width={160}
              target={{ kind: 'item', restaurantId, itemId: item.id }}
              editable={menu}
            />
          ))}
        </section>
      ))}
    </>
  );
}

function ImageField(props: {
  label: string;
  imageKey: string | null;
  width: MediaWidth;
  target: ImageTarget;
  editable: boolean;
}) {
  const { t } = useTranslation();
  const setImage = useSetImage();
  const pick = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    event.target.value = '';
    if (file) setImage.mutate({ target: props.target, file });
  };
  const result = setImage.data;
  return (
    <section aria-label={props.label}>
      <h3>{props.label}</h3>
      {props.imageKey ? (
        <img src={mediaUrl(props.imageKey, props.width)} alt={props.label} width={props.width} />
      ) : (
        <p>{t('images.none')}</p>
      )}
      {props.editable && (
        <label>
          {props.imageKey ? t('images.replace') : t('images.upload')}
          <input
            type="file"
            accept={IMAGE_TYPES.join(',')}
            onChange={pick}
            disabled={setImage.isPending}
          />
        </label>
      )}
      {setImage.isPending ? (
        <p role="status">{t('images.uploading')}</p>
      ) : setImage.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : result?.status === 'refused' ? (
        <p role="alert">{t(refusalKeys[result.refusal])}</p>
      ) : result?.status === 'set' ? (
        <p role="status">{t('images.set')}</p>
      ) : null}
    </section>
  );
}
