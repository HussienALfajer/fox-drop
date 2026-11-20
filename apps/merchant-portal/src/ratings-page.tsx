import { useInfiniteQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import type { PeriodChoice } from './period.js';
import { PeriodPicker } from './period-picker.js';
import { RATING_PERIODS, type RatingPeriod, ratingsQuery } from './ratings.js';

// RA §13, §17 (slice 2.45d): «التقييمات»: the average, the count and the
// distribution of the period, then each rating with its stars, reasons,
// comment and day, never the customer or the order. No replies (R16).
export function RatingsPage() {
  const { t } = useTranslation();
  const [choice, setChoice] = useState<PeriodChoice<RatingPeriod>>({
    kind: 'period',
    period: 'all',
  });
  const [stars, setStars] = useState<number | null>(null);
  const read = useInfiniteQuery(ratingsQuery(choice, stars));
  const first = read.data?.pages[0];

  return (
    <main>
      <h1>{t('ratings.title')}</h1>
      <PeriodPicker<RatingPeriod> periods={RATING_PERIODS} value={choice} onChange={setChoice} />
      <label>
        {t('ratings.stars')}{' '}
        <select
          value={stars ?? ''}
          onChange={(e) => setStars(e.target.value === '' ? null : Number(e.target.value))}
        >
          <option value="">{t('ratings.allStars')}</option>
          {[5, 4, 3, 2, 1].map((each) => (
            <option key={each} value={each}>
              {t('ratings.starsRow', { stars: each })}
            </option>
          ))}
        </select>
      </label>
      {read.isPending ? (
        <p>{t('app.loading')}</p>
      ) : read.isError && !read.data ? (
        <p role="alert">{t('app.error')}</p>
      ) : first?.status !== 'ok' ? (
        <p role="alert">
          {t(`ratings.refusal.${first?.status === 'refused' ? first.refusal : 'other'}`)}
        </p>
      ) : (
        <>
          <p>
            {first.page.average === null
              ? t('ratings.none')
              : t('ratings.average', { average: first.page.average })}{' '}
            {t('ratings.count', { count: first.page.count })}
          </p>
          <ul>
            {first.page.distribution.map((each) => (
              <li key={each.stars}>
                {t('ratings.distributionRow', { stars: each.stars, count: each.count })}
              </li>
            ))}
          </ul>
          {first.page.ratings.length === 0 && <p>{t('ratings.empty')}</p>}
          <ul>
            {read.data.pages
              .flatMap((page) => (page.status === 'ok' ? page.page.ratings : []))
              .map((rating, index) => (
                <li key={index}>
                  {[
                    t('ratings.starsRow', { stars: rating.stars }),
                    rating.day,
                    ...(rating.reasons.length > 0
                      ? [
                          rating.reasons
                            .map((reason) => reason.label)
                            .join(t('ratings.reasonSeparator')),
                        ]
                      : []),
                  ].join(t('app.separator'))}
                  {rating.comment !== null && <p>{rating.comment}</p>}
                </li>
              ))}
          </ul>
          {read.hasNextPage && (
            <button
              type="button"
              disabled={read.isFetchingNextPage}
              onClick={() => void read.fetchNextPage()}
            >
              {t('ratings.more')}
            </button>
          )}
          {read.isFetchNextPageError && <p role="alert">{t('ratings.moreFailed')}</p>}
        </>
      )}
    </main>
  );
}
