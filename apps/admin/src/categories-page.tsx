import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import { type ChangeEvent, type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  type Category,
  type CategoryRefusal,
  type CategoryResult,
  canEditCategories,
  canSetRestaurantCategories,
  categoriesQuery,
  chosenCategories,
  RESTAURANT_CATEGORIES_MAX,
  restaurantCategoriesQuery,
  useAddCategory,
  useReorderCategories,
  useSetRestaurantCategories,
  useUpdateCategory,
} from './categories.js';
import { chosenCity, citiesQuery } from './cities.js';
import { moved } from './content.js';
import { mediaUrl } from './media.js';
import {
  IMAGE_TYPES,
  type ImageRefusal,
  restaurantsQuery,
  useSetImage,
} from './restaurant-images.js';

const signedIn = getRouteApi('/signed-in');
const restaurantRoute = getRouteApi('/signed-in/restaurant-categories');

const refusalKeys = {
  duplicate_label: 'categories.refused.duplicate',
  invalid_order: 'categories.refused.order',
  invalid_value: 'categories.refused.value',
  unknown_category: 'categories.refused.unknown',
} as const satisfies Record<CategoryRefusal, string>;

const imageRefusalKeys = {
  type: 'images.refused.type',
  size: 'images.refused.size',
  not_image: 'images.refused.notImage',
  upload_failed: 'images.refused.uploadFailed',
} as const satisfies Record<ImageRefusal, string>;

function Outcome({ result, failed }: { result: CategoryResult | undefined; failed: boolean }) {
  const { t } = useTranslation();
  if (failed) return <p role="alert">{t('common.failed')}</p>;
  if (!result) return null;
  if (result.status === 'saved') return <p role="status">{t('categories.saved')}</p>;
  return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
}

// AP §9.13 «التصنيفات» (slice 2.27a): the platform's restaurant categories
// in their order, with a name and an icon or image; OWN and DATA add,
// rename, reorder, remove and bring back (content.categories), OPS reads.
// Unstyled until the design.
export function CategoriesPage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const edit = canEditCategories(session);
  const categories = useQuery(categoriesQuery);
  const reorder = useReorderCategories();
  const ids = categories.data?.map((category) => category.id) ?? [];
  return (
    <main>
      <h1>{t('categories.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('categories.explain')}</p>
      {categories.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !categories.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <>
          {categories.data.length === 0 && <p>{t('categories.empty')}</p>}
          <ul>
            {categories.data.map((category, index) => (
              <li key={category.id}>
                <CategoryRow category={category} edit={edit} />
                {edit && (
                  <>
                    <button
                      type="button"
                      disabled={reorder.isPending || index === 0}
                      onClick={() => reorder.mutate(moved(ids, category.id, -1))}
                    >
                      {t('content.up')}
                    </button>
                    <button
                      type="button"
                      disabled={reorder.isPending || index === ids.length - 1}
                      onClick={() => reorder.mutate(moved(ids, category.id, 1))}
                    >
                      {t('content.down')}
                    </button>
                  </>
                )}
              </li>
            ))}
          </ul>
          <Outcome result={reorder.data} failed={reorder.isError} />
          {edit && <AddCategory />}
        </>
      )}
    </main>
  );
}

function CategoryRow({ category, edit }: { category: Category; edit: boolean }) {
  const { t } = useTranslation();
  const [name, setName] = useState(category.name);
  const update = useUpdateCategory();
  const setImage = useSetImage();
  const save = (event: FormEvent) => {
    event.preventDefault();
    update.mutate({ categoryId: category.id, name, active: category.active });
  };
  const pick = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    event.target.value = '';
    if (file) setImage.mutate({ target: { kind: 'category', categoryId: category.id }, file });
  };
  const image = setImage.data;
  return (
    <section aria-label={category.name}>
      {category.imageKey ? (
        <img src={mediaUrl(category.imageKey, 160)} alt={category.name} width={160} />
      ) : (
        <p>{t('images.none')}</p>
      )}
      {edit ? (
        <form onSubmit={save}>
          <label>
            {t('categories.name')}
            <input
              value={name}
              maxLength={40}
              required
              onChange={(event) => setName(event.target.value)}
            />
          </label>
          <button type="submit" disabled={update.isPending}>
            {t('content.save')}
          </button>
        </form>
      ) : (
        <h2>{category.name}</h2>
      )}
      {!category.active && <p>{t('categories.removed')}</p>}
      {edit && (
        <>
          <button
            type="button"
            disabled={update.isPending}
            onClick={() =>
              update.mutate({
                categoryId: category.id,
                name: category.name,
                active: !category.active,
              })
            }
          >
            {category.active ? t('categories.remove') : t('categories.restore')}
          </button>
          <label>
            {category.imageKey ? t('images.replace') : t('images.upload')}
            <input
              type="file"
              accept={IMAGE_TYPES.join(',')}
              onChange={pick}
              disabled={setImage.isPending}
            />
          </label>
        </>
      )}
      <Outcome result={update.data} failed={update.isError} />
      {setImage.isPending ? (
        <p role="status">{t('images.uploading')}</p>
      ) : setImage.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : image?.status === 'refused' ? (
        <p role="alert">{t(imageRefusalKeys[image.refusal])}</p>
      ) : image?.status === 'set' ? (
        <p role="status">{t('images.set')}</p>
      ) : null}
    </section>
  );
}

