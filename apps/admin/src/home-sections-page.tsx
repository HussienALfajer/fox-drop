import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { type FormEvent, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import {
  type CustomSectionForm,
  customSectionProblem,
  type HomeSection,
  type HomeSectionKind,
  type HomeSectionRefusal,
  type HomeSectionResult,
  type HomeSections,
  homeSectionsQuery,
  movedKey,
  pickedRestaurants,
  SECTION_RESTAURANTS_MAX,
  SECTION_TITLE_MAX,
  useAddCustomSection,
  useRemoveCustomSection,
  useReorderSections,
  useSetSectionVisible,
  useUpdateCustomSection,
} from './home-sections.js';

const route = getRouteApi('/signed-in/home-sections');

const kindKeys = {
  banners: 'homeSections.kind.banners',
  categories: 'homeSections.kind.categories',
  nearest: 'homeSections.kind.nearest',
  most_ordered: 'homeSections.kind.most_ordered',
  new: 'homeSections.kind.new',
  offers: 'homeSections.kind.offers',
  custom: 'homeSections.kind.custom',
} as const satisfies Record<HomeSectionKind, string>;

const explainKeys = {
  banners: 'homeSections.explain.banners',
  categories: 'homeSections.explain.categories',
  nearest: 'homeSections.explain.nearest',
  most_ordered: 'homeSections.explain.most_ordered',
  new: 'homeSections.explain.new',
  offers: 'homeSections.explain.offers',
  custom: 'homeSections.explain.custom',
} as const satisfies Record<HomeSectionKind, string>;

const refusalKeys = {
  invalid_section: 'homeSections.refused.invalid',
  sections_changed: 'homeSections.refused.changed',
  unknown_section: 'homeSections.refused.unknown',
} as const satisfies Record<HomeSectionRefusal, string>;

// AP §9.11.3 «أقسام الرئيسية» (slice 2.27b): the customer home's sections in
// their order, shown or hidden, and the custom sections. Unstyled until the
// design; up and down stand for the drag until then.
export function HomeSectionsPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const sections = useQuery({ ...homeSectionsQuery(city?.id ?? ''), enabled: city !== undefined });
  return (
    <main>
      <h1>{t('homeSections.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('homeSections.intro')}</p>
      {sections.isError || cities.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : !city || !sections.data ? (
        <p role="status">{t('status.loading')}</p>
      ) : (
        <SectionsView sections={sections.data} city={city} />
      )}
    </main>
  );
}

function SectionsView({ sections, city }: { sections: HomeSections; city: City }) {
  const { t } = useTranslation();
  const sectionName = useSectionName();
  const reorder = useReorderSections(city.id);
  const setVisible = useSetSectionVisible(city.id);
  const keys = sections.sections.map((section) => section.key);
  const edit = sections.canManage;
  const names = new Map(sections.restaurants.map((each) => [each.id, each.name]));
  return (
    <>
      <ol>
        {sections.sections.map((section, index) => (
          <li key={section.key}>
            <section aria-label={sectionName(section)}>
              <h2>{sectionName(section)}</h2>
              <p>{t(explainKeys[section.kind])}</p>
              <p>{section.visible ? t('homeSections.shown') : t('homeSections.hidden')}</p>
              {section.kind === 'custom' && !edit && (
                <p>
                  {section.restaurantIds
                    .map((id) => names.get(id) ?? id)
                    .join(t('homeSections.separator'))}
                </p>
              )}
              {edit && (
                <>
                  <button
                    type="button"
                    disabled={reorder.isPending || index === 0}
                    onClick={() => reorder.mutate(movedKey(keys, section.key, -1))}
                  >
                    {t('homeSections.moveUp')}
                  </button>
                  <button
                    type="button"
                    disabled={reorder.isPending || index === keys.length - 1}
                    onClick={() => reorder.mutate(movedKey(keys, section.key, 1))}
                  >
                    {t('homeSections.moveDown')}
                  </button>
                  <button
                    type="button"
                    disabled={setVisible.isPending}
                    onClick={() =>
                      setVisible.mutate({ key: section.key, visible: !section.visible })
                    }
                  >
                    {section.visible ? t('homeSections.hide') : t('homeSections.show')}
                  </button>
                </>
              )}
              {edit && section.kind === 'custom' && (
                <CustomSectionEditor
                  key={[section.key, section.title, ...section.restaurantIds].join('|')}
                  city={city}
                  section={section}
                  restaurants={sections.restaurants}
                />
              )}
            </section>
          </li>
        ))}
      </ol>
      <Outcome
        result={reorder.data ?? setVisible.data}
        failed={reorder.isError || setVisible.isError}
      />
      {edit && <AddCustomSection city={city} restaurants={sections.restaurants} />}
    </>
  );
}

function useSectionName(): (section: HomeSection) => string {
  const { t } = useTranslation();
  return (section) =>
    section.kind === 'custom' && section.title !== null ? section.title : t(kindKeys[section.kind]);
}

type Restaurant = HomeSections['restaurants'][number];

function CustomSectionEditor({
  city,
  section,
  restaurants,
}: {
  city: City;
  section: HomeSection;
  restaurants: Restaurant[];
}) {
  const { t } = useTranslation();
  const update = useUpdateCustomSection(city.id);
  const remove = useRemoveCustomSection(city.id);
  return (
    <>
      <SectionForm
        initial={{ title: section.title ?? '', restaurantIds: section.restaurantIds }}
        restaurants={restaurants}
        submitLabel={t('homeSections.save')}
        pending={update.isPending}
        onSubmit={(form) => update.mutate({ ...form, sectionId: section.key })}
      />
      <button type="button" disabled={remove.isPending} onClick={() => remove.mutate(section.key)}>
        {t('homeSections.remove')}
      </button>
      <Outcome result={update.data ?? remove.data} failed={update.isError || remove.isError} />
    </>
  );
}

function AddCustomSection({ city, restaurants }: { city: City; restaurants: Restaurant[] }) {
  const { t } = useTranslation();
  const add = useAddCustomSection(city.id);
  // A new form after each section added.
  const [round, setRound] = useState(0);
  return (
    <section aria-label={t('homeSections.add')}>
      <h2>{t('homeSections.add')}</h2>
      <SectionForm
        key={round}
        initial={{ title: '', restaurantIds: [] }}
        restaurants={restaurants}
        submitLabel={t('homeSections.add')}
        pending={add.isPending}
        onSubmit={(form) =>
          add.mutate(form, {
            onSuccess: (result) => {
              if (result.status === 'saved') setRound((value) => value + 1);
            },
          })
        }
      />
      <Outcome result={add.data} failed={add.isError} />
    </section>
  );
}

function SectionForm({
  initial,
  restaurants,
  submitLabel,
  pending,
  onSubmit,
}: {
  initial: CustomSectionForm;
  restaurants: Restaurant[];
  submitLabel: string;
  pending: boolean;
  onSubmit: (form: CustomSectionForm) => void;
}) {
  const { t } = useTranslation();
  const [form, setForm] = useState(initial);
  const problem = customSectionProblem(form);
  const names = new Map(restaurants.map((each) => [each.id, each.name]));
  const submit = (event: FormEvent) => {
    event.preventDefault();
    if (problem === null) onSubmit(form);
  };
  return (
    <form onSubmit={submit}>
      <label>
        {t('homeSections.sectionTitle')}
        <input
          value={form.title}
          maxLength={SECTION_TITLE_MAX}
          required
          onChange={(event) => setForm({ ...form, title: event.target.value })}
        />
      </label>
      <fieldset>
        <legend>{t('homeSections.restaurants', { max: SECTION_RESTAURANTS_MAX })}</legend>
        {restaurants.map((restaurant) => (
          <label key={restaurant.id}>
            <input
              type="checkbox"
              checked={form.restaurantIds.includes(restaurant.id)}
              onChange={(event) =>
                setForm({
                  ...form,
                  restaurantIds: pickedRestaurants(
                    form.restaurantIds,
                    restaurant.id,
                    event.target.checked,
                  ),
                })
              }
            />
            {restaurant.name}
          </label>
        ))}
      </fieldset>
      {form.restaurantIds.length > 0 && (
        <>
          <p>{t('homeSections.picked')}</p>
          <ol>
            {form.restaurantIds.map((id, index) => (
              <li key={id}>
                {names.get(id) ?? id}
                <button
                  type="button"
                  disabled={index === 0}
                  onClick={() =>
                    setForm({ ...form, restaurantIds: movedKey(form.restaurantIds, id, -1) })
                  }
                >
                  {t('content.up')}
                </button>
                <button
                  type="button"
                  disabled={index === form.restaurantIds.length - 1}
                  onClick={() =>
                    setForm({ ...form, restaurantIds: movedKey(form.restaurantIds, id, 1) })
                  }
                >
                  {t('content.down')}
                </button>
              </li>
            ))}
          </ol>
        </>
      )}
      {problem !== null && (
        <p>
          {problem === 'title'
            ? t('homeSections.problem.title', { max: SECTION_TITLE_MAX })
            : t('homeSections.problem.restaurants', { max: SECTION_RESTAURANTS_MAX })}
        </p>
      )}
      <button type="submit" disabled={pending || problem !== null}>
        {submitLabel}
      </button>
    </form>
  );
}

function Outcome({ result, failed }: { result: HomeSectionResult | undefined; failed: boolean }) {
  const { t } = useTranslation();
  if (failed) return <p role="alert">{t('common.failed')}</p>;
  if (result?.status === 'refused') return <p role="alert">{t(refusalKeys[result.refusal])}</p>;
  if (result?.status === 'saved') return <p role="status">{t('homeSections.saved')}</p>;
  return null;
}
