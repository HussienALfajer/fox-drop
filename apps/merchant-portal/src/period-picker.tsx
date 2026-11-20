import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { type PeriodChoice, rangeProblem } from './period.js';

// The periods as buttons, then «فترة مخصّصة» with two days (RA §17): the
// range is asked only once both days make one.
export function PeriodPicker<P extends string>({
  periods,
  value,
  onChange,
}: {
  periods: readonly P[];
  value: PeriodChoice<P>;
  onChange: (choice: PeriodChoice<P>) => void;
}) {
  const { t } = useTranslation();
  const [from, setFrom] = useState(value.kind === 'range' ? value.from : '');
  const [to, setTo] = useState(value.kind === 'range' ? value.to : '');
  const [problem, setProblem] = useState<ReturnType<typeof rangeProblem>>(null);
  return (
    <fieldset data-print="hide">
      <legend>{t('period.title')}</legend>
      {periods.map((period) => (
        <button
          key={period}
          type="button"
          aria-pressed={value.kind === 'period' && value.period === period}
          onClick={() => onChange({ kind: 'period', period })}
        >
          {t(`period.${period as 'today'}`)}
        </button>
      ))}{' '}
      <label>
        {t('period.from')}{' '}
        <input type="date" value={from} onChange={(e) => setFrom(e.target.value)} />
      </label>{' '}
      <label>
        {t('period.to')} <input type="date" value={to} onChange={(e) => setTo(e.target.value)} />
      </label>{' '}
      <button
        type="button"
        aria-pressed={value.kind === 'range'}
        onClick={() => {
          const found = rangeProblem(from, to);
          setProblem(found);
          if (found === null) onChange({ kind: 'range', from, to });
        }}
      >
        {t('period.custom')}
      </button>
      {problem !== null && <span role="alert">{t(`period.problem.${problem}`)}</span>}
    </fieldset>
  );
}