function AddCategory() {
  const { t } = useTranslation();
  const [name, setName] = useState('');
  const add = useAddCategory();
  const submit = (event: FormEvent) => {
    event.preventDefault();
    add.mutate(name, {
      onSuccess: (result) => {
        if (result.status === 'saved') setName('');
      },
    });
  };
  return (
    <form onSubmit={submit}>
      <h2>{t('categories.add')}</h2>
      <label>
        {t('categories.name')}
        <input
          value={name}
          maxLength={40}
          required
          onChange={(event) => setName(event.target.value)}
        />
      </label>
      <button type="submit" disabled={add.isPending}>
        {t('categories.add')}
      </button>
      <Outcome result={add.data} failed={add.isError} />
    </form>
  );
}

// AP §9.6.3 step 1 (slice 2.27a, until the restaurant profile of 2.30): pick
// a restaurant of the city and tick its categories, up to
// RESTAURANT_CATEGORIES_MAX, in the platform's order. Unstyled until the
// design.
export function RestaurantCategoriesPage() {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const search = restaurantRoute.useSearch();
  const navigate = useNavigate();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const restaurants = useQuery({
    ...restaurantsQuery(city?.id ?? ''),
    enabled: city !== undefined,
  });
  const choose = (event: ChangeEvent<HTMLSelectElement>) =>
    void navigate({
      to: '/restaurant-categories',
      search: {
        ...(search.city ? { city: search.city } : {}),
        ...(event.target.value ? { restaurant: event.target.value } : {}),
      },
    });
  return (
    <main>
      <h1>{t('restaurantCategories.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('restaurantCategories.explain', { max: RESTAURANT_CATEGORIES_MAX })}</p>
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
        <RestaurantCategories
          key={search.restaurant}
          restaurantId={search.restaurant}
          edit={canSetRestaurantCategories(session)}
        />
      )}
    </main>
  );
}

function RestaurantCategories({ restaurantId, edit }: { restaurantId: string; edit: boolean }) {
  const { t } = useTranslation();
  const categories = useQuery(categoriesQuery);
  const chosen = useQuery(restaurantCategoriesQuery(restaurantId));
  const set = useSetRestaurantCategories(restaurantId);
  if (categories.isPending || chosen.isPending) return <p role="status">{t('status.loading')}</p>;
  if (categories.isError || chosen.isError) return <p role="alert">{t('common.failed')}</p>;
  const ticked = new Set(chosen.data);
  const full = chosen.data.length >= RESTAURANT_CATEGORIES_MAX;
  const shown = categories.data.filter((category) => category.active || ticked.has(category.id));
  return (
    <fieldset>
      <legend>{t('restaurantCategories.choose')}</legend>
      {shown.length === 0 && <p>{t('categories.empty')}</p>}
      {shown.map((category) => (
        <label key={category.id}>
          <input
            type="checkbox"
            checked={ticked.has(category.id)}
            disabled={
              !edit || set.isPending || (!ticked.has(category.id) && (full || !category.active))
            }
            onChange={(event) =>
              set.mutate(
                chosenCategories(categories.data, chosen.data, category.id, event.target.checked),
              )
            }
          />
          {category.name}
          {!category.active && <span> {t('categories.removed')}</span>}
        </label>
      ))}
      <Outcome result={set.data} failed={set.isError} />
    </fieldset>
  );
}
