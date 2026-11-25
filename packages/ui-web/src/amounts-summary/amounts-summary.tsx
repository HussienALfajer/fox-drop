import { formTv } from '../field/styles';
import { Money } from '../money/money';

/** The states the stories show (R3). */
export const STATES = ['default', 'prominent', 'free', 'compact'] as const;

export interface AmountLine {
  label: string;
  /** Minor units: «-2500» is «−25 ₺». */
  amount: string;
  /** Words instead of the amount: «مجاني» for a zero fee. */
  text?: string;
  tone?: 'default' | 'success' | 'danger';
}

// The approved sheet (owner, 2026-11-24): `prominent` puts the total on the
// orange bar of the Figma cart (the customer's cart and checkout), `plain`
// writes it bold under a rule (the panel, the portal, the order detail).
// The lines are parted by the dashed rules of the Figma cart.
const lineRow = formTv({
  base: 'flex items-center justify-between gap-sm border-b border-dashed border-border py-xs last:border-b-0',
  variants: { compact: { true: 'text-panel-body', false: 'text-phone-body' } },
});

const totalRow = formTv({
  base: 'flex items-center justify-between gap-sm',
  variants: {
    variant: {
      plain: 'border-t-(length:--fd-border-width-thick) border-on-surface pt-sm',
      prominent: 'rounded-lg bg-primary px-lg py-sm text-on-primary',
    },
  },
});

export interface AmountsSummaryProps {
  lines: AmountLine[];
  total: { label: string; amount: string };
  /** The base currency's symbol and minor digits. */
  symbol: string;
  decimals?: number | undefined;
  /** One equivalent per accepted currency under the total (CU §10.3): «أو 11.50 $ · …». */
  equivalents?: string | undefined;
  variant?: 'plain' | 'prominent';
  density?: 'comfortable' | 'compact';
}

/** The money lines of an order and its total (CU §10.3 step 7, §12.3). */
export function AmountsSummary(props: AmountsSummaryProps) {
  const { lines, total, symbol, decimals, equivalents, variant = 'plain', density } = props;
  const compact = density === 'compact';
  const item = lineRow({ compact });
  return (
    <div className="flex flex-col gap-sm text-on-surface">
      <ul className="m-none flex list-none flex-col p-none">
        {lines.map((line) => (
          <li key={line.label} className={item}>
            <span>{line.label}</span>
            {line.text ? (
              <span className="font-medium text-success">{line.text}</span>
            ) : (
              <Money
                amount={line.amount}
                symbol={symbol}
                decimals={decimals}
                tone={line.tone}
                size={compact ? 'compact' : 'body'}
              />
            )}
          </li>
        ))}
      </ul>
      <div data-total="" className={totalRow({ variant })}>
        <span className="text-phone-subtitle font-bold">{total.label}</span>
        <Money
          amount={total.amount}
          symbol={symbol}
          decimals={decimals}
          size={variant === 'prominent' ? 'subtitle' : 'number'}
          tone={variant === 'prominent' ? 'inverse' : 'default'}
        />
      </div>
      {equivalents ? (
        <p className="m-none text-phone-secondary text-on-surface-muted">{equivalents}</p>
      ) : null}
    </div>
  );
}
