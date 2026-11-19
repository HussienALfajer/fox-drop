import { useInfiniteQuery, useQuery } from '@tanstack/react-query';
import { getRouteApi, Link, useNavigate } from '@tanstack/react-router';
import type { ChangeEvent } from 'react';
import { useTranslation } from 'react-i18next';
import { type City, chosenCity, citiesQuery } from './cities.js';
import { formatAverage, formatDateTime } from './format.js';
import { OPERATIONS_READ } from './orders-board.js';
import {
  CAPTAINS_READ,
  ratedCaptainsQuery,
  type RatingPeriod,
  ratingPeriods,
  type RatingsSearch,
  type RatingTarget,
  ratingsQuery,
} from './ratings.js';
import { can } from './session.js';

const route = getRouteApi('/signed-in/ratings');
const signedIn = getRouteApi('/signed-in');

// AP §9.7.4 «التقييمات والشكاوى», CU §12.1 (slice 2.26c; owner decision
// 2026-11-18): a captain's ratings with everything, comments included, never
// the customer's name, until the captain profile of 2.36; a restaurant's
// moved into its profile (slice 2.30d). Unstyled until the design.
export function RatingsPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const navigate = useNavigate();
  const { session } = signedIn.useRouteContext();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const readsCaptains = can(session, CAPTAINS_READ);
  const captains = useQuery({
    ...ratedCaptainsQuery(city?.id ?? ''),
    enabled: city !== undefined && readsCaptains,
  });
  const go = (next: RatingsSearch) =>
    void navigate({
      to: '/ratings',
      search: { ...(search.city ? { city: search.city } : {}), ...next },
    });
  const filters = {
    ...(search.period ? { period: search.period } : {}),
    ...(search.stars ? { stars: search.stars } : {}),
  };
  const target: RatingTarget | null = search.captain
    ? { party: 'captain', id: search.captain }
    : null;
  return (
    <main>
      <h1>{t('ratings.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('ratings.explain')}</p>
      {cities.isError || captains.isError ? (
        <p role="alert">{t('common.failed')}</p>
      ) : null}
      {readsCaptains && captains.data && (
        <label>
          {t('ratings.captain')}
          <select
            value={search.captain ?? ''}
            onChange={(event: ChangeEvent<HTMLSelectElement>) =>
              go(event.target.value ? { ...filters, captain: event.target.value } : {})
            }
          >
            <option value="">{t('ratings.chooseCaptain')}</option>
            {captains.data.map((captain) => (
              <option key={captain.id} value={captain.id}>
                {captain.average === null
                  ? t('ratings.captainUnrated', { name: captain.name })
                  : t('ratings.captainRated', {
                      name: captain.name,
                      average: formatAverage(captain.average),
                      count: captain.count,
                    })}
              </option>
            ))}
          </select>
        </label>
      )}
      {city && target && (
        <RatingsSection
          key={target.party + target.id}
          target={target}
          city={city}
          period={search.period ?? 'all'}
          stars={search.stars ?? null}
          onFilters={(next) =>
            go({
              captain: target.id,
              ...(next.period !== 'all' ? { period: next.period } : {}),
              ...(next.stars !== null ? { stars: next.stars } : {}),
            })
          }
        />
      )}
    </main>
  );
}

// The ratings of a restaurant (its profile's «التقييمات», slice 2.30d) or a
// captain, with their period and stars.
export function RatingsSection({
  target,
  city,
  period,
  stars,
  onFilters,
}: {
  target: RatingTarget;
  city: City;
  period: RatingPeriod;
  stars: number | null;
  onFilters: (filters: { period: RatingPeriod; stars: number | null }) => void;
}) {
  const { t } = useTranslation();
  const { session } = signedIn.useRouteContext();
  const ratings = useInfiniteQuery(ratingsQuery(target, { period, stars }));
  const opensOrders = can(session, OPERATIONS_READ);
  const first = ratings.data?.pages[0];
  return (
    <section aria-label={t('ratings.title')}>
      <label>
        {t('ratings.period')}
        <select
          value={period}
          onChange={(event: ChangeEvent<HTMLSelectElement>) =>
            onFilters({
              period: ratingPeriods.find((each) => each === event.target.value) ?? 'all',
              stars,
            })
          }
        >
          {ratingPeriods.map((each) => (
            <option key={each} value={each}>
              {t(`ratings.periods.${each}`)}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t('ratings.stars')}
        <select
          value={stars ?? ''}
          onChange={(event: ChangeEvent<HTMLSelectElement>) =>
            onFilters({ period, stars: event.target.value ? Number(event.target.value) : null })
          }
        >
          <option value="">{t('ratings.allStars')}</option>
          {[5, 4, 3, 2, 1].map((each) => (
            <option key={each} value={each}>
              {t('ratings.starsRow', { stars: each })}
            </option>
          ))}
        </select>
      </label>
      {ratings.isPending ? (
        <p role="status">{t('status.loading')}</p>
      ) : ratings.isError || !first ? (
        <p role="alert">{t('common.failed')}</p>
      ) : (
        <>
          <p>
            {first.average === null
              ? t('ratings.none')
              : t('ratings.average', { average: formatAverage(first.average) })}
          </p>
          <p>{t('ratings.count', { count: first.count })}</p>
          <ul aria-label={t('ratings.distribution')}>
            {first.distribution.map((each) => (
              <li key={each.stars}>
                {t('ratings.distributionRow', { stars: each.stars, count: each.count })}
              </li>
            ))}
          </ul>
          {first.ratings.length === 0 ? (
            <p>{t('ratings.empty')}</p>
          ) : (
            <ul aria-label={t('ratings.list')}>
              {ratings.data.pages
                .flatMap((page) => page.ratings)
                .map((rating) => (
                  <li key={rating.orderId}>
                    <p>
                      {t('ratings.starsRow', { stars: rating.stars })}{' '}
                      {formatDateTime(rating.at, city.timeZone)}{' '}
                      {opensOrders ? (
                        <Link
                          to="/orders/$orderId"
                          params={{ orderId: rating.orderId }}
                          search={{ city: city.code }}
                        >
                          {t('ratings.order', { number: rating.orderNumber })}
                        </Link>
                      ) : (
                        t('ratings.order', { number: rating.orderNumber })
                      )}
                    </p>
                    {rating.reasons.length > 0 && (
                      <p>
                        {t('ratings.reasons', {
                          reasons: rating.reasons
                            .map((reason) => reason.label)
                            .join(t('ratings.reasonSeparator')),
                        })}
                      </p>
                    )}
                    {rating.comment !== null && (
                      <p>{t('ratings.comment', { comment: rating.comment })}</p>
                    )}
                  </li>
                ))}
            </ul>
          )}
          {ratings.hasNextPage && (
            <button
              type="button"
              disabled={ratings.isFetchingNextPage}
              onClick={() => void ratings.fetchNextPage()}
            >
              {t('ratings.more')}
            </button>
          )}
        </>
      )}
    </section>
  );
}
