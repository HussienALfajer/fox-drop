import { formTv } from '../field/styles';

/** The states the stories show (R3). */
export const STATES = [
  'default',
  'fraction',
  'large',
  'negative',
  'gain',
  'total',
  'compact',
] as const;

const MINUS = '−';

/**
 * An amount in minor units as text (AP §4.7; owner, 2026-11-24): Western
 * digits, a Western comma between thousands, a whole amount drops its
 * fraction and any other shows every minor digit; the minus is U+2212, and
 * `signed` puts a plus on a gain. The value never passes through a float.
 */
export function formatAmount(
  minor: string | bigint,
  decimals: number,
  options: { signed?: boolean | undefined } = {},
): string {
  const text = typeof minor === 'bigint' ? minor.toString() : minor;
  if (!/^-?\d+$/.test(text)) throw new Error(`Not an integer of minor units: ${text}`);
  const negative = text.startsWith('-');
  const digits = (negative ? text.slice(1) : text).replace(/^0+(?=\d)/, '');
  const padded = digits.padStart(decimals + 1, '0');
  const whole = padded.slice(0, padded.length - decimals);
  const fraction = padded.slice(padded.length - decimals);
  const grouped = whole.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  const amount = /^0*$/.test(fraction) ? grouped : `${grouped}.${fraction}`;
  const zero = /^0+$/.test(digits);
  const sign = zero ? '' : negative ? MINUS : options.signed ? '+' : '';
  return `${sign}${amount}`;
}

// The amount and its symbol are one right-to-left isolate, so in Arabic the
// symbol sits to the amount's left (as the Figma file draws it) and no
// neighbouring Latin run or sign moves it (R5). The ₺ comes from Fox Lira,
// the fallback of the sans family.
const run = formTv({
  base: 'whitespace-nowrap tabular-nums',
  variants: {
    size: {
      secondary: 'text-phone-secondary',
      body: 'text-phone-body',
      subtitle: 'text-phone-subtitle font-bold',
      number: 'text-phone-number font-bold',
      compact: 'text-panel-body',
    },
    tone: {
      default: 'text-(color:--fd-money-color-default)',
      success: 'text-(color:--fd-money-color-success)',
      danger: 'text-(color:--fd-money-color-danger)',
      muted: 'text-(color:--fd-money-color-muted)',
      inverse: 'text-(color:--fd-money-color-inverse)',
    },
    bold: { true: 'font-bold' },
  },
  defaultVariants: { size: 'body', tone: 'default' },
});

export interface MoneyProps {
  /** The amount in minor units, as the API sends it: «41000» TRY is «410 ₺». */
  amount: string | bigint;
  /** The currency's symbol from its data row: «₺», «$», «ل.س». */
  symbol: string;
  /** The currency's minor digits. Default 2. */
  decimals?: number | undefined;
  /** A plus on a gain (the panel's dashboard). */
  signed?: boolean | undefined;
  size?: 'secondary' | 'body' | 'subtitle' | 'number' | 'compact' | undefined;
  tone?: 'default' | 'success' | 'danger' | 'muted' | 'inverse' | undefined;
  bold?: boolean | undefined;
}

/** An amount and its currency symbol, as every app shows money. */
export function Money({ amount, symbol, decimals = 2, signed, size, tone, bold }: MoneyProps) {
  const text = `${formatAmount(amount, decimals, { signed })} ${symbol}`;
  return (
    <bdi dir="rtl" className={run({ size, tone, bold })}>
      {text}
    </bdi>
  );
}
