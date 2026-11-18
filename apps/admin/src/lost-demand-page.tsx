import { useQuery } from '@tanstack/react-query';
import { getRouteApi, Link } from '@tanstack/react-router';
import { useTranslation } from 'react-i18next';
import { chosenCity, citiesQuery } from './cities.js';
import { formatDateTime } from './format.js';
import { lostDemandQuery } from './lost-demand.js';

const route = getRouteApi('/signed-in/lost-demand');

// AP §9.17 «الطلب الضائع» (slice 2.28a, owner decision 2026-11-18): the
// searches that found nothing and the restaurants customers asked for in
// the last 30 days (CU §8.3). The export and the other lost demand come with
// the reports (2.41). Unstyled until the design.
export function LostDemandPage() {
  const { t } = useTranslation();
  const search = route.useSearch();
  const cities = useQuery(citiesQuery);
  const city = cities.data ? chosenCity(cities.data, search.city) : undefined;
  const report = useQuery({ ...lostDemandQuery(city?.id ?? ''), enabled: city !== undefined });
  return (
    <main>
      <h1>{t('lostDemand.title')}</h1>
      <p>
        <Link to="/">{t('common.home')}</Link>
      </p>
      <p>{t('lostDemand.explain')}</p>
      {cities.isError || report.isError ? <p role="alert">{t('common.failed')}</p> : null}
      {city && report.data && (
        <>
          <section aria-labelledby="lost-demand-searches">
            <h2 id="lost-demand-searches">{t('lostDemand.searches')}</h2>
            {report.data.searches.length === 0 ? (
              <p>{t('lostDemand.noSearches')}</p>
            ) : (
              <table>
                <thead>
                  <tr>
                    <th>{t('lostDemand.query')}</th>
                    <th>{t('lostDemand.count')}</th>
                    <th>{t('lostDemand.lastAt')}</th>
                  </tr>
                </thead>
                <tbody>
                  {report.data.searches.map((row) => (
                    <tr key={row.query}>
                      <td>{row.query}</td>
                      <td>{row.count}</td>
                      <td>{formatDateTime(row.lastAt, city.timeZone)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </section>
          <section aria-labelledby="lost-demand-suggestions">
            <h2 id="lost-demand-suggestions">{t('lostDemand.suggestions')}</h2>
            {report.data.suggestions.length === 0 ? (
              <p>{t('lostDemand.noSuggestions')}</p>
            ) : (
              <table>
                <thead>
                  <tr>
                    <th>{t('lostDemand.restaurantName')}</th>
                    <th>{t('lostDemand.note')}</th>
                    <th>{t('lostDemand.followed')}</th>
                    <th>{t('lostDemand.at')}</th>
                  </tr>
                </thead>
                <tbody>
                  {report.data.suggestions.map((row) => (
                    <tr key={row.id}>
                      <td>{row.restaurantName}</td>
                      <td>{row.note ?? '—'}</td>
                      <td>{row.query ?? '—'}</td>
                      <td>{formatDateTime(row.at, city.timeZone)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </section>
        </>
      )}
    </main>
  );
}
